<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <main id="main" class="main">

                <div class="pagetitle">
                    <h1>Khách hàng đã xóa</h1>
                    <nav>
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="homepage">Trang chủ</a></li>
                            <li class="breadcrumb-item">Khách hàng</li>
                            <li class="breadcrumb-item active">Khách hàng đã xóa</li>
                        </ol>
                    </nav>
                </div><!-- End Page Title -->

                <section class="section dashboard">
                    <div class="row justify-content-center align-items-stretch g-4">
                        <!-- Tổng số khách hàng đã xóa -->
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="stat-modern-card stat-total h-100">
                                <div class="stat-modern-icon-bg">
                                    <i class="bi bi-trash"></i>
                                </div>
                                <div class="stat-modern-content">
                                    <div class="stat-modern-title">Tổng số khách hàng đã xóa</div>
                                    <div class="stat-modern-number" id="stat-total-deleted">${totalDeletedUsers}</div>
                                    <div class="stat-modern-desc">Khách hàng</div>
                                </div>
                            </div>
                        </div>
                        <!-- Khách hàng có thể khôi phục -->
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="stat-modern-card stat-active h-100">
                                <div class="stat-modern-icon-bg">
                                    <i class="bi bi-person-fill-up"></i>
                                </div>
                                <div class="stat-modern-content">
                                    <div class="stat-modern-title">Khách hàng có thể khôi phục</div>
                                    <div class="stat-modern-number" id="stat-recoverable">${totalDeletedUsers}</div>
                                    <div class="stat-modern-desc">Có thể khôi phục</div>
                                </div>
                            </div>
                        </div>
                        <!-- Khách hàng đã xóa vĩnh viễn -->
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="stat-modern-card stat-locked h-100">
                                <div class="stat-modern-icon-bg">
                                    <i class="bi bi-person-slash"></i>
                                </div>
                                <div class="stat-modern-content">
                                    <div class="stat-modern-title">Khách hàng đã xóa vĩnh viễn</div>
                                    <div class="stat-modern-number" id="stat-permanently-deleted">0</div>
                                    <div class="stat-modern-desc">Đã xóa vĩnh viễn</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="section">
                    <div class="row">
                        <div class="col-lg-12">

                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Danh sách khách hàng đã xóa</h5>
                                    <hr>

                                    <!-- Filter Dropdown and Search Bar Wrapper -->
                                    <div
                                        class="table-controls-wrapper d-flex justify-content-end align-items-center mb-3">
                                        <!-- Removed the filter dropdown as it's not directly applicable here unless we filter by deletion date/type -->
                                        <div class="search-bar-container">
                                            <input type="text" class="form-control search-input"
                                                placeholder="Tìm kiếm...">
                                            <button class="btn btn-outline-secondary search-button" type="button"><i
                                                    class="bi bi-search"></i></button>
                                        </div>
                                    </div>

                                    <!-- Table with stripped rows -->
                                    <table class="table datatable">
                                        <thead>
                                            <tr>
                                                <th scope="col" data-sortable="false">Mã khách hàng</th>
                                                <th scope="col" data-sortable="false">Tên khách hàng</th>
                                                <th scope="col" data-sortable="false">Điện thoại</th>
                                                <th scope="col" data-sortable="false">Giới tính</th>
                                                <th scope="col" data-sortable="false">Địa chỉ</th>
                                                <th scope="col" data-sortable="false">Email</th>
                                                <th scope="col" data-sortable="false">Ngày sinh</th>
                                                <th scope="col" data-sortable="false">Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody id="deleted-customer-table-body">
                                            <c:if test="${not empty deletedUserList}">
                                                <c:forEach var="user" items="${deletedUserList}" varStatus="loop">
                                                    <tr data-id="${user.id}">
                                                        <td>${user.getFormattedUserCode()}</td>
                                                        <td>${not empty user.name ? user.name : 'Chưa có'}</td>
                                                        <td>${not empty user.phone ? user.phone : 'Chưa có'}</td>
                                                        <td>${not empty user.gender ? user.gender.displayName : 'Chưa
                                                            có'}</td>
                                                        <td>${not empty user.address ? user.address : 'Chưa có'}</td>
                                                        <td>${not empty user.email ? user.email : 'Chưa có'}</td>
                                                        <td>
                                                            <c:if test="${not empty user.dob}">
                                                                <fmt:formatDate value="${user.dobAsDate}"
                                                                    pattern="yyyy-MM-dd" />
                                                            </c:if>
                                                            <c:if test="${empty user.dob}">
                                                                Chưa có
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <button type="button"
                                                                class="btn btn-success btn-sm restore-customer-btn"
                                                                data-id="${user.id}" title="Khôi phục khách hàng"><i
                                                                    class="bi bi-arrow-clockwise"></i></button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:if>
                                            <c:if test="${empty deletedUserList or deletedUserList.size() == 0}">
                                                <tr>
                                                    <td colspan="8" class="text-center">Không có khách hàng đã xóa nào.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                    <!-- End Table with stripped rows -->

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
                                                    <c:set var="startPage"
                                                        value="${startPage - (endPage - totalPages)}" />
                                                    <c:set var="endPage" value="${totalPages}" />
                                                    <c:if test="${startPage < 1}">
                                                        <c:set var="startPage" value="1" />
                                                    </c:if>
                                                </c:if>

                                                <c:if test="${startPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="account?page=1">1</a>
                                                    </li>
                                                    <c:if test="${startPage > 2}">
                                                        <li class="page-item disabled"><span
                                                                class="page-link">...</span></li>
                                                    </c:if>
                                                </c:if>

                                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                    <li
                                                        class="page-item <c:if test='${currentPage == i}'>active</c:if>">
                                                        <a class="page-link" href="account?page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${endPage < totalPages}">
                                                    <c:if test="${endPage < totalPages - 1}">
                                                        <li class="page-item disabled"><span
                                                                class="page-link">...</span></li>
                                                    </c:if>
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                            href="account?page=${totalPages}">${totalPages}</a>
                                                    </li>
                                                </c:if>
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

            <style>
                /* Căn lề trái cho nội dung trong các ô của bảng quản lý tài khoản */
                .datatable td,
                .datatable th {
                    text-align: left;
                    vertical-align: middle;
                    /* Giữ căn giữa theo chiều dọc */
                }

                /* Căn giữa cho cột Hành động nếu muốn */
                .datatable th:last-child,
                .datatable td:last-child {
                    text-align: center;
                }

                /* Stat Modern Card Style */
                .stat-modern-card {
                    background: #fff;
                    border-radius: 1.2rem;
                    box-shadow: 0 4px 24px 0 rgba(60, 72, 100, .10);
                    padding: 1.2rem 0.7rem 1rem 0.7rem;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                    min-height: 120px;
                    transition: box-shadow 0.2s, transform 0.2s;
                }

                .stat-modern-card:hover {
                    box-shadow: 0 8px 32px 0 rgba(60, 72, 100, .18);
                    transform: translateY(-6px) scale(1.03);
                }

                .stat-modern-icon-bg {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.2rem;
                    margin-bottom: 0.7rem;
                    background: linear-gradient(135deg, #e3eafe 0%, #f5f7fa 100%);
                    box-shadow: 0 2px 12px 0 rgba(60, 72, 100, .10);
                    color: #4154f1;
                }

                .stat-total .stat-modern-icon-bg {
                    background: linear-gradient(135deg, #e3eafe 0%, #f5f7fa 100%);
                    color: #4154f1;
                }

                .stat-active .stat-modern-icon-bg {
                    background: linear-gradient(135deg, #d0f5e8 0%, #f5f7fa 100%);
                    color: #009688;
                }

                .stat-locked .stat-modern-icon-bg {
                    background: linear-gradient(135deg, #ffe0b2 0%, #f5f7fa 100%);
                    color: #ff9800;
                }

                .stat-modern-title {
                    font-size: 0.95rem;
                    font-weight: 600;
                    color: #1a237e;
                    margin-bottom: 0.3rem;
                    text-align: center;
                }

                .stat-modern-number {
                    font-size: 1.5rem;
                    font-weight: 800;
                    color: #222;
                    margin-bottom: 0.1rem;
                    text-align: center;
                }

                .stat-modern-desc {
                    font-size: 0.85rem;
                    color: #888;
                    text-align: center;
                }

                @media (max-width: 991px) {
                    .stat-modern-card {
                        min-height: 90px;
                    }

                    .stat-modern-icon-bg {
                        width: 28px;
                        height: 28px;
                        font-size: 0.9rem;
                    }
                }

                /* End Stat Modern Card Style */

                .status-circle {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    font-size: 0.9rem;
                }
            </style>

            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    // Updated stat IDs
                    const statTotalDeleted = document.getElementById('stat-total-deleted');
                    const statRecoverable = document.getElementById('stat-recoverable');
                    const statPermanentlyDeleted = document.getElementById('stat-permanently-deleted');

                    // Function to update statistics (simplified for now)
                    function updateDeletedCustomerStats() {
                        // Use values from JSP attributes
                        const totalDeleted = parseInt(statTotalDeleted.textContent);
                        const recoverable = parseInt(statRecoverable.textContent);
                        const permanentlyDeleted = parseInt(statPermanentlyDeleted.textContent);

                        // Update stats from the server on page load (assuming the servlet populates them)
                        // For dynamic updates after restore, you might need to re-fetch data or update counts manually.
                    }

                    const tableBody = document.getElementById('deleted-customer-table-body'); // Use the new ID for deleted customer table

                    // Add event listener for restore buttons
                    if (tableBody) {
                        tableBody.addEventListener('click', async (e) => {
                            if (e.target.closest('.restore-customer-btn')) {
                                const button = e.target.closest('.restore-customer-btn');
                                const customerId = button.dataset.id;

                                if (confirm('Bạn có chắc chắn muốn khôi phục khách hàng này không?')) {
                                    try {
                                        const response = await fetch('account', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: `action=restore&customerId=${customerId}`,
                                        });

                                        const result = await response.json();

                                        if (response.ok) {
                                            alert(result.message);
                                            // Remove the row from the table
                                            button.closest('tr').remove();
                                            // Decrement total deleted users count and increment active users count
                                            if (statTotalDeleted) statTotalDeleted.textContent = parseInt(statTotalDeleted.textContent) - 1;
                                            if (statRecoverable) statRecoverable.textContent = parseInt(statRecoverable.textContent) - 1;
                                            // You might need to trigger a refresh of the customer.jsp table or update its stats as well
                                        } else {
                                            alert('Lỗi: ' + result.error);
                                        }
                                    } catch (error) {
                                        console.error('Lỗi khi khôi phục khách hàng:', error);
                                        alert('Đã xảy ra lỗi khi khôi phục khách hàng.');
                                    }
                                }
                            }
                        });
                    }

                    // Initial update of stats when the page loads
                    updateDeletedCustomerStats();

                    // Removed filter dropdown logic as it's not applicable for deleted customers in this context

                    // Removed ApexCharts donut chart as it's not directly applicable for deleted customers in this context
                });
            </script>