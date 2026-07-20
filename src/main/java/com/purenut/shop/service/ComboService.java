package com.purenut.shop.service;

import com.purenut.shop.model.Combo;
import com.purenut.shop.model.ComboItem;

import java.util.List;
import java.util.Optional;

/**
 * Business logic cho Combo (fixed-bundle): admin chọn đích danh sản phẩm
 * cố định cho từng combo, khách hàng không tự chọn gì — chỉ chọn số lượng
 * combo muốn mua.
 * Implementation: {@link com.purenut.shop.service.impl.ComboServiceImpl}
 */
public interface ComboService {

    // ── Admin ───────────────────────────────────────────────────
    List<Combo> getAllCombosForAdmin();
    Optional<Combo> getComboById(int comboId);
    int createCombo(Combo combo, List<ComboItem> items);
    void updateCombo(Combo combo, List<ComboItem> items);
    void deleteCombo(int comboId);

    // ── Customer-facing ─────────────────────────────────────────
    List<Combo> getActiveCombos();
    Optional<Combo> getComboBySlug(String slug);

    /** Combo đang bán có chứa sản phẩm này — dùng cho mục "Mua cùng Combo" ở trang chi tiết sản phẩm. */
    List<Combo> getCombosForProduct(int productId);
}
