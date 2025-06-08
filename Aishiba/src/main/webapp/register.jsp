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
            </div>

            <div class="card mb-3">
              <div class="card-body">
                <div class="pt-4 pb-2">
                  <h5 class="card-title text-center pb-0 fs-4">Tạo tài khoản mới</h5>
                  <p class="text-center small">Nhập thông tin cá nhân của bạn để tạo tài khoản</p>
                  <%-- Hiển thị thông báo lỗi chung từ Servlet --%>
                  <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                  %>
                  <div class="alert alert-danger text-center small p-2" role="alert">
                    <%= error %>
                  </div>
                  <% } %>
                </div>

                <form class="row g-3 needs-validation" action="register" method="post" novalidate>

                  <div class="col-12">
                    <label for="yourName" class="form-label">Họ và Tên</label>
                    <input type="text" name="fullname" class="form-control" id="yourName"
                           value="<%= request.getAttribute("fullname") != null ? request.getAttribute("fullname") : "" %>" required>
                    <div class="invalid-feedback">Vui lòng nhập họ và tên của bạn!</div>
                  </div>

                  <%-- ===== TRƯỜNG TÊN ĐĂNG NHẬP (THÊM LẠI) ===== --%>
                  <div class="col-12">
                    <label for="yourUsername" class="form-label">Tên đăng nhập</label>
                    <div class="input-group has-validation">
                      <span class="input-group-text" id="inputGroupPrepend">@</span>
                      <input type="text" name="username" class="form-control" id="yourUsername"
                             value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                      <div class="invalid-feedback">Vui lòng chọn tên đăng nhập.</div>
                    </div>
                  </div>
                  <%-- ============================================ --%>

                  <div class="col-12">
                    <label for="yourEmail" class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" id="yourEmail"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                    <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ.</div>
                  </div>

                  <div class="col-12">
                    <label for="yourPassword" class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" id="yourPassword" required>
                    <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
                  </div>

                  <div class="col-12">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                    <input type="password" name="confirm_password" class="form-control" id="confirmPassword" required>
                    <div class="invalid-feedback">Vui lòng xác nhận lại mật khẩu!</div>
                  </div>

                  <div class="col-12">
                    <div class="form-check">
                      <input class="form-check-input" name="terms" type="checkbox" value="true" id="acceptTerms" required>
                      <label class="form-check-label" for="acceptTerms">Tôi đồng ý với các <a href="#">điều khoản và điều kiện</a></label>
                      <div class="invalid-feedback">Bạn phải đồng ý với điều khoản để tiếp tục.</div>
                    </div>
                  </div>

                  <div class="col-12">
                    <button class="btn btn-primary w-100" type="submit">Tạo tài khoản</button>
                  </div>
                  <div class="col-12">
                    <p class="small mb-0" style="color: black;">Đã có tài khoản? <a href="login">Đăng nhập</a></p>
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