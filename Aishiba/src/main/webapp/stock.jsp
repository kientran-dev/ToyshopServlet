<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Nhập hàng</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="homepage">Trang chủ</a></li>
                <li class="breadcrumb-item">Giao dịch</li>
                <li class="breadcrumb-item active">Nhập hàng</li>
            </ol>
        </nav>
    </div>

    <section class="section">
        <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="card-title fs-4 text-primary mb-0">Danh sách phiếu nhập hàng</h5>
                    <div class="d-flex gap-2">
                        <button class="btn btn-primary d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#newStockModal">
                            <i class="bi bi-plus-lg me-1"></i>
                            Tạo phiếu nhập
                        </button>
                        <button id="btnExportExcel" class="btn btn-success d-flex align-items-center">
                            <i class="bi bi-file-earmark-spreadsheet me-1"></i>
                            Xuất Excel
                        </button>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-9 d-flex gap-2 align-items-center">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control" id="searchInput" placeholder="Tìm theo mã phiếu, tên nhà cung cấp...">
                        </div>
                        <select id="statusFilter" class="form-select" style="width: auto;">
                            <option value="">Tất cả trạng thái</option>
                            <option value="CHO_XU_LY">Chờ xử lý</option>
                            <option value="DA_THANH_TOAN">Đã thanh toán</option>
                            <option value="DANG_GIAO_HANG">Đang giao hàng</option>
                            <option value="DA_HUY">Đã hủy</option>
                        </select>
                        <input type="date" id="dateFilter" class="form-control" style="width: auto;" title="Lọc theo ngày nhập hàng">
                        <button type="button" class="btn btn-secondary" id="resetFilters">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="form-check-input" id="selectAllStock"></th>
                            <th style="width:40px">
                                <i class="bi bi-star header-star text-warning" id="selectAllorderStars" title="Chọn/Bỏ chọn tất cả nổi bật" onclick="toggleSelectAllorderStars()"></i>
                            </th>
                            <th>Mã PN</th>
                            <th>Thời gian</th>
                            <th>Nhà cung cấp</th>
                            <th class="text-end">Tổng tiền nhập</th>
                            <th class="text-center">Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody id="stockTableBody">
                        <tr>
                            <td colspan="6" class="text-center p-4">Đang tải dữ liệu...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-container d-flex justify-content-center mt-3"></div>
            </div>
        </div>
    </section>
</main>

<%--Modal Tạo Phiếu Nhập Mới--%>
<div class="modal fade" id="newStockModal" tabindex="-1" aria-labelledby="newStockModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="newStockModalLabel">Tạo phiếu nhập hàng mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="newStockForm">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierName" class="form-label">Nhà cung cấp <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="supplierName" placeholder="Nhập tên NCC để tìm..." required>
                            <input type="hidden" id="supplierId" name="supplierId">
                        </div>
                        <div class="col-md-6"> <label for="stockDate" class="form-label">Ngày nhập hàng</label>
                            <input type="date" class="form-control" id="stockDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="stockAddress" class="form-label">Địa chỉ kho nhập <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="stockAddress" placeholder="[Sẽ tự động điền khi chọn nhà cung cấp]" required readonly>                    </div>

                    <h6 class="mb-3">Danh sách sản phẩm nhập</h6>
                    <div class="table-responsive">
                        <table class="table table-bordered" id="productImportTable">
                            <thead>
                            <tr>
                                <th style="width: 35%;">Tên sản phẩm</th>
                                <th style="width: 15%;">Số lượng <span class="text-danger">*</span></th>
                                <th style="width: 20%;">Giá nhập <span class="text-danger">*</span></th>
                                <th style="width: 20%;">Thành tiền</th>
                                <th style="width: 10%;">Xóa</th>
                            </tr>
                            </thead>
                            <tbody id="productImportTableBody"></tbody>
                        </table>
                    </div>
                    <button type="button" class="btn btn-outline-primary mt-2" onclick="addProductImportRow()">+ Thêm sản phẩm</button>

                    <div class="mt-4 fs-5 text-end">
                        <strong>Tổng tiền nhập: <span id="totalImportAmount" class="text-danger fw-bold">0</span> VND</strong>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" id="btnSaveNewStock">Lưu phiếu nhập</button>
            </div>
        </div>
    </div>
</div>

