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
            return orderItem;
        } catch (Exception e) {
            throw new RuntimeException("Error reading OrderItem: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateOrderItem(String orderId, String toyId, int quantity) {
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
            // Sử dụng HQL với constructor expression để tạo đối tượng ProductSaleStat
            // Model OrderItem có thuộc tính 'toy' kiểu Toy, và Toy có 'id', 'name'.
            // OrderItem có thuộc tính 'quantity' kiểu int.
            String hql = "SELECT new com.kiendey.dto.ProductSaleStat(oi.toy.id, oi.toy.name, SUM(oi.quantity)) " +
                    "FROM OrderItem oi " + // [cite: 9]
                    "GROUP BY oi.toy.id, oi.toy.name " + // [cite: 9]
                    "ORDER BY SUM(oi.quantity) DESC"; // [cite: 9]
            Query<ProductSaleStat> query = session.createQuery(hql, ProductSaleStat.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace(); // Xử lý exception phù hợp
            return Collections.emptyList();
        }
    }


}