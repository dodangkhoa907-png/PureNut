package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.CartItemDao;
import com.purenut.shop.model.CartItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartItemDaoImpl implements CartItemDao {

    @Override
    public int insertOrUpdate(int userId, int productId, int quantity) {
        // Kiểm tra xem sản phẩm đã có trong giỏ chưa
        String checkSql = "SELECT CartItemID, Quantity FROM CartItems WHERE UserID = ? AND ProductID = ?";
        
        try (Connection conn = Database.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
             
            checkPs.setInt(1, userId);
            checkPs.setInt(2, productId);
            
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Update số lượng
                    int cartItemId = rs.getInt("CartItemID");
                    int newQuantity = rs.getInt("Quantity") + quantity;
                    
                    String updateSql = "UPDATE CartItems SET Quantity = ? WHERE CartItemID = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, newQuantity);
                        updatePs.setInt(2, cartItemId);
                        updatePs.executeUpdate();
                    }
                    return cartItemId;
                } else {
                    // Thêm mới
                    String insertSql = "INSERT INTO CartItems (UserID, ProductID, Quantity) VALUES (?, ?, ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, productId);
                        insertPs.setInt(3, quantity);
                        insertPs.executeUpdate();
                        
                        try (ResultSet insertRs = insertPs.getGeneratedKeys()) {
                            if (insertRs.next()) {
                                return insertRs.getInt(1);
                            }
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
    public List<CartItem> findByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.*, p.Name AS ProductName, p.Price AS ProductPrice, p.Slug AS ProductSlug, " +
                     "       p.ImageUrl, p.BgColorHex, p.VolumeMl " +
                     "FROM CartItems c " +
                     "JOIN Products p ON c.ProductID = p.ProductID " +
                     "WHERE c.UserID = ? " +
                     "ORDER BY c.CreatedAt DESC";
                     
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("CartItemID"));
                    item.setUserId(rs.getInt("UserID"));
                    item.setProductId(rs.getInt("ProductID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    
                    // Thuộc tính nối bảng
                    item.setProductName(rs.getNString("ProductName"));
                    item.setProductPrice(rs.getBigDecimal("ProductPrice"));
                    item.setProductSlug(rs.getString("ProductSlug"));
                    item.setImageUrl(rs.getString("ImageUrl"));
                    item.setBgColorHex(rs.getString("BgColorHex"));
                    item.setVolumeMl(rs.getInt("VolumeMl"));
                    
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateQuantity(int cartItemId, int userId, int quantity) {
        if (quantity < 1) quantity = 1;
        String sql = "UPDATE CartItems SET Quantity = ? WHERE CartItemID = ? AND UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            ps.setInt(3, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int countItems(int userId) {
        String sql = "SELECT COALESCE(SUM(Quantity), 0) AS Cnt FROM CartItems WHERE UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("Cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void delete(int cartItemId, int userId) {
        String sql = "DELETE FROM CartItems WHERE CartItemID = ? AND UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, cartItemId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearCart(int userId) {
        String sql = "DELETE FROM CartItems WHERE UserID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
