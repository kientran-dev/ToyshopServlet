<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                <button class="btn btn-primary d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#newOrderModal">
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

            <div class="row mb-3">
              <div class="col-md-8 d-flex gap-2 align-items-center">
                <div class="search-box flex-grow-1">
                  <div class="input-group">
                    <span class="input-group-text bg-light">
                      <i class="bi bi-search"></i>
                    </span>
                    <label for="searchInput"></label><input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm theo mã đơn hàng, khách hàng...">
                  </div>
                </div>
                <label>
                  <select id="searchStatus" class="form-select" style="width: auto;">
                    <option value="">Tất cả trạng thái</option>
                    <%-- Đảm bảo các value này khớp 100% với tên hằng số trong file Enum --%>
                    <option value="CHO_XU_LY">Chờ xử lý</option>
                    <option value="DA_XAC_NHAN">Đã xác nhận</option>
                    <option value="DANG_GIAO_HANG">Đang giao hàng</option>
                    <option value="HOAN_THANH">Đã giao tới khách</option>
                    <option value="DA_HUY">Đã hủy</option>
                  </select>
                </label>
                <input type="date" class="form-control" style="width: auto;" title="Lọc theo ngày đặt hàng">
                <button type="button" class="btn btn-secondary" id="resetButton">
                  <i class="bi bi-arrow-counterclockwise me-1"></i>
                  Xóa lọc
                </button>
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
                  <th class="text-end">Tổng tiền hàng</th>
                  <th class="text-center">Trạng thái</th>
                </tr>
                </thead>
                <tbody id="orderTableBody">
                <%-- Để trống hoặc chỉ hiển thị trạng thái đang tải --%>
                <tr>
                  <td colspan="8" class="text-center">Đang tải dữ liệu...</td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <c:if test="${not empty totalPages && totalPages > 1}">
    <nav aria-label="Page navigation">
      <ul class="pagination-container">
          <%-- Nút Previous --%>
        <li class="page-item <c:if test='${empty currentPage || currentPage <= 1}'>disabled</c:if>">
          <a class="page-link" href="order?page=${currentPage - 1}" aria-label="Previous">
            <span aria-hidden="true">«</span>
          </a>
        </li>

          <%-- Logic tính toán trang bắt đầu và kết thúc --%>
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

          <%-- Nút trang đầu tiên và dấu "..." --%>
        <c:if test="${startPage > 1}">
          <li class="page-item">
            <a class="page-link" href="order?page=1">1</a>
          </li>
          <c:if test="${startPage > 2}">
            <li class="page-item disabled"><span class="page-link">...</span></li>
          </c:if>
        </c:if>

          <%-- Các nút trang số --%>
        <c:forEach begin="${startPage}" end="${endPage}" var="i">
          <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
            <a class="page-link" href="order?page=${i}">${i}</a>
          </li>
        </c:forEach>

          <%-- Nút trang cuối cùng và dấu "..." --%>
        <c:if test="${endPage < totalPages}">
          <c:if test="${endPage < totalPages - 1}">
            <li class="page-item disabled"><span class="page-link">...</span></li>
          </c:if>
          <li class="page-item">
            <a class="page-link" href="order?page=${totalPages}">${totalPages}</a>
          </li>
        </c:if>

          <%-- Nút Next --%>
        <li class="page-item <c:if test='${empty totalPages || totalPages == 0 || (not empty currentPage && currentPage >= totalPages)}'>disabled</c:if>">
          <a class="page-link" href="order?page=${currentPage + 1}" aria-label="Next">
            <span>»</span>
          </a>
        </li>
      </ul>
    </nav>
  </c:if>
</main>

