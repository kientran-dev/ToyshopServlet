<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- Thêm dòng này --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<main id="main" class="main">
  <div class="pagetitle">
    <h1>Đơn hàng</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="homepage">Trang chủ</a></li>
        <li class="breadcrumb-item"><a href="#">Giao dịch</a></li>
        <li class="breadcrumb-item active">Đơn hàng</li>
      </ol>
    </nav>
  </div>

  <section class="section">
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="card-title fs-4 text-primary">Danh sách đơn hàng</h5>
    <div class="d-flex gap-2">
      <button class="btn btn-primary d-flex align-items-center">
        <i class="bi bi-plus-lg me-1"></i>
        Thêm mới
      </button>
      <button class="btn btn-success d-flex align-items-center">
        <i class="bi bi-collection me-1"></i>
        Gộp đơn
      </button>
      <div class="dropdown">
        <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="fileDropdown" data-bs-toggle="dropdown">
          <i class="bi bi-file-earmark me-1"></i>
          File
        </button>
        <ul class="dropdown-menu shadow">
          <li><a class="dropdown-item" href="#"><i class="bi bi-download me-2"></i>Xuất Excel</a></li>
          <li><a class="dropdown-item" href="#"><i class="bi bi-printer me-2"></i>In đơn hàng</a></li>
        </ul>
      </div>
    </div>
  </div>

    <%-- Cac nut tim kiem, loc --%>
    <!-- Add above the table -->
    <div class="row mb-3">
      <div class="col-md-8 d-flex gap-2 align-items-center">
        <div class="search-box flex-grow-1">
          <div class="input-group">
                      <span class="input-group-text bg-light">
                        <i class="bi bi-search"></i>
                      </span>
            <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm theo mã đơn hàng, khách hàng...">
          </div>
        </div>
        <select class="form-select" style="width: auto;">
          <option value="">Tất cả trạng thái</option>
          <option value="pending">Chờ xử lý</option>
          <option value="confirmed">Đã xác nhận</option>
          <option value="shipping">Đang giao hàng</option>
          <option value="completed">Hoàn thành</option>
          <option value="cancelled">Đã hủy</option>
          <option value="returned">Đã trả hàng</option>
        </select>
        <input type="date" class="form-control" style="width: auto;" title="Lọc theo ngày đặt hàng">
      </div>
    </div>

  <div class="table-responsive">
    <table class="table table-hover align-middle rounded-4 overflow-hidden">
      <thead class="table-light">
      <tr>
        <th style="width:40px">
          <input type="checkbox" class="form-check-input" id="selectAllorder" title="Chọn tất cả" onclick="toggleSelectAllorder(this)">
        </th>
        <th style="width:40px">
          <i class="bi bi-star header-star text-warning" id="selectAllorderStars" title="Chọn/Bỏ chọn tất cả nổi bật" onclick="toggleSelectAllorderStars()"></i>
        </th>
        <th>Mã DH</th>
        <th>Thời gian</th>
        <th>Khách hàng</th>
        <th>Địa chỉ nhận hàng</th>
        <th >Tổng tiền hàng</th>
      </tr>
      </thead>
      <tbody id="orderTableBody">
      <%-- Kiểm tra nếu orderList không rỗng --%>
      <c:if test="${not empty orderList}">
        <%-- Duyệt qua danh sách nhà cung cấp và hiển thị --%>
        <c:forEach var="order" items="${orderList}" varStatus="loop">
          <tr>
            <td><input type="checkbox" class="form-check-input supplier-checkbox" title="Chọn nhà cung cấp này" onclick="event.stopPropagation();"></td>
            <td><i class="bi bi-star star-outline" onclick="toggleSupplierStar(this, event)"></i></td>
            <td style="color: #0D6EFD"><c:out value="${order.formattedOrderCode}" /></td>
              <%-- Ngày đặt hàng --%>
            <td>
              <c:choose>
                <c:when test="${not empty order.orderDate}">
                  <fmt:formatDate value="${orderDateList[loop.index]}" pattern="dd/MM/yyyy HH:mm:ss" />
                </c:when>
                <c:otherwise>
                  N/A
                </c:otherwise>
              </c:choose>
            </td>
              <%-- Tên Khách hàng --%>
            <td>
              <c:choose>
                <c:when test="${not empty order.user and not empty order.user.name}">
                  <c:out value="${order.user.name}" />
                </c:when>
                <c:otherwise>
                  N/A
                </c:otherwise>
              </c:choose>
            </td>
              <%-- Địa chỉ --%>
            <td><c:out value="${order.address}" /></td>
              <%-- Email Khách hàng --%>
            <td class="text-end">
              <c:if test="${not empty totalAmountList[loop.index]}">
                <fmt:formatNumber value="${totalAmountList[loop.index]}" type="currency" currencyCode="VND" />
              </c:if>
              <c:if test="${empty totalAmountList[loop.index]}">
                N/A
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </c:if>
      <%-- Hiển thị thông báo nếu danh sách rỗng --%>
      <c:if test="${empty orderList}">
        <tr>
          <td colspan="9" class="text-center">Không có nhà cung cấp nào.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <%-- Phần phân trang --%>
  <c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation">
      <ul class="pagination-container">
          <%-- Nút Previous --%>
        <li class="page-item <c:if test='${currentPage == 1}'>disabled</c:if>">
          <a class="page-link" href="order?page=${currentPage - 1}" aria-label="Previous">
            <span aria-hidden="true">&laquo;</span>
          </a>
        </li>

          <%-- Các nút số trang --%>
          <%-- Logic hiển thị số trang (ví dụ: hiển thị 5 trang xung quanh trang hiện tại) --%>
        <c:set var="startPage" value="${currentPage - 2}"/>
        <c:set var="endPage" value="${currentPage + 2}"/>

        <c:if test="${startPage < 1}">
          <c:set var="endPage" value="${endPage + (1 - startPage)}"/>
          <c:set var="startPage" value="1"/>
        </c:if>
        <c:if test="${endPage > totalPages}">
          <c:set var="startPage" value="${startPage - (endPage - totalPages)}"/>
          <c:set var="endPage" value="${totalPages}"/>
          <c:if test="${startPage < 1}"><c:set var="startPage" value="1"/></c:if>
        </c:if>

          <%-- Nút trang đầu và "..." nếu cần --%>
        <c:if test="${startPage > 1}">
          <li class="page-item">
            <a class="page-link" href="order?page=1">1</a>
          </li>
          <c:if test="${startPage > 2}">
            <li class="page-item disabled"><span class="page-link">...</span></li>
          </c:if>
        </c:if>

        <c:forEach begin="${startPage}" end="${endPage}" var="i">
          <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
            <a class="page-link" href="order?page=${i}">${i}</a>
          </li>
        </c:forEach>

          <%-- Nút trang cuối và "..." nếu cần --%>
        <c:if test="${endPage < totalPages}">
          <c:if test="${endPage < totalPages - 1}">
            <li class="page-item disabled"><span class="page-link">...</span></li>
          </c:if>
          <li class="page-item">
            <a class="page-link" href="order?page=${totalPages}">${totalPages}</a>
          </li>
        </c:if>

          <%-- Nút Next --%>
        <li class="page-item <c:if test='${currentPage == totalPages || totalPages == 0}'>disabled</c:if>">
          <a class="page-link" href="order?page=${currentPage + 1}" aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
          </a>
        </li>
      </ul>
    </nav>
  </c:if>
  <%-- Hết phần phân trang --%>

