package com.purenut.shop.dao;

import com.purenut.shop.model.CartItem;
import java.util.List;

public interface CartItemDao {
    int insertOrUpdate(int userId, int productId, int quantity);
    List<CartItem> findByUserId(int userId);
    /** Đặt lại số lượng cho 1 dòng giỏ (set, không cộng dồn). */
    void updateQuantity(int cartItemId, int userId, int quantity);
    void delete(int cartItemId, int userId);
    void clearCart(int userId);
    /** Tổng số lượng sản phẩm trong giỏ (cho badge navbar). */
    int countItems(int userId);
}
