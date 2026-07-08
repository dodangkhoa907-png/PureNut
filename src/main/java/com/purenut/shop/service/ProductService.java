package com.purenut.shop.service;

import com.purenut.shop.model.Product;

import java.util.List;
import java.util.Optional;

/**
 * Service interface cho Product.
 * Chứa business logic và validation trước khi gọi DAO.
 * Implementation: {@link com.purenut.shop.service.impl.ProductServiceImpl}
 */
public interface ProductService {

    // ── Customer-facing queries ─────────────────────────────────

    /** Tất cả sản phẩm chưa bị xoá mềm. */
    List<Product> getAllProducts();

    /** Sản phẩm nổi bật (IsFeatured=1) — hiển thị ở trang chủ. */
    List<Product> getFeaturedProducts();

    /**
     * Lọc sản phẩm theo slug danh mục.
     * Nếu categorySlug là null hoặc rỗng → trả về toàn bộ sản phẩm.
     */
    List<Product> getProductsByCategory(String categorySlug);

    /**
     * Lấy chi tiết sản phẩm theo slug.
     * @throws jakarta.servlet.ServletException nếu không tìm thấy
     */
    Optional<Product> getProductBySlug(String slug);

    /**
     * Lấy sản phẩm liên quan (cùng category, khác sản phẩm hiện tại).
     * @param categoryId    ID danh mục
     * @param excludeId     ID sản phẩm cần loại trừ
     * @param limit         giới hạn số lượng (thường 3–4)
     */
    List<Product> getRelatedProducts(int categoryId, int excludeId, int limit);

    // ── Admin operations ────────────────────────────────────────

    /** Tìm sản phẩm theo ID (cho form edit). */
    Optional<Product> getProductById(int productId);

    /**
     * Tạo sản phẩm mới.
     * @return productId vừa được tạo
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    int createProduct(Product product);

    /**
     * Cập nhật sản phẩm.
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    void updateProduct(Product product);

    /** Xoá mềm (IsDeleted=1). */
    void deleteProduct(int productId);

    /** Bật/tắt trạng thái nổi bật. */
    void toggleFeatured(int productId, boolean featured);

    /**
     * Giảm tồn kho khi đặt hàng thành công.
     * @param productId ID sản phẩm
     * @param quantity  số lượng đặt
     * @throws IllegalStateException nếu tồn kho không đủ
     */
    void decreaseStock(int productId, int quantity);

    /**
     * Tăng tồn kho khi nhập hàng hoặc huỷ đơn.
     */
    void increaseStock(int productId, int quantity);
}
