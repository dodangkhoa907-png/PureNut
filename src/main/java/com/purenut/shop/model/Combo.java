package com.purenut.shop.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Ánh xạ bảng dbo.Combos. Field {@code items} được populate bởi DAO
 * (JOIN/truy vấn phụ với ComboItems) — không có cột tương ứng trong DB.
 */
public class Combo {

    private int comboId;
    private String name;
    private String slug;
    private String description;
    private String imageUrl;
    private BigDecimal comboPrice;
    private boolean isActive;
    private boolean isDeleted;
    private LocalDateTime createdAt;

    /** Populated bởi DAO — không có cột tương ứng trong bảng Combos. */
    private List<ComboItem> items;

    public Combo() { }

    public int getComboId() { return comboId; }
    public void setComboId(int comboId) { this.comboId = comboId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public BigDecimal getComboPrice() { return comboPrice; }
    public void setComboPrice(BigDecimal comboPrice) { this.comboPrice = comboPrice; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<ComboItem> getItems() { return items; }
    public void setItems(List<ComboItem> items) { this.items = items; }

    /** Trả về giá định dạng tiếng Việt, ví dụ 199000 -> "199.000". */
    public String getFormattedPrice() {
        if (comboPrice == null) return "0";
        return String.format("%,.0f", comboPrice.doubleValue()).replace(',', '.');
    }

    /** Tổng giá gốc các sản phẩm con (giá tham khảo, không phải giá bán combo). */
    public BigDecimal getOriginalTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        if (items == null) return total;
        for (ComboItem item : items) {
            if (item.getProductPrice() != null) {
                total = total.add(item.getProductPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            }
        }
        return total;
    }

    public String getFormattedOriginalTotalPrice() {
        return String.format("%,.0f", getOriginalTotalPrice().doubleValue()).replace(',', '.');
    }
}
