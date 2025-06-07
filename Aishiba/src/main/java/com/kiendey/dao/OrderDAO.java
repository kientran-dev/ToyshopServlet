package com.kiendey.dao;

import com.kiendey.common.OrderStatus;
import com.kiendey.model.Order;
import com.kiendey.model.OrderItem;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map; // Import Map

public interface OrderDAO {
    boolean createOrder(Order order);
    boolean createOrderWithItems(Order order, List<OrderItem> orderItems);
    Order readOrder(String id);
    void updateOrder(Order order);
    void deleteOrder(String id);
    List<Order> getAllOrders();
    List<Order> getOrdersByUserId(String userId);
    List<Order> searchOrdersByStatus(String status);
    List<Order> getOrdersByDate(LocalDateTime startDate, LocalDateTime endDate);
    Order getOrderById(String id);
    double getTotalOrderAmount(String userId);//Tinh tong tien cua tat ca don hang cua user
    double getFinalAmount(String orderId);
    // Phương thức mới cho phân trang
    List<Order> getOrdersByPage(int pageNumber, int pageSize);
    int getTotalOrderCount();
    boolean updateOrderStatus(String orderId, OrderStatus status);
    List<Order> searchAndFilterOrders(String searchTerm, String status, String dateStr, int page, int pageSize);
    int countFilteredOrders(String searchTerm, String status, String dateStr);
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

    // **************************** NEW METHODS FOR FINANCIAL REPORT ****************************

    /**
     * Lấy tổng doanh thu bán hàng trong một khoảng thời gian cụ thể.
     * Chỉ tính các đơn hàng có trạng thái là 'Hoàn thành'.
     * @param startDate Thời gian bắt đầu.
     * @param endDate Thời gian kết thúc.
     * @return Tổng doanh thu bán hàng.
     */
    double getTotalSalesRevenue(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Lấy tổng giá trị các đơn hàng bị hủy hoặc trả lại trong một khoảng thời gian cụ thể.
     * @param startDate Thời gian bắt đầu.
     * @param endDate Thời gian kết thúc.
     * @return Tổng giá trị bị hủy hoặc trả lại.
     */
    double getTotalCancelledOrRefundedAmount(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Lấy tổng số lượng tồn kho hiện tại của tất cả các đồ chơi.
     * @return Tổng số lượng tồn kho.
     */
    double getTotalCurrentStockQuantity();
    // ******************************************************************************************
}