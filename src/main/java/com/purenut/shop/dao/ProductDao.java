package com.purenut.shop.dao;

import com.purenut.shop.model.Product;

import java.util.List;
import java.util.Optional;

/**
 * DAO interface cho bảng Products.
 * Mọi truy vấn đọc JOIN với Categories để populate categoryName/categorySlug.
 * Implementation: {@link com.purenut.shop.dao.impl.ProductDaoImpl}
 */
public interface ProductDao {

    /** Tất cả sản phẩm chưa bị xoá mềm (IsDeleted = 0). */
    List<Product> findAll();

    /** Sản phẩm nổi bật (IsFeatured = 1, IsDeleted = 0). */
    List<Product> findFeatured();

    /**
     * Lọc sản phẩm theo category slug.
     * @param categorySlug slug của danh mục (ví dụ "dau-nanh")
     */
    List<Product> findByCategory(String categorySlug);

    /**
     * Tìm sản phẩm theo slug (unique).
     * @param slug slug của sản phẩm
     */
    Optional<Product> findBySlug(String slug);

    /**
     * Tìm sản phẩm liên quan: cùng category, không phải sản phẩm hiện tại.
     * @param categoryId    ID danh mục
     * @param excludeId     ID sản phẩm cần loại trừ
     * @param limit         số lượng tối đa trả về
     */
    List<Product> findRelated(int categoryId, int excludeId, int limit);

    /**
     * Tìm sản phẩm theo ID (dùng trong Admin).
     * @param productId ID sản phẩm
     */
    Optional<Product> findById(int productId);

    /**
     * Tìm kiếm sản phẩm theo tên.
     */
    List<Product> searchByName(String keyword);

    // ── Admin CRUD ─────────────────────────────────────────────────────────

    /**
     * Thêm sản phẩm mới, trả về productId vừa tạo.
     */
    int insert(Product product);

    /**
     * Cập nhật thông tin sản phẩm.
     * @return số dòng bị ảnh hưởng (0 = không tìm thấy)
     */
    int update(Product product);

    /**
     * Xoá mềm (IsDeleted = 1) — KHÔNG xoá vật lý khỏi DB.
     * @return số dòng bị ảnh hưởng
     */
    int softDelete(int productId);

    /**
     * Bật/tắt trạng thái nổi bật.
     * @return số dòng bị ảnh hưởng
     */
    int toggleFeatured(int productId, boolean featured);

    /**
     * Cập nhật số lượng tồn kho (dùng khi đặt hàng / nhập hàng).
     * @param delta số lượng thay đổi (âm = giảm, dương = tăng)
     */
    int adjustStock(int productId, int delta);
}