<!-- Modal Tạo đơn hàng mới -->
<div class="modal fade" id="newOrderModal" tabindex="-1" aria-labelledby="newOrderModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="newOrderModalLabel">Tạo đơn hàng mới</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="newOrderForm">
          <!-- Thông tin chung -->
          <div class="row mb-3">
            <div class="col-md-6">
              <div class="mb-3">
                <label for="orderCode" class="form-label">Mã đơn hàng</label>
                <input type="text" class="form-control" id="orderCode" placeholder="[Sẽ được tạo tự động sau khi lưu]" readonly>              </div>
              <div class="mb-3">
                <label for="customerName" class="form-label">Khách hàng <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="customerName" placeholder="Nhập tên khách hàng để tìm kiếm..." required>
                <input type="hidden" id="customerId" name="customerId">
              </div>
              <div class="mb-3">
                <label for="address" class="form-label">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="address" required>
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label for="orderDate" class="form-label">Ngày đặt hàng</label>
                <input type="date" class="form-control" id="orderDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
              </div>
              <div class="mb-3">
                <label for="paymentMethod" class="form-label">Phương thức thanh toán <span class="text-danger">*</span></label>
                <select class="form-select" id="paymentMethod" required>
                  <option value="">Chọn phương thức</option>
                  <c:forEach var="payment" items="${paymentMethods}">
                    <option value="${payment.id}">${payment.paymentMethod.displayName}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="mb-3">
                <label for="deliveryMethod" class="form-label">Phương thức giao hàng <span class="text-danger">*</span></label>
                <select class="form-select" id="deliveryMethod" required>
                  <option value="">Chọn phương thức</option>
                  <c:forEach var="delivery" items="${deliveryMethods}">
                    <option value="${delivery.id}">${delivery.deliveryMethodName.displayName}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
          </div>

          <!-- Danh sách sản phẩm -->
          <h6 class="mb-3" style="font-size: 18px">Danh sách sản phẩm</h6>
          <div class="table-responsive">
            <table class="table table-bordered" id="productTable">
              <thead>
              <tr>
                <th style="width: 25%;">Mã sản phẩm</th>
                <th style="width: 25%;">Tên sản phẩm</th>
                <th style="width: 15%;">Số lượng</th>
                <th style="width: 15%;">Đơn giá</th>
                <th style="width: 15%;">Thành tiền</th>
                <th style="width: 5%;">Xóa</th>
              </tr>
              </thead>

              <tbody id="productTableBody">
              <tr>
                <td><input type="text" class="form-control product-search product-id" placeholder="Nhập mã..."></td>

                <td><input type="text" class="form-control product-search product-name" placeholder="hoặc gõ tên..."></td>

                <td><input type="number" class="form-control product-quantity" min="1" value="0"></td>
                <td><input type="number" class="form-control product-price" readonly></td>
                <td><input type="number" class="form-control product-total" readonly></td>
                <td><button type="button" class="btn btn-danger btn-sm" onclick="removeProductRow(this)">Xóa</button></td>
              </tr>
              </tbody>
            </table>
          </div>
          <button type="button" class="btn btn-outline-primary mt-2" onclick="addProductRow()">+ Thêm sản phẩm</button>
          <div class="mt-3">
            <strong>Tổng số lượng: <span id="totalQuantity">0</span></strong> |
            <strong>Tổng tiền: <span id="totalAmount">0</span> VND</strong>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        <button type="button" class="btn btn-primary" onclick="createNewOrder()">Tạo đơn</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal Chi tiết đơn hàng -->
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="orderDetailModalLabel">Chi tiết đơn hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row mb-3">
          <div class="col-md-6">
            <p><strong>Mã đơn hàng:</strong> <span id="detailOrderCode"></span></p>
            <p><strong>Khách hàng:</strong> <span id="detailCustomer"></span></p>
            <p><strong>Địa chỉ:</strong> <span id="detailAddress"></span></p>
            <p><strong>Khuyến mãi:</strong> <span id="detailCoupon"></span></p>
          </div>
          <div class="col-md-6">
            <p><strong>Ngày đặt:</strong> <span id="detailOrderDate"></span></p>
            <p><strong>Phương thức thanh toán:</strong> <span id="detailPaymentMethod"></span></p>
            <p><strong>Phương thức giao hàng:</strong> <span id="detailDeliveryMethod"></span></p>
            <p> <%-- Bỏ thẻ div không cần thiết ở đây --%>
              <strong>Trạng thái:</strong>
              <span class="status-wrapper"> <%-- Wrapper chính cho cả display và select --%>
            <span id="statusDisplay" class="status-display"></span>
            <input type="hidden" id="detailStatus" value=""> <%-- Input ẩn lưu giá trị trạng thái --%>
            <div class="status-select-wrapper"> <%-- Wrapper này có thể dùng để định vị select --%>
                <label for="statusSelect"></label><select id="statusSelect" class="form-select status-select"> <%-- Ban đầu ẩn bằng CSS, class 'show' để hiện --%>
                    <option value="CHO_XU_LY" class="status-option status-CHO_XU_LY">Chờ xử lý</option>
                    <option value="DA_XAC_NHAN" class="status-option status-DA_XAC_NHAN">Đã xác nhận</option>
                    <option value="DANG_GIAO_HANG" class="status-option status-DANG_GIAO_HANG">Đang giao hàng</option>
                    <option value="HOAN_THANH" class="status-option status-HOAN_THANH">Đã giao tới khách</option>
                    <option value="DA_HUY" class="status-option status-DA_HUY">Đã hủy</option>
                </select>
            </div>
        </span>
            </p>
          </div>
        </div>
        <h6 class="mb-3" style="font-size: 20px">Danh sách sản phẩm</h6>
        <div class="table-responsive">
          <table class="table table-bordered" id="detailProductTable">
            <thead>
            <tr>
              <th>Mã sản phẩm</th>
              <th>Tên sản phẩm</th>
              <th>Số lượng</th>
              <th>Đơn giá</th>
              <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody id="detailProductTableBody"></tbody>
          </table>
        </div>
        <div class="mt-3">
          <strong>Tổng số lượng: <span id="detailTotalQuantity">0</span></strong> |
          <strong>Tổng tiền: <span id="detailTotalAmount">0</span> VND</strong>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        <button id="updateStatusButton" type="button" class="btn btn-primary">Cập nhật trạng thái</button>
      </div>
    </div>
  </div>
</div>

