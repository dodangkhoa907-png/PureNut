package com.purenut.shop.config;

/**
 * Cấu hình PayOS — điền thông tin từ dashboard.payos.vn
 * Hoặc set environment variables: PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY
 */
public final class PayOSConfig {
    public static final String CLIENT_ID    = resolve("PAYOS_CLIENT_ID",    "payos.client_id");
    public static final String API_KEY      = resolve("PAYOS_API_KEY",      "payos.api_key");
    public static final String CHECKSUM_KEY = resolve("PAYOS_CHECKSUM_KEY", "payos.checksum_key");
    public static final String BASE_URL     = "https://api-merchant.payos.vn";
    public static final int    EXPIRE_SECS  = 600;

    private PayOSConfig() {}

    private static String resolve(String envName, String propKey) {
        String v = System.getenv(envName);
        if (v != null && !v.isBlank()) return v;
        return AppConfig.get(propKey, "");
    }

    public static boolean isConfigured() {
        return !CLIENT_ID.isEmpty()
            && !API_KEY.isEmpty()
            && !CHECKSUM_KEY.isEmpty();
    }
}