<%--Modal Chi tiết Phiếu Nhập--%>
<div class="modal fade" id="stockDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chi tiết phiếu nhập: <span id="modalStockCode" class="text-primary"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="modalDetailLoading" class="text-center"><div class="spinner-border"></div></div>
                <div id="modalDetailContent" class="d-none">
                    <div class="row mb-3">
                        <div class="col-md-6"><p><strong>Nhà cung cấp:</strong> <span id="modalSupplierName"></span></p></div>
                        <div class="col-md-6"><p><strong>Ngày nhập:</strong> <span id="modalstockDate"></span></p></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6"><p><strong>Địa chỉ kho:</strong> <span id="modalAddress"></span></p></div>
                        <div class="col-md-6 d-flex align-items-center gap-2">
                            <strong>Trạng thái:</strong>
                            <select id="modalStatusSelect" class="form-select form-select-sm" style="width: auto;"></select>
                        </div>
                    </div>

                    <h6 class="mt-4" style="font-size: 18px">Các sản phẩm đã nhập</h6>
                    <table class="table table-sm table-bordered">
                        <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th class="text-end">Số lượng</th>
                            <th class="text-end">Giá nhập</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody id="modalProductsTableBody"></tbody>
                    </table>
                    <div class="d-flex justify-content-end gap-4 fs-5 mt-3">
                        <strong>Tổng số lượng: <span id="modalTotalQuantity" class="fw-bold text-primary">0</span></strong>
                        <strong>Tổng giá trị: <span id="modalTotalAmount" class="fw-bold text-danger"></span></strong>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" id="btnUpdateStockStatus">Lưu thay đổi</button>
            </div>
        </div>
    </div>
</div>


