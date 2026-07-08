package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.AuditLogDao;
import com.purenut.shop.model.AuditLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDaoImpl implements AuditLogDao {

    @Override
    public boolean insert(AuditLog log) {
        String sql = "INSERT INTO AuditLogs (UserID, Action, Target, Detail, IpAddress) VALUES (?,?,?,?,?)";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (log.getUserId() == null) ps.setNull(1, Types.INTEGER); else ps.setInt(1, log.getUserId());
            ps.setNString(2, log.getAction());
            ps.setNString(3, log.getTarget());
            ps.setNString(4, log.getDetail());
            ps.setString(5, log.getIpAddress());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Không chặn luồng chính nếu bảng chưa tồn tại / lỗi ghi log
            System.err.println("[AuditLog] Không ghi được log: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<AuditLog> findRecent(int limit) {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT TOP (?) a.*, u.FullName AS UserName " +
                     "FROM AuditLogs a LEFT JOIN Users u ON a.UserID = u.UserID " +
                     "ORDER BY a.CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog a = new AuditLog();
                    a.setLogId(rs.getInt("LogID"));
                    int uid = rs.getInt("UserID");
                    a.setUserId(rs.wasNull() ? null : uid);
                    a.setUserName(rs.getNString("UserName"));
                    a.setAction(rs.getNString("Action"));
                    a.setTarget(rs.getNString("Target"));
                    a.setDetail(rs.getNString("Detail"));
                    a.setIpAddress(rs.getString("IpAddress"));
                    a.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.err.println("[AuditLog] Không đọc được log: " + e.getMessage());
        }
        return list;
    }
}
