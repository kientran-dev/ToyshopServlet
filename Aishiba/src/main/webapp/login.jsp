<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="head.jsp" />

<body style="
    background-image: url('assets/img/background.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
    backdrop-filter: blur(2.5px); ">
<main>
    <div class="container">

        <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">

                        <div class="d-flex justify-content-center py-4">
                            <a href="homepage" class="logo d-flex align-items-center w-auto">
                                <img src="assets/img/logo.png" alt="" height="38">
                                <span class="d-none d-lg-block">AISHIBA</span>
                            </a>
                        </div><div class="card mb-3">

                        <div class="card-body">

                            <div class="pt-4 pb-2">
                                <h5 class="card-title text-center pb-0 fs-4">Đăng nhập vào tài khoản của bạn</h5>
                                <p class="text-center ">Nhập tên đăng nhập và mật khẩu </p>
                                <%
                                    String error = (String) request.getAttribute("error");
                                    if (error != null) {
                                %>
                                <div class="alert alert-danger text-center" role="alert">
                                    <%= error %>
                                </div>
                                <% } %>
                            </div>

                            <form class="row g-3 needs-validation" action="login" method="post" novalidate>

                                <div class="col-12">
                                    <label for="yourUsername" class="form-label">Tên đăng nhập</label>
                                    <div class="input-group has-validation">
                                        <span class="input-group-text" id="inputGroupPrepend">@</span>
                                        <input type="text" name="username" class="form-control" id="yourUsername"
                                               value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                                        <div class="invalid-feedback" id="usernameError"></div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label for="yourPassword" class="form-label">Mật khẩu</label>
                                    <input type="password" name="password" class="form-control" id="yourPassword"
                                           value="<%= request.getAttribute("password") != null ? request.getAttribute("password") : "" %>" required>
                                    <div class="invalid-feedback" id="passwordError"></div>
                                </div>

                                <div class="col-12">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="remember" value="true" id="rememberMe">
                                        <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <button class="btn btn-primary w-100" type="submit">Đăng nhập</button>
                                </div>

                                <div class="col-12">
                                    <a href="${pageContext.request.contextPath}/googleLogin" class="btn btn-danger w-100">
                                        <i class="fab fa-google me-2"></i> Đăng nhập với Google
                                    </a>
                                </div>
                                <div class="col-12">
                                    <p class="small mb-0" style="color: black;">Chưa có tài khoản? <a href="register">Tạo tài khoản</a></p>
                                </div>
                            </form>

                        </div>
                    </div>

                        <div class="credits" style="color: white;">
                            Designed by <a href="info">Team seven</a>
                        </div>

                    </div>
                </div>
            </div>

        </section>

    </div>
</main>
</body>

<jsp:include page="end.jsp" />