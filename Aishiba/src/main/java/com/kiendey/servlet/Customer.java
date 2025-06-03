package com.kiendey.servlet;

import com.kiendey.dao.UserDAO;
import com.kiendey.dao.impl.UserDAOImpl;
import com.kiendey.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer")
public class Customer extends HttpServlet {

    private UserDAO userDAO;
    private static final int DEFAULT_PAGE_SIZE = 15; // Same as Supplier

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        // Handle pagination
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

        long totalUsers = userDAO.getTotalUserCount();
        int totalPages = (int) Math.ceil((double) totalUsers / DEFAULT_PAGE_SIZE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (totalPages == 0 && currentPage > 1) {
            currentPage = 1;
        }

        List<User> userList = userDAO.getUsersByPage(currentPage, DEFAULT_PAGE_SIZE);

        // Set attributes for JSP
        req.setAttribute("userList", userList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

        // Include JSP pages
        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) head.include(req, resp);

        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) header.include(req, resp);

        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) sidebar.include(req, resp);

        RequestDispatcher customer = req.getRequestDispatcher("/customer.jsp");
        if (customer != null) customer.include(req, resp);

        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) footer.include(req, resp);

        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) end.include(req, resp);

    }

}