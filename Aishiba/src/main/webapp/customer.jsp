<%@ page contentType="text/html; charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                  </div>
                  <div>
                    <div class="d-flex align-items-stretch">
                      <button class="btn btn-success action-btn me-1" data-bs-toggle="modal"
                        data-bs-target="#addCustomerModal">
                        <i class="bi bi-plus"></i> Khách hàng
                      </button>
                      <div class="btn-group me-1">
                        <button class="btn btn-primary action-btn dropdown-toggle" type="button"
                          data-bs-toggle="dropdown" aria-expanded="false">
                          <i class="bi bi-file-earmark"></i> File
                        </button>
                        <ul class="dropdown-menu">
                          <li><a class="dropdown-item" href="#" id="exportCustomerCsvBtn">Xuất CSV</a></li>
                          <li><a class="dropdown-item" href="#" id="importCustomerCsvBtn">Nhập CSV</a></li>
                        </ul>
                      </div>
                      <div class="btn-group">
                        <button class="btn btn-secondary action-btn dropdown-toggle" type="button" id="columnToggler"
                          data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false">
                          <i class="bi bi-list"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="columnToggler"
                          id="columnSelectionDropdown" style="min-width: 250px; max-height: 300px; overflow-y: auto;">
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
                      <tr>
                        <th>Mã khách hàng</th>
                        <th>Tên khách hàng</th>
                        <th>Điện thoại</th>
                        <th>Giới tính</th>
                        <th>Địa chỉ</th>
                        <th>Email</th>
                        <th>Ngày sinh</th>
                      </tr>
                    </thead>
                    <tbody id="customer-table-body">
                      <c:if test="${not empty userList}">
                        <c:forEach var="user" items="${userList}" varStatus="loop">
                          <tr data-id="${user.id}" data-name="${not empty user.name ? user.name : ''}"
                            data-phone="${not empty user.phone ? user.phone : ''}"
                            data-gender="${not empty user.gender ? user.gender.displayName : ''}"
                            data-address="${not empty user.address ? user.address : ''}"
                            data-email="${not empty user.email ? user.email : ''}"
                            data-birthday="${not empty user.dob ? user.dob : ''}">
                            <td>${user.getFormattedUserCode()}</td>
                            <td>${not empty user.name ? user.name : 'Chưa có'}</td>
                            <td>${not empty user.phone ? user.phone : 'Chưa có'}</td>
                            <td>${not empty user.gender ? user.gender.displayName : 'Chưa có'}</td>
                            <td>${not empty user.address ? user.address : 'Chưa có'}</td>
                            <td>${not empty user.email ? user.email : 'Chưa có'}</td>
                            <td>
                              <c:if test="${not empty user.dob}">
                                <fmt:formatDate value="${user.dobAsDate}" pattern="yyyy-MM-dd" />
                              </c:if>
                              <c:if test="${empty user.dob}">
                                Chưa có
                              </c:if>
                            </td>
                          </tr>
                        </c:forEach>
                      </c:if>
                      <c:if test="${empty userList or userList.size() == 0}">
                        <tr>
                          <td colspan="7" class="text-center">Không có khách hàng nào. (Debug: userList size =
                            ${userList != null ? userList.size() : 0})</td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>

                  <!-- Pagination -->
                  <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                      <ul class="pagination-container">
                        <c:set var="startPage" value="${currentPage - 1}" />
                        <c:set var="endPage" value="${currentPage + 1}" />

                        <c:if test="${startPage < 1}">
                          <c:set var="endPage" value="${endPage + (1 - startPage)}" />
                          <c:set var="startPage" value="1" />
                        </c:if>
                        <c:if test="${endPage > totalPages}">
                          <c:set var="startPage" value="${startPage - (endPage - totalPages)}" />
                          <c:set var="endPage" value="${totalPages}" />
                          <c:if test="${startPage < 1}">
                            <c:set var="startPage" value="1" />
                          </c:if>
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
                </div>
              </div>
            </div>
          </div>
        </section>
      </main><!-- End #main -->

      <!-- Modal Thêm Khách Hàng -->
      <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="addCustomerModalLabel">Thêm khách hàng</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <form id="customerForm">
                <input type="hidden" name="action" id="action" value="add">
                <input type="hidden" name="customerId" id="customerId">
                <div class="row">
                  <div class="col-md-3">
                    <div class="mb-3 text-center">
                      <div id="imagePreviewArea"
                        class="border rounded d-flex align-items-center justify-content-center mb-2"
                        style="height: 150px; width: 150px; border-style: dashed!important; margin:auto; overflow: hidden;">
                        <span class="text-muted">Ảnh</span>
                      </div>
                      <label for="customerImage" class="btn btn-success btn-sm">Chọn ảnh</label>
                      <input type="file" class="form-control d-none" id="customerImage" name="customerImage">
                    </div>
                  </div>
                  <div class="col-md-9">
                    <div class="mb-3">
                      <label for="customerName" class="form-label small">Tên khách hàng</label>
                      <input type="text" class="form-control form-control-sm" id="customerName" name="customerName"
                        required>
                    </div>
                    <div class="mb-3">
                      <label for="customerPhone" class="form-label small">Điện thoại</label>
                      <input type="text" class="form-control form-control-sm" id="customerPhone" name="customerPhone"
                        required>
                    </div>
                    <div class="mb-3">
                      <label for="customerBirthdate" class="form-label small d-block">Ngày sinh</label>
                      <div class="input-group input-group-sm">
                        <input type="date" class="form-control form-control-sm" id="customerBirthdate"
                          name="customerBirthdate" value="" placeholder="yyyy-MM-dd">
                        <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                        <div class="ms-3 d-inline-flex align-items-center">
                          <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="gender" id="nu" value="Nữ">
                            <label class="form-check-label small" for="nu">Nữ</label>
                          </div>
                          <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="gender" id="nam" value="Nam">
                            <label class="form-check-label small" for="nam">Nam</label>
                          </div>
                          <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="gender" id="khac" value="Khác">
                            <label class="form-check-label small" for="khac">Khác</label>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="mb-3">
                      <label for="customerAddress" class="form-label small">Địa chỉ</label>
                      <input type="text" class="form-control form-control-sm" id="customerAddress"
                        name="customerAddress">
                    </div>
                    <div class="mb-3">
                      <label for="email" class="form-label small">Email</label>
                      <input type="email" class="form-control form-control-sm" id="email" name="email">
                    </div>
                  </div>
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-success btn-sm" id="saveCustomerBtn"><i class="bi bi-save me-1"></i>
                Lưu (F9)</button>
              <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal"><i
                  class="bi bi-x-circle me-1"></i> Bỏ qua</button>
            </div>
          </div>
        </div>
      </div>


      <style>
        .table-hover tbody tr:hover {
          background-color: #f8f9fa;
        }

        .table th,
        .table td {
          vertical-align: middle;
          padding: 8px;
          font-size: 14px;
          /* Kích thước chữ nhỏ gọn */
        }

        /* Căn chỉnh cụ thể cho từng cột */
        .table th:nth-child(1),
        .table td:nth-child(1),
        /* Mã khách hàng */
        .table th:nth-child(2),
        .table td:nth-child(2),
        /* Tên khách hàng */
        .table th:nth-child(5),
        .table td:nth-child(5),
        /* Địa chỉ */
        .table th:nth-child(6),
        .table td:nth-child(6)

        /* Email */
          {
          text-align: left;
        }

        .table th:nth-child(3),
        .table td:nth-child(3),
        /* Điện thoại */
        .table th:nth-child(4),
        .table td:nth-child(4),
        /* Giới tính */
        .table th:nth-child(7),
        .table td:nth-child(7)

        /* Ngày sinh */
          {
          text-align: center;
        }

        .table thead tr:first-child {
          background-color: #fff3cd;
          font-weight: bold;
        }

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
          content: '\f26e';
          font-family: bootstrap-icons !important;
          position: absolute;
          left: 4px;
          top: 1px;
          color: white;
          font-size: 0.8em;
        }

        #company:checked+.form-check-label::after {
          content: '\f283';
          font-family: bootstrap-icons !important;
          position: absolute;
          left: 4px;
          top: 1px;
          color: white;
          font-size: 0.8em;
        }

        .customer-detail-container {
          background-color: #f8f9fc;
          border-top: 1px solid #dee2e6;
        }

        .customer-detail-row td {
          border-top: none !important;
        }

        #customer-table-body tr:not(.customer-detail-row):hover {
          cursor: pointer;
          background-color: #e9ecef;
        }

        #customer-table-body tr.table-active {
          background-color: #cfe2ff !important;
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
          border: 1px solid #dee2e6;
          border-radius: 0;
          background: none;
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

        ul li {
          text-decoration: none;
          list-style: none;
        }
      </style>


      <script>
        document.addEventListener('DOMContentLoaded', () => {
          const tableBody = document.getElementById('customer-table-body');
          let activeDetailRow = null;
          let activeClickedRow = null;

          const addCustomerModalElement = document.getElementById('addCustomerModal');
          const addCustomerModal = new bootstrap.Modal(addCustomerModalElement);
          const saveCustomerBtn = document.getElementById('saveCustomerBtn');
          const customerForm = document.getElementById('customerForm');
          const modalTitle = document.getElementById('addCustomerModalLabel');
          let editMode = false;

          const columnConfiguration = {
            colId: { label: 'Mã khách hàng', dataAttr: 'id', defaultChecked: true },
            colName: { label: 'Tên khách hàng', dataAttr: 'name', defaultChecked: true },
            colPhone: { label: 'Điện thoại', dataAttr: 'phone', defaultChecked: true },
            colGender: { label: 'Giới tính', dataAttr: 'gender', defaultChecked: true },
            colAddress: { label: 'Địa chỉ', dataAttr: 'address', defaultChecked: true },
            colEmail: { label: 'Email', dataAttr: 'email', defaultChecked: true },
            colBirthday: { label: 'Ngày sinh', dataAttr: 'birthday', defaultChecked: true }
          };

          function getSavedColumns() {
            const saved = localStorage.getItem('customerTableColumns');
            return saved ? JSON.parse(saved) : Object.keys(columnConfiguration).filter(key => columnConfiguration[key].defaultChecked);
          }

          function saveColumns(columns) {
            localStorage.setItem('customerTableColumns', JSON.stringify(columns));
          }

          const columnSelectionDropdown = document.getElementById('columnSelectionDropdown');
          const customerTable = document.getElementById('customerTable');
          const customerTableHead = customerTable ? customerTable.querySelector('thead') : null;
          const columnToggler = document.getElementById('columnToggler');

          function renderColumnSelectionCheckboxes() {
            if (!columnSelectionDropdown) return;
            columnSelectionDropdown.innerHTML = '';
            const savedColumns = getSavedColumns();

            Object.keys(columnConfiguration).forEach(key => {
              const colConfig = columnConfiguration[key];
              const li = document.createElement('li');
              li.classList.add('dropdown-item', 'd-flex', 'align-items-center');
              li.innerHTML = `<div class="form-check flex-grow-1"><input class="form-check-input column-toggle-checkbox me-2" type="checkbox" value="${key}" id="checkbox-${key}"${savedColumns.includes(key) ? ' checked' : ''}><label class="form-check-label" for="checkbox-${key}">${colConfig.label}</label></div>`;
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

          function renderTable() {
            if (!customerTableHead || !tableBody) return;

            const visibleColumnKeys = getSavedColumns();
            const theadRow = customerTableHead.querySelector('tr');
            while (theadRow.cells.length > 7) theadRow.deleteCell(7);
            while (theadRow.cells.length < 7) {
              const th = document.createElement('th');
              theadRow.appendChild(th);
            }

            const dataRows = tableBody.querySelectorAll('tr:not(.customer-detail-row)');
            dataRows.forEach(row => {
              while (row.cells.length > 7) row.deleteCell(7);
              while (row.cells.length < 7) {
                const td = document.createElement('td');
                row.appendChild(td);
              }
              const cells = row.cells;
              cells[0].textContent = row.dataset.id ? "KH" + row.dataset.id.substring(0, 4).toUpperCase() : '';
              cells[1].textContent = row.dataset.name ? row.dataset.name : 'Chưa có';
              cells[2].textContent = row.dataset.phone ? row.dataset.phone : 'Chưa có';
              cells[3].textContent = row.dataset.gender ? row.dataset.gender : 'Chưa có';
              cells[4].textContent = row.dataset.address ? row.dataset.address : 'Chưa có';
              cells[5].textContent = row.dataset.email ? row.dataset.email : 'Chưa có';
              cells[6].textContent = row.dataset.birthday ? new Date(row.dataset.birthday).toLocaleDateString('en-CA') : 'Chưa có';
            });

            if (activeDetailRow) {
              const detailCell = activeDetailRow.querySelector('td');
              if (detailCell) detailCell.colSpan = 7;
            }

            const emptyRow = tableBody.querySelector('tr td[colspan]');
            if (emptyRow) emptyRow.colSpan = 7;
          }

          const searchInput = document.getElementById('customerSearchInput');
          const genderFilterSelect = document.getElementById('customerGenderFilterInline');

          function filterCustomerRows() {
            if (!tableBody) return;

            const searchTerm = (searchInput ? searchInput.value.toLowerCase().trim() : '');
            const selectedGender = (genderFilterSelect ? genderFilterSelect.value.toLowerCase() : '');

            const rows = tableBody.getElementsByTagName('tr');
            for (const row of rows) {
              if (row.classList.contains('customer-detail-row')) continue;

              const name = (row.getAttribute('data-name') || '').toLowerCase();
              const phone = (row.getAttribute('data-phone') || '').toLowerCase();
              const gender = (row.getAttribute('data-gender') || '').toLowerCase();

              let matchesSearch = !searchTerm || name.includes(searchTerm) || phone.includes(searchTerm);
              let matchesGender = !selectedGender || gender === selectedGender;

              if (matchesSearch && matchesGender) row.style.display = '';
              else row.style.display = 'none';

              const nextRow = row.nextElementSibling;
              if (nextRow && nextRow.classList.contains('customer-detail-row')) nextRow.style.display = row.style.display;
            }
          }

          if (searchInput) searchInput.addEventListener('input', filterCustomerRows);
          if (genderFilterSelect) genderFilterSelect.addEventListener('change', filterCustomerRows);

          // Reset modal khi mở từ nút "+ Khách hàng"
          document.querySelector('.btn-success.action-btn[data-bs-target="#addCustomerModal"]').addEventListener('click', () => {
            editMode = false;
            modalTitle.textContent = 'Thêm khách hàng';
            saveCustomerBtn.innerHTML = '<i class="bi bi-save me-1"></i> Lưu (F9)';
            if (customerForm) customerForm.reset();
            document.getElementById('action').value = 'add';
            document.getElementById('customerId').value = '';
          });

          if (tableBody) {
            tableBody.addEventListener('click', (event) => {
              let clickedRow = event.target.closest('tr');
              if (!clickedRow || !clickedRow.parentElement || clickedRow.parentElement.tagName !== 'TBODY') {
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
              if (isClickingActiveRow) {
                if (activeDetailRow) {
                  activeDetailRow.remove();
                  activeDetailRow = null;
                }
                if (activeClickedRow) activeClickedRow.classList.remove('table-active');
                activeClickedRow = null;
                return;
              }

              if (activeDetailRow) {
                activeDetailRow.remove();
                activeDetailRow = null;
                if (activeClickedRow) activeClickedRow.classList.remove('table-active');
                activeClickedRow = null;
              }

              const detailRow = document.createElement('tr');
              detailRow.classList.add('customer-detail-row');
              const detailCell = detailRow.insertCell();
              detailCell.colSpan = 7;
              detailCell.style.padding = '0';

              const id = clickedRow.dataset.id || '';
              console.log('ID captured from clicked row:', id);
              const name = clickedRow.dataset.name || '';
              const phone = clickedRow.dataset.phone || '';
              const email = clickedRow.dataset.email || '';
              const address = clickedRow.dataset.address || '';
              const birthday = clickedRow.dataset.birthday || '';
              const gender = clickedRow.dataset.gender || '';

              detailCell.innerHTML = `
  <div class="customer-detail-container p-3">
    <div class="row mb-3">
      <div class="col-auto">
        <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white" style="width: 80px; height: 80px; font-size: 2rem;">
          <i class="bi bi-person"></i>
        </div>
      </div>

    </div>
    <div class="row">
      <div class="col-md-4 mb-2">
        <p class="small mb-1 text-muted">Mã</p>
        <p>${id ? "KH" + id.substring(0, 4).toUpperCase() : 'Chưa có'}</p>
      </div>
      <div class="col-md-4 mb-2">
        <p class="small mb-1 text-muted">Tên</p>
        <p>${name || 'Chưa có'}</p>
      </div>
      <div class="col-md-4 mb-2">
        <p class="small mb-1 text-muted">Điện thoại</p>
        <p>${phone || 'Chưa có'}</p>
      </div>
      <div class="col-md-4 mb-2">
        <p class="small mb-1 text-muted">Giới tính</p>
        <p>${gender || 'Chưa có'}</p>
      </div>
      <div class="col-md-4 mb-2">
        <p class="small mb-1 text-muted">Email</p>
        <p>${email || 'Chưa có'}</p>
      </div>
      <div class="col-md-4 mb-2">
        <p class="small mb-1 text-muted">Địa chỉ</p>
        <p>${address || 'Chưa có'}</p>
      </div>
    </div>
    <hr>
    <div class="d-flex justify-content-end gap-2">
      <button type="button" class="btn btn-danger delete-customer-detail-btn" title="Xóa" style="width: 38px; height: 38px; display: flex; align-items: center; justify-content: center; padding: 0;" data-id="${id}">
        <i class="bi bi-trash"></i>
      </button>
      <button type="button" class="btn btn-primary edit-customer-detail-btn" title="Chỉnh sửa" style="width: 38px; height: 38px; display: flex; align-items: center; justify-content: center; padding: 0;" data-id="${id}">
        <i class="bi bi-pen"></i>
      </button>
    </div>
  </div>`;

              clickedRow.after(detailRow);
              activeDetailRow = detailRow;
              activeClickedRow = clickedRow;
              clickedRow.classList.add('table-active');

              // Thêm sự kiện cho nút Xóa
              const deleteBtn = detailRow.querySelector('.delete-customer-detail-btn');
              if (deleteBtn) {
                deleteBtn.addEventListener('click', () => {
                  if (confirm('Bạn có chắc chắn muốn xóa khách hàng này?')) {
                    console.log('ID being passed to deleteCustomer:', id);
                    deleteCustomer(id);
                  }
                });
              }

              // Thêm sự kiện cho nút Chỉnh sửa
              const editBtn = detailRow.querySelector('.edit-customer-detail-btn');
              if (editBtn) {
                editBtn.addEventListener('click', () => {
                  editMode = true;
                  modalTitle.textContent = 'Chỉnh sửa khách hàng';
                  saveCustomerBtn.innerHTML = '<i class="bi bi-save me-1"></i> Cập nhật (F9)';
                  document.getElementById('customerId').value = id || '';
                  document.getElementById('customerName').value = name || '';
                  document.getElementById('customerPhone').value = phone || '';
                  document.getElementById('customerAddress').value = address || '';
                  document.getElementById('email').value = email || '';
                  // Xử lý ngày sinh an toàn
                  const birthdateInput = document.getElementById('customerBirthdate');
                  if (birthday && birthday !== 'Chưa có') {
                    try {
                      birthdateInput.value = new Date(birthday).toISOString().split('T')[0];
                    } catch (e) {
                      console.error('Lỗi định dạng ngày sinh:', e);
                      birthdateInput.value = '';
                    }
                  } else {
                    birthdateInput.value = '';
                  }
                  // Xử lý giới tính
                  const genderRadios = customerForm.querySelectorAll('input[name="gender"]');
                  genderRadios.forEach(radio => {
                    radio.checked = (radio.value === gender);
                  });
                  document.getElementById('action').value = 'update';
                  addCustomerModal.show();
                });
              }
            });
          }

          if (columnToggler) {
            columnToggler.addEventListener('click', (e) => {
              e.preventDefault();
              renderColumnSelectionCheckboxes();
              new bootstrap.Dropdown(columnToggler).show();
            });
          }

          if (saveCustomerBtn && tableBody && customerForm) {
            saveCustomerBtn.addEventListener('click', async () => {
              const customerName = document.getElementById('customerName').value.trim();
              const customerPhone = document.getElementById('customerPhone').value.trim();
              const customerBirthdate = document.getElementById('customerBirthdate').value.trim();
              const customerAddress = document.getElementById('customerAddress').value.trim();
              const customerGender = customerForm.querySelector('input[name="gender"]:checked') ? customerForm.querySelector('input[name="gender"]:checked').value : '';
              const email = document.getElementById('email').value.trim();
              const customerId = document.getElementById('customerId').value;
              const action = document.getElementById('action').value;

              if (!customerName || !customerPhone) {
                alert('Vui lòng nhập tên và số điện thoại.');
                return;
              }

              try {
                const response = await fetch('/Aishiba/customer', {
                  method: 'POST',
                  body: new URLSearchParams({
                    action: action,
                    customerId: customerId,
                    customerName: customerName,
                    customerPhone: customerPhone,
                    customerBirthdate: customerBirthdate,
                    customerAddress: customerAddress,
                    gender: customerGender,
                    email: email
                  }).toString(),
                  headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                  }
                });
                const result = await response.json();
                if (response.ok) {
                  alert(result.message);
                  addCustomerModal.hide();
                  window.location.reload();
                } else {
                  alert('Lỗi: ' + result.error);
                }
              } catch (error) {
                console.error('Lỗi:', error);
                alert('Đã xảy ra lỗi khi lưu khách hàng.');
              }
            });
          }

          // Hàm xóa khách hàng
          function deleteCustomer(id) {
            if (confirm('Bạn có chắc chắn muốn xóa khách hàng này?')) {
              const params = new URLSearchParams();
              params.append('action', 'delete');
              params.append('customerId', id);
              const requestBody = params.toString();
              console.log('Sending delete request with body:', requestBody);
              fetch('/Aishiba/customer', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: requestBody
              })
                .then(response => response.json())
                .then(result => {
                  if (result.message) {
                    alert(result.message);
                    // Sau khi xóa thành công, reload trang hoặc xóa hàng khỏi DOM
                    window.location.reload(); // Hoặc bạn có thể xóa hàng khỏi DOM
                  } else if (result.error) {
                    alert('Lỗi: ' + result.error);
                  }
                })
                .catch(error => {
                  console.error('Lỗi:', error);
                  alert('Đã xảy ra lỗi khi xóa khách hàng.');
                });
            }
          }

          window.addEventListener('load', () => {
            renderColumnSelectionCheckboxes();
            renderTable();
            filterCustomerRows();
          });
        });
      </script>