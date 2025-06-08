<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Giả sử các file head.jsp, header.jsp, sidebar.jsp đã được include ở trang chính --%>

<main id="main" class="main">

    <div class="pagetitle">
        <h1>Hồ sơ cá nhân</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="homepage">Trang chủ</a></li>
                <li class="breadcrumb-item">Người dùng</li>
                <li class="breadcrumb-item active">Hồ sơ</li>
            </ol>
        </nav>
    </div><section class="section profile">
    <div class="row">
        <div class="col-xl-4">

            <div class="card">
                <div class="card-body profile-card pt-4 d-flex flex-column align-items-center">

                    <img src="assets/img/profile-img.jpg" alt="Profile" class="rounded-circle">
                    <h2>Tung Tung Tung Sahur</h2>
                    <h3>Quản lý chuỗi cửa hàng</h3>
                    <div class="social-links mt-2">
                        <a href="#" class="twitter"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="facebook"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="instagram"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="linkedin"><i class="bi bi-linkedin"></i></a>
                    </div>
                </div>
            </div>

        </div>

        <div class="col-xl-8">

            <div class="card">
                <div class="card-body pt-3">
                    <ul class="nav nav-tabs nav-tabs-bordered">

                        <li class="nav-item">
                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#profile-overview">Tổng quan</button>
                        </li>

                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-edit">Chỉnh sửa hồ sơ</button>
                        </li>

                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-settings">Cài đặt</button>
                        </li>

                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-change-password">Đổi mật khẩu</button>
                        </li>

                    </ul>
                    <div class="tab-content pt-2">

                        <div class="tab-pane fade show active profile-overview" id="profile-overview">
                            <%-- ===== GIỚI THIỆU ĐÃ RÚT GỌN ===== --%>
                            <h5 class="card-title">Giới thiệu</h5>
                            <p class="fst-italic" style="font-size: 16px;">Với vai trò quản lý chuỗi cửa hàng Aishiba, tôi có niềm đam mê mang đến những món đồ chơi không chỉ an toàn, chất lượng mà còn giúp khơi dậy sự sáng tạo và trí tuệ cho trẻ em. Tôi và đội ngũ của mình cam kết đồng hành cùng tuổi thơ, thắp sáng nụ cười cho mọi gia đình Việt.</p>

                            <h5 class="card-title">Chi tiết hồ sơ</h5>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label ">Họ và Tên</div>
                                <div class="col-lg-9 col-md-8">Tung Tung Tung Sahur</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label">Công ty</div>
                                <div class="col-lg-9 col-md-8">Công ty TNHH Aishiba Việt Nam</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label">Chức vụ</div>
                                <div class="col-lg-9 col-md-8">Quản lý chuỗi cửa hàng</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label">Quốc gia</div>
                                <div class="col-lg-9 col-md-8">Việt Nam</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label">Địa chỉ</div>
                                <div class="col-lg-9 col-md-8">Số 123, Phố Duy Tân, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label">Điện thoại</div>
                                <div class="col-lg-9 col-md-8">(+84) 98-765-4321</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label">Email</div>
                                <div class="col-lg-9 col-md-8">manager.aishiba@example.com</div>
                            </div>

                        </div>

                        <div class="tab-pane fade profile-edit pt-3" id="profile-edit">

                            <form>
                                <div class="row mb-3">
                                    <label for="profileImage" class="col-md-4 col-lg-3 col-form-label">Ảnh đại diện</label>
                                    <div class="col-md-8 col-lg-9">
                                        <img src="assets/img/profile-img.jpg" alt="Profile">
                                        <div class="pt-2">
                                            <a href="#" class="btn btn-primary btn-sm" title="Upload new profile image"><i class="bi bi-upload"></i></a>
                                            <a href="#" class="btn btn-danger btn-sm" title="Remove my profile image"><i class="bi bi-trash"></i></a>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="fullName" class="col-md-4 col-lg-3 col-form-label">Họ và Tên</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="fullName" type="text" class="form-control" id="fullName" value="Tung Tung Tung Sahur">
                                    </div>
                                </div>

                                <%-- ===== GIỚI THIỆU ĐÃ RÚT GỌN ===== --%>
                                <div class="row mb-3">
                                    <label for="about" class="col-md-4 col-lg-3 col-form-label">Giới thiệu</label>
                                    <div class="col-md-8 col-lg-9" >
                                        <textarea name="about" class="form-control" id="about" style="height: 100px">Với vai trò quản lý chuỗi cửa hàng Aishiba, tôi có niềm đam mê mang đến những món đồ chơi không chỉ an toàn, chất lượng mà còn giúp khơi dậy sự sáng tạo và trí tuệ cho trẻ em. Tôi và đội ngũ của mình cam kết đồng hành cùng tuổi thơ, thắp sáng nụ cười cho mọi gia đình Việt.</textarea>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="company" class="col-md-4 col-lg-3 col-form-label">Công ty</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="company" type="text" class="form-control" id="company" value="Công ty TNHH Aishiba Việt Nam">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Job" class="col-md-4 col-lg-3 col-form-label">Chức vụ</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="job" type="text" class="form-control" id="Job" value="Quản lý chuỗi cửa hàng">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Country" class="col-md-4 col-lg-3 col-form-label">Quốc gia</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="country" type="text" class="form-control" id="Country" value="Việt Nam">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Address" class="col-md-4 col-lg-3 col-form-label">Địa chỉ</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="address" type="text" class="form-control" id="Address" value="Số 123, Phố Duy Tân, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Phone" class="col-md-4 col-lg-3 col-form-label">Điện thoại</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="phone" type="text" class="form-control" id="Phone" value="(+84) 98-765-4321">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Email" class="col-md-4 col-lg-3 col-form-label">Email</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="email" type="email" class="form-control" id="Email" value="manager.aishiba@example.com">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Twitter" class="col-md-4 col-lg-3 col-form-label">Twitter Profile</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="twitter" type="text" class="form-control" id="Twitter" value="https://twitter.com/#">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Facebook" class="col-md-4 col-lg-3 col-form-label">Facebook Profile</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="facebook" type="text" class="form-control" id="Facebook" value="https://facebook.com/#">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Instagram" class="col-md-4 col-lg-3 col-form-label">Instagram Profile</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="instagram" type="text" class="form-control" id="Instagram" value="https://instagram.com/#">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label for="Linkedin" class="col-md-4 col-lg-3 col-form-label">Linkedin Profile</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="linkedin" type="text" class="form-control" id="Linkedin" value="https://linkedin.com/#">
                                    </div>
                                </div>

                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                </div>
                            </form></div>

                        <div class="tab-pane fade pt-3" id="profile-settings">
                        </div>

                        <div class="tab-pane fade pt-3" id="profile-change-password">
                        </div>

                    </div></div>
            </div>

        </div>
    </div>
</section>

</main>```