<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <%-- 1. Import lớp Year từ gói java.time --%>
                    <%@ page import="java.time.Year" %>
                        <% request.setAttribute("currentYear", Year.now().getValue()); %>
                            <main id="main" class="main">
                                <div class="pagetitle">
                                    <h1>Báo cáo tài chính</h1>
                                    <nav>
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                                            <li class="breadcrumb-item"><a href="#">Thống kê</a></li>
                                            <li class="breadcrumb-item active">Tài chính</li>
                                        </ol>
                                    </nav>
                                </div>

                                <div class="row">
                                    <div class="col-lg-3 col-md-4 sidebar-main">
                                        <%-- Form để gửi các tham số lọc đến servlet --%>
                                            <form action="${pageContext.request.contextPath}/report-finance"
                                                method="GET" id="reportFilterForm">
                                                <div class="sidebar-section">
                                                    <h5 class="mb-3">Kiểu hiển thị</h5>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="displayType"
                                                            id="report" value="report" checked>
                                                        <label class="form-check-label" for="report">Báo cáo</label>
                                                    </div>
                                                </div>

                                                <div class="sidebar-section">
                                                    <h5 class="mb-3">Thời gian</h5>
                                                    <select class="form-select mb-3" name="selectedYear"
                                                        id="selectedYear">
                                                        <%-- Tạo danh sách các năm tự động từ năm hiện tại lùi về 5 năm
                                                            bằng JSTL --%>
                                                            <c:forEach var="i" begin="${currentYear - 5}"
                                                                end="${currentYear}" step="1">
                                                                <option value="${i}" ${param.selectedYear eq i
                                                                    ? 'selected' : '' }>${i}</option>
                                                            </c:forEach>
                                                    </select>

                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="timePeriod"
                                                            id="month" value="month" ${param.timePeriod eq 'month' ||
                                                            param.timePeriod eq null ? 'checked' : '' }>
                                                        <label class="form-check-label" for="month">Theo
                                                            Tháng</label>
                                                    </div>
                                                    <div id="monthSelection" class="mt-2 mb-3">
                                                        <select class="form-select" name="selectedMonth">
                                                            <c:forEach var="m" begin="1" end="12">
                                                                <option value="${m}" ${param.selectedMonth eq m
                                                                    ? 'selected' : '' }>Tháng ${m}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="timePeriod"
                                                            id="quarter" value="quarter" ${param.timePeriod eq 'quarter'
                                                            ? 'checked' : '' }>
                                                        <label class="form-check-label" for="quarter">Theo
                                                            Quý</label>
                                                    </div>
                                                    <div id="quarterSelection" class="mt-2 mb-3" style="display: none;">
                                                        <select class="form-select" name="selectedQuarter">
                                                            <c:forEach var="q" begin="1" end="4">
                                                                <option value="${q}" ${param.selectedQuarter eq q
                                                                    ? 'selected' : '' }>Quý ${q}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="timePeriod"
                                                            id="year" value="year" ${param.timePeriod eq 'year'
                                                            ? 'checked' : '' }>
                                                        <label class="form-check-label" for="year">Theo Năm</label>
                                                    </div>

                                                    <div class="form-check mt-3">
                                                        <input class="form-check-input" type="radio" name="timePeriod"
                                                            id="custom" value="custom" ${param.customDateStart ne null
                                                            and not empty param.customDateStart ? 'checked' : '' }>
                                                        <label class="form-check-label" for="custom">Tùy
                                                            chỉnh</label>
                                                    </div>
                                                    <div id="customDateRange" class="mt-2" style="display: none;">
                                                        <input type="date" class="form-control" id="customDateStart"
                                                            name="customDateStart" value="${param.customDateStart}">
                                                        <input type="date" class="form-control mt-2" id="customDateEnd"
                                                            name="customDateEnd" value="${param.customDateEnd}">
                                                    </div>
                                                    <button type="submit" class="btn btn-primary w-100 mt-3">Xem báo
                                                        cáo</button>
                                                </div>
                                            </form>
                                    </div>

                                    <div class="col-lg-9 col-md-8">
                                        <div class="card p-4">
                                            <div class="d-flex justify-content-end mb-3"
                                                style="position: absolute; top: 20px; right: 20px;">
                                                <button class="btn btn-primary me-2" id="printReport">
                                                    <i class="bi bi-printer"></i> In báo cáo
                                                </button>
                                                <button class="btn btn-success me-2" id="exportExcel">
                                                    <i class="bi bi-file-earmark-excel"></i> Xuất Excel
                                                </button>
                                                <button class="btn btn-info" id="sendEmail">
                                                    <i class="bi bi-envelope"></i> Gửi Email
                                                </button>
                                            </div>
                                            <p class="text-muted">Ngày lập: <strong>${currentDate}</strong></p>
                                            <h5 class="text-center">Báo cáo kết quả hoạt động kinh doanh</h5>
                                            <p class="text-center text-muted">${reportDateDisplay}</p>
                                            <p class="text-center text-muted">Chi nhánh trung tâm</p>

                                            <table class="table table-bordered mt-4">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Chỉ tiêu</th>
                                                        <th class="text-center">Tổng</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>Doanh thu bán hàng (1)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${totalSalesRevenue}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Giảm trừ Doanh thu (2 = 2.1+2.2)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${totalCancelledOrRefundedAmount}"
                                                                type="number" pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Chiết khấu hóa đơn (2.1)</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Giá trị hàng bán bị trả lại (2.2)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${totalCancelledOrRefundedAmount}"
                                                                type="number" pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Doanh thu thuần (3=1-2)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${netSalesRevenue}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Giá vốn hàng bán (4)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${costOfGoodsSold}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Lợi nhuận gộp về bán hàng (5=3-4)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${grossProfit}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Chi phí (6)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${totalExpenses}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Chi phí voucher</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Phí trả ĐTGH</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Xuất hủy hàng hóa</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Giá trị thanh toán bằng điểm</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Chiết khấu thanh toán cho khách</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Chi trả lương NV</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td>Lợi nhuận từ hoạt động kinh doanh (7=5-6)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${operatingProfit}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Thu nhập khác (8)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${otherIncome}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Phí trả hàng</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Chiết khấu thanh toán từ NCC</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td class="sub-item">Chi phí khác (9)</td>
                                                        <td class="text-end">0</td> <%-- Placeholder, adjust as needed
                                                            --%>
                                                    </tr>
                                                    <tr>
                                                        <td>Lợi nhuận thuần (10=7+8-9)</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${netProfit}" type="number"
                                                                pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Tổng số lượng tồn kho hiện tại</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${totalCurrentStockQuantity}"
                                                                type="number" pattern="#,##0" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p class="text-muted text-center mt-3">Chi nhánh trung tâm:</p>
                                        </div>
                                    </div>
                                </div>
                            </main>
                            <style>
                                /* Your existing CSS here */
                                .sidebar-main {
                                    position: fixed;
                                    top: 70px;
                                    right: 0;
                                    width: 20%;
                                    height: calc(100vh - 70px);
                                    z-index: 1020;
                                    overflow-y: auto;
                                    background-color: #ffffff;
                                    border-left: 1px solid #e0e0e0;
                                    box-shadow: -2px 0 6px rgba(0, 0, 0, 0.1);
                                    padding: 16px;
                                }

                                .main-content {
                                    margin-right: 20%;
                                }

                                .sidebar-wrapper {
                                    padding: 16px;
                                    background-color: #ffffff;
                                    border-radius: 8px;
                                }

                                .card {
                                    background-color: #ffffff;
                                    border: 1px solid #e0e0e0;
                                    border-radius: 8px;
                                    padding: 24px;
                                    margin-bottom: 24px;
                                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                                }

                                .card h5 {
                                    font-size: 28px;
                                    font-weight: bold;
                                    color: #012970;
                                    margin-bottom: 16px;
                                    text-align: center;
                                }

                                .sidebar-section {
                                    margin-bottom: 16px;
                                    padding: 16px;
                                    background-color: #ffffff;
                                    border: 1px solid #e0e0e0;
                                    border-radius: 8px;
                                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                                }

                                .sidebar-section h5 {
                                    font-size: 16px;
                                    font-weight: bold;
                                    color: #012970;
                                    margin-bottom: 12px;
                                }

                                .sidebar-section .form-control,
                                .sidebar-section .form-select {
                                    margin-top: 8px;
                                    border-radius: 4px;
                                }

                                .sidebar-section .form-check {
                                    margin-bottom: 8px;
                                }

                                .sidebar-section .form-check-label {
                                    font-size: 14px;
                                    color: #6c757d;
                                }

                                .text-center .btn {
                                    padding: 10px 20px;
                                    font-size: 14px;
                                    border-radius: 5px;
                                }

                                .gap-3>* {
                                    margin-left: 10px;
                                }

                                .d-flex.justify-content-end .btn {
                                    padding: 10px 20px;
                                    font-size: 14px;
                                    border-radius: 5px;
                                }

                                .d-flex.justify-content-end .btn+.btn {
                                    margin-left: 10px;
                                }

                                .d-flex.justify-content-end {
                                    margin-top: -10px;
                                }

                                .d-flex.justify-content-end {
                                    position: absolute;
                                    top: 20px;
                                    right: 20px;
                                    z-index: 10;
                                }

                                .d-flex.justify-content-end .btn {
                                    padding: 10px 20px;
                                    font-size: 14px;
                                    border-radius: 5px;
                                }

                                .d-flex.justify-content-end .btn+.btn {
                                    margin-left: 10px;
                                }

                                #chart1,
                                #chart2 {
                                    height: 400px;
                                    background-color: #f9f9f9;
                                    border-radius: 8px;
                                    padding: 16px;
                                }

                                .card+.card {
                                    margin-top: 100px;
                                }

                                /* Main Content */
                                .card {
                                    background-color: #ffffff;
                                    border: 1px solid #e0e0e0;
                                    border-radius: 8px;
                                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                                    margin-bottom: 24px;
                                }

                                .card h5 {
                                    font-size: 26px;
                                    font-weight: bold;
                                    color: #012970;
                                    margin-bottom: 16px;
                                }

                                .table {
                                    width: 100%;
                                    border-collapse: collapse;
                                }

                                .table th {
                                    background-color: #f9f9f9;
                                    font-weight: bold;
                                    text-align: left;
                                }

                                .table td,
                                .table th {
                                    padding: 12px;
                                    border: 1px solid #e0e0e0;
                                }

                                .table .text-end {
                                    text-align: right;
                                }

                                .text-muted {
                                    color: #6c757d;
                                }

                                .text-center {
                                    text-align: center;
                                }

                                .table tbody tr td {
                                    padding-left: 8px;
                                }

                                .table tbody tr td.sub-item {
                                    padding-left: 32px;
                                }

                                @media print {

                                    .sidebar-main,
                                    .sidebar,
                                    .header,
                                    .back-to-top,
                                    .d-flex.justify-content-end,
                                    .sidebar-section,
                                    .breadcrumb,
                                    select,
                                    input[type="radio"],
                                    input[type="date"],
                                    label[for="report"],
                                    label[for="month"],
                                    label[for="quarter"],
                                    label[for="year"] {
                                        display: none !important;
                                    }

                                    body,
                                    .main,
                                    .main-content,
                                    .card {
                                        margin: 0 !important;
                                        padding: 0 !important;
                                        box-shadow: none !important;
                                        background: #fff !important;
                                    }

                                    .col-lg-9,
                                    .col-md-8 {
                                        width: 100% !important;
                                        max-width: 100% !important;
                                        flex: 0 0 100% !important;
                                    }
                                }
                            </style>


                            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    // Function to toggle display of date/month/quarter inputs
                                    function toggleTimePeriodInputs() {
                                        var timePeriod = document.querySelector('input[name="timePeriod"]:checked').value;
                                        document.getElementById('monthSelection').style.display = 'none';
                                        document.getElementById('quarterSelection').style.display = 'none';
                                        document.getElementById('customDateRange').style.display = 'none';

                                        if (timePeriod === 'month') {
                                            document.getElementById('monthSelection').style.display = 'block';
                                        } else if (timePeriod === 'quarter') {
                                            document.getElementById('quarterSelection').style.display = 'block';
                                        } else if (timePeriod === 'custom') {
                                            document.getElementById('customDateRange').style.display = 'block';
                                        }
                                    }

                                    // Add event listeners to radio buttons
                                    document.querySelectorAll('input[name="timePeriod"]').forEach(function (radio) {
                                        radio.addEventListener('change', toggleTimePeriodInputs);
                                    });

                                    // Initial call to set correct visibility based on default checked radio or request parameters
                                    toggleTimePeriodInputs();

                                    // Set default month/quarter/year based on current date if no param is set
                                    const urlParams = new URLSearchParams(window.location.search);
                                    const selectedYear = urlParams.get('selectedYear');
                                    const timePeriod = urlParams.get('timePeriod');
                                    const selectedMonth = urlParams.get('selectedMonth');
                                    const selectedQuarter = urlParams.get('selectedQuarter');

                                    if (!selectedYear) {
                                        // Logic to set default year, month, quarter if no parameters are in the URL
                                        const currentYear = new Date().getFullYear();
                                        const currentMonth = new Date().getMonth() + 1; // getMonth() is 0-indexed
                                        const currentQuarter = Math.ceil(currentMonth / 3);

                                        document.getElementById('selectedYear').value = currentYear;

                                        // Set default month or quarter based on current time
                                        if (!timePeriod || timePeriod === 'month') {
                                            document.querySelector('input[name="timePeriod"][value="month"]').checked = true;
                                            document.querySelector('#monthSelection select').value = currentMonth;
                                        } else if (timePeriod === 'quarter') {
                                            document.querySelector('input[name="timePeriod"][value="quarter"]').checked = true;
                                            document.querySelector('#quarterSelection select').value = currentQuarter;
                                        }
                                        toggleTimePeriodInputs(); // Re-call to ensure correct display after setting defaults
                                    }

                                    // Print functionality
                                    document.getElementById('printReport').addEventListener('click', function () {
                                        window.print();
                                    });

                                    // Export to Excel functionality
                                    document.getElementById('exportExcel').addEventListener('click', function () {
                                        // Get the table element
                                        const table = document.querySelector('table');
                                        // Create a workbook and a worksheet
                                        const ws = XLSX.utils.table_to_sheet(table);
                                        const wb = XLSX.utils.book_new();
                                        XLSX.utils.book_append_sheet(wb, ws, "Financial Report");

                                        // Define the filename
                                        const filename = "Bao_cao_tai_chinh.xlsx";

                                        // Write the workbook to a file
                                        XLSX.writeFile(wb, filename);
                                    });

                                    // Send Email functionality (Placeholder)
                                    document.getElementById('sendEmail').addEventListener('click', function () {
                                        alert('Chức năng Gửi Email chưa được triển khai.');
                                        // You would typically open a modal or redirect to a servlet
                                        // for handling email sending on the server-side.
                                    });
                                });
                            </script>