<!-- Style -->
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
    color: #0d6efd;
    border: 1px solid #dee2e6;
    border-radius: 4px;
    transition: background-color 0.2s, color 0.2s;
  }

  .pagination-container .page-link:hover {
    background-color: #e9ecef;
  }

  .pagination-container .page-item.active .page-link {
    background-color: #0d6efd;
    color: white;
    border-color: #0d6efd;
  }

  .pagination-container .page-item.disabled .page-link {
    color: #6c757d;
    pointer-events: none;
    background-color: #fff;
    border-color: #dee2e6;
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

  /* Style cho modal tạo đơn hàng mới và chi tiết đơn hàng */
  #productTable input, #detailProductTable {
    font-size: 0.9rem;
  }
  #productTable .product-quantity {
    width: 80px;
  }
  #productTable .product-price, #productTable .product-total {
    width: 120px;
  }
  #productTable .btn-danger {
    padding: 0.25rem 0.5rem;
  }
  .ui-autocomplete{
    z-index: 9950 !important; /* Đảm bảo nó hiển thị trên các thành phần khác */
  }
  /* ... (CSS hiện có của bạn) ... */

  .status-wrapper {
    position: relative; /* Cần thiết để status-select-wrapper định vị đúng */
    display: inline-block;
    min-width: 170px; /* Tăng một chút nếu cần */
    vertical-align: middle;
  }

  .status-display {
    display: inline-block;
    padding: 6px 12px; /* Đồng nhất padding */
    border-radius: 4px;
    color: white;
    font-size: 14px;
    cursor: pointer;
    width: 100%; /* Cho phép nó chiếm toàn bộ chiều rộng của wrapper */
    text-align: center;
    border: 1px solid transparent;
    box-sizing: border-box;
  }

  /* Các lớp màu nền cho status-display (giữ nguyên hoặc điều chỉnh nếu cần) */
  .status-display.status-CHO_XU_LY { background-color: #6c757d; }
  .status-display.status-DA_XAC_NHAN { background-color: #0d6efd; }
  .status-display.status-DANG_GIAO_HANG { background-color: #ffc107; color: #000; }
  .status-display.status-HOAN_THANH { background-color: #198754; }
  .status-display.status-DA_HUY { background-color: #dc3545; }


  .status-select-wrapper {
    position: relative;
    top: -23px;
    left: 0;
    width: 100%; /* SỬA LẠI: Cho wrapper chiếm toàn bộ chiều rộng của status-wrapper */
    z-index: 1055; /* Giữ nguyên z-index */
  }

  .status-select {
    /*display: none; !* Ban đầu ẩn *!*/
    width: 100%;  /* Cho select chiếm toàn bộ chiều rộng của wrapper của nó */
    /* Bootstrap class 'form-select' đã xử lý nhiều style cơ bản */
    /* Bỏ background-color: transparent và color: white mặc định cho select */
    /* Thay vào đó, mỗi option sẽ có màu riêng */
  }

  .status-select.show {
    display: block; /* Hiện select khi có class 'show' */
  }

  /* Định nghĩa màu nền cho các option trong select */
  /* Các class này đã có trong CSS của bạn, đảm bảo chúng đúng */
  .status-select option.status-CHO_XU_LY { background-color: #6c757d; color: white; }
  .status-select option.status-DA_XAC_NHAN { background-color: #0d6efd; color: white; }
  .status-select option.status-DANG_GIAO_HANG { background-color: #ffc107; color: black; } /* Chú ý màu text */
  .status-select option.status-HOAN_THANH { background-color: #198754; color: white; }
  .status-select option.status-DA_HUY { background-color: #dc3545; color: white; }

  /* Thêm style để chính thẻ select cũng có màu nền tương ứng với option được chọn */
  .status-select.selected-CHO_XU_LY { background-color: #6c757d !important; color: white !important; }
  .status-select.selected-DA_XAC_NHAN { background-color: #0d6efd !important; color: white !important; }
  .status-select.selected-DANG_GIAO_HANG { background-color: #ffc107 !important; color: black !important; }
  .status-select.selected-HOAN_THANH { background-color: #198754 !important; color: white !important; }
  .status-select.selected-DA_HUY { background-color: #dc3545 !important; color: white !important; }

  /* ... (Style hiện có của bạn) ... */

  /* Style cho nhãn trạng thái trong bảng */
  .status-badge {
    display: inline-block;
    padding: 0.35em 0.65em; /* Tương tự padding của Bootstrap badge */
    font-size: 0.85em;     /* Kích thước chữ nhỏ hơn một chút */
    font-weight: 600;
    line-height: 1;
    color: #fff;            /* Màu chữ mặc định là trắng */
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: .375rem; /* Bo góc */
  }

  /* Áp dụng các màu nền đã có cho .status-badge */
  /* Các class này nên giống với các class bạn dùng cho .status-display */
  .status-badge.status-CHO_XU_LY { background-color: #6c757d; }
  .status-badge.status-DA_XAC_NHAN { background-color: #0d6efd; }
  .status-badge.status-DANG_GIAO_HANG { background-color: #ffc107; color: #000; } /* Chú ý màu text cho nền vàng */
  .status-badge.status-HOAN_THANH { background-color: #198754; }
  .status-badge.status-DA_HUY { background-color: #dc3545; }

  /* Đảm bảo text-center cho cột trạng thái nếu muốn căn giữa */
  .table th.text-center, .table td.text-center {
    text-align: center;
  }

</style>

<!-- Script -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Script cho nút "Thêm mới"
    const addNewBtn = document.querySelector('.btn-primary[data-bs-target="#newOrderModal"]');
    addNewBtn.addEventListener('click', function() {
      const modal = new bootstrap.Modal(document.getElementById('newOrderModal'));
      modal.show();
      updateOrderSummary();
    const closeModal = document.querySelector('.btn-close');
      closeModal.addEventListener('click', function() {
        $('#modal').modal('hide');
      });
    });

    /**
     * Bật/tắt trạng thái chọn của tất cả các checkbox đơn hàng.
     * @param {HTMLInputElement} masterCheckbox Checkbox tổng ở tiêu đề bảng.
     */
    function toggleSelectAllorder(masterCheckbox) {
      // 1. Tìm tất cả các checkbox của từng đơn hàng trong tbody
      //    Lưu ý: class '.supplier-checkbox' là class bạn đã dùng cho các checkbox ở dòng.
      const rowCheckboxes = document.querySelectorAll('#orderTableBody .supplier-checkbox');

      // 2. Lặp qua từng checkbox và đặt trạng thái 'checked' của nó
      //    giống với trạng thái của checkbox tổng.
      rowCheckboxes.forEach(checkbox => {
        checkbox.checked = masterCheckbox.checked;
      });
    }

    /**
     * Bật/tắt trạng thái "đánh dấu sao" của tất cả các đơn hàng.
     * @param {HTMLElement} masterStar Icon ngôi sao tổng ở tiêu đề bảng.
     */
    function toggleSelectAllorderStars(masterStar) {
      // 1. Xác định xem hành động cần làm là "tô màu" hay "bỏ tô màu"
      //    dựa vào trạng thái hiện tại của ngôi sao tổng.
      //    Nếu ngôi sao tổng là rỗng (có class 'bi-star'), thì chúng ta cần tô màu.
      const shouldBeFilled = masterStar.classList.contains('bi-star');

      // 2. Tìm tất cả các icon ngôi sao của từng đơn hàng trong tbody
      const rowStars = document.querySelectorAll('#orderTableBody .bi-star, #orderTableBody .bi-star-fill');

      // 3. Lặp qua từng ngôi sao và thay đổi class của nó
      rowStars.forEach(star => {
        if (shouldBeFilled) {
          // Tô màu ngôi sao
          star.classList.remove('bi-star');
          star.classList.add('bi-star-fill', 'text-warning'); // Thêm class màu vàng
        } else {
          // Bỏ tô màu ngôi sao
          star.classList.remove('bi-star-fill', 'text-warning');
          star.classList.add('bi-star');
        }
      });

      // 4. Cập nhật lại chính ngôi sao tổng
      if (shouldBeFilled) {
        masterStar.classList.remove('bi-star');
        masterStar.classList.add('bi-star-fill', 'text-warning');
      } else {
        masterStar.classList.remove('bi-star-fill', 'text-warning');
        masterStar.classList.add('bi-star');
      }
    }
    // Script cho nút "Gộp đơn"
    const mergeOrderBtn = document.querySelector('.btn-success');
    mergeOrderBtn.addEventListener('click', function() {
      const selectedOrders = document.querySelectorAll('tbody input[type="checkbox"]:checked');
      if (selectedOrders.length < 2) {
        alert('Vui lòng chọn ít nhất 2 đơn hàng để gộp!');
        return;
      }
      const orderIds = Array.from(selectedOrders).map(checkbox =>
              checkbox.closest('tr').querySelector('td:nth-child(3)')?.textContent?.trim() || ''
      ).filter(id => id); // Lọc bỏ các ID rỗng

      // Xóa modal cũ nếu tồn tại
      const existingModal = document.getElementById('mergeOrderModal');
      if (existingModal) {
        existingModal.remove();
      }

      // Tạo danh sách HTML cho các đơn hàng được chọn
      const orderListItems = orderIds.map(id => {
        const row = Array.from(document.querySelectorAll('tbody tr')).find(tr =>
                tr.querySelector('td:nth-child(3)')?.textContent?.trim() === id
        );
        const total = row ? row.querySelector('td:nth-child(7)')?.textContent?.trim() || 'N/A' : 'N/A';
        return `
      <li class="list-group-item d-flex justify-content-between align-items-center">
        ${id}
        <span class="badge bg-primary rounded-pill">${total}</span>
      </li>
    `;
      }).join('');

      // Tạo modal động
      const mergeModal = `
    <div class="modal fade" id="mergeOrderModal" tabindex="-1" aria-labelledby="mergeOrderModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="mergeOrderModalLabel">Gộp đơn hàng</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>Bạn đang gộp ${selectedOrders.length} đơn hàng:</p>
            <ul class="list-group mb-3>
              ${orderListItems}
            </ul>
            <div class="mb-3">
              <label for="mergeNote" class="form-label">Ghi chú</label>
              <textarea class="form-control" id="mergeNote" rows="2" placeholder="Nhập ghi chú cho đơn gộp..."></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <button type="button" class="btn btn-success" onclick="mergeOrders('${orderIds.join(',')}')">Xác nhận gộp</button>
          </div>
        </div>
      </div>
    </div>
  `;

      // Thêm modal vào DOM
      document.body.insertAdjacentHTML('beforeend', mergeModal);

      // Hiển thị modal
      const modal = new bootstrap.Modal(document.getElementById('mergeOrderModal'));
      modal.show();
    });


// Script cho ngôi sao
    const headerStar = document.querySelector('#selectAllorderStars');
    const rowStars = document.querySelectorAll('tbody tr td:nth-child(2) i');
    headerStar.addEventListener('click', function() {
      const isHeaderStarFilled = this.classList.contains('bi-star-fill');
      if (isHeaderStarFilled) {
        this.classList.remove('bi-star-fill');
        this.classList.add('bi-star');
      } else {
        this.classList.remove('bi-star');
        this.classList.add('bi-star-fill');
      }
      rowStars.forEach(star => {
        if (isHeaderStarFilled) {
          star.classList.remove('bi-star-fill');
          star.classList.add('bi-star');
        } else {
          star.classList.remove('bi-star');
          star.classList.add('bi-star-fill');
        }
        const orderId = star.closest('tr').querySelector('td:nth-child(3)').textContent;
        localStorage.setItem(`favorite_${orderId}`, !isHeaderStarFilled);
      });
    });

    rowStars.forEach(star => {
      star.addEventListener('click', function(e) {
        e.preventDefault();
        if (this.classList.contains('bi-star-fill')) {
          this.classList.remove('bi-star-fill');
          this.classList.add('bi-star');
        } else {
          this.classList.remove('bi-star');
          this.classList.add('bi-star-fill');
        }
        const orderId = this.closest('tr').querySelector('td:nth-child(3)').textContent;
        const isFavorite = this.classList.contains('bi-star-fill');
        localStorage.setItem(`favorite_${orderId}`, isFavorite);
        updateHeaderStar();
      });
      const orderId = star.closest('tr').querySelector('td:nth-child(3)').textContent;
      const isFavorite = localStorage.getItem(`favorite_${orderId}`) === 'true';
      if (isFavorite) {
        star.classList.remove('bi-star');
        star.classList.add('bi-star-fill');
      }
    });

    function updateHeaderStar() {
      const allStarsFilled = Array.from(rowStars).every(star => star.classList.contains('bi-star-fill'));
      if (allStarsFilled) {
        headerStar.classList.remove('bi-star');
        headerStar.classList.add('bi-star-fill');
      } else {
        headerStar.classList.remove('bi-star-fill');
        headerStar.classList.add('bi-star');
      }
    }
    updateHeaderStar();

    // Script cho hiển thị chi tiết đơn hàng
    const orderCodes = document.querySelectorAll('.order-code');
    orderCodes.forEach(code => {
      code.addEventListener('click', function() {
        const orderId = this.dataset.orderId;
        fetchOrderDetails(orderId);
      });
    });
  });

//Script cho thêm mới đơn hàng
  // Đảm bảo mã chạy sau khi trang đã được tải xong
  $(function() {

    // ===================================================
    //  PHẦN 1: LOGIC CHO TÌM KIẾM KHÁCH HÀNG
    // ===================================================
    $("#customerName").autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "/Aishiba/order?action=searchCustomers",
          dataType: "json",
          data: { term: request.term },
          success: function(data) {
            response(data);
          },
          error: function() {
            response([]); // Trả về mảng rỗng nếu có lỗi, tránh bị treo
          }
        });
      },
      minLength: 1,
      appendTo: "#newOrderForm", // Rất quan trọng: Để hiển thị trên modal
      select: function(event, ui) {
        event.preventDefault();
        $("#customerName").val(ui.item.name);
        $("#customerId").val(ui.item.value);
      }
    });

    // ===================================================
    //  PHẦN 2: LOGIC CHO BẢNG SẢN PHẨM
    // ===================================================

    // Dùng event delegation để gắn Autocomplete vào ô tìm kiếm sản phẩm
    // Áp dụng cho cả các dòng được thêm vào sau này
    $('#productTableBody').on('focus', '.product-search', function() {
      $(this).autocomplete({
        source: function(request, response) {
          $.ajax({
            url: "/Aishiba/order?action=searchProducts",
            dataType: "json",
            data: { term: request.term },
            success: function(data) { response(data); },
            error: function() { response([]); }
          });
        },
        minLength: 1,
        appendTo: "#newOrderForm",

        // Sửa lại logic select để điền dữ liệu vào cả 2 ô
        select: function(event, ui) {
          event.preventDefault();
          const row = $(this).closest('tr');

          // Tìm đến các ô trong cùng một hàng và điền dữ liệu
          row.find('.product-id').val(ui.item.value);     // Điền mã vào cột "Mã sản phẩm"
          row.find('.product-name').val(ui.item.name);    // Điền tên vào cột "Tên sản phẩm"
          row.find('.product-price').val(ui.item.price);
          row.find('.product-quantity').val(1);

          calculateRowTotal(row.find('.product-quantity')[0]);
        }
      });
    });

// Gắn sự kiện 'input' để tự động tính toán lại thành tiền khi sửa số lượng
    $('#productTableBody').on('input', '.product-quantity', function() {
      calculateRowTotal(this);
    });
  });

  // ===================================================
  //  PHẦN 3: CÁC HÀM TIỆN ÍCH (Để ở ngoài $(function(){...}) )
  //  Các hàm này được gọi bằng onclick="" từ HTML
  // ===================================================

  /**
   * Hàm thêm một dòng sản phẩm mới vào bảng
   */
  // Trong file JavaScript của bạn
  function addProductRow() {
    const tbody = document.getElementById('productTableBody');
    const newRow = document.createElement('tr');

    // Cập nhật innerHTML với cấu trúc mới
    newRow.innerHTML = `
      <td><input type="text" class="form-control product-search product-id" placeholder="Gõ mã..."></td>
      <td><input type="text" class="form-control product-search product-name" placeholder="hoặc gõ tên..."></td>
      <td><input type="number" class="form-control product-quantity" min="1" value="0"></td>
      <td><input type="number" class="form-control product-price" readonly></td>
      <td><input type="number" class="form-control product-total" readonly></td>
      <td><button type="button" class="btn btn-danger btn-sm" onclick="removeProductRow(this)">Xóa</button></td>
    `;
    tbody.appendChild(newRow);
  }

  /**
   * Hàm xóa một dòng sản phẩm
   * @param {HTMLButtonElement} button Nút "Xóa" được bấm
   */
  function removeProductRow(button) {
    $(button).closest('tr').remove();
    updateOrderSummary();
  }

  /**
   * Hàm tính tổng tiền cho một dòng dựa trên số lượng và đơn giá
   * @param {HTMLInputElement} input Ô input số lượng đang được thay đổi
   */
  function calculateRowTotal(input) {
    const row = $(input).closest('tr');
    const quantity = parseInt($(input).val()) || 0;
    const price = parseFloat(row.find('.product-price').val()) || 0;
    const total = quantity * price;
    row.find('.product-total').val(total);
    updateOrderSummary();
  }

  /**
   * Hàm cập nhật tổng số lượng và tổng tiền của cả đơn hàng
   */
  function updateOrderSummary() {
    let totalQuantity = 0;
    let totalAmount = 0;
    $('#productTableBody tr').each(function() {
      const row = $(this);
      totalQuantity += parseInt(row.find('.product-quantity').val()) || 0;
      totalAmount += parseFloat(row.find('.product-total').val()) || 0;
    });
    $('#totalQuantity').text(totalQuantity);
    $('#totalAmount').text(totalAmount.toLocaleString('vi-VN'));
  }


  // ===================================================
  //  PHẦN 4: HÀM GỬI ĐƠN HÀNG MỚI ĐẾN SERVER
  // ===================================================
  function createNewOrder() {
    // Thu thập dữ liệu từ các trường
    const customerId = document.getElementById('customerId').value;
    const orderCode = document.getElementById('orderCode').value;
    const orderDate = document.getElementById('orderDate').value;
    const address = document.getElementById('address').value;
    const paymentMethodId = document.getElementById('paymentMethod').value;
    const deliveryMethodId = document.getElementById('deliveryMethod').value;

    // Thu thập dữ liệu từ bảng sản phẩm
    const products = Array.from(document.querySelectorAll('#productTableBody tr')).map(row => ({
      toyId: row.querySelector('.product-id').value,
      quantity: parseInt(row.querySelector('.product-quantity').value) || 0,
      price: parseFloat(row.querySelector('.product-price').value) || 0
    }));

    // Kiểm tra dữ liệu (Validation)
    if (!customerId) {
      alert('Vui lòng tìm và chọn một khách hàng!');
      return;
    }
    if (!address.trim()) {
      alert('Vui lòng nhập địa chỉ nhận hàng!');
      return;
    }
    if (products.length === 0 || products.some(p => !p.toyId || p.quantity <= 0)) {
      alert('Đơn hàng phải có ít nhất một sản phẩm hợp lệ với số lượng lớn hơn 0!');
      return;
    }

    // Tạo đối tượng JSON để gửi đi
    const orderData = {
      orderCode,
      customerId,
      orderDate,
      address,
      paymentMethodId,
      deliveryMethodId,
      status: 'CHO_XU_LY', // Trạng thái mặc định khi tạo đơn hàng mới
      products
    };

    // Gửi yêu cầu POST đến server
    fetch('/Aishiba/order?action=create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(orderData)
    })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                alert('Đã tạo đơn hàng mới thành công!');
                window.location.reload(); // Tải lại trang để cập nhật danh sách
              } else {
                alert('Lỗi khi tạo đơn hàng: ' + (data.message || 'Lỗi không xác định từ server.'));
              }
            })
            .catch(error => {
              console.error('Lỗi khi gửi yêu cầu tạo đơn hàng:', error);
              alert('Đã có lỗi nghiêm trọng xảy ra. Vui lòng kiểm tra console (F12) để biết thêm chi tiết.');
            });
  }

  function mergeOrders(orderIds) {
    const modal = bootstrap.Modal.getInstance(document.getElementById('mergeOrderModal'));
    const note = modal.element.querySelector('textarea').value;
    alert(`Đã gộp ${orderId.split(',').length} đơn hàng thành công!`);
    $('#modal').modal('hide');
  }

//Script cho chi tiết đơn hàng
  const statusDisplayNames = {
    'CHO_XU_LY': 'Chờ xử lý',
    'DA_XAC_NHAN': 'Đã xác nhận',
    'DANG_GIAO_HANG': 'Đang giao hàng',
    'HOAN_THANH': 'Đã giao tới khách',
    'DA_HUY': 'Đã hủy'
  };

  function updateStatusDisplay(status) {
    const statusDisplay = document.getElementById('statusDisplay');
    const statusInput = document.getElementById('detailStatus');
    const statusSelect = document.getElementById('statusSelect');
    if (statusDisplay && statusInput && statusSelect) {
      statusDisplay.textContent = statusDisplayNames[status] || status;
      statusDisplay.className = 'status-display status-' + status;
      statusInput.value = status;
      statusSelect.value = status;
    }
  }
  function updateOrderStatus(orderId, status) {
    const url = '/Aishiba/order?action=updateStatus';
    const data = {
      orderId: orderId,
      status: status
    };

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })
            .then(response => {
              console.log('Mã trạng thái HTTP:', response.status);
              if (!response.ok) {
                throw new Error('HTTP error: ' + response.status);
              }
              return response.json();
            })
            .then(result => {
              if (result.success) {
                alert('Cập nhật trạng thái thành công!');
                updateStatusDisplay(status);
                window.location.reload();
              } else {
                alert('Cập nhật trạng thái thất bại: ' + (result.error || ''));
              }
            })
            .catch(error => {
              console.error('Lỗi khi cập nhật trạng thái:', error);
              alert('Lỗi khi cập nhật trạng thái: ' + error.message);
            });
  }
  function fetchOrderDetails(orderId) {
    // Hiển thị một trạng thái tải đơn giản (tùy chọn)
    $('#orderDetailsModalLabel').text('Đang tải chi tiết...');
    $('#orderDetailsModal').modal('show'); // Hiển thị modal trước
    if (!orderId || orderId.trim() === '') {
      console.error('Lỗi: orderId không hợp lệ hoặc rỗng:', orderId);
      alert('Lỗi: Vui lòng cung cấp ID đơn hàng hợp lệ!');
      return;
    }

    const url = '/Aishiba/order?action=getDetails&id=' + encodeURIComponent(orderId);
    console.log('Gửi yêu cầu tới URL:', url);

    fetch(url)
            .then(response => {
              console.log('Mã trạng thái HTTP:', response.status);
              if (!response.ok) {
                throw new Error('HTTP error! Status: ' + response.status);
              }
              const contentType = response.headers.get('Content-Type');
              if (!contentType || !contentType.includes('application/json')) {
                throw new Error('Phản hồi không phải JSON: ' + contentType);
              }
              return response.text();
            })
            .then(text => {
              console.log('Phản hồi từ server:', text);
              try {
                const cleanedText = text.trim().replace(/^\uFEFF/, '').replace(/[\x00-\x1F\x7F]/g, '');
                const data = JSON.parse(cleanedText);
                if (data.order) {
                  document.getElementById('detailOrderCode').textContent = data.order.id || 'N/A';
                  document.getElementById('detailCustomer').textContent = data.order.user.name || 'N/A';
                  document.getElementById('detailAddress').textContent = data.order.address || 'N/A';
                  document.getElementById('detailCoupon').textContent = data.order.coupon ? data.order.coupon : 'Không có';
                  document.getElementById('detailOrderDate').textContent = data.order.orderDate ?
                          new Date(data.order.orderDate).toLocaleString('vi-VN', {
                            day: '2-digit',
                            month: '2-digit',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit',
                            second: '2-digit'
                          }) : 'N/A';
                  document.getElementById('detailPaymentMethod').textContent = data.order.paymentMethod || 'N/A';
                  document.getElementById('detailDeliveryMethod').textContent = data.order.deliveryMethod || 'N/A';

                  // Cập nhật trạng thái với màu nền
                  const statusInput = document.getElementById('detailStatus');
                  if (statusInput) {
                    const currentStatus = data.order.status || 'CHO_XU_LY';
                    console.log('Trạng thái đơn hàng:', currentStatus);
                    updateStatusDisplay(currentStatus);
                  } else {
                    console.error('Không tìm thấy phần tử detailStatus');
                    alert('Lỗi: Không thể cập nhật trạng thái đơn hàng!');
                    return;
                  }

                  const tbody = document.getElementById('detailProductTableBody');
                  tbody.innerHTML = '';
                  let totalQuantity = 0;
                  let totalAmount = 0;

                  console.log('Danh sách sản phẩm:', data.order.products);

                  if (data.order.products && data.order.products.length > 0) {
                    data.order.products.forEach(product => {
                      console.log('Sản phẩm:', product);
                      const row = document.createElement('tr');
                      const total = (product.quantity || 0) * (product.price || 0);
                      row.innerHTML = '<td>' + (product.toyId || 'N/A') + '</td>' +
                              '<td>' + (product.name || 'N/A') + '</td>' +
                              '<td>' + (product.quantity !== undefined ? product.quantity : 0) + '</td>' +
                              '<td>' + (product.price ? product.price.toLocaleString('vi-VN') : 'N/A') + '</td>' +
                              '<td>' + (total ? total.toLocaleString('vi-VN') : 'N/A') + '</td>';
                      tbody.appendChild(row);
                      totalQuantity += product.quantity || 0;
                      totalAmount += total || 0;
                    });
                  } else {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center">Không có sản phẩm nào.</td></tr>';
                  }

                  document.getElementById('detailTotalQuantity').textContent = totalQuantity;
                  document.getElementById('detailTotalAmount').textContent = totalAmount.toLocaleString('vi-VN');

                  // Gán sự kiện cho trạng thái và dropdown
                  const updateButton = document.getElementById('updateStatusButton');
                  const statusDisplay = document.getElementById('statusDisplay');
                  const statusSelect = document.getElementById('statusSelect');
                  const statusSelectWrapper = document.querySelector('.status-select-wrapper');
                  if (updateButton && statusDisplay && statusSelect && statusSelectWrapper) {
                    statusDisplay.onclick = function() {
                      statusDisplay.style.display = 'none';
                      statusSelect.classList.add('show');
                      statusSelect.focus();
                    };
                    statusSelect.onchange = function() {
                      const newStatus = this.value;
                      updateStatusDisplay(newStatus);
                      statusDisplay.style.display = 'inline-block';
                      statusSelect.classList.remove('show');
                    };
                    statusSelect.onblur = function() {
                      statusDisplay.style.display = 'inline-block';
                      statusSelect.classList.remove('show');
                    };
                    updateButton.onclick = function() {
                      const newStatus = statusInput.value;
                      updateOrderStatus(orderId, newStatus);
                    };
                  } else {
                    console.error('Không tìm thấy phần tử cần thiết để gán sự kiện');
                    alert('Lỗi: Không thể gán sự kiện cập nhật trạng thái!');
                    return;
                  }

                  const modal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
                  modal.show();
                } else {
                  alert('Không tìm thấy thông tin đơn hàng!');
                }
              } catch (e) {
                console.error('Lỗi xử lý phản hồi:', e.message);
                alert('Lỗi: Không thể phân tích phản hồi từ server!');
              }
            })
            .catch(error => {
              console.error('Lỗi khi lấy chi tiết:', error);
              alert('Lỗi khi lấy thông tin: ' + error.message);
            });
  }
  // --- SỬ DỤNG EVENT DELEGATION ĐỂ GẮN SỰ KIỆN CLICK ---
  // Đoạn code này thay thế cho code cũ của bạn
  $('#orderTableBody').on('click', '.order-code', function() {
    // `this` ở đây chính là thẻ <td> có class .order-code được click
    const orderId = $(this).data('order-id');

    if (orderId) {
      // Gọi hàm fetchOrderDetails với ID lấy được
      fetchOrderDetails(orderId);
    } else {
      console.error("Không tìm thấy order-id trên phần tử được click.");
    }
  });
//Loc va tim kiem
  $(document).ready(function() {

    const searchInput = $('#searchInput');
    const statusFilter = $('#searchStatus');
    const dateFilter = $('input[type="date"]');
    const tableBody = $('#orderTableBody');
    // Thêm các element phân trang nếu có
    const paginationContainer = $('.pagination-container'); // Thay .pagination-container bằng selector thực tế của bạn

    let currentPage = 1;
    let debounceTimeout;
    // Hàm lấy class CSS cho badge trạng thái
    // Hàm chính: Gọi AJAX để lấy dữ liệu và render lại bảng + phân trang
    function fetchAndRenderOrders(page = 1) {
      currentPage = page;
      const searchTerm = searchInput.val();
      const status = statusFilter.val();
      const date = dateFilter.val();

      // Hiển thị hiệu ứng tải (tùy chọn)
      tableBody.html('<tr><td colspan="8" class="text-center">Đang tải dữ liệu...</td></tr>');

      $.ajax({
        url: 'order', // URL đến servlet
        type: 'GET',
        data: {
          action: 'searchAndFilter', // Action mới đã định nghĩa ở servlet
          searchTerm: searchTerm,
          status: status,
          date: date,
          page: currentPage
        },
        dataType: 'json',
        success: function(response) {
          console.log("1. Success callback được gọi!"); // Log số 1
          console.log("Dữ liệu nhận được:", response);  // Log số 2

          tableBody.empty(); // Xóa nội dung cũ

          // Render lại các hàng của bảng
          if (response.orders && response.orders.length > 0) {
            console.log("3. Bắt đầu lặp qua " + response.orders.length + " đơn hàng."); // Log số 3

            $.each(response.orders, function(index, order) {
              console.log("Đang xử lý đơn hàng:", order.formattedId); // Log mỗi lần lặp
              const formattedAmount = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(order.totalAmount);
              const row = `
        <tr>
            <td><input type="checkbox" class="form-check-input supplier-checkbox" title="Chọn nhà cung cấp này" onclick="event.stopPropagation();"></td>
            <td><i class="bi bi-star star-outline" onclick="toggleSupplierStar(this, event)"></i></td>
            <td style="color: #0D6EFD; cursor: pointer;" class="order-code" data-order-id="\${order.id}">\${order.formattedId}</td>
            <td>\${order.orderDate}</td>
            <td>\${order.customerName}</td>

            <%-- CỘT NÀY QUAN TRỌNG, CẦN DỮ LIỆU TỪ SERVER --%>
            <td>\${order.address}</td>

            <td class="text-end">\${formattedAmount}</td>
            <td class="text-center">
                <span class="status-badge status-\${order.status}">
                    \${order.statusDisplay}
                </span>
            </td>
        </tr>
    `;

              console.log("HTML của dòng được tạo:", row); // Log chuỗi HTML
              tableBody.append(row);
            });
          } else {
            console.log("3. Không có đơn hàng nào để hiển thị."); // Log nếu không có dữ liệu
            tableBody.html('<tr><td colspan="8" class="text-center">Không tìm thấy đơn hàng nào khớp với điều kiện.</td></tr>');
          }


          // Render lại phần phân trang
          renderPagination(response.totalPages, response.currentPage);
        },
        error: function(xhr, status, error) {
          tableBody.html('<tr><td colspan="8" class="text-center text-danger">Có lỗi xảy ra khi tải dữ liệu.</td></tr>');
          console.error("Lỗi AJAX: ", error);
        }
      });
    }

    // Hàm render lại các nút phân trang
    // HÃY THAY THẾ TOÀN BỘ HÀM CŨ BẰNG HÀM NÀY

    function renderPagination(totalPages, currentPage) {
      // Chuyển đổi currentPage sang kiểu số để đảm bảo các phép toán chính xác
      currentPage = parseInt(currentPage);

      // Xóa các nút phân trang cũ
      paginationContainer.empty();

      // Nếu chỉ có 1 trang hoặc không có trang nào, không cần hiển thị phân trang
      if (totalPages <= 1) {
        return;
      }

      let paginationHtml = '<ul class="pagination">';

      // 1. NÚT "TRƯỚC" (PREVIOUS)
      paginationHtml += `<li class="page-item \${currentPage === 1 ? 'disabled' : ''}">
                           <a class="page-link" href="#" data-page="\${currentPage - 1}">Trước</a>
                       </li>`;

      // 2. LOGIC HIỂN THỊ CÁC NÚT SỐ TRANG

      // Ngưỡng để quyết định khi nào nên dùng dấu "..."
      const pageThreshold = 7;

      if (totalPages <= pageThreshold) {
        // TRƯỜNG HỢP 1: TỔNG SỐ TRANG ÍT, HIỂN THỊ TẤT CẢ
        for (let i = 1; i <= totalPages; i++) {
          paginationHtml += `<li class="page-item \${i === currentPage ? 'active' : ''}">
                                   <a class="page-link" href="#" data-page="\${i}">\${i}</a>
                               </li>`;
        }
      } else {
        // TRƯỜNG HỢP 2: TỔNG SỐ TRANG NHIỀU, DÙNG DẤU "..."
        // Luôn hiển thị trang đầu tiên
        paginationHtml += `<li class="page-item \${currentPage === 1 ? 'active' : ''}">
                               <a class="page-link" href="#" data-page="1">1</a>
                           </li>`;

        // Xử lý dấu "..." bên trái
        if (currentPage > 4) {
          paginationHtml += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
        }

        // Xác định các trang ở giữa để hiển thị
        let startPage, endPage;
        if (currentPage <= 4) {
          // Gần đầu: hiển thị từ 2 đến 5
          startPage = 2;
          endPage = 5;
        } else if (currentPage >= totalPages - 3) {
          // Gần cuối: hiển thị 4 trang cuối cùng trước trang cuối
          startPage = totalPages - 4;
          endPage = totalPages - 1;
        } else {
          // Ở giữa: hiển thị trang trước, trang hiện tại, và trang sau
          startPage = currentPage - 1;
          endPage = currentPage + 1;
        }

        for (let i = startPage; i <= endPage; i++) {
          paginationHtml += `<li class="page-item \${i === currentPage ? 'active' : ''}">
                                   <a class="page-link" href="#" data-page="\${i}">\${i}</a>
                               </li>`;
        }

        // Xử lý dấu "..." bên phải
        if (currentPage < totalPages - 3) {
          paginationHtml += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
        }

        // Luôn hiển thị trang cuối cùng
        paginationHtml += `<li class="page-item \${currentPage === totalPages ? 'active' : ''}">
                               <a class="page-link" href="#" data-page="\${totalPages}">\${totalPages}</a>
                           </li>`;
      }

      // 3. NÚT "SAU" (NEXT)
      paginationHtml += `<li class="page-item \${currentPage === totalPages ? 'disabled' : ''}">
                           <a class="page-link" href="#" data-page="\${currentPage + 1}">Sau</a>
                       </li>`;

      paginationHtml += '</ul>';

      // Đưa HTML đã tạo vào container
      paginationContainer.html(paginationHtml);
    }
    // Gán sự kiện cho các input
    searchInput.on('keyup', function() {
      clearTimeout(debounceTimeout);
      debounceTimeout = setTimeout(() => {
        fetchAndRenderOrders(1); // Luôn tìm kiếm từ trang 1
      }, 500); // Chờ 0.5s sau khi người dùng ngừng gõ
    });

    statusFilter.on('change', function() {
      fetchAndRenderOrders(1);
    });

    dateFilter.on('change', function() {
      fetchAndRenderOrders(1);
    });

    // Gán sự kiện cho các nút phân trang (sử dụng event delegation)
    paginationContainer.on('click', '.page-link', function(e) {
      e.preventDefault();
      const page = $(this).data('page');
      if (page) {
        fetchAndRenderOrders(page);
      }
    });

    // Xử lý nút xóa bộ lọc
    $('#resetButton').on('click', function() { // Giả sử bạn có nút với id="resetButton"
      searchInput.val('');
      statusFilter.val('');
      dateFilter.val('');
      fetchAndRenderOrders(1); // Tải lại danh sách gốc
    });

    // Tải dữ liệu lần đầu khi trang được mở
    fetchAndRenderOrders(1); // Bạn có thể bỏ dòng này nếu trang đã tải sẵn danh sách từ JSP
  });
</script>