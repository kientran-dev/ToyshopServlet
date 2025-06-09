// File: src/main/java/com/kiendey/dao/OrderItemDAO.java
package com.kiendey.dao;

import com.kiendey.dto.ProductSaleStat;
import com.kiendey.model.OrderItem;

import java.time.LocalDateTime;
import java.util.List;

public interface OrderItemDAO {
    void createOrderItem(String orderId, String toyId, int quantity);
    OrderItem readOrderItem(String orderId, String toyId);
    void updateOrderItem(String orderId, String toyId, int quantity);
    void deleteOrderItem(String orderId, String toyId);

    List<ProductSaleStat> getProductSalesStatistics();
    List<ProductSaleStat> getProductSalesStatisticsByDate(LocalDateTime startDate, LocalDateTime endDate);

    // **************************** NEW METHOD FOR YEARLY REPORTS ****************************

    /**
     * Lấy tổng số lượng sản phẩm đã bán trong một khoảng thời gian cụ thể (theo năm).
     * @param startDate Thời gian bắt đầu.
     * @param endDate Thời gian kết thúc.
     * @return Tổng số lượng sản phẩm đã bán.
     */
    long getTotalQuantitySoldByDateRange(LocalDateTime startDate, LocalDateTime endDate);
}