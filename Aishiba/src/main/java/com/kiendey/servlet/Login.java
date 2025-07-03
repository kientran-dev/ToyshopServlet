package com.kiendey.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.Serial;

@WebServlet("/login")
public class Login extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String errorMessage = null;

        // Lưu giá trị đã nhập để giữ lại trong form
        request.setAttribute("username", username != null ? username.trim() : "");
        request.setAttribute("password", password != null ? password.trim() : "");

        // Input validation
        if (username == null || username.trim().isEmpty()) {
            errorMessage = "Tên người dùng không được để trống!";
        } else if (password == null || password.trim().isEmpty()) {
            errorMessage = "Mật khẩu không được để trống!";
        } else if (username.length() < 4 || username.length() > 20) {
            errorMessage = "Tên người dùng phải từ 4-20 ký tự!";
        } else if (password.length() < 6 || password.length() > 30) {
            errorMessage = "Mật khẩu phải từ 6-30 ký tự!";
        } else if (!username.matches("^[a-zA-Z0-9_]+$")) {
            errorMessage = "Tên người dùng chỉ được chứa chữ cái, số và dấu gạch dưới!";
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra thông tin đăng nhập
        // Trong một ứng dụng thực tế, bạn sẽ dùng UserDAO để kiểm tra user/password trong database
        if ("admin".equals(username) && "password123".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username); // Lưu username vào session
            //session.setAttribute("currentUser", userObject); // Nếu bạn có đối tượng User

            // --- THAY ĐỔI TẠI ĐÂY ---
            // Sử dụng sendRedirect để chuyển hướng trình duyệt đến /homepage
            response.sendRedirect(request.getContextPath() + "/homepage");
            // ------------------------

        } else {
            request.setAttribute("error", "Tên người dùng hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}