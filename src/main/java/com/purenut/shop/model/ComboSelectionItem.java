package com.purenut.shop.model;

/**
 * 1 dòng sản phẩm+số lượng trong snapshot OrderComboItems.SelectionJson.
 * Fixed-bundle: snapshot này do SERVER tự sinh từ ComboItems tại thời điểm
 * đặt hàng (không phải lựa chọn của khách) — dùng để hoàn kho đúng dù sau
 * này admin đổi nội dung combo. Dùng làm phần tử mảng khi (de)serialize
 * qua gson.
 */
public class ComboSelectionItem {

    private int productId;
    private int qty;

    public ComboSelectionItem() { }

    public ComboSelectionItem(int productId, int qty) {
        this.productId = productId;
        this.qty = qty;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }
}
