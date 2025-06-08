package com.kiendey.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class Register extends HttpServlet {

    // Biểu thức chính quy để kiểm tra định dạng email
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher registerPage = req.getRequestDispatcher("/register.jsp");
        registerPage.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // Lấy dữ liệu từ form (cả username và email)
        String fullname = req.getParameter("fullname");
        String username = req.getParameter("username"); // Lấy thêm username
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String confirm_pass = req.getParameter("confirm_password");
        String terms = req.getParameter("terms");

        // Lưu lại các giá trị đã nhập
        req.setAttribute("fullname", fullname);
        req.setAttribute("username", username); // Lưu lại username
        req.setAttribute("email", email);

        // ===== BẮT ĐẦU KIỂM TRA DỮ LIỆU =====

        // 1. Kiểm tra trường rỗng
        if (fullname == null || fullname.trim().isEmpty() ||
                username == null || username.trim().isEmpty() || // Thêm kiểm tra username
                email == null || email.trim().isEmpty() ||
                pass == null || pass.trim().isEmpty() ||
                confirm_pass == null || confirm_pass.trim().isEmpty()) {

            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra tên đăng nhập
        if (username.contains(" ") || username.length() < 5) {
            req.setAttribute("error", "Tên đăng nhập không hợp lệ (phải dài hơn 5 ký tự và không có khoảng trắng).");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra định dạng email
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            req.setAttribute("error", "Định dạng email không hợp lệ. Vui lòng kiểm tra lại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 4. Kiểm tra độ dài mật khẩu
        if (pass.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 5. Kiểm tra mật khẩu xác nhận
        if (!pass.equals(confirm_pass)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp. Vui lòng thử lại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 6. Kiểm tra điều khoản
        if (terms == null || !terms.equals("true")) {
            req.setAttribute("error", "Bạn phải đồng ý với các điều khoản và điều kiện của chúng tôi.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // ===== KẾT THÚC KIỂM TRA DỮ LIỆU =====

        // TODO: Viết code kiểm tra xem USERNAME hoặc EMAIL này đã tồn tại trong cơ sở dữ liệu chưa.
        // Cả hai đều phải là duy nhất.
        // Ví dụ:
        // if (dao.checkUsernameExists(username)) { req.setAttribute("error", "Tên đăng nhập đã tồn tại."); forward... }
        // if (dao.checkEmailExists(email)) { req.setAttribute("error", "Email đã được sử dụng."); forward... }

        // TODO: Nếu mọi thứ hợp lệ, lưu thông tin người dùng (Họ tên, Tên đăng nhập, Email, Mật khẩu đã mã hóa) vào cơ sở dữ liệu.

        resp.sendRedirect("login?register=success");
    }
}