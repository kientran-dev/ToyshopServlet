package com.kiendey.servlet;

import com.kiendey.dao.UserDAO;
import com.kiendey.dao.impl.UserDAOImpl;
import com.kiendey.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/account")
public class Account extends HttpServlet {

    private UserDAO userDAO;
    private static final int DEFAULT_PAGE_SIZE = 15;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        // Pagination and data retrieval for deleted users
        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1)
                    currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        long totalDeletedUsers = userDAO.getTotalDeletedUserCount();
        int totalPages = (int) Math.ceil((double) totalDeletedUsers / DEFAULT_PAGE_SIZE);
        if (currentPage > totalPages && totalPages > 0)
            currentPage = totalPages;
        if (totalPages == 0 && currentPage > 1)
            currentPage = 1;

        List<User> deletedUserList = userDAO.getDeletedUsersByPage(currentPage, DEFAULT_PAGE_SIZE);
        req.setAttribute("deletedUserList", deletedUserList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);
        req.setAttribute("totalDeletedUsers", totalDeletedUsers);
        req.setAttribute("pageTitle", "Khách hàng đã xóa");
        req.setAttribute("contentPage", "/account.jsp");

        req.getRequestDispatcher("/layout.jsp").forward(req, resp);

        // The following includes are handled by layout.jsp, so they are redundant here
        // RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        // if (head != null) {
        // head.include(req, resp);
        // }
        // RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        // if (header != null) {
        // header.include(req, resp);
        // }
        // RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        // if (sidebar != null) {
        // sidebar.include(req, resp);
        // }
        // RequestDispatcher order = req.getRequestDispatcher("/account.jsp");
        // if (order != null) {
        // order.include(req, resp);
        // }
        // RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        // if (footer != null) {
        // footer.include(req, resp);
        // }
        // RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        // if (end != null) {
        // end.include(req, resp);
        // }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String action = req.getParameter("action");

        try {
            if ("restore".equals(action)) {
                String customerId = req.getParameter("customerId");
                if (customerId == null || customerId.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\": \"Customer ID is required for restore action\"}");
                    return;
                }

                userDAO.restoreUser(customerId);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"message\": \"Khách hàng đã được khôi phục thành công\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
