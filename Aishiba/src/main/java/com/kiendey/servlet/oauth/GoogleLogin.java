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
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Collection;
import java.util.Objects;

@WebServlet("/googleLogin")
public class GoogleLogin extends HttpServlet {

    private static final String CLIENT_SECRET_FILE = "/client_secret.json"; // Đặt file này trong src/main/resources
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
            System.exit(1);
        }
    }

    private GoogleAuthorizationCodeFlow flow;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // Tải Client Secrets từ file client_secret.json
            GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                    JSON_FACTORY, new InputStreamReader(Objects.requireNonNull(GoogleLogin.class.getResourceAsStream(CLIENT_SECRET_FILE)))
            );

            // Khởi tạo flow
            flow = new GoogleAuthorizationCodeFlow.Builder(
                    HTTP_TRANSPORT,
                    JSON_FACTORY,
                    clientSecrets,
                    SCOPES
            ).setDataStoreFactory(new com.google.api.client.util.store.FileDataStoreFactory(
                            new java.io.File(System.getProperty("user.home"), ".store/oauth2-api-client"))
                    ).setAccessType("offline") // Yêu cầu refresh token để duy trì phiên đăng nhập
                    .build();

        } catch (IOException e) {
            throw new ServletException("Error initializing Google Authorization Code Flow", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/oauth2callback_google";

        // Tạo URL ủy quyền của Google
        String authorizationUrl = flow.newAuthorizationUrl()
                .setRedirectUri(redirectUri)
                .build();

        response.sendRedirect(authorizationUrl);
    }
}
