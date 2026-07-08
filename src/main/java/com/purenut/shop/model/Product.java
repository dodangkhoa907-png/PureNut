package com.purenut.shop.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Ánh xạ bảng dbo.Products trong SQL Server.
 * Field {@code categoryName} được populate khi JOIN với Categories —
 * không có cột tương ứng trong DB.
 */
public class Product {

    private int    productId;
    private String name;
    private String slug;
    private int    categoryId;
    private String description;
    private BigDecimal price;
    private String imageUrl;
    private String bgColorHex;
    private int    volumeMl;
    private int    kcalPer100ml;
    private int    stockQuantity;
    private boolean isFeatured;
    private boolean isDeleted;
    private LocalDateTime createdAt;

    /** Populated khi JOIN Categories — không có trong bảng Products. */
    private String categoryName;
    /** Slug của category — dùng để lọc filter chip. */
    private String categorySlug;

    /* ── Constructors ─────────────────────────────────────────── */

    public Product() { }

    /* ── Getters & Setters ────────────────────────────────────── */

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getBgColorHex() { return bgColorHex; }
    public void setBgColorHex(String bgColorHex) { this.bgColorHex = bgColorHex; }

    public int getVolumeMl() { return volumeMl; }
    public void setVolumeMl(int volumeMl) { this.volumeMl = volumeMl; }

    public int getKcalPer100ml() { return kcalPer100ml; }
    public void setKcalPer100ml(int kcalPer100ml) { this.kcalPer100ml = kcalPer100ml; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean featured) { isFeatured = featured; }

    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getCategorySlug() { return categorySlug; }
    public void setCategorySlug(String categorySlug) { this.categorySlug = categorySlug; }

    /* ── Helpers dùng trong JSP ───────────────────────────────── */

    /**
     * Trả về giá định dạng tiếng Việt (không import java.text trong JSP).
     * Ví dụ: 22000 → "22.000"
     */
    public String getFormattedPrice() {
        if (price == null) return "0";
        return String.format("%,.0f", price.doubleValue()).replace(',', '.');
    }

    /** Kiểm tra còn hàng. */
    public boolean isInStock() {
        return stockQuantity > 0;
    }

    @Override
    public String toString() {
        return "Product{productId=" + productId + ", name='" + name + "', slug='" + slug + "'}";
    }
}
