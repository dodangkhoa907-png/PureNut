package com.purenut.shop.model;

import java.math.BigDecimal;
import java.util.List;

/**
 * Ánh xạ bảng dbo.OrderComboItems — dòng combo đã đặt, snapshot tên/giá/
 * danh sách sản phẩm tại thời điểm mua (không phụ thuộc Combos/ComboItems
 * bị admin sửa/xoá sau này).
 */
public class OrderComboItem {

    private int orderComboItemId;
    private int orderId;
    private int comboId;
    private String comboName;
    private int quantity;
    private BigDecimal priceAtTime;
    private String selectionJson;

    /** Populated bởi DAO khi parse selectionJson qua gson. */
    private List<ComboSelectionItem> selectionItems;

    public OrderComboItem() { }

    public int getOrderComboItemId() { return orderComboItemId; }
    public void setOrderComboItemId(int orderComboItemId) { this.orderComboItemId = orderComboItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getComboId() { return comboId; }
    public void setComboId(int comboId) { this.comboId = comboId; }

    public String getComboName() { return comboName; }
    public void setComboName(String comboName) { this.comboName = comboName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPriceAtTime() { return priceAtTime; }
    public void setPriceAtTime(BigDecimal priceAtTime) { this.priceAtTime = priceAtTime; }

    public String getSelectionJson() { return selectionJson; }
    public void setSelectionJson(String selectionJson) { this.selectionJson = selectionJson; }

    public List<ComboSelectionItem> getSelectionItems() { return selectionItems; }
    public void setSelectionItems(List<ComboSelectionItem> selectionItems) { this.selectionItems = selectionItems; }
}
