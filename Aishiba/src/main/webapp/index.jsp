<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
  // Kiểm tra session (giữ nguyên logic này)
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
  }
%>
<main id="main" class="main">

  <div class="pagetitle">
    <h1>Dashboard</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="homepage">Trang chủ</a></li>
        <li class="breadcrumb-item active">Dashboard</li>
      </ol>
    </nav>
  </div><section class="section dashboard">
  <%-- Bọc tất cả các thẻ vào trong một <div class="row"> --%>
  <div class="row">
    <%-- Thẻ 1: Tổng Doanh Thu --%>
    <div class="col-xxl-3 col-md-6">
      <div class="card info-card revenue-card">
        <div class="card-body">
          <h5 class="card-title">Tổng Doanh Thu</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center"
                 style="background-color: #f0f8ff;">
              <i class="bi bi-currency-dollar" style="color: #4154f1;"></i>
            </div>
            <div class="ps-3">
              <h6>$<fmt:formatNumber value="${totalSalesRevenue}" pattern="#,##0.00"/></h6>
              <%-- PHẦN NÂNG CẤP --%>
              <c:if test="${requestScope.totalRevenueChange != null}">
            <span class="small pt-1 fw-bold ${totalRevenueChange >= 0 ? 'text-success' : 'text-danger'}">
              <i class="bi ${totalRevenueChange >= 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
              <fmt:formatNumber value="${Math.abs(totalRevenueChange)}" type="percent" maxFractionDigits="2"/>
            </span>
                <span class="text-muted small pt-2 ps-1">so với tháng trước</span>
              </c:if>
            </div>
          </div>
          <div id="totalRevenueChart" class="mt-2" style="height: 40px;"></div>
          <script>
            document.addEventListener("DOMContentLoaded", () => {
              if (typeof ApexCharts !== 'undefined' && document.querySelector("#totalRevenueChart")) {
                new ApexCharts(document.querySelector("#totalRevenueChart"), {
                  chart: { type: 'area', height: 40, sparkline: { enabled: true } },
                  stroke: { curve: 'smooth', width: 2 },
                  colors: ['#4154f1'],
                  fill: { type: 'gradient', gradient: { opacityFrom: 0.5, opacityTo: 0.2 } },
                  series: [{ data: [20, 70, 30, 80, 25, 75, 35, 65, 20] }], // Đây là dữ liệu mẫu, bạn có thể truyền dữ liệu động vào nếu có.
                  tooltip: { enabled: false },
                }).render();
              }
            });
          </script>
        </div>
      </div>
    </div>
    <%-- Thẻ 2: Tổng đơn hàng --%>
    <div class="col-xxl-3 col-md-6">
      <div class="card info-card sales-card">
        <div class="card-body">
          <h5 class="card-title">Tổng đơn hàng</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center" style="background-color: #ffebee;">
              <i class="bi bi-receipt" style="color: #dc3545;"></i>
            </div>
            <div class="ps-3">
              <h6>${totalOrders}</h6>
              <c:if test="${requestScope.totalOrdersChange != null}">
                            <span class="small pt-1 fw-bold ${totalOrdersChange >= 0 ? 'text-success' : 'text-danger'}">
                                <i class="bi ${totalOrdersChange >= 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
                                <fmt:formatNumber value="${Math.abs(totalOrdersChange)}" type="percent" maxFractionDigits="2"/>
                            </span>
                <span class="text-muted small pt-2 ps-1">tháng trước</span>
              </c:if>
            </div>
          </div>
          <div id="affiliateRevenueChart" class="mt-2" style="height: 40px;"></div>
          <script>
            document.addEventListener("DOMContentLoaded", () => {
              if (typeof ApexCharts !== 'undefined' && document.querySelector("#affiliateRevenueChart")) {
                new ApexCharts(document.querySelector("#affiliateRevenueChart"), {
                  chart: { type: 'area', height: 40, sparkline: { enabled: true } },
                  stroke: { curve: 'smooth', width: 2 },
                  colors: ['#dc3545'],
                  fill: { type: 'gradient', gradient: { opacityFrom: 0.5, opacityTo: 0.2 } },
                  series: [{ data: [30, 75, 25, 85, 30, 70, 40, 60, 25] }], // Dữ liệu mẫu
                  tooltip: { enabled: false },
                }).render();
              }
            });
          </script>
        </div>
      </div>
    </div> <%-- Đóng thẻ .col-xxl-3 của "Tổng đơn hàng" --%>

    <%-- Thẻ 2: Tổng sản phẩm bán ra --%>
    <div class="col-xxl-3 col-md-6">
      <div class="card info-card customers-card">
        <div class="card-body">
          <h5 class="card-title">Tổng sản phẩm bán ra</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center" style="background-color: #e0f7fa;">
              <i class="bi bi-box-seam" style="color: #0dcaf0;"></i>
            </div>
            <div class="ps-3">
              <h6>${totalProductsSold}</h6>
              <c:if test="${requestScope.totalProductsSoldChange != null}">
                            <span class="small pt-1 fw-bold ${totalProductsSoldChange >= 0 ? 'text-success' : 'text-danger'}">
                                <i class="bi ${totalProductsSoldChange >= 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
                                <fmt:formatNumber value="${Math.abs(totalProductsSoldChange)}" type="percent" maxFractionDigits="2"/>
                            </span>
                <span class="text-muted small pt-2 ps-1">tháng trước</span>
              </c:if>
            </div>
          </div>
          <div id="refundsChart" class="mt-2" style="height: 40px;"></div>
          <script>
            document.addEventListener("DOMContentLoaded", () => {
              if (typeof ApexCharts !== 'undefined' && document.querySelector("#refundsChart")) {
                new ApexCharts(document.querySelector("#refundsChart"), {
                  chart: { type: 'area', height: 40, sparkline: { enabled: true } },
                  stroke: { curve: 'smooth', width: 2 },
                  colors: ['#0dcaf0'],
                  fill: { type: 'gradient', gradient: { opacityFrom: 0.5, opacityTo: 0.2 } },
                  series: [{ data: [10, 45, 15, 50, 10, 40, 20, 35, 10] }], // Dữ liệu mẫu
                  tooltip: { enabled: false },
                }).render();
              }
            });
          </script>
        </div>
      </div>
    </div> <%-- Đóng thẻ .col-xxl-3 của "Tổng sản phẩm bán ra" --%>

    <%-- Thẻ 3: Tổng khách hàng --%>
    <div class="col-xxl-3 col-md-6">
      <div class="card info-card revenue-card">
        <div class="card-body">
          <h5 class="card-title">Tổng khách hàng</h5>
          <div class="d-flex align-items-center">
            <div class="card-icon rounded-circle d-flex align-items-center justify-content-center" style="background-color: #fff8e1;">
              <i class="bi bi-people" style="color: #ffc107;"></i>
            </div>
            <div class="ps-3">
              <h6>${totalCustomers}</h6>
              <c:if test="${requestScope.customersChange != null}">
                            <span class="small pt-1 fw-bold ${customersChange >= 0 ? 'text-success' : 'text-danger'}">
                                <i class="bi ${customersChange >= 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
                                <fmt:formatNumber value="${Math.abs(customersChange)}" type="percent" maxFractionDigits="2"/>
                            </span>
                <span class="text-muted small pt-2 ps-1">tháng trước</span>
              </c:if>
            </div>
          </div>
          <div id="avgRevenueUserChart" class="mt-2" style="height: 40px;"></div>
          <script>
            document.addEventListener("DOMContentLoaded", () => {
              if (typeof ApexCharts !== 'undefined' && document.querySelector("#avgRevenueUserChart")) {
                new ApexCharts(document.querySelector("#avgRevenueUserChart"), {
                  chart: { type: 'area', height: 40, sparkline: { enabled: true } },
                  stroke: { curve: 'smooth', width: 2 },
                  colors: ['#ffc107'],
                  fill: { type: 'gradient', gradient: { opacityFrom: 0.5, opacityTo: 0.2 } },
                  series: [{ data: [40, 90, 30, 80, 35, 85, 45, 75, 40] }], // Dữ liệu mẫu
                  tooltip: { enabled: false },
                }).render();
              }
            });
          </script>
        </div>
      </div>
    </div> <%-- Đóng thẻ .col-xxl-3 của "Tổng khách hàng" --%>

  </div> <%-- Đóng thẻ <div class="row"> bao ngoài --%>

  <div class="row mb-4">
    <div class="col-lg-8">
      <div class="card h-100">
        <div class="card-body">
          <h5 class="card-title">Mức độ tăng trưởng bán hàng từng năm </h5>
          <div id="customBarChart"></div>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="card h-100">
        <div class="card-body">
          <h5 class="card-title">Tỷ lệ phần trăm sản phẩm theo danh mục</h5>
          <div id="customPieChart"></div>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.addEventListener("DOMContentLoaded", () => {
      if (typeof ApexCharts !== 'undefined') {
        // Biểu đồ miền - Mức độ tăng trưởng bán hàng theo tháng so với năm trước
        // Lấy dữ liệu từ Servlet (đã được chuyển đổi sang List<Double> trong HomePage.java)
        const monthlySales2025 = [<c:forEach items="${monthlySales2025}" var="sales" varStatus="status">${sales}<c:if test="${!status.last}">,</c:if></c:forEach>];
        const monthlySales2024 = [<c:forEach items="${monthlySales2024}" var="sales" varStatus="status">${sales}<c:if test="${!status.last}">,</c:if></c:forEach>];

        new ApexCharts(document.querySelector("#customBarChart"), {
          chart: { type: 'area', height: 250 },
          series: [
            { name: new Date().getFullYear().toString(), data: monthlySales2025 },
            { name: (new Date().getFullYear() - 1).toString(), data: monthlySales2024 }
          ],
          xaxis: { categories: ['Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'] },
          stroke: { curve: 'smooth', width: 2 },
          fill: { type: 'gradient', gradient: { opacityFrom: 0.5, opacityTo: 0.2 } },
          dataLabels: { enabled: false }
        }).render();

        // Biểu đồ tròn - Tỷ lệ phần trăm sản phẩm bán ra theo danh mục
        // Lấy dữ liệu từ Servlet (đã được chuyển đổi sang List<String> và List<Long> trong HomePage.java)
        const productLabels = [<c:forEach items="${productLabels}" var="label" varStatus="status">'${label}'<c:if test="${!status.last}">,</c:if></c:forEach>];
        const productQuantities = [<c:forEach items="${productQuantities}" var="quantity" varStatus="status">${quantity}<c:if test="${!status.last}">,</c:if></c:forEach>];

        new ApexCharts(document.querySelector("#customPieChart"), {
          chart: { type: 'pie', height: 250 },
          series: productQuantities,
          labels: productLabels,
          legend: {
            position: 'bottom',
            horizontalAlign: 'center',
            offsetY: 10
          }
        }).render();
      }
    });
  </script>

  <div class="row">
    <div class="col-lg-8 d-flex">
      <div class="card h-100 w-100">
        <div class="card-body">
          <h5 class="card-title">Đơn Hàng Gần Đây <span>| Hôm nay</span></h5>
          <div class="table-responsive" style="max-height: 350px; overflow-y: auto;">
            <table class="table table-hover">
              <thead>
              <tr>
                <th scope="col">#</th>
                <th scope="col">Hình Ảnh</th>
                <th scope="col">Tên Sản Phẩm</th>
                <th scope="col">Số Lượng</th>
                <th scope="col">Giá</th>
                <th scope="col">Thời Gian Đặt</th>
                <th scope="col">Khách Hàng</th>
                <th scope="col">Trạng Thái</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="order" items="${recentOrders}" varStatus="loop">
                <c:forEach var="orderItem" items="${order.orderItems}">
                  <tr>
                    <th scope="row">${loop.index + 1}</th>
                    <td>
                        <%--
                          GIẢI PHÁP TỐI ƯU:
                          Vì tất cả các link đều bắt đầu bằng "//", ta chỉ cần thêm "https:" vào trước.
                        --%>
                      <img src="https:${orderItem.toy.image}"
                           alt="Hình ảnh ${orderItem.toy.name}"
                           style="width: 40px; height: 40px; object-fit: cover;">
                    </td>
                    <td>${orderItem.toy.name}</td>
                    <td>${orderItem.quantity}</td>
                    <td>$<fmt:formatNumber value="${orderItem.toy.price * orderItem.quantity}" pattern="#,##0.00"/></td>
                    <td>${order.orderDate.format(myFormatter)}</td>
                    <td>${order.user.name}</td> <%-- Giả định User có thuộc tính 'name' --%>
                    <td>
                          <span class="badge
<c:choose>
    <c:when test="${order.status.toString() eq 'HOAN_THANH'}">bg-success</c:when>
    <c:when test="${order.status.toString() eq 'DANG_CHO'}">bg-warning text-dark</c:when>
    <c:when test="${order.status.toString() eq 'DA_HUY'}">bg-danger</c:when>
    <c:when test="${order.status.toString() eq 'DANG_XU_LY'}">bg-info text-dark</c:when>
    <c:when test="${order.status.toString() eq 'DA_GIAO'}">bg-primary</c:when>
    <c:otherwise>bg-secondary</c:otherwise>
</c:choose>
                          ">${order.status}</span>
                    </td>
                  </tr>
                </c:forEach>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-4 d-flex">
      <div class="card h-100 w-100">
        <div class="card-body">
          <h5 class="card-title">Thu Hút Khách Hàng <span>| Tuần Này</span></h5>
          <div id="customerAcquisitionChart"></div>
          <script>
            document.addEventListener("DOMContentLoaded", () => {
              if (typeof ApexCharts !== 'undefined' && document.querySelector("#customerAcquisitionChart")) {
                new ApexCharts(document.querySelector("#customerAcquisitionChart"), {
                  series: [{
                    name: 'Quay Lại',
                    data: [30, 45, 60, 40, 35, 50, 70] // Dữ liệu mẫu - Cần logic để lấy dữ liệu thực
                  }, {
                    name: 'Lần Đầu',
                    data: [20, 25, 30, 50, 70, 80, 90] // Dữ liệu mẫu - Cần logic để lấy dữ liệu thực
                  }],
                  chart: { type: 'area', height: 365, toolbar: { show: false } },
                  colors: ['#4154f1', '#ff771d'],
                  dataLabels: { enabled: false },
                  stroke: { curve: 'smooth', width: 2 },
                  xaxis: {
                    categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                    labels: { style: { colors: '#8c909a', fontSize: '12px' } }
                  },
                  yaxis: {
                    min: 0,
                    labels: { style: { colors: '#8c909a', fontSize: '12px' } }
                  },
                  legend: {
                    position: 'top',
                    horizontalAlign: 'right',
                    floating: true,
                    offsetY: -25,
                    offsetX: -5,
                    labels: { colors: '#333' },
                    markers: { width: 10, height: 10 }
                  },
                  fill: {
                    type: "gradient",
                    gradient: {
                      shadeIntensity: 1,
                      opacityFrom: 0.6,
                      opacityTo: 0.2,
                      stops: [0, 90, 100]
                    }
                  },
                  tooltip: {
                    y: {
                      formatter: function (val) {
                        return val + " customers"
                      }
                    }
                  }
                }).render();
              }
            });
          </script>
        </div>
      </div>
    </div>
  </div>
</section>

</main>