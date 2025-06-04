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
                  <select class="form-select" style="width: auto;">
                    <option value="">Tất cả trạng thái</option>
                    <option value="PENDING">Chờ xử lý</option>
                    <option value="CONFIRMED">Đã xác nhận</option>
                    <option value="SHIPPING">Đang giao hàng</option>
                    <option value="COMPLETED">Hoàn thành</option>
                    <option value="CANCELLED">Đã hủy</option>
                    <option value="RETURNED">Đã trả hàng</option>
                  </select>
                </label>
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
                  <th class="text-lg-center">Tổng tiền hàng</th>
                </tr>
                </thead>
                <tbody id="orderTableBody">
                <c:if test="${not empty orderList}">
                  <c:forEach var="order" items="${orderList}" varStatus="loop">
                    <tr>
                      <td><input type="checkbox" class="form-check-input supplier-checkbox" title="Chọn nhà cung cấp này" onclick="event.stopPropagation();"></td>
                      <td><i class="bi bi-star star-outline" onclick="toggleSupplierStar(this, event)"></i></td>
                      <td style="color: #0D6EFD; cursor: pointer;" class="order-code" data-order-id="${order.id}"><c:out value="${order.formattedOrderCode}" /></td>
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
                      <td><c:out value="${order.address}" /></td>
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
                <c:if test="${empty orderList}">
                  <tr>
                    <td colspan="9" class="text-center">Không có đơn hàng nào.</td>
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
                <input type="text" class="form-control" id="orderCode" value="DH<%= System.currentTimeMillis() %>" readonly>
              </div>
              <div class="mb-3">
                <label for="customer" class="form-label">Khách hàng <span class="text-danger">*</span></label>
                <select class="form-select" id="customer" required>
                  <option value="">Chọn khách hàng</option>
                  <c:forEach var="customer" items="${customerList}">
                    <option value="${customer.id}">${customer.name}</option>
                  </c:forEach>
                </select>
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
                    <option value="${payment.id}">${payment.paymentMethod}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="mb-3">
                <label for="deliveryMethod" class="form-label">Phương thức giao hàng <span class="text-danger">*</span></label>
                <select class="form-select" id="deliveryMethod" required>
                  <option value="">Chọn phương thức</option>
                  <c:forEach var="delivery" items="${deliveryMethods}">
                    <option value="${delivery.id}">${delivery.deliveryMethodName}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
          </div>

          <!-- Danh sách sản phẩm -->
          <h6 class="mb-3">Danh sách sản phẩm</h6>
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
                <td>
                  <input type="text" class="form-control product-id" placeholder="Nhập mã sản phẩm" oninput="fetchProduct(this)">
                </td>
                <td><input type="text" class="form-control product-name" readonly></td>
                <td><input type="number" class="form-control product-quantity" min="1" value="1" oninput="calculateRowTotal(this)"></td>
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
          </div>
          <div class="col-md-6">
            <p><strong>Ngày đặt:</strong> <span id="detailOrderDate"></span></p>
            <p><strong>Phương thức thanh toán:</strong> <span id="detailPaymentMethod"></span></p>
            <p><strong>Phương thức giao hàng:</strong> <span id="detailDeliveryMethod"></span></p>
            <p><strong>Trạng thái:</strong> <span id="detailStatus"></span></p>
          </div>
        </div>
        <h6 class="mb-3">Danh sách sản phẩm</h6>
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

  .form-select option[value="PENDING"] {
    background-color: #fff3cd;
    color: #664d03;
  }

  .form-select option[value="CONFIRMED"] {
    background-color: #cff4fc;
    color: #084298;
  }

  .form-select option[value="SHIPPING"] {
    background-color: #e8f4f8;
    color: #055160;
  }

  .form-select option[value="COMPLETED"] {
    background-color: #d1e7dd;
    color: #0f5132;
  }

  .form-select option[value="CANCELLED"] {
    background-color: #f8d7da;
    color: #842029;
  }

  .form-select option[value="RETURNED"] {
    background-color: #e2e3e5;
    color: #41464b;
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
    });

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

    // Script cho tìm kiếm và lọc
    const searchInput = document.getElementById('searchInput');
    const tableRows = document.querySelectorAll('table tbody tr');
    searchInput.addEventListener('keyup', function() {
      const searchTerm = this.value.toLowerCase();
      tableRows.forEach(row => {
        const orderCode = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
        const customer = row.querySelector('td:nth-child(5)').textContent.toLowerCase();
        if (orderCode.includes(searchTerm) || customer.includes(searchTerm)) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    });

    // Script cho lọc trạng thái và ngày
    const statusFilter = document.querySelector('select');
    const dateFilter = document.querySelector('input[type="date"]');
    statusFilter.addEventListener('change', filterOrders);
    dateFilter.addEventListener('change', filterOrders);

    function filterOrders() {
      const selectedStatus = statusFilter.value;
      const selectedDate = dateFilter.value ? new Date(dateFilter.value) : null;
      tableRows.forEach(row => {
        const rowStatus = row.dataset.status || '';
        const rowDate = new Date(row.cells[3].textContent);
        const rowDateOnly = new Date(rowDate.getFullYear(), rowDate.getMonth(), rowDate.getDate());
        const selectedDateOnly = selectedDate ? new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate()) : null;
        const matchesStatus = !selectedStatus || rowStatus.toLowerCase() === selectedStatus.toLowerCase();
        const matchesDate = !selectedDate || rowDateOnly.getTime() === selectedDateOnly.getTime();
        row.style.display = (matchesStatus && matchesDate) ? '' : 'none';
      });
      updateFilteredCount();
    }

    function updateFilteredCount() {
      const visibleRows = document.querySelectorAll('tbody tr:not([style*="none"])').length;
      const totalRows = tableRows.length;
      let counter = document.querySelector('.filter-counter');
      if (!counter) {
        counter = document.createElement('div');
        counter.className = 'filter-counter text-muted mt-2';
        document.querySelector('.table-responsive').insertAdjacentElement('beforebegin', counter);
      }
      counter.textContent = `Hiển thị ${visibleRows} / ${totalRows} đơn hàng`;
    }

    const resetButton = document.createElement('button');
    resetButton.className = 'btn btn-outline-secondary';
    resetButton.innerHTML = '<i class="bi bi-x-circle me-1"></i>Xóa bộ lọc';
    resetButton.addEventListener('click', function() {
      statusFilter.value = '';
      dateFilter.value = '';
      tableRows.forEach(row => row.style.display = '');
      updateFilteredCount();
    });
    dateFilter.insertAdjacentElement('afterend', resetButton);
    updateFilteredCount();

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

  // Script cho modal tạo đơn hàng mới
  function fetchProduct(input) {
    const row = input.closest('tr');
    const toyId = input.value.trim();
    const nameInput = row.querySelector('.product-name');
    const priceInput = row.querySelector('.product-price');
    const quantityInput = row.querySelector('.product-quantity');

    if (toyId) {
      fetch(`/order?action=getToy&id=${toyId}`)
              .then(response => response.json())
              .then(data => {
                if (data.toy) {
                  nameInput.value = data.toy.name;
                  priceInput.value = data.toy.price;
                  quantityInput.value = quantityInput.value || 1;
                  calculateRowTotal(quantityInput);
                } else {
                  nameInput.value = '';
                  priceInput.value = '';
                  quantityInput.value = '';
                  row.querySelector('.product-total').value = '';
                  alert('Sản phẩm không tồn tại hoặc đã bị xóa!');
                }
                updateOrderSummary();
              })
              .catch(error => {
                console.error('Error fetching toy:', error);
                alert('Lỗi khi tìm sản phẩm!');
              });
    } else {
      nameInput.value = '';
      priceInput.value = '';
      quantityInput.value = '';
      row.querySelector('.product-total').value = '';
      updateOrderSummary();
    }
  }

  function calculateRowTotal(input) {
    const row = input.closest('tr');
    const quantity = parseInt(input.value) || 0;
    const price = parseFloat(row.querySelector('.product-price').value) || 0;


    const total = quantity * price;
    row.querySelector('.product-total').value = total;
    updateOrderSummary();
  }

  function addProductRow() {
    const tbody = document.getElementById('productTableBody');
    const newRow = document.createElement('tr');
    newRow.innerHTML = `
      <td><input type="text" class="form-control product-id" placeholder="Nhập mã sản phẩm" oninput="fetchProduct(this)"></td>
      <td><input type="text" class="form-control product-name" readonly></td>
<!--      <td><input type="number" class="form-control product-quantity" min="1" value="1" data-stock="0" oninput="calculateRowTotal(this)"></td>-->
      <td><input type="number" class="form-control product-price" readonly></td>
      <td><input type="number" class="form-control product-total" readonly></td>
      <td><button type="button" class="btn btn-danger btn-sm" onclick="removeProductRow(this)">Xóa</button></td>
    `;
    tbody.appendChild(newRow);
  }

  function removeProductRow(button) {
    const row = button.closest('tr');
    row.remove();
    updateOrderSummary();
  }

  function updateOrderSummary() {
    const rows = document.querySelectorAll('#productTableBody tr');
    let totalQuantity = 0;
    let totalAmount = 0;
    rows.forEach(row => {
      const quantity = parseInt(row.querySelector('.product-quantity').value) || 0;
      const total = parseFloat(row.querySelector('.product-total').value) || 0;
      totalQuantity += quantity;
      totalAmount += total;
    });
    document.getElementById('totalQuantity').textContent = totalQuantity;
    document.getElementById('totalAmount').textContent = totalAmount.toLocaleString('vi-VN');
  }

  function createNewOrder() {
    const form = document.getElementById('newOrderForm');
    const customerId = document.getElementById('customer').value;
    const orderCode = document.getElementById('orderCode').value;
    const orderDate = document.getElementById('orderDate').value;
    const address = document.getElementById('address').value;
    const paymentMethodId = document.getElementById('paymentMethod').value;
    const deliveryMethodId = document.getElementById('deliveryMethod').value;
    const products = Array.from(document.querySelectorAll('#productTableBody tr')).map(row => ({
      toyId: row.querySelector('.product-id').value,
      quantity: parseInt(row.querySelector('.product-quantity').value) || 0,
      price: parseFloat(row.querySelector('.product-price').value) || 0
    }));

    if (!customerId) {
      alert('Vui lòng chọn khách hàng!');
      return;
    }
    if (!orderCode) {
      alert('Mã đơn hàng không được để trống!');
      return;
    }
    if (!orderDate) {
      alert('Vui lòng chọn ngày đặt hàng!');
      return;
    }
    if (!address) {
      alert('Vui lòng nhập địa chỉ nhận hàng!');
      return;
    }
    if (!paymentMethodId) {
      alert('Vui lòng chọn phương thức thanh toán!');
      return;
    }
    if (!deliveryMethodId) {
      alert('Vui lòng chọn phương thức giao hàng!');
      return;
    }
    if (products.length === 0 || products.every(p => !p.toyId)) {
      alert('Vui lòng thêm ít nhất một sản phẩm!');
      return;
    }
    for (const product of products) {
      if (!product.toyId || product.quantity <= 0 || product.price <= 0) {
        alert('Vui lòng kiểm tra thông tin sản phẩm!');
        return;
      }
    }

    const orderData = {
      orderCode,
      customerId,
      orderDate,
      address,
      paymentMethodId,
      deliveryMethodId,
      status: 'PENDING',
      products
    };
    fetch('/order?action=create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(orderData)
    })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                alert('Đã tạo đơn hàng mới!');
                bootstrap.Modal.getInstance(document.getElementById('newOrderModal')).hide();
                window.location.reload();
              } else {
                alert('Lỗi khi tạo đơn hàng: ' + data.message);
              }
            })
            .catch(error => {
              console.error('Error creating order:', error);
              alert('Lỗi khi tạo đơn hàng!');
            });
  }

  function mergeOrders(orderIds) {
    const modal = bootstrap.Modal.getInstance(document.getElementById('mergeOrderModal'));
    const note = modal.element.querySelector('textarea').value;
    alert(`Đã gộp ${orderId.split(',').length} đơn hàng thành công!`);
    modal.hide();
  }

  function fetchOrderDetails(orderId) {
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
                throw new Error(`HTTP error! Status: ${response.status}`);
              }
              return response.text();
            })
            .then(text => {
              console.log('Phản hồi từ server:', text);
              try {
                const data = JSON.parse(text);
                if (data.order) {
                  document.getElementById('detailOrderCode').textContent = data.order.id || 'N/A';
                  document.getElementById('detailCustomer').textContent = data.order.user.name || 'N/A';
                  document.getElementById('detailAddress').textContent = data.order.address || 'N/A';
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
                  document.getElementById('detailStatus').textContent = data.order.status || 'N/A';

                  const tbody = document.getElementById('detailProductTableBody');
                  tbody.innerHTML = '';
                  let totalQuantity = 0;
                  let totalAmount = 0;

                  if (data.order.products && data.order.products.length > 0) {
                    data.order.products.forEach(product => {
                      const row = document.createElement('tr');
                      const total = product.quantity * product.price;
                      // Sử dụng chuỗi nối thay vì template literal
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

                  const modal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
                  modal.show();
                } else {
                  alert('Không tìm thấy thông tin đơn hàng!');
                }
              } catch (e) {
                console.error('Phản hồi không phải JSON:', text);
                alert('Lỗi: Phản hồi từ máy chủ không đúng định dạng JSON!');
              }
            })
            .catch(error => {
              console.error('Lỗi khi lấy chi tiết đơn hàng:', error);
              alert('Lỗi khi lấy thông tin đơn hàng: ' + error.message);
            });
  }
</script>