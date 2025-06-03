<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  /* Tùy chỉnh bảng */
  .table-hover tbody tr:hover {
    background-color: #f8f9fa;
  }

  .table th,
  .table td {
    vertical-align: middle;
    text-align: center;
  }

  /* Thêm style cho header của bảng */
  .table thead tr:first-child {
    background-color: #fff3cd;
    font-weight: bold;
  }

  /* Tùy chỉnh nút */
  .btn-success,
  .btn-primary,
  .btn-secondary {
    margin-left: 5px;
  }

  .form-check-input:checked+.form-check-label::before {
    background-color: #198754;
    border-color: #198754;
  }

  #company:checked+.form-check-label::before {
    background-color: #0d6efd;
    border-color: #0d6efd;
  }

  #individual:checked+.form-check-label::after {
    content: '\\f26e';
    font-family: bootstrap-icons !important;
    position: absolute;
    left: 4px;
    top: 1px;
    color: white;
    font-size: 0.8em;
  }

  #company:checked+.form-check-label::after {
    content: '\\f283';
    font-family: bootstrap-icons !important;
    position: absolute;
    left: 4px;
    top: 1px;
    color: white;
    font-size: 0.8em;
  }

  /* Style cho phần chi tiết khách hàng */
  .customer-detail-container {
    background-color: #f8f9fc;
    border-top: 1px solid #dee2e6;
  }

  .customer-detail-row td {
    border-top: none !important;
  }

  #customer-table-body tr:not(.total-row):not(.customer-detail-row):hover {
    cursor: pointer;
    background-color: #e9ecef;
  }

  #customer-table-body tr.table-active {
    background-color: #cfe2ff !important;
  }

  .nav-tabs .nav-link {
    color: #6c757d;
    border-bottom-width: 2px;
  }

  .nav-tabs .nav-link.active {
    color: #0d6efd;
    border-color: #dee2e6 #dee2e6 #0d6efd;
  }

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
    border: 1px solid #dee2e6; /* Loại bỏ viền */
    border-radius: 0; /* Loại bỏ bo góc */
    background: none; /* Loại bỏ nền */
    transition: color 0.2s;
  }

  .pagination-container .page-link:hover {
    color: #0056b3;
    background: none;
  }

  .pagination-container .page-item.active .page-link {
    color: black;
    font-weight: bold;
    background: none;
    border: none;
  }

  .pagination-container .page-item.disabled .page-link {
    color: #6c757d;
    pointer-events: none;
    background: none;
    border: none;
  }

  /* Loại bỏ gạch chân cho li */
  ul li {
    text-decoration: none;
    list-style: none; /* Loại bỏ dấu đầu dòng nếu có */
  }
</style>

<jsp:include page="head.jsp" />
<jsp:include page="header.jsp" />
<div class="sidebar">
  <jsp:include page="sidebar.jsp" />
</div>

