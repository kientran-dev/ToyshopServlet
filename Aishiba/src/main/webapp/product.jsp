<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<style>
    /* ==================== COMMON CARD & TABLE STYLE ==================== */
.card {
    border-radius: 16px !important;
    box-shadow: 0 2px 16px rgba(0,0,0,0.06) !important;
    border: none !important;
    background: #fff;
}

.table {
    border-radius: 12px !important;
    overflow: hidden;
    background: #fff;
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    font-size: 1rem;
}

.table thead th {
    background: #f6f8fa !important;
    font-weight: 600;
    font-size: 1.05rem;
    padding: 0.75rem 1rem;
    border-bottom: 2px solid #e5e7eb;
    user-select: none;
    white-space: nowrap;
}

.table tbody tr {
    transition: background-color 0.25s ease;
    cursor: default;
}

.table tbody tr:hover {
    background: #f0f6ff;
}

.table td {
    vertical-align: middle;
    padding: 0.75rem 1rem;
    white-space: nowrap;
}

/* ==================== BADGE ==================== */
.badge {
    font-size: 0.875rem;
    padding: 0.35em 0.65em;
    font-weight: 500;
    border-radius: 12px;
    user-select: none;
    display: inline-block;
    text-align: center;
}

.badge.bg-success {
    background: #22c55e !important;
    color: white;
}

.badge.bg-danger {
    background: #ef4444 !important;
    color: white;
}

/* ==================== BUTTONS ==================== */
.btn-primary {
    background: #2563eb !important;
    border: none;
    color: white;
    transition: filter 0.3s, box-shadow 0.3s;
    border-radius: 8px;
    padding: 0.5rem 1rem;
}

.btn-primary:hover {
    filter: brightness(0.9);
    box-shadow: 0 0 8px rgba(37, 99, 235, 0.4);
}

.btn-success {
    background: #22c55e !important;
    border: none;
    color: white;
    transition: filter 0.3s, box-shadow 0.3s;
    border-radius: 8px;
    padding: 0.5rem 1rem;
}

.btn-success:hover {
    filter: brightness(0.9);
    box-shadow: 0 0 8px rgba(34, 197, 94, 0.4);
}

.btn-outline-secondary {
    border-radius: 8px;
    padding: 0.5rem 1rem;
    border: 1px solid #6c757d;
    color: #6c757d;
    background: transparent;
    transition: background-color 0.3s, color 0.3s;
}

.btn-outline-secondary:hover {
    background-color: #6c757d;
    color: white;
}

/* ==================== FORM CONTROLS ==================== */
.input-group-text {
    background: #fff;
    border-right: 0;
    border-radius: 8px 0 0 8px;
    padding: 0.5rem 0.75rem;
    font-weight: 600;
}

.form-control, .form-select {
    border-radius: 8px !important;
    border: 1px solid #ced4da;
    padding: 0.5rem 0.75rem;
    transition: border-color 0.3s, box-shadow 0.3s;
}

.form-control:focus, .form-select:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
    outline: none;
}

/* ==================== PRODUCT DETAIL ROW ==================== */
.product-detail-row {
    display: none;
    background: #fff;
    transition: max-height 0.3s ease;
    max-height: 0;
    overflow: hidden;
}

.product-detail-row.show {
    display: table-row;
    max-height: 1000px;
}

.product-detail-row td {
    padding: 0 !important;
}

.product-detail-row .product-detail-content {
    padding: 1.5rem;
    border-top: 1px solid #eee;
    transform: translateY(-100%);
    opacity: 0;
    transition: transform 0.3s ease, opacity 0.3s ease;
}

.product-detail-row.show .product-detail-content {
    transform: translateY(0);
    opacity: 1;
}

.product-detail-row .product-detail-content .row {
    margin: 0;
}

.product-detail-row .product-detail-content img {
    max-height: 200px;
    object-fit: contain;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

/* ==================== DETAIL SECTION ==================== */
.detail-section {
    background: #f8fafc;
    padding: 1rem;
    border-radius: 12px;
    margin-bottom: 1rem;
    border: 1px solid #e5e7eb;
    transition: box-shadow 0.2s ease, transform 0.2s ease;
}

.detail-section:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    transform: translateY(-2px);
}

.detail-section h5 {
    color: #2563eb;
    margin-bottom: 1rem;
    font-weight: 600;
}

.detail-label {
    font-weight: 600;
    color: #4b5563;
    margin-bottom: 0.5rem;
}

.detail-value {
    color: #1f2937;
}

/* ==================== SELECTED ROW ==================== */
.selected-row {
    background: #f0f6ff !important;
    transition: background-color 0.3s ease;
}

/* ==================== STAR ICONS ==================== */
.star-header {
    pointer-events: none;
    opacity: 0.7;
}

.star-outline {
    color: #ffc107;
    cursor: pointer;
    transition: color 0.2s, transform 0.2s;
    font-size: 1.2rem;
}

.star-outline:hover {
    color: #ffca28;
    transform: scale(1.1);
}

.header-star {
    cursor: pointer;
    font-size: 1.1em;
    transition: transform 0.2s;
}

.header-star:hover {
    transform: scale(1.2);
}

/* ==================== PRODUCT IMAGES GRID ==================== */
.product-images {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
    margin-bottom: 1rem;
}

.product-image-item {
    position: relative;
    aspect-ratio: 1;
    border-radius: 8px;
    overflow: hidden;
    border: 2px solid #e5e7eb;
    background: white;
    box-shadow: 0 1px 4px rgba(0,0,0,0.05);
}

.product-image-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.product-image-item .remove-image {
    position: absolute;
    top: 0.5rem;
    right: 0.5rem;
    background: rgba(239, 68, 68, 0.9);
    color: white;
    border: none;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    font-size: 14px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background-color 0.3s;
}

.product-image-item .remove-image:hover {
    background: rgba(220, 38, 38, 0.9);
}

/* ==================== IMAGE UPLOAD PLACEHOLDER ==================== */
.image-upload-placeholder {
    border: 2px dashed #e5e7eb;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    background: #f9fafb;
    aspect-ratio: 1;
    transition: border-color 0.2s, background-color 0.2s;
}

.image-upload-placeholder:hover {
    border-color: #2563eb;
    background: #f0f6ff;
}

/* ==================== BUSINESS STATUS SWITCH ==================== */
.business-status-switch {
    position: relative;
    display: inline-block;
    width: 60px;
    height: 30px;
}

.business-status-switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.business-status-slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ef4444;
    transition: background-color 0.4s;
    border-radius: 34px;
}

.business-status-slider:before {
    position: absolute;
    content: "";
    height: 22px;
    width: 22px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    transition: transform 0.4s;
    border-radius: 50%;
}

.business-status-switch input:checked + .business-status-slider {
    background-color: #22c55e;
}

.business-status-switch input:checked + .business-status-slider:before {
    transform: translateX(30px);
}

/* ==================== DATE RANGE INPUTS ==================== */
.date-range-inputs {
    display: flex;
    gap: 10px;
    margin-left: 10px;
    flex: 1;
}

.date-input-group {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #fff;
    padding: 0 10px;
    border: 1px solid #dee2e6;
    border-radius: 6px;
    flex: 1;
}

.date-input-group label {
    color: #6c757d;
    font-size: 0.9rem;
    margin-bottom: 0;
    white-space: nowrap;
}

.date-input-group input[type="date"] {
    border: none;
    padding: 6px 0;
    flex: 1;
    min-width: 120px;
}

.date-input-group input[type="date"]:focus {
    outline: none;
    box-shadow: none;
}

/* ==================== DROPDOWN ==================== */
.dropdown-toggle {
    border-radius: 6px;
    padding: 8px 12px;
    display: flex;
    align-items: center;
    gap: 6px;
    white-space: nowrap;
    cursor: pointer;
    user-select: none;
}

.dropdown-toggle i {
    font-size: 1.1rem;
}

.dropdown-menu {
    padding: 8px 0;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    background: white;
}

.dropdown-item {
    padding: 8px 16px;
    cursor: pointer;
    transition: background-color 0.2s;
    user-select: none;
}

.dropdown-item:hover {
    background-color: #f0f6ff;
}

.dropdown-divider {
    margin: 4px 0;
    border-top: 1px solid #e5e7eb;
}

/* ==================== FIX COLUMN WIDTHS ==================== */
.table td:first-child,
.table td:nth-child(2) {
    width: 40px;
    text-align: center;
    white-space: nowrap;
}

/* ==================== RESPONSIVE ==================== */
@media (max-width: 768px) {
    .table thead th:nth-child(7),
    .table td:nth-child(7),
    .table thead th:nth-child(8),
    .table td:nth-child(8) {
        display: none; /* Ẩn cột không cần thiết */
    }
    .table {
        font-size: 0.9rem;
    }
}

</style>
<script src="assets/js/main.js"></script>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Danh sách sản phẩm</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="#">Sản phẩm</a></li>
                <li class="breadcrumb-item active">Danh sách sản phẩm</li>
            </ol>
        </nav>
    </div>
    <section class="section">
        <div class="container-fluid px-0">
            <div class="card shadow-sm rounded-4 p-4" style="border: none;">
                <!-- Cập nhật giao diện toolbar -->
                <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
                    <h2 class="fw-bold text-primary mb-0">Danh sách sản phẩm</h2>
                    <div class="d-flex gap-2">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm mới
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-success dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-file-earmark me-1"></i> Xuất/Nhập
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="exportProducts()">
                                    <i class="bi bi-file-earmark-excel me-2"></i>Xuất Excel
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="importProducts()">
                                    <i class="bi bi-file-earmark-arrow-up me-2"></i>Nhập Excel
                                </a></li>
                            </ul>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-warning dropdown-toggle" type="button" data-bs-toggle="dropdown" id="businessActionBtn">
                                <i class="bi bi-shop me-1"></i> Kinh doanh
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="startBusinessSelected()" id="startBusinessBtn">
                                    <i class="bi bi-unlock me-2"></i>Mở kinh doanh
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="stopBusinessSelected()" id="stopBusinessBtn">
                                    <i class="bi bi-lock me-2"></i>Ngừng kinh doanh
                                </a></li>
                            </ul>
                        </div>
                        <button class="btn btn-danger" onclick="deleteSelectedProducts()" title="Xóa" id="deleteSelectedBtn">
                            <i class="bi bi-trash me-1"></i> Xóa
                        </button>
                    </div>
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
                            <option value="Đồ chơi trẻ em">Đồ chơi trẻ em</option>
                            <option value="Đồ chơi giáo dục">Đồ chơi giáo dục</option>
                            <option value="Đồ chơi mô hình">Đồ chơi mô hình</option>
                            <option value="Đồ chơi điện tử">Đồ chơi điện tử</option>
                            <option value="Đồ chơi vận động">Đồ chơi vận động</option>
                            <option value="Đồ chơi xếp hình">Đồ chơi xếp hình</option>
                            <option value="Đồ chơi nghệ thuật">Đồ chơi nghệ thuật</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filterStatus" title="Lọc theo trạng thái" onchange="filterProducts()">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Còn hàng">Còn hàng</option>
                            <option value="Hết hàng">Hết hàng</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-calendar3"></i> Thời gian
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="setDateRange('today')">Hôm nay</a></li>
                                <li><a class="dropdown-item" href="#" onclick="setDateRange('yesterday')">Hôm qua</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" onclick="setDateRange('last7Days')">7 ngày qua</a></li>
                                <li><a class="dropdown-item" href="#" onclick="setDateRange('last30Days')">30 ngày qua</a></li>
                                <li><a class="dropdown-item" href="#" onclick="setDateRange('last90Days')">90 ngày qua</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" onclick="clearDateRange()">Xóa bộ lọc</a></li>
                            </ul>
                            <div class="date-range-inputs">
                                <div class="date-input-group">
                                    <label>Từ ngày:</label>
                                    <input type="date" class="form-control" id="filterStartDate" title="Lọc từ ngày" onchange="handleDateChange()">
                                </div>
                                <div class="date-input-group">
                                    <label>Đến ngày:</label>
                                    <input type="date" class="form-control" id="filterEndDate" title="Lọc đến ngày" onchange="handleDateChange()">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle rounded-4 overflow-hidden">
                        <thead class="table-light">
                        <tr>
                            <th style="width:40px">
                                <input type="checkbox" class="form-check-input" id="selectAll" title="Chọn tất cả" onclick="toggleSelectAll(this)">
                            </th>
                            <th style="width:40px">
                                <i class="bi bi-star header-star text-warning" id="selectAllStars" title="Chọn/Bỏ chọn tất cả nổi bật" onclick="toggleSelectAllStars()"></i>
                            </th>
                            <th>Mã hàng</th>
                            <th>Tên hàng</th>
                            <th class="text-end">Giá bán</th>
                            <th class="text-end">Giá vốn</th>
                            <th class="text-end">Tồn kho</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-center">Trạng thái KD</th>
                            <th>Thời gian tạo</th>
                        </tr>
                        </thead>

                    </table>
                </div>
            </div>
        </div>
    </section>
    <!-- Modal Chỉnh Sửa Sản Phẩm -->
    <div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProductModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editProductModalLabel">Chỉnh Sửa Sản Phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editProductForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editProductCode" class="form-label">Mã sản phẩm</label>
                                    <input type="text" class="form-control" id="editProductCode" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editProductBarcode" class="form-label">Mã vạch</label>
                                    <input type="text" class="form-control" id="editProductBarcode">
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="editProductName" class="form-label">Tên sản phẩm</label>
                                    <input type="text" class="form-control" id="editProductName" required>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editProductCategory" class="form-label">Nhóm hàng</label>
                                    <select class="form-select" id="editProductCategory">
                                        <option value="">Chọn nhóm hàng</option>
                                        <option value="Đồ chơi">Đồ chơi</option>
                                        <option value="Thời trang">Thời trang</option>
                                        <option value="Phụ kiện">Phụ kiện</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editProductSupplier" class="form-label">Nhà cung cấp</label>
                                    <select class="form-select" id="editProductSupplier">
                                        <option value="">Chọn nhà cung cấp</option>
                                        <option value="NCC1">Nhà cung cấp 1</option>
                                        <option value="NCC2">Nhà cung cấp 2</option>
                                        <option value="NCC3">Nhà cung cấp 3</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="editProductPrice" class="form-label">Giá bán</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="editProductPrice" required>
                                        <span class="input-group-text">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="editProductCost" class="form-label">Giá vốn</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="editProductCost" required>
                                        <span class="input-group-text">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="editProductStock" class="form-label">Tồn kho</label>
                                    <input type="number" class="form-control" id="editProductStock" required>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="editProductDescription" class="form-label">Mô tả sản phẩm</label>
                                    <textarea class="form-control" id="editProductDescription" rows="3"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="editProductOrderNote" class="form-label">Ghi chú đặt hàng</label>
                                    <textarea class="form-control" id="editProductOrderNote" rows="2"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="editProductStatus">
                                    <label class="form-check-label" for="editProductStatus">Đang kinh doanh</label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveProductChanges()">Lưu thay đổi</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Giao diện thêm mới sản phẩm -->
    <div id="addProductModal" class="modal fade" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addProductModalLabel">Thêm mới sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addProductForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="newProductCode" class="form-label">Mã sản phẩm</label>
                                    <input type="text" class="form-control" id="newProductCode" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="newProductBarcode" class="form-label">Mã vạch</label>
                                    <input type="text" class="form-control" id="newProductBarcode">
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="newProductName" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="newProductName" required>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="newProductCategory" class="form-label">Nhóm hàng</label>
                                    <select class="form-select" id="newProductCategory">
                                        <option value="">Chọn nhóm hàng</option>
                                        <option value="Đồ chơi trẻ em">Đồ chơi trẻ em</option>
                                        <option value="Đồ chơi giáo dục">Đồ chơi giáo dục</option>
                                        <option value="Đồ chơi mô hình">Đồ chơi mô hình</option>
                                        <option value="Đồ chơi điện tử">Đồ chơi điện tử</option>
                                        <option value="Đồ chơi vận động">Đồ chơi vận động</option>
                                        <option value="Đồ chơi xếp hình">Đồ chơi xếp hình</option>
                                        <option value="Đồ chơi nghệ thuật">Đồ chơi nghệ thuật</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="newProductSupplier" class="form-label">Nhà cung cấp</label>
                                    <select class="form-select" id="newProductSupplier">
                                        <option value="">Chọn nhà cung cấp</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="newProductPrice" class="form-label">Giá bán <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="newProductPrice" required>
                                        <span class="input-group-text">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="newProductCost" class="form-label">Giá vốn <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="newProductCost" required>
                                        <span class="input-group-text">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="newProductStock" class="form-label">Tồn kho <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="newProductStock" required>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="newProductDescription" class="form-label">Mô tả sản phẩm</label>
                                    <textarea class="form-control" id="newProductDescription" rows="3"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="newProductOrderNote" class="form-label">Ghi chú đặt hàng</label>
                                    <textarea class="form-control" id="newProductOrderNote" rows="2"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-12">
                                <label class="form-label">Hình ảnh sản phẩm</label>
                                <div class="product-images" id="newProductImages">
                                    <div class="image-upload-placeholder" onclick="addNewProductImage()">
                                        <i class="bi bi-plus-lg fs-3 text-primary"></i>
                                        <span class="ms-2">Thêm ảnh</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="newProductStatus" checked>
                                    <label class="form-check-label" for="newProductStatus">Đang kinh doanh</label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-success" onclick="addProduct()">Thêm</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Thêm input file ẩn vào HTML -->
    <input type="file" id="importFile" accept=".csv" style="display:none" onchange="handleImport(event)">

</main><!-- End #main -->
<script src="assets/js/pro.js"></script>
