package com.kiendey.dao;

import com.kiendey.model.Order;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map; // Import Map

public interface OrderDAO {
    void createOrder(Order order);
    Order readOrder(String id);
    void updateOrder(Order order);
    void deleteOrder(String id);
    List<Order> getAllOrders();
    List<Order> getOrdersByUserId(String userId);
    List<Order> searchOrdersByStatus(String status);
    List<Order> getOrdersByDate(LocalDateTime startDate, LocalDateTime endDate);

    // New methods for customer reports
    /**
     * Lấy số lượng đơn hàng của mỗi khách hàng, sắp xếp giảm dần.
     * Key là userId, Value là số lượng đơn hàng.
     */
    Map<String, Long> getCustomerOrderCounts();

    /**
     * Lấy tổng giá trị mua hàng của mỗi khách hàng, sắp xếp giảm dần.
     * Key là userId, Value là tổng giá trị.
     */
    Map<String, Double> getCustomerTotalPurchaseValues();
}