<main id="main" class="main">
  <div class="pagetitle">
    <h1>Danh sách khách hàng</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="homepage">Trang chủ</a></li>
        <li class="breadcrumb-item">Khách hàng</li>
        <li class="breadcrumb-item active">Danh sách khách hàng</li>
      </ol>
    </nav>
  </div><!-- End Page Title -->

  <section class="section mt-4">
    <div class="row">
      <div class="col-lg-12">
        <!-- Controls Bar (Search and Actions) - Made Sticky -->
        <div id="customer-controls" class="bg-light p-3 mb-3 sticky-top shadow-sm" style="z-index: 990;">
          <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div class="d-flex align-items-center gap-2 flex-grow-1 me-sm-2 me-md-3 mb-2 mb-sm-0">
              <div class="input-group input-group-sm" style="flex: 1; min-width: 110px;">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input type="text" class="form-control" placeholder="Mã, tên, SĐT" id="customerSearchInput">
              </div>
              <div class="input-group input-group-sm" style="flex: 1; min-width: 110px;">
                <select class="form-select form-select-sm" id="customerGenderFilterInline" aria-label="Giới tính">
                  <option selected value="">Tất cả giới tính</option>
                  <option value="Nam">Nam</option>
                  <option value="Nữ">Nữ</option>
                </select>
              </div>
              <div class="input-group input-group-sm" style="flex: 1; min-width: 110px;">
                <select class="form-select form-select-sm" id="creationDateFilterInline" aria-label="Ngày tạo">
                  <option selected value="">Toàn thời gian</option>
                  <option value="today">Hôm nay</option>
                  <option value="this_week">Tuần này</option>
                  <option value="this_month">Tháng này</option>
                  <option value="custom">Tùy chọn...</option>
                </select>
              </div>
            </div>
            <div>
              <div class="d-flex align-items-stretch">
                <button class="btn btn-success action-btn me-1" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                  <i class="bi bi-plus"></i> Khách hàng
                </button>
                <div class="btn-group me-1">
                  <button class="btn btn-primary action-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-file-earmark"></i> File
                  </button>
                  <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#" id="exportCustomerCsvBtn">Xuất CSV</a></li>
                    <li><a class="dropdown-item" href="#" id="importCustomerCsvBtn">Nhập CSV</a></li>
                  </ul>
                </div>
                <div class="btn-group">
                  <button class="btn btn-secondary action-btn dropdown-toggle" type="button" id="columnToggler" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false">
                    <i class="bi bi-list"></i>
                  </button>
                  <ul class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="columnToggler" id="columnSelectionDropdown" style="min-width: 250px; max-height: 300px; overflow-y: auto;">
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- End Controls Bar -->

        <div class="card">
          <div class="card-body">
            <!-- Table -->
            <table class="table table-hover" id="customerTable">
              <thead>
              <!-- Headers will be populated by JavaScript -->
              </thead>
              <tbody id="customer-table-body">
              <c:if test="${not empty userList}">
                <c:forEach var="user" items="${userList}" varStatus="loop">
                  <tr data-code="${user.formattedUserCode}"
                      data-name="${user.name}"
                      data-phone="${user.phone}"
                      data-email="${user.email}"
                      data-address="${user.address}"
                      data-creator="${user.creator}"
                      data-created="${user.createdDate != null ? user.createdDate : ''}"
                      data-group="${user.group}"
                      data-birthday="${user.dob != null ? user.dob : ''}"
                      data-gender="${user.gender != null ? user.gender : ''}"
                      data-note="${user.note}"
                      data-facebook="${user.facebook}"
                      data-type="${user.customerType != null ? user.customerType : 'Cá nhân'}"
                      data-debt="0"
                      data-total-sale="0"
                      data-net-sale="0"
                      data-taxcode="${user.taxCode}"
                      data-idcard="${user.idCard}">
                    <td><input type="checkbox"></td>
                    <td><c:out value="${user.formattedUserCode}" /></td>
                    <td><c:out value="${user.name}" /></td>
                    <td><c:out value="${user.phone}" /></td>
                    <td>0</td> <!-- Debt: Bỏ fmt:formatNumber -->
                    <td>0</td> <!-- Total Sale: Bỏ fmt:formatNumber -->
                    <td>0</td> <!-- Net Sale: Bỏ fmt:formatNumber -->
                  </tr>
                </c:forEach>
              </c:if>
              <c:if test="${empty userList}">
                <tr>
                  <td colspan="7" class="text-center">Không có khách hàng nào.</td>
                </tr>
              </c:if>
              </tbody>
            </table>

            <!-- Pagination -->
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
              <nav aria-label="Page navigation">
                <ul class="pagination-container">
                  <c:set var="startPage" value="${currentPage - 1}"/>
                  <c:set var="endPage" value="${currentPage + 1}"/>

                  <c:if test="${startPage < 1}">
                    <c:set var="endPage" value="${endPage + (1 - startPage)}"/>
                    <c:set var="startPage" value="1"/>
                  </c:if>
                  <c:if test="${endPage > totalPages}">
                    <c:set var="startPage" value="${startPage - (endPage - totalPages)}"/>
                    <c:set var="endPage" value="${totalPages}"/>
                    <c:if test="${startPage < 1}"><c:set var="startPage" value="1"/></c:if>
                  </c:if>

                  <c:if test="${startPage > 1}">
                    <li class="page-item">
                      <a class="page-link" href="customer?page=1">1</a>
                    </li>
                    <c:if test="${startPage > 2}">
                      <li class="page-item disabled"><span class="page-link">...</span></li>
                    </c:if>
                  </c:if>

                  <c:forEach begin="${startPage}" end="${endPage}" var="i">
                    <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
                      <a class="page-link" href="customer?page=${i}">${i}</a>
                    </li>
                  </c:forEach>
                </ul>
              </nav>
            </c:if>
            <!-- End Pagination -->
            <!-- End Pagination -->
          </div>
        </div>
      </div>
    </div>
  </section>
</main><!-- End #main -->

