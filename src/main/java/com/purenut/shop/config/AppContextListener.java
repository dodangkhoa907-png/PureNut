package com.purenut.shop.config;

import com.purenut.shop.util.Passwords;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Khởi tạo connection pool khi web app start và seed 2 tài khoản mẫu
 * (admin + customer) với mật khẩu hash BCrypt nếu chưa tồn tại.
 * Bảng phải được tạo trước bằng database/schema.sql trong SSMS.
 * 
 * OPTIMIZATION: Seeding chạy async để không block startup.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        long t0 = System.currentTimeMillis();
        System.out.println("[AppInit] Khởi tạo Database pool...");
        Database.init();
        long t1 = System.currentTimeMillis();
        System.out.println("[AppInit] Database pool ready in " + (t1 - t0) + "ms");
        
        // Seed users async - không block Tomcat startup
        new Thread(this::seedUsers, "UserSeedThread").start();
        System.out.println("[AppInit] Seeding users in background thread");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        Database.close();
    }

    private void seedUsers() {
        try {
            long t0 = System.currentTimeMillis();
            // Tài khoản quản trị chính (email nhận mã đổi mật khẩu): khoaddty00210@gmail.com / Admin@123
            seedUser("khoaddty00210@gmail.com", N("Quản trị PureNut"), "0900000000", "Admin@123", "ADMIN");
            seedUser("khachhang@gmail.com", N("Khách Hàng Mẫu"), "0911111111", "Customer@123", "CUSTOMER");
            // Nếu email admin đã tồn tại nhưng bị role CUSTOMER (do lỡ đăng ký trước) -> nâng quyền
            promoteToAdmin("khoaddty00210@gmail.com");
            long t1 = System.currentTimeMillis();
            System.out.println("[Seed] Hoàn tất seeding users in " + (t1 - t0) + "ms");
        } catch (Exception e) {
            System.err.println("[Seed] Lỗi khi seeding users: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** Đảm bảo email chỉ định luôn có Role = ADMIN (không đổi mật khẩu hiện tại). */
    private void promoteToAdmin(String email) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE Users SET Role='ADMIN' WHERE Email=? AND Role<>'ADMIN'")) {
            ps.setString(1, email);
            int n = ps.executeUpdate();
            if (n > 0) System.out.println("[Seed] Đã nâng quyền ADMIN cho " + email);
        } catch (SQLException e) {
            System.err.println("[Seed] Lỗi nâng quyền " + email + ": " + e.getMessage());
        }
    }

    private void seedUser(String email, String fullName, String phone, String rawPassword, String role) {
        try (Connection con = Database.getConnection()) {
            System.out.println("[Seed] Checking user: " + email);
            if (userExists(con, email)) {
                System.out.println("[Seed] User already exists: " + email);
                return;
            }

            String sql = "INSERT INTO Users (FullName, Email, Phone, PasswordHash, Role) VALUES (?,?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setString(4, Passwords.hash(rawPassword));
                ps.setString(5, role);
                ps.executeUpdate();
                ps.setQueryTimeout(10); // 10 giây timeout
            }
            System.out.println("[Seed] Đã tạo tài khoản " + role + ": " + email);
        } catch (SQLException e) {
            System.err.println("[Seed] Lỗi seed user " + email + ": " + e.getMessage());
        }
    }

    private boolean userExists(Connection con, String email) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT 1 FROM Users WHERE Email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Đảm bảo chuỗi tiếng Việt có dấu được giữ nguyên (UTF-8 source file). */
    private static String N(String s) {
        return s;
    }
}
