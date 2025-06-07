package com.kiendey.servlet;

import com.google.gson.*;
import com.kiendey.dao.*;
import com.kiendey.dao.impl.*;
import com.kiendey.model.*;
import com.kiendey.common.OrderStatus;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.google.gson.reflect.TypeToken;

@WebServlet("/order")
public class Order extends HttpServlet {
    private OrderDAO orderDAO;
    private ToyDAO toyDAO;
    private UserDAO userDAO;
    private DeliveryMethodDAO deliveryMethodDAO;
    private PaymentMethodDAO paymentMethodDAO;
    private static final int DEFAULT_PAGE_SIZE = 15;

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
                                order.getStatus().name(): null);
                        orderJson.addProperty("coupon", order.getCoupon() != null ?
                                order.getCoupon().getDescription() : null); // Lay decription cua coupon
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
        } else if ("searchCustomers".equals(action)) {
            String term = req.getParameter("term"); // "term" là tham số mặc định của jQuery UI Autocomplete
            List<User> users = userDAO.searchUsersByName(term);// Bạn sẽ cần tạo phương thức này trong DAO

            Gson gson = new Gson();
            List<JsonObject> result = new ArrayList<>();
            for (User user : users) {
                JsonObject obj = new JsonObject();
                //label để trang trí cho đẹp
                obj.addProperty("label", user.getName() + " (ID: " + user.getFormattedUserCode() + ")"); // Hiển thị cho người dùng
                // value là giá trị sẽ được sử dụng trong form
                obj.addProperty("value", user.getId()); // Giá trị sẽ được sử dụng (ID khách hàng)
                obj.addProperty("name", user.getName()); // Tên khách hàng
                result.add(obj);
            }
            resp.getWriter().write(gson.toJson(result));
            return; // Kết thúc sớm

        } else if ("searchProducts".equals(action)) {
            String term = req.getParameter("term");
            // Bạn sẽ cần tạo phương thức này trong DAO để tìm theo cả tên và mã
            List<Toy> toys = toyDAO.searchToysByNameOrId(term);

            Gson gson = new Gson();
            List<JsonObject> result = new ArrayList<>();
            for (Toy toy : toys) {
                JsonObject obj = new JsonObject();
                // Hiển thị cho người dùng cả tên và mã
                obj.addProperty("label", toy.getFormattedToyName() + " (" + toy.getFormattedIdToy() + ")");
                obj.addProperty("value", toy.getId()); // Giá trị chính là mã sản phẩm
                obj.addProperty("name", toy.getFormattedToyName());
                obj.addProperty("price", toy.getPrice());
                result.add(obj);
            }
            resp.getWriter().write(gson.toJson(result));
            return; // Kết thúc sớm
        } else if ("searchAndFilter".equals(action)) {
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

            // Lấy danh sách đơn hàng đã được lọc
            List<com.kiendey.model.Order> orders = orderDAO.searchAndFilterOrders(searchTerm, status, date, page, DEFAULT_PAGE_SIZE);

            // Lấy tổng số kết quả để tính toán phân trang
            int totalOrders = orderDAO.countFilteredOrders(searchTerm, status, date);
            int totalPages = (int) Math.ceil((double) totalOrders / DEFAULT_PAGE_SIZE);

            // Chuyển đổi danh sách Order sang một định dạng JSON đơn giản để gửi về client
            List<JsonObject> jsonOrders = new ArrayList<>();
            for (com.kiendey.model.Order order : orders) {
                JsonObject orderJson = new JsonObject();
                orderJson.addProperty("id", order.getId()); // Gửi ID gốc để xử lý
                orderJson.addProperty("formattedId", order.getFormattedOrderCode());
                orderJson.addProperty("customerName", order.getUser() != null ? order.getUser().getName() : "N/A");
                orderJson.addProperty("orderDate", order.getOrderDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                orderJson.addProperty("totalAmount", orderDAO.getFinalAmount(order.getId()));
                orderJson.addProperty("status", order.getStatus().name());
                orderJson.addProperty("statusDisplay", order.getStatus().getDisplayName()); // Giả sử có hàm này
                orderJson.addProperty("address", order.getAddress() != null ? order.getAddress() : "N/A");

                jsonOrders.add(orderJson);
            }

            // Tạo đối tượng JSON cuối cùng chứa cả danh sách đơn hàng và thông tin phân trang
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.add("orders", new Gson().toJsonTree(jsonOrders));
            jsonResponse.addProperty("totalPages", totalPages);
            jsonResponse.addProperty("currentPage", page);

            resp.getWriter().write(jsonResponse.toString());
            return; // Quan trọng: Kết thúc sớm để không chạy code hiển thị trang HTML bên dưới
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
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        String action = req.getParameter("action");

        if ("create".equals(action)) {
            try {
                // 1. Đọc và phân tích chuỗi JSON từ request
                BufferedReader reader = req.getReader();
                Gson gson = new Gson();
                JsonObject orderData = gson.fromJson(reader, JsonObject.class);

                // 2. Tạo đối tượng Order mới (ID sẽ do Hibernate tự sinh)
                com.kiendey.model.Order newOrder = new com.kiendey.model.Order();

                newOrder.setAddress(orderData.get("address").getAsString());

                // Chuyển đổi chuỗi ngày tháng sang LocalDateTime
                String orderDateStr = orderData.get("orderDate").getAsString();
                newOrder.setOrderDate(LocalDateTime.parse(orderDateStr + "T00:00:00"));

                newOrder.setStatus(OrderStatus.valueOf(orderData.get("status").getAsString()));

                // --- PHẦN SỬA ĐỔI QUAN TRỌNG ---
                // Tạo các đối tượng liên quan bằng cách set ID (dạng String) cho chúng

                // Tạo tham chiếu đến User
                User user = new User();
                // Sửa .getAsInt() -> .getAsString()
                user.setId(orderData.get("customerId").getAsString());
                newOrder.setUser(user);

                // Tạo tham chiếu đến PaymentMethod
                PaymentMethod paymentMethod = new PaymentMethod();
                // Sửa .getAsInt() -> .getAsString()
                paymentMethod.setId(orderData.get("paymentMethodId").getAsString());
                newOrder.setPaymentMethod(paymentMethod);

                // Tạo tham chiếu đến DeliveryMethod
                DeliveryMethod deliveryMethod = new DeliveryMethod();
                // Sửa .getAsInt() -> .getAsString()
                deliveryMethod.setId(orderData.get("deliveryMethodId").getAsString());
                newOrder.setDeliveryMethod(deliveryMethod);

                // Tạo tham chiếu đến Coupon
                Coupon coupon = new Coupon();
                if (orderData.has("couponId") && !orderData.get("couponId").isJsonNull()) {
                    // Sửa .getAsInt() -> .getAsString()
                    coupon.setId(orderData.get("couponId").getAsString());
                    newOrder.setCoupon(coupon);
                } else {
                    newOrder.setCoupon(null); // Không có coupon
                }

                // 3. Tạo danh sách OrderItem
                List<OrderItem> orderItems = new ArrayList<>();
                JsonArray productsArray = orderData.getAsJsonArray("products");

                for (JsonElement productElement : productsArray) {
                    JsonObject productJson = productElement.getAsJsonObject();

                    OrderItem item = new OrderItem();
                    item.setQuantity(productJson.get("quantity").getAsInt());

                    // Tạo tham chiếu đến Toy
                    Toy toy = new Toy();
                    // Sửa .getAsInt() -> .getAsString()
                    toy.setId(productJson.get("toyId").getAsString());
                    item.setToy(toy);

                    // Liên kết item này với đơn hàng của nó
                    item.setOrder(newOrder);

                    orderItems.add(item);
                }
                newOrder.setOrderItems(orderItems);

                // 4. Gọi DAO để lưu vào cơ sở dữ liệu
                // Hibernate sẽ tự động tạo UUID cho newOrder.id
                // và dùng các ID dạng String bạn đã set để tạo khóa ngoại chính xác
                boolean created = orderDAO.createOrder(newOrder);

                if (created) {
                    jsonResponse.addProperty("success", true);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không thể tạo đơn hàng trong cơ sở dữ liệu.");
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

            } catch (Exception e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Lỗi phía máy chủ: " + e.getMessage());
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }

        } else if ("updateStatus".equals(action)) {
            try {
                // Đọc JSON từ body request
                BufferedReader reader = req.getReader();
                JsonObject requestJson = JsonParser.parseReader(reader).getAsJsonObject();
                String orderId = requestJson.has("orderId") ? requestJson.get("orderId").getAsString() : null;
                String status = requestJson.has("status") ? requestJson.get("status").getAsString() : null;

                if (orderId != null && status != null) {
                    // Kiểm tra trạng thái hợp lệ
                    try {
                        OrderStatus orderStatus = OrderStatus.valueOf(status);
                        // Cập nhật trạng thái trong cơ sở dữ liệu
                        boolean updated = orderDAO.updateOrderStatus(orderId, orderStatus);
                        if (updated) {
                            jsonResponse.addProperty("success", true);
                        } else {
                            jsonResponse.addProperty("success", false);
                            jsonResponse.addProperty("error", "Không tìm thấy đơn hàng với ID: " + orderId);
                            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        }
                    } catch (IllegalArgumentException e) {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("error", "Trạng thái không hợp lệ: " + status);
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    }
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("error", "Thiếu orderId hoặc status");
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
            } catch (Exception e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Hành động không hợp lệ: " + action);
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }

        out.print(jsonResponse.toString());
        out.flush();
    }

}