package com.kiendey.utils;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

import java.util.Properties;
import com.kiendey.model.Toy;
import com.kiendey.model.Category;
import com.kiendey.model.User;
import com.kiendey.model.Order;
import com.kiendey.model.OrderItem;
import com.kiendey.model.Cart;
import com.kiendey.model.CartItem;
import com.kiendey.model.Brand;
import com.kiendey.model.Coupon;
import com.kiendey.model.DeliveryMethod;
import com.kiendey.model.PaymentMethod;
import com.kiendey.model.Permission;
import com.kiendey.model.Role;
import com.kiendey.model.Supplier;
import com.kiendey.model.Stock;
import com.kiendey.model.StockItem;

public class HibernateUtil {

    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                Configuration configuration = new Configuration();
                configuration.configure("hibernate.cfg.xml"); // Load cấu hình từ XML

                Properties envSettings = new Properties();
                String postgresUrl = System.getenv("POSTGRES_URL");
                String postgresUser = System.getenv("POSTGRES_USER");
                String postgresPassword = System.getenv("POSTGRES_PASSWORD");

                // --- DEBUG LOGS (Giữ lại để kiểm tra trên Railway Logs) ---
                System.out.println("DEBUG: POSTGRES_URL = " + postgresUrl);
                System.out.println("DEBUG: POSTGRES_USER = " + postgresUser);
                System.out.println("DEBUG: POSTGRES_PASSWORD = " + (postgresPassword != null ? "********" : "null"));
                // -----------------------------------------------------------

                if (postgresUrl == null || postgresUrl.isEmpty()) {
                    throw new RuntimeException("Biến môi trường POSTGRES_URL chưa được thiết lập.");
                }
                if (postgresUser == null || postgresUser.isEmpty()) {
                    throw new RuntimeException("Biến môi trường POSTGRES_USER chưa được thiết lập.");
                }
                if (postgresPassword == null || postgresPassword.isEmpty()) {
                    throw new RuntimeException("Biến môi trường POSTGRES_PASSWORD chưa được thiết lập.");
                }

                envSettings.put("hibernate.connection.url", postgresUrl);
                envSettings.put("hibernate.connection.username", postgresUser);
                envSettings.put("hibernate.connection.password", postgresPassword);

                StandardServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                        .applySettings(configuration.getProperties())
                        .applySettings(envSettings)
                        .build();

                try {
                    // *** THAY ĐỔI LỚN NHẤT TẠI ĐÂY ***
                    // Bạn cần thêm TẤT CẢ các lớp Entity của mình vào MetadataSources
                    // ngay cả khi chúng đã có trong hibernate.cfg.xml
                    MetadataSources metadataSources = new MetadataSources(serviceRegistry)
                            .addAnnotatedClass(Toy.class)
                            .addAnnotatedClass(Category.class)
                            .addAnnotatedClass(User.class)
                            .addAnnotatedClass(Order.class)
                            .addAnnotatedClass(OrderItem.class)
                            .addAnnotatedClass(Cart.class)
                            .addAnnotatedClass(CartItem.class)
                            .addAnnotatedClass(Brand.class)
                            .addAnnotatedClass(Coupon.class)
                            .addAnnotatedClass(DeliveryMethod.class)
                            .addAnnotatedClass(PaymentMethod.class)
                            .addAnnotatedClass(Permission.class)
                            .addAnnotatedClass(Role.class)
                            .addAnnotatedClass(Supplier.class)
                            .addAnnotatedClass(Stock.class)
                            .addAnnotatedClass(StockItem.class);


                    Metadata metadata = metadataSources.getMetadataBuilder().build();
                    sessionFactory = metadata.getSessionFactoryBuilder().build();

                } catch (Exception e) {
                    StandardServiceRegistryBuilder.destroy(serviceRegistry);
                    throw e;
                }

            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Lỗi khi khởi tạo SessionFactory: " + e.getMessage());
                throw new ExceptionInInitializerError(e);
            }
        }
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}