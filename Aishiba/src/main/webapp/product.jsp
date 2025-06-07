<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    color: #6c757d;
    pointer-events: none;
    background-color: #fff;
    border-color: #dee2e6;
}

ul li {
    text-decoration: none;
    list-style: none;
}
/* Responsive: Ẩn cột ít quan trọng trên mobile */
@media (max-width: 768px) {
    .table thead th:nth-child(7),
    .table td:nth-child(7),
    .table thead th:nth-child(8),
    .table td:nth-child(8) {
        display: none;
    }
    .table {
        font-size: 0.9rem;
    }
}

.btn-group-header .btn-action {
    min-width: 160px;
    border-radius: 8px !important;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>
<main id="main" class="main">
    <div class="pagetitle">
        <h1>Danh sách sản phẩm</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
                <li class="breadcrumb-item active">Danh sách sản phẩm</li>
            </ol>
        </nav>
    </div>
    <section class="section">
        <div class="container-fluid px-0">
            <div class="card shadow-sm rounded-4 p-4" style="border: none;">
                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap flex-row-reverse">
                    <div class="d-flex flex-row align-items-center btn-group-header gap-2">
                        <button class="btn btn-outline-primary btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#addProductModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm sản phẩm
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-outline-success btn-sm btn-action dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-file-earmark-arrow-down me-1"></i> Xuất file
                            </button>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="#" id="exportBtn">
                                        <i class="bi bi-file-earmark-excel me-2"></i>Xuất Excel
                                    </a>
                                </li>
                                <li>
                                    <label class="dropdown-item" style="cursor:pointer;">
                                        <i class="bi bi-file-earmark-arrow-up me-2"></i>Nhập Excel
                                        <input type="file" id="importFileInput" accept=".xlsx,.xls" style="display:none;">
                                    </label>
                                </li>
                            </ul>
                        </div>
                        <button class="btn btn-outline-danger btn-sm btn-action" id="deleteSelectedBtn" disabled>
                            <i class="bi bi-trash me-1"></i> Xóa đã chọn
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary btn-sm btn-action dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-funnel me-1"></i> Lọc trạng thái
                            </button>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="#" onclick="filterProductsByStatus('')">Tất cả</a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="filterProductsByStatus('Còn hàng')">Còn hàng</a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="filterProductsByStatus('Hết hàng')">Hết hàng</a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="filterProductsByStatus('Đang kinh doanh')">Đang kinh doanh</a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="filterProductsByStatus('Ngừng kinh doanh')">Ngừng kinh doanh</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <h2 class="fw-bold text-primary mb-0 ms-2">Danh sách sản phẩm</h2>
                </div>
                <div class="row g-2 mb-3">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm theo mã, tên hàng..." oninput="filterProducts()">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filterCategory" title="Lọc theo nhóm hàng" onchange="filterProducts()">
                            <option value="">Tất cả nhóm hàng</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <!-- Có thể thêm filter thời gian nếu cần -->
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle rounded-4 overflow-hidden">
                        <thead class="table-light">
                        <tr>
                            <th style="width:40px">
                                <input type="checkbox" class="form-check-input" id="selectAll" title="Chọn tất cả" onclick="toggleSelectAll(this)">
                            </th>
                            <th>Mã hàng</th>
                            <th>Tên hàng</th>
                            <th class="text-end">Giá bán</th>
                            <th class="text-end">Tồn kho</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-center">Trạng thái KD</th>
                            <th>Thời gian tạo</th>
                        </tr>
                        </thead>
                        <tbody id="productsTableBody">
                            <c:if test="${not empty productList}">
                                <c:forEach items="${productList}" var="product">
                                    <tr 
                                        data-product-id="${product.id}"
                                        data-code="${product.formattedIdToy}"
                                        data-name="${product.name}"
                                        data-price="${formattedPrice}"
                                        data-stock="${product.stock}"
                                        data-status="${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}"
                                        data-business="${product.status == 'true' ? 'Đang kinh doanh' : 'Ngừng kinh doanh'}"
                                        data-created="${formattedCreatedAt}"
                                        data-desc="${product.description}">
                                        <td>
                                            <input type="checkbox" class="form-check-input product-checkbox" value="${product.id}">
                                        </td>
                                        <td style="color: #0D6EFD">
                                            <c:out value="${product.formattedIdToy}" />
                                        </td>
                                        <td>
                                            <c:out value="${product.name}" />
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" var="formattedPrice" />
                                            <c:out value="${formattedPrice}" />
                                        </td>
                                        <td class="text-end">
                                            <c:out value="${product.stock}" />
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <span class="badge bg-success">Còn hàng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Hết hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${product.status == 'true'}">
                                                    <span class="badge bg-primary">Đang kinh doanh</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Ngừng kinh doanh</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:parseDate value="${product.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedAt" />
                                            <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy HH:mm" var="formattedCreatedAt" />
                                            <c:out value="${formattedCreatedAt}" />
                                        </td>
                                        <td class="text-center">
                                            <!-- Có thể để trống hoặc thêm nút Sửa/Xóa nếu muốn -->
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty productList}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted">Không có sản phẩm nào.</td>
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
                                    <a class="page-link" href="product?page=${startPage}" aria-label="Homepage">
                                        <span aria-hidden="true">«</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="product?page=${currentPage - 1}" aria-label="Previous">
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
                                    <a class="page-link" href="prodcut?page=1">1</a>
                                </li>
                                <c:if test="${startPage > 2}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:if>

                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
                                    <a class="page-link" href="product?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="product?page=${totalPages}">${totalPages}</a>
                                </li>
                            </c:if>

                            <c:if test="${currentPage < endPage && currentPage >= 1}">
                                <li class="page-item">
                                    <a class="page-link" href="product?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">›</span>
                                    </a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="product?page=${totalPages}" aria-label="EndPage">
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
    <!-- Modal Thêm/Sửa sản phẩm -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content rounded-4">
      <div class="modal-header">
        <h5 class="modal-title fw-bold" id="addProductModalLabel">
          <i class="bi bi-box-seam me-2"></i>Thêm / Sửa sản phẩm
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body">
        <form id="productForm" autocomplete="off">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="productCode" class="form-label">Mã sản phẩm <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="productCode" required>
            </div>
            <div class="col-md-6">
              <label for="productName" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="productName" required>
            </div>
            <div class="col-md-6">
              <label for="productPrice" class="form-label">Giá bán <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="productPrice" min="0" required>
            </div>
            <div class="col-md-6">
              <label for="productStock" class="form-label">Tồn kho <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="productStock" min="0" required>
            </div>
            <div class="col-md-6">
              <label for="productCategory" class="form-label">Nhóm hàng</label>
              <select class="form-select" id="productCategory">
                <option value="">Chọn nhóm hàng</option>
                <!-- Thêm option động nếu cần -->
              </select>
            </div>
            <div class="col-md-6">
              <label for="productStatus" class="form-label">Trạng thái hàng</label>
              <select class="form-select" id="productStatus">
                <option value="Còn hàng">Còn hàng</option>
                <option value="Hết hàng">Hết hàng</option>
              </select>
            </div>
            <div class="col-md-12">
              <label for="productDesc" class="form-label">Mô tả</label>
              <textarea class="form-control" id="productDesc" rows="2"></textarea>
            </div>
            <div class="col-md-12">
              <label for="productImage" class="form-label">Ảnh sản phẩm</label>
              <div class="d-flex align-items-center gap-3 flex-wrap">
                <img id="productImagePreview" src="https://via.placeholder.com/80x80?text=No+Image" alt="Ảnh sản phẩm" style="width:80px;height:80px;object-fit:cover;border-radius:8px;border:1px solid #eee;">
                <input type="file" class="form-control" id="productImage" accept="image/*" style="max-width:220px;">
              </div>
            </div>
            <div class="col-md-6">
              <label for="productCreated" class="form-label">Ngày tạo</label>
              <input type="text" class="form-control" id="productCreated" readonly>
            </div>
            <div class="col-md-6 d-flex align-items-center justify-content-end">
              <label class="form-check-label me-2" for="productBusiness">Đang kinh doanh</label>
              <div class="form-check form-switch m-0">
                <input class="form-check-input" type="checkbox" id="productBusiness" checked>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer justify-content-end">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
          <i class="bi bi-x-circle me-1"></i>Hủy
        </button>
        <button type="button" class="btn btn-success" id="saveProductBtn">
          <i class="bi bi-save2 me-1"></i>Lưu sản phẩm
        </button>
      </div>
    </div>
  </div>
