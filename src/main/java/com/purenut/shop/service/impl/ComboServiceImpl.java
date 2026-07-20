package com.purenut.shop.service.impl;

import com.purenut.shop.dao.ComboDao;
import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.ComboDaoImpl;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Combo;
import com.purenut.shop.model.ComboItem;
import com.purenut.shop.service.ComboService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Triển khai ComboService (fixed-bundle). Chứa validation + điều phối DAO calls.
 * Không phụ thuộc Spring — Servlet khởi tạo bằng {@code new ComboServiceImpl()}.
 *
 * Đây là ngoại lệ có chủ đích so với style "admin bỏ qua Service" đang dùng
 * cho Product: validation combo (kiểm tra sản phẩm tồn tại) dùng chung cho
 * cả AdminComboController lẫn các chỗ khác cần đọc combo.
 */
public class ComboServiceImpl implements ComboService {

    private final ComboDao comboDao;
    private final ProductDao productDao;

    /** Constructor mặc định cho Servlet. */
    public ComboServiceImpl() {
        this.comboDao = new ComboDaoImpl();
        this.productDao = new ProductDaoImpl();
    }

    /** Constructor tiêm DAO — dùng cho unit test mock. */
    public ComboServiceImpl(ComboDao comboDao, ProductDao productDao) {
        this.comboDao = comboDao;
        this.productDao = productDao;
    }

    // ── Admin ───────────────────────────────────────────────────

    @Override
    public List<Combo> getAllCombosForAdmin() {
        return comboDao.findAllForAdmin();
    }

    @Override
    public Optional<Combo> getComboById(int comboId) {
        if (comboId <= 0) return Optional.empty();
        return comboDao.findById(comboId);
    }

    @Override
    public int createCombo(Combo combo, List<ComboItem> items) {
        validateCombo(combo, items, 0);
        try {
            return comboDao.insert(combo, items);
        } catch (Exception e) {
            throw new RuntimeException("Tạo combo thất bại", e);
        }
    }

    @Override
    public void updateCombo(Combo combo, List<ComboItem> items) {
        if (combo.getComboId() <= 0) throw new IllegalArgumentException("ComboID không hợp lệ");
        validateCombo(combo, items, combo.getComboId());
        try {
            comboDao.update(combo, items);
        } catch (Exception e) {
            throw new RuntimeException("Cập nhật combo thất bại", e);
        }
    }

    @Override
    public void deleteCombo(int comboId) {
        if (comboId <= 0) throw new IllegalArgumentException("ComboID không hợp lệ");
        comboDao.softDelete(comboId);
    }

    // ── Customer-facing ─────────────────────────────────────────

    @Override
    public List<Combo> getActiveCombos() {
        return comboDao.findAllActive();
    }

    @Override
    public Optional<Combo> getComboBySlug(String slug) {
        if (slug == null || slug.isBlank()) return Optional.empty();
        return comboDao.findBySlug(slug.trim());
    }

    @Override
    public List<Combo> getCombosForProduct(int productId) {
        if (productId <= 0) return List.of();
        return comboDao.findActiveCombosContainingProduct(productId);
    }

    // ── Private helpers ─────────────────────────────────────────

    /**
     * Kiểm tra các trường bắt buộc của Combo + items trước khi insert/update.
     * @param excludeComboId ComboID cần loại trừ khi check slug trùng (0 khi tạo mới)
     */
    private void validateCombo(Combo combo, List<ComboItem> items, int excludeComboId) {
        if (combo == null) throw new IllegalArgumentException("Combo không được null");
        if (combo.getName() == null || combo.getName().isBlank()) {
            throw new IllegalArgumentException("Tên combo không được để trống");
        }
        if (combo.getSlug() == null || combo.getSlug().isBlank()) {
            throw new IllegalArgumentException("Slug combo không được để trống");
        }
        if (comboDao.slugExists(combo.getSlug(), excludeComboId)) {
            throw new IllegalArgumentException("Slug \"" + combo.getSlug() + "\" đã tồn tại");
        }
        if (combo.getComboPrice() == null || combo.getComboPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Giá combo phải > 0");
        }
        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Combo phải có ít nhất 1 sản phẩm");
        }
        for (ComboItem item : items) {
            if (item.getQuantity() <= 0) {
                throw new IllegalArgumentException("Số lượng sản phẩm trong combo phải > 0");
            }
            if (productDao.findById(item.getProductId()).isEmpty()) {
                throw new IllegalArgumentException("Sản phẩm #" + item.getProductId() + " không tồn tại");
            }
        }
    }
}
