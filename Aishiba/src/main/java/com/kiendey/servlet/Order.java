package com.kiendey.servlet;

import com.kiendey.dao.OrderDAO;
import com.kiendey.dao.OrderDAO;
import com.kiendey.dao.impl.OrderDAOImpl;
import com.kiendey.dao.impl.OrderDAOImpl;
import com.kiendey.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@WebServlet("/order")
public class Order extends HttpServlet {
    private OrderDAO orderDAO;
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        long totalOrders = orderDAO.getTotalOrderCount();
        int totalPages = (int) Math.ceil((double) totalOrders / DEFAULT_PAGE_SIZE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (totalPages == 0 && currentPage > 1) {
            currentPage = 1;
        }

        List<com.kiendey.model.Order> orderList = orderDAO.getOrdersByPage(currentPage, DEFAULT_PAGE_SIZE);
        // Chuyển đổi LocalDateTime sang java.util.Date cho mỗi Order
        List<Date> orderDateList = new ArrayList<>();
        List<Double> totalAmountList = new ArrayList<>();
        for (com.kiendey.model.Order order : orderList) {
            LocalDateTime orderDate = order.getOrderDate();
            Date date = orderDate != null ? Date.from(orderDate.atZone(ZoneId.systemDefault()).toInstant()) : null;
            orderDateList.add(date);

        // Gọi getTotalAmount() từ OrderDAOImpl
            double totalAmount = orderDAO.getFinalAmount(order.getId()); // Giả sử nhận orderId
            totalAmountList.add(totalAmount);
        }


        req.setAttribute("orderList", orderList);
        req.setAttribute("orderDateList", orderDateList); // Danh sách Date tương ứng
        req.setAttribute("totalAmountList", totalAmountList); // Danh sách tổng tiền tương ứng
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) head.include(req, resp);
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) header.include(req, resp);
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) sidebar.include(req, resp);

        RequestDispatcher orderPage = req.getRequestDispatcher("/order.jsp");
        if (orderPage != null) orderPage.include(req, resp);

        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) footer.include(req, resp);
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) end.include(req, resp);
    }
}