<%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 5/9/2025
  Time: 12:08 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Báo cáo khách hàng</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Thống kê</a></li>
                <li class="breadcrumb-item active">Khách hàng</li>
            </ol>
        </nav>
    </div>

    <div class="row">
        <div class="col-lg-3 col-md-4 sidebar-main">
            <div class="sidebar-section">
                <h5 class="mb-3">Kiểu hiển thị</h5>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="displayType" id="chart" checked>
                    <label class="form-check-label" for="chart">Biểu đồ</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="displayType" id="report">
                    <label class="form-check-label" for="report">Báo cáo</label>
                </div>
            </div>

            <div class="sidebar-section">
                <h5 class="mb-3">Mối quan tâm</h5>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="sales" checked>
                    <label class="form-check-label" for="sales">Bán hàng</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="profit">
                    <label class="form-check-label" for="profit">Lợi nhuận</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="debt">
                    <label class="form-check-label" for="debt">Công nợ</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="focus" id="customerSales">
                    <label class="form-check-label" for="customerSales">Hàng bán theo khách</label>
                </div>
            </div>

            <div class="sidebar-section">
                <h5 class="mb-3">Thời gian</h5>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="time" id="thisWeek" checked>
                    <label class="form-check-label" for="thisWeek">Tuần này</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="time" id="custom">
                    <label class="form-check-label" for="custom">Lựa chọn khác</label>
                </div>
                <input type="date" class="form-control mt-2" id="customDate">
            </div>

            <div class="sidebar-section">
                <h5 class="mb-3">Khách hàng</h5>
                <input type="text" class="form-control" placeholder="Theo mã, tên, điện thoại">
            </div>
        </div>

        <div class="col-lg-9 col-md-8">
            <%
                // Lấy dữ liệu từ request scope
                Map<String, Long> customerOrderCounts = (Map<String, Long>) request.getAttribute("customerOrderCounts");
                Map<String, Double> customerTotalPurchaseValues = (Map<String, Double>) request.getAttribute("customerTotalPurchaseValues");

                // Chuẩn bị dữ liệu cho JavaScript
                StringBuilder orderLabels = new StringBuilder();
                StringBuilder orderSeries = new StringBuilder();
                if (customerOrderCounts != null) {
                    Iterator<Map.Entry<String, Long>> it = customerOrderCounts.entrySet().iterator();
                    int count = 0;
                    while (it.hasNext() && count < 10) { // Giới hạn 10 khách hàng hàng đầu
                        Map.Entry<String, Long> entry = it.next();
                        orderLabels.append("'").append(entry.getKey()).append("'");
                        orderSeries.append(entry.getValue());
                        if (it.hasNext() && count < 9) { // Chỉ thêm dấu phẩy nếu không phải phần tử cuối cùng của top 10
                            orderLabels.append(", ");
                            orderSeries.append(", ");
                        }
                        count++;
                    }
                }

                StringBuilder purchaseLabels = new StringBuilder();
                StringBuilder purchaseSeries = new StringBuilder();
                if (customerTotalPurchaseValues != null) {
                    Iterator<Map.Entry<String, Double>> it = customerTotalPurchaseValues.entrySet().iterator();
                    int count = 0;
                    while (it.hasNext() && count < 10) { // Giới hạn 10 khách hàng hàng đầu
                        Map.Entry<String, Double> entry = it.next();
                        purchaseLabels.append("'").append(entry.getKey()).append("'");
                        purchaseSeries.append(entry.getValue());
                        if (it.hasNext() && count < 9) {
                            purchaseLabels.append(", ");
                            purchaseSeries.append(", ");
                        }
                        count++;
                    }
                }
            %>

            <div class="card p-4">
                <h5 class="text-center">Top 10 khách hàng mua nhiều nhất (Số lượng đơn hàng)</h5>
                <div id="customerOrderCountChart" style="height: 600px;"></div>
            </div>

            <div class="card p-4 mt-5">
                <h5 class="text-center">Top 10 khách hàng theo Tổng Giá Trị Mua Hàng</h5>
                <div id="customerTotalPurchaseChart" style="height: 600px;"></div>
            </div>

        </div>
    </div>
</main>

