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

@WebServlet("/homepagess")
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
        long totalOrders = orderDAO.getTotalOrderCountByDateRange(startOfCurrentYear, endOfCurrentYear);
        long totalProductsSold = orderItemDAO.getTotalQuantitySoldByDateRange(startOfCurrentYear, endOfCurrentYear);

        // Lấy tổng số khách hàng:
        // Sử dụng phương thức getCustomerOrderCounts() từ OrderDAO để lấy số lượng khách hàng duy nhất đã đặt hàng.
        // Nếu bạn có UserDAO với phương thức getTotalUserCount(), bạn có thể dùng nó thay thế.
        long totalCustomers = orderDAO.getCustomerOrderCounts().size();

        // Set metrics as request attributes
        req.setAttribute("totalSalesRevenue", totalSalesRevenue);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalProductsSold", totalProductsSold);
        req.setAttribute("totalCustomers", totalCustomers); // Giá trị này giờ sẽ được cập nhật từ DB

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

        // 3. Get data for "Tỷ lệ phần trăm sản phẩm theo danh mục" chart
        List<ProductSaleStat> productSaleStats = orderItemDAO.getProductSalesStatistics();
        List<String> productLabels = productSaleStats.stream()
                .map(ProductSaleStat::getFormattedToyName)
                .collect(Collectors.toList());
        List<Long> productQuantities = productSaleStats.stream()
                .map(ProductSaleStat::getQuantitySold)
                .collect(Collectors.toList());

        // Manually serialize productLabels to a JSON string for JavaScript consumption
        StringBuilder labelsJsonBuilder = new StringBuilder("[");
        for (int i = 0; i < productLabels.size(); i++) {
            String label = productLabels.get(i);
            String escapedLabel = label.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
            labelsJsonBuilder.append("\"").append(escapedLabel).append("\"");
            if (i < productLabels.size() - 1) {
                labelsJsonBuilder.append(",");
            }
        }
        labelsJsonBuilder.append("]");

        req.setAttribute("productLabelsJson", labelsJsonBuilder.toString());
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
}