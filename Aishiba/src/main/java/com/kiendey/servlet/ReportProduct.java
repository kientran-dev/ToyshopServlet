package com.kiendey.servlet;

import com.kiendey.dao.OrderItemDAO;
import com.kiendey.dao.ToyDAO;
import com.kiendey.dao.impl.OrderItemDAOImpl;
import com.kiendey.dao.impl.ToyDAOImpl;
import com.kiendey.dto.ProductSaleStat;
import com.kiendey.model.Toy;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/report-product")
public class ReportProduct extends HttpServlet {

    private transient OrderItemDAO orderItemDAO;
    private transient ToyDAO toyDAO;

    @Override
    public void init() {
        orderItemDAO = new OrderItemDAOImpl();
        toyDAO = new ToyDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        try {
            // 1. Lấy thống kê sản phẩm bán chạy (theo số lượng)
            List<ProductSaleStat> productSaleStats = orderItemDAO.getProductSalesStatistics();

            // 2. Lấy tất cả sản phẩm
            List<Toy> allToys = toyDAO.getAllToys();

            // 3. Xác định sản phẩm chưa bán được
            Set<String> soldToyIds = productSaleStats.stream()
                    .map(ProductSaleStat::getToyId)
                    .collect(Collectors.toSet());

            List<Toy> unsoldProducts = allToys.stream()
                    .filter(toy -> !soldToyIds.contains(toy.getId()))
                    .collect(Collectors.toList());

            // 4. Đặt thuộc tính cho JSP
            req.setAttribute("productSaleStats", productSaleStats); // Sửa tên thuộc tính
            req.setAttribute("unsoldProducts", unsoldProducts);
            req.setAttribute("topN", 10);

            // 5. Sử dụng layout.jsp để hiển thị
            RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
            if (head != null) head.include(req, resp);
            RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
            if (header != null) header.include(req, resp);
            RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
            if (sidebar != null) sidebar.include(req, resp);

            RequestDispatcher supplierPage = req.getRequestDispatcher("/report_product.jsp");
            if (supplierPage != null) supplierPage.include(req, resp);

            RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
            if (footer != null) footer.include(req, resp);
            RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
            if (end != null) end.include(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error fetching product report statistics", e);
        }
    }
}