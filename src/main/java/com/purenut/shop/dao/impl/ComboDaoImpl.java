package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.ComboDao;
import com.purenut.shop.model.Combo;
import com.purenut.shop.model.ComboItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Triển khai ComboDao dùng JDBC thuần + HikariCP.
 * insert/update chạm cả bảng Combos lẫn ComboItems nên chạy trong 1
 * transaction thủ công (giống OrderDaoImpl.placeOrder), khai báo throws Exception.
 */
public class ComboDaoImpl implements ComboDao {

    private static final String BASE_SELECT_COMBO =
            "SELECT ComboID, Name, Slug, Description, ImageUrl, ComboPrice, IsActive, IsDeleted, CreatedAt " +
            "FROM Combos ";

    private static final String SQL_FIND_ALL_ACTIVE =
            BASE_SELECT_COMBO + "WHERE IsActive=1 AND IsDeleted=0 ORDER BY CreatedAt DESC";

    private static final String SQL_FIND_ALL_ADMIN =
            BASE_SELECT_COMBO + "WHERE IsDeleted=0 ORDER BY CreatedAt DESC";

    private static final String SQL_FIND_BY_ID =
            BASE_SELECT_COMBO + "WHERE ComboID=? AND IsDeleted=0";

    private static final String SQL_FIND_BY_SLUG =
            BASE_SELECT_COMBO + "WHERE Slug=? AND IsDeleted=0";

    private static final String SQL_FIND_ITEMS =
            "SELECT ci.ComboItemID, ci.ComboID, ci.ProductID, ci.Quantity, " +
            "       p.Name AS ProductName, p.ImageUrl AS ProductImageUrl, p.Price AS ProductPrice " +
            "FROM ComboItems ci JOIN Products p ON ci.ProductID = p.ProductID " +
            "WHERE ci.ComboID = ?";

    private static final String SQL_FIND_ACTIVE_FOR_PRODUCT =
            BASE_SELECT_COMBO +
            "WHERE IsActive=1 AND IsDeleted=0 AND ComboID IN " +
            "(SELECT ComboID FROM ComboItems WHERE ProductID = ?)";

    private static final String SQL_INSERT_COMBO =
            "INSERT INTO Combos (Name, Slug, Description, ImageUrl, ComboPrice, IsActive) VALUES (?,?,?,?,?,?)";

    private static final String SQL_INSERT_ITEM =
            "INSERT INTO ComboItems (ComboID, ProductID, Quantity) VALUES (?,?,?)";

    private static final String SQL_UPDATE_COMBO =
            "UPDATE Combos SET Name=?, Slug=?, Description=?, ImageUrl=?, ComboPrice=?, IsActive=? " +
            "WHERE ComboID=? AND IsDeleted=0";

    private static final String SQL_DELETE_ITEMS =
            "DELETE FROM ComboItems WHERE ComboID=?";

    private static final String SQL_SOFT_DELETE =
            "UPDATE Combos SET IsDeleted=1 WHERE ComboID=?";

    private static final String SQL_SLUG_EXISTS =
            "SELECT COUNT(*) FROM Combos WHERE Slug=? AND ComboID<>? AND IsDeleted=0";

    // ── Read ─────────────────────────────────────────────────────

    @Override
    public List<Combo> findAllActive() {
        return queryList(SQL_FIND_ALL_ACTIVE);
    }

    @Override
    public List<Combo> findAllForAdmin() {
        return queryList(SQL_FIND_ALL_ADMIN);
    }

