package com.purenut.shop.dao;

import com.purenut.shop.model.Combo;
import com.purenut.shop.model.ComboItem;

import java.util.List;
import java.util.Optional;

/**
 * DAO interface cho bảng Combos + ComboItems (fixed-bundle: admin chọn
 * đích danh sản phẩm cố định cho từng combo).
 * Implementation: {@link com.purenut.shop.dao.impl.ComboDaoImpl}
 */
public interface ComboDao {

    /** Combo đang bán (IsActive=1, IsDeleted=0) — dùng cho trang khách hàng. */
    List<Combo> findAllActive();

    /** Toàn bộ combo chưa xoá mềm — dùng cho admin. */
    List<Combo> findAllForAdmin();

    /** Tìm combo theo ID, kèm sẵn danh sách items (sản phẩm cố định). */
    Optional<Combo> findById(int comboId);

    /** Tìm combo theo slug (unique), kèm sẵn danh sách items. */
    Optional<Combo> findBySlug(String slug);

    /** Danh sách sản phẩm cố định của 1 combo, kèm tên/ảnh/giá (JOIN Products). */
    List<ComboItem> findItemsByComboId(int comboId);

    /** Combo đang bán có chứa sản phẩm này — dùng cho mục "Mua cùng Combo" ở trang chi tiết sản phẩm. */
    List<Combo> findActiveCombosContainingProduct(int productId);

    /**
     * Thêm combo mới + toàn bộ items trong 1 transaction.
     * @return ComboID vừa tạo
     */
    int insert(Combo combo, List<ComboItem> items) throws Exception;

    /**
     * Cập nhật combo + thay toàn bộ items (xoá items cũ, insert items mới) trong 1 transaction.
     */
    void update(Combo combo, List<ComboItem> items) throws Exception;

    /** Xoá mềm (IsDeleted=1) — KHÔNG xoá vật lý khỏi DB. */
    void softDelete(int comboId);

    /**
     * Kiểm tra slug đã tồn tại chưa (loại trừ chính combo đang sửa).
     * @param excludeComboId ComboID cần loại trừ (dùng 0 khi tạo mới)
     */
    boolean slugExists(String slug, int excludeComboId);
}
