package com.purenut.shop.model;

import java.math.BigDecimal;
import java.util.Date;
import java.text.DecimalFormat;

public class CartItem {
    private int cartItemId;
    private int userId;
    private int productId;
    private int quantity;
    private Date createdAt;
    
    // Thuộc tính bổ sung cho UI (JOIN Products)
    private String productName;
    private BigDecimal productPrice;
    private String productSlug;
    private String imageUrl;
    private String bgColorHex;
    private int volumeMl;

    public CartItem() {}

    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getProductPrice() { return productPrice; }
    public void setProductPrice(BigDecimal productPrice) { this.productPrice = productPrice; }

    public String getProductSlug() { return productSlug; }
    public void setProductSlug(String productSlug) { this.productSlug = productSlug; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getBgColorHex() { return bgColorHex; }
    public void setBgColorHex(String bgColorHex) { this.bgColorHex = bgColorHex; }

    public int getVolumeMl() { return volumeMl; }
    public void setVolumeMl(int volumeMl) { this.volumeMl = volumeMl; }

    public BigDecimal getTotalPrice() {
        if (productPrice != null) {
            return productPrice.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }
    
    public String getFormattedTotalPrice() {
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(getTotalPrice()).replace(',', '.');
    }
    
    public String getFormattedPrice() {
        if (productPrice == null) return "0";
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(productPrice).replace(',', '.');
    }
}
