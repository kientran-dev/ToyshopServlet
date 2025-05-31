package com.kiendey.servlet;

import com.kiendey.dao.OrderDAO;
import com.kiendey.dao.impl.OrderDAOImpl;
import com.kiendey.model.Order;
import com.kiendey.model.OrderItem;
import com.kiendey.dto.DailyReportEntry;
import com.kiendey.dto.DailyReportSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/report-day")
public class ReportDay extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        LocalDate selectedDate;
        String dateParam = req.getParameter("date");
        String reportDateType;

        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        if (dateParam != null && !dateParam.isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParam, inputFormatter);
                reportDateType = "custom";
            } catch (DateTimeParseException e) {
                System.err.println("Invalid date parameter: " + dateParam + ". Defaulting to current date.");
                selectedDate = LocalDate.now();
                reportDateType = "today";
            }
        } else {
            selectedDate = LocalDate.now();
            reportDateType = "today";
        }

        LocalDateTime startOfDay = selectedDate.atStartOfDay();
        LocalDateTime endOfDay = selectedDate.atTime(23, 59, 59, 999999999);

        System.out.println("DEBUG: Ngày được chọn (selectedDate): " + selectedDate);
        System.out.println("DEBUG: Khoảng thời gian truy vấn: " + startOfDay + " đến " + endOfDay);

        List<Order> orders = orderDAO.getOrdersByDate(startOfDay, endOfDay);

        if (orders != null) {
            orders = orders.stream()
                    .filter(order -> order != null)
                    .collect(Collectors.toList());
        } else {
            orders = new ArrayList<>();
        }

        System.out.println("DEBUG: Số lượng đơn hàng lấy được từ DAO (sau lọc null): " + orders.size());

        List<DailyReportEntry> dailyEntries = new ArrayList<>();
        double totalAllItemsAmount = 0;
        double totalAllRevenue = 0;
        double totalAllVat = 0;

        double VAT_RATE = 0.10;

        if (!orders.isEmpty()) {
            for (Order order : orders) {
                double orderTotalItemsAmount = 0;
                double orderRevenue = 0;
                double orderVat = 0;

                if (order.getOrderItems() != null) {
                    for (OrderItem item : order.getOrderItems()) {
                        // Corrected logic for price null check and comparison
                        if (item != null && item.getToy() != null) {
                            Double priceObject = item.getToy().getPrice(); // Get the Double object first
                            if (priceObject != null && priceObject > 0) { // Then check for null and compare its value
                                orderTotalItemsAmount += item.getQuantity() * priceObject;
                            }
                        }
                    }
                }

                orderRevenue = orderTotalItemsAmount;
                orderVat = orderRevenue * VAT_RATE;

                // Determine customer name, default to "N/A" if user or user name is null
                String customerName = (order.getUser() != null && order.getUser().getName() != null) ? order.getUser().getName() : "Khách vãng lai";
                // As per previous discussion, employeeName is hardcoded to "N/A"
                String employeeName = "N/A";

                String formattedInvoiceCode = "N/A";
                if (order.getId() != null) {
                    formattedInvoiceCode = "HD" + (order.getId().length() >= 8 ? order.getId().substring(0, 8) : order.getId()).toUpperCase();
                }

                String formattedTime = order.getOrderDate() != null ? order.getOrderDate().format(DateTimeFormatter.ofPattern("HH:mm")) : "N/A";

                // === Thêm logic lọc ở đây ===
                // Chỉ bao gồm hàng nếu Tổng tiền hàng, Doanh thu HOẶC VAT KHÔNG BẰNG 0
                // Nếu cả ba đều bằng 0, hàng sẽ bị loại bỏ.
                if (orderTotalItemsAmount != 0.0 || orderRevenue != 0.0 || orderVat != 0.0) {
                    DailyReportEntry entry = DailyReportEntry.builder()
                            .invoiceCode(formattedInvoiceCode)
                            .customerName(customerName)
                            .employeeName(employeeName)
                            .time(formattedTime)
                            .totalItemsAmount(orderTotalItemsAmount)
                            .revenue(orderRevenue)
                            .vat(orderVat)
                            .build();
                    dailyEntries.add(entry);

                    System.out.println("DEBUG: Đã thêm DailyReportEntry: Mã HD=" + entry.getInvoiceCode() + ", KH=" + entry.getCustomerName() + ", Doanh thu=" + entry.getRevenue());

                    totalAllItemsAmount += orderTotalItemsAmount;
                    totalAllRevenue += orderRevenue;
                    totalAllVat += orderVat;
                } else {
                    System.out.println("DEBUG: Bỏ qua DailyReportEntry do Tổng tiền hàng, Doanh thu và VAT đều bằng 0: Mã HD=" + formattedInvoiceCode + ", KH=" + customerName);
                }
            }
        } else {
            System.out.println("DEBUG: Danh sách đơn hàng rỗng, không có DailyReportEntry nào được tạo.");
        }

        DailyReportSummary summary = DailyReportSummary.builder()
                .totalAllItemsAmount(totalAllItemsAmount)
                .totalAllRevenue(totalAllRevenue)
                .totalAllVat(totalAllVat)
                .build();

        System.out.println("DEBUG: Số lượng DailyReportEntry chuẩn bị gửi đến JSP: " + dailyEntries.size());
        System.out.println("DEBUG: Tổng tiền hàng của tất cả: " + totalAllItemsAmount);
        System.out.println("DEBUG: Tổng doanh thu của tất cả: " + totalAllRevenue);
        System.out.println("DEBUG: Tổng VAT của tất cả: " + totalAllVat);

        req.setAttribute("dailyEntries", dailyEntries);
        req.setAttribute("totalSummary", summary);
        req.setAttribute("reportDate", selectedDate.format(displayFormatter));
        req.setAttribute("reportDateType", reportDateType);
        req.setAttribute("todayFormattedForInput", LocalDate.now().format(inputFormatter));

        jakarta.servlet.RequestDispatcher head = req.getRequestDispatcher("/head.jsp");
        if (head != null) {
            head.include(req, resp);
        }
        jakarta.servlet.RequestDispatcher header = req.getRequestDispatcher("/header.jsp");
        if (header != null) {
            header.include(req, resp);
        }
        jakarta.servlet.RequestDispatcher sidebar = req.getRequestDispatcher("/sidebar.jsp");
        if (sidebar != null) {
            sidebar.include(req, resp);
        }
        jakarta.servlet.RequestDispatcher reportDay = req.getRequestDispatcher("/report_day.jsp");
        if (reportDay != null) {
            reportDay.include(req, resp);
        }
        jakarta.servlet.RequestDispatcher footer = req.getRequestDispatcher("/footer.jsp");
        if (footer != null) {
            footer.include(req, resp);
        }
        jakarta.servlet.RequestDispatcher end = req.getRequestDispatcher("/end.jsp");
        if (end != null) {
            end.include(req, resp);
        }
    }
}