<!-- Modal Thêm Khách Hàng -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addCustomerModalLabel">Thêm khách hàng <span class="text-muted small">| Chi nhánh tạo: Chi nhánh trung tâm</span></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form>
          <div class="row">
            <div class="col-md-3">
              <div class="mb-3 text-center">
                <div id="imagePreviewArea" class="border rounded d-flex align-items-center justify-content-center mb-2" style="height: 150px; width: 150px; border-style: dashed!important; margin:auto; overflow: hidden;">
                  <span class="text-muted">Ảnh</span>
                </div>
                <label for="customerImage" class="btn btn-success btn-sm">Chọn ảnh</label>
                <input type="file" class="form-control d-none" id="customerImage">
              </div>
            </div>
            <div class="col-md-4">
              <div class="mb-3">
                <label for="customerCode" class="form-label small">Mã khách hàng</label>
                <input type="text" class="form-control form-control-sm" id="customerCode" placeholder="Mã mặc định">
              </div>
              <div class="mb-3">
                <label for="customerName" class="form-label small">Tên khách hàng</label>
                <input type="text" class="form-control form-control-sm" id="customerName">
              </div>
              <div class="mb-3">
                <label for="customerPhone" class="form-label small">Điện thoại</label>
                <input type="text" class="form-control form-control-sm" id="customerPhone">
              </div>
              <div class="mb-3">
                <label for="customerBirthdate" class="form-label small d-block">Ngày sinh</label>
                <div class="input-group input-group-sm">
                  <input type="text" class="form-control form-control-sm datepicker" id="customerBirthdate" placeholder="dd/mm/yyyy">
                  <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                  <div class="ms-3 d-inline-flex align-items-center">
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="gender" id="male" value="Nam">
                      <label class="form-check-label small" for="male">Nam</label>
                    </div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="gender" id="female" value="Nữ">
                      <label class="form-check-label small" for="female">Nữ</label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="mb-3">
                <label for="customerAddress" class="form-label small">Địa chỉ</label>
                <input type="text" class="form-control form-control-sm" id="customerAddress">
              </div>
              <div class="mb-3">
                <label for="customerRegion" class="form-label small">Khu vực</label>
                <div class="input-group input-group-sm">
                  <span class="input-group-text"><i class="bi bi-search"></i></span>
                  <input type="text" class="form-control form-control-sm" id="customerRegion" placeholder="Chọn Tỉnh/TP - Quận/Huyện">
                </div>
              </div>
              <div class="mb-3">
                <label for="customerWard" class="form-label small">Phường xã</label>
                <div class="input-group input-group-sm">
                  <span class="input-group-text"><i class="bi bi-search"></i></span>
                  <input type="text" class="form-control form-control-sm" id="customerWard" placeholder="Chọn Phường/Xã">
                </div>
              </div>
            </div>
            <div class="col-md-5">
              <div class="mb-3">
                <label class="form-label small d-block">Loại khách</label>
                <div class="form-check form-check-inline custom-radio">
                  <input class="form-check-input" type="radio" name="customerType" id="individual" value="Cá nhân" checked>
                  <label class="form-check-label small" for="individual">Cá nhân</label>
                </div>
                <div class="form-check form-check-inline custom-radio">
                  <input class="form-check-input" type="radio" name="customerType" id="company" value="Công ty">
                  <label class="form-check-label small" for="company">Công ty</label>
                </div>
              </div>
              <div class="mb-3">
                <label for="taxCode" class="form-label small">Mã số thuế</label>
                <input type="text" class="form-control form-control-sm" id="taxCode">
              </div>
              <div class="mb-3">
                <label for="idCard" class="form-label small">Số CMND/CCCD</label>
                <input type="text" class="form-control form-control-sm" id="idCard">
              </div>
              <div class="mb-3">
                <label for="email" class="form-label small">Email</label>
                <input type="email" class="form-control form-control-sm" id="email">
              </div>
              <div class="mb-3">
                <label for="facebook" class="form-label small">Facebook</label>
                <input type="text" class="form-control form-control-sm" id="facebook">
              </div>
              <div class="mb-3">
                <label for="group" class="form-label small">Nhóm</label>
                <input type="text" class="form-control form-control-sm" id="group">
              </div>
              <div class="mb-3">
                <label for="note" class="form-label small">Ghi chú</label>
                <div class="input-group input-group-sm">
                  <textarea class="form-control form-control-sm" id="note" rows="2"></textarea>
                  <span class="input-group-text"><i class="bi bi-pencil"></i></span>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success btn-sm" id="saveCustomerBtn"><i class="bi bi-save me-1"></i> Lưu (F9)</button>
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal"><i class="bi bi-x-circle me-1"></i> Bỏ qua</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Thêm Địa Chỉ Nhận Hàng -->
<div class="modal fade" id="addAddressModal" tabindex="-1" aria-labelledby="addAddressModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addAddressModalLabel">Thêm địa chỉ nhận mới</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="addAddressForm">
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label for="addressName" class="form-label form-label-sm">Tên địa chỉ</label>
                <input type="text" class="form-control form-control-sm" id="addressName">
              </div>
              <div class="mb-3">
                <label for="recipientName" class="form-label form-label-sm">Tên người nhận</label>
                <input type="text" class="form-control form-control-sm" id="recipientName">
              </div>
              <div class="mb-3">
                <label for="recipientPhone" class="form-label form-label-sm">Số điện thoại</label>
                <input type="text" class="form-control form-control-sm" id="recipientPhone">
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label for="shippingAddress" class="form-label form-label-sm">Địa chỉ nhận</label>
                <input type="text" class="form-control form-control-sm" id="shippingAddress">
              </div>
              <div class="mb-3">
                <label for="shippingRegion" class="form-label form-label-sm">Khu vực:</label>
                <div class="input-group input-group-sm">
                  <span class="input-group-text"><i class="bi bi-search"></i></span>
                  <input type="text" class="form-control" id="shippingRegion" placeholder="Tìm Tỉnh/Thành phố - Quận/Huyện">
                </div>
              </div>
              <div class="mb-3">
                <label for="shippingWard" class="form-label form-label-sm">Phường/Xã:</label>
                <div class="input-group input-group-sm">
                  <span class="input-group-text"><i class="bi bi-search"></i></span>
                  <input type="text" class="form-control" id="shippingWard" placeholder="Tìm Phường/Xã">
                </div>
              </div>
            </div>
          </div>
          <input type="hidden" id="addAddressCustomerCode">
        </form>
      </div>
      <div class="modal-footer justify-content-end">
        <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Bỏ qua</button>
        <button type="button" class="btn btn-primary btn-sm" id="saveAddressBtn">Xong</button>
      </div>
    </div>
  </div>
</div>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

<!-- Vendor JS Files -->
<script src="${pageContext.request.contextPath}/assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/chart.js/chart.umd.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/echarts/echarts.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/quill/quill.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/tinymce/tinymce.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/php-email-form/validate.js"></script>

