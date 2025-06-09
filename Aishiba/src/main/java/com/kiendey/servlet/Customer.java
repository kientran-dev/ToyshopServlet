package com.kiendey.servlet;

import com.kiendey.dao.RoleDAO;
import com.kiendey.dao.UserDAO;
import com.kiendey.dao.impl.RoleDAOImpl;
import com.kiendey.dao.impl.UserDAOImpl;
import com.kiendey.model.Role;
import com.kiendey.model.User;
import com.kiendey.utils.HibernateUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/customer")
public class Customer extends HttpServlet {

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

        // Pagination and data retrieval
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

        long totalUsers = userDAO.getTotalUserCount();
        int totalPages = (int) Math.ceil((double) totalUsers / DEFAULT_PAGE_SIZE);
        if (currentPage > totalPages && totalPages > 0)
            currentPage = totalPages;
        if (totalPages == 0 && currentPage > 1)
            currentPage = 1;

        List<User> userList = userDAO.getUsersByPage(currentPage, DEFAULT_PAGE_SIZE);
        req.setAttribute("userList", userList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);
        req.setAttribute("pageTitle", "Danh sách khách hàng");
        req.setAttribute("contentPage", "/customer.jsp");

        req.getRequestDispatcher("/layout.jsp").forward(req, resp);

        // Include JSP files
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
        RequestDispatcher customer = req.getRequestDispatcher("/customer.jsp");
        if (customer != null) {
            customer.include(req, resp);
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        // Log all request parameters for debugging
        System.out.println("All request parameters in doPost:");
        req.getParameterMap().forEach((key, values) -> {
            System.out.println("  " + key + ": " + String.join(", ", values));
        });

        String action = req.getParameter("action");
        String customerId = req.getParameter("customerId");

        System.out.println("Received POST request. Action: " + action + ", Customer ID: " + customerId);

        try {
            if ("add".equals(action)) {
                Session session = null;
                Transaction transaction = null;
                try {
                    session = HibernateUtil.getSessionFactory().openSession();
                    transaction = session.beginTransaction();

                    User user = new User();
                    user.setName(req.getParameter("customerName"));
                    user.setPhone(req.getParameter("customerPhone"));
                    user.setAddress(req.getParameter("customerAddress"));
                    user.setEmail(req.getParameter("email"));

                    String birthdate = req.getParameter("customerBirthdate");
                    if (birthdate != null && !birthdate.trim().isEmpty()) {
                        try {
                            user.setDob(LocalDate.parse(birthdate));
                        } catch (Exception e) {
                            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            resp.getWriter().write("{\"error\": \"Invalid birthdate format. Use yyyy-MM-dd\"}");
                            return;
                        }
                    }

                    String gender = req.getParameter("gender");
                    if (gender != null && !gender.trim().isEmpty()) {
                        try {
                            user.setGender(com.kiendey.common.Gender.valueOf(gender));
                        } catch (IllegalArgumentException e) {
                            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            resp.getWriter().write("{\"error\": \"Invalid gender value\"}");
                            return;
                        }
                    } else {
                        user.setGender(null);
                    }

                    if (user.getName() == null || user.getName().trim().isEmpty() || user.getPhone() == null
                            || user.getPhone().trim().isEmpty()) {
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        resp.getWriter().write("{\"error\": \"Customer name and phone are required\"}");
                        return;
                    }

                    user.setDeleted(false);

                    RoleDAO roleDAO = new RoleDAOImpl();
                    Role defaultRole = session.createQuery("FROM Role r WHERE r.name = :name", Role.class)
                            .setParameter("name", "USER")
                            .uniqueResult();

                    if (defaultRole == null) {
                        defaultRole = new Role();
                        defaultRole.setName("USER");
                        defaultRole.setDescription("Default user role");
                        session.persist(defaultRole);
                    }
                    user.setRole(defaultRole);

                    session.persist(user);
                    transaction.commit();

                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"message\": \"Thêm khách hàng thành công \", \"id\": \""
                            + user.getFormattedUserCode() + "\"}");
                } catch (Exception e) {
                    if (transaction != null) {
                        transaction.rollback();
                    }
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
                } finally {
                    if (session != null && session.isOpen()) {
                        session.close();
                    }
                }
            } else if ("update".equals(action)) {
                User user = userDAO.readUser(customerId);
                if (user == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\": \"Customer not found\"}");
                    return;
                }

                user.setName(req.getParameter("customerName"));
                user.setPhone(req.getParameter("customerPhone"));
                user.setAddress(req.getParameter("customerAddress"));
                user.setEmail(req.getParameter("email"));

                String birthdate = req.getParameter("customerBirthdate");
                if (birthdate != null && !birthdate.trim().isEmpty()) {
                    try {
                        user.setDob(LocalDate.parse(birthdate));
                    } catch (Exception e) {
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        resp.getWriter().write("{\"error\": \"Invalid birthdate format. Use yyyy-MM-dd\"}");
                        return;
                    }
                } else {
                    user.setDob(null);
                }

                String gender = req.getParameter("gender");
                if (gender != null && !gender.trim().isEmpty()) {
                    try {
                        user.setGender(com.kiendey.common.Gender.valueOf(gender));
                    } catch (IllegalArgumentException e) {
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        resp.getWriter().write("{\"error\": \"Invalid gender value\"}");
                        return;
                    }
                } else {
                    user.setGender(null);
                }

                userDAO.updateUser(user);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"message\": \"Cập nhật khách hàng thành công\"}");
            } else if ("delete".equals(action)) {
                System.out.println("Attempting to soft delete customer with ID: " + customerId);
                User user = userDAO.readUser(customerId);
                if (user != null) {
                    userDAO.softDeleteUser(user.getId());
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"message\": \"Customer soft deleted successfully\"}");
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\": \"Customer not found for ID: " + customerId + "\"}");
                }
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