<%-- Created by IntelliJ IDEA. User: PC Date: 5/9/2025 Time: 12:02 AM To change this template use File | Settings | File
    Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Báo cáo cuối ngày</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Thống kê</a></li>
                <li class="breadcrumb-item active">Cuối ngày</li>
            </ol>
        </nav>
    </div>
    </div>
    </div>
    <div class="row">
        <div class="col-lg-9 col-md-8">
            <div class="card p-4">
                <div class="d-flex justify-content-end mb-3">
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

                <p class="text-muted">Ngày lập: <strong id="currentDate"></strong></p>

                <script>
                    const currentDate = new Date();
                    const formattedDate = currentDate.toLocaleString('vi-VN', {
                        day: '2-digit',
                        month: '2-digit',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                    });
                    document.getElementById('currentDate').textContent = formattedDate;
                </script>

                <h3 class="text-center">Báo cáo cuối ngày về bán hàng</h3>
                <p class="text-center text-muted">Ngày bán: <strong
                        id="reportSalesDate">${reportDate}</strong></p>
                <p class="text-center text-muted">Chi nhánh: Chi nhánh trung tâm</p>

                <table class="table table-bordered mt-4">
                    <thead class="table-light">
                    <tr>
                        <th>Mã chứng từ</th>
                        <th>Khách hàng</th>
                        <th>Nhân viên</th>
                        <th>Thời gian</th>
                        <th>Tổng tiền hàng</th>
                        <th>Doanh thu</th>
                        <th>VAT</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="entry" items="${dailyEntries}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${entry.invoiceCode != null && entry.invoiceCode != ''}">
                                        ${entry.invoiceCode}
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${entry.customerName != null && entry.customerName != ''}">
                                        ${entry.customerName}
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${entry.employeeName != null && entry.employeeName != ''}">
                                        ${entry.employeeName}
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${entry.time != null && entry.time != ''}">
                                        ${entry.time}
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <c:choose>
                                    <c:when test="${entry.totalItemsAmount != null}">
                                        <fmt:formatNumber value="${entry.totalItemsAmount}" type="currency"
                                                          currencySymbol="" maxFractionDigits="0" />
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <c:choose>
                                    <c:when test="${entry.revenue != null}">
                                        <fmt:formatNumber value="${entry.revenue}" type="currency"
                                                          currencySymbol="" maxFractionDigits="0" />
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <c:choose>
                                    <c:when test="${entry.vat != null}">
                                        <fmt:formatNumber value="${entry.vat}" type="currency"
                                                          currencySymbol="" maxFractionDigits="0" />
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr class="table-primary fw-bold">
                        <td colspan="4" class="text-end">Tổng cộng</td>
                        <td class="text-end">
                            <c:choose>
                                <c:when test="${totalSummary.totalAllItemsAmount != null}">
                                    <fmt:formatNumber value="${totalSummary.totalAllItemsAmount}"
                                                      type="currency" currencySymbol="" maxFractionDigits="0" />
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <c:choose>
                                <c:when test="${totalSummary.totalAllRevenue != null}">
                                    <fmt:formatNumber value="${totalSummary.totalAllRevenue}"
                                                      type="currency" currencySymbol="" maxFractionDigits="0" />
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <c:choose>
                                <c:when test="${totalSummary.totalAllVat != null}">
                                    <fmt:formatNumber value="${totalSummary.totalAllVat}" type="currency"
                                                      currencySymbol="" maxFractionDigits="0" />
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    </tbody>
                </table>

            </div>
        </div>

        <div class="col-lg-3 col-md-4 sidebar-main">
            <div class="sidebar-section">
                <h5 class="mt-4 mb-3">Mối quan tâm</h5>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="sales" checked>
                    <label class="form-check-label" for="sales">Bán hàng</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="expenses">
                    <label class="form-check-label" for="expenses">Thu chi</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="inventory">
                    <label class="form-check-label" for="inventory">Hàng hóa</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="summary">
                    <label class="form-check-label" for="summary">Tổng hợp</label>
                </div>
            </div>

            <div class="sidebar-section">
                <h5 class="mt-4 mb-3">Thời gian</h5>
                <form action="${pageContext.request.contextPath}/report-day" method="GET"
                      id="reportFilterForm">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="timeOption" id="todayRadio"
                               value="today" ${empty param.date ? 'checked' : '' }>
                        <label class="form-check-label" for="todayRadio">Hôm nay</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="timeOption" id="customRadio"
                               value="custom" ${not empty param.date ? 'checked' : '' }>
                        <label class="form-check-label" for="customRadio">Lựa chọn khác</label>
                    </div>
                    <input type="date" class="form-control mt-2" id="customDateInput" name="date"
                           value="${param.date != null ? param.date : ''}" autocomplete="off">
                    <button type="submit" class="btn btn-primary mt-2" id="applyFilter">Áp dụng</button>
                </form>
            </div>

            <div class="sidebar-section">
                <h5 class="mt-4 mb-3">Khách hàng</h5>
                <input type="text" class="form-control" placeholder="Theo mã, tên, điện thoại">
            </div>

            <div class="sidebar-section">
                <h5 class="mt-4 mb-3">Nhân viên</h5>
                <input type="text" class="form-control" placeholder="Nhập tên nhân viên">
            </div>

            <div class="sidebar-section">
                <h5 class="mt-4 mb-3">Người tạo</h5>
                <input type="text" class="form-control" placeholder="Nhập tên người tạo">
            </div>

            <div class="sidebar-section">
                <h5 class="mt-4 mb-3">Phương thức thanh toán</h5>
                <select class="form-select">
                    <option selected>Chọn phương thức...</option>
                    <option value="1">Tiền mặt</option>
                    <option value="2">Chuyển khoản</option>
                </select>
            </div>
        </div>
    </div>
    </div>
