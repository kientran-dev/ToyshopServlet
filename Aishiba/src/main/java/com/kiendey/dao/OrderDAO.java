// File: src/main/java/com/kiendey/dao/OrderDAO.java
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

    // **************************** NEW METHODS FOR YEARLY REPORTS ****************************

    /**
     * Lấy tổng số đơn hàng trong một khoảng thời gian cụ thể (theo năm).
     * @param startDate Thời gian bắt đầu.
     * @param endDate Thời gian kết thúc.
     * @return Tổng số đơn hàng.
     */
    long getTotalOrderCountByDateRange(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Lấy tổng doanh thu liên kết trong một khoảng thời gian cụ thể (theo năm).
     * Bạn cần định nghĩa rõ logic này dựa trên nghiệp vụ của mình (ví dụ: liên kết với mã giảm giá/coupon, hoặc loại khách hàng).
     * @param startDate Thời gian bắt đầu.
     * @param endDate Thời gian kết thúc.
     * @return Tổng doanh thu liên kết.
     */
    double getTotalAffiliateRevenue(LocalDateTime startDate, LocalDateTime endDate);

    /**
     * Lấy dữ liệu doanh thu theo từng tháng trong một năm cụ thể.
     * Key là tháng (1-12), Value là tổng doanh thu của tháng đó.
     * @param year Năm cần lấy dữ liệu.
     * @return Map chứa doanh thu theo tháng.
     */
    Map<Integer, Double> getMonthlySalesData(int year);
}