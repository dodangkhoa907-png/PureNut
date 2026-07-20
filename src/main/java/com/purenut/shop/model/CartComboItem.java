package com.purenut.shop.model;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;

/**
 * Ánh xạ bảng dbo.CartComboItems — 1 lần khách "thêm combo vào giỏ".
 * Fixed-bundle: nội dung combo (sản phẩm + số lượng) đã cố định sẵn trong
 * ComboItems, khách chỉ chọn số lượng combo (bundle) muốn mua — không có
 * lựa chọn sản phẩm nào để lưu riêng ở đây.
 */
public class CartComboItem {

    private int cartComboItemId;
    private int userId;
    private int comboId;
    private int quantity;
    private Date createdAt;

    // Thuộc tính bổ sung cho UI (JOIN Combos)
    private String comboName;
    private String comboSlug;
    private BigDecimal comboPrice;
    private String imageUrl;

    /** Populated bởi DAO (JOIN ComboItems+Products) — danh sách sản phẩm cố định trong combo, để hiển thị. */
    private List<ComboItem> items;

    public CartComboItem() { }

    public int getCartComboItemId() { return cartComboItemId; }
    public void setCartComboItemId(int cartComboItemId) { this.cartComboItemId = cartComboItemId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getComboId() { return comboId; }
    public void setComboId(int comboId) { this.comboId = comboId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getComboName() { return comboName; }
    public void setComboName(String comboName) { this.comboName = comboName; }

    public String getComboSlug() { return comboSlug; }
    public void setComboSlug(String comboSlug) { this.comboSlug = comboSlug; }

    public BigDecimal getComboPrice() { return comboPrice; }
    public void setComboPrice(BigDecimal comboPrice) { this.comboPrice = comboPrice; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public List<ComboItem> getItems() { return items; }
    public void setItems(List<ComboItem> items) { this.items = items; }

    public BigDecimal getTotalPrice() {
        if (comboPrice != null) {
            return comboPrice.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }

    public String getFormattedTotalPrice() {
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(getTotalPrice()).replace(',', '.');
    }

    public String getFormattedPrice() {
        if (comboPrice == null) return "0";
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(comboPrice).replace(',', '.');
    }
}
