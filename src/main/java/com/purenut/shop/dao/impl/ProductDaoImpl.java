package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.model.Product;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Triển khai ProductDao dùng JDBC thuần + HikariCP.
 *
 * Mọi truy vấn đọc đều JOIN với Categories để populate
 * {@code categoryName} và {@code categorySlug} ngay trong một query.
 * Không nối chuỗi SQL thủ công — dùng PreparedStatement toàn bộ.
 */
public class ProductDaoImpl implements ProductDao {

    // ── Base SELECT (dùng chung cho nhiều query) ────────────────
    private static final String BASE_SELECT =
            "SELECT p.ProductID, p.Name, p.Slug, p.CategoryID, p.Description, " +
            "       p.Price, p.ImageUrl, p.BgColorHex, p.VolumeMl, p.KcalPer100ml, " +
            "       p.StockQuantity, p.IsFeatured, p.IsDeleted, p.CreatedAt, " +
            "       c.Name AS CategoryName, c.Slug AS CategorySlug " +
            "FROM Products p " +
            "LEFT JOIN Categories c ON p.CategoryID = c.CategoryID ";

    private static final String WHERE_NOT_DELETED = "WHERE p.IsDeleted = 0 ";

    // ── SQL constants ───────────────────────────────────────────
    private static final String SQL_FIND_ALL =
            BASE_SELECT + WHERE_NOT_DELETED + "ORDER BY p.CreatedAt DESC";

    private static final String SQL_FIND_FEATURED =
            BASE_SELECT + WHERE_NOT_DELETED + "AND p.IsFeatured = 1 ORDER BY p.CreatedAt DESC";

    private static final String SQL_FIND_BY_CATEGORY =
            BASE_SELECT + WHERE_NOT_DELETED + "AND c.Slug = ? ORDER BY p.CreatedAt DESC";

    private static final String SQL_FIND_BY_SLUG =
            BASE_SELECT + "WHERE p.Slug = ? AND p.IsDeleted = 0";

    private static final String SQL_FIND_BY_ID =
            BASE_SELECT + "WHERE p.ProductID = ? AND p.IsDeleted = 0";

    private static final String SQL_FIND_RELATED =
            BASE_SELECT + WHERE_NOT_DELETED +
            "AND p.CategoryID = ? AND p.ProductID != ? " +
            "ORDER BY NEWID() OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

    private static final String SQL_INSERT =
            "INSERT INTO Products " +
            "(Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, " +
            " VolumeMl, KcalPer100ml, StockQuantity, IsFeatured) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

    private static final String SQL_UPDATE =
            "UPDATE Products SET " +
            "Name=?, Slug=?, CategoryID=?, Description=?, Price=?, ImageUrl=?, " +
            "BgColorHex=?, VolumeMl=?, KcalPer100ml=?, StockQuantity=?, IsFeatured=? " +
            "WHERE ProductID=? AND IsDeleted=0";

    private static final String SQL_SOFT_DELETE =
            "UPDATE Products SET IsDeleted=1 WHERE ProductID=?";

    private static final String SQL_TOGGLE_FEATURED =
            "UPDATE Products SET IsFeatured=? WHERE ProductID=? AND IsDeleted=0";

    private static final String SQL_ADJUST_STOCK =
            "UPDATE Products SET StockQuantity = StockQuantity + ? " +
            "WHERE ProductID=? AND IsDeleted=0 AND StockQuantity + ? >= 0";

    // ── Public API: Read ────────────────────────────────────────

    @Override
    public List<Product> findAll() {
        return queryList(SQL_FIND_ALL);
    }

    @Override
    public List<Product> findFeatured() {
        return queryList(SQL_FIND_FEATURED);
    }

    @Override
    public List<Product> findByCategory(String categorySlug) {
        List<Product> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_CATEGORY)) {

            ps.setString(1, categorySlug);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.findByCategory thất bại: " + categorySlug, e);
        }
        return list;
    }

    @Override
    public Optional<Product> findBySlug(String slug) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_SLUG)) {

            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.findBySlug thất bại: " + slug, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Product> findById(int productId) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.findById thất bại: " + productId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Product> findRelated(int categoryId, int excludeId, int limit) {
        List<Product> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_RELATED)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, excludeId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.findRelated thất bại", e);
        }
        return list;
    }

    @Override
    public List<Product> searchByName(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = BASE_SELECT + WHERE_NOT_DELETED + "AND p.Name LIKE ? ORDER BY p.CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setNString(1, "%" + keyword + "%"); // NVARCHAR: khớp đúng tiếng Việt có dấu
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.searchByName thất bại", e);
        }
        return list;
    }

    // ── Public API: Write (Admin) ───────────────────────────────

    @Override
    public int insert(Product p) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_INSERT,
                     Statement.RETURN_GENERATED_KEYS)) {

            bindInsert(ps, p);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.insert thất bại", e);
        }
        return -1;
    }

    @Override
    public int update(Product p) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {

            bindUpdate(ps, p);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.update thất bại: " + p.getProductId(), e);
        }
    }

    @Override
    public int softDelete(int productId) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_SOFT_DELETE)) {

            ps.setInt(1, productId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.softDelete thất bại: " + productId, e);
        }
    }

    @Override
    public int toggleFeatured(int productId, boolean featured) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_TOGGLE_FEATURED)) {

            ps.setBoolean(1, featured);
            ps.setInt(2, productId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.toggleFeatured thất bại: " + productId, e);
        }
    }

    @Override
    public int adjustStock(int productId, int delta) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_ADJUST_STOCK)) {

            ps.setInt(1, delta);
            ps.setInt(2, productId);
            ps.setInt(3, delta); // dùng lại delta trong điều kiện CHECK >= 0
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.adjustStock thất bại: " + productId, e);
        }
    }

    // ── Private helpers ─────────────────────────────────────────

    /** Thực thi query không tham số, trả về danh sách Product. */
    private List<Product> queryList(String sql) {
        List<Product> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new RuntimeException("ProductDao.queryList thất bại: " + sql, e);
        }
        return list;
    }

    /** Ánh xạ một hàng ResultSet → Product. */
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("ProductID"));
        p.setName(rs.getString("Name"));
        p.setSlug(rs.getString("Slug"));
        p.setCategoryId(rs.getInt("CategoryID"));
        p.setDescription(rs.getString("Description"));

        BigDecimal price = rs.getBigDecimal("Price");
        p.setPrice(price != null ? price : BigDecimal.ZERO);

        p.setImageUrl(rs.getString("ImageUrl"));
        p.setBgColorHex(rs.getString("BgColorHex"));
        p.setVolumeMl(rs.getInt("VolumeMl"));
        p.setKcalPer100ml(rs.getInt("KcalPer100ml"));
        p.setStockQuantity(rs.getInt("StockQuantity"));
        p.setFeatured(rs.getBoolean("IsFeatured"));
        p.setDeleted(rs.getBoolean("IsDeleted"));

        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) p.setCreatedAt(ts.toLocalDateTime());

        // JOIN fields
        p.setCategoryName(rs.getString("CategoryName"));
        p.setCategorySlug(rs.getString("CategorySlug"));

        return p;
    }

    /** Bind tham số cho INSERT (không có ProductID — IDENTITY). */
    private void bindInsert(PreparedStatement ps, Product p) throws SQLException {
        ps.setString(1, p.getName());
        ps.setString(2, p.getSlug());
        ps.setInt(3, p.getCategoryId());
        ps.setString(4, p.getDescription());
        ps.setBigDecimal(5, p.getPrice());
        ps.setString(6, p.getImageUrl());
        ps.setString(7, p.getBgColorHex());
        ps.setInt(8, p.getVolumeMl());
        ps.setInt(9, p.getKcalPer100ml());
        ps.setInt(10, p.getStockQuantity());
        ps.setBoolean(11, p.isFeatured());
    }

    /** Bind tham số cho UPDATE (có ProductID ở cuối). */
    private void bindUpdate(PreparedStatement ps, Product p) throws SQLException {
        ps.setString(1, p.getName());
        ps.setString(2, p.getSlug());
        ps.setInt(3, p.getCategoryId());
        ps.setString(4, p.getDescription());
        ps.setBigDecimal(5, p.getPrice());
        ps.setString(6, p.getImageUrl());
        ps.setString(7, p.getBgColorHex());
        ps.setInt(8, p.getVolumeMl());
        ps.setInt(9, p.getKcalPer100ml());
        ps.setInt(10, p.getStockQuantity());
        ps.setBoolean(11, p.isFeatured());
        ps.setInt(12, p.getProductId());  // WHERE ProductID=?
    }
}
