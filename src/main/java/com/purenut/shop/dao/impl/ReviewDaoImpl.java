package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.ReviewDao;
import com.purenut.shop.model.Review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReviewDaoImpl implements ReviewDao {

    @Override
    public int insert(Review review) {
        String sql = "INSERT INTO Reviews (ProductID, UserID, Rating, Comment, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, DATEADD(HOUR,7,GETUTCDATE()))";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setNString(4, review.getComment());
            int n = ps.executeUpdate();
            if (n > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ReviewDao] insert: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public List<Review> findByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.ReviewID, r.ProductID, r.UserID, r.Rating, r.Comment, r.CreatedAt, " +
                     "u.FullName, u.ProfileImage " +
                     "FROM Reviews r JOIN Users u ON r.UserID = u.UserID " +
                     "WHERE r.ProductID = ? ORDER BY r.CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("ReviewID"));
                    r.setProductId(rs.getInt("ProductID"));
                    r.setUserId(rs.getInt("UserID"));
                    r.setRating(rs.getInt("Rating"));
                    r.setComment(rs.getNString("Comment"));
                    r.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    r.setReviewerName(rs.getNString("FullName"));
                    r.setReviewerAvatar(rs.getNString("ProfileImage"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ReviewDao] findByProductId: " + e.getMessage());
        }
        return list;
    }
}
