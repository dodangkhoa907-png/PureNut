package com.purenut.shop.service.impl;

import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Product;
import com.purenut.shop.service.ProductService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Triển khai ProductService.
 * Chứa validation logic và điều phối DAO calls.
 * Không phụ thuộc Spring — Servlet khởi tạo bằng {@code new ProductServiceImpl()}.
 */
public class ProductServiceImpl implements ProductService {

    private final ProductDao productDao;

    /** Constructor mặc định cho Servlet. */
    public ProductServiceImpl() {
        this.productDao = new ProductDaoImpl();
    }

    /** Constructor tiêm DAO — dùng cho unit test mock. */
    public ProductServiceImpl(ProductDao productDao) {
        this.productDao = productDao;
    }

    // ── Customer-facing ─────────────────────────────────────────

    @Override
    public List<Product> getAllProducts() {
        return productDao.findAll();
    }

    @Override
    public List<Product> getFeaturedProducts() {
        return productDao.findFeatured();
    }

    @Override
    public List<Product> getProductsByCategory(String categorySlug) {
        if (categorySlug == null || categorySlug.isBlank()) {
            return productDao.findAll();
        }
        return productDao.findByCategory(categorySlug.trim());
    }

    @Override
    public Optional<Product> getProductBySlug(String slug) {
        if (slug == null || slug.isBlank()) return Optional.empty();
        return productDao.findBySlug(slug.trim());
    }

    @Override
    public List<Product> getRelatedProducts(int categoryId, int excludeId, int limit) {
        if (categoryId <= 0 || limit <= 0) return List.of();
        return productDao.findRelated(categoryId, excludeId, limit);
    }

    // ── Admin ───────────────────────────────────────────────────

    @Override
    public Optional<Product> getProductById(int productId) {
        if (productId <= 0) return Optional.empty();
        return productDao.findById(productId);
    }

    @Override
    public int createProduct(Product product) {
        validateProduct(product);
        // Tự tạo slug nếu không được truyền vào
        if (product.getSlug() == null || product.getSlug().isBlank()) {
            product.setSlug(toSlug(product.getName()));
        }
        return productDao.insert(product);
    }

    @Override
    public void updateProduct(Product product) {
        if (product.getProductId() <= 0) {
            throw new IllegalArgumentException("ProductID không hợp lệ");
        }
        validateProduct(product);
        if (product.getSlug() == null || product.getSlug().isBlank()) {
            product.setSlug(toSlug(product.getName()));
        }
        int rows = productDao.update(product);
        if (rows == 0) {
            throw new IllegalStateException("Không tìm thấy sản phẩm ID=" + product.getProductId());
        }
    }

    @Override
    public void deleteProduct(int productId) {
        if (productId <= 0) throw new IllegalArgumentException("ProductID không hợp lệ");
        productDao.softDelete(productId);
    }

    @Override
    public void toggleFeatured(int productId, boolean featured) {
        if (productId <= 0) throw new IllegalArgumentException("ProductID không hợp lệ");
        productDao.toggleFeatured(productId, featured);
    }

    @Override
    public void decreaseStock(int productId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("Số lượng phải > 0");
        int rows = productDao.adjustStock(productId, -quantity);
        if (rows == 0) {
            throw new IllegalStateException("Tồn kho không đủ cho sản phẩm ID=" + productId);
        }
    }

    @Override
    public void increaseStock(int productId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("Số lượng phải > 0");
        productDao.adjustStock(productId, quantity);
    }

    // ── Private helpers ─────────────────────────────────────────

    /**
     * Kiểm tra các trường bắt buộc của Product trước khi insert/update.
     * Validate phía server, không phụ thuộc frontend.
     */
    private void validateProduct(Product p) {
        if (p == null) throw new IllegalArgumentException("Product không được null");

        if (p.getName() == null || p.getName().isBlank()) {
            throw new IllegalArgumentException("Tên sản phẩm không được để trống");
        }
        if (p.getName().length() > 150) {
            throw new IllegalArgumentException("Tên sản phẩm tối đa 150 ký tự");
        }
        if (p.getPrice() == null || p.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Giá sản phẩm phải > 0");
        }
        if (p.getCategoryId() <= 0) {
            throw new IllegalArgumentException("Danh mục không hợp lệ");
        }
        if (p.getStockQuantity() < 0) {
            throw new IllegalArgumentException("Số lượng tồn kho không thể âm");
        }
        if (p.getVolumeMl() < 0) {
            throw new IllegalArgumentException("Dung tích không thể âm");
        }
        if (p.getKcalPer100ml() < 0) {
            throw new IllegalArgumentException("Kcal không thể âm");
        }
    }

    /**
     * Chuyển tên tiếng Việt thành slug URL-safe.
     * Ví dụ: "Đậu Nành Hạnh Nhân" → "dau-nanh-hanh-nhan"
     */
    public static String toSlug(String text) {
        if (text == null) return "";
        String s = text.trim().toLowerCase();

        // Bảng thay thế ký tự Unicode tiếng Việt
        s = s.replaceAll("[àáâãăạảấầẩẫậắằẳẵặ]", "a");
        s = s.replaceAll("[èéêẹẻẽếềểễệ]", "e");
        s = s.replaceAll("[ìíîïịỉĩ]", "i");
        s = s.replaceAll("[òóôõơọỏốồổỗộớờởỡợ]", "o");
        s = s.replaceAll("[ùúûüưụủứừửữự]", "u");
        s = s.replaceAll("[ỳýỷỹỵ]", "y");
        s = s.replaceAll("[đ]", "d");
        // Xoá ký tự đặc biệt còn lại, thay khoảng trắng bằng dấu gạch
        s = s.replaceAll("[^a-z0-9\\s-]", "");
        s = s.replaceAll("\\s+", "-");
        s = s.replaceAll("-+", "-");
        s = s.replaceAll("^-|-$", "");
        return s;
    }
}
