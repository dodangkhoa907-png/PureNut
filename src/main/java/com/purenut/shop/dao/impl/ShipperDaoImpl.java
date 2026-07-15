package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.ShipperDao;
import com.purenut.shop.model.Shipper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ShipperDaoImpl implements ShipperDao {

    @Override
    public Optional<Shipper> findById(int shipperId) {
        String sql = "SELECT * FROM Shippers WHERE ShipperID = ?";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ShipperDao] findById: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Shipper> findActive() {
        List<Shipper> list = new ArrayList<>();
        String sql = "SELECT * FROM Shippers WHERE Status = 'ACTIVE' ORDER BY FullName";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            System.err.println("[ShipperDao] findActive: " + e.getMessage());
        }
        return list;
    }

    @Override
    public List<Shipper> findAll() {
        List<Shipper> list = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "(SELECT COUNT(*) FROM Orders o WHERE o.ShipperID = s.ShipperID AND o.Status = 'SHIPPING') AS ActiveOrders, " +
                "(SELECT COUNT(*) FROM Orders o WHERE o.ShipperID = s.ShipperID AND o.Status = 'DONE') AS CompletedToday " +
                "FROM Shippers s ORDER BY s.Status DESC, s.FullName";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Shipper s = map(rs);
                s.setActiveOrders(rs.getInt("ActiveOrders"));
                s.setCompletedToday(rs.getInt("CompletedToday"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.err.println("[ShipperDao] findAll: " + e.getMessage());
        }
        return list;
    }

    @Override
    public void ensureProfile(int userId, String fullName, String phone) {
        String sql = "IF NOT EXISTS (SELECT 1 FROM Shippers WHERE ShipperID = ?) " +
                     "INSERT INTO Shippers (ShipperID, FullName, Phone, Status) VALUES (?, ?, ?, 'ACTIVE')";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setNString(3, fullName);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[ShipperDao] ensureProfile: " + e.getMessage());
        }
    }

    @Override
    public boolean updateStatus(int shipperId, String status) {
        if (!"ACTIVE".equals(status) && !"OFFLINE".equals(status)) return false;
        String sql = "UPDATE Shippers SET Status = ? WHERE ShipperID = ?";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, shipperId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ShipperDao] updateStatus: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateAllowedIp(int shipperId, String allowedIp, String vehiclePlate) {
        String sql = "UPDATE Shippers SET Allowed_IP = ?, VehiclePlate = ? WHERE ShipperID = ?";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, allowedIp);
            ps.setNString(2, vehiclePlate);
            ps.setInt(3, shipperId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ShipperDao] updateAllowedIp: " + e.getMessage());
        }
        return false;
    }

    private Shipper map(ResultSet rs) throws SQLException {
        Shipper s = new Shipper();
        s.setShipperId(rs.getInt("ShipperID"));
        s.setFullName(rs.getNString("FullName"));
        s.setPhone(rs.getString("Phone"));
        s.setVehiclePlate(rs.getNString("VehiclePlate"));
        s.setStatus(rs.getString("Status"));
        s.setAllowedIp(rs.getString("Allowed_IP"));
        s.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return s;
    }
}