</main>

<div class="modal fade" id="adminOrderDetailModal" tabindex="-1" aria-labelledby="adminOrderDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="adminOrderDetailModalLabel">Chi tiết Đơn hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="adminOrderDetailModalBody">
        <p class="text-center">Đang tải dữ liệu...</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>

<%-- Thêm các style cần thiết --%>
<!-- Thêm CSS -->
<style>
  .pagination-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
    margin-bottom: 20px;
  }

  .pagination-container .page-item {
    margin: 0 5px;
  }

  .pagination-container .page-link {
    padding: 8px 12px;
    text-decoration: none;
    color: #0d6efd; /* Bootstrap primary color */
    border: 1px solid #dee2e6; /* Bootstrap border color */
    border-radius: 4px;
    transition: background-color 0.2s, color 0.2s;
  }

  .pagination-container .page-link:hover {
    background-color: #e9ecef; /* Bootstrap hover color */
  }

  .pagination-container .page-item.active .page-link {
    background-color: #0d6efd;
    color: white;
    border-color: #0d6efd;
  }

  .pagination-container .page-item.disabled .page-link {
    color: #6c757d; /* Bootstrap disabled color */
    pointer-events: none;
    background-color: #fff;
    border-color: #dee2e6;
  }
  .status-select option[value="pending"] {
    background-color: #fff3cd;
    color: #856404;
  }

  .status-select option[value="processing"] {
    background-color: #cff4fc;
    color: #055160;
  }

  .status-select option[value="completed"] {
    background-color: #d4edda;
    color: #155724;
  }

  .status-select option[value="returned"] {
    background-color: #e2e3e5;
    color: #383d41;
  }

  .status-select option[value="cancelled"] {
    background-color: #f8d7da;
    color: #721c24;
  }

  /* Style cho select khi được chọn */
  .status-select {
    font-weight: 500;
  }

  .status-select:has(option[value="pending"]:checked) {
    color: #856404;
    background-color: #fff3cd;
  }

  .status-select:has(option[value="processing"]:checked) {
    color: #055160;
    background-color: #cff4fc;
  }

  .status-select:has(option[value="completed"]:checked) {
    color: #155724;
    background-color: #d4edda;
  }

  .status-select:has(option[value="returned"]:checked) {
    color: #383d41;
    background-color: #e2e3e5;
  }

  .status-select:has(option[value="cancelled"]:checked) {
    color: #721c24;
    background-color: #f8d7da;
  }

  /* Style cho select trạng thái */
  .form-select {
    padding: 0.375rem 2.25rem 0.375rem 0.75rem;
    font-weight: 500;
  }

  .form-select option {
    padding: 8px 12px;
  }

  /* Chờ xử lý */
  .form-select option[value="pending"] {
    background-color: #fff3cd;
    color: #664d03;
  }

  /* Đã xác nhận */
  .form-select option[value="confirmed"] {
    background-color: #cff4fc;
    color: #084298;
  }

  /* Đang giao hàng */
  .form-select option[value="shipping"] {
    background-color: #e8f4f8;
    color: #055160;
  }

  /* Hoàn thành */
  .form-select option[value="completed"] {
    background-color: #d1e7dd;
    color: #0f5132;
  }

  /* Đã hủy */
  .form-select option[value="cancelled"] {
    background-color: #f8d7da;
    color: #842029;
  }

  /* Đã trả hàng */
  .form-select option[value="returned"] {
    background-color: #e2e3e5;
    color: #41464b;
  }

  /* Style khi option được chọn */
  .form-select:has(option[value="pending"]:checked) {
    background-color: #fff3cd;
    color: #664d03;
    border-color: #ffecb5;
  }

  .form-select:has(option[value="confirmed"]:checked) {
    background-color: #cff4fc;
    color: #084298;
    border-color: #b6effb;
  }

  .form-select:has(option[value="shipping"]:checked) {
    background-color: #e8f4f8;
    color: #055160;
    border-color: #b6effb;
  }

  .form-select:has(option[value="completed"]:checked) {
    background-color: #d1e7dd;
    color: #0f5132;
    border-color: #badbcc;
  }

  .form-select:has(option[value="cancelled"]:checked) {
    background-color: #f8d7da;
    color: #842029;
    border-color: #f5c2c7;
  }

  .form-select:has(option[value="returned"]:checked) {
    background-color: #e2e3e5;
    color: #41464b;
    border-color: #d3d6d8;
  }
  .header-star,
  .bi-star,
  .bi-star-fill {
    color: #ffc107;
    cursor: pointer;
    transition: all 0.2s;
    -webkit-text-stroke: 0.25px #ffc107;
    user-select: none;
  }

  .header-star:hover,
  .bi-star:hover,
  .bi-star-fill:hover {
    transform: scale(1.2);
  }

  .bi-star-fill {
    color: #ffc107 !important;
  }

  td.text-center {
    cursor: default;
  }
