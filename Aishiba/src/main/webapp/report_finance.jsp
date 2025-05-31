<%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 5/9/2025
  Time: 12:08 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <!-- Sidebar -->
        <div class="col-lg-3 col-md-4 sidebar-main">
            <div class="sidebar-section">
                <h5 class="mb-3">Kiểu hiển thị</h5>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="displayType" id="report" checked>
                    <label class="form-check-label" for="report">Báo cáo</label>
                </div>
            </div>

            <div class="sidebar-section">
                <h5 class="mb-3">Thời gian</h5>
                <select class="form-select mb-3">
                    <option selected>2025</option>
                    <option>2024</option>
                    <option>2023</option>
                </select>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="time" id="month" checked>
                    <label class="form-check-label" for="month">Theo Tháng</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="time" id="quarter">
                    <label class="form-check-label" for="quarter">Theo Quý</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="time" id="year">
                    <label class="form-check-label" for="year">Theo Năm</label>
                </div>
                <input type="date" class="form-control mt-3" id="customDateStart">
                <input type="date" class="form-control mt-2" id="customDateEnd">
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-9 col-md-8">
            <div class="card p-4">
                <div class="d-flex justify-content-end mb-3" style="position: absolute; top: 20px; right: 20px;">
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
                <p class="text-muted">Ngày lập: <strong>20/04/2025 23:10</strong></p>
                <h5 class="text-center">Báo cáo kết quả hoạt động kinh doanh</h5>
                <p class="text-center text-muted">Từ ngày 01/04/2025 đến ngày 20/04/2025</p>
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
                        <td class="text-end">298,370,000</td>
                    </tr>
                    <tr>
                        <td>Giảm trừ Doanh thu (2 = 2.1+2.2)</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Chiết khấu hóa đơn (2.1)</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Giá trị hàng bán bị trả lại (2.2)</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td>Doanh thu thuần (3=1-2)</td>
                        <td class="text-end">298,370,000</td>
                    </tr>
                    <tr>
                        <td>Giá vốn hàng bán (4)</td>
                        <td class="text-end">280,297,500</td>
                    </tr>
                    <tr>
                        <td>Lợi nhuận gộp về bán hàng (5=3-4)</td>
                        <td class="text-end">16,072,500</td>
                    </tr>
                    <tr>
                        <td>Chi phí (6)</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Chi phí voucher</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Phí trả ĐTGH</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Xuất hủy hàng hóa</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Giá trị thanh toán bằng điểm</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Chiết khấu thanh toán cho khách</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Chi trả lương NV</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td>Lợi nhuận từ hoạt động kinh doanh (7=5-6)</td>
                        <td class="text-end">16,072,500</td>
                    </tr>
                    <tr>
                        <td>Thu nhập khác (8)</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Phí trả hàng</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Chiết khấu thanh toán từ NCC</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td class="sub-item">Chi phí khác (9)</td>
                        <td class="text-end">0</td>
                    </tr>
                    <tr>
                        <td>Lợi nhuận thuần (10=7+8-9)</td>
                        <td class="text-end">16,072,500</td>
                    </tr>
                    </tbody>
                </table>
                <p class="text-muted text-center mt-3">Chi nhánh trung tâm:</p>
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
        background-color: #ffffff;
        /* Màu nền sáng hơn */
        border: 1px solid #e0e0e0;
        /* Viền màu xám nhạt */
        border-radius: 8px;
        /* Bo góc nhẹ */
        padding: 24px;
        /* Tăng khoảng cách bên trong khung */
        margin-bottom: 24px;
        /* Tăng khoảng cách giữa các khung */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    }

    /* Tiêu đề của từng phần */
    .card h5 {
        font-size: 28px;
        /* Tăng cỡ chữ tiêu đề */
        font-weight: bold;
        color: #012970;
        margin-bottom: 16px;
        text-align: center;
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

    .d-flex.justify-content-end {
        position: absolute;
        top: 20px;
        /* Căn chỉnh nút cách phía trên 20px */
        right: 20px;
        /* Căn chỉnh nút cách phía phải 20px */
        z-index: 10;
        /* Đảm bảo nút nằm trên các phần tử khác */
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

    #chart1,
    #chart2 {
        height: 400px;
        /* Tăng chiều cao biểu đồ */
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 16px;
        /* Thêm khoảng cách bên trong */
    }

    .card+.card {
        margin-top: 100px;
        /* Tăng khoảng cách giữa các khung biểu đồ */
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
        /* Căn giữa văn bản */
    }

    .table tbody tr td {
        padding-left: 8px;
        /* Khoảng cách mặc định cho các chỉ tiêu */
    }

    .table tbody tr td.sub-item {
        padding-left: 32px;
        /* Thụt lề cho các chỉ tiêu con */
    }

    @media print {

        .sidebar-main,
        .sidebar,
        .header,
        .back-to-top,
        .d-flex.justify-content-end,
            /* Ẩn các nút chức năng trên báo cáo */
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


<!-- Thêm thư viện SheetJS (đặt trước thẻ đóng </body>) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script>
    document.getElementById('printReport').addEventListener('click', function () {
        window.print();
    });

    document.getElementById('exportExcel').addEventListener('click', function () {
        var wb = XLSX.utils.table_to_book(document.querySelector('table'), { sheet: "Báo cáo" });
        XLSX.writeFile(wb, 'baocaotaichinh.xlsx');
    });

    document.getElementById('sendEmail').addEventListener('click', function () {
        alert("Chức năng này đang phát triển");
    });
</script>
