<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
        margin-right: 12px;
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
    .supplier-detail-row {
        transition: height 0.3s cubic-bezier(.4,0,.2,1), opacity 0.3s;
        overflow: hidden;
        height: 0;
        opacity: 0;
    }
    .supplier-detail-row.show {
        height: auto !important;
        opacity: 1;
    }
</style>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Danh sách nhà cung cấp</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
                <li class="breadcrumb-item active">Danh sách nhà cung cấp</li>
            </ol>
        </nav>
    </div>

    <section class="section">
        <div class="container-fluid px-0">
            <div class="card shadow-sm rounded-4 p-4" style="border: none;">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap flex-row-reverse">
                    <div class="d-flex flex-row align-items-center btn-group-header mb-3">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newSupplierModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm mới
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-success dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-file-earmark-arrow-down me-1"></i> Xuất/Nhập
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="exportSuppliers()">Xuất Excel</a></li>
                                <li><a class="dropdown-item" href="#" onclick="importSuppliers()">Nhập Excel</a></li>
                            </ul>
                        </div>
                        <!-- Nút Xóa chỉ 1 cấp -->
                        <button class="btn btn-danger" type="button" onclick="deleteSelectedSuppliersTemp()">
                            <i class="bi bi-file-earmark-x me-1"></i> Xóa
                        </button>
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
                        </tr>
                        </thead>
                        <tbody id="supplierTableBody">
                        <c:if test="${not empty supplierList}">
                            <c:forEach var="supplier" items="${supplierList}">
                                <tr
                                        data-supplier-id="${supplier.id}"
                                        data-formatted-code="${supplier.formattedSupplierCode}"
                                        style="cursor:pointer"
                                        onclick="toggleSupplierDetail('${supplier.id}')">
                                    <td>
                                        <input type="checkbox" class="form-check-input supplier-checkbox"
                                               value="${supplier.id}"
                                               onclick="event.stopPropagation();">
                                    </td>
                                    <td style="color: #0D6EFD">
                                        <c:out value="${supplier.formattedSupplierCode}" />
                                    </td>
                                    <td>${supplier.name}</td>
                                    <td>${supplier.phoneNumber}</td>
                                    <td>${supplier.email}</td>
                                    <td>${supplier.address}</td>
                                </tr>
                                <!-- Dòng chi tiết (ẩn/hiện bằng JS) -->
                                <tr class="supplier-detail-row" style="display:none;" id="detail-${supplier.id}">
                                    <td colspan="6">
                                        <div class="supplier-detail-card p-4 mt-0">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <h2 class="fw-bold text-primary mb-0">${supplier.name}</h2>
                                                <button class="btn btn-outline-secondary btn-sm" onclick="closeDetailRow('${supplier.id}');event.stopPropagation();"><i class="bi bi-x-lg"></i> Đóng</button>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-2"><strong>Mã NCC:</strong> <span>${supplier.formattedSupplierCode}</span></div>
                                                    <div class="mb-2"><strong>Số điện thoại:</strong> <span>${supplier.phoneNumber}</span></div>
                                                    <div class="mb-2"><strong>Email:</strong> <span>${supplier.email}</span></div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-2"><strong>Địa chỉ:</strong> <span>${supplier.address}</span></div>
                                                    <div class="mb-2"><strong>Ghi chú:</strong> <span>${supplier.description}</span></div>
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-end mt-3">
                                                <button class="btn btn-primary btn-sm" onclick="openEditSupplierModal('${supplier.id}');event.stopPropagation();" data-bs-toggle="modal" data-bs-target="#editSupplierModal"><i class="bi bi-pencil-square me-1"></i> Sửa</button>
                                                <button class="btn btn-danger btn-sm" onclick="deleteSupplier('${supplier.id}');event.stopPropagation();"><i class="bi bi-trash me-1"></i> Xóa</button>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty supplierList}">
                            <tr>
                                <td colspan="7" class="text-center">Không có nhà cung cấp nào.</td>
                            </tr>
                        </c:if>
                        </tbody>

                    </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination-container">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${startPage}" aria-label="Homepage">
                                        <span aria-hidden="true">«</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">‹</span>
                                    </a>
                                </li>
                            </c:if>

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

                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${totalPages}">${totalPages}</a>
                                </li>
                            </c:if>

                            <c:if test="${currentPage < endPage && currentPage >= 1}">
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">›</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="supplier?page=${totalPages}" aria-label="EndPage">
                                        <span aria-hidden="true">»</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </section>
    <!-- Modal Thêm Nhà Cung Cấp= -->
    <div class="modal fade" id="newSupplierModal" tabindex="-1" aria-labelledby="newSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <form id="newSupplierForm" action="/supplier" method="post">
                <input type="hidden" name="action" value="create">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="newSupplierModalLabel">Thêm nhà cung cấp mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="supplierCode" class="form-label">Mã NCC</label>
                                    <input type="text" class="form-control" id="supplierCode" placeholder="[Sẽ được tạo tự động sau khi lưu]" readonly>
                                </div>
                                <div class="mb-3">
                                    <label for="supplierName" class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="supplierName" name="supplierName" required>
                                </div>
                                <div class="mb-3">
                                    <label for="supplierPhone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="supplierPhone" name="supplierPhone" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="supplierEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="supplierEmail" name="supplierEmail">
                                </div>
                                <div class="mb-3">
                                    <label for="supplierAddress" class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="supplierAddress" name="supplierAddress" required>
                                </div>
                                <div class="mb-3">
                                    <label for="supplierNote" class="form-label">Ghi chú</label>
                                    <textarea class="form-control" id="supplierNote" name="supplierNote" rows="2" placeholder="Nhập ghi chú..."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Thêm</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Sửa Nhà Cung Cấp -->
    <div class="modal fade" id="editSupplierModal" tabindex="-1" aria-labelledby="editSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <form id="editSupplierForm" action="${pageContext.request.contextPath}/supplier" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="supplierCode" id="editSupplierCode">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editSupplierModalLabel">Sửa nhà cung cấp</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="supplierName" id="editSupplierName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="supplierEmail" id="editSupplierEmail">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="supplierPhone" id="editSupplierPhone" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="supplierAddress" id="editSupplierAddress" required>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Ghi chú</label>
                                <textarea class="form-control" name="supplierNote" id="editSupplierNote" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Lưu</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- Hidden Form for Server Actions -->
    <form id="serverActionForm" action="/supplier" method="post" style="display:none;">
        <input type="hidden" name="action" id="serverAction">
        <input type="hidden" name="supplierIds" id="serverSupplierIds">
        <input type="file" name="file" id="importFile" accept=".csv">
    </form>
