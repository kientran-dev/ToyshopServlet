package com.kiendey.dao;

import com.kiendey.model.Order;
import java.time.LocalDateTime;
import java.util.List;

public interface OrderDAO {
    void createOrder(Order order);
    Order readOrder(String id);
    void updateOrder(Order order);
    void deleteOrder(String id);
    List<Order> getAllOrders();
    List<Order> getOrdersByUserId(String userId);
    List<Order> searchOrdersByStatus(String status);
    // New method for daily report
    List<Order> getOrdersByDate(LocalDateTime startDate, LocalDateTime endDate);
}