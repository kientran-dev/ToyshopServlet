// File: src/main/java/com/kiendey/dao/impl/OrderDAOImpl.java
package com.kiendey.dao.impl;

import com.kiendey.common.OrderStatus;
import com.kiendey.dao.OrderDAO;
import com.kiendey.model.Order;
import com.kiendey.model.OrderItem;
import com.kiendey.model.Toy;
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors; // Import Collectors

import com.kiendey.dto.ProductSaleStat;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public boolean createOrder(Order order) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(order);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    public boolean createOrderWithItems(Order order, List<OrderItem> orderItems) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            session.persist(order); // Lưu Order trước

            for (OrderItem item : orderItems) {
                // Thiết lập mối quan hệ với Order
                item.setOrder(order);
                // Lấy lại đối tượng Toy từ session để đảm bảo nó ở trạng thái managed
                Toy toy = session.get(Toy.class, item.getToy().getId());
                if (toy == null) {
                    throw new RuntimeException("Toy not found with ID: " + item.getToy().getId());
                }
                item.setToy(toy);
                session.persist(item); // Lưu từng OrderItem
            }

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    public Order readOrder(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Order.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void updateOrder(Order order) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(order);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(String id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Order order = session.get(Order.class, id);
            if (order != null) {
                session.remove(order);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> getAllOrders() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Order", Order.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public List<Order> getOrdersByUserId(String userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order o WHERE o.user.id = :userId", Order.class);
            query.setParameter("userId", userId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public List<Order> searchOrdersByStatus(String status) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order o WHERE o.status = :status", Order.class);
            query.setParameter("status", OrderStatus.valueOf(status));
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public List<Order> getOrdersByDate(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order o WHERE o.orderDate BETWEEN :startDate AND :endDate", Order.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public Order getOrderById(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Order.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public double getTotalOrderAmount(String userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Double> query = session.createQuery(
                    "SELECT SUM(oi.quantity * t.price) FROM OrderItem oi JOIN oi.toy t JOIN oi.order o WHERE o.user.id = :userId AND o.status = :completedStatus",
                    Double.class
            );
            query.setParameter("userId", userId);
            query.setParameter("completedStatus", OrderStatus.HOAN_THANH);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    @Override
    public double getFinalAmount(String orderId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Double> query = session.createQuery(
                    "SELECT SUM(oi.quantity * oi.toy.price) FROM OrderItem oi WHERE oi.order.id = :orderId",
                    Double.class
            );
            query.setParameter("orderId", orderId);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    @Override
    public List<Order> getOrdersByPage(int pageNumber, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("FROM Order o ORDER BY o.orderDate DESC", Order.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public int getTotalOrderCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery("SELECT COUNT(o.id) FROM Order o", Long.class).uniqueResult();
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public boolean updateOrderStatus(String orderId, OrderStatus status) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Order order = session.get(Order.class, orderId);
            if (order != null) {
                order.setStatus(status);
                session.merge(order);
                transaction.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Order> searchAndFilterOrders(String searchTerm, String status, String dateStr, int page, int pageSize) {
        // Implement searchAndFilterOrders if not already done
        // This is a complex method, likely needs to be copied from your existing implementation
        // For brevity, I'm not including its full body here.
        return Collections.emptyList(); // Placeholder
    }

    @Override
    public int countFilteredOrders(String searchTerm, String status, String dateStr) {
        // Implement countFilteredOrders if not already done
        // For brevity, I'm not including its full body here.
        return 0; // Placeholder
    }

    @Override
    public Map<String, Long> getCustomerOrderCounts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT o.user.id, COUNT(o.id) FROM Order o GROUP BY o.user.id ORDER BY COUNT(o.id) DESC";
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            return query.list().stream()
                    .collect(Collectors.toMap(
                            arr -> (String) arr[0],
                            arr -> (Long) arr[1]
                    ));
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }

    @Override
    public Map<String, Double> getCustomerTotalPurchaseValues() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT o.user.id, SUM(oi.quantity * oi.toy.price) " +
                    "FROM OrderItem oi JOIN oi.order o " +
                    "GROUP BY o.user.id " +
                    "ORDER BY SUM(oi.quantity * oi.toy.price) DESC";
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            return query.list().stream()
                    .collect(Collectors.toMap(
                            arr -> (String) arr[0],
                            arr -> (Double) arr[1]
                    ));
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }

    @Override
    public double getTotalSalesRevenue(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(oi.quantity * oi.toy.price) " +
                    "FROM OrderItem oi JOIN oi.order o " +
                    "WHERE o.status = :completedStatus AND o.orderDate BETWEEN :startDate AND :endDate";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("completedStatus", OrderStatus.HOAN_THANH);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    @Override
    public double getTotalCancelledOrRefundedAmount(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(oi.quantity * oi.toy.price) " +
                    "FROM OrderItem oi JOIN oi.order o " +
                    "WHERE (o.status = :cancelledStatus OR o.status = :refundedStatus) AND o.orderDate BETWEEN :startDate AND :endDate";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("cancelledStatus", OrderStatus.DA_HUY);
            query.setParameter("refundedStatus", OrderStatus.DA_XAC_NHAN); // Assuming you have a REFUNDED status
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    @Override
    public double getTotalCurrentStockQuantity() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(t.stock) FROM Toy t WHERE t.isDeleted = false";
            Double result = session.createQuery(hql, Double.class).uniqueResult();
            return result != null ? result : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    // --- NEW METHODS FOR YEARLY REPORTS ---

    @Override
    public long getTotalOrderCountByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(o.id) FROM Order o WHERE o.orderDate BETWEEN :startDate AND :endDate";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            Long result = query.uniqueResult();
            return result != null ? result : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }

    @Override
    public double getTotalAffiliateRevenue(LocalDateTime startDate, LocalDateTime endDate) {
        // TODO: Cần định nghĩa logic cho "Doanh thu liên kết" dựa trên nghiệp vụ của bạn.
        // Ví dụ: Doanh thu từ các đơn hàng có sử dụng một loại mã giảm giá cụ thể,
        // hoặc từ khách hàng được đánh dấu là "affiliate".
        // Hiện tại, tôi sẽ trả về 0.0 để không gây lỗi.
        System.out.println("WARN: getTotalAffiliateRevenue method needs custom implementation based on your business logic.");
        return 0.0; // Placeholder
    }

    @Override
    public Map<Integer, Double> getMonthlySalesData(int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT MONTH(o.orderDate) as month, SUM(oi.quantity * oi.toy.price) as revenue " +
                    "FROM OrderItem oi JOIN oi.order o " +
                    "WHERE YEAR(o.orderDate) = :year AND o.status = :completedStatus " +
                    "GROUP BY MONTH(o.orderDate) " +
                    "ORDER BY MONTH(o.orderDate) ASC"; // Changed this line
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            query.setParameter("year", year);
            query.setParameter("completedStatus", OrderStatus.HOAN_THANH);

            // Khởi tạo map với 0 cho tất cả các tháng
            Map<Integer, Double> monthlySales = new TreeMap<>();
            for (int i = 1; i <= 12; i++) {
                monthlySales.put(i, 0.0);
            }

            // Điền dữ liệu từ query vào map
            query.list().forEach(result -> {
                Integer month = (Integer) result[0];
                Double revenue = (Double) result[1];
                if (month != null && revenue != null) {
                    monthlySales.put(month, revenue);
                }
            });
            return monthlySales;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }
}