</style>

<!-- ======= Script ======= -->
<%-- Script ngoi sao --%>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Lấy ngôi sao ở header và tất cả ngôi sao trong tbody
    const headerStar = document.querySelector("thead th:nth-child(2)");
    const rowStars = document.querySelectorAll(
            "tbody tr td:nth-child(2) i"
    );

    // Thêm ngôi sao vào header nếu chưa có
    if (!headerStar.querySelector("i")) {
      headerStar.innerHTML =
              '<i class="bi bi-star text-warning header-star"></i>';
    }

    // Lấy reference tới ngôi sao header
    const headerStarIcon = headerStar.querySelector("i");

    // Xử lý click vào ngôi sao header
    headerStarIcon.addEventListener("click", function () {
      const isHeaderStarFilled = this.classList.contains("bi-star-fill");

      // Toggle star trong header
      if (isHeaderStarFilled) {
        this.classList.remove("bi-star-fill");
        this.classList.add("bi-star");
      } else {
        this.classList.remove("bi-star");
        this.classList.add("bi-star-fill");
      }

      // Toggle tất cả stars trong tbody
      rowStars.forEach((star) => {
        if (isHeaderStarFilled) {
          star.classList.remove("bi-star-fill");
          star.classList.add("bi-star");
        } else {
          star.classList.remove("bi-star");
          star.classList.add("bi-star-fill");
        }

        // Lưu trạng thái vào localStorage
        const orderId = star.closest("tr").querySelector("a").textContent;
        localStorage.setItem(`favorite_${orderId}`, !isHeaderStarFilled);
      });
    });

    // Xử lý click cho từng ngôi sao trong tbody
    rowStars.forEach((star) => {
      star.addEventListener("click", function (e) {
        e.preventDefault();

        // Toggle class của ngôi sao được click
        if (this.classList.contains("bi-star-fill")) {
          this.classList.remove("bi-star-fill");
          this.classList.add("bi-star");
        } else {
          this.classList.remove("bi-star");
          this.classList.add("bi-star-fill");
        }

        // Lưu trạng thái vào localStorage
        const orderId = this.closest("tr").querySelector("a").textContent;
        const isFavorite = this.classList.contains("bi-star-fill");
        localStorage.setItem(`favorite_${orderId}`, isFavorite);

        // Cập nhật trạng thái header star
        updateHeaderStar();
      });

      // Khôi phục trạng thái từ localStorage
      const orderId = star.closest("tr").querySelector("a").textContent;
      const isFavorite =
              localStorage.getItem(`favorite_${orderId}`) === "true";
      if (isFavorite) {
        star.classList.remove("bi-star");
        star.classList.add("bi-star-fill");
      }
    });

    // Hàm cập nhật trạng thái header star
    function updateHeaderStar() {
      const allStarsFilled = Array.from(rowStars).every((star) =>
              star.classList.contains("bi-star-fill")
      );

      if (allStarsFilled) {
        headerStarIcon.classList.remove("bi-star");
        headerStarIcon.classList.add("bi-star-fill");
      } else {
        headerStarIcon.classList.remove("bi-star-fill");
        headerStarIcon.classList.add("bi-star");
      }
    }

    // Cập nhật trạng thái header star khi load trang
    updateHeaderStar();
  });
