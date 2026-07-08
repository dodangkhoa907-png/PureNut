package com.purenut.shop.exception;

/**
 * Ném ra khi đặt hàng mà tồn kho không đủ cho một sản phẩm.
 * Dùng để phân biệt với lỗi hệ thống, hiển thị thông báo thân thiện cho khách.
 */
public class OutOfStockException extends Exception {
    private final String productName;

    public OutOfStockException(String productName) {
        super("Sản phẩm \"" + productName + "\" không đủ số lượng tồn kho.");
        this.productName = productName;
    }

    public String getProductName() {
        return productName;
    }
}
