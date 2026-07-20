package com.purenut.shop.dao;

import com.purenut.shop.model.CartComboItem;

import java.util.List;

/**
 * DAO interface cho bảng CartComboItems.
 * Fixed-bundle: nội dung combo cố định sẵn trong ComboItems, khách chỉ chọn
 * số lượng combo muốn mua — dùng insertOrUpdate merge theo (UserID, ComboID)
 * giống CartItemDao, vì 2 lần "thêm cùng combo" giờ luôn là cùng 1 nội dung.
 */
public interface CartComboItemDao {

    /** Giỏ hàng combo của 1 user, kèm thông tin combo (JOIN Combos) + danh sách sản phẩm cố định (JOIN ComboItems+Products). */
    List<CartComboItem> findByUserId(int userId);

    /** Merge theo (UserID, ComboID): đã có thì cộng dồn quantity, chưa có thì tạo mới. */
    int insertOrUpdate(int userId, int comboId, int quantity);

    void updateQuantity(int cartComboItemId, int userId, int quantity);

    void delete(int cartComboItemId, int userId);

    /** Xoá toàn bộ combo trong giỏ của user — dùng sau khi checkout xong. */
    void clearForUser(int userId);
}
