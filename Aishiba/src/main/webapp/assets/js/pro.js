// ================== SẢN PHẨM MẪU ==================

        // Tạo HTML cho dòng sản phẩm
        function createProductRow(product, index) {
        return `<tr onclick="showProductDetailByRow(this, ${index})">
            <td>
            <div class="form-check" onclick="event.stopPropagation()">
                <input type="checkbox"
                class="form-check-input product-checkbox"
                \${product.checked ? 'checked' : ''}
                onchange="toggleProductSelection(event, ${index})"
                title="Chọn sản phẩm này">
            </div>
            </td>
            <td><i class="bi \${product.star ? 'bi-star-fill' : 'bi-star'} star-outline text-warning" onclick="toggleStar(event, ${index})" title="Đánh dấu sản phẩm"></i></td>
            <td>\${product.code}</td>
            <td>\${product.name}</td>
            <td class="text-end">\${formatCurrency(product.price)}</td>
            <td class="text-end">\${formatCurrency(product.cost)}</td>
            <td class="text-end">\${formatCurrency(product.stock)}</td>
            <td class="text-center"><span class="badge \${product.stock > 0 ? 'bg-success' : 'bg-danger'}">\${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}</span></td>
            <td class="text-center"><span class="badge \${product.stock <= 0 ? 'bg-danger' : (product.business.includes('Kinh doanh') ? 'bg-success' : 'bg-danger')}">\${product.stock <= 0 ? 'Ngừng KD' : (product.business.includes('Kinh doanh') ? 'Kinh doanh' : 'Ngừng KD')}</span></td>
            <td>\${product.created}</td>
        </tr>`;
    }
        // Tạo HTML cho dòng chi tiết
        function createProductDetailRow(product, products) {
        const images = product.images || [];
        const productIndex = products.indexOf(product);

        const imageGrid = `
        <div class="product-images">
            ${images.slice(0, 4).map((img, index) => `
            <div class="product-image-item position-relative">
                <img src="${img}" alt="${product.name} - Ảnh ${index + 1}" class="img-fluid">
                <button class="remove-image btn btn-sm btn-danger position-absolute top-0 end-0" 
                onclick="removeProductImage(${productIndex}, ${index})" type="button" aria-label="Xóa ảnh">
                <i class="bi bi-x"></i>
                </button>
            </div>
            `).join('')}
            ${images.length < 4 ? `
            <div class="image-upload-placeholder d-flex justify-content-center align-items-center border border-primary rounded" 
                style="cursor:pointer; height: 100px;"
                onclick="addProductImage(${productIndex})" title="Thêm ảnh sản phẩm">
                <i class="bi bi-plus-lg fs-3 text-primary"></i>
            </div>
            ` : ''}
        </div>`;

        return `
        <tr class="product-detail-row">
            <td colspan="10">
            <div class="product-detail-content">
                <div class="row">
                <div class="col-md-4">
                    ${images.length > 0 ? imageGrid : `
                    <div class="product-images">
                        <div class="image-upload-placeholder d-flex justify-content-center align-items-center border border-primary rounded"
                        style="cursor:pointer; height: 100px;"
                        onclick="addProductImage(${productIndex})" title="Thêm ảnh sản phẩm">
                        <i class="bi bi-plus-lg fs-3 text-primary"></i>
                        <span class="ms-2">Thêm ảnh</span>
                        </div>
                    </div>
                    `}
                </div>
                <div class="col-md-8">
                    <div class="row">
                    <div class="col-md-6">
                        <div class="detail-section">
                        <h5><i class="bi bi-info-circle me-2"></i>Thông tin cơ bản</h5>
                        <div class="mb-3">
                            <div class="detail-label">Mã hàng</div>
                            <div class="detail-value">${product.code}</div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">Mã vạch</div>
                            <div class="detail-value">${product.barcode || (product.code + 'BAR')}</div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">Nhóm hàng</div>
                            <div class="detail-value">${product.category || 'Chưa phân loại'}</div>
                        </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-section">
                        <h5><i class="bi bi-currency-dollar me-2"></i>Thông tin giá</h5>
                        <div class="mb-3">
                            <div class="detail-label">Giá bán</div>
                            <div class="detail-value text-success fw-bold text-end">${formatCurrency(product.price)}</div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">Giá vốn</div>
                            <div class="detail-value text-danger text-end">${formatCurrency(product.cost)}</div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">Tồn kho</div>
                            <div class="detail-value">${product.stock} đơn vị</div>
                        </div>
                        </div>
                    </div>
                    </div>

                    <div class="detail-section mt-3">
                    <h5><i class="bi bi-card-text me-2"></i>Thông tin bổ sung</h5>
                    <div class="mb-3">
                        <div class="detail-label">Mô tả sản phẩm</div>
                        <div class="detail-value">${product.description || 'Chưa có mô tả'}</div>
                    </div>
                    <div class="mb-3">
                        <div class="detail-label">Nhà cung cấp</div>
                        <div class="detail-value">${product.supplier || 'Chưa có thông tin'}</div>
                    </div>
                    <div class="mb-3">
                        <div class="detail-label">Ngày tạo</div>
                        <div class="detail-value">${product.created}</div>
                    </div>
                    </div>

                    <div class="btn-group mt-3" role="group" aria-label="Các thao tác với sản phẩm">
                    <button class="btn btn-success" onclick="editProductDetail(${productIndex})" type="button">
                        <i class="bi bi-pencil me-1"></i> Sửa
                    </button>
                    <button class="btn btn-secondary" onclick="printProductLabel(${productIndex})" type="button">
                        <i class="bi bi-printer me-1"></i> In tem mã
                    </button>
                    <button class="btn btn-info text-white" onclick="copyProductDetail(${productIndex})" type="button">
                        <i class="bi bi-clipboard me-1"></i> Sao chép
                    </button>
                    <button class="btn btn-warning" onclick="toggleBusinessStatus(${productIndex})" type="button">
                        <i class="bi bi-lock me-1"></i> ${product.business.includes('Ngừng') ? 'Mở bán lại' : 'Ngừng kinh doanh'}
                    </button>
                    <button class="btn btn-danger" onclick="deleteProductDetail(${productIndex})" type="button">
                        <i class="bi bi-trash me-1"></i> Xóa
                    </button>
                    </div>

                </div>
                </div>
            </div>
            </td>
        </tr>`;
        }

        // Render lại toàn bộ bảng sản phẩm và chi tiết
    function renderProductTable() {
        const tbody = document.querySelector('#productTable tbody');
        if (!tbody) return;
        tbody.innerHTML = '';
        products.forEach((product, idx) => {
            tbody.insertAdjacentHTML('beforeend', createProductRow(product, idx));
        });
        updateSelectAllCheckbox && updateSelectAllCheckbox();
        updateActionButtonsState && updateActionButtonsState();
        updateSelectAllStars && updateSelectAllStars();
    }
        // Cập nhật trạng thái selectAll checkbox
    function updateSelectAllCheckbox() {
        const selectAll = document.getElementById('selectAll');
        if (!selectAll || !Array.isArray(products)) return;

        const checkedProducts = products.filter(p => p.checked);
        selectAll.checked = checkedProducts.length === products.length && products.length > 0;
        selectAll.indeterminate = checkedProducts.length > 0 && checkedProducts.length < products.length;
    }

    // Cập nhật trạng thái selectAllStars (icon star ở header)
    function updateSelectAllStars() {
        const headerStar = document.getElementById('selectAllStars');
        if (!headerStar || !Array.isArray(products)) return;

        const allStarred = products.length > 0 && products.every(p => p.star);
        headerStar.classList.remove('bi-star-fill', 'bi-star');
        headerStar.classList.add(allStarred ? 'bi-star-fill' : 'bi-star');
    }

    // Chọn hoặc bỏ chọn tất cả star
    function toggleSelectAllStars() {
        const headerStar = document.getElementById('selectAllStars');
        if (!headerStar || !Array.isArray(products)) return;

        const allStarred = products.length > 0 && products.every(p => p.star);
        const newStarState = !allStarred;

        products.forEach(p => p.star = newStarState);
        renderProductTable();
    }

    // Toggle star cho 1 sản phẩm
    function toggleStar(event, idx) {
        event.stopPropagation();
        event.preventDefault(); // tránh các hành động mặc định nếu có

        if (!Array.isArray(products)) return;
        if (idx >= 0 && idx < products.length) {
            products[idx].star = !products[idx].star;
            renderProductTable();
        }
    }

        function addProduct() {
        const name = document.getElementById('newProductName').value.trim();
        const priceStr = document.getElementById('newProductPrice').value.trim();
        const costStr = document.getElementById('newProductCost').value.trim();
        const stockStr = document.getElementById('newProductStock').value.trim();
        const description = document.getElementById('newProductDescription').value.trim();
        const barcode = document.getElementById('newProductBarcode').value.trim();
        const category = document.getElementById('newProductCategory').value;
        const supplier = document.getElementById('newProductSupplier').value;
        const orderNote = document.getElementById('newProductOrderNote').value.trim();
        const isActive = document.getElementById('newProductStatus').checked;

        // Validate dữ liệu bắt buộc
        if (!name || !priceStr || !costStr || !stockStr) {
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }

        // Parse số và kiểm tra hợp lệ
        const priceNum = parseInt(priceStr, 10);
        const costNum = parseInt(costStr, 10);
        const stockNum = parseInt(stockStr, 10);

        if (isNaN(priceNum) || isNaN(costNum) || isNaN(stockNum)) {
            alert('Giá, giá vốn và tồn kho phải là số hợp lệ!');
            return;
        }

        // Lấy ảnh sản phẩm
        const imageElements = document.querySelectorAll('#newProductImages .product-image-item img');
        const images = Array.from(imageElements).map(img => img.src);

        // Tạo mã sản phẩm mới duy nhất
        const newCode = "SP" + Math.floor(Math.random() * 1000000).toString().padStart(6, '0');

        // Tạo đối tượng sản phẩm mới
        const newProduct = {
            code: newCode,
            name,
            price: priceNum,
            cost: costNum,
            stock: stockNum,
            barcode,
            category,
            supplier,
            description,
            orderNote,
            status: stockNum > 0, // true nếu còn hàng
            business: stockNum <= 0 ? 'Ngừng KD' : (isActive ? 'Kinh doanh' : 'Ngừng KD'),
            created: new Date().toLocaleDateString('vi-VN') + " " + new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }),
            star: false,
            images: images,
            checked: false
        };

        if (!Array.isArray(products)) {
            products = [];
        }
        products.unshift(newProduct);
        renderProductTable();

        // Đóng modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('addProductModal'));
        if (modal) {
            modal.hide();
        }

        // Reset form
        const form = document.getElementById('addProductForm');
        if (form) form.reset();

        // Xóa ảnh đã thêm (ngoại trừ placeholder)
        const imagesContainer = document.getElementById('newProductImages');
        if (imagesContainer) {
            const placeholder = imagesContainer.querySelector('.image-upload-placeholder');
            Array.from(imagesContainer.children).forEach(child => {
                if (child !== placeholder) {
                    child.remove();
                }
            });
            if (placeholder) placeholder.style.display = 'block';
        }

        // Cập nhật lại mã sản phẩm trong form (nếu có input hiển thị mã)
        const codeInput = document.getElementById('newProductCode');
        if (codeInput) {
            codeInput.value = "SP" + Math.floor(Math.random() * 1000000).toString().padStart(6, '0');
        }

        alert('Đã thêm sản phẩm mới thành công!');
    }

    // Hàm showProductDetailByRow cần hoàn thiện hoặc xem lại nếu có lỗi
    function showProductDetailByRow(row, idx) {
        // Nếu đã mở chi tiết thì ẩn, nếu chưa thì hiển thị
        if (!products || idx < 0 || idx >= products.length) return;

        const detailRow = row.nextElementSibling;
        if (detailRow && detailRow.classList.contains('product-detail-row')) {
            // Toggle ẩn/hiện
            if (detailRow.style.display === 'table-row') {
                detailRow.style.display = 'none';
            } else {
                detailRow.style.display = 'table-row';
            }
        }
    }
        // Khai báo biến global quản lý chi tiết đang mở
    let currentProduct = null;
    let currentDetailRow = null;

    // Hàm show/ẩn chi tiết sản phẩm khi click
    function showProductDetailByRow(row, idx) {
        if (!products || idx < 0 || idx >= products.length) return;
        const detailRow = row.nextElementSibling;

        // Nếu đang hiển thị chi tiết của hàng này, đóng lại
        if (detailRow && detailRow.classList.contains('show')) {
            detailRow.classList.remove('show');
            row.classList.remove('selected-row');
            setTimeout(() => {
                if (!detailRow.classList.contains('show')) {
                    detailRow.style.display = 'none';
                }
            }, 300);
            currentProduct = null;
            currentDetailRow = null;
            return;
        }

        // Ẩn tất cả chi tiết và bỏ chọn các hàng
        document.querySelectorAll('.product-detail-row').forEach(r => {
            r.classList.remove('show');
            setTimeout(() => {
                if (!r.classList.contains('show')) r.style.display = 'none';
            }, 300);
        });
        document.querySelectorAll('tbody tr').forEach(r => r.classList.remove('selected-row'));

        // Hiện chi tiết hàng được chọn
        if (detailRow && detailRow.classList.contains('product-detail-row')) {
            detailRow.style.display = 'table-row';
            detailRow.offsetHeight; // reflow
            detailRow.classList.add('show');
            row.classList.add('selected-row');
            currentProduct = products[idx];
            currentDetailRow = detailRow;
        }
    }

    function editProductDetail(idx) {
        updateEditModalSelects().then(() => {
            const p = products[idx];
            document.getElementById('editProductCode').value = p.code;
            document.getElementById('editProductBarcode').value = p.barcode || '';
            document.getElementById('editProductName').value = p.name;
            document.getElementById('editProductCategory').value = p.category || '';
            document.getElementById('editProductSupplier').value = p.supplier || '';
            document.getElementById('editProductPrice').value = p.price.toString();
            document.getElementById('editProductCost').value = p.cost.toString();
            document.getElementById('editProductStock').value = p.stock;
            document.getElementById('editProductDescription').value = p.description || '';
            document.getElementById('editProductOrderNote').value = p.orderNote || '';

            const businessStatusSwitch = document.getElementById('editProductStatus');
            businessStatusSwitch.checked = p.business === true;  // business lưu boolean
            businessStatusSwitch.disabled = p.stock <= 0;

            document.getElementById('editProductModal').setAttribute('data-edit-idx', idx);
            const modal = new bootstrap.Modal(document.getElementById('editProductModal'));
            modal.show();
        });
    }

    function saveProductChanges() {
        const idx = +document.getElementById('editProductModal').getAttribute('data-edit-idx');
        if (isNaN(idx)) return;

        const product = products[idx];
        product.barcode = document.getElementById('editProductBarcode').value.trim();
        product.name = document.getElementById('editProductName').value.trim();
        product.category = document.getElementById('editProductCategory').value;
        product.supplier = document.getElementById('editProductSupplier').value;
        product.price = parseInt(document.getElementById('editProductPrice').value) || 0;
        product.cost = parseInt(document.getElementById('editProductCost').value) || 0;
        const newStock = parseInt(document.getElementById('editProductStock').value) || 0;
        product.stock = newStock;

        product.status = newStock > 0; // true nếu còn hàng, false hết hàng
        if (newStock <= 0) {
            product.business = false; // ngừng KD
            document.getElementById('editProductStatus').disabled = true;
        } else {
            document.getElementById('editProductStatus').disabled = false;
            const isActive = document.getElementById('editProductStatus').checked;
            product.business = isActive;
        }

        product.description = document.getElementById('editProductDescription').value.trim();
        product.orderNote = document.getElementById('editProductOrderNote').value.trim();

        renderProductTable();
        const modal = bootstrap.Modal.getInstance(document.getElementById('editProductModal'));
        if (modal) modal.hide();
        alert('Đã cập nhật thông tin sản phẩm!');
    }

    function deleteProductDetail(idx) {
        if (!confirm('Xóa sản phẩm này?')) return;
        products.splice(idx, 1);
        renderProductTable();
        alert('Đã xóa sản phẩm!');
    }

    function printProductLabel(idx) {
        alert('In tem mã cho: ' + products[idx].name + '\nMã: ' + products[idx].code);
    }

    function copyProductDetail(idx) {
        const p = products[idx];
        const text = `Tên: ${p.name}\nMã: ${p.code}\nGiá bán: ${p.price}\nTồn kho: ${p.stock}\nMô tả: ${p.description}`;
        navigator.clipboard.writeText(text.trim());
        alert('Đã sao chép thông tin sản phẩm!');
    }

    function toggleBusinessStatus(idx) {
        const product = products[idx];
        if (product.stock <= 0) {
            alert('Sản phẩm hết hàng, không thể thay đổi trạng thái kinh doanh!');
            return;
        }
        product.business = !product.business;
        renderProductTable();
        alert(product.business ? 'Đã mở lại kinh doanh cho sản phẩm!' : 'Đã ngừng kinh doanh sản phẩm!');
    }

    function addProductImage(productIndex) {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/*';
        input.onchange = function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    if (!products[productIndex].images) {
                        products[productIndex].images = [];
                    }
                    if (products[productIndex].images.length < 4) {
                        products[productIndex].images.push(e.target.result);
                        renderProductTable();
                    } else {
                        alert('Chỉ được phép thêm tối đa 4 ảnh!');
                    }
                };
                reader.readAsDataURL(file);
            }
        };
        input.click();
    }

    function removeProductImage(productIndex, imageIndex) {
        if (!confirm('Bạn có chắc muốn xóa ảnh này?')) return;
        const images = products[productIndex].images;
        if (images && images.length > imageIndex) {
            images.splice(imageIndex, 1);
            if (images.length === 0) {
                delete products[productIndex].images;
            }
            renderProductTable();
        }
    }

        // Hàm load danh sách nhà cung cấp từ supplier.html
    async function loadSuppliers() {
        try {
            const response = await fetch('supplier.html');
            const html = await response.text();
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const suppliers = [];
            doc.querySelectorAll('table tbody tr').forEach(row => {
                const code = row.cells[2]?.textContent.trim();
                const name = row.cells[3]?.textContent.trim();
                if (code && name) {
                    suppliers.push({ code, name });
                }
            });
            return suppliers;
        } catch (error) {
            console.error('Không thể tải danh sách nhà cung cấp:', error);
            return [];
        }
    }

    // Cập nhật select nhóm hàng và nhà cung cấp trong modal chỉnh sửa
    async function updateEditModalSelects() {
        // Nhóm hàng
        const categorySelect = document.getElementById('editProductCategory');
        categorySelect.innerHTML = `
            <option value="">Chọn nhóm hàng</option>
            <option value="Đồ chơi trẻ em">Đồ chơi trẻ em</option>
            <option value="Đồ chơi giáo dục">Đồ chơi giáo dục</option>
            <option value="Đồ chơi mô hình">Đồ chơi mô hình</option>
            <option value="Đồ chơi điện tử">Đồ chơi điện tử</option>
            <option value="Đồ chơi vận động">Đồ chơi vận động</option>
            <option value="Đồ chơi xếp hình">Đồ chơi xếp hình</option>
            <option value="Đồ chơi nghệ thuật">Đồ chơi nghệ thuật</option>
        `;

        // Nhà cung cấp
        const supplierSelect = document.getElementById('editProductSupplier');
        const suppliers = await loadSuppliers();
        supplierSelect.innerHTML = '<option value="">Chọn nhà cung cấp</option>' +
            suppliers.map(s => `<option value="${s.code}">${s.name}</option>`).join('');
    }

    // Chuyển đổi ngày từ dd/mm/yyyy sang yyyy-mm-dd
    function convertDateFormat(dateStr) {
        if (!dateStr) return '';
        const parts = dateStr.split('/');
        if (parts.length === 3) {
            return `${parts[2].split(' ')[0]}-${parts[1].padStart(2, '0')}-${parts[0].padStart(2, '0')}`;
        }
        return dateStr;
    }

    // So sánh ngày nằm trong khoảng startDate và endDate
    function isDateInRange(dateStr, startDate, endDate) {
        if (!dateStr) return false;
        const productDate = convertDateFormat(dateStr.split(' ')[0]);
        if (!startDate && !endDate) return true;
        if (startDate && !endDate) return productDate >= startDate;
        if (!startDate && endDate) return productDate <= endDate;
        return productDate >= startDate && productDate <= endDate;
    }

    // Hàm lọc sản phẩm theo nhiều tiêu chí
    function filterProducts() {
        const searchText = document.getElementById('searchInput').value.toLowerCase();
        const category = document.getElementById('filterCategory').value;
        const status = document.getElementById('filterStatus').value;
        const startDate = document.getElementById('filterStartDate').value;
        const endDate = document.getElementById('filterEndDate').value;

        const filteredProducts = products.filter(product => {
            const matchSearch = !searchText ||
                product.code.toLowerCase().includes(searchText) ||
                product.name.toLowerCase().includes(searchText);

            const matchCategory = !category ||
                (product.category && product.category.includes(category));

            const matchStatus = !status ||
                (status === 'Còn hàng' && product.stock > 0) ||
                (status === 'Hết hàng' && product.stock <= 0);

            const matchDate = isDateInRange(product.created, startDate, endDate);

            return matchSearch && matchCategory && matchStatus && matchDate;
        });

        const tbody = document.querySelector('tbody');
        tbody.innerHTML = '';
        filteredProducts.forEach((product) => {
            const originalIndex = products.indexOf(product);
            tbody.insertAdjacentHTML('beforeend', createProductRow(product, originalIndex));
            tbody.insertAdjacentHTML('beforeend', createProductDetailRow(product));
        });

        updateSelectAllCheckbox();
        updateActionButtonsState();
        updateSelectAllStars();
    }

    // Các hàm xử lý khoảng thời gian filter nhanh
    function setDateRange(range) {
        const today = new Date();
        let startDate, endDate;
        switch (range) {
            case 'today':
                startDate = endDate = today;
                break;
            case 'yesterday':
                startDate = endDate = new Date(today.getTime() - 86400000);
                break;
            case 'last7Days':
                startDate = new Date(today.getTime() - 7 * 86400000);
                endDate = new Date();
                break;
            case 'last30Days':
                startDate = new Date(today.getTime() - 30 * 86400000);
                endDate = new Date();
                break;
            case 'last90Days':
                startDate = new Date(today.getTime() - 90 * 86400000);
                endDate = new Date();
                break;
            default:
                startDate = endDate = null;
        }

        document.getElementById('filterStartDate').value = startDate ? formatDate(startDate) : '';
        document.getElementById('filterEndDate').value = endDate ? formatDate(endDate) : '';
        filterProducts();
        updateDateRangeButtonText(range);
    }

    function clearDateRange() {
        document.getElementById('filterStartDate').value = '';
        document.getElementById('filterEndDate').value = '';
        document.querySelector('.dropdown-toggle').innerHTML = '<i class="bi bi-calendar3"></i> Thời gian';
        filterProducts();
    }

    function updateDateRangeButtonText(range) {
        const button = document.querySelector('.dropdown-toggle');
        const rangeTexts = {
            'today': 'Hôm nay',
            'yesterday': 'Hôm qua',
            'thisWeek': 'Tuần này',
            'lastWeek': 'Tuần trước',
            'thisMonth': 'Tháng này',
            'lastMonth': 'Tháng trước',
            'last7Days': '7 ngày qua',
            'last30Days': '30 ngày qua',
            'last90Days': '90 ngày qua'
        };
        button.innerHTML = `<i class="bi bi-calendar3"></i> ${rangeTexts[range] || 'Thời gian'}`;
    }

    function formatDate(date) {
        return date.toISOString().split('T')[0];
    }

    // Xử lý thay đổi ngày nhập thủ công
    function handleDateChange() {
        const startDate = document.getElementById('filterStartDate').value;
        const endDate = document.getElementById('filterEndDate').value;

        if (startDate && endDate && startDate > endDate) {
            document.getElementById('filterEndDate').value = startDate;
        }

        if (startDate || endDate) {
            const formatDisplayDate = (dateStr) => {
                if (!dateStr) return '';
                const date = new Date(dateStr);
                return date.toLocaleDateString('vi-VN');
            };

            let buttonText = 'Thời gian: ';
            if (startDate && endDate) {
                buttonText += `${formatDisplayDate(startDate)} - ${formatDisplayDate(endDate)}`;
            } else if (startDate) {
                buttonText += `Từ ${formatDisplayDate(startDate)}`;
            } else {
                buttonText += `Đến ${formatDisplayDate(endDate)}`;
            }
            document.querySelector('.dropdown-toggle').innerHTML = `<i class="bi bi-calendar3"></i> ${buttonText}`;
        } else {
            document.querySelector('.dropdown-toggle').innerHTML = '<i class="bi bi-calendar3"></i> Thời gian';
        }

        filterProducts();
    }

    // Thêm ảnh mới khi thêm sản phẩm
    function addNewProductImage() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/*';
        input.onchange = function (e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const imagesContainer = document.getElementById('newProductImages');
                    const imageCount = imagesContainer.querySelectorAll('.product-image-item').length;

                    if (imageCount < 4) {
                        const imageDiv = document.createElement('div');
                        imageDiv.className = 'product-image-item';
                        imageDiv.innerHTML = `
                            <img src="${e.target.result}" alt="Product Image">
                            <button type="button" class="btn btn-danger btn-sm remove-image-btn">Xóa</button>
                        `;
                        imagesContainer.appendChild(imageDiv);

                        imageDiv.querySelector('.remove-image-btn').onclick = () => {
                            imageDiv.remove();
                        };
                    } else {
                        alert('Chỉ được thêm tối đa 4 ảnh.');
                    }
                };
                reader.readAsDataURL(file);
            }
        };
        input.click();
    }

    // Xử lý import file
    function handleImportFile(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = function (e) {
            try {
                const importedProducts = JSON.parse(e.target.result);
                if (Array.isArray(importedProducts)) {
                    importedProducts.forEach(p => products.push(p));
                    saveProductsToLocalStorage();
                    filterProducts();
                    alert('Import thành công!');
                } else {
                    alert('Dữ liệu import không hợp lệ!');
                }
            } catch (error) {
                alert('Lỗi khi đọc file import!');
            }
        };
        reader.readAsText(file);
    }

    // Xử lý export file
    function handleExportFile() {
        const dataStr = JSON.stringify(products, null, 2);
        const blob = new Blob([dataStr], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'products_export.json';
        a.click();
        URL.revokeObjectURL(url);
    }

    // Hàm cập nhật checkbox "Chọn tất cả"
    function updateSelectAllCheckbox() {
        const allCheckboxes = document.querySelectorAll('.product-checkbox');
        const selectedCheckboxes = document.querySelectorAll('.product-checkbox:checked');
        const selectAll = document.getElementById('selectAllCheckbox');

        selectAll.checked = allCheckboxes.length > 0 && allCheckboxes.length === selectedCheckboxes.length;
        updateActionButtonsState();
    }

    // Cập nhật trạng thái nút xóa / chỉnh sửa theo checkbox được chọn
    function updateActionButtonsState() {
        const selectedCount = document.querySelectorAll('.product-checkbox:checked').length;
        document.getElementById('deleteSelectedBtn').disabled = selectedCount === 0;
        document.getElementById('editSelectedBtn').disabled = selectedCount !== 1;
    }

    // Chọn hoặc bỏ chọn tất cả checkbox sản phẩm
    function toggleSelectAll() {
        const selectAll = document.getElementById('selectAll');
        const checked = selectAll.checked;
        products.forEach(p => p.checked = checked);
        filterProducts(); // hoặc renderProductTable() nếu không dùng filter
    }

    // Xử lý chọn ưa thích (star)
    function toggleFavorite(index) {
        products[index].favorite = !products[index].favorite;
        saveProductsToLocalStorage();
        filterProducts();
    }

    // Cập nhật biểu tượng star khi chọn / bỏ chọn tất cả
    function updateSelectAllStars() {
        const allFavorited = products.every(p => p.favorite);
        const starAll = document.getElementById('starAll');
        starAll.classList.toggle('bi-star-fill', allFavorited);
        starAll.classList.toggle('bi-star', !allFavorited);
    }

    // Chọn hoặc bỏ chọn tất cả yêu thích
    function toggleFavoriteAll() {
        const allFavorited = products.every(p => p.favorite);
        products.forEach(p => p.favorite = !allFavorited);
        saveProductsToLocalStorage();
        filterProducts();
    }

    // Chuyển trạng thái kinh doanh cho sản phẩm được chọn
    function toggleBusinessStatusForSelected() {
        const selectedIndexes = Array.from(document.querySelectorAll('.product-checkbox:checked'))
            .map(cb => parseInt(cb.dataset.index));
        selectedIndexes.forEach(idx => {
            products[idx].businessStatus = !products[idx].businessStatus;
        });
        saveProductsToLocalStorage();
        filterProducts();
    }

    // Xóa sản phẩm được chọn
    function deleteSelectedProducts() {
        const selectedIndexes = Array.from(document.querySelectorAll('.product-checkbox:checked'))
            .map(cb => parseInt(cb.dataset.index));
        if (selectedIndexes.length === 0) {
            alert('Vui lòng chọn ít nhất một sản phẩm để xóa.');
            return;
        }
        if (confirm(`Bạn có chắc chắn muốn xóa ${selectedIndexes.length} sản phẩm?`)) {
            selectedIndexes.sort((a, b) => b - a).forEach(idx => products.splice(idx, 1));
            saveProductsToLocalStorage();
            filterProducts();
        }
    }

    // Hàm khởi tạo các sự kiện
    function initializeEventListeners() {
        document.getElementById('searchInput').addEventListener('input', filterProducts);
        document.getElementById('filterCategory').addEventListener('change', filterProducts);
        document.getElementById('filterStatus').addEventListener('change', filterProducts);
        document.getElementById('filterStartDate').addEventListener('change', handleDateChange);
        document.getElementById('filterEndDate').addEventListener('change', handleDateChange);
        document.getElementById('selectAllCheckbox').addEventListener('change', toggleSelectAll);
        document.getElementById('starAll').addEventListener('click', toggleFavoriteAll);
        document.getElementById('deleteSelectedBtn').addEventListener('click', deleteSelectedProducts);
        document.getElementById('toggleBusinessStatusBtn').addEventListener('click', toggleBusinessStatusForSelected);
        document.getElementById('importFileInput').addEventListener('change', handleImportFile);
        document.getElementById('exportBtn').addEventListener('click', handleExportFile);
        document.getElementById('addProductImageBtn').addEventListener('click', addNewProductImage);

        // Các nút khoảng thời gian filter nhanh
        document.querySelectorAll('.dropdown-menu .dropdown-item').forEach(item => {
            item.addEventListener('click', e => {
                e.preventDefault();
                const range = item.dataset.range;
                if (range) {
                    setDateRange(range);
                }
            });
        });

        document.getElementById('clearDateRangeBtn').addEventListener('click', e => {
            e.preventDefault();
            clearDateRange();
        });
    }

    // Gọi khởi tạo sự kiện và tải danh sách khi trang load
    document.addEventListener('DOMContentLoaded', async () => {
        await updateEditModalSelects();
        initializeEventListeners();
        filterProducts();
    });

    let currentProduct = null;

    function formatCurrency(num) {
        return num != null ? num.toLocaleString('vi-VN') + '₫' : '';
    }

    function createProductRow(product, index) {
        return `<tr>
        <td>
          <div class="form-check">
            <input type="checkbox"
              class="form-check-input product-checkbox"
              ${product.checked ? 'checked' : ''}
              onchange="toggleProductSelection(event, ${index})"
              title="Chọn sản phẩm này">
          </div>
        </td>
        <td><i class="bi ${product.star ? 'bi-star-fill' : 'bi-star'} star-outline text-warning" onclick="toggleStar(event, ${index})" title="Đánh dấu sản phẩm"></i></td>
        <td>${product.code}</td>
        <td>${product.name}</td>
        <td class="text-end">${formatCurrency(product.price)}</td>
        <td class="text-end">${formatCurrency(product.cost)}</td>
        <td class="text-end">${formatCurrency(product.stock)}</td>
        <td class="text-center"><span class="badge ${product.stock > 0 ? 'bg-success' : 'bg-danger'}">${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}</span></td>
        <td class="text-center"><span class="badge ${product.business ? 'bg-success' : 'bg-danger'}">${product.business ? 'Kinh doanh' : 'Ngừng KD'}</span></td>
        <td>${product.created}</td>
      </tr>`;
    }

    function renderProductTable() {
        const tbody = document.querySelector('#productTable tbody');
        if (!tbody) return;
        tbody.innerHTML = '';
        products.forEach((product, idx) => {
            tbody.insertAdjacentHTML('beforeend', createProductRow(product, idx));
        });
    }

    window.toggleProductSelection = function(event, index) {
        event.stopPropagation();
        products[index].checked = event.target.checked;
        renderProductTable();
    };
    window.toggleStar = function(event, idx) {
        event.stopPropagation();
        products[idx].star = !products[idx].star;
        renderProductTable();
    };

    window.toggleSelectAll = function() {
        const selectAll = document.getElementById('selectAll');
        const checked = selectAll.checked;
        products.forEach(p => p.checked = checked);
        renderProductTable();
    };
    window.toggleSelectAllStars = function() {
        const allStarred = products.every(p => p.star);
        products.forEach(p => p.star = !allStarred);
        renderProductTable();
    };

    window.addEventListener('DOMContentLoaded', function () {
        renderProductTable();
    });
