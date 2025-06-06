package com.kiendey.servlet;

import com.kiendey.dao.OrderDAO;
import com.kiendey.dao.impl.OrderDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/report-finance")
public class ReportFinance extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReportFinance.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        OrderDAO orderDAO = new OrderDAOImpl();

        // Default date range: current month
        LocalDate today = LocalDate.now();
        LocalDate defaultStartDate = today.withDayOfMonth(1);
        LocalDate defaultEndDate = today.withDayOfMonth(today.lengthOfMonth());

        LocalDateTime startDate = defaultStartDate.atStartOfDay();
        LocalDateTime endDate = defaultEndDate.atTime(LocalTime.MAX);
        String reportDateDisplay = ""; // For displaying the current report period

        // Parse start and end dates from request parameters if available
        String customDateStartParam = req.getParameter("customDateStart");
        String customDateEndParam = req.getParameter("customDateEnd");
        String selectedYearParam = req.getParameter("selectedYear");
        String timePeriodParam = req.getParameter("timePeriod"); // "month", "quarter", "year"
        String selectedMonthParam = req.getParameter("selectedMonth"); // "1" to "12"
        String selectedQuarterParam = req.getParameter("selectedQuarter"); // "1", "2", "3", "4"


        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        try {
            if (customDateStartParam != null && !customDateStartParam.isEmpty() &&
                    customDateEndParam != null && !customDateEndParam.isEmpty()) {
                // Use custom dates if provided
                startDate = LocalDate.parse(customDateStartParam, dateFormatter).atStartOfDay();
                endDate = LocalDate.parse(customDateEndParam, dateFormatter).atTime(LocalTime.MAX);
                reportDateDisplay = "Từ ngày " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) +
                        " đến ngày " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            } else if (selectedYearParam != null && !selectedYearParam.isEmpty()) {
                int year = Integer.parseInt(selectedYearParam);
                if ("month".equals(timePeriodParam) && selectedMonthParam != null && !selectedMonthParam.isEmpty()) {
                    int month = Integer.parseInt(selectedMonthParam);
                    LocalDate startOfMonth = LocalDate.of(year, month, 1);
                    startDate = startOfMonth.atStartOfDay();
                    endDate = startOfMonth.withDayOfMonth(startOfMonth.lengthOfMonth()).atTime(LocalTime.MAX);
                    reportDateDisplay = "Tháng " + month + " Năm " + year;
                } else if ("quarter".equals(timePeriodParam) && selectedQuarterParam != null && !selectedQuarterParam.isEmpty()) {
                    int quarter = Integer.parseInt(selectedQuarterParam);
                    LocalDate startOfQuarter;
                    LocalDate endOfQuarter;
                    switch (quarter) {
                        case 1:
                            startOfQuarter = LocalDate.of(year, 1, 1);
                            endOfQuarter = LocalDate.of(year, 3, 31);
                            break;
                        case 2:
                            startOfQuarter = LocalDate.of(year, 4, 1);
                            endOfQuarter = LocalDate.of(year, 6, 30);
                            break;
                        case 3:
                            startOfQuarter = LocalDate.of(year, 7, 1);
                            endOfQuarter = LocalDate.of(year, 9, 30);
                            break;
                        case 4:
                            startOfQuarter = LocalDate.of(year, 10, 1);
                            endOfQuarter = LocalDate.of(year, 12, 31);
                            break;
                        default:
                            startOfQuarter = defaultStartDate; // Fallback
                            endOfQuarter = defaultEndDate; // Fallback
                    }
                    startDate = startOfQuarter.atStartOfDay();
                    endDate = endOfQuarter.atTime(LocalTime.MAX);
                    reportDateDisplay = "Quý " + quarter + " Năm " + year;
                } else { // Default to year if no specific month/quarter or time period is "year"
                    startDate = LocalDate.of(year, 1, 1).atStartOfDay();
                    endDate = LocalDate.of(year, 12, 31).atTime(LocalTime.MAX);
                    reportDateDisplay = "Năm " + year;
                }
            } else {
                // If no parameters, use current month defaults
                reportDateDisplay = "Tháng " + defaultStartDate.getMonthValue() + " Năm " + defaultStartDate.getYear();
            }
        } catch (DateTimeParseException | NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Error parsing date or number parameters, using default date range.", e);
            // Revert to defaults if parsing fails
            startDate = defaultStartDate.atStartOfDay();
            endDate = defaultEndDate.atTime(LocalTime.MAX);
            reportDateDisplay = "Tháng " + defaultStartDate.getMonthValue() + " Năm " + defaultStartDate.getYear();
        }

        // 1. Doanh thu bán hàng (Total Sales Revenue)
        double totalSalesRevenue = orderDAO.getTotalSalesRevenue(startDate, endDate);

        // 2. Giảm trừ Doanh thu (Cancelled/Refunded Amount)
        double totalCancelledOrRefundedAmount = orderDAO.getTotalCancelledOrRefundedAmount(startDate, endDate);

        // For simplicity, let's assume 'Giá vốn hàng bán' (Cost of Goods Sold) is a fixed percentage of sales or from stock cost
        // In a real application, you would calculate this based on the cost of the toys sold.
        // For demonstration, let's use a placeholder.
        // If you have a 'cost_price' in Toy, you'd iterate OrderItems and sum (item.quantity * item.toy.costPrice)
        double costOfGoodsSold = totalSalesRevenue * 0.70; // Example: 70% of revenue is COGS, adjust as needed

        // Chi phí (other expenses) - Placeholder. You would fetch these from other DAOs/tables if available.
        double totalExpenses = 0.0; // Example: can include staff salaries, voucher costs etc.

        // Thu nhập khác (Other Income) - Placeholder.
        double otherIncome = 0.0; // Example: fees from returns, discounts from suppliers etc.

        // Calculate metrics
        double netSalesRevenue = totalSalesRevenue - totalCancelledOrRefundedAmount;
        double grossProfit = netSalesRevenue - costOfGoodsSold;
        double operatingProfit = grossProfit - totalExpenses;
        double netProfit = operatingProfit + otherIncome; // Assuming no other expenses here.

        // Get current stock quantity
        double totalCurrentStockQuantity = orderDAO.getTotalCurrentStockQuantity(); //


        // Set attributes for JSP
        req.setAttribute("reportDateDisplay", reportDateDisplay);
        req.setAttribute("currentDate", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        req.setAttribute("totalSalesRevenue", totalSalesRevenue);
        req.setAttribute("totalCancelledOrRefundedAmount", totalCancelledOrRefundedAmount);
        req.setAttribute("netSalesRevenue", netSalesRevenue);
        req.setAttribute("costOfGoodsSold", costOfGoodsSold);
        req.setAttribute("grossProfit", grossProfit);
        req.setAttribute("totalExpenses", totalExpenses);
        req.setAttribute("operatingProfit", operatingProfit);
        req.setAttribute("otherIncome", otherIncome);
        req.setAttribute("netProfit", netProfit);
        req.setAttribute("totalCurrentStockQuantity", totalCurrentStockQuantity); // Pass stock quantity

        // Forward to JSP
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
        jakarta.servlet.RequestDispatcher reportFinance = req.getRequestDispatcher("/report_finance.jsp");
        if (reportFinance != null) {
            reportFinance.include(req, resp);
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp); // Process POST requests the same way as GET
    }
}