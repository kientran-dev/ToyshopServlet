// File: src/main/java/com/kiendey/servlet/HomePage.java
package com.kiendey.servlet;

import com.kiendey.dao.OrderDAO;
import com.kiendey.dao.OrderItemDAO;
import com.kiendey.dao.ToyDAO;
// import com.kiendey.dao.UserDAO; // Uncomment if you have a UserDAO interface
import com.kiendey.dao.impl.OrderDAOImpl;
import com.kiendey.dao.impl.OrderItemDAOImpl;
import com.kiendey.dao.impl.ToyDAOImpl;
// import com.kiendey.dao.impl.UserDAOImpl; // Uncomment if you have a UserDAOImpl
import com.kiendey.dto.ProductSaleStat;
import com.kiendey.model.Order;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.Year; // Import Year
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/homepage")
public class HomePage extends HttpServlet {
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private ToyDAO toyDAO;
    // private UserDAO userDAO; // Declare if you have a UserDAO for totalCustomers

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize DAO implementations
        orderDAO = new OrderDAOImpl();
        orderItemDAO = new OrderItemDAOImpl();
        toyDAO = new ToyDAOImpl();
        // userDAO = new UserDAOImpl(); // Initialize if you have a UserDAO
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Get current year and define time ranges for data retrieval
        int currentYear = LocalDateTime.now().getYear();
        LocalDateTime startOfCurrentYear = LocalDateTime.of(currentYear, 1, 1, 0, 0);
        LocalDateTime endOfCurrentYear = LocalDateTime.of(currentYear, 12, 31, 23, 59, 59);

        // 1. Calculate dashboard metrics from DAOs
        double totalSalesRevenue = orderDAO.getTotalSalesRevenue(startOfCurrentYear, endOfCurrentYear);
        // Lấy tổng số khách hàng:
        // Sử dụng phương thức getCustomerOrderCounts() từ OrderDAO để lấy số lượng khách hàng duy nhất đã đặt hàng.
        // Nếu bạn có UserDAO với phương thức getTotalUserCount(), bạn có thể dùng nó thay thế.


        // Set metrics as request attributes
        req.setAttribute("totalSalesRevenue", totalSalesRevenue);


        // 2. Get data for "Mức độ tăng trưởng bán hàng từng năm" chart
        Map<Integer, Double> monthlySales2025Data = orderDAO.getMonthlySalesData(currentYear);
        List<Double> monthlySales2025 = new ArrayList<>(Collections.nCopies(12, 0.0));
        monthlySales2025Data.forEach((month, sales) -> {
            if (month >= 1 && month <= 12) {
                monthlySales2025.set(month - 1, sales);
            }
        });
        req.setAttribute("monthlySales2025", monthlySales2025);

        Map<Integer, Double> monthlySales2024Data = orderDAO.getMonthlySalesData(currentYear - 1);
        List<Double> monthlySales2024 = new ArrayList<>(Collections.nCopies(12, 0.0));
        monthlySales2024Data.forEach((month, sales) -> {
            if (month >= 1 && month <= 12) {
                monthlySales2024.set(month - 1, sales);
            }
        });
        req.setAttribute("monthlySales2024", monthlySales2024);

