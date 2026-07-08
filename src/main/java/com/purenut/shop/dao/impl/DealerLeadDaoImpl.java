package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.DealerLeadDao;
import com.purenut.shop.model.DealerLead;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DealerLeadDaoImpl implements DealerLeadDao {

    @Override
    public int insert(DealerLead lead) {
        String sql = "INSERT INTO DealerLeads (FullName, Phone, Email, City) VALUES (?, ?, ?, ?)";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setNString(1, lead.getFullName());
            ps.setString(2, lead.getPhone());
            ps.setString(3, lead.getEmail());
            ps.setNString(4, lead.getCity());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<DealerLead> findAll() {
        List<DealerLead> list = new ArrayList<>();
        String sql = "SELECT * FROM DealerLeads ORDER BY CreatedAt DESC";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                DealerLead lead = new DealerLead();
                lead.setLeadId(rs.getInt("LeadID"));
                lead.setFullName(rs.getNString("FullName"));
                lead.setPhone(rs.getString("Phone"));
                lead.setEmail(rs.getString("Email"));
                lead.setCity(rs.getNString("City"));
                lead.setStatus(rs.getString("Status"));
                lead.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(lead);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int updateStatus(int leadId, String status) {
        String sql = "UPDATE DealerLeads SET Status = ? WHERE LeadID = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, status);
            ps.setInt(2, leadId);
            return ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
