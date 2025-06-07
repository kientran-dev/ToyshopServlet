package com.kiendey.servlet;

import com.google.gson.*;
import com.kiendey.dao.*;
import com.kiendey.dao.impl.*;
import com.kiendey.model.*;
import com.kiendey.common.StockStatus; // Giả sử bạn có Enum này
import com.kiendey.model.Supplier;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/stock")
public class Stock extends HttpServlet {
    // --- DAOs ---
    private StockDAO stockDAO; // DAO cho phiếu nhập
    private ToyDAO toyDAO; // Tái sử dụng DAO cho đồ chơi
    private SupplierDAO supplierDAO; // DAO mới cho nhà cung cấp

    private static final int DEFAULT_PAGE_SIZE = 15;

    @Override
    public void init() throws ServletException {
        super.init();
        // Khởi tạo các DAO
        stockDAO = new StockDAOImpl();         // Bạn cần tạo class này
        toyDAO = new ToyDAOImpl();
        supplierDAO = new SupplierDAOImpl();   // Bạn cần tạo class này
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("getDetails".equals(action)) {
            // Xử lý lấy chi tiết phiếu nhập
            handleGetDetails(req, resp);
            return;
        } else if ("getToy".equals(action)) {
            // Tái sử dụng logic lấy thông tin sản phẩm
            handleGetToy(req, resp);
            return;
        } else if ("searchSuppliers".equals(action)) {
            // Xử lý tìm kiếm nhà cung cấp (thay cho khách hàng)
            handleSearchSuppliers(req, resp);
            return;
        } else if ("searchProducts".equals(action)) {
            // Tái sử dụng logic tìm kiếm sản phẩm
            handleSearchProducts(req, resp);
            return;
        } else if ("searchAndFilter".equals(action)) {
            // Xử lý tìm kiếm và lọc các phiếu nhập
            handleSearchAndFilter(req, resp);
            return;
        }

        // --- Hiển thị trang danh sách phiếu nhập mặc định ---
        displayStockListPage(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();
        String action = req.getParameter("action");

        if ("create".equals(action)) {
            // Xử lý tạo phiếu nhập mới
            handleCreateStock(req, resp, jsonResponse);
        } else if ("updateStatus".equals(action)) {
            // Xử lý cập nhật trạng thái phiếu nhập
            handleUpdateStatus(req, resp, jsonResponse);
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Hành động không hợp lệ: " + action);
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }

        out.print(jsonResponse.toString());
        out.flush();
    }

    // ==================================================================
    // CÁC PHƯƠNG THỨC XỬ LÝ (HANDLER METHODS)
    // ==================================================================

    /**
     * Lấy chi tiết một phiếu nhập và trả về dưới dạng JSON.
     */
    private void handleGetDetails(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String stockId = req.getParameter("id");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject json = new JsonObject();

        if (stockId != null && !stockId.trim().isEmpty()) {
            try {
                // Giả sử bạn có model Stock
                com.kiendey.model.Stock stock = stockDAO.readStock(stockId);
                if (stock != null) {
                    JsonObject stockJson = new JsonObject();
                    stockJson.addProperty("id", stock.getFormattedStockCode()); // VD: PN00001
                    stockJson.addProperty("StockDate", stock.getStockDate() != null ?
                            stock.getStockDate().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null);
                    stockJson.addProperty("address", stock.getSupplier().getAddress()); // Địa chỉ kho nhập
                    stockJson.addProperty("status", stock.getStatus() != null ?
                            stock.getStatus().name() : null);

                    // Thông tin nhà cung cấp
                    JsonObject supplierJson = new JsonObject();
                    if (stock.getSupplier() != null) {
                        supplierJson.addProperty("name", stock.getSupplier().getName());
                    }
                    stockJson.add("supplier", supplierJson);

                    // Danh sách sản phẩm nhập
                    List<StockItem> stockItems = stock.getStockItems(); // Giả sử có getStockItems()
                    JsonArray productsJson = new JsonArray();
                    if (stockItems != null) {
                        for (StockItem item : stockItems) {
                            JsonObject productJson = new JsonObject();
                            if (item.getToy() != null) {
                                productJson.addProperty("toyId", item.getToy().getFormattedIdToy());
                                productJson.addProperty("name", item.getToy().getFormattedToyName());
                                productJson.addProperty("quantity", item.getQuantity());
                                productJson.addProperty("importPrice", item.getToy().getPrice()); // Giá nhập
                                productsJson.add(productJson);
                            }
                        }
                    }
                    stockJson.add("products", productsJson);

                    json.add("stock", stockJson);
                } else {
                    json.addProperty("error", "Không tìm thấy phiếu nhập với ID: " + stockId);
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                json.addProperty("error", "Lỗi khi lấy chi tiết phiếu nhập: " + e.getMessage());
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }
        } else {
            json.addProperty("error", "ID phiếu nhập không hợp lệ");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
        out.print(json.toString());
        out.flush();
    }

    /**
     * Tìm kiếm nhà cung cấp cho chức năng autocomplete.
     */
    private void handleSearchSuppliers(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String term = req.getParameter("term");
        List<com.kiendey.model.Supplier> suppliers = supplierDAO.searchSuppliersByName(term); // Cần tạo phương thức này

        Gson gson = new Gson();
        List<JsonObject> result = new ArrayList<>();
        for (com.kiendey.model.Supplier supplier : suppliers) {
            JsonObject obj = new JsonObject();
            obj.addProperty("label", supplier.getName() + " (ID: " + supplier.getFormattedSupplierCode() + ")");
            obj.addProperty("value", supplier.getId());
            obj.addProperty("name", supplier.getName());
            result.add(obj);
        }
        resp.getWriter().write(gson.toJson(result));
    }

    /**
     * Tìm kiếm và lọc danh sách phiếu nhập.
     */
    private void handleSearchAndFilter(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String searchTerm = req.getParameter("searchTerm");
        String status = req.getParameter("status");
        String date = req.getParameter("date");
        int page = 1;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<com.kiendey.model.Stock> stocks = stockDAO.searchAndFilterStocks(searchTerm, status, date, page, DEFAULT_PAGE_SIZE);
        int totalStocks = stockDAO.countFilteredStocks(searchTerm, status, date);
        int totalPages = (int) Math.ceil((double) totalStocks / DEFAULT_PAGE_SIZE);

        List<JsonObject> jsonStocks = new ArrayList<>();
        for (com.kiendey.model.Stock stock : stocks) {
            JsonObject stockJson = new JsonObject();
            stockJson.addProperty("id", stock.getId());
            stockJson.addProperty("formattedId", stock.getFormattedStockCode());
            stockJson.addProperty("supplierName", stock.getSupplier() != null ? stock.getSupplier().getName() : "N/A");
            stockJson.addProperty("StockDate", stock.getStockDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            stockJson.addProperty("totalAmount", stockDAO.getTotalAmount(stock.getId()));
            stockJson.addProperty("status", stock.getStatus().name());
            stockJson.addProperty("statusDisplay", stock.getStatus().name());
            jsonStocks.add(stockJson);
        }

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.add("stocks", new Gson().toJsonTree(jsonStocks));
        jsonResponse.addProperty("totalPages", totalPages);
        jsonResponse.addProperty("currentPage", page);

        resp.getWriter().write(jsonResponse.toString());
    }

    /**
     * Tạo một phiếu nhập mới từ dữ liệu JSON.
     */
    private void handleCreateStock(HttpServletRequest req, HttpServletResponse resp, JsonObject jsonResponse) {
        try {
            BufferedReader reader = req.getReader();
            Gson gson = new Gson();
            JsonObject stockData = gson.fromJson(reader, JsonObject.class);

            com.kiendey.model.Stock newStock = new com.kiendey.model.Stock();
            newStock.setStockDate(LocalDateTime.parse(stockData.get("StockDate").getAsString() + "T00:00:00"));
            newStock.setStatus(StockStatus.valueOf(stockData.get("status").getAsString()));

            // Quan trọng: Thay đổi từ Customer sang Supplier
            com.kiendey.model.Supplier supplier = new com.kiendey.model.Supplier();
            supplier.setId(stockData.get("supplierId").getAsString());
            newStock.setSupplier(supplier);

            List<StockItem> stockItems = new ArrayList<>();
            JsonArray productsArray = stockData.getAsJsonArray("products");

            for (JsonElement productElement : productsArray) {
                JsonObject productJson = productElement.getAsJsonObject();
                StockItem item = new StockItem();
                item.setQuantity(productJson.get("quantity").getAsInt());

                Toy toy = new Toy();
                toy.setId(productJson.get("toyId").getAsString());
                item.setToy(toy);
                item.setStock(newStock); // Liên kết item với phiếu nhập
                stockItems.add(item);
            }
            newStock.setStockItems(stockItems);

            boolean created = stockDAO.createStock(newStock);

            if (created) {
                jsonResponse.addProperty("success", true);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể tạo phiếu nhập.");
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi phía máy chủ: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
        }
    }

    /**
     * Cập nhật trạng thái của một phiếu nhập.
     */
    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp, JsonObject jsonResponse) {
        try {
            BufferedReader reader = req.getReader();
            JsonObject requestJson = JsonParser.parseReader(reader).getAsJsonObject();
            String stockId = requestJson.get("stockId").getAsString();
            String status = requestJson.get("status").getAsString();

            if (stockId != null && status != null) {
                StockStatus stockStatus = StockStatus.valueOf(status);
                boolean updated = stockDAO.updateStockStatus(stockId, stockStatus);
                if (updated) {
                    jsonResponse.addProperty("success", true);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("error", "Không tìm thấy phiếu nhập: " + stockId);
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // ... xử lý lỗi
            }
        } catch (Exception e) {
            // ... xử lý lỗi
        }
    }

    /**
     * Lấy thông tin một sản phẩm (tái sử dụng từ Order servlet).
     */
    private void handleGetToy(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String toyId = req.getParameter("id");
        Toy toy = toyDAO.readToy(toyId);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject json = new JsonObject();
        if (toy != null && !toy.isDeleted()) {
            JsonObject toyJson = new JsonObject();
            toyJson.addProperty("id", toy.getId());
            toyJson.addProperty("name", toy.getFormattedToyName());
            // Đối với phiếu nhập, có thể bạn muốn giá nhập gần nhất thay vì giá bán
            toyJson.addProperty("price", toy.getPrice());
            json.add("toy", toyJson);
        }
        out.print(json.toString());
        out.flush();
    }

    /**
     * Tìm kiếm sản phẩm cho chức năng autocomplete (tái sử dụng từ Order servlet).
     */
    private void handleSearchProducts(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String term = req.getParameter("term");
        List<Toy> toys = toyDAO.searchToysByNameOrId(term);

        Gson gson = new Gson();
        List<JsonObject> result = new ArrayList<>();
        for (Toy toy : toys) {
            JsonObject obj = new JsonObject();
            obj.addProperty("label", toy.getFormattedToyName() + " (" + toy.getFormattedIdToy() + ")");
            obj.addProperty("value", toy.getId());
            obj.addProperty("name", toy.getFormattedToyName());
            obj.addProperty("price", toy.getPrice()); // Giá bán để tham khảo
            result.add(obj);
        }
        resp.getWriter().write(gson.toJson(result));
    }


    /**
     * Lấy dữ liệu và hiển thị trang danh sách phiếu nhập.
     */
    private void displayStockListPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalStocks = Math.toIntExact(stockDAO.getTotalStockCount());
        int totalPages = (int) Math.ceil((double) totalStocks / DEFAULT_PAGE_SIZE);

        List<com.kiendey.model.Stock> stockList = stockDAO.getStocksByPage(currentPage, DEFAULT_PAGE_SIZE);

        // Lấy danh sách nhà cung cấp để hiển thị trong form tạo mới
        List<Supplier> supplierList = supplierDAO.getAllSuppliers(); // Cần tạo phương thức này

        req.setAttribute("stockList", stockList);
        req.setAttribute("supplierList", supplierList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

        // Call jsp files
        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) head.include(req, resp);
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) header.include(req, resp);
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) sidebar.include(req, resp);
        RequestDispatcher stockPage = req.getRequestDispatcher("/stock.jsp"); // Trang JSP cho phiếu nhập
        if (stockPage != null) stockPage.include(req, resp);
        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) footer.include(req, resp);
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) end.include(req, resp);
    }
}