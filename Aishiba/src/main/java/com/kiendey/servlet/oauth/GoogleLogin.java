package com.kiendey.servlet.oauth;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
// import java.io.InputStreamReader; // Không còn cần thiết nữa vì không đọc từ file
import java.util.Arrays;
import java.util.Collection;
// import java.util.Objects; // Không còn cần thiết nữa

@WebServlet("/googleLogin")
public class GoogleLogin extends HttpServlet {

    // Bỏ CLIENT_SECRET_FILE vì chúng ta sẽ đọc từ biến môi trường
    // private static final String CLIENT_SECRET_FILE = "/client_secret.json";

    private static final Collection<String> SCOPES = Arrays.asList(
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/userinfo.profile"
    );
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static HttpTransport HTTP_TRANSPORT;

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
        } catch (Throwable t) {
            t.printStackTrace();
            System.err.println("Error initializing HTTP Transport: " + t.getMessage());
            // Nên ném ngoại lệ để ứng dụng không khởi động nếu HTTP Transport lỗi
            throw new ExceptionInInitializerError(t);
        }
    }

    private GoogleAuthorizationCodeFlow flow;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // --- THAY ĐỔI TẠI ĐÂY: Đọc Client ID và Client Secret từ biến môi trường ---
            String googleClientId = System.getenv("GOOGLE_CLIENT_ID");
            String googleClientSecret = System.getenv("GOOGLE_CLIENT_SECRET");

            // Kiểm tra xem các biến môi trường có tồn tại và không rỗng không
            if (googleClientId == null || googleClientId.isEmpty()) {
                throw new ServletException("Biến môi trường GOOGLE_CLIENT_ID chưa được thiết lập hoặc rỗng.");
            }
            if (googleClientSecret == null || googleClientSecret.isEmpty()) {
                throw new ServletException("Biến môi trường GOOGLE_CLIENT_SECRET chưa được thiết lập hoặc rỗng.");
            }

            // Tạo đối tượng GoogleClientSecrets từ các giá trị đọc được
            GoogleClientSecrets.Details details = new GoogleClientSecrets.Details();
            details.setClientId(googleClientId);
            details.setClientSecret(googleClientSecret);
            GoogleClientSecrets clientSecrets = new GoogleClientSecrets();
            clientSecrets.setWeb(details); // Sử dụng setWeb() cho ứng dụng web

            // --- Phần còn lại của code khởi tạo flow vẫn giữ nguyên ---
            flow = new GoogleAuthorizationCodeFlow.Builder(
                    HTTP_TRANSPORT,
                    JSON_FACTORY,
                    clientSecrets, // Sử dụng clientSecrets đã tạo từ biến môi trường
                    SCOPES
            ).setDataStoreFactory(new com.google.api.client.util.store.FileDataStoreFactory(
                            new java.io.File(System.getProperty("user.home"), ".store/oauth2-api-client"))
                    ).setAccessType("offline") // Yêu cầu refresh token để duy trì phiên đăng nhập
                    .build();

        } catch (IOException e) {
            throw new ServletException("Lỗi khi khởi tạo Google Authorization Code Flow", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- THAY ĐỔI TẠI ĐÂY: Xử lý Redirect URI ---
        String redirectUri = System.getenv("GOOGLE_REDIRECT_URI");

        if (redirectUri == null || redirectUri.isEmpty()) {
            // Đây là phần fallback, bạn có thể giữ hoặc xóa tùy thuộc vào cách bạn quản lý Redirect URI
            // Nếu bạn luôn thiết lập GOOGLE_REDIRECT_URI trên Render, bạn có thể bỏ phần này
            System.err.println("Biến môi trường GOOGLE_REDIRECT_URI chưa được thiết lập. Sử dụng URI động.");
            redirectUri = request.getScheme() + "://" + request.getServerName() +
                    // Thêm cổng nếu không phải cổng 80 (HTTP) hoặc 443 (HTTPS) mặc định
                    (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort()) +
                    request.getContextPath() + "/oauth2callback_google";
        }

        // Tạo URL ủy quyền của Google
        String authorizationUrl = flow.newAuthorizationUrl()
                .setRedirectUri(redirectUri)
                .build();

        response.sendRedirect(authorizationUrl);
    }
}