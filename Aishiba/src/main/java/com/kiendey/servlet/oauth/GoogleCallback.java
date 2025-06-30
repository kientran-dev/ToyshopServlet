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
import java.io.InputStreamReader;
import java.util.Collection;
import java.util.Arrays;

import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.api.client.http.GenericUrl;


@WebServlet("/oauth2callback_google")
public class GoogleCallback extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GoogleCallback.class.getName());
    private static final String CLIENT_SECRET_FILE = "/WEB-INF/client_secret.json";

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
            LOGGER.log(Level.SEVERE, "Failed to initialize HTTP Transport", t);
            throw new ExceptionInInitializerError(t);
        }
    }

    private GoogleAuthorizationCodeFlow flow;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                    JSON_FACTORY, new InputStreamReader(getServletContext().getResourceAsStream(CLIENT_SECRET_FILE))
            );

            flow = new GoogleAuthorizationCodeFlow.Builder(
                    HTTP_TRANSPORT,
                    JSON_FACTORY,
                    clientSecrets,
                    SCOPES
            )
                    .setDataStoreFactory(new com.google.api.client.util.store.FileDataStoreFactory(
                            new java.io.File(System.getProperty("user.home"), ".store/oauth2-api-client")))
                    .setAccessType("offline")
                    .setApprovalPrompt("force")
                    .build();

            userDAO = new UserDAOImpl();

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error initializing Google Authorization Code Flow or UserDAO", e);
            throw new ServletException("Error initializing Google Callback Servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code != null) {
            String redirectUri = request.getScheme() + "://" +
                    request.getServerName() +
                    (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort()) +
                    request.getContextPath() + "/oauth2callback_google";

            try {
                GoogleTokenResponse tokenResponse = flow.newTokenRequest(code)
                        .setRedirectUri(redirectUri)
                        .execute();

                // *** CHỈNH SỬA TẠI ĐÂY ***
                // Tạo GenericUrl từ String token server URL
                GenericUrl tokenServerUrl = new GenericUrl(flow.getTokenServerEncodedUrl());

                Credential credential = new Credential.Builder(
                        com.google.api.client.auth.oauth2.BearerToken.authorizationHeaderAccessMethod())
                        .setTransport(HTTP_TRANSPORT)
                        .setJsonFactory(JSON_FACTORY)
                        .setTokenServerUrl(tokenServerUrl)
                        .setClientAuthentication(flow.getClientAuthentication())
                        .build(); // DỪNG Ở ĐÂY, HOÀN TẤT VIỆC BUILD ĐỐI TƯỢNG CREDENTIAL

                // BÂY GIỜ GỌI CÁC PHƯƠNG THỨC SETTER TRÊN ĐỐI TƯỢNG CREDENTIAL ĐÃ ĐƯỢC TẠO
                credential.setAccessToken(tokenResponse.getAccessToken());
                credential.setRefreshToken(tokenResponse.getRefreshToken());
                credential.setExpirationTimeMilliseconds(tokenResponse.getExpiresInSeconds() != null ?
                        System.currentTimeMillis() + tokenResponse.getExpiresInSeconds() * 1000 : null);
                // **************************

                Oauth2 oauth2 = new Oauth2.Builder(
                        HTTP_TRANSPORT,
                        JSON_FACTORY,
                        credential
                ).setApplicationName("ToyshopServlet").build();

                Userinfo userInfo = oauth2.userinfo().get().execute();

                String googleEmail = userInfo.getEmail();
                String googleFirstName = userInfo.getGivenName();
                String googleLastName = userInfo.getFamilyName();
                String googleId = userInfo.getId();

                User existingUser = userDAO.findByEmail(googleEmail);

                if (existingUser == null) {
                    RoleDAOImpl roleDAO = new RoleDAOImpl();
                    Role customerRole = roleDAO.getRoleByName("User");
                    User newUser = new User();
                    newUser.setEmail(googleEmail);
                    newUser.setName(googleFirstName + " " + googleLastName);
                    newUser.setPassword(PasswordUtil.hashPassword(googleId));
                    newUser.setRole(customerRole);
                    newUser.setDeleted(false);

                    userDAO.createUser(newUser);
                    request.getSession().setAttribute("currentUser", newUser);
                    response.sendRedirect(request.getContextPath() + "/homepage");
                } else {
                    request.getSession().setAttribute("currentUser", existingUser);
                    response.sendRedirect(request.getContextPath() + "/homepage");
                }

            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error during Google OAuth callback processing: " + e.getMessage(), e);
                response.sendRedirect(request.getContextPath() + "/login?error=oauth_failed&details=" + e.getClass().getSimpleName());
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Unexpected error during Google OAuth callback processing: " + e.getMessage(), e);
                response.sendRedirect(request.getContextPath() + "/login?error=oauth_failed_unexpected&details=" + e.getClass().getSimpleName());
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
        }
    }
}