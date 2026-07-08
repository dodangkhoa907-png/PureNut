package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.UserAddressDao;
import com.purenut.shop.model.UserAddress;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAddressDaoImpl implements UserAddressDao {

    @Override
    public List<UserAddress> findByUserId(int userId) {
        List<UserAddress> list = new ArrayList<>();
        String sql = "SELECT * FROM UserAddresses WHERE UserID = ? ORDER BY IsDefault DESC, CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("UserAddressDao.findByUserId failed", e);
        }
        return list;
    }

    @Override
    public int insert(UserAddress a) {
        String sql = "INSERT INTO UserAddresses (UserID,Label,RecipientName,Phone,Province,District,Ward,Street,IsDefault) "
                   + "VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getUserId());
            ps.setNString(2, a.getLabel());
            ps.setNString(3, a.getRecipientName());
            ps.setString(4, a.getPhone());
            ps.setNString(5, a.getProvince());
            ps.setNString(6, a.getDistrict());
            ps.setNString(7, a.getWard());
            ps.setNString(8, a.getStreet());
            ps.setBoolean(9, a.isDefault());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("UserAddressDao.insert failed", e);
        }
        return -1;
    }

    @Override
    public boolean delete(int addressId, int userId) {
        String sql = "DELETE FROM UserAddresses WHERE AddressID = ? AND UserID = ?";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("UserAddressDao.delete failed", e);
        }
    }

    @Override
    public boolean setDefault(int addressId, int userId) {
        try (Connection con = Database.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement resetPs = con.prepareStatement(
                    "UPDATE UserAddresses SET IsDefault = 0 WHERE UserID = ?")) {
                resetPs.setInt(1, userId);
                resetPs.executeUpdate();
            }
            try (PreparedStatement setPs = con.prepareStatement(
                    "UPDATE UserAddresses SET IsDefault = 1 WHERE AddressID = ? AND UserID = ?")) {
                setPs.setInt(1, addressId);
                setPs.setInt(2, userId);
                setPs.executeUpdate();
            }
            con.commit();
            return true;
        } catch (SQLException e) {
            throw new RuntimeException("UserAddressDao.setDefault failed", e);
        }
    }

    private UserAddress map(ResultSet rs) throws SQLException {
        UserAddress a = new UserAddress();
        a.setAddressId(rs.getInt("AddressID"));
        a.setUserId(rs.getInt("UserID"));
        a.setLabel(rs.getNString("Label"));
        a.setRecipientName(rs.getNString("RecipientName"));
        a.setPhone(rs.getString("Phone"));
        a.setProvince(rs.getNString("Province"));
        a.setDistrict(rs.getNString("District"));
        a.setWard(rs.getNString("Ward"));
        a.setStreet(rs.getNString("Street"));
        a.setDefault(rs.getBoolean("IsDefault"));
        a.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return a;
    }
}
