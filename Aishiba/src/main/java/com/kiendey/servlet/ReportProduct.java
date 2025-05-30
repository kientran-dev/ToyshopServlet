package com.kiendey.servlet;

import com.kiendey.dao.OrderItemDAO;
import com.kiendey.dao.StockItemDAO; // Thêm import này
import com.kiendey.dao.ToyDAO;
import com.kiendey.dao.impl.OrderItemDAOImpl;
import com.kiendey.dao.impl.StockItemDAOImpl; // Thêm import này
import com.kiendey.dao.impl.ToyDAOImpl;
import com.kiendey.dto.ProductSaleStat;
import com.kiendey.dto.StockProductStat; // Thêm import này
import com.kiendey.model.StockItem; // Thêm import này
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
    private transient StockItemDAO stockItemDAO; // Thêm khai báo này

    @Override
    public void init() {
        orderItemDAO = new OrderItemDAOImpl();
        toyDAO = new ToyDAOImpl();
        stockItemDAO = new StockItemDAOImpl(); // Thêm khởi tạo này
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        String focus = req.getParameter("focus");
        if (focus == null || focus.isEmpty()) {
            focus = "sales"; // Giá trị mặc định nếu không có focus
        }

        try {
            if ("sales".equals(focus)) {
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
                req.setAttribute("productSaleStats", productSaleStats);
                req.setAttribute("unsoldProducts", unsoldProducts);
                req.setAttribute("topN", 10);
            } else if ("inventory".equals(focus)) {
                // Xử lý khi focus là "Giữ tồn kho"
                int lowStockThreshold = 50; // Ngưỡng ví dụ cho sản phẩm sắp hết hàng
                int highStockThreshold = 200; // Ngưỡng ví dụ cho sản phẩm tồn kho nhiều

                List<StockItem> lowStockItems = stockItemDAO.getLowStockItems(lowStockThreshold);
                List<StockItem> highStockItems = stockItemDAO.getHighStockItems(highStockThreshold);
                List<StockItem> outOfStockItems = stockItemDAO.getOutOfStockItems();


                // Chuyển đổi StockItem sang StockProductStat để dễ dàng hiển thị trong JSP
                List<StockProductStat> lowStockStats = lowStockItems.stream()
                        .map(si -> new StockProductStat(si.getToy().getId(), si.getToy().getName(), si.getQuantity()))
                        .collect(Collectors.toList());

                List<StockProductStat> highStockStats = highStockItems.stream()
                        .map(si -> new StockProductStat(si.getToy().getId(), si.getToy().getName(), si.getQuantity()))
                        .collect(Collectors.toList());

                List<StockProductStat> outOfStockStats = outOfStockItems.stream()
                        .map(si -> new StockProductStat(si.getToy().getId(), si.getToy().getName(), si.getQuantity()))
                        .collect(Collectors.toList());

                req.setAttribute("lowStockStats", lowStockStats);
                req.setAttribute("highStockStats", highStockStats);
                req.setAttribute("outOfStockStats", outOfStockStats);
                req.setAttribute("lowStockThreshold", lowStockThreshold);
                req.setAttribute("highStockThreshold", highStockThreshold);

            }
            // Bạn có thể thêm các điều kiện else if khác cho "profit", "import",... ở đây

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