</main>

<style>
    /* Định vị sidebar trong main */
    .sidebar-main {
        position: fixed;
        /* Cố định vị trí */
        top: 70px;
        /* Khoảng cách từ trên xuống để không chèn lên header */
        right: 0;
        /* Sát cạnh phải màn hình */
        width: 20%;
        /* Chiếm 20% chiều rộng màn hình */
        height: calc(100vh - 70px);
        /* Chiều cao toàn màn hình trừ chiều cao của header */
        z-index: 1020;
        /* Đảm bảo nằm trên các phần tử khác */
        overflow-y: auto;
        /* Cuộn dọc nếu nội dung quá dài */
        background-color: #ffffff;
        /* Màu nền trắng */
        border-left: 1px solid #e0e0e0;
        /* Viền bên trái */
        box-shadow: -2px 0 6px rgba(0, 0, 0, 0.1);
        /* Đổ bóng bên trái */
        padding: 16px;
        /* Khoảng cách bên trong */
    }

    /* Đảm bảo nội dung chính không bị chồng lấn */
    .main-content {
        margin-right: 20%;
        /* Đẩy nội dung chính sang trái để nhường chỗ cho sidebar */
    }

    /* Tùy chỉnh khung sidebar */
    .sidebar-wrapper {
        padding: 16px;
        /* Khoảng cách bên trong */
        background-color: #ffffff;
        /* Màu nền trắng */
        border-radius: 8px;
        /* Bo góc */
    }

    /* Khung nhỏ cho từng phần */
    .card {
        background-color: #f9f9f9;
        /* Màu nền sáng hơn */
        border: 1px solid #e0e0e0;
        /* Viền màu xám nhạt */
        border-radius: 4px;
        /* Bo góc nhẹ */
        padding: 16px;
        /* Khoảng cách bên trong */
        margin-bottom: 16px;
        /* Khoảng cách giữa các khung */
    }

    /* Tiêu đề của từng phần */
    .card h5 {
        font-size: 16px;
        /* Cỡ chữ tiêu đề */
        font-weight: bold;
        /* In đậm tiêu đề */
        color: #012970;
        /* Màu chữ tiêu đề */
        margin-bottom: 12px;
        /* Khoảng cách dưới tiêu đề */
    }

    /* Tùy chỉnh từng phần trong sidebar */
    .sidebar-section {
        margin-bottom: 16px;
        /* Khoảng cách giữa các phần */
        padding: 16px;
        background-color: #ffffff;
        /* Nền trắng */
        border: 1px solid #e0e0e0;
        /* Viền màu xám nhạt */
        border-radius: 8px;
        /* Bo góc */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        /* Đổ bóng nhẹ */
    }

    /* Tiêu đề của từng phần */
    .sidebar-section h5 {
        font-size: 16px;
        font-weight: bold;
        color: #012970;
        margin-bottom: 12px;
    }

    /* Input và select */
    .sidebar-section .form-control,
    .sidebar-section .form-select {
        margin-top: 8px;
        border-radius: 4px;
    }

    /* Radio button và nhãn */
    .sidebar-section .form-check {
        margin-bottom: 8px;
    }

    .sidebar-section .form-check-label {
        font-size: 14px;
        color: #6c757d;
    }

    .text-center .btn {
        padding: 10px 20px;
        /* Tăng kích thước nút */
        font-size: 14px;
        /* Cỡ chữ */
        border-radius: 5px;
        /* Bo góc nhẹ */
    }

    .gap-3>* {
        margin-left: 10px;
        /* Khoảng cách giữa các nút */
    }

    .d-flex.justify-content-end .btn {
        padding: 10px 20px;
        /* Tăng kích thước nút */
        font-size: 14px;
        /* Cỡ chữ */
        border-radius: 5px;
        /* Bo góc nhẹ */
    }

    .d-flex.justify-content-end .btn+.btn {
        margin-left: 10px;
        /* Khoảng cách giữa các nút */
    }

    .d-flex.justify-content-end {
        margin-top: -10px;
        /* Điều chỉnh khoảng cách với tiêu đề */
    }

    .d-flex.justify-content-end .btn {
        padding: 8px 16px;
        /* Kích thước nút */
        font-size: 14px;
        /* Cỡ chữ */
        border-radius: 5px;
        /* Bo góc nhẹ */
    }

    .d-flex.justify-content-end .btn+.btn {
        margin-left: 10px;
        /* Khoảng cách giữa các nút */
    }

    @media print {

        /* Ẩn header, sidebar, các nút chức năng khi in */
        #header,
        #sidebar,
        .sidebar-main,
        .d-flex.justify-content-end,
        .sidebar-section,
        .back-to-top {
            display: none !important;
        }

        /* Căn chỉnh main cho đẹp khi in */
        #main.main,
        .main-content,
        .col-lg-9,
        .col-md-8 {
            width: 100% !important;
            max-width: 100% !important;
            margin: 0 !important;
            float: none !important;
            position: static !important;
        }

        /* Xóa margin/padding không cần thiết */
        body,
        html,
        #main.main {
            padding: 0 !important;
            margin: 0 !important;
            background: #fff !important;
        }

        /* Bảng báo cáo full width */
        table.table {
            width: 100% !important;
            font-size: 14px;
        }

        /* Ẩn các phần không cần thiết khác nếu có */
    }
