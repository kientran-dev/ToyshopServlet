package com.kiendey.servlet;

import com.kiendey.dao.SupplierDAO;
import com.kiendey.dao.impl.SupplierDAOImpl;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/supplier")
public class Supplier extends HttpServlet{

    private SupplierDAO supplierDAO;
    private static final int DEFAULT_PAGE_SIZE = 10; // Số lượng nhà cung cấp trên mỗi trang

    @Override
    public void init() throws ServletException {
        super.init();
        supplierDAO = new SupplierDAOImpl();
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
                // Giữ currentPage là 1 nếu tham số không hợp lệ
                currentPage = 1;
            }
        }

        long totalSuppliers = supplierDAO.getTotalSupplierCount();
        int totalPages = (int) Math.ceil((double) totalSuppliers / DEFAULT_PAGE_SIZE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages; // Nếu trang hiện tại vượt quá tổng số trang, đặt lại là trang cuối
        }
        if (totalPages == 0 && currentPage > 1) { // Nếu không có dữ liệu mà page > 1
            currentPage = 1;
        }


        List<com.kiendey.model.Supplier> supplierList = supplierDAO.getSuppliersByPage(currentPage, DEFAULT_PAGE_SIZE);

        req.setAttribute("supplierList", supplierList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE); // Gửi pageSize để có thể dùng trong JSP nếu cần

        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) head.include(req, resp);
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) header.include(req, resp);
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) sidebar.include(req, resp);

        RequestDispatcher supplierPage = req.getRequestDispatcher("/supplier.jsp");
        if (supplierPage != null) supplierPage.include(req, resp);

        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) footer.include(req, resp);
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) end.include(req, resp);
    }
}