</main>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
    let currentSupplier = null;

    // Hiển thị chi tiết khi click vào dòng (trượt mở ngay dưới dòng được chọn)


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

    function toggleSelectAllSupplier(checkbox) {
        const checkboxes = document.querySelectorAll('.supplier-checkbox');
        checkboxes.forEach(cb => {
            cb.checked = checkbox.checked;
        });
    }

    function filterSuppliers() {
        const search = document.getElementById('searchSupplierInput').value.toLowerCase();
        const rows = document.querySelectorAll('#supplierTableBody tr:not(.supplier-detail-row)');
        rows.forEach(row => {
            const code = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const name = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const phone = row.querySelector('td:nth-child(5)').textContent.toLowerCase();
            row.style.display = (code.includes(search) || name.includes(search) || phone.includes(search)) ? '' : 'none';
        });
    }

    function exportSuppliers() {
        window.location.href = '${pageContext.request.contextPath}/supplier?action=export';
    }

    function importSuppliers() {
        const fileInput = document.getElementById('importFile');
        fileInput.onchange = function(event) {
            if (event.target.files[0]) {
                const form = document.getElementById('serverActionForm');
                document.getElementById('serverAction').value = 'import';
                form.submit();
            }
        };
        fileInput.click();
    }

    function hideSupplierRows(ids) {
        ids.forEach(id => {
            const row = document.querySelector(`tr[data-supplier-id="${id}"]`);
            if (row) row.style.display = 'none';
            const detailRow = document.getElementById('detail-' + id);
            if (detailRow) detailRow.style.display = 'none';
        });
    }

    function deleteSupplier(supplierId) {
        if (!supplierId) return;
        if (!confirm('Bạn có chắc muốn xóa nhà cung cấp này?')) return;
        fetch('${pageContext.request.contextPath}/supplier', {
            method: 'POST',
            headers: { 'Accept': 'application/json' },
            body: new URLSearchParams({
                action: 'delete',
                supplierIds: supplierId
            })
        })
            .then(res => {
                if (!res.ok) throw new Error('Lỗi server');
                return res.json();
            })
            .then(json => {
                if (json.status === "success") {
                    hideSupplierRows([supplierId]);
                } else {
                    alert('Xóa thất bại!');
                }
            })
            .catch(() => alert('Có lỗi xảy ra khi xóa!'));
    }

    function deleteSelectedSuppliersTemp() {
        const checked = document.querySelectorAll('.supplier-checkbox:checked');
        if (checked.length === 0) {
            alert('Vui lòng chọn nhà cung cấp!');
            return;
        }
        const supplierIds = Array.from(checked).map(cb => cb.value);
        if (!confirm(`Bạn có chắc muốn chuyển ${supplierIds.length} nhà cung cấp vào thùng rác?`)) return;
        fetch('${pageContext.request.contextPath}/supplier', {
            method: 'POST',
            headers: { 'Accept': 'application/json' },
            body: new URLSearchParams({
                action: 'delete',
                supplierIds: supplierIds.join(',')
            })
        })
            .then(res => {
                if (!res.ok) throw new Error('Lỗi server');
                return res.json();
            })
            .then(json => {
                if (json.status === "success") {
                    hideSupplierRows(supplierIds);
                } else {
                    alert('Xóa thất bại!');
                }
            })
            .catch(() => alert('Có lỗi xảy ra khi xóa!'));
    }

    function editSupplier(supplierId) {
        const row = document.querySelector(`tr[data-supplier-id="${supplierId}"]`);
        if (!row) return;
        const tds = row.querySelectorAll('td');
        document.getElementById('supplierAction').value = 'update';
        document.getElementById('supplierCode').value = tds[1].textContent;
        document.getElementById('supplierName').value = tds[2].textContent;
        document.getElementById('supplierPhone').value = tds[4].textContent;
        document.getElementById('supplierEmail').value = tds[5].textContent;
        document.getElementById('supplierAddress').value = tds[6].textContent;
        document.getElementById('supplierNote').value = row.dataset.description || '';
        document.getElementById('editSupplierModalLabel').textContent = 'Sửa Nhà Cung Cấp';
    }

    // Tạo object lưu thông tin supplier theo mã
    var supplierMap = {};
    <c:forEach var="supplier" items="${supplierList}">
    supplierMap["${supplier.id}"] = {
        id: "${supplier.id}",
        formattedSupplierCode: "${supplier.formattedSupplierCode}",
        name: "${supplier.name}",
        phoneNumber: "${supplier.phoneNumber}",
        email: "${supplier.email}",
        address: "${supplier.address}",
        description: "${supplier.description}"
    };
    </c:forEach>
    function openEditSupplierModal(supplierId) {
        var supplier = supplierMap[supplierId];
        if (!supplier) return;
        document.getElementById('editSupplierCode').value = supplier.id; // id thực
        document.getElementById('editSupplierName').value = supplier.name;
        document.getElementById('editSupplierPhone').value = supplier.phoneNumber;
        document.getElementById('editSupplierEmail').value = supplier.email;
        document.getElementById('editSupplierAddress').value = supplier.address;
        document.getElementById('editSupplierNote').value = supplier.description || '';
    }

    document.getElementById('editSupplierForm').onsubmit = function(e) {
        e.preventDefault();
        const form = e.target;
        const data = new FormData(form);

        fetch(form.action, {
            method: 'POST',
            body: data
        })
            .then(res => {
                if (!res.ok) throw new Error('Lỗi cập nhật');
                return res.json();
            })
            .then(json => {
                if (json.status === "success") {
                    // Cập nhật UI như bạn đã làm
                    // ...
                    const modal = bootstrap.Modal.getInstance(document.getElementById('editSupplierModal'));
                    if (modal) modal.hide();
                } else {
                    alert('Cập nhật thất bại!');
                }
            })
            .catch(() => {
                alert('Có lỗi xảy ra khi cập nhật!');
            });
    };

    document.getElementById('newSupplierForm').onsubmit = function(e) {
        e.preventDefault();
        const form = e.target;
        const data = new FormData(form);
        fetch(form.action, {
            method: 'POST',
            body: data
        })
            .then(res => res.json())
            .then(json => {
                if (json.status === "success") {
                    // Reload hoặc thêm dòng mới vào bảng bằng JS
                    location.reload();
                } else {
                    alert('Thêm thất bại!');
                }
            });
    };

    function toggleSupplierDetail(supplierId) {
        var detailRow = document.getElementById('detail-' + supplierId);
        if (!detailRow) return;

        // Nếu đang mở thì đóng lại
        if (detailRow.classList.contains('show')) {
            detailRow.style.height = detailRow.scrollHeight + 'px'; // Đảm bảo có giá trị height trước khi đóng
            // Bắt buộc reflow để transition hoạt động
            void detailRow.offsetHeight;
            detailRow.style.height = '0';
            detailRow.style.opacity = '0';
            detailRow.classList.remove('show');
            setTimeout(function() {
                detailRow.style.display = 'none';
            }, 300);
        } else {
            // Đóng tất cả dòng chi tiết khác
            document.querySelectorAll('.supplier-detail-row.show').forEach(row => {
                row.style.height = '0';
                row.style.opacity = '0';
                row.classList.remove('show');
                setTimeout(function(r) {
                    r.style.display = 'none';
                }, 300, row);
            });

            // Mở dòng chi tiết này
            detailRow.style.display = 'table-row';
            let content = detailRow.querySelector('.supplier-detail-card');
            detailRow.style.height = '0';
            detailRow.style.opacity = '0';
            // Bắt buộc reflow để transition hoạt động
            void detailRow.offsetHeight;
            if (content) {
                detailRow.style.height = content.offsetHeight + 'px';
            }
            detailRow.classList.add('show');
            detailRow.style.opacity = '1';
            // Sau khi transition xong, set height về auto để không bị lỗi khi resize nội dung
            setTimeout(function() {
                if (detailRow.classList.contains('show')) {
                    detailRow.style.height = 'auto';
                }
            }, 300);
        }
    }

    function closeDetailRow(supplierId) {
        var detailRow = document.getElementById('detail-' + supplierId);
        if (detailRow) {
            detailRow.classList.remove('show');
            detailRow.style.height = '0';
            detailRow.style.opacity = '0';
            setTimeout(function() {
                detailRow.style.display = 'none';
            }, 300); // 300ms khớp với transition CSS
        }
    }

</script>