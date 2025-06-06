package com.kiendey.dao.impl;

import com.kiendey.common.OrderStatus;
import com.kiendey.dao.OrderDAO;
import com.kiendey.model.Order;
import com.kiendey.model.OrderItem; // Thêm import cho OrderItem
import com.kiendey.model.Toy; // Thêm import cho Toy
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap; // Để giữ thứ tự kết quả

import com.kiendey.dto.ProductSaleStat; // Thêm import cho ProductSaleStat

public class OrderDAOImpl implements OrderDAO {

    @Override
    public void createOrder(Order order) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(order);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error creating Order: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean createOrderWithItems(Order order, List<OrderItem> orderItems) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(order);
            for (OrderItem item : orderItems) {
                item.setOrder(order);
                session.persist(item);
            }
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Order readOrder(String orderId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            // Sử dụng JOIN FETCH để tải trước User, OrderItems và Toy
            String hql = "FROM Order o " +
                    "LEFT JOIN FETCH o.user " +
                    "LEFT JOIN FETCH o.orderItems oi " +
                    "LEFT JOIN FETCH oi.toy " +
                    "LEFT JOIN FETCH o.paymentMethod " +
                    "LEFT JOIN FETCH o.deliveryMethod " +
                    "WHERE o.id = :orderId";
            Query<com.kiendey.model.Order> query = session.createQuery(hql, com.kiendey.model.Order.class);
            query.setParameter("orderId", orderId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    @Override
    public void updateOrder(Order order) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(order); // Use merge for updating detached instances
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating Order: " + e.getMessage(), e);
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
            throw new RuntimeException("Error deleting Order: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Order> getAllOrders() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order o LEFT JOIN FETCH o.user LEFT JOIN FETCH o.orderItems oi LEFT JOIN FETCH oi.toy";
            return session.createQuery(hql, Order.class).list();
        } catch (Exception e) {
            throw new RuntimeException("Error getting all Orders: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Order> getOrdersByUserId(String userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order o WHERE o.user.id = :userId";
            return session.createQuery(hql, Order.class)
                    .setParameter("userId", userId)
                    .list();
        } catch (Exception e) {
            throw new RuntimeException("Error getting Orders by user ID: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Order> searchOrdersByStatus(String status) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order o WHERE o.status = :status";
            return session.createQuery(hql, Order.class)
                    .setParameter("status", status)
                    .list();
        } catch (Exception e) {
            throw new RuntimeException("Error searching Orders by status: " + e.getMessage(), e);
        }
    }

    @Override
    public Order getOrderById(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Order.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Error getting Order by ID: " + e.getMessage(), e);
        }
    }

    @Override
    public double getTotalOrderAmount(String userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(oi.quantity * oi.toy.price) FROM Order o JOIN o.orderItems oi WHERE o.user.id = :userId";
            Double totalAmount = session.createQuery(hql, Double.class)
                    .setParameter("userId", userId)
                    .uniqueResult();
            return totalAmount != null ? totalAmount : 0.0;
        } catch (Exception e) {
            throw new RuntimeException("Error getting total order amount for User: " + e.getMessage(), e);
        }
    }

    @Override
    public double getFinalAmount(String orderId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(oi.quantity * oi.toy.price) FROM OrderItem oi WHERE oi.order.id = :orderId";
            Double finalAmount = session.createQuery(hql, Double.class)
                    .setParameter("orderId", orderId)
                    .uniqueResult();
            return finalAmount != null ? finalAmount : 0.0;
        } catch (Exception e) {
            throw new RuntimeException("Error getting final amount for Order: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Order> getOrdersByPage(int pageNumber, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order o LEFT JOIN FETCH o.user LEFT JOIN FETCH o.orderItems oi LEFT JOIN FETCH oi.toy";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error getting Orders by page: " + e.getMessage(), e);
        }
    }

    @Override
    public int getTotalOrderCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(o.id) FROM Order o";
            Long count = session.createQuery(hql, Long.class).uniqueResult();
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            throw new RuntimeException("Error getting total order count: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean updateOrderStatus(String orderId, OrderStatus status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Order order = session.get(Order.class, orderId);
            if (order != null) {
                order.setStatus(status);
                session.merge(order);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Order> getOrdersByDate(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Order o LEFT JOIN FETCH o.user LEFT JOIN FETCH o.orderItems oi LEFT JOIN FETCH oi.toy " +
                    "WHERE o.orderDate BETWEEN :startDate AND :endDate ORDER BY o.orderDate ASC";

            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);

            return query.list();
        } catch (Exception e) {
            throw new RuntimeException("Error getting Orders by date range: " + e.getMessage(), e);
        }
    }

    @Override
    public Map<String, Long> getCustomerOrderCounts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Thay đổi o.user.id thành o.user.name để lấy tên khách hàng
            String hql = "SELECT o.user.name, COUNT(o.id) FROM Order o GROUP BY o.user.name ORDER BY COUNT(o.id) DESC";
            List<Object[]> results = session.createQuery(hql, Object[].class).list();

            Map<String, Long> customerOrderCounts = new LinkedHashMap<>();
            for (Object[] result : results) {
                customerOrderCounts.put((String) result[0], (Long) result[1]);
            }
            return customerOrderCounts;
        } catch (Exception e) {
            throw new RuntimeException("Error getting customer order counts: " + e.getMessage(), e);
        }
    }

    @Override
    public Map<String, Double> getCustomerTotalPurchaseValues() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Thay đổi o.user.id thành o.user.name để lấy tên khách hàng
            String hql = "SELECT o.user.name, SUM(oi.quantity * oi.toy.price) " +
                    "FROM Order o JOIN o.orderItems oi " +
                    "GROUP BY o.user.name " +
                    "ORDER BY SUM(oi.quantity * oi.toy.price) DESC";

            List<Object[]> results = session.createQuery(hql, Object[].class).list();

            Map<String, Double> customerTotalPurchaseValues = new LinkedHashMap<>();
            for (Object[] result : results) {
                customerTotalPurchaseValues.put((String) result[0], (Double) result[1]);
            }
            return customerTotalPurchaseValues;
        } catch (Exception e) {
            throw new RuntimeException("Error getting customer total purchase values: " + e.getMessage(), e);
        }
    }

    // **************************** NEW METHODS FOR FINANCIAL REPORT ****************************

    @Override
    public double getTotalSalesRevenue(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Only count orders with status 'completed'
            String hql = "SELECT SUM(oi.quantity * oi.toy.price) FROM Order o JOIN o.orderItems oi " +
                    "WHERE o.orderDate BETWEEN :startDate AND :endDate AND o.status = 'HOAN_THANH'"; //
            Double totalRevenue = session.createQuery(hql, Double.class)
                    .setParameter("startDate", startDate)
                    .setParameter("endDate", endDate)
                    .uniqueResult();
            return totalRevenue != null ? totalRevenue : 0.0;
        } catch (Exception e) {
            throw new RuntimeException("Error getting total sales revenue: " + e.getMessage(), e);
        }
    }

    @Override
    public double getTotalCancelledOrRefundedAmount(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Assuming 'cancelled' or 'refunded' are statuses for returned/cancelled orders
            String hql = "SELECT SUM(oi.quantity * oi.toy.price) FROM Order o JOIN o.orderItems oi " +
                    "WHERE o.orderDate BETWEEN :startDate AND :endDate AND (o.status = 'DA_HUY' OR o.status = 'CHO_XU_LY')"; //
            Double totalAmount = session.createQuery(hql, Double.class)
                    .setParameter("startDate", startDate)
                    .setParameter("endDate", endDate)
                    .uniqueResult();
            return totalAmount != null ? totalAmount : 0.0;
        } catch (Exception e) {
            throw new RuntimeException("Error getting total cancelled or refunded amount: " + e.getMessage(), e);
        }
    }

    @Override
    public double getTotalCurrentStockQuantity() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Assuming Toy model has a 'stock' field directly, if not, adjust based on stock_items.
            // Based on screenshot, 'toys' table has 'stock' (int4) column.
            String hql = "SELECT SUM(t.stock) FROM Toy t WHERE t.isDeleted = false"; //
            Long totalStock = session.createQuery(hql, Long.class).uniqueResult();
            return totalStock != null ? totalStock.doubleValue() : 0.0;
        } catch (Exception e) {
            throw new RuntimeException("Error getting total current stock quantity: " + e.getMessage(), e);
        }
    }

    // Các phương thức OrderItemDAOImpl (nếu có)
    // Các phương thức này không liên quan trực tiếp đến yêu cầu chuyển từ ID sang tên khách hàng trên biểu đồ,
    // nhưng chúng được bao gồm để hoàn thiện lớp OrderDAOImpl dựa trên ngữ cảnh ban đầu.
    // Đảm bảo rằng OrderDAO interface của bạn cũng có các phương thức này.
    // Hiện tại OrderDAOImpl đang triển khai OrderDAO, nhưng các phương thức này thường thuộc về OrderItemDAO.
    // Nếu bạn muốn giữ chúng trong OrderDAOImpl, hãy đảm bảo interface OrderDAO cũng định nghĩa chúng.
    // Tôi sẽ thêm chúng vào đây với giả định rằng chúng là một phần của OrderDAO.

    public void createOrderItem(String orderId, String toyId, int quantity) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Toy toy = session.get(Toy.class, toyId);
            if (toy == null) {
                throw new RuntimeException("Toy not found with ID: " + toyId);
            }
            Order order = session.get(Order.class, orderId);
            if (order == null) {
                throw new RuntimeException("Order not found with ID: " + orderId);
            }
            OrderItem orderItem = new OrderItem();
            orderItem.setToy(toy);
            orderItem.setOrder(order);
            orderItem.setQuantity(quantity);
            session.persist(orderItem);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error creating OrderItem: " + e.getMessage(), e);
        }
    }

    public OrderItem readOrderItem(String orderId, String toyId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM OrderItem oi WHERE oi.order.id = :orderId AND oi.toy.id = :toyId";
            Query<OrderItem> query = session.createQuery(hql, OrderItem.class);
            query.setParameter("orderId", orderId);
            query.setParameter("toyId", toyId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void updateOrderItem(String orderId, String toyId, int quantity) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            OrderItem orderItem = readOrderItem(orderId, toyId);
            if (orderItem == null) {
                throw new RuntimeException("OrderItem not found for Order ID: " + orderId + " and Toy ID: " + toyId);
            }
            orderItem.setQuantity(quantity);
            session.merge(orderItem);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating OrderItem: " + e.getMessage(), e);
        }
    }

    public void deleteOrderItem(String orderId, String toyId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            OrderItem orderItem = readOrderItem(orderId, toyId);
            if (orderItem == null) {
                throw new RuntimeException("OrderItem not found for Order ID: " + orderId + " and Toy ID: " + toyId);
            }
            session.remove(orderItem);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting OrderItem: " + e.getMessage(), e);
        }
    }

    public List<ProductSaleStat> getProductSalesStatistics() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT new com.kiendey.dto.ProductSaleStat(oi.toy.id, oi.toy.name, SUM(oi.quantity)) " +
                    "FROM OrderItem oi " +
                    "GROUP BY oi.toy.id, oi.toy.name " +
                    "ORDER BY SUM(oi.quantity) DESC";
            Query<ProductSaleStat> query = session.createQuery(hql, ProductSaleStat.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}