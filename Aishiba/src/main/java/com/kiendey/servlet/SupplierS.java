package com.kiendey.servlet;

import com.kiendey.dao.SupplierDAO;
import com.kiendey.dao.impl.SupplierDAOImpl;
import com.kiendey.model.Supplier;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/supplier")
public class SupplierS extends HttpServlet {
    private SupplierDAO supplierDAO;
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("export".equals(action)) {
            exportSuppliers(resp);
            return;
        }
        resp.setContentType("text/html;charset=UTF-8");
        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        long totalSuppliers = supplierDAO.getTotalSupplierCount();
        int totalPages = (int) Math.ceil((double) totalSuppliers / DEFAULT_PAGE_SIZE);
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (totalPages == 0 && currentPage > 1) currentPage = 1;
        List<Supplier> supplierList = supplierDAO.getSuppliersByPage(currentPage, DEFAULT_PAGE_SIZE);
        req.setAttribute("supplierList", supplierList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        if ("delete".equals(action)) {
            String ids = req.getParameter("supplierIds");
            if (ids != null && !ids.isEmpty()) {
                for (String id : ids.split(",")) {
                    supplierDAO.deleteSupplier(id.trim());
                }
                resp.getWriter().write("{\"status\":\"success\"}");
            } else {
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"No IDs\"}");
            }
            return;
        }
        try {
            if ("create".equals(action)) {
                String name = req.getParameter("supplierName");
                String phone = req.getParameter("supplierPhone");
                String email = req.getParameter("supplierEmail");
                String address = req.getParameter("supplierAddress");
                String note = req.getParameter("supplierNote");
                Supplier supplier = new Supplier();
                supplier.setName(name);
                supplier.setPhoneNumber(phone);
                supplier.setEmail(email);
                supplier.setAddress(address);
                supplier.setDescription(note);
                supplier.setIsDeleted(false);
                supplierDAO.createSupplier(supplier);
                resp.getWriter().write("{\"status\":\"success\"}");
                return;
            } else if ("update".equals(action)) {
                String code = req.getParameter("supplierCode");
                System.out.println("Update supplier: " + code);
                Supplier supplier = supplierDAO.readSupplier(code);
                if (supplier != null) {
                    supplier.setName(req.getParameter("supplierName"));
                    supplier.setPhoneNumber(req.getParameter("supplierPhone"));
                    supplier.setEmail(req.getParameter("supplierEmail"));
                    supplier.setAddress(req.getParameter("supplierAddress"));
                    supplier.setDescription(req.getParameter("supplierNote"));
                    supplierDAO.updateSupplier(supplier);
                    resp.getWriter().write("{\"status\":\"success\"}");
                } else {
                    resp.setStatus(404);
                    resp.getWriter().write("{\"status\":\"not_found\"}");
                }
                return;
            } 
            resp.sendRedirect(req.getContextPath() + "/supplier");
        } catch (Exception ex) {
            resp.setStatus(500);
            resp.getWriter().write("{\"status\":\"error\"}");
        }
    }

    // Xuất danh sách nhà cung cấp ra CSV
    private void exportSuppliers(HttpServletResponse resp) throws IOException {
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=suppliers.csv");
        try (var writer = resp.getWriter()) {
            writer.println("Mã NCC,Tên,Địa chỉ,SĐT,Email,Ghi chú");
            for (Supplier s : suppliers) {
                writer.printf("%s,%s,%s,%s,%s,%s%n",
                    s.getFormattedSupplierCode(),
                    escapeCsv(s.getName()),
                    escapeCsv(s.getAddress()),
                    escapeCsv(s.getPhoneNumber()),
                    escapeCsv(s.getEmail()),
                    escapeCsv(s.getDescription())
                );
            }
        }
    }

    // Nhập danh sách nhà cung cấp từ CSV
    private void importSuppliers(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"No file uploaded\"}");
            return;
        }
        try (var reader = new java.io.BufferedReader(new java.io.InputStreamReader(filePart.getInputStream(), "UTF-8"))) {
            String line;
            boolean first = true;
            while ((line = reader.readLine()) != null) {
                if (first) { first = false; continue; } // skip header
                String[] arr = line.split(",", -1);
                if (arr.length >= 6) {
                    Supplier s = new Supplier();
                    s.setName(arr[1].trim());
                    s.setAddress(arr[2].trim());
                    s.setPhoneNumber(arr[3].trim());
                    s.setEmail(arr[4].trim());
                    s.setDescription(arr[5].trim());
                    s.setIsDeleted(false);
                    supplierDAO.createSupplier(s);
                }
            }
            resp.getWriter().write("{\"status\":\"success\"}");
        } catch (Exception ex) {
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Import failed\"}");
        }
    }

    // Hàm escape cho CSV
    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}