</div>
<!-- Modal Xem chi tiết sản phẩm -->
<div class="modal fade" id="viewProductModal" tabindex="-1" aria-labelledby="viewProductModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content rounded-4">
      <div class="modal-header">
        <h5 class="modal-title fw-bold" id="viewProductModalLabel">
          <i class="bi bi-eye me-2"></i>Chi tiết sản phẩm
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body">
        <form id="viewProductForm" autocomplete="off">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Mã sản phẩm</label>
              <input type="text" class="form-control" id="viewProductCode" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">Tên sản phẩm</label>
              <input type="text" class="form-control" id="viewProductName" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">Giá bán</label>
              <input type="text" class="form-control" id="viewProductPrice" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">Tồn kho</label>
              <input type="text" class="form-control" id="viewProductStock" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">Nhóm hàng</label>
              <input type="text" class="form-control" id="viewProductCategory" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">Trạng thái hàng</label>
              <input type="text" class="form-control" id="viewProductStatus" readonly>
            </div>
            <div class="col-md-12">
              <label class="form-label">Mô tả</label>
              <textarea class="form-control" id="viewProductDesc" rows="2" readonly></textarea>
            </div>
            <div class="col-md-12">
              <label class="form-label">Ảnh sản phẩm</label>
              <div>
                <img id="viewProductImagePreview" src="https://via.placeholder.com/80x80?text=No+Image" alt="Ảnh sản phẩm" style="width:80px;height:80px;object-fit:cover;border-radius:8px;border:1px solid #eee;">
              </div>
            </div>
            <div class="col-md-6">
              <label class="form-label">Ngày tạo</label>
              <input type="text" class="form-control" id="viewProductCreated" readonly>
            </div>
            <div class="col-md-6 d-flex align-items-center justify-content-end">
              <label class="form-check-label me-2">Đang kinh doanh</label>
              <div class="form-check form-switch m-0">
                <input class="form-check-input" type="checkbox" id="viewProductBusiness" disabled>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer justify-content-end">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
          <i class="bi bi-x-circle me-1"></i>Đóng
        </button>
      </div>
    </div>
  </div>
