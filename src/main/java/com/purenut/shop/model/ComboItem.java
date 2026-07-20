package com.purenut.shop.model;

import java.math.BigDecimal;

/**
 * Ánh xạ bảng dbo.ComboItems — 1 sản phẩm cố định (đích danh) trong combo,
 * do admin chọn khi tạo/sửa combo (fixed-bundle, không phải rule theo danh mục).
 * Field productName/productImageUrl/productPrice được populate khi JOIN
 * với Products — không có cột tương ứng trong bảng ComboItems.
 */
public class ComboItem {

    private int comboItemId;
    private int comboId;
    private int productId;
    private int quantity;

    private String productName;
    private String productImageUrl;
    private BigDecimal productPrice;

    public ComboItem() { }

    public int getComboItemId() { return comboItemId; }
    public void setComboItemId(int comboItemId) { this.comboItemId = comboItemId; }

    public int getComboId() { return comboId; }
    public void setComboId(int comboId) { this.comboId = comboId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImageUrl() { return productImageUrl; }
    public void setProductImageUrl(String productImageUrl) { this.productImageUrl = productImageUrl; }

    public BigDecimal getProductPrice() { return productPrice; }
    public void setProductPrice(BigDecimal productPrice) { this.productPrice = productPrice; }
}
