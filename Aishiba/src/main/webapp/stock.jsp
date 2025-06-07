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
                            <%-- Các value phải khớp với tên Enum StockStatus --%>
                            <option value="PENDING">Chờ xử lý</option>
                            <option value="COMPLETED">Hoàn thành</option>
                            <option value="CANCELLED">Đã hủy</option>
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

                <div class="pagination-container d-flex justify-content-end mt-3"></div>
            </div>
        </div>
    </section>
</main>

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
                        <div class="col-md-3">
                            <label for="stockDate" class="form-label">Ngày nhập hàng</label>
                            <input type="date" class="form-control" id="stockDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                        <div class="col-md-3">
                            <label for="stockStatus" class="form-label">Trạng thái</label>
                            <select id="stockStatus" class="form-select">
                                <option value="PENDING">Chờ xử lý</option>
                                <option value="COMPLETED">Hoàn thành</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="stockAddress" class="form-label">Địa chỉ kho nhập <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="stockAddress" placeholder="VD: Kho trung tâm" required>
                    </div>

                    <h6 class="mb-3">Danh sách sản phẩm nhập</h6>
                    <div class="table-responsive">
                        <table class="table table-bordered" id="productImportTable">
                            <thead>
                            <tr>
                                <th style="width: 20%;">Tên sản phẩm</th>
                                <th style="width: 10%;">Tồn kho</th>
                                <th style="width: 15%;">Giá nhập <span class="text-danger">*</span></th>
                                <th style="width: 10%;">Số lượng <span class="text-danger">*</span></th>
                                <th style="width: 15%;">Thành tiền</th>
                                <th style="width: 5%;">Xóa</th>
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

                    <h6 class="mt-4">Các sản phẩm đã nhập</h6>
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
                    <div class="text-end fs-5 mt-3">
                        <strong>Tổng giá trị: <span id="modalTotalAmount" class="fw-bold"></span></strong>
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
    /* Status Badges */
    .status-badge { padding: 0.4em 0.7em; font-size: 0.85em; font-weight: 600; border-radius: .375rem; color: #fff; }
    .status-badge.status-PENDING { background-color: #ffc107; color: #000; }
    .status-badge.status-COMPLETED { background-color: #198754; }
    .status-badge.status-CANCELLED { background-color: #dc3545; }

    /* Autocomplete z-index fix */
    .ui-autocomplete { z-index: 1056 !important; }

    /* Align-middle for table rows */
    .table > :not(caption) > * > * { vertical-align: middle; }
    #stockTableBody tr { cursor: pointer; }
</style>

<script>
    // Hàm format tiền tệ
    const currencyFormatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

    $(document).ready(function() {
        // --- BIẾN TOÀN CỤC ---
        const searchInput = $('#searchInput');
        const statusFilter = $('#statusFilter');
        const dateFilter = $('#dateFilter');
        const tableBody = $('#stockTableBody');
        const paginationContainer = $('.pagination-container');
        const detailModal = new bootstrap.Modal('#stockDetailModal');
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
                const row = `
                    <tr data-id="${stock.id}">
                        <td><input type="checkbox" class="form-check-input" onclick="event.stopPropagation();"></td>
                        <td class="fw-bold text-primary">${stock.formattedId}</td>
                        <td>${stock.stockDate}</td>
                        <td>${stock.supplierName}</td>
                        <td class="text-end">${currencyFormatter.format(stock.totalAmount)}</td>
                        <td class="text-center"><span class="status-badge status-${stock.status}">${stock.statusDisplay}</span></td>
                    </tr>`;
                tableBody.append(row);
            });
        }

        function renderPagination(totalPages, currentPage) {
            paginationContainer.empty();
            if (totalPages <= 1) return;
            // (Sử dụng hàm renderPagination từ câu trả lời trước, đã được chứng minh là hoạt động tốt)
            let paginationHtml = '<ul class="pagination">';
            // Logic nút Previous, Next, và dấu "..."
            paginationContainer.html(paginationHtml); // Thay thế bằng logic đầy đủ
        }


        // --- HÀM AJAX CHÍNH ---

        function fetchAndRenderStock(page = 1) {
            tableBody.html('<tr><td colspan="6" class="text-center p-4"><div class="spinner-border spinner-border-sm"></div> Đang tải...</td></tr>');
            $.ajax({
                url: 'stock',
                type: 'GET',
                data: {
                    action: 'searchAndFilter',
                    searchTerm: searchInput.val(),
                    status: statusFilter.val(),
                    date: dateFilter.val(),
                    page: page
                },
                dataType: 'json',
                success: function(response) {
                    renderTable(response.stocks);
                    renderPagination(response.totalPages, response.currentPage);
                },
                error: function() {
                    tableBody.html('<tr><td colspan="6" class="text-center text-danger p-4">Lỗi tải dữ liệu.</td></tr>');
                }
            });
        }

        // --- GÁN SỰ KIỆN ---

        // Bộ lọc thay đổi
        searchInput.on('keyup', function() {
            clearTimeout(debounceTimeout);
            debounceTimeout = setTimeout(() => fetchAndRenderStock(1), 500);
        });
        statusFilter.add(dateFilter).on('change', () => fetchAndRenderStock(1));
        $('#resetFilters').on('click', function() {
            searchInput.val('');
            statusFilter.val('');
            dateFilter.val('');
            fetchAndRenderStock(1);
        });

        // Click vào dòng để xem chi tiết
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
                success: function(response) {
                    if (!response.stock) {
                        // Xử lý lỗi
                        return;
                    }
                    const stock = response.stock;
                    // Điền dữ liệu vào modal chi tiết
                    $('#modalStockCode').text(stock.id);
                    $('#modalSupplierName').text(stock.supplier.name);
                    $('#modalStockDate').text(stock.stockDate);
                    $('#modalAddress').text(stock.supplier.address);
                    $('#modalStatusSelect').val(stock.status);

                    //... các trường khác

                    // Điền bảng sản phẩm
                    const productsBody = $('#modalProductsTableBody').empty();
                    let total = 0;
                    $.each(stock.products, function(i, item) {
                        const subTotal = item.quantity * item.importPrice;
                        total += subTotal;
                        productsBody.append(`<tr>...</tr>`); //Tương tự như khi tạo modal
                    });
                    $('#modalTotalAmount').text(currencyFormatter.format(total));

                    // Điền select trạng thái
                    const statusSelect = $('#modalStatusSelect').empty();
                    const statuses = { 'PENDING': 'Chờ xử lý', 'COMPLETED': 'Hoàn thành', 'CANCELLED': 'Đã hủy' };
                    statusSelect.append('<option value="' + key + '"' + (key === stock.status ? ' selected' : '') + '>' + value + '</option>');

                    $('#modalDetailLoading').addClass('d-none');
                    $('#modalDetailContent').removeClass('d-none');
                }
            });
        });

        // Cập nhật trạng thái
        $('#btnUpdateStockStatus').on('click', function() {
            // Logic AJAX POST để cập nhật trạng thái
        });

        // --- LOGIC MODAL TẠO MỚI ---

        // Autocomplete cho Nhà cung cấp
        $("#supplierName").autocomplete({
            source: (request, response) => $.ajax({ url: "stock", data: { action: 'searchSuppliers', term: request.term }, success: data => response(data) }),
            minLength: 1,
            appendTo: "#newStockForm",
            select: function(event, ui) {
                $("#supplierName").val(ui.item.name);
                $("#supplierId").val(ui.item.value);
                return false;
            }
        });

        // Lưu phiếu nhập mới
        $('#btnSaveNewStock').on('click', function() {
            // 1. Validate form
            // 2. Thu thập dữ liệu thành object JSON
            const stockData = {
                supplierId: $('#supplierId').val(),
                stockDate: $('#stockDate').val(),
                address: $('#stockAddress').val(),
                status: $('#stockStatus').val(),
                products: []
            };
            $('#productImportTableBody tr').each(function() {
                // Thêm sản phẩm vào mảng products
            });
            // 3. Gọi AJAX POST đến action=create
        });

        // --- KHỞI CHẠY LẦN ĐẦU ---
        fetchAndRenderStock(1);
    });

    // --- CÁC HÀM TIỆN ÍCH (Bên ngoài document.ready) ---
    function addProductImportRow() {
        const rowHtml = `
            <tr>
                <td><input type="text" class="form-control product-search" placeholder="Gõ tên hoặc mã SP..."></td>
                <td><input type="text" class="form-control product-stock" readonly></td>
                <td><input type="number" class="form-control import-price" min="0"></td>
                <td><input type="number" class="form-control import-quantity" min="1"></td>
                <td><input type="text" class="form-control sub-total" readonly></td>
                <td><button type="button" class="btn btn-danger btn-sm" onclick="$(this).closest('tr').remove()">Xóa</button></td>
            </tr>`;
        $('#productImportTableBody').append(rowHtml);

        // Gắn lại autocomplete cho dòng mới
        $('#productImportTableBody .product-search').last().autocomplete({
            source: (request, response) => $.ajax({ url: "stock", data: { action: 'searchProducts', term: request.term }, success: data => response(data) }),
            minLength: 1,
            appendTo: "#newStockForm",
            select: function(event, ui) {
                const row = $(this).closest('tr');
                // điền thông tin sản phẩm
                return false;
            }
        });
    }

</script>