</div>
</main>
<script src="${pageContext.request.contextPath}assets/js/main.js"></script>
<script>
    let currentProduct = null;

    // Khi mở modal thêm/sửa sản phẩm, tự động set ngày tạo nếu là thêm mới
    document.getElementById('addProductModal').addEventListener('show.bs.modal', function () {
        document.getElementById('productCreated').value = new Date().toLocaleString();
    });

    // Chọn tất cả sản phẩm
    function toggleSelectAll(checkbox) {
        const checkboxes = document.querySelectorAll('.product-checkbox');
        checkboxes.forEach(cb => {
            cb.checked = checkbox.checked;
        });
    }

    // Lọc sản phẩm theo ô tìm kiếm, nhóm hàng, trạng thái
    function filterProducts() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const filterCategory = document.getElementById('filterCategory').value;
        const filterStatus = window.selectedStatus || '';
        const rows = document.querySelectorAll('#productsTableBody tr');

        rows.forEach(row => {
            const code = row.querySelector('td:nth-child(2)')?.textContent.toLowerCase() || '';
            const name = row.querySelector('td:nth-child(3)')?.textContent.toLowerCase() || '';
            const category = row.getAttribute('data-category') || '';
            const status = row.querySelector('td:nth-child(6) .badge')?.textContent || '';
            const business = row.querySelector('td:nth-child(7) .badge')?.textContent || '';

            const matchSearch = code.includes(search) || name.includes(search);
            const matchCategory = !filterCategory || category === filterCategory;

            // Lọc theo trạng thái hoặc trạng thái kinh doanh
            let matchStatus = true;
            if (filterStatus === 'Còn hàng' || filterStatus === 'Hết hàng') {
                matchStatus = status === filterStatus;
            } else if (filterStatus === 'Đang kinh doanh' || filterStatus === 'Ngừng kinh doanh') {
                matchStatus = business === filterStatus;
            }

            row.style.display = (matchSearch && matchCategory && matchStatus) ? '' : 'none';
        });
    }

    // Lọc trạng thái từ dropdown "Lọc trạng thái"
    function filterProductsByStatus(status) {
        window.selectedStatus = status; // dùng biến toàn cục thay cho select đã xóa
        filterProducts();
    }

    // Xem trước ảnh sản phẩm khi chọn file
    document.getElementById('productImage').addEventListener('change', function(e) {
        const file = e.target.files[0];
        const preview = document.getElementById('productImagePreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(evt) {
                preview.src = evt.target.result;
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = 'https://via.placeholder.com/80x80?text=No+Image';
        }
    });

    function viewProductDetail(productId) {
        // Tìm dòng sản phẩm theo data-product-id
        const row = document.querySelector(`tr[data-product-id="${productId}"]`);
        if (!row) return;

        document.getElementById('viewProductCode').value = row.dataset.code || '';
        document.getElementById('viewProductName').value = row.dataset.name || '';
        document.getElementById('viewProductPrice').value = row.dataset.price || '';
        document.getElementById('viewProductStock').value = row.dataset.stock || '';
        document.getElementById('viewProductCategory').value = row.dataset.category || '';
        document.getElementById('viewProductStatus').value = row.dataset.status || '';
        document.getElementById('viewProductDesc').value = row.dataset.desc || '';
        document.getElementById('viewProductCreated').value = row.dataset.created || '';
        document.getElementById('viewProductBusiness').checked = row.dataset.business === 'Đang kinh doanh';

        // Nếu có ảnh, set ảnh
        // document.getElementById('viewProductImagePreview').src = row.dataset.image || 'https://via.placeholder.com/80x80?text=No+Image';

        // Hiển thị modal
        const modal = new bootstrap.Modal(document.getElementById('viewProductModal'));
        modal.show();
    }
(function() {
    const productTable = document.getElementById('productsTableBody');
    let currentDetailRow = null;
    let currentRow = null;

    // Hàm render chi tiết sản phẩm
    function showProductDetail(row) {
        // Xóa chi tiết cũ nếu có
        if (currentDetailRow) currentDetailRow.remove();
        if (currentRow === row) {
            currentDetailRow = null;
            currentRow = null;
            return;
        }

        // Lấy dữ liệu từ data-*
        const code = row.dataset.code;
        const name = row.dataset.name;
        const price = row.dataset.price;
        const stock = row.dataset.stock;
        const status = row.dataset.status;
        const business = row.dataset.business;
        const created = row.dataset.created;
        const desc = row.dataset.desc || 'Không có mô tả';

        const detailTr = document.createElement('tr');
        detailTr.className = 'product-detail-row';
        detailTr.innerHTML = `
            <td colspan="9">
              <div class="product-detail-card p-4 mt-0" style="animation: slideDown .3s;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                  <h2 class="fw-bold text-primary mb-0">${name}</h2>
                  <button class="btn btn-outline-secondary btn-sm" onclick="this.closest('tr').remove();window.currentDetailRow=null;window.currentRow=null;event.stopPropagation();"><i class="bi bi-x-lg"></i> Đóng</button>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <div class="mb-2"><strong>Mã sản phẩm:</strong> <span>${code}</span></div>
                    <div class="mb-2"><strong>Giá bán:</strong> <span>${price}</span></div>
                    <div class="mb-2"><strong>Tồn kho:</strong> <span>${stock}</span></div>
                  </div>
                  <div class="col-md-6">
                    <div class="mb-2"><strong>Trạng thái:</strong> <span class="badge bg-${status == 'Còn hàng' ? 'success' : 'danger'}">${status}</span></div>
                    <div class="mb-2"><strong>Kinh doanh:</strong> <span class="badge bg-${business == 'Đang kinh doanh' ? 'primary' : 'secondary'}">${business}</span></div>
                    <div class="mb-2"><strong>Ngày tạo:</strong> <span>${created}</span></div>
                  </div>
                  <div class="col-12 mt-2">
                    <div class="mb-2"><strong>Mô tả:</strong> <span>${desc}</span></div>
                  </div>
                </div>
                <div class="d-flex justify-content-end mt-3">
                  <button class="btn btn-primary btn-sm me-2" onclick="editProduct('${row.dataset.productId}');event.stopPropagation();" data-bs-toggle="modal" data-bs-target="#addProductModal"><i class="bi bi-pencil-square me-1"></i> Sửa</button>
                  <button class="btn btn-danger btn-sm" onclick="deleteProduct('${row.dataset.productId}');event.stopPropagation();"><i class="bi bi-trash me-1"></i> Xóa</button>
                </div>
              </div>
            </td>`;
        row.parentNode.insertBefore(detailTr, row.nextSibling);
        currentDetailRow = detailTr;
        currentRow = row;
        // Để có thể đóng từ nút Đóng
        window.currentDetailRow = detailTr;
        window.currentRow = row;
    }

    // Gán lại sự kiện click cho từng dòng (trừ dòng chi tiết)
    function bindProductRowEvents() {
        productTable.querySelectorAll('tr').forEach(row => {
            // Bỏ sự kiện cho dòng chi tiết
            if (row.classList.contains('product-detail-row')) return;
            // Xóa sự kiện cũ nếu có
            row.onclick = function(event) {
                // Không mở chi tiết khi click vào checkbox hoặc nút trong cột hành động
                if (
                    event.target.type === 'checkbox' ||
                    event.target.closest('.btn') ||
                    event.target.closest('.dropdown-menu')
                ) return;
                showProductDetail(this);
            };
        });
    }

    // Gán sự kiện khi trang load
    bindProductRowEvents();

    // Nếu có phân trang hoặc render lại bảng, hãy gọi lại bindProductRowEvents()
    window.bindProductRowEvents = bindProductRowEvents;
})();

// CSS hiệu ứng trượt
const style = document.createElement('style');
style.innerHTML = `
@keyframes slideDown {
  from { opacity: 0; transform: translateY(-20px); }
  to { opacity: 1; transform: translateY(0); }
}
.product-detail-row td { padding: 0 !important; background: #f8fafc; }
`;
document.head.appendChild(style);

// Hàm Sửa/Xóa sản phẩm (bạn tự xử lý logic)
function editProduct(productId) {
    // Mở modal và load dữ liệu sản phẩm theo productId
    // ...
}
function deleteProduct(productId) {
    if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
        // Gửi request xóa sản phẩm
        // ...
    }
}
</script>
