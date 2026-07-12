package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.StaffMessageDao;
import com.purenut.shop.model.StaffMessage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffMessageDaoImpl implements StaffMessageDao {

    @Override
    public int insertChat(int userId, String message) {
        String sql = "INSERT INTO StaffMessages (UserID, Message) VALUES (?, ?)";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setNString(2, message);
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<StaffMessage> findChatAfter(int afterId) {
        List<StaffMessage> list = new ArrayList<>();
        String sql = (afterId > 0)
                ? "SELECT m.MessageID, m.UserID, m.Message, m.CreatedAt, u.FullName, u.Role " +
                  "FROM StaffMessages m JOIN Users u ON m.UserID = u.UserID " +
                  "WHERE m.MessageID > ? ORDER BY m.MessageID ASC"
                : "SELECT * FROM (" +
                  "  SELECT TOP 50 m.MessageID, m.UserID, m.Message, m.CreatedAt, u.FullName, u.Role " +
                  "  FROM StaffMessages m JOIN Users u ON m.UserID = u.UserID " +
                  "  ORDER BY m.MessageID DESC) t ORDER BY t.MessageID ASC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (afterId > 0) ps.setInt(1, afterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffMessage m = new StaffMessage();
                    m.setId(rs.getInt("MessageID"));
                    m.setUserId(rs.getInt("UserID"));
                    m.setMessage(rs.getNString("Message"));
                    m.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    m.setUserName(rs.getNString("FullName"));
                    m.setUserRole(rs.getString("Role"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int insertNote(int orderId, int userId, String message) {
        String sql = "INSERT INTO OrderNotes (OrderID, UserID, Message) VALUES (?, ?, ?)";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.setNString(3, message);
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<StaffMessage> findNotesByOrder(int orderId) {
        List<StaffMessage> list = new ArrayList<>();
        String sql = "SELECT n.NoteID, n.OrderID, n.UserID, n.Message, n.CreatedAt, u.FullName, u.Role " +
                     "FROM OrderNotes n JOIN Users u ON n.UserID = u.UserID " +
                     "WHERE n.OrderID = ? ORDER BY n.NoteID ASC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffMessage m = new StaffMessage();
                    m.setId(rs.getInt("NoteID"));
                    m.setOrderId(rs.getInt("OrderID"));
                    m.setUserId(rs.getInt("UserID"));
                    m.setMessage(rs.getNString("Message"));
                    m.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    m.setUserName(rs.getNString("FullName"));
                    m.setUserRole(rs.getString("Role"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
