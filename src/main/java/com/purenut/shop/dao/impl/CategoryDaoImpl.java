package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.CategoryDao;
import com.purenut.shop.model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Triển khai CategoryDao dùng JDBC thuần + HikariCP connection pool.
 * Mọi Connection/Statement/ResultSet đóng qua try-with-resources.
 */
public class CategoryDaoImpl implements CategoryDao {

    // ── SQL constants ───────────────────────────────────────────
    private static final String SQL_FIND_ALL =
            "SELECT CategoryID, Name, Slug FROM Categories ORDER BY Name";

    private static final String SQL_FIND_BY_SLUG =
            "SELECT CategoryID, Name, Slug FROM Categories WHERE Slug = ?";

    private static final String SQL_FIND_BY_ID =
            "SELECT CategoryID, Name, Slug FROM Categories WHERE CategoryID = ?";

    // ── Public API ──────────────────────────────────────────────

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("CategoryDao.findAll thất bại", e);
        }
        return list;
    }

    @Override
    public Optional<Category> findBySlug(String slug) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_SLUG)) {

            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("CategoryDao.findBySlug thất bại: " + slug, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Category> findById(int id) {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("CategoryDao.findById thất bại: " + id, e);
        }
        return Optional.empty();
    }

    // ── Private helpers ─────────────────────────────────────────

    private Category mapRow(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("CategoryID"),
                rs.getString("Name"),
                rs.getString("Slug")
        );
    }
}