</script>

<%-- Script chon va thao tac don --%>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const selectAll = document.getElementById('selectAll');
    const rowCheckboxes = document.getElementsByClassName('row-checkbox');

    selectAll.addEventListener('change', function() {
      const isChecked = this.checked;

      Array.from(rowCheckboxes).forEach(checkbox => {
        checkbox.checked = isChecked;
      });
    });

    // Cập nhật trạng thái của checkbox "Chọn tất cả" khi các checkbox riêng lẻ thay đổi
    Array.from(rowCheckboxes).forEach(checkbox => {
      checkbox.addEventListener('change', function() {
        const allChecked = Array.from(rowCheckboxes).every(cb => cb.checked);
        selectAll.checked = allChecked;
      });
    });

    // Lấy các element cần thiết
    const orderModal = document.getElementById('orderDetailModal');
    const statusSelect = orderModal.querySelector('.form-select');
    const originalStatus = statusSelect.value;

    // Nút Cập nhật
    const updateBtn = orderModal.querySelector('.btn-success');
    updateBtn.addEventListener('click', function() {
      // Reload dữ liệu đơn hàng từ server
      alert('Đang tải lại thông tin đơn hàng...');
    });

    // Nút Lưu
    const saveBtn = orderModal.querySelector('.btn-primary');
    saveBtn.addEventListener('click', function() {
      if(statusSelect.value !== originalStatus) {
        const confirm = window.confirm('Bạn có chắc muốn thay đổi trạng thái đơn hàng?');
        if(confirm) {
          alert('Đã lưu thay đổi trạng thái đơn hàng!');
        }
      }
    });

    // Nút Trả hàng
    const returnBtn = orderModal.querySelector('.btn-warning');
    returnBtn.addEventListener('click', function() {
      // Kiểm tra trạng thái đơn hàng
      if(statusSelect.value === 'completed') {
        window.location.href = '#return-order'; // Chuyển đến trang trả hàng
      } else {
        alert('Chỉ có thể trả hàng với đơn hàng đã hoàn thành!');
      }
    });

    // Nút In
    const printBtn = orderModal.querySelector('.btn-secondary');
    printBtn.addEventListener('click', function() {
      window.print(); // Mở hộp thoại in
    });

    // Nút Xuất file
    const exportBtn = orderModal.querySelector('.btn-info');
    exportBtn.addEventListener('click', function() {
      // Tạo menu xuất file
      const format = prompt('Chọn định dạng xuất (pdf/excel):', 'pdf');
      if(format) {
        alert(`Đang xuất file ${format.toUpperCase()}...`);
      }
    });

    // Nút Sao chép
    const copyBtn = orderModal.querySelector('.btn:nth-last-child(2)');
    copyBtn.addEventListener('click', function() {
      const confirm = window.confirm('Bạn có muốn tạo đơn hàng mới từ đơn hàng này?');
      if(confirm) {
        // Reset trạng thái và tạo mã đơn mới
        statusSelect.value = 'pending';
        alert('Đã tạo đơn hàng mới!');
      }
    });

    // Nút Hủy bỏ
    const cancelBtn = orderModal.querySelector('.btn-danger');
    cancelBtn.addEventListener('click', function() {
      if(statusSelect.value !== 'cancelled') {
        const reason = prompt('Nhập lý do hủy đơn:');
        if(reason) {
          statusSelect.value = 'cancelled';
          alert('Đã hủy đơn hàng!');
        }
      } else {
        alert('Đơn hàng đã được hủy trước đó!');
      }
    });

    // Thêm class cho trạng thái
    statusSelect.addEventListener('change', function() {
      const status = this.value;
      this.className = 'form-select';
      switch(status) {
        case 'pending':
          this.classList.add('text-warning');
          break;
        case 'confirmed':
        case 'shipping':
          this.classList.add('text-primary');
          break;
        case 'completed':
          this.classList.add('text-success');
          break;
        case 'cancelled':
        case 'returned':
          this.classList.add('text-danger');
          break;
      }
    });

    // Xử lý nút ngôi sao
    const starButtons = document.querySelectorAll('.bi-star');
    starButtons.forEach(star => {
      star.addEventListener('click', function(e) {
        e.preventDefault();

        // Toggle class để đổi màu sao
        if(this.classList.contains('bi-star-fill')) {
          this.classList.remove('bi-star-fill');
          this.classList.add('bi-star');
        } else {
          this.classList.remove('bi-star');
          this.classList.add('bi-star-fill');
        }

        // Lưu trạng thái vào localStorage
        const orderId = this.closest('tr').querySelector('a').textContent;
        const isFavorite = this.classList.contains('bi-star-fill');
        localStorage.setItem(`favorite_${orderId}`, isFavorite);
      });

      // Khôi phục trạng thái từ localStorage khi load trang
      const orderId = star.closest('tr').querySelector('a').textContent;
      const isFavorite = localStorage.getItem(`favorite_${orderId}`) === 'true';
      if(isFavorite) {
        star.classList.remove('bi-star');
        star.classList.add('bi-star-fill');
      }
    });

    // Thêm style cho ngôi sao
    const style = document.createElement('style');
    style.textContent = `
        .bi-star, .bi-star-fill {
          cursor: pointer;
          transition: all 0.2s;
          user-select: none;  /* Thêm dòng này */
        }
        .bi-star:hover, .bi-star-fill:hover {
          transform: scale(1.2);
        }
        .bi-star-fill {
          color: #ffc107 !important;
        }
        td.text-center {
          cursor: default;  /* Thêm dòng này */
        }
      `;
    document.head.appendChild(style);

  });

  // Add this JavaScript for search functionality
  document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    const tableRows = document.querySelectorAll('table tbody tr');

    searchInput.addEventListener('keyup', function() {
      const searchTerm = this.value.toLowerCase();

      tableRows.forEach(row => {
        const orderCode = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
        const customer = row.querySelector('td:nth-child(6)').textContent.toLowerCase();

        if (orderCode.includes(searchTerm) || customer.includes(searchTerm)) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    });
  });