        // 1. Gọi hàm MỚI từ ToyDAO để lấy dữ liệu thống kê
        List<Object[]> productStats = toyDAO.countToysByCategory();

// 2. Chuẩn bị 2 danh sách để truyền cho biểu đồ (giữ nguyên)
        List<String> productLabels = new ArrayList<>();
        List<Long> productQuantities = new ArrayList<>();

// 3. Lặp qua kết quả và đưa vào 2 danh sách trên (giữ nguyên)
        for (Object[] result : productStats) {
            String categoryName = (String) result[0];
            Long productCount = (Long) result[1]; // Đây là số lượng sản phẩm, không phải số lượng bán

            productLabels.add(categoryName);
            productQuantities.add(productCount);
        }
// Xác định khoảng thời gian (giữ nguyên)
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startOfThisMonth = now.withDayOfMonth(1).toLocalDate().atStartOfDay();
        LocalDateTime startOfNextMonth = startOfThisMonth.plusMonths(1);
        LocalDateTime startOfLastMonth = startOfThisMonth.minusMonths(1);

// --- Tính toán cho thẻ Tổng Đơn Hàng ---
        long totalOrders = orderDAO.getTotalOrderCount();
        long totalOrdersLastMonth = orderDAO.countOrdersBetweenDates(startOfLastMonth, startOfThisMonth);
        double totalOrdersChange = calculatePercentageChange(totalOrders, totalOrdersLastMonth);
        req.setAttribute("totalOrders", totalOrders); // Gửi tổng số hiển thị chính
        req.setAttribute("totalOrdersChange", totalOrdersChange);

// --- Tính toán cho thẻ Tổng Sản Phẩm Bán Ra ---
        long totalProductsSold = orderDAO.sumTotalSoldProducts();
        long totalProductsSoldLastMonth = orderDAO.sumSoldProductsBetweenDates(startOfLastMonth, startOfThisMonth);
        double totalProductsSoldChange = calculatePercentageChange(totalProductsSold, totalProductsSoldLastMonth);
        req.setAttribute("totalProductsSold", totalProductsSold);
        req.setAttribute("totalProductsSoldChange", totalProductsSoldChange);

// --- Tính toán cho thẻ Tổng Khách Hàng ---
        long totalCustomers = orderDAO.countTotalDistinctCustomers(); // Tổng từ trước đến nay
        long customersThisMonth = orderDAO.countDistinctCustomersBetweenDates(startOfThisMonth, startOfNextMonth);
        long customersLastMonth = orderDAO.countDistinctCustomersBetweenDates(startOfLastMonth, startOfThisMonth);
        double customersChange = calculatePercentageChange(customersThisMonth, customersLastMonth);

        double totalRevenueThisMonth = orderDAO.getTotalRevenueBetweenDates(startOfThisMonth, startOfNextMonth);
        double totalRevenueLastMonth = orderDAO.getTotalRevenueBetweenDates(startOfLastMonth, startOfThisMonth);

// 5. Tính toán tỷ lệ phần trăm thay đổi
        double totalRevenueChange = calculatePercentageChange(totalRevenueThisMonth, totalRevenueLastMonth);

// 6. Đặt thuộc tính để gửi sang JSP
        req.setAttribute("totalRevenueChange", totalRevenueChange);
        req.setAttribute("totalCustomers", totalCustomers);
        req.setAttribute("customersChange", customersChange);
// 4. Đặt thuộc tính cho request để JSP có thể đọc được (giữ nguyên)
        req.setAttribute("productLabels", productLabels);
        req.setAttribute("productQuantities", productQuantities);

        // Tạo một formatter để gửi sang JSP
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
        req.setAttribute("myFormatter", formatter);
        
        // 4. Get data for "Đơn Hàng Gần Đây" table
        int page = 1;
        int pageSize = 10;
        List<Order> recentOrders = orderDAO.getOrdersByPage(page, pageSize);
        req.setAttribute("recentOrders", recentOrders);

        // Include JSP files for the overall page structure
        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null){
            head.include(req, resp);
        }
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null){
            header.include(req, resp);
        }
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null){
            sidebar.include(req, resp);
        }
        RequestDispatcher index = req.getRequestDispatcher("/index.jsp");
        if (index != null){
            index.include(req, resp);
        }
        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null){
            footer.include(req, resp);
        }
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null){
            end.include(req, resp);
        }
    }

    /**
     * Hàm trợ giúp (helper method) để tính toán tỷ lệ phần trăm thay đổi.
     * @param currentValue Giá trị của kỳ hiện tại (ví dụ: doanh thu tháng này).
     * @param previousValue Giá trị của kỳ trước đó (ví dụ: doanh thu tháng trước).
     * @return Tỷ lệ phần trăm thay đổi.
     */
    private double calculatePercentageChange(double currentValue, double previousValue) {
        // --- Xử lý trường hợp đặc biệt để tránh lỗi chia cho 0 ---
        if (previousValue == 0) {
            // Nếu giá trị cũ là 0 và giá trị mới lớn hơn 0, coi như tăng 100%
            return (currentValue > 0) ? 100.0 : 0.0;
        }

        // --- Công thức tính toán chính ---
        // ((Giá trị mới - Giá trị cũ) / Giá trị cũ) * 100
        return ((currentValue - previousValue) / previousValue) * 100.0;
    }
}