    @Override
    public Optional<Combo> findById(int comboId) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Combo combo = mapRow(rs);
                    combo.setItems(findItemsByComboId(combo.getComboId()));
                    return Optional.of(combo);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.findById thất bại: " + comboId, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Combo> findBySlug(String slug) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_SLUG)) {

            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Combo combo = mapRow(rs);
                    combo.setItems(findItemsByComboId(combo.getComboId()));
                    return Optional.of(combo);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.findBySlug thất bại: " + slug, e);
        }
        return Optional.empty();
    }

    @Override
    public List<ComboItem> findItemsByComboId(int comboId) {
        List<ComboItem> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_ITEMS)) {

            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapItemRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.findItemsByComboId thất bại: " + comboId, e);
        }
        return list;
    }

    @Override
    public List<Combo> findActiveCombosContainingProduct(int productId) {
        List<Combo> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_ACTIVE_FOR_PRODUCT)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Combo combo = mapRow(rs);
                    combo.setItems(findItemsByComboId(combo.getComboId()));
                    list.add(combo);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.findActiveCombosContainingProduct thất bại: " + productId, e);
        }
        return list;
    }

    @Override
    public boolean slugExists(String slug, int excludeComboId) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_SLUG_EXISTS)) {

            ps.setString(1, slug);
            ps.setInt(2, excludeComboId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.slugExists thất bại: " + slug, e);
        }
    }

    // ── Write (Admin) ────────────────────────────────────────────

    @Override
    public int insert(Combo combo, List<ComboItem> items) throws Exception {
        Connection conn = null;
        int comboId;
        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(SQL_INSERT_COMBO, Statement.RETURN_GENERATED_KEYS)) {
                bindCombo(ps, combo);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Không thể lấy ComboID");
                    comboId = keys.getInt(1);
                }
            }

            insertItems(conn, comboId, items);

            conn.commit();
            return comboId;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    @Override
    public void update(Combo combo, List<ComboItem> items) throws Exception {
        Connection conn = null;
        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_COMBO)) {
                bindCombo(ps, combo);
                ps.setInt(7, combo.getComboId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(SQL_DELETE_ITEMS)) {
                ps.setInt(1, combo.getComboId());
                ps.executeUpdate();
            }
            insertItems(conn, combo.getComboId(), items);

            conn.commit();
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    @Override
    public void softDelete(int comboId) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_SOFT_DELETE)) {

            ps.setInt(1, comboId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.softDelete thất bại: " + comboId, e);
        }
    }

    // ── Private helpers ──────────────────────────────────────────

    private void insertItems(Connection conn, int comboId, List<ComboItem> items) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(SQL_INSERT_ITEM)) {
            for (ComboItem item : items) {
                ps.setInt(1, comboId);
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /** Danh sách combo kèm items — dùng cho trang list (admin/khách) hiển thị sản phẩm trong combo. */
    private List<Combo> queryList(String sql) {
        List<Combo> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Combo combo = mapRow(rs);
                combo.setItems(findItemsByComboId(combo.getComboId()));
                list.add(combo);
            }
        } catch (SQLException e) {
            throw new RuntimeException("ComboDao.queryList thất bại: " + sql, e);
        }
        return list;
    }

    /** Bind Name, Slug, Description, ImageUrl, ComboPrice, IsActive (thứ tự dùng chung cho INSERT lẫn UPDATE). */
    private void bindCombo(PreparedStatement ps, Combo c) throws SQLException {
        ps.setString(1, c.getName());
        ps.setString(2, c.getSlug());
        ps.setString(3, c.getDescription());
        ps.setString(4, c.getImageUrl());
        ps.setBigDecimal(5, c.getComboPrice());
        ps.setBoolean(6, c.isActive());
    }

    private Combo mapRow(ResultSet rs) throws SQLException {
        Combo c = new Combo();
        c.setComboId(rs.getInt("ComboID"));
        c.setName(rs.getString("Name"));
        c.setSlug(rs.getString("Slug"));
        c.setDescription(rs.getString("Description"));
        c.setImageUrl(rs.getString("ImageUrl"));

        BigDecimal price = rs.getBigDecimal("ComboPrice");
        c.setComboPrice(price != null ? price : BigDecimal.ZERO);

        c.setActive(rs.getBoolean("IsActive"));
        c.setDeleted(rs.getBoolean("IsDeleted"));

        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) c.setCreatedAt(ts.toLocalDateTime());

        return c;
    }

    private ComboItem mapItemRow(ResultSet rs) throws SQLException {
        ComboItem item = new ComboItem();
        item.setComboItemId(rs.getInt("ComboItemID"));
        item.setComboId(rs.getInt("ComboID"));
        item.setProductId(rs.getInt("ProductID"));
        item.setQuantity(rs.getInt("Quantity"));
        item.setProductName(rs.getNString("ProductName"));
        item.setProductImageUrl(rs.getString("ProductImageUrl"));

        BigDecimal price = rs.getBigDecimal("ProductPrice");
        item.setProductPrice(price != null ? price : BigDecimal.ZERO);

        return item;
    }
}
