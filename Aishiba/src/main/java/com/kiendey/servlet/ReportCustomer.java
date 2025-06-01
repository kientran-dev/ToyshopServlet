package com.kiendey.servlet;

import com.kiendey.dao.OrderDAO;
import com.kiendey.dao.impl.OrderDAOImpl;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.util.Map;

@WebServlet("/report-customer") // Đặt đường dẫn cho Servlet này
public class ReportCustomer extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl(); // Khởi tạo DAO
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws jakarta.servlet.ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy dữ liệu cho biểu đồ Top khách hàng theo số lượng đơn hàng
            Map<String, Long> customerOrderCounts = orderDAO.getCustomerOrderCounts();
            req.setAttribute("customerOrderCounts", customerOrderCounts);

            // Lấy dữ liệu cho biểu đồ Top khách hàng theo tổng giá trị mua hàng
            Map<String, Double> customerTotalPurchaseValues = orderDAO.getCustomerTotalPurchaseValues();
            req.setAttribute("customerTotalPurchaseValues", customerTotalPurchaseValues);

        } catch (Exception e) {
            // Log lỗi và hiển thị thông báo lỗi cho người dùng
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error loading customer report data: " + e.getMessage());
        }

        // Call jsp files
        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) {
            head.include(req, resp);
        }
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) {
            header.include(req, resp);
        }
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) {
            sidebar.include(req, resp);
        }
        RequestDispatcher reportCustomer = req.getRequestDispatcher("/report_customer.jsp"); // Đảm bảo đúng tên JSP
        if (reportCustomer != null) {
            reportCustomer.include(req, resp);
        }
        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) {
            footer.include(req, resp);
        }
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) {
            end.include(req, resp);
        }
    }
}