<script>
    // Dữ liệu và cấu hình cho biểu đồ Top Khách Hàng theo Số Lượng Đơn Hàng
    var customerOrderCountOptions = {
        series: [{
            name: 'Số Lượng Đơn Hàng',
            data: [<%= orderSeries.toString() %>]
        }],
        chart: {
            type: 'bar',
            height: 600,
            toolbar: { show: false }
        },
        colors: ['#42A5F5', '#66BB6A', '#FFA726', '#EF5350', '#AB47BC', '#7E57C2', '#26A69A', '#D4E157', '#FFCA28', '#8D6E63'],
        plotOptions: {
            bar: {
                horizontal: true,
                dataLabels: { position: 'top' },
                barHeight: '70%',
                distributed: true // Đảm bảo dòng này có!
            }
        },
        dataLabels: {
            enabled: false, // Thay đổi từ 'true' thành 'false' để xóa các con số trên cột
            offsetX: -6,
            style: {
                fontSize: '12px',
                colors: ['#fff']
            }
        },
        xaxis: {
            categories: [<%= orderLabels.toString() %>],
            title: {
                text: 'Số Lượng Đơn Hàng'
            },
            labels: {
                style: {
                    fontSize: '14px',
                    colors: '#333'
                }
            }
        },
        yaxis: {
            labels: {
                style: {
                    fontSize: '14px',
                    colors: '#333'
                }
                // HÀM FORMATTER ĐÃ BỊ XÓA HOẶC KHÔNG CÓ Ở ĐÂY NỮA
                // Để hiển thị tên khách hàng đầy đủ, bạn chỉ cần xóa hàm formatter
                // Hoặc nếu muốn kiểm soát độ dài, bạn có thể điều chỉnh nó:
                // formatter: function (val) {
                //     if (val.length > 50) { // Ví dụ: cắt nếu dài hơn 50 ký tự
                //         return val.substring(0, 47) + '...';
                //     }
                //     return val;
                // }
            }
        }
    };

    var customerOrderCountChart = new ApexCharts(document.querySelector("#customerOrderCountChart"), customerOrderCountOptions);
    customerOrderCountChart.render();

    // Dữ liệu và cấu hình cho biểu đồ Top Khách Hàng theo Tổng Giá Trị Mua Hàng
    var customerTotalPurchaseOptions = {
        series: [{
            name: 'Tổng Giá Trị Mua Hàng',
            data: [<%= purchaseSeries.toString() %>]
        }],
        chart: {
            type: 'bar',
            height: 600,
            toolbar: { show: false }
        },
        colors: ['#42A5F5', '#66BB6A', '#FFA726', '#EF5350', '#AB47BC', '#7E57C2', '#26A69A', '#D4E157', '#FFCA28', '#8D6E63'], // Đặt ở đây
        plotOptions: {
            bar: {
                horizontal: true,
                dataLabels: { position: 'top' },
                barHeight: '70%',
                distributed: true // Quan trọng: Đảm bảo mỗi cột nhận một màu khác nhau từ mảng 'colors'
            }
        },
        dataLabels: {
            enabled: false,
            offsetX: -6,
            style: {
                fontSize: '12px',
                colors: ['#fff']
            },
            formatter: function (val) {
                return val.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
            }
        },
        xaxis: {
            categories: [<%= purchaseLabels.toString() %>],
            title: {
                text: 'Tổng Giá Trị Mua Hàng'
            },
            labels: {
                formatter: function (val) {
                    return val.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
                },
                style: {
                    fontSize: '14px',
                    colors: '#333'
                }
            }
        },
        yaxis: {
            labels: {
                style: {
                    fontSize: '14px',
                    colors: '#333'
                }
                // HÀM FORMATTER ĐÃ BỊ XÓA HOẶC KHÔNG CÓ Ở ĐÂY NỮA
                // Để hiển thị tên khách hàng đầy đủ, bạn chỉ cần xóa hàm formatter
                // Hoặc nếu muốn kiểm soát độ dài, bạn có thể điều chỉnh nó:
                // formatter: function (val) {
                //     if (val.length > 50) { // Ví dụ: cắt nếu dài hơn 50 ký tự
                //         return val.substring(0, 47) + '...';
                //     }
                //     return val;
                // }
            }
        }
    };

    var customerTotalPurchaseChart = new ApexCharts(document.querySelector("#customerTotalPurchaseChart"), customerTotalPurchaseOptions);
    customerTotalPurchaseChart.render();

    // JavaScript để ẩn/hiện ô input ngày tùy chỉnh
    document.addEventListener('DOMContentLoaded', function () {
        const customTimeRadio = document.getElementById('custom');
        const thisWeekRadio = document.getElementById('thisWeek');
        const customDateInput = document.getElementById('customDate');

        // Ẩn customDateInput ban đầu nếu "Tuần này" được chọn
        if (thisWeekRadio.checked) {
            customDateInput.style.display = 'none';
        }

        customTimeRadio.addEventListener('change', function () {
            if (this.checked) {
                customDateInput.style.display = 'block';
            }
        });

        thisWeekRadio.addEventListener('change', function () {
            if (this.checked) {
                customDateInput.style.display = 'none';
            }
        });
    });
</script>

<style>
    /* Định vị sidebar trong main */
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

    /* Đảm bảo nội dung chính không bị chồng lấn */
    .main-content {
        margin-right: 20%;
    }

    /* Tùy chỉnh khung sidebar */
    .sidebar-wrapper {
        padding: 16px;
        background-color: #ffffff;
        border-radius: 8px;
    }

    /* Khung nhỏ cho từng phần */
    .card {
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 24px;
        margin-bottom: 24px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    }

    /* Tiêu đề của từng phần */
    .card h5 {
        font-size: 18px;
        font-weight: bold;
        color: #012970;
        margin-bottom: 16px;
        text-align: center;
    }

    /* Tùy chỉnh từng phần trong sidebar */
    .sidebar-section {
        margin-bottom: 16px;
        padding: 16px;
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
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

    .d-flex.justify-content-end .btn {
        padding: 8px 16px;
        font-size: 14px;
        border-radius: 5px;
    }

    .d-flex.justify-content-end .btn+.btn {
        margin-left: 10px;
    }

    #customerOrderCountChart,
    #customerTotalPurchaseChart {
        height: 600px; /* Cập nhật chiều cao phù hợp với chart.height */
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 16px;
    }

    /* Điều chỉnh khoảng cách giữa các khung biểu đồ */
    .card + .card {
        margin-top: 50px;
    }
</style>