<!-- Template Main JS File -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const tableBody = document.getElementById('customer-table-body');
    let activeDetailRow = null;
    let activeClickedRow = null;

    const addCustomerModalElement = document.getElementById('addCustomerModal');
    const addCustomerModal = bootstrap.Modal.getOrCreateInstance(addCustomerModalElement);
    const saveCustomerBtn = document.getElementById('saveCustomerBtn');
    const addCustomerForm = addCustomerModalElement.querySelector('form');
    const modalTitle = document.getElementById('addCustomerModalLabel');
    let editMode = false;
    let customerCodeToEdit = null;

    // "Chọn tất cả" logic
    const mainTable = document.querySelector('.card .table');
    const headerCheckbox = mainTable ? mainTable.querySelector('thead input[type="checkbox"]') : null;
    const tableBodyForSelectAll = document.getElementById('customer-table-body');

    if (headerCheckbox && tableBodyForSelectAll) {
      headerCheckbox.addEventListener('change', () => {
        const bodyCheckboxes = tableBodyForSelectAll.querySelectorAll('tbody input[type="checkbox"]');
        bodyCheckboxes.forEach(checkbox => {
          checkbox.checked = headerCheckbox.checked;
        });
      });

      tableBodyForSelectAll.addEventListener('change', (event) => {
        if (event.target.type === 'checkbox') {
          const bodyCheckboxes = tableBodyForSelectAll.querySelectorAll('tbody input[type="checkbox"]');
          const allChecked = Array.from(bodyCheckboxes).every(cb => cb.checked);
          const someChecked = Array.from(bodyCheckboxes).some(cb => cb.checked);

          if (bodyCheckboxes.length > 0) {
            headerCheckbox.checked = allChecked;
          }
        }
      });
    }

    // Modal Thêm địa chỉ
    const addAddressModalElement = document.getElementById('addAddressModal');
    const addAddressModal = addAddressModalElement ? bootstrap.Modal.getOrCreateInstance(addAddressModalElement) : null;
    const saveAddressBtn = document.getElementById('saveAddressBtn');
    const addAddressForm = document.getElementById('addAddressForm');
    const addAddressCustomerCodeInput = document.getElementById('addAddressCustomerCode');

    // Column Toggling Logic
    const columnConfiguration = {
      colCode: { label: 'Mã khách hàng', dataAttr: 'code', defaultChecked: true },
      colName: { label: 'Tên khách hàng', dataAttr: 'name', defaultChecked: true },
      colType: { label: 'Loại khách', dataAttr: 'type', defaultChecked: false },
      colPhone: { label: 'Điện thoại', dataAttr: 'phone', defaultChecked: true },
      colGroup: { label: 'Nhóm khách hàng', dataAttr: 'group', defaultChecked: false },
      colGender: { label: 'Giới tính', dataAttr: 'gender', defaultChecked: true },
      colAddress: { label: 'Địa chỉ', dataAttr: 'address', defaultChecked: false },
      colCreator: { label: 'Người tạo', dataAttr: 'creator', defaultChecked: false },
      colCreatedDate: { label: 'Ngày tạo', dataAttr: 'created', defaultChecked: false },
      colNote: { label: 'Ghi chú', dataAttr: 'note', defaultChecked: false },
      colDebt: { label: 'Nợ hiện tại', dataAttr: 'debt', defaultChecked: true },
      colTotalSale: { label: 'Tổng bán', dataAttr: 'totalSale', defaultChecked: true },
      colNetSale: { label: 'Tổng bán trừ trả hàng', dataAttr: 'netSale', defaultChecked: true }
    };

    // Load saved column selections from localStorage
    function getSavedColumns() {
      const saved = localStorage.getItem('customerTableColumns');
      return saved ? JSON.parse(saved) : Object.keys(columnConfiguration).filter(key => columnConfiguration[key].defaultChecked);
    }

    // Save column selections to localStorage
    function saveColumns(columns) {
      localStorage.setItem('customerTableColumns', JSON.stringify(columns));
    }

    const columnSelectionDropdown = document.getElementById('columnSelectionDropdown');
    const customerTable = document.getElementById('customerTable');
    const customerTableHead = customerTable ? customerTable.querySelector('thead') : null;
    const columnToggler = document.getElementById('columnToggler');

    function renderColumnSelectionCheckboxes() {
      if (!columnSelectionDropdown) {
        console.error("Column selection dropdown not found!");
        return;
      }
      columnSelectionDropdown.innerHTML = '';
      const savedColumns = getSavedColumns();

      Object.keys(columnConfiguration).forEach(key => {
        const colConfig = columnConfiguration[key];
        const li = document.createElement('li');
        li.classList.add('dropdown-item');

        let inputHtml = '<div class="form-check">' +
                '<input class="form-check-input column-toggle-checkbox" type="checkbox" value="' + key + '" id="checkbox-' + key + '"';
        if (savedColumns.includes(key)) {
          inputHtml += ' checked';
        }
        inputHtml += '>' +
                '<label class="form-check-label" for="checkbox-' + key + '">' +
                colConfig.label +
                '</label>' +
                '</div>';
        li.innerHTML = inputHtml;

        li.addEventListener('click', (e) => e.stopPropagation());
        columnSelectionDropdown.appendChild(li);
      });

      const checkboxes = columnSelectionDropdown.querySelectorAll('.column-toggle-checkbox');
      checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', () => {
          const visibleColumns = Array.from(columnSelectionDropdown.querySelectorAll('.column-toggle-checkbox:checked')).map(cb => cb.value);
          saveColumns(visibleColumns);
          renderTable();
          filterCustomerRows();
        });
      });
    }

    function getVisibleColumns() {
      const savedColumns = getSavedColumns();
      return savedColumns.filter(col => columnConfiguration[col]);
    }

    function renderTable() {
      if (!customerTableHead || !tableBody) {
        console.error("Table head or body not found!");
        return;
      }

      const visibleColumnKeys = getVisibleColumns();

      customerTableHead.innerHTML = '';
      const headerRow = customerTableHead.insertRow();

      const thCheckbox = document.createElement('th');
      thCheckbox.scope = 'col';
      const mainCheckbox = document.createElement('input');
      mainCheckbox.type = 'checkbox';
      mainCheckbox.id = 'selectAllCustomersCheckbox';
      thCheckbox.appendChild(mainCheckbox);
      headerRow.appendChild(thCheckbox);

      visibleColumnKeys.forEach(key => {
        const colConfig = columnConfiguration[key];
        if (colConfig) {
          const th = document.createElement('th');
          th.scope = 'col';
          th.textContent = colConfig.label;
          headerRow.appendChild(th);
        }
      });

      const newHeaderCheckbox = document.getElementById('selectAllCustomersCheckbox');
      if (newHeaderCheckbox && tableBody) {
        newHeaderCheckbox.addEventListener('change', () => {
          const bodyCheckboxes = tableBody.querySelectorAll('tbody tr:not(.customer-detail-row) input[type="checkbox"]');
          bodyCheckboxes.forEach(checkbox => {
            checkbox.checked = newHeaderCheckbox.checked;
          });
        });
      }

      const dataRows = tableBody.querySelectorAll('tr:not(.customer-detail-row)');
      dataRows.forEach(row => {
        const cells = Array.from(row.cells);
        for (let i = cells.length - 1; i > 0; i--) {
          row.deleteCell(i);
        }

        visibleColumnKeys.forEach(key => {
          const colConfig = columnConfiguration[key];
          if (colConfig) {
            const cell = row.insertCell();
            let cellValue = row.dataset[colConfig.dataAttr] || '';
            if (['colDebt', 'colTotalSale', 'colNetSale'].includes(key) && cellValue) {
              const num = parseFloat(String(cellValue).replace(/,/g, ''));
              cellValue = isNaN(num) ? cellValue : Math.round(num).toString();
            }
            if (['colTotalSale', 'colNetSale'].includes(key) && cellValue) {
              cell.innerHTML = '<strong>' + cellValue + '</strong>';
            } else {
              cell.textContent = cellValue;
            }
          }
        });
      });

      if (activeDetailRow) {
        const newColspan = headerRow.cells.length;
        const detailCell = activeDetailRow.querySelector('td');
        if (detailCell) {
          detailCell.colSpan = newColspan;
        }
      }
    }

    // Customer Table Filtering Logic
    const searchInput = document.getElementById('customerSearchInput');
    const genderFilterSelect = document.getElementById('customerGenderFilterInline');
    const dateFilterSelect = document.getElementById('creationDateFilterInline');

    function parseDateYYYYMMDD(dateString) {
      if (!dateString) return null;
      const parts = dateString.split('-');
      if (parts.length === 3) {
        const year = parseInt(parts[0], 10);
        const month = parseInt(parts[1], 10) - 1;
        const day = parseInt(parts[2], 10);
        if (!isNaN(day) && !isNaN(month) && !isNaN(year)) {
          return new Date(year, month, day);
        }
      }
      return null;
    }

    function filterCustomerRows() {
      if (!tableBody) return;

      const searchTerm = searchInput ? searchInput.value.toLowerCase().trim() : '';
      const selectedGender = genderFilterSelect ? genderFilterSelect.value.toLowerCase() : '';
      const selectedDateOption = dateFilterSelect ? dateFilterSelect.value : '';

      const rows = tableBody.getElementsByTagName('tr');

      for (const row of rows) {
        if (row.classList.contains('total-row') || row.classList.contains('customer-detail-row')) {
          continue;
        }

        const code = (row.getAttribute('data-code') || '').toLowerCase();
        const name = (row.getAttribute('data-name') || '').toLowerCase();
        const phone = (row.getAttribute('data-phone') || '').toLowerCase();
        const gender = (row.getAttribute('data-gender') || '').toLowerCase();
        const createdDateStr = row.getAttribute('data-created') || '';

        let matchesSearch = true;
        if (searchTerm) {
          matchesSearch = code.includes(searchTerm) ||
                  name.includes(searchTerm) ||
                  phone.includes(searchTerm);
        }

        let matchesGender = true;
        if (selectedGender) {
          matchesGender = gender === selectedGender;
        }

        let matchesDate = true;
        if (selectedDateOption && createdDateStr) {
          const rowDate = parseDateYYYYMMDD(createdDateStr);
          if (rowDate) {
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (selectedDateOption === 'today') {
              matchesDate = rowDate.toDateString() === today.toDateString();
            } else if (selectedDateOption === 'this_week') {
              const currentDay = today.getDay();
              const firstDayOfWeek = new Date(today);
              firstDayOfWeek.setDate(today.getDate() - (currentDay === 0 ? 6 : currentDay - 1));
              firstDayOfWeek.setHours(0, 0, 0, 0);

              const lastDayOfWeek = new Date(firstDayOfWeek);
              lastDayOfWeek.setDate(firstDayOfWeek.getDate() + 6);
              lastDayOfWeek.setHours(23, 59, 59, 999);
              matchesDate = rowDate >= firstDayOfWeek && rowDate <= lastDayOfWeek;
            } else if (selectedDateOption === 'this_month') {
              const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);
              const monthEnd = new Date(today.getFullYear(), today.getMonth() + 1, 0);
              monthEnd.setHours(23, 59, 59, 999);
              matchesDate = rowDate >= monthStart && rowDate <= monthEnd;
            }
          } else {
            matchesDate = false;
          }
        }

        if (matchesSearch && matchesGender && matchesDate) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }

        const nextRow = row.nextElementSibling;
        if (nextRow && nextRow.classList.contains('customer-detail-row')) {
          nextRow.style.display = row.style.display;
        }
      }
    }

    // Attach event listeners
    if (searchInput) searchInput.addEventListener('input', filterCustomerRows);
    if (genderFilterSelect) genderFilterSelect.addEventListener('change', filterCustomerRows);
    if (dateFilterSelect) dateFilterSelect.addEventListener('change', filterCustomerRows);

    const resetModalToAddMode = () => {
      modalTitle.innerHTML = 'Thêm khách hàng <span class="text-muted small">| Chi nhánh tạo: Chi nhánh trung tâm</span>';
      saveCustomerBtn.innerHTML = '<i class="bi bi-save me-1"></i> Lưu (F9)';
      if (addCustomerForm) addCustomerForm.reset();
      const customerCodeInput = document.getElementById('customerCode');
      if (customerCodeInput) customerCodeInput.disabled = false;
      editMode = false;
      customerCodeToEdit = null;
    };

    if (addCustomerModalElement) {
      addCustomerModalElement.addEventListener('hidden.bs.modal', resetModalToAddMode);
    }

    if (tableBody) {
      tableBody.addEventListener('click', (event) => {
        if (event.target.classList.contains('edit-customer-detail-btn') || event.target.closest('.edit-customer-detail-btn')) {
          if (!activeClickedRow) return;

          const code = activeClickedRow.dataset.code;
          const name = activeClickedRow.dataset.name;
          const phone = activeClickedRow.dataset.phone;
          const birthday = activeClickedRow.dataset.birthday;
          const address = activeClickedRow.dataset.address;
          const gender = activeClickedRow.dataset.gender;
          const type = activeClickedRow.dataset.type || 'Cá nhân';
          const taxCode = activeClickedRow.dataset.taxcode || '';
          const idCard = activeClickedRow.dataset.idcard || '';
          const email = activeClickedRow.dataset.email;
          const facebook = activeClickedRow.dataset.facebook;
          const group = activeClickedRow.dataset.group;
          const note = activeClickedRow.dataset.note;

          if (addCustomerForm) {
            document.getElementById('customerCode').value = code;
            document.getElementById('customerCode').disabled = true;
            document.getElementById('customerName').value = name;
            document.getElementById('customerPhone').value = phone;
            document.getElementById('customerBirthdate').value = birthday;
            document.getElementById('customerAddress').value = address;

            const maleRadio = addCustomerForm.querySelector('#male');
            const femaleRadio = addCustomerForm.querySelector('#female');
            if (maleRadio && femaleRadio) {
              if (gender === 'Nam') maleRadio.checked = true;
              else if (gender === 'Nữ') femaleRadio.checked = true;
              else {
                maleRadio.checked = false;
                femaleRadio.checked = false;
              }
            }

            const individualRadio = addCustomerForm.querySelector('#individual');
            const companyRadio = addCustomerForm.querySelector('#company');
            if (individualRadio && companyRadio) {
              if (type === 'Cá nhân') individualRadio.checked = true;
              else if (type === 'Công ty') companyRadio.checked = true;
            }

            document.getElementById('taxCode').value = taxCode;
            document.getElementById('idCard').value = idCard;
            document.getElementById('email').value = email;
            document.getElementById('facebook').value = facebook;
            document.getElementById('group').value = group;
            document.getElementById('note').value = note;
          }

          if (modalTitle) modalTitle.textContent = 'Cập nhật thông tin khách hàng';
          if (saveCustomerBtn) saveCustomerBtn.innerHTML = '<i class="bi bi-check-circle me-1"></i> Cập nhật (F9)';
          editMode = true;
          customerCodeToEdit = code;
          if (addCustomerModal) addCustomerModal.show();
          return;
        }

        if (event.target.classList.contains('delete-customer-detail-btn') || event.target.closest('.delete-customer-detail-btn')) {
          if (!activeClickedRow) return;
          const customerCode = activeClickedRow.dataset.code;
          const customerName = activeClickedRow.dataset.name;
          if (confirm(`Bạn có chắc chắn muốn xóa khách hàng "${customerName}" (Mã: ${customerCode}) không?`)) {
            activeClickedRow.remove();
            if (activeDetailRow) {
              activeDetailRow.remove();
              activeDetailRow = null;
            }
            activeClickedRow = null;
            console.log(`Đã xóa khách hàng ${customerCode}`);
          }
          return;
        }

        if (event.target.classList.contains('add-new-address-btn') || event.target.closest('.add-new-address-btn')) {
          if (!activeClickedRow) return;
          const customerCode = activeClickedRow.dataset.code;
          if (addAddressCustomerCodeInput) addAddressCustomerCodeInput.value = customerCode;
          if (addAddressForm) addAddressForm.reset();
          if (addAddressModal) addAddressModal.show();
          return;
        }

        let clickedRow = event.target.closest('tr');
        if (!clickedRow || !clickedRow.parentElement || clickedRow.parentElement.tagName !== 'TBODY' || !clickedRow.dataset.code) {
          if (event.target.closest('.customer-detail-row')) return;
          if (activeDetailRow) {
            activeDetailRow.remove();
            activeDetailRow = null;
            if (activeClickedRow) activeClickedRow.classList.remove('table-active');
            activeClickedRow = null;
          }
          return;
        }

        const isClickingActiveRow = activeClickedRow === clickedRow;

        if (activeDetailRow) {
          activeDetailRow.remove();
          activeDetailRow = null;
          if (activeClickedRow) activeClickedRow.classList.remove('table-active');
          activeClickedRow = null;
        }

        if (!isClickingActiveRow) {
          const detailRow = document.createElement('tr');
          detailRow.classList.add('customer-detail-row');
          const detailCell = detailRow.insertCell();
          const currentHeaderCells = customerTableHead && customerTableHead.querySelector('tr') ? customerTableHead.querySelector('tr').cells.length : 7;
          detailCell.colSpan = currentHeaderCells;
          detailCell.style.padding = '0';

          const code = clickedRow.dataset.code || 'Chưa có';
          const name = clickedRow.dataset.name || 'Chưa có';
          const phone = clickedRow.dataset.phone || 'Chưa có';
          const emailAddress = clickedRow.dataset.email || 'Chưa có';
          const addressVal = clickedRow.dataset.address || 'Chưa có';
          const creator = clickedRow.dataset.creator || 'Chưa có';
          const created = clickedRow.dataset.created || 'Chưa có';
          const groupVal = clickedRow.dataset.group || 'Chưa có';
          const birthday = clickedRow.dataset.birthday || 'Chưa có';
          const genderVal = clickedRow.dataset.gender || 'Chưa có';
          const noteVal = clickedRow.dataset.note || 'Chưa có';
          const facebookLink = clickedRow.dataset.facebook || 'Chưa có';

          detailCell.innerHTML =
                  '<div class="customer-detail-container p-3">' +
                  '<ul class="nav nav-tabs mb-3" id="customer-detail-tabs-' + code + '" role="tablist">' +
                  '<li class="nav-item" role="presentation">' +
                  '<button class="nav-link active" id="info-tab-' + code + '" data-bs-toggle="tab" data-bs-target="#info-content-' + code + '" type="button" role="tab" aria-controls="info-content-' + code + '" aria-selected="true">Thông tin</button>' +
                  '</li>' +
                  '<li class="nav-item" role="presentation">' +
                  '<button class="nav-link" id="address-tab-' + code + '" data-bs-toggle="tab" data-bs-target="#address-content-' + code + '" type="button" role="tab" aria-controls="address-content-' + code + '" aria-selected="false">Địa chỉ nhận hàng</button>' +
                  '</li>' +
                  '</ul>' +
                  '<div class="tab-content" id="customer-detail-tab-content-' + code + '">' +
                  '<div class="tab-pane fade show active" id="info-content-' + code + '" role="tabpanel" aria-labelledby="info-tab-' + code + '">' +
                  '<div class="row mb-3">' +
                  '<div class="col-auto">' +
                  '<div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white" style="width: 80px; height: 80px; font-size: 2rem;">' +
                  '<i class="bi bi-person"></i>' +
                  '</div>' +
                  '</div>' +
                  '<div class="col">' +
                  '<h5>' + name + ' <small class="text-muted fw-normal">' + code + '</small></h5>' +
                  '<p class="small mb-1">' +
                  'Người tạo: <span class="text-primary">' + creator + '</span> | Ngày tạo: ' + created + ' | Nhóm khách: <span class="badge bg-secondary">' + (groupVal || 'Chưa có') + '</span>' +
                  '</p>' +
                  '</div>' +
                  '<div class="col-auto text-end">' +
                  '<span class="text-muted small">Chi nhánh trung tâm</span>' +
                  '</div>' +
                  '</div>' +
                  '<div class="row mb-3">' +
                  '<div class="col-md-4"><p class="small mb-1 text-muted">Điện thoại</p><p>' + phone + '</p></div>' +
                  '<div class="col-md-4"><p class="small mb-1 text-muted">Sinh nhật</p><p>' + birthday + '</p></div>' +
                  '<div class="col-md-4"><p class="small mb-1 text-muted">Giới tính</p><p>' + genderVal + '</p></div>' +
                  '</div>' +
                  '<div class="row mb-3">' +
                  '<div class="col-md-4"><p class="small mb-1 text-muted">Email</p><p>' + emailAddress + '</p></div>' +
                  '<div class="col-md-4"><p class="small mb-1 text-muted">Facebook</p><p>' + facebookLink + '</p></div>' +
                  '</div>' +
                  '<div class="row mb-4">' +
                  '<div class="col-md-12"><p class="small mb-1 text-muted">Địa chỉ</p><p>' + addressVal + '</p></div>' +
                  '</div>' +
                  '<a href="#" class="text-primary mb-3 d-block">Thêm thông tin xuất hóa đơn</a>' +
                  '<p class="small"><i class="bi bi-pencil me-1"></i> Ghi chú: ' + noteVal + '</p>' +
                  '<hr>' +
                  '<div class="d-flex justify-content-end align-items-center gap-2">' +
                  '<button type="button" class="btn btn-danger delete-customer-detail-btn" title="Xóa" style="width: 38px; height: 38px; display: flex; align-items: center; justify-content: center; padding: 0;">' +
                  '<i class="bi bi-trash"></i>' +
                  '</button>' +
                  '<button type="button" class="btn btn-primary edit-customer-detail-btn" title="Chỉnh sửa" style="width: 38px; height: 38px; display: flex; align-items: center; justify-content: center; padding: 0;">' +
                  '<i class="bi bi-pencil-square"></i>' +
                  '</button>' +
                  '</div>' +
                  '</div>' +
                  '<div class="tab-pane fade" id="address-content-' + code + '" role="tabpanel" aria-labelledby="address-tab-' + code + '">' +
                  '<table class="table table-sm mb-3">' +
                  '<thead class="table-light">' +
                  '<tr><th>Tên địa chỉ</th><th>Tên người nhận</th><th>Số điện thoại</th><th>Địa chỉ nhận</th><th>Ngày tạo</th></tr>' +
                  '</thead>' +
                  '<tbody></tbody>' +
                  '</table>' +
                  '<div class="text-center text-muted p-5 border rounded no-address-message">' +
                  '<div class="mb-3"><i class="bi bi-inbox fs-1"></i></div>' +
                  'Không tìm thấy kết quả nào phù hợp' +
                  '</div>' +
                  '<div class="text-end mt-3">' +
                  '<button class="btn btn-primary btn-sm add-new-address-btn"><i class="bi bi-plus"></i> Địa chỉ mới</button>' +
                  '</div>' +
                  '</div>' +
                  '</div>' +
                  '</div>';
          clickedRow.after(detailRow);
          activeDetailRow = detailRow;
          activeClickedRow = clickedRow;
          clickedRow.classList.add('table-active');
        }
      });
    }

    // Initialize column toggling
    if (columnToggler) {
      columnToggler.addEventListener('click', (e) => {
        e.preventDefault();
        renderColumnSelectionCheckboxes();
        const dropdown = new bootstrap.Dropdown(columnToggler);
        dropdown.show();
      });
    } else {
      console.error("Column toggler button not found!");
    }

    if (saveCustomerBtn && tableBody && addCustomerForm) {
      saveCustomerBtn.addEventListener('click', () => {
        const customerCode = document.getElementById('customerCode').value.trim();
        const customerName = document.getElementById('customerName').value.trim();
        const customerPhone = document.getElementById('customerPhone').value.trim();
        const customerBirthdate = document.getElementById('customerBirthdate').value.trim();
        const customerAddress = document.getElementById('customerAddress').value.trim();
        const customerRegion = document.getElementById('customerRegion').value.trim();
        const customerWard = document.getElementById('customerWard').value.trim();
        const customerGender = addCustomerForm.querySelector('input[name="gender"]:checked') ? addCustomerForm.querySelector('input[name="gender"]:checked').value : '';
        const customerType = addCustomerForm.querySelector('input[name="customerType"]:checked') ? addCustomerForm.querySelector('input[name="customerType"]:checked').value : '';
        const taxCode = document.getElementById('taxCode').value.trim();
        const idCard = document.getElementById('idCard').value.trim();
        const email = document.getElementById('email').value.trim();
        const facebook = document.getElementById('facebook').value.trim();
        const group = document.getElementById('group').value.trim();
        const note = document.getElementById('note').value.trim();

        if (!customerName) {
          alert('Vui lòng nhập tên khách hàng.');
          document.getElementById('customerName').focus();
          return;
        }
        if (!editMode && !customerCode) {
          alert('Vui lòng nhập mã khách hàng.');
          document.getElementById('customerCode').focus();
          return;
        }

        if (editMode && customerCodeToEdit) {
          const rowToUpdate = tableBody.querySelector(`tr[data-code="${customerCodeToEdit}"]`);
          if (rowToUpdate) {
            rowToUpdate.setAttribute('data-name', customerName);
            rowToUpdate.setAttribute('data-phone', customerPhone);
            rowToUpdate.setAttribute('data-email', email);
            rowToUpdate.setAttribute('data-address', customerAddress);
            rowToUpdate.setAttribute('data-group', group);
            rowToUpdate.setAttribute('data-birthday', customerBirthdate);
            rowToUpdate.setAttribute('data-gender', customerGender);
            rowToUpdate.setAttribute('data-note', note);
            rowToUpdate.setAttribute('data-facebook', facebook);
            rowToUpdate.setAttribute('data-type', customerType);
            rowToUpdate.setAttribute('data-taxcode', taxCode);
            rowToUpdate.setAttribute('data-idcard', idCard);

            const cells = rowToUpdate.getElementsByTagName('td');
            if (cells.length > 3) {
              cells[2].textContent = customerName;
              cells[3].textContent = customerPhone;
            }
            if (activeClickedRow === rowToUpdate && activeDetailRow) {
              activeDetailRow.remove();
              activeDetailRow = null;
              activeClickedRow.classList.remove('table-active');
              activeClickedRow = null;
            }
          }
        } else {
          const newRow = document.createElement('tr');
          newRow.setAttribute('data-code', customerCode);
          newRow.setAttribute('data-name', customerName);
          newRow.setAttribute('data-phone', customerPhone);
          newRow.setAttribute('data-email', email);
          newRow.setAttribute('data-address', customerAddress);
          newRow.setAttribute('data-creator', 'CurrentUser');
          newRow.setAttribute('data-created', new Date().toLocaleDateString('vi-VN'));
          newRow.setAttribute('data-group', group);
          newRow.setAttribute('data-birthday', customerBirthdate);
          newRow.setAttribute('data-gender', customerGender);
          newRow.setAttribute('data-note', note);
          newRow.setAttribute('data-facebook', facebook);
          newRow.setAttribute('data-type', customerType);
          newRow.setAttribute('data-taxcode', taxCode);
          newRow.setAttribute('data-idcard', idCard);

          newRow.innerHTML =
                  '<td><input type="checkbox"></td>' +
                  '<td>' + customerCode + '</td>' +
                  '<td>' + customerName + '</td>' +
                  '<td>' + customerPhone + '</td>' +
                  '<td>0</td>' +
                  '<td>0</td>' +
                  '<td>0</td>';
          tableBody.appendChild(newRow);
        }

        addCustomerModal.hide();
      });
    }

    if (saveAddressBtn && addAddressModalElement) {
      saveAddressBtn.addEventListener('click', () => {
        const customerCode = addAddressCustomerCodeInput ? addAddressCustomerCodeInput.value : null;
        if (!customerCode) return;

        const addressName = document.getElementById('addressName').value.trim();
        const recipientName = document.getElementById('recipientName').value.trim();
        const recipientPhone = document.getElementById('recipientPhone').value.trim();
        const shippingAddress = document.getElementById('shippingAddress').value.trim();
        const shippingRegion = document.getElementById('shippingRegion').value.trim();
        const shippingWard = document.getElementById('shippingWard').value.trim();

        const addressTableBody = document.querySelector(`#address-content-${customerCode} tbody`);
        const noAddressMessage = document.querySelector(`#address-content-${customerCode} .no-address-message`);

        if (addressTableBody) {
          if (noAddressMessage) {
            noAddressMessage.style.display = 'none';
          }
          const newAddressRow = document.createElement('tr');
          const currentDate = new Date().toLocaleDateString('vi-VN');
          newAddressRow.innerHTML =
                  '<td>' + (addressName || '-') + '</td>' +
                  '<td>' + (recipientName || '-') + '</td>' +
                  '<td>' + (recipientPhone || '-') + '</td>' +
                  '<td>' + shippingAddress + ', ' + shippingWard + ', ' + shippingRegion + '</td>' +
                  '<td>' + currentDate + '</td>';
          addressTableBody.appendChild(newAddressRow);
        }

        const currentAddressModalInstance = bootstrap.Modal.getInstance(addAddressModalElement);
        if (currentAddressModalInstance) currentAddressModalInstance.hide();
      });
    }

    // Initial filter and column setup
    renderColumnSelectionCheckboxes();
    renderTable();
    filterCustomerRows();
  });
</script>
