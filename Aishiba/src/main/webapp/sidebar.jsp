<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- ======= Sidebar ======= -->
<aside id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">

        <li class="nav-item">
            <a class="nav-link" href="homepage">
                <i class="bi bi-grid fs-5"></i>
                <span>Dashboard</span>
            </a>
        </li><!-- End Dashboard Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#components-nav" data-bs-toggle="collapse" href="#">
                <i class="bi bi-box-seam fs-5 " ></i><span>Sản phẩm</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="components-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="product" >
                        <i class="bi bi-list-ul fs-5"></i><span>Danh sách sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="supplier">
                        <i class="bi bi-truck fs-5"></i><span>Nhà cung cấp</span>
                    </a>
                </li>
            </ul>
        </li><!-- End Components Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#charts-nav" data-bs-toggle="collapse" href="#">
                <i class="bi bi-people-fill fs-5"></i><span>Khách hàng</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="charts-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
                <li>
                    <a href="customer">
                        <i class="bi bi-person-lines-fill fs-5"></i><span>Danh sách khách hàng</span>
                    </a>
                </li>
                <li>
                    <a href="account">
                        <i class="bi bi-person-x fs-5"></i><span>Khóa/Mở tài khoản khách hàng</span>
                    </a>
                </li>
            </ul>
        </li><!-- End Charts Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#tables-nav" data-bs-toggle="collapse" href="#" >
                <i class="bi bi-cart-check fs-5"></i><span>Giao dịch</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="tables-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
                <li>
                    <a href="order">
                        <i class="bi bi-receipt fs-5"></i><span>Đơn hàng</span>
                    </a>
                </li>
                <li>
                    <a href="stock">
                        <i class="bi bi-box-arrow-in-down fs-5"></i><span>Nhập hàng</span>
                    </a>
                </li>
            </ul>
        </li><!-- End Tables Nav -->


        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#icons-nav" data-bs-toggle="collapse" href="#">
                <i class="bi bi-bar-chart-line fs-5"></i><span>Thống kê</span><i
                    class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="icons-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
                <li>
                    <a href="report-day">
                        <i class="bi bi-calendar-check fs-5"></i><span>Cuối ngày</span>
                    </a>
                </li>
                <li>
                    <a href="report-product">
                        <i class="bi bi-box fs-5"></i><span>Hàng hoá</span>
                    </a>
                </li>
                <li>
                    <a href="report-customer">
                        <i class="bi bi-people fs-5"></i><span>Khách hàng</span>
                    </a>
                </li>
                <li>
                    <a href="report-finance">
                        <i class="bi bi-cash-coin fs-5"></i><span>Tài chính</span>
                    </a>
                </li>
            </ul>
        </li><!-- End Icons Nav -->

        <li class="nav-heading">Pages</li>

        <li class="nav-item">
            <a class="nav-link collapsed" href="info">
                <i class="bi bi-person fs-5"></i>
                <span>Thông tin cá nhân</span>
            </a>
        </li><!-- End Profile Page Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="faq">
                <i class="bi bi-question-circle fs-5"></i>
                <span>F.A.Q</span>
            </a>
        </li><!-- End F.A.Q Page Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="contact">
                <i class="bi bi-envelope fs-5"></i>
                <span>Liên hệ</span>
            </a>
        </li><!-- End Contact Page Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="error404">
                <i class="bi bi-envelope fs-5"></i>
                <span>Error 404</span>
            </a>
        </li><!-- End Error 404 Page Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="register">
                <i class="bi bi-person-plus fs-5"></i>
                <span>Đăng ký</span>
            </a>
        </li><!-- End Register Page Nav -->

        <li class="nav-item">
            <a class="nav-link collapsed" href="login">
                <i class="bi bi-box-arrow-in-right fs-5"></i>
                <span>Đăng nhập</span>
            </a>
        </li><!-- End Login Page Nav -->

    </ul>

</aside><!-- End Sidebar-->

