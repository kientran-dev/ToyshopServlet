<%-- Aishiba/src/main/webapp/report_product.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="jstlTopN" value="10" />

<main id="main" class="main">
  <div class="pagetitle">
    <h1>Báo cáo hàng hoá</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/homepage">Trang chủ</a></li>
        <li class="breadcrumb-item"><a href="#">Thống kê</a></li>
        <li class="breadcrumb-item active">Hàng hoá</li>
      </ol>
    </nav>
  </div>

  <div class="row">
    <div class="col-lg-3 col-md-4 sidebar-main">
      <%-- Giữ nguyên phần filter của bạn --%>
      <div class="sidebar-section">
        <h5 class="mb-3">Kiểu hiển thị</h5>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="displayType" id="chartRadio" value="chart" <c:if test="${empty param.displayType or param.displayType eq 'chart'}">checked</c:if>>
          <label class="form-check-label" for="chartRadio">Biểu đồ</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="displayType" id="reportRadio" value="report" <c:if test="${param.displayType eq 'report'}">checked</c:if>>
          <label class="form-check-label" for="reportRadio">Báo cáo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="displayType" id="groupRadio" value="group" <c:if test="${param.displayType eq 'group'}">checked</c:if>>
          <label class="form-check-label" for="groupRadio">Gộp hàng hoá cùng loại</label>
        </div>
      </div>
      <div class="sidebar-section">
        <h5 class="mb-3">Mối quan tâm</h5>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="focus" id="salesRadio" value="sales" <c:if test="${empty param.focus or param.focus eq 'sales'}">checked</c:if>>
          <label class="form-check-label" for="salesRadio">Bán hàng</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="focus" id="inventoryRadio" value="inventory" <c:if test="${param.focus eq 'inventory'}">checked</c:if>>
          <label class="form-check-label" for="inventoryRadio">Giữ tồn kho</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="focus" id="importRadio" value="import" <c:if test="${param.focus eq 'import'}">checked</c:if>>
          <label class="form-check-label" for="importRadio">Xuất nhập tồn</label>
        </div>
      </div>
      <div class="sidebar-section">
        <h5 class="mb-3">Thời gian</h5>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="time" id="thisWeekRadio" checked>
          <label class="form-check-label" for="thisWeekRadio">Tuần này</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="time" id="customRadio">
          <label class="form-check-label" for="customRadio">Lựa chọn khác</label>
        </div>
        <input type="date" class="form-control mt-2" id="customDateInput">
      </div>
    </div>

    <div class="col-lg-9 col-md-8">
      <%-- Hiển thị phần "Bán hàng" (Sales) --%>
      <c:if test="${empty param.focus or param.focus eq 'sales'}">
        <div class="card p-4">
          <h5 class="text-center card-title">Top ${jstlTopN} sản phẩm được bán nhiều nhất</h5>
          <div id="chartTopSellingHorizontalBarDistributed" style="height: 500px;"></div>
        </div>

        <div class="card mt-4">
          <div class="card-body">
            <h5 class="card-title">Danh sách Top ${jstlTopN} sản phẩm bán chạy nhất (Theo Số Lượng)</h5>
            <c:choose>
              <c:when test="${not empty productSaleStats}">
                <div class="table-responsive">
                  <table class="table table-striped table-hover table-sm">
                    <thead class="table-light">
                    <tr style="height: 40px;">
                      <th scope="col" style="width: 5%;">#</th>
                      <th scope="col" style="width: 25%;">Mã Sản Phẩm</th>
                      <th scope="col" style="width: 40%;">Tên Sản Phẩm</th>
                      <th scope="col" class="text-end" style="width: 30%;">Số lượng đã bán</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="productStat" items="${productSaleStats}" varStatus="status" begin="0" end="${jstlTopN - 1}">
                      <tr style="height: 40px;">
                        <th scope="row">${status.count}</th>
                        <td><c:out value="${productStat.formattedIdDisplay}" /></td>
                        <td><c:out value="${productStat.formattedToyName}" /></td>
                        <td class="text-end fw-bold"><c:out value="${productStat.quantitySold}" /></td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                  Chưa có dữ liệu sản phẩm bán chạy.
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="card mt-4">
          <div class="card-body">
            <h5 class="card-title">Sản phẩm chưa bán được</h5>
            <c:choose>
              <c:when test="${not empty unsoldProducts}">
                <div class="table-responsive">
                  <table class="table table-striped table-hover table-sm">
                    <thead class="table-light">
                    <tr>
                      <th scope="col" style="width: 5%;">#</th>
                      <th scope="col" style="width: 30%;">Mã Sản Phẩm</th>
                      <th scope="col" style="width: 65%;">Tên Sản Phẩm</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="toy" items="${unsoldProducts}" varStatus="status">
                      <tr style="height: 40px;">
                        <th scope="row">${status.count}</th>
                        <td><c:out value="${toy.formattedIdToy}" /></td>
                        <td><c:out value="${toy.formattedToyName}" /></td>
                      </tr>
                    </c:forEach>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                  Tất cả sản phẩm đều đã được bán ít nhất một lần hoặc không có sản phẩm nào trong hệ thống.
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:if>

      <%-- Thêm phần hiển thị "Giữ tồn kho" (Inventory) --%>
      <c:if test="${param.focus eq 'inventory'}">
        <div class="card mt-4">
          <div class="card-body">
            <h5 class="card-title">Sản phẩm sắp hết hàng (Dưới ${lowStockThreshold} sản phẩm)</h5>
            <c:choose>
              <c:when test="${not empty lowStockStats}">
                <div class="table-responsive">
                  <table class="table table-striped table-hover table-sm">
                    <thead class="table-light">
                    <tr style="height: 40px;">
                      <th scope="col" style="width: 5%;">#</th>
                      <th scope="col" style="width: 25%;">Mã Sản Phẩm</th>
                      <th scope="col" style="width: 40%;">Tên Sản Phẩm</th>
                      <th scope="col" class="text-end" style="width: 30%;">Số lượng tồn kho</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${lowStockStats}" varStatus="status">
                      <tr style="height: 40px;">
                        <th scope="row">${status.count}</th>
                        <td><c:out value="${item.formattedIdDisplay}" /></td>
                        <td><c:out value="${item.formattedToyName}" /></td>
                        <td class="text-end fw-bold"><c:out value="${item.quantity}" /></td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                  Không có sản phẩm nào sắp hết hàng.
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="card mt-4">
          <div class="card-body">
            <h5 class="card-title">Sản phẩm tồn kho nhiều (Trên ${highStockThreshold} sản phẩm)</h5>
            <c:choose>
              <c:when test="${not empty highStockStats}">
                <div class="table-responsive">
                  <table class="table table-striped table-hover table-sm">
                    <thead class="table-light">
                    <tr style="height: 40px;">
                      <th scope="col" style="width: 5%;">#</th>
                      <th scope="col" style="width: 25%;">Mã Sản Phẩm</th>
                      <th scope="col" style="width: 40%;">Tên Sản Phẩm</th>
                      <th scope="col" class="text-end" style="width: 30%;">Số lượng tồn kho</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${highStockStats}" varStatus="status">
                      <tr style="height: 40px;">
                        <th scope="row">${status.count}</th>
                        <td><c:out value="${item.formattedIdDisplay}" /></td>
                        <td><c:out value="${item.formattedToyName}" /></td>
                        <td class="text-end fw-bold"><c:out value="${item.quantity}" /></td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                  Không có sản phẩm nào tồn kho nhiều.
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="card mt-4">
          <div class="card-body">
            <h5 class="card-title">Sản phẩm đã hết hàng</h5>
            <c:choose>
              <c:when test="${not empty outOfStockStats}">
                <div class="table-responsive">
                  <table class="table table-striped table-hover table-sm">
                    <thead class="table-light">
                    <tr style="height: 40px;">
                      <th scope="col" style="width: 5%;">#</th>
                      <th scope="col" style="width: 25%;">Mã Sản Phẩm</th>
                      <th scope="col" style="width: 40%;">Tên Sản Phẩm</th>
                      <th scope="col" class="text-end" style="width: 30%;">Số lượng tồn kho</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${outOfStockStats}" varStatus="status">
                      <tr style="height: 40px;">
                        <th scope="row">${status.count}</th>
                        <td><c:out value="${item.formattedIdDisplay}" /></td>
                        <td><c:out value="${item.formattedToyName}" /></td>
                        <td class="text-end fw-bold"><c:out value="${item.quantity}" /></td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                  Không có sản phẩm nào đã hết hàng.
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:if>
      <%-- End of "Giữ tồn kho" (Inventory) section --%>

    </div>
  </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const chartProductNames = []; // Nhãn cho trục Y (ID - Tên Sản Phẩm)
    const chartQuantityData = []; // Dữ liệu cho trục X (số lượng)

    // Mảng màu sẽ được sử dụng cho các thanh và legend
    const distributedChartColors = ['#008FFB', '#00E396', '#FEB019', '#FF4560', '#775DD0', '#546E7A', '#26a69a', '#D10CE8', '#F9CE1D', '#33b2df'];


    <c:if test="${not empty productSaleStats and (empty param.focus or param.focus eq 'sales')}">
    <c:forEach items="${productSaleStats}" var="p" varStatus="loopStatus" begin="0" end="${jstlTopN - 1}">
    // Đảm bảo p.formattedProductDisplay trả về giá trị chuỗi hợp lệ
    chartProductNames.push('${p.formattedToyName.replace("\\\\", "\\\\\\\\").replace("\'", "\\\'").replace("\"", "\\\"")}');
    chartQuantityData.push(${p.quantitySold});
    </c:forEach>
    </c:if>

    // ... (bên trong thẻ <script>) ...
    var optionsHorizontalBarDistributed = {
      series: [{
        name: 'Số lượng đã bán', // Tên series
        data: chartQuantityData
      }],
      chart: {
        type: 'bar',
        height: 700
      },
      plotOptions: {
        bar: {
          horizontal: true,
          barHeight: '65%',
          distributed: true,
          dataLabels: {
            position: 'top'
          }
        }
      },
      colors: distributedChartColors,
      dataLabels: {
        enabled: false, // Tắt data label trên thanh
      },
      xaxis: { // Đây là dọc vì horizontal
        categories: chartProductNames, // Tên sản phẩm ("ID - Tên SP") được gán vào đây
        title: {
          text: 'Số lượng đã bán',
          style: {
            fontSize: '16px',
            fontWeight: 'bold'
          }
        },
        labels: {
          show: true
          // Không cần categories ở đây vì đây là trục số
        }
      },
      yaxis: { // Đây là ngang vì horizontal
        title: {
          text: 'Sản phẩm',
          style: {
            fontSize: '17px',
            fontWeight: 'bold'
          }
        },
        labels: {
          show: true,
          style: {
            fontSize: '13px',
            colors: '#333'
          },
          formatter: function (value) {
            if (value && value.length > 40) {
              return value.substring(0, 37) + '...';
            }
            return value;
          }
        }
      },
      grid: {
        xaxis: {
          lines: {
            show: true
          }
        },
        yaxis: {
          lines: {
            show: false
          }
        }
      },
      legend: {
        show: true,
        position: 'bottom',
        horizontalAlign: 'center',
        offsetY: 5,
      },

      tooltip: {
        theme: 'dark',
        // Đối với horizontalBar, ApexCharts sẽ tự động lấy category từ trục Y làm tiêu đề tooltip.
        // Ví dụ: "TOYABC - Tên Sản Phẩm"

        // tooltip.x định dạng giá trị hiển thị cho trục X (số lượng)
        x: {
          formatter: function(value) {
            // 'value' ở đây là số lượng (giá trị của thanh)
            return value ;
          }
        },
        // tooltip.y định dạng phần hiển thị của series trong tooltip
        y: {
          // Không cần formatter cho y ở đây để hiển thị lại tên sản phẩm,
          // vì tên sản phẩm đã là tiêu đề chính của tooltip.
          // Thay vào đó, chúng ta chỉ cần title cho series.
          title: {
            formatter: function (seriesName) {
              // seriesName là 'Số lượng đã bán'
              return seriesName + ':';
            }
          }
          // Nếu bạn vẫn muốn formatter cho y (sẽ không cần thiết nếu x đã định dạng giá trị):
          // formatter: function(value, { series, seriesIndex, dataPointIndex, w }) {
          //    // 'value' trong ngữ cảnh này của tooltip.y.formatter cho horizontal bar
          //    // thực chất là giá trị của series, giống như trong tooltip.x.formatter.
          //    // Tránh nhầm lẫn, nên tập trung định dạng giá trị ở tooltip.x.formatter.
          //    return value; // Hoặc bỏ trống nếu không muốn hiển thị gì thêm
          // }
        }
      },
      noData: {
        text: "Không có dữ liệu để hiển thị.",
        align: 'center',
        verticalAlign: 'middle',
        offsetX: 0,
        offsetY: 0,
        style: {
          fontSize: '16px',
        }
      }
    };

    const chartDiv = document.querySelector("#chartTopSellingHorizontalBarDistributed");
    // Chỉ render biểu đồ nếu đang ở chế độ "Bán hàng"
    <c:if test="${empty param.focus or param.focus eq 'sales'}">
    if (chartDiv) {
      if (chartQuantityData.length > 0 && chartProductNames.length === chartQuantityData.length) {
        var chart = new ApexCharts(chartDiv, optionsHorizontalBarDistributed);
        chart.render();
      } else if (chartQuantityData.length === 0) {
        chartDiv.innerHTML = '<div class="alert alert-info text-center p-5" role="alert">Không có dữ liệu sản phẩm bán chạy để hiển thị biểu đồ.</div>';
      } else {
        chartDiv.innerHTML = '<div class="alert alert-warning text-center p-5" role="alert">Lỗi: Dữ liệu tên sản phẩm và số lượng không khớp hoặc tên sản phẩm rỗng.</div>';
      }
    }
    </c:if>

    // JavaScript để xử lý sự kiện radio button cho "Mối quan tâm" (focus)
    const focusRadios = document.querySelectorAll('input[name="focus"]');
    focusRadios.forEach(radio => {
      radio.addEventListener('change', function() {
        const selectedFocus = this.value;
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('focus', selectedFocus);
        window.location.href = currentUrl.toString();
      });
    });

    // JavaScript để xử lý sự kiện radio button cho "Kiểu hiển thị" (displayType)
    const displayTypeRadios = document.querySelectorAll('input[name="displayType"]');
    displayTypeRadios.forEach(radio => {
      radio.addEventListener('change', function() {
        const selectedDisplayType = this.value;
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('displayType', selectedDisplayType);
        window.location.href = currentUrl.toString();
      });
    });

    // Highlight radio button based on current URL parameter on page load
    const urlParams = new URLSearchParams(window.location.search);
    const currentFocus = urlParams.get('focus') || 'sales'; // Default to 'sales'
    const currentDisplayType = urlParams.get('displayType') || 'chart'; // Default to 'chart'

    document.getElementById(currentFocus + 'Radio').checked = true;
    document.getElementById(currentDisplayType + 'Radio').checked = true;

  });
</script>
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
    font-size: 18px;
    /* Tăng cỡ chữ tiêu đề */
    font-weight: bold;
    /* In đậm tiêu đề */
    color: #012970;
    /* Màu chữ tiêu đề */
    margin-bottom: 16px;
    /* Khoảng cách dưới tiêu đề */
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
</style>