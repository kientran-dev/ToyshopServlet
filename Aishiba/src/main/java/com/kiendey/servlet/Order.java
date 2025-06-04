package com.kiendey.servlet;

import com.kiendey.dao.*;
import com.kiendey.dao.impl.*;
import com.kiendey.model.*;
import com.kiendey.common.OrderStatus;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

@WebServlet("/order")
public class Order extends HttpServlet {
    private OrderDAO orderDAO;
    private ToyDAO toyDAO;
    private UserDAO userDAO;
    private DeliveryMethodDAO deliveryMethodDAO;
    private PaymentMethodDAO paymentMethodDAO;
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAOImpl();
        toyDAO = new ToyDAOImpl();
        userDAO = new UserDAOImpl();
        deliveryMethodDAO = new DeliveryMethodDAOImpl();
        paymentMethodDAO = new PaymentMethodDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("getDetails".equals(action)) {
            // Xử lý lấy chi tiết đơn hàng
            String orderId = req.getParameter("id");
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            JsonObject json = new JsonObject();

            if (orderId != null && !orderId.trim().isEmpty()) {
                try {
                    com.kiendey.model.Order order = orderDAO.readOrder(orderId);
                    if (order != null) {
                        JsonObject orderJson = new JsonObject();
                        orderJson.addProperty("id", order.getFormattedOrderCode());
                        orderJson.addProperty("orderDate", order.getOrderDate() != null ?
                                order.getOrderDate().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null);
                        orderJson.addProperty("address", order.getAddress());
                        // Trả về tên phương thức thanh toán
                        //Lưu ý trả về getDisplayName() vì GSon bắt trả về String, Number, Boolean, hoặc null
                        orderJson.addProperty("paymentMethod", order.getPaymentMethod() != null ?
                                order.getPaymentMethod().getPaymentMethod().getDisplayName() : null); // Giả sử PaymentMethod có getName()
                        // Trả về tên phương thức giao hàng
                        orderJson.addProperty("deliveryMethod", order.getDeliveryMethod() != null ?
                                order.getDeliveryMethod().getDeliveryMethodName().getDisplayName() : null);
                        orderJson.addProperty("status", order.getStatus() != null ?
                                order.getStatus().getDisplayName() : null);

                        // Thông tin khách hàng
                        JsonObject userJson = new JsonObject();
                        if (order.getUser() != null) {
                            userJson.addProperty("name", order.getUser().getName());
                        }
                        orderJson.add("user", userJson);

                        // Danh sách sản phẩm
                        List<OrderItem> orderItems = order.getOrderItems();
                        List<JsonObject> productsJson = new ArrayList<>();
                        if (orderItems != null) {
                            for (OrderItem item : orderItems) {
                                JsonObject productJson = new JsonObject();
                                if (item.getToy() != null) {
                                    productJson.addProperty("toyId", item.getToy().getFormattedIdToy());
                                    productJson.addProperty("name", item.getToy().getFormattedToyName());
                                    productJson.addProperty("quantity", item.getQuantity());
                                    productJson.addProperty("price", item.getToy().getPrice());
                                    productsJson.add(productJson);
                                }
                            }
                        }
                        orderJson.add("products", new Gson().toJsonTree(productsJson));

                        json.add("order", orderJson);
                    } else {
                        json.addProperty("error", "Không tìm thấy đơn hàng với ID: " + orderId);
                        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    }
                } catch (Exception e) {
                    json.addProperty("error", "Lỗi khi lấy chi tiết đơn hàng: " + e.getMessage());
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    e.printStackTrace(); // Ghi log lỗi để debug
                }
            } else {
                json.addProperty("error", "ID đơn hàng không hợp lệ");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            out.print(json.toString());
            out.flush();
            return;
        } else if ("getToy".equals(action)) {
            // Lấy thông tin sản phẩm và tồn kho từ Toy
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
                toyJson.addProperty("price", toy.getPrice());
                json.add("toy", toyJson);
            }
            out.print(json.toString());
            out.flush();
            return;
        }

        // Hiển thị danh sách đơn hàng (mặc định)
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
                currentPage = 1;
            }
        }

        int totalOrders = orderDAO.getTotalOrderCount();
        int totalPages = (int) Math.ceil((double) totalOrders / DEFAULT_PAGE_SIZE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (totalPages == 0 && currentPage > 1) {
            currentPage = 1;
        }

        List<com.kiendey.model.Order> orderList = orderDAO.getOrdersByPage(currentPage, DEFAULT_PAGE_SIZE);
        List<Date> orderDateList = new ArrayList<>();
        List<Double> totalAmountList = new ArrayList<>();
        for (com.kiendey.model.Order order : orderList) {
            LocalDateTime orderDate = order.getOrderDate();
            Date date = orderDate != null ? Date.from(orderDate.atZone(java.time.ZoneId.systemDefault()).toInstant()) : null;
            orderDateList.add(date);
            double totalAmount = orderDAO.getFinalAmount(order.getId());
            totalAmountList.add(totalAmount);
        }

        List<User> customerList = userDAO.getAllUsers();
        List<PaymentMethod> paymentMethods = paymentMethodDAO.getAllPaymentMethods();
        List<DeliveryMethod> deliveryMethods = deliveryMethodDAO.getAllDeliveryMethods();

        req.setAttribute("customerList", customerList);
        req.setAttribute("paymentMethods", paymentMethods);
        req.setAttribute("deliveryMethods", deliveryMethods);
        req.setAttribute("orderList", orderList);
        req.setAttribute("orderDateList", orderDateList);
        req.setAttribute("totalAmountList", totalAmountList);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

        RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) head.include(req, resp);
        RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) header.include(req, resp);
        RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) sidebar.include(req, resp);
        RequestDispatcher order = req.getRequestDispatcher("/order.jsp");
        if (order != null) order.include(req, resp);
        RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) footer.include(req, resp);
        RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) end.include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // [Mã doPost giữ nguyên như bạn đã cung cấp]
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        String action = req.getParameter("action");
        if ("create".equals(action)) {
            // [Logic tạo đơn hàng giữ nguyên]
            // ...
        }
        out.print(jsonResponse.toString());
        out.flush();
    }

    // DTO cho OrderItem
    private static class OrderItemDTO {
        private String toyId;
        private int quantity;
        private double price;

        public String getToyId() { return toyId; }
        public void setToyId(String toyId) { this.toyId = toyId; }
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
    }
}