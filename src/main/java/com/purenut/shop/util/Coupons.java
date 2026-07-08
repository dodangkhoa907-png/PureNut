package com.purenut.shop.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Logic mã giảm giá. Hiện hỗ trợ mã PURENUT20 (giảm 20%)
 * tái sử dụng từ landing page. Tách riêng để dễ mở rộng mã khác.
 */
public final class Coupons {

    public static final String PURENUT20 = "PURENUT20";

    private Coupons() { }

    /** true nếu mã hợp lệ (không phân biệt hoa thường). */
    public static boolean isValid(String code) {
        return code != null && PURENUT20.equalsIgnoreCase(code.trim());
    }

    /** Số tiền được giảm trên tổng tạm tính (0 nếu mã không hợp lệ). */
    public static BigDecimal discountFor(String code, BigDecimal subtotal) {
        if (subtotal == null || !isValid(code)) return BigDecimal.ZERO;
        return subtotal.multiply(new BigDecimal("0.20"))
                       .setScale(0, RoundingMode.HALF_UP);
    }

    /** Tổng sau khi trừ giảm giá. */
    public static BigDecimal applyDiscount(String code, BigDecimal subtotal) {
        if (subtotal == null) return BigDecimal.ZERO;
        return subtotal.subtract(discountFor(code, subtotal));
    }
}