</script>

<%-- Script cho cac nut tren cung --%>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Get buttons
    const addNewBtn = document.querySelector('.btn-primary');
    const mergeOrderBtn = document.querySelector('.btn-success');

    // Thêm mới button handler
    addNewBtn.addEventListener('click', function() {
      const newOrderModal = `
            <div class="modal fade" id="newOrderModal">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Tạo đơn hàng mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Khách hàng</label>
                                        <select class="form-select" required>
                                            <option value="">Chọn khách hàng</option>
                                            <option>KH000001 - Anh Hoàng - Sài Gòn</option>
                                            <option>KH000002 - Chị Lan - Hà Nội</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Bảng giá</label>
                                        <select class="form-select">
                                            <option>Bảng giá chung</option>
                                            <option>Bảng giá sỉ</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Chi nhánh</label>
                                        <select class="form-select">
                                            <option>Chi nhánh trung tâm</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ghi chú</label>
                                        <textarea class="form-control" rows="3"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="button" class="btn btn-primary" onclick="createNewOrder()">Tạo đơn</button>
                        </div>
                    </div>
                </div>
            </div>
        `;
      document.body.insertAdjacentHTML('beforeend', newOrderModal);
      const modal = new bootstrap.Modal(document.getElementById('newOrderModal'));
      modal.show();
    });

    // Gộp đơn button handler
    mergeOrderBtn.addEventListener('click', function() {
      // Check if any orders are selected
      const selectedOrders = document.querySelectorAll('tbody input[type="checkbox"]:checked');

      if (selectedOrders.length < 2) {
        alert('Vui lòng chọn ít nhất 2 đơn hàng để gộp!');
        return;
      }

      // Get selected order IDs
      const orderIds = Array.from(selectedOrders).map(checkbox =>
              checkbox.closest('tr').querySelector('a.text-primary').textContent
      );

      const mergeModal = `
            <div class="modal fade" id="mergeOrderModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Gộp đơn hàng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn đang gộp ${selectedOrders.length} đơn hàng:</p>
                            <ul class="list-group mb-3">
                          {orderIds.map(id => (
                              <li key={id} className="list-group-item d-flex justify-content-between align-items-center">
                                  {id}
                                  <span className="badge bg-primary rounded-pill">
                                      {(() => {
                                          const linkElement = document.querySelector(`
      a[href="#"][text="${id}"]`);
                                          return linkElement
                                              ? linkElement.closest('tr')?.querySelector('td:nth-child(7)')?.textContent || ''
                                              : '';
                                      })()}
                                  </span>
                              </li>
                          ))}
                            </ul>
                            <div class="mb-3">
                                <label class="form-label">Ghi chú</label>
                                <textarea class="form-control" rows="2" placeholder="Nhập ghi chú cho đơn gộp..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="button" class="btn btn-success" onclick="mergeOrders('${orderIds.join(',')}')">
                                Xác nhận gộp
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
      document.body.insertAdjacentHTML('beforeend', mergeModal);
      const modal = new bootstrap.Modal(document.getElementById('mergeOrderModal'));
      modal.show();
    });
  });

  // Helper functions
  function createNewOrder() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('newOrderModal'));
    const customer = modal.element.querySelector('select').value;

    if (!customer) {
      alert('Vui lòng chọn khách hàng!');
      return;
    }

    alert('Đã tạo đơn hàng mới!');
    modal.hide();
    // Add logic to create new order here
  }

  function mergeOrders(orderIds) {
    const modal = bootstrap.Modal.getInstance(document.getElementById('mergeOrderModal'));
    const note = modal.element.querySelector('textarea').value;

    alert(`Đã gộp ${orderIds.split(',').length} đơn hàng thành công!`);
    modal.hide();
    // Add logic to merge orders here
  }
</script>

<%-- Script cho tim kiem va loc --%>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Get filter elements
    const statusFilter = document.querySelector('select[value=""]');
    const dateFilter = document.querySelector('input[type="date"]');
    const tableRows = document.querySelectorAll('tbody tr');

    // Add filter change handlers
    statusFilter.addEventListener('change', filterOrders);
    dateFilter.addEventListener('change', filterOrders);

    function filterOrders() {
      const selectedStatus = statusFilter.value;
      const selectedDate = dateFilter.value ? new Date(dateFilter.value) : null;

      tableRows.forEach(row => {
        // Get row data
        const rowStatus = row.querySelector('.badge')?.textContent || '';
        const rowDate = new Date(row.cells[3].textContent);

        // Format date for comparison (remove time part)
        const rowDateOnly = new Date(rowDate.getFullYear(), rowDate.getMonth(), rowDate.getDate());
        const selectedDateOnly = selectedDate ? new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate()) : null;

        // Check if row matches filters
        const matchesStatus = !selectedStatus || rowStatus.toLowerCase().includes(selectedStatus.toLowerCase());
        const matchesDate = !selectedDate || rowDateOnly.getTime() === selectedDateOnly.getTime();

        // Show/hide row based on filters
        row.style.display = (matchesStatus && matchesDate) ? '' : 'none';
      });

      // Update total count
      updateFilteredCount();
    }

    function updateFilteredCount() {
      const visibleRows = document.querySelectorAll('tbody tr:not([style*="none"])').length;
      const totalRows = tableRows.length;

      // Add or update counter element
      let counter = document.querySelector('.filter-counter');
      if (!counter) {
        counter = document.createElement('div');
        counter.className = 'filter-counter text-muted mt-2';
        document.querySelector('.table-responsive').insertAdjacentElement('beforebegin', counter);
      }
      counter.textContent = `Hiển thị ${visibleRows} / ${totalRows} đơn hàng`;
    }

    // Reset filters button
    const resetButton = document.createElement('button');
    resetButton.className = 'btn btn-outline-secondary';
    resetButton.innerHTML = '<i class="bi bi-x-circle me-1"></i>Xóa bộ lọc';
    resetButton.addEventListener('click', function() {
      statusFilter.value = '';
      dateFilter.value = '';
      tableRows.forEach(row => row.style.display = '');
      updateFilteredCount();
    });

    // Add reset button after filters
    dateFilter.insertAdjacentElement('afterend', resetButton);

    // Initialize counter
    updateFilteredCount();
  });
</script>