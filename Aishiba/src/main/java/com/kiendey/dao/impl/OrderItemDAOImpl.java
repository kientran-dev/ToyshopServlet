package com.kiendey.dao.impl;

import com.kiendey.dao.OrderItemDAO;
import com.kiendey.dto.ProductSaleStat;
import com.kiendey.model.Order;
import com.kiendey.model.OrderItem;
import com.kiendey.model.Toy;
import com.kiendey.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime; // Import LocalDateTime
import java.util.Collections;
import java.util.List;

public class OrderItemDAOImpl implements OrderItemDAO {
    /**
     * Tạo một mục đơn hàng mới và lưu vào cơ sở dữ liệu.
     *
     * @param orderId Đối tượng Order mà mục này thuộc về.
     * @param toyId Đối tượng Product được đặt hàng.
     * @param quantity Số lượng sản phẩm.
     */
    @Override
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

    @Override
    public OrderItem readOrderItem(String orderId, String toyId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Corrected readOrderItem to actually query the database for the OrderItem
            String hql = "FROM OrderItem oi WHERE oi.order.id = :orderId AND oi.toy.id = :toyId";
            Query<OrderItem> query = session.createQuery(hql, OrderItem.class);
            query.setParameter("orderId", orderId);
            query.setParameter("toyId", toyId);
            return query.uniqueResult();
        } catch (Exception e) {
            throw new RuntimeException("Error reading OrderItem: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateOrderItem(String orderId, String toyId, int quantity) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            OrderItem orderItem = readOrderItem(orderId, toyId); // Use the correct readOrderItem to find the existing item
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

    @Override
    public void deleteOrderItem(String orderId, String toyId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            OrderItem orderItem = readOrderItem(orderId, toyId); // Use the correct readOrderItem to find the existing item
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

    @Override
    public List<ProductSaleStat> getProductSalesStatistics() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT new com.kiendey.dto.ProductSaleStat(oi.toy.id, oi.toy.name, SUM(oi.quantity)) " +
                    "FROM OrderItem oi " + //
                    "GROUP BY oi.toy.id, oi.toy.name " + //
                    "ORDER BY SUM(oi.quantity) DESC"; //
            Query<ProductSaleStat> query = session.createQuery(hql, ProductSaleStat.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public List<ProductSaleStat> getProductSalesStatisticsByDate(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT new com.kiendey.dto.ProductSaleStat(oi.toy.id, oi.toy.name, SUM(oi.quantity)) " +
                    "FROM OrderItem oi JOIN oi.order o " +
                    "WHERE o.orderDate BETWEEN :startDate AND :endDate " +
                    "GROUP BY oi.toy.id, oi.toy.name " +
                    "ORDER BY SUM(oi.quantity) DESC";
            Query<ProductSaleStat> query = session.createQuery(hql, ProductSaleStat.class);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
    // --- NEW METHOD FOR YEARLY REPORTS ---

    @Override
    public long getTotalQuantitySoldByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(oi.quantity) FROM OrderItem oi JOIN oi.order o " +
                    "WHERE o.orderDate BETWEEN :startDate AND :endDate";
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
}