<style>
    /*Star*/
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

    /* Style cho select box trong modal chi tiết */
    /* Style cho select box trong modal chi tiết */
    #modalStatusSelect {
        font-weight: 500;
        border: none;
        border-radius: .375rem; /* Thêm bo góc cho đẹp */
        padding-left: 12px;
        padding-right: 12px;
        /* THÊM MỚI: Tăng chiều rộng tối thiểu */
        min-width: 180px;
    }

    /* SỬA LẠI: Thêm !important để đảm bảo màu được áp dụng, ghi đè lên style mặc định */
    #modalStatusSelect.status-bg-CHO_XU_LY { background-color: #6c757d !important; color: white !important; }
    #modalStatusSelect.status-bg-DA_THANH_TOAN { background-color: #0d6efd !important; color: white !important; }
    #modalStatusSelect.status-bg-DANG_GIAO_HANG { background-color: #ffc107 !important; color: black !important; }
    #modalStatusSelect.status-bg-DA_HUY { background-color: #dc3545 !important; color: white !important; }

    /* Thêm style cho các trạng thái o ben ngaoi */
    /* Status Badges */
    .status-badge { padding: 0.4em 0.7em; font-size: 0.85em; font-weight: 600; border-radius: .375rem; color: #fff; }
    .status-badge.status-PENDING { background-color: #ffc107; color: #000; }
    .status-badge.status-COMPLETED { background-color: #198754; }
    .status-badge.status-CANCELLED { background-color: #dc3545; }

    /* Status Badges */
    .status-badge { padding: 0.4em 0.7em; font-size: 0.85em; font-weight: 600; border-radius: .375rem; color: #fff; }

    /* Các màu mới cho trạng thái */
    .status-badge.status-CHO_XU_LY { background-color: #6c757d; } /* Xám */
    .status-badge.status-DA_THANH_TOAN { background-color: #0d6efd; } /* Xanh dương */
    .status-badge.status-DANG_GIAO_HANG { background-color: #ffc107; color: #000; } /* Vàng */
    .status-badge.status-DA_HUY { background-color: #dc3545; } /* Đỏ */

    /* Các style khác của bạn... */
    .ui-autocomplete { z-index: 1056 !important; }
    .table > :not(caption) > * > * { vertical-align: middle; }
    #stockTableBody tr { cursor: pointer; }
</style>

<script>

    // Thêm hàm helper này ở đâu đó bên ngoài $(document).ready()
    function updateStatusSelectColor(selectElement) {
        // Xóa tất cả các class màu cũ
        selectElement.removeClass('status-bg-CHO_XU_LY status-bg-DA_THANH_TOAN status-bg-DANG_GIAO_HANG status-bg-DA_HUY');
        // Thêm class màu mới tương ứng với giá trị được chọn
        selectElement.addClass('status-bg-' + selectElement.val());
    }

    //Star và checkbox
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

    // Hàm format tiền tệ để sử dụng chung
    const currencyFormatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

    // ===================================================================
    //  CÁC HÀM TIỆN ÍCH CHO MODAL TẠO MỚI (để ở ngoài khối ready)
    // ===================================================================
    function addProductImportRow() {
        const rowHtml =
            '<tr>' +
            '<td><input type="text" class="form-control product-search" placeholder="Gõ tên hoặc mã SP..."><input type="hidden" class="product-id"></td>' +
            '<td><input type="number" class="form-control import-quantity" min="1" value="1"></td>' +
            '<td><input type="number" class="form-control import-price" readonly value=""></td>' +
            '<td><input type="text" class="form-control sub-total" readonly value=""></td>' +
            '<td><button type="button" class="btn btn-danger btn-sm" onclick="removeProductImportRow(this)">Xóa</button></td>' +
            '</tr>';
        $('#productImportTableBody').append(rowHtml);
    }

    function removeProductImportRow(button) {
        $(button).closest('tr').remove();
        updateTotalImportAmount();
    }

    function updateTotalImportAmount() {
        let totalAmount = 0;
        $('#productImportTableBody tr').each(function() {
            const row = $(this);
            const quantity = parseFloat(row.find('.import-quantity').val()) || 0;
            const price = parseFloat(row.find('.import-price').val()) || 0;
            totalAmount += quantity * price;
        });
        $('#totalImportAmount').text(currencyFormatter.format(totalAmount));
    }


    // ===================================================================
    //  KHỐI JQUERY CHÍNH
    // ===================================================================
    $(document).ready(function() {
        // --- KHAI BÁO BIẾN ---
        const searchInput = $('#searchInput');
        const statusFilter = $('#statusFilter');
        const dateFilter = $('#dateFilter');
        const tableBody = $('#stockTableBody');
        const paginationContainer = $('.pagination-container');
        const detailModal = new bootstrap.Modal(document.getElementById('stockDetailModal'));
        const newStockModal = new bootstrap.Modal(document.getElementById('newStockModal'));
        let currentStockId = null;
        let debounceTimeout;

        // --- CÁC HÀM RENDER ---
        function renderTable(stocks) {
            tableBody.empty();
            if (!stocks || stocks.length === 0) {
                tableBody.html('<tr><td colspan="6" class="text-center p-4">Không có phiếu nhập nào.</td></tr>');
                return;
            }
            $.each(stocks, function(index, stock) {
                const row =
                    '<tr data-id="' + stock.id + '" style="cursor:pointer;">' +
                    '<td><input type="checkbox" class="form-check-input" onclick="event.stopPropagation();"></td>' +
                    '<td><i class="bi bi-star star-outline" onclick="toggleSupplierStar(this, event)"></i></td>' +
                    '<td class="text-primary">' + stock.formattedId + '</td>' +
                    '<td>' + stock.stockDate + '</td>' +
                    '<td>' + stock.supplierName + '</td>' +
                    '<td class="text-end">' + currencyFormatter.format(stock.totalAmount) + '</td>' +
                    '<td class="text-center"><span class="status-badge status-' + stock.status + '">' + stock.statusDisplay + '</span></td>' +
                    '</tr>';
                tableBody.append(row);
            });
        }

        // HÀM PHÂN TRANG HOÀN CHỈNH
        function renderPagination(totalPages, currentPage) {
            paginationContainer.empty();
            if (totalPages <= 1) return;
            currentPage = parseInt(currentPage);
            let paginationHtml = '<ul class="pagination">';
            paginationHtml += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '"><a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Trước</a></li>';
            let startPage = Math.max(1, currentPage - 2), endPage = Math.min(totalPages, currentPage + 2);
            if (startPage > 1) {
                paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="1">1</a></li>';
                if (startPage > 2) paginationHtml += '<li class="page-item disabled"><span class="page-link">...</span></li>';
            }
            for (let i = startPage; i <= endPage; i++) {
                paginationHtml += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>';
            }
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) paginationHtml += '<li class="page-item disabled"><span class="page-link">...</span></li>';
                paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + totalPages + '">' + totalPages + '</a></li>';
            }
            paginationHtml += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '"><a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Sau</a></li>';
            paginationHtml += '</ul>';
            paginationContainer.html(paginationHtml);
        }

        // --- HÀM AJAX CHÍNH ---
        function fetchAndRenderStock(page = 1) {
            tableBody.html('<tr><td colspan="6" class="text-center p-4"><div class="spinner-border spinner-border-sm"></div> Đang tải...</td></tr>');
            $.ajax({
                url: 'stock',
                type: 'GET',
                data: { action: 'searchAndFilter', searchTerm: searchInput.val(), status: statusFilter.val(), date: dateFilter.val(), page: page },
                dataType: 'json',
                success: function(response) { renderTable(response.stocks); renderPagination(response.totalPages, response.currentPage); },
                error: function() { tableBody.html('<tr><td colspan="6" class="text-center text-danger p-4">Lỗi tải dữ liệu.</td></tr>'); }
            });
        }

        // --- GÁN CÁC SỰ KIỆN ---

        // 1. Lọc và tìm kiếm
        searchInput.on('keyup', () => { clearTimeout(debounceTimeout); debounceTimeout = setTimeout(() => fetchAndRenderStock(1), 500); });
        statusFilter.add(dateFilter).on('change', () => fetchAndRenderStock(1));
        $('#resetFilters').on('click', () => { searchInput.val(''); statusFilter.val(''); dateFilter.val(''); fetchAndRenderStock(1); });

        // 2. Phân trang
        paginationContainer.on('click', '.page-link', function(e) { e.preventDefault(); const page = $(this).data('page'); if(page) fetchAndRenderStock(page); });

        // 3. Click vào dòng để xem chi tiết (HOÀN THIỆN)
// Tìm đến hàm click vào dòng để xem chi tiết
        tableBody.on('click', 'tr', function() {
            currentStockId = $(this).data('id');
            if (!currentStockId) return;

            $('#modalDetailContent').addClass('d-none');
            $('#modalDetailLoading').removeClass('d-none');
            detailModal.show();

            $.ajax({
                url: 'stock',
                type: 'GET',
                data: { action: 'getDetails', id: currentStockId },
                dataType: 'json',

                // THAY THẾ TOÀN BỘ KHỐI SUCCESS BẰNG KHỐI NÀY
                success: function(response) {
                    if (!response.stock) {
                        alert('Không thể tải chi tiết phiếu nhập.');
                        detailModal.hide();
                        return;
                    }
                    const stock = response.stock;

                    // Điền dữ liệu chung vào modal
                    $('#modalStockCode').text(stock.id);
                    $('#modalSupplierName').text(stock.supplier.name);
                    $('#modalstockDate').text(new Date(stock.stockDate).toLocaleString('vi-VN'));
                    $('#modalAddress').text(stock.address);

                    // SỬA LỖI: Luôn gọi .empty() TRƯỚC khi thêm mới để xóa các option cũ
                    const statusSelect = $('#modalStatusSelect').empty();
                    const statuses = { 'CHO_XU_LY': 'Chờ xử lý', 'DA_THANH_TOAN': 'Đã thanh toán', 'DANG_GIAO_HANG': 'Đang giao hàng', 'DA_HUY': 'Đã hủy' };
                    $.each(statuses, (key, value) => {
                        statusSelect.append('<option value="' + key + '"' + (key === stock.status ? ' selected' : '') + '>' + value + '</option>');
                    });
                    // Gọi hàm đổi màu cho select box
                    updateStatusSelectColor(statusSelect);


                    // Điền bảng sản phẩm VÀ TÍNH TỔNG SỐ LƯỢNG
                    const productsBody = $('#modalProductsTableBody').empty();
                    let totalAmount = 0;
                    let totalQuantity = 0; // THÊM MỚI: Biến đếm tổng số lượng

                    $.each(stock.products, function(i, item) {
                        const subTotal = item.quantity * item.importPrice;
                        totalAmount += subTotal;
                        totalQuantity += item.quantity; // THÊM MỚI: Cộng dồn số lượng

                        productsBody.append(
                            '<tr>' +
                            '<td>' + item.name + '</td>' +
                            '<td class="text-end">' + item.quantity + '</td>' +
                            '<td class="text-end">' + currencyFormatter.format(item.importPrice) + '</td>' +
                            '<td class="text-end">' + currencyFormatter.format(subTotal) + '</td>' +
                            '</tr>'
                        );
                    });

                    // Cập nhật giá trị lên giao diện
                    $('#modalTotalQuantity').text(totalQuantity); // THÊM MỚI: Hiển thị tổng số lượng
                    $('#modalTotalAmount').text(currencyFormatter.format(totalAmount));

                    // Hiển thị nội dung
                    $('#modalDetailLoading').addClass('d-none');
                    $('#modalDetailContent').removeClass('d-none');
                },
                error: function() {
                    alert('Lỗi kết nối máy chủ khi lấy chi tiết phiếu nhập.');
                    detailModal.hide();
                }
            });
        });

        // 4. Cập nhật trạng thái (HOÀN THIỆN)
        $('#btnUpdateStockStatus').on('click', function() {
            const newStatus = $('#modalStatusSelect').val();
            if (!currentStockId || !newStatus) return;
            $.ajax({
                url: 'stock?action=updateStatus', type: 'POST', contentType: 'application/json',
                data: JSON.stringify({ stockId: currentStockId, status: newStatus }),
                dataType: 'json',
                success: function(response) {
                    if (response.success) { alert('Cập nhật thành công!'); detailModal.hide(); fetchAndRenderStock(); }
                    else { alert('Lỗi: ' + (response.error || 'Không thể cập nhật.')); }
                },
                error: () => alert('Lỗi kết nối máy chủ.')
            });
        });

        // 5. Logic cho modal tạo mới (HOÀN THIỆN)
        $("#supplierName").autocomplete({
            source: (req, res) => $.ajax({ url: "stock", data: { action: 'searchSuppliers', term: req.term }, dataType: "json", success: data => res(data) }),
            minLength: 1,
            appendTo: "#newStockForm",
            select: function(event, ui) { // Sửa lại thành function để dễ đọc
                // Điền tên và ID nhà cung cấp
                $("#supplierName").val(ui.item.name);
                $("#supplierId").val(ui.item.value);

                // THÊM DÒNG NÀY: Lấy địa chỉ từ `ui.item` và điền vào ô địa chỉ
                $("#stockAddress").val(ui.item.address);

                return false; // Ngăn không cho autocomplete điền giá trị "label" vào input
            }
        });

        $('#productImportTableBody').on('focus', '.product-search', function() {
            $(this).autocomplete({
                source: (req, res) => $.ajax({ url: "stock", data: { action: 'searchProducts', term: req.term }, dataType: "json", success: data => res(data) }),
                minLength: 1, appendTo: "#newStockForm",
                select: (event, ui) => {
                    const row = $(this).closest('tr');
                    row.find('.product-search').val(ui.item.name);
                    row.find('.product-id').val(ui.item.value);
                    row.find('.import-price').val(ui.item.price).trigger('input'); // Lấy giá bán làm giá nhập tạm thời
                    return false;
                }
            });
        });

        $('#productImportTableBody').on('input', '.import-quantity, .import-price', function() {
            const row = $(this).closest('tr');
            const quantity = parseFloat(row.find('.import-quantity').val()) || 0;
            const price = parseFloat(row.find('.import-price').val()) || 0;
            row.find('.sub-total').val(currencyFormatter.format(quantity * price));
            updateTotalImportAmount();
        });

        $('#btnSaveNewStock').on('click', function() {
            if (!$('#supplierId').val()) { alert('Vui lòng chọn nhà cung cấp.'); return; }
            const products = [];
            let validProducts = true;
            $('#productImportTableBody tr').each(function() {
                const row = $(this);
                const p = { toyId: row.find('.product-id').val(), quantity: parseFloat(row.find('.import-quantity').val()), importPrice: parseFloat(row.find('.import-price').val()) };
                if (!p.toyId || !p.quantity || p.quantity <= 0 || isNaN(p.importPrice)) { validProducts = false; return; }
                products.push(p);
            });
            if (!validProducts || products.length === 0) { alert('Vui lòng thêm ít nhất một sản phẩm hợp lệ.'); return; }

            $.ajax({
                url: 'stock?action=create',
                type: 'POST',
                contentType: 'application/json',
                // Chỉ gửi những dữ liệu mà server cần
                data: JSON.stringify({
                    supplierId: $('#supplierId').val(),
                    stockDate: $('#stockDate').val(),
                    products: products
                }),
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        alert('Tạo phiếu nhập thành công!');
                        // Dùng bootstrap.Modal.getInstance để gọi phương thức hide
                        bootstrap.Modal.getInstance(document.getElementById('newStockModal')).hide();
                        fetchAndRenderStock(1);
                    } else {
                        alert('Lỗi: ' + (response.message || 'Không thể tạo phiếu nhập.'));
                    }
                },
                error: () => alert('Lỗi kết nối khi tạo phiếu nhập.')
            });
        });

        $('#modalStatusSelect').on('change', function() {
            updateStatusSelectColor($(this));
        });
        // --- KHỞI CHẠY LẦN ĐẦU ---
        fetchAndRenderStock(1);
    });
</script>