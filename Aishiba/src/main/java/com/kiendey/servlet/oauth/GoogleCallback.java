package com.kiendey.servlet.oauth;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.oauth2.model.Userinfo;
import com.kiendey.dao.UserDAO;
import com.kiendey.dao.impl.RoleDAOImpl;
import com.kiendey.dao.impl.UserDAOImpl;
import com.kiendey.model.Role;
import com.kiendey.model.User;
import com.kiendey.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
// import java.io.InputStreamReader; // KHÔNG CẦN THIẾT NỮA
import java.util.Collection;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken; // Thêm import này
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier; // Thêm import này
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload; // Thêm import này


@WebServlet("/oauth2callback_google")
public class GoogleCallback extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GoogleCallback.class.getName());
    // KHÔNG CẦN DÒNG NÀY NỮA VÌ CHÚNG TA ĐỌC TỪ BIẾN MÔI TRƯỜNG
    // private static final String CLIENT_SECRET_FILE = "/resources/client_secret.json";

    private static final Collection<String> SCOPES = Arrays.asList(
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/userinfo.profile"
            // "openid" // Thường được thêm vào nếu bạn sử dụng ID Token
    );

    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static HttpTransport HTTP_TRANSPORT;

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
        } catch (Throwable t) {
            LOGGER.log(Level.SEVERE, "Failed to initialize HTTP Transport in GoogleCallback", t);
            throw new ExceptionInInitializerError(t);
        }
    }

    private GoogleAuthorizationCodeFlow flow;
    private UserDAO userDAO;
    private RoleDAOImpl roleDAO; // Khởi tạo RoleDAOImpl một lần

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // --- THAY ĐỔI TẠI ĐÂY: Đọc Client ID và Client Secret từ biến môi trường ---
            String googleClientId = System.getenv("GOOGLE_CLIENT_ID");
            String googleClientSecret = System.getenv("GOOGLE_CLIENT_SECRET");

            // --- DEBUG LOGS (Giữ lại để kiểm tra trên Railway Logs) ---
            System.out.println("DEBUG: Google Client ID in GoogleCallback = " + googleClientId);
            System.out.println("DEBUG: Google Client Secret in GoogleCallback = " + (googleClientSecret != null ? "********" : "null"));
            // -------------------------------------------------------------------------

            // Kiểm tra xem các biến môi trường có tồn tại không
            if (googleClientId == null || googleClientId.isEmpty()) {
                LOGGER.log(Level.SEVERE, "Biến môi trường GOOGLE_CLIENT_ID chưa được thiết lập trong GoogleCallback.");
                throw new ServletException("Biến môi trường GOOGLE_CLIENT_ID chưa được thiết lập.");
            }
            if (googleClientSecret == null || googleClientSecret.isEmpty()) {
                LOGGER.log(Level.SEVERE, "Biến môi trường GOOGLE_CLIENT_SECRET chưa được thiết lập trong GoogleCallback.");
                throw new ServletException("Biến môi trường GOOGLE_CLIENT_SECRET chưa được thiết lập.");
            }

            // Tạo GoogleClientSecrets từ các biến môi trường
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
            )
                    .setDataStoreFactory(new com.google.api.client.util.store.FileDataStoreFactory(
                            new java.io.File(System.getProperty("user.home"), ".store/oauth2-api-client")))
                    .setAccessType("offline")
                    .setApprovalPrompt("force")
                    .build();

            userDAO = new UserDAOImpl();
            roleDAO = new RoleDAOImpl(); // Khởi tạo RoleDAOImpl ở đây

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error initializing Google Authorization Code Flow or DAOs", e);
            throw new ServletException("Error initializing Google Callback Servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code != null) {
            // Lấy redirect URI từ biến môi trường
            String redirectUri = System.getenv("GOOGLE_REDIRECT_URI");
            // --- DEBUG LOGS ---
            System.out.println("DEBUG: Google Redirect URI in GoogleCallback (doGet) = " + redirectUri);
            // ------------------

            if (redirectUri == null || redirectUri.isEmpty()) {
                LOGGER.log(Level.WARNING, "Biến môi trường GOOGLE_REDIRECT_URI chưa được thiết lập trong GoogleCallback. Sử dụng URI động.");
                // Fallback: Xây dựng động nếu biến môi trường không có
                redirectUri = request.getScheme() + "://" +
                        request.getServerName() +
                        (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort()) +
                        request.getContextPath() + "/oauth2callback_google";
            }

            try {
                GoogleTokenResponse tokenResponse = flow.newTokenRequest(code)
                        .setRedirectUri(redirectUri)
                        .execute();

                // Lấy thông tin người dùng từ ID Token (khuyến nghị)
                GoogleIdToken idToken = tokenResponse.parseIdToken();
                if (idToken == null) {
                    LOGGER.log(Level.WARNING, "Failed to parse ID Token from GoogleTokenResponse.");
                    response.sendRedirect(request.getContextPath() + "/login?error=oauth_failed&details=id_token_missing");
                    return;
                }
                Payload payload = idToken.getPayload();

                String googleEmail = payload.getEmail();
                String googleFirstName = (String) payload.get("given_name");
                String googleLastName = (String) payload.get("family_name");
                String googleId = payload.getSubject(); // Google User ID

                User existingUser = userDAO.findByEmail(googleEmail);

                if (existingUser == null) {
                    Role customerRole = roleDAO.getRoleByName("User"); // Sử dụng roleDAO đã khởi tạo
                    if (customerRole == null) {
                        LOGGER.log(Level.SEVERE, "Role 'User' not found in database. Cannot create new user.");
                        response.sendRedirect(request.getContextPath() + "/login?error=role_not_found");
                        return;
                    }

                    User newUser = new User();
                    newUser.setEmail(googleEmail);
                    newUser.setName(googleFirstName + " " + googleLastName);
                    // Mật khẩu có thể là một chuỗi ngẫu nhiên hoặc hash của googleId
                    // Không nên dùng googleId trực tiếp làm mật khẩu, hãy hash nó.
                    newUser.setPassword(PasswordUtil.hashPassword(googleId));
                    newUser.setRole(customerRole);
                    newUser.setDeleted(false);

                    userDAO.createUser(newUser);
                    request.getSession().setAttribute("currentUser", newUser);
                    LOGGER.log(Level.INFO, "New user registered via Google: " + googleEmail);
                    response.sendRedirect(request.getContextPath() + "/homepage");
                } else {
                    request.getSession().setAttribute("currentUser", existingUser);
                    LOGGER.log(Level.INFO, "Existing user logged in via Google: " + googleEmail);
                    response.sendRedirect(request.getContextPath() + "/homepage");
                }

            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error during Google OAuth token exchange: " + e.getMessage(), e);
                response.sendRedirect(request.getContextPath() + "/login?error=oauth_token_exchange_failed&details=" + e.getClass().getSimpleName());
            } catch (Exception e) {
                // Bắt các ngoại lệ chung khác
                LOGGER.log(Level.SEVERE, "Unexpected error during Google OAuth callback processing: " + e.getMessage(), e);
                response.sendRedirect(request.getContextPath() + "/login?error=oauth_failed_unexpected&details=" + e.getClass().getSimpleName());
            }
        } else {
            // Xử lý trường hợp không có 'code' (ví dụ: người dùng từ chối cấp quyền hoặc lỗi khác)
            String error = request.getParameter("error");
            String errorDescription = request.getParameter("error_description");
            LOGGER.log(Level.WARNING, "Google OAuth access denied or error: " + error + " - " + errorDescription);
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied&details=" + (error != null ? error : "unknown"));
        }
    }
}