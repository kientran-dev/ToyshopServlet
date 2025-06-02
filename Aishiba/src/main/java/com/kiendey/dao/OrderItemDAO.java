package com.kiendey.dao;

import com.kiendey.dto.ProductSaleStat;
import com.kiendey.model.OrderItem;

import java.util.List;

public interface OrderItemDAO {
    // Define methods for CRUD operations on OrderItem entities
    void createOrderItem(String orderId, String toyId, int quantity);
    OrderItem readOrderItem(String orderId, String toyId);
    void updateOrderItem(String orderId, String toyId, int quantity);
    void deleteOrderItem(String orderId, String toyId);

    /**
     * Lấy danh sách thống kê số lượng bán của mỗi sản phẩm,
     * sắp xếp theo số lượng bán giảm dần.
     * @return Danh sách các đối tượng ProductSaleStat.
     */
    List<ProductSaleStat> getProductSalesStatistics();
    // Additional methods can be added as needed
}