</style>

<script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>

<script>
    // Hàm in báo cáo
    document.getElementById('printReport').addEventListener('click', function () {
        window.print();
    });

    // Hàm xuất Excel
    document.getElementById('exportExcel').addEventListener('click', function () {
        var table = document.querySelector('table.table');
        var wb = XLSX.utils.table_to_book(table, { sheet: "Báo cáo cuối ngày" });
        XLSX.writeFile(wb, 'baocao_cuoingay.xlsx');
    });

    // Hàm gửi Email
    document.getElementById('sendEmail').addEventListener('click', function () {
        alert('Chức năng gửi Email đang được phát triển!');
    });

    // JavaScript để xử lý lựa chọn ngày và gửi form
    document.addEventListener('DOMContentLoaded', function () {
        const todayRadio = document.getElementById('todayRadio');
        const customRadio = document.getElementById('customRadio');
        const customDateInput = document.getElementById('customDateInput');
        const reportFilterForm = document.getElementById('reportFilterForm');

        // Khởi tạo trạng thái input date
        if (customRadio.checked) {
            customDateInput.disabled = false;
        } else {
            customDateInput.disabled = true;
        }

        todayRadio.addEventListener('change', function () {
            if (this.checked) {
                customDateInput.disabled = true;
                // Có thể reset giá trị nếu muốn
                // customDateInput.value = '';
                reportFilterForm.submit();
            }
        });

        customRadio.addEventListener('change', function () {
            if (this.checked) {
                customDateInput.disabled = false;
                customDateInput.focus();
            }
        });

        customDateInput.addEventListener('change', function () {
            if (customRadio.checked) {
                reportFilterForm.submit();
            }
        });
    });
</script>