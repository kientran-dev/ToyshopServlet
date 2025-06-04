<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- Thêm dòng này --%>

<style>
    .card {
        border-radius: 16px !important;
        box-shadow: 0 2px 16px rgba(0,0,0,0.06) !important;
        border: none !important;
    }
    .table {
        border-radius: 12px !important;
        overflow: hidden;
        background: #fff;
    }
    .table thead th {
        background: #f6f8fa !important;
        font-weight: 600;
        font-size: 1.05rem;
    }
    .table tbody tr {
        transition: background 0.2s;
    }
    .table tbody tr:hover {
        background: #f0f6ff;
    }
    .badge.bg-success {
        background: #22c55e !important;
    }
    .badge.bg-danger {
        background: #ef4444 !important;
    }
    .btn-primary {
        background: #2563eb !important;
        border: none;
    }
    .btn-success {
        background: #22c55e !important;
        border: none;
    }
    .btn-outline-secondary {
        border-radius: 8px;
    }
    .input-group-text {
        background: #fff;
        border-right: 0;
    }
    .form-control, .form-select {
        border-radius: 8px !important;
    }

    .btn-sm {
        padding: 2px 6px;
        font-size: 0.9em;
        margin-right: 2px;
    }
    .btn, .dropdown .btn {
        border-radius: 8px !important;
        min-width: 100px;
        height: 34px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.95rem;
        font-weight: 500;
        gap: 4px;
        padding: 0 10px;
        box-shadow: 0 0 0 2px #e0e7ef;
        margin-right: 4px;
        transition: box-shadow 0.2s;
    }
    .btn-sm, .dropdown .btn-sm {
        min-width: 90px;
        height: 32px;
        font-size: 0.92rem;
        padding: 0 8px;
    }
    .d-flex.flex-row.align-items-center > .btn:last-child,
    .d-flex.flex-row.align-items-center > .dropdown:last-child {
        margin-right: 0;
    }
    .dropdown-toggle::after {
        margin-left: 8px;
    }
    .btn:focus, .btn:active {
        box-shadow: 0 0 0 3px #2563eb55;
    }
    .btn-group-header > * {
        margin-right: 4px;
    }
    .btn-group-header > *:last-child {
        margin-right: 0;
    }
    .btn, .dropdown .btn {
        border-radius: 8px !important;
        min-width: 90px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.92rem;
        font-weight: 500;
        gap: 4px;
        padding: 0 8px;
        box-shadow: 0 0 0 2px #e0e7ef;
        transition: box-shadow 0.2s;
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
        color: #0d6efd; /* Bootstrap primary color */
        border: 1px solid #dee2e6; /* Bootstrap border color */
        border-radius: 0px;
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
        color: #6c757d; /* Bootstrap disabled color */
        pointer-events: none;
        background-color: #fff;
        border-color: #dee2e6;
    }
    ul li {
        text-decoration: none;
        list-style: none; /* Loại bỏ dấu đầu dòng nếu có */
    }
</style>

<body>
<main id="main" class="main">
    <div class="pagetitle">
        <h1>Danh sách nhà cung cấp</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
                <li class="breadcrumb-item active">Danh sách nhà cung cấp</li>
            </ol>
        </nav>
    </div>
    <section class="section">
        <div class="container-fluid px-0">
            <div class="card shadow-sm rounded-4 p-4" style="border: none;">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap flex-row-reverse">
                    <div class="d-flex flex-row align-items-center btn-group-header">
                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm mới
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-success btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-file-earmark me-1"></i> Xuất/Nhập
                            </button>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="#" onclick="exportSuppliers()">
                                        <i class="bi bi-file-earmark-excel me-2"></i>Xuất Excel
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="importSuppliers()">
                                        <i class="bi bi-file-earmark-arrow-up me-2"></i>Nhập Excel
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <button class="btn btn-danger btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-file-earmark me-1"></i> Xóa
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <a class="dropdown-item" href="#" onclick="deleteSelectedSuppliersTemp()">
                                    <i class="bi bi-trash me-2"></i>Chuyển vô thùng rác
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="#" onclick="deleteSelectedSuppliersForever()">
                                    <i class="bi bi-file-trash me-2"></i>Xóa hoàn toàn
                                </a>
                            </li>
                        </ul>
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-arrow-repeat me-1"></i> Trạng thái hợp tác
                            </button>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item text-warning" href="#" onclick="bulkChangeSupplierStatus('Ngừng hợp tác')">
                                        <i class="bi bi-x-octagon me-1"></i> Hủy hợp tác
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item text-success" href="#" onclick="bulkChangeSupplierStatus('Đang hợp tác')">
                                        <i class="bi bi-check2-circle me-1"></i> Hợp tác lại
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <h2 class="fw-bold text-primary mb-0 ms-2">Danh sách nhà cung cấp</h2>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control" id="searchSupplierInput" placeholder="Tìm kiếm theo mã, tên, SĐT..." oninput="filterSuppliers()">
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle rounded-4 overflow-hidden">
                        <thead class="table-light">
                        <tr>
                            <th style="width:40px">
                                <input type="checkbox" class="form-check-input" id="selectAllSupplier" title="Chọn tất cả" onclick="toggleSelectAllSupplier(this)">
                            </th>
                            <th>Mã NCC</th>
                            <th>Tên nhà cung cấp</th>
                            <th>Số điện thoại</th>
                            <th>Email</th>
                            <th>Địa chỉ</th>
                            <th>Ghi chú</th>
                        </tr>
                        </thead>
                        <tbody id="supplierTableBody">
                        <%-- Kiểm tra nếu supplierList không rỗng --%>
                        <c:if test="${not empty supplierList}">
                            <%-- Duyệt qua danh sách nhà cung cấp và hiển thị --%>
                            <c:forEach var="supplier" items="${supplierList}" varStatus="loop">
                                <tr>
                                    <td><input type="checkbox" class="form-check-input supplier-checkbox" title="Chọn nhà cung cấp này" onclick="event.stopPropagation();"></td>
                                    <td style="color: #0D6EFD"><c:out value="${supplier.formattedSupplierCode}" /></td> <%-- Giả sử mã NCC là id --%>
                                    <td><c:out value="${supplier.name}" /></td>
                                    <td><c:out value="${supplier.phoneNumber}" /></td>
                                    <td><c:out value="${supplier.email}" /></td>
                                    <td><c:out value="${supplier.address}" /></td>
                                    <td><c:out value="${supplier.description}" /></td>
                                </tr>
                            </c:forEach>
                        </c:if>
                        <%-- Hiển thị thông báo nếu danh sách rỗng --%>
                        <c:if test="${empty supplierList}">
                            <tr>
                                <td colspan="9" class="text-center">Không có nhà cung cấp nào.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                <%-- Phần phân trang --%>
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination-container">
                                <%-- Nút Previous --%>
                            <c:if test="${currentPage >1}">
                                <li class="page-item ">
                                    <a class="page-link" href="supplier?page=${startPage}" aria-label="Homepage">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&lsaquo;</span>
                                    </a>
                                </li>
                            </c:if>

                                <%-- Các nút số trang --%>
                                <%-- Logic hiển thị số trang (ví dụ: hiển thị 5 trang xung quanh trang hiện tại) --%>
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

                                <%-- Nút trang đầu và "..." nếu cần --%>
                            <c:if test="${startPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=1">1</a>
                                </li>
                                <c:if test="${startPage > 2}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:if>

                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
                                    <a class="page-link" href="supplier?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                                <%-- Nút trang cuối và "..." nếu cần --%>
                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${totalPages}">${totalPages}</a>
                                </li>
                            </c:if>

                                <%-- Nút Next --%>
                            <c:if test="${currentPage < endPage and currentPage >=1}">
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&rsaquo;</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${currentPage == totalPage-1}" aria-label="EndPage">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
                <%-- Hết phần phân trang --%>

            </div>

            </div>
        </div>
    </section>
    <!-- Modal Thêm/Sửa Nhà Cung Cấp -->
    <div class="modal fade" id="addSupplierModal" tabindex="-1" aria-labelledby="addSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addSupplierModalLabel">Thêm / Sửa Nhà Cung Cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="supplierForm">
                        <div class="mb-3">
                            <label for="supplierCode" class="form-label">Mã NCC</label>
                            <input type="text" class="form-control" id="supplierCode" required>
                        </div>
                        <div class="mb-3">
                            <label for="supplierName" class="form-label">Tên nhà cung cấp</label>
                            <input type="text" class="form-control" id="supplierName" required>
                        </div>
                        <div class="mb-3">
                            <label for="supplierPhone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="supplierPhone" required>
                        </div>
                        <div class="mb-3">
                            <label for="supplierEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="supplierEmail">
                        </div>
                        <div class="mb-3">
                            <label for="supplierAddress" class="form-label">Địa chỉ</label>
                            <input type="text" class="form-control" id="supplierAddress">
                        </div>
                        <div class="mb-3">
                            <label for="supplierStatus" class="form-label">Trạng thái</label>
                            <select class="form-select" id="supplierStatus">
                                <option value="Đang hợp tác">Đang hợp tác</option>
                                <option value="Ngừng hợp tác">Ngừng hợp tác</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="supplierNote" class="form-label">Ghi chú</label>
                            <textarea class="form-control" id="supplierNote"></textarea>
                        </div>
                        <button type="submit" class="btn btn-success">Lưu</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main><!-- End #main -->
<script src="${pageContext.request.contextPath}assets/js/main.js"></script>
<script>
    let currentSupplier = null;


    function filterSuppliers() {
        const search = document.getElementById('searchSupplierInput').value.toLowerCase();
        document.querySelectorAll('#supplierTableBody tr').forEach(tr => {
            const code = tr.children[0]?.innerText.toLowerCase() || '';
            const name = tr.children[1]?.innerText.toLowerCase() || '';
            const phone = tr.children[2]?.innerText.toLowerCase() || '';
            if (search && !code.includes(search) && !name.includes(search) && !phone.includes(search)) {
                tr.style.display = 'none';
            } else {
                tr.style.display = '';
            }
        });
    }

    function editSupplier(btn) {
        const tr = btn.closest('tr');
        document.getElementById('supplierCode').value = tr.children[0].innerText;
        document.getElementById('supplierName').value = tr.children[1].innerText;
        document.getElementById('supplierPhone').value = tr.children[2].innerText;
        document.getElementById('supplierEmail').value = tr.children[3].innerText;
        document.getElementById('supplierAddress').value = tr.children[4].innerText;
        document.getElementById('supplierStatus').value = tr.children[5].innerText.trim();
        document.getElementById('supplierNote').value = tr.children[6].innerText;
        var modal = new bootstrap.Modal(document.getElementById('addSupplierModal'));
        modal.show();
        // Đánh dấu dòng đang sửa
        document.getElementById('supplierForm').setAttribute('data-editing', tr.rowIndex);
    }

    function deleteSupplier(btn) {
        if (confirm('Bạn có chắc muốn xóa nhà cung cấp này?')) {
            btn.closest('tr').remove();
        }
    }

    function toggleSelectAllSupplier(checkbox) {
        document.querySelectorAll('.supplier-checkbox').forEach(cb => cb.checked = checkbox.checked);
    }

    function deleteSelectedSuppliersForever() {
        if (!confirm('Bạn có chắc muốn xóa hoàn toàn các nhà cung cấp đã chọn?')) return;

        const selectedIds=Array.from(document.querySelectorAll('.supplier-checkbox:checked')).map(cb => cb.value);

        if(selectedIds.length === 0){
            alert("Vui lòng chọn ít nhất 1 nhà cung cấp");
            return;
        }

        const formData = new URLSearchParams();
        selectedIds.forEach(id => formData.append('supplierCode', id));
        formData.append('action', 'deleteForever');

        fetch('supplier', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
            .then(response => {
                if (response.ok) {
                    selectedIds.forEach(id => {
                        const row = document.querySelector(`.supplier-checkbox[value="${id}"]`).closest('tr');
                        row.remove();
                    });
                } else {
                    alert('Lỗi khi xóa.');
                }
            })
            .catch(error => {
                console.error('Lỗi:', error);
            });
    }
    function deleteSelectedSuppliersTemp(){
        if(confirm('Bạn có muốn xóa các nhà cung cấp đã chọn')){
            document.querySelectorAll('.supplier-checkbox:checked').forEach(cb => {

            })
        }
    }
    function exportSuppliers() {
        let csv = '';
        document.querySelectorAll('#supplierTableBody tr').forEach(tr => {
            const tds = tr.querySelectorAll('td');
            const row = [
                tds[2]?.innerText, tds[3]?.innerText, tds[4]?.innerText, tds[5]?.innerText,
                tds[6]?.innerText, tds[7]?.innerText, tds[8]?.innerText, tds[9]?.innerText
            ].join(',');
            csv += row + '\n';
        });
        const blob = new Blob([csv], {type: 'text/csv'});
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'suppliers.csv';
        a.click();
        URL.revokeObjectURL(url);
    }
    function importSuppliers() {
        if (!window.supplierImportInput) {
            window.supplierImportInput = document.createElement('input');
            window.supplierImportInput.type = 'file';
            window.supplierImportInput.accept = '.csv';
            window.supplierImportInput.style.display = 'none';
            window.supplierImportInput.onchange = function(event) {
                const file = event.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = function(e) {
                    const lines = e.target.result.split('\n');
                    lines.forEach(line => {
                        const [code, name, phone, email, address, status, note] = line.split(',');
                        if (name && code) {
                            const tbody = document.getElementById('supplierTableBody');
                            const tr = document.createElement('tr');
                            tr.innerHTML = `
                  <td><input type="checkbox" class="form-check-input supplier-checkbox" title="Chọn nhà cung cấp này" onclick="event.stopPropagation();"></td>
                  <td>${code}</td>
                  <td>${name}</td>
                  <td>${phone || ''}</td>
                  <td>${email || ''}</td>
                  <td>${address || ''}</td>
                  <td>${status == 'Ngừng hợp tác' ? '<span class=\"badge bg-danger\">Ngừng hợp tác</span>' : '<span class=\"badge bg-success\">Đang hợp tác</span>'}</td>
                  <td>${note || ''}</td>
                `;
                            tbody.appendChild(tr);
                        }
                    });
                    alert('Đã nhập file thành công!');
                };
                reader.readAsText(file);
            };
            document.body.appendChild(window.supplierImportInput);
        }
        window.supplierImportInput.value = '';
        window.supplierImportInput.click();
    }
    // Hiển thị chi tiết khi click vào dòng (trượt mở ngay dưới dòng được chọn)
    (function() {
        const supplierTable = document.getElementById('supplierTableBody');
        let currentDetailRow = null;
        let currentRow = null;
        if (supplierTable) {
            supplierTable.querySelectorAll('tr').forEach(row => {
                row.onclick = function() {
                    // Nếu đã mở chi tiết ở dòng này thì ẩn đi
                    if (currentRow === this && currentDetailRow) {
                        currentDetailRow.remove();
                        currentDetailRow = null;
                        currentRow = null;
                        return;
                    }
                    // Nếu đang mở chi tiết ở dòng khác thì ẩn đi
                    if (currentDetailRow) {
                        currentDetailRow.remove();
                    }
                    // Lấy dữ liệu
                    const tds = this.querySelectorAll('td');
                    // Tạo dòng chi tiết
                    const detailTr = document.createElement('tr');
                    detailTr.className = 'supplier-detail-row';
                    detailTr.innerHTML =
                        `<td colspan="9">
                          <div class="supplier-detail-card p-4 mt-0" style="animation: slideDown .3s;">
                            <c:if test="${not empty supplierList}">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                              <h2 class="fw-bold text-primary mb-0">${supplier.name}</h2>
                              <button class="btn btn-outline-secondary btn-sm" onclick="this.closest('tr').remove();window.currentDetailRow=null;window.currentRow=null;event.stopPropagation();"><i class="bi bi-x-lg"></i> Đóng</button>
                            </div>
                            <div class="row">
                              <div class="col-md-6">
                                <div class="mb-2"><strong>Mã NCC:</strong> <span>${supplier.formattedSupplierCode}</span></div>
                                <div class="mb-2"><strong>Số điện thoại:</strong> <span>${supplier.phoneNumber}</span></div>
                                <div class="mb-2"><strong>Email:</strong> <span>${supplier.email}</span></div>
                              </div>
                              <div class="col-md-6">
                                <div class="mb-2"><strong>Địa chỉ:</strong> <span>${supplier.address}</span></div>
                                <div class="mb-2"><strong>Trạng thái:</strong> <span>${tds[7].innerHTML}</span></div>
                                <div class="mb-2"><strong>Ghi chú:</strong> <span>${supplier.description}</span></div>
                              </div>
                            </div>
                            <div class="d-flex justify-content-end mt-3">
                              <button class="btn btn-primary btn-sm" onclick="editSupplier(this);event.stopPropagation();"><i class="bi bi-pencil-square me-1"></i> Sửa</button>
                              <button class="btn btn-danger btn-sm" onclick="deleteSupplier(this);event.stopPropagation();"><i class="bi bi-trash me-1"></i> Xóa</button>

                            </div>
                            </c:if>
                          </div>
                        </td>`;
                    // Chèn sau dòng hiện tại
                    this.parentNode.insertBefore(detailTr, this.nextSibling);
                    currentDetailRow = detailTr;
                    currentRow = this;
                    window.currentDetailRow = detailTr;
                    window.currentRow = this;
                }
            });
        }
    })();
    // CSS hiệu ứng trượt
    const style = document.createElement('style');
    style.innerHTML = `
    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .supplier-detail-row td { padding: 0 !important; background: #f8fafc; }
    `;
    document.head.appendChild(style);

    function bulkChangeSupplierStatus(status) {
        const checked = document.querySelectorAll('.supplier-checkbox:checked');
        if (checked.length === 0) {
            alert('Vui lòng chọn nhà cung cấp!');
            return;
        }
        checked.forEach(cb => {
            const row = cb.closest('tr');
            const statusTd = row.querySelectorAll('td')[7];
            if (status === 'Ngừng hợp tác') {
                statusTd.innerHTML = '<span class="badge bg-danger">Ngừng hợp tác</span>';
            } else {
                statusTd.innerHTML = '<span class="badge bg-success">Đang hợp tác</span>';
            }
        });
    }
</script>
