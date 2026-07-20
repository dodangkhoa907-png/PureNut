package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.CartComboItemDao;
import com.purenut.shop.model.CartComboItem;
import com.purenut.shop.model.ComboItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartComboItemDaoImpl implements CartComboItemDao {

    private static final String SQL_FIND_ITEMS =
            "SELECT ci.ComboItemID, ci.ComboID, ci.ProductID, ci.Quantity, " +
            "       p.Name AS ProductName, p.ImageUrl AS ProductImageUrl, p.Price AS ProductPrice " +
            "FROM ComboItems ci JOIN Products p ON ci.ProductID = p.ProductID " +
            "WHERE ci.ComboID = ?";

    @Override
    public List<CartComboItem> findByUserId(int userId) {
        List<CartComboItem> list = new ArrayList<>();
        String sql = "SELECT cc.*, c.Name AS ComboName, c.Slug AS ComboSlug, " +
                     "       c.ComboPrice, c.ImageUrl " +
                     "FROM CartComboItems cc " +
                     "JOIN Combos c ON cc.ComboID = c.ComboID " +
                     "WHERE cc.UserID = ? " +
                     "ORDER BY cc.CreatedAt DESC";

        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartComboItem item = new CartComboItem();
                    item.setCartComboItemId(rs.getInt("CartComboItemID"));
                    item.setUserId(rs.getInt("UserID"));
                    item.setComboId(rs.getInt("ComboID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    // Thuộc tính nối bảng
                    item.setComboName(rs.getNString("ComboName"));
                    item.setComboSlug(rs.getString("ComboSlug"));
                    item.setComboPrice(rs.getBigDecimal("ComboPrice"));
                    item.setImageUrl(rs.getString("ImageUrl"));

                    item.setItems(findItemsByComboId(conn, item.getComboId()));

                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Danh sách sản phẩm cố định trong combo, dùng chung connection để tránh mở thêm pool connection cho mỗi dòng giỏ. */
    private List<ComboItem> findItemsByComboId(Connection conn, int comboId) throws SQLException {
        List<ComboItem> items = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(SQL_FIND_ITEMS)) {
            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComboItem item = new ComboItem();
                    item.setComboItemId(rs.getInt("ComboItemID"));
                    item.setComboId(rs.getInt("ComboID"));
                    item.setProductId(rs.getInt("ProductID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setProductName(rs.getNString("ProductName"));
                    item.setProductImageUrl(rs.getString("ProductImageUrl"));
                    BigDecimal price = rs.getBigDecimal("ProductPrice");
                    item.setProductPrice(price != null ? price : BigDecimal.ZERO);
                    items.add(item);
                }
            }
        }
        return items;
    }

    @Override
    public int insertOrUpdate(int userId, int comboId, int quantity) {
        String checkSql = "SELECT CartComboItemID, Quantity FROM CartComboItems WHERE UserID = ? AND ComboID = ?";

        try (Connection conn = Database.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setInt(1, userId);
            checkPs.setInt(2, comboId);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    int cartComboItemId = rs.getInt("CartComboItemID");
                    int newQuantity = rs.getInt("Quantity") + quantity;

                    try (PreparedStatement updatePs = conn.prepareStatement(
                            "UPDATE CartComboItems SET Quantity = ? WHERE CartComboItemID = ?")) {
                        updatePs.setInt(1, newQuantity);
                        updatePs.setInt(2, cartComboItemId);
                        updatePs.executeUpdate();
                    }
                    return cartComboItemId;
                } else {
                    try (PreparedStatement insertPs = conn.prepareStatement(
                            "INSERT INTO CartComboItems (UserID, ComboID, Quantity) VALUES (?, ?, ?)",
                            Statement.RETURN_GENERATED_KEYS)) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, comboId);
                        insertPs.setInt(3, quantity);
                        insertPs.executeUpdate();

                        try (ResultSet insertRs = insertPs.getGeneratedKeys()) {
                            if (insertRs.next()) return insertRs.getInt(1);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void updateQuantity(int cartComboItemId, int userId, int quantity) {
        if (quantity < 1) quantity = 1;
        String sql = "UPDATE CartComboItems SET Quantity = ? WHERE CartComboItemID = ? AND UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartComboItemId);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int cartComboItemId, int userId) {
        String sql = "DELETE FROM CartComboItems WHERE CartComboItemID = ? AND UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartComboItemId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearForUser(int userId) {
        String sql = "DELETE FROM CartComboItems WHERE UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
