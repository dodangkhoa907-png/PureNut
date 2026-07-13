package com.purenut.shop.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Connection pool dùng chung toàn ứng dụng (HikariCP).
 * Đọc cấu hình từ src/main/resources/db.properties.
 * Mọi DAO lấy Connection qua {@link #getConnection()}.
 */
public final class Database {

    private static volatile HikariDataSource dataSource;

    private Database() { }

    /** Khởi tạo pool 1 lần khi app start (gọi từ AppContextListener). */
    public static synchronized void init() {
        if (dataSource != null) return;

        long t0 = System.currentTimeMillis();
        Properties props = new Properties();
        try (InputStream in = Database.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new IllegalStateException("Không tìm thấy db.properties trong classpath");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Lỗi đọc db.properties", e);
        }
        
        long t1 = System.currentTimeMillis();
        System.out.println("[DB] Loaded db.properties in " + (t1 - t0) + "ms");

        // Bật statement pooling phía driver SQL Server (tái dùng prepared statement -> nhanh hơn)
        String jdbcUrl = props.getProperty("db.url");
        if (jdbcUrl != null && !jdbcUrl.toLowerCase().contains("statementpoolingcachesize")) {
            jdbcUrl += (jdbcUrl.endsWith(";") ? "" : ";") + "statementPoolingCacheSize=512;disableStatementPooling=false";
        }

        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(jdbcUrl);
        cfg.setUsername(props.getProperty("db.username"));
        cfg.setPassword(props.getProperty("db.password"));
        cfg.setDriverClassName(props.getProperty("db.driver"));
        cfg.setPoolName("PureNutPool");
        cfg.setMaximumPoolSize(8);
        cfg.setMinimumIdle(2);
        cfg.setConnectionTimeout(10_000);
        cfg.setIdleTimeout(300_000);
        cfg.setMaxLifetime(900_000);
        cfg.setKeepaliveTime(120_000);
        cfg.setValidationTimeout(3_000);
        cfg.setLeakDetectionThreshold(30_000);

        long t2 = System.currentTimeMillis();
        System.out.println("[DB] Creating HikariCP pool (MinIdle=2, MaxSize=12)...");
        dataSource = new HikariDataSource(cfg);
        long t3 = System.currentTimeMillis();
        System.out.println("[DB] HikariCP pool initialized in " + (t3 - t2) + "ms (total init: " + (t3 - t0) + "ms)");
    }

    public static DataSource getDataSource() {
        if (dataSource == null) init();
        return dataSource;
    }

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    public static synchronized void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            dataSource = null;
        }
    }
}
