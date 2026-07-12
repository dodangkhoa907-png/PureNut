package com.purenut.shop.dao;

import com.purenut.shop.model.User;
import java.util.List;
import java.util.Optional;

public interface UserDao {
    int insert(User user);
    Optional<User> findByEmail(String email);
    Optional<User> findById(int userId);
    boolean existsByEmail(String email);
    boolean updatePassword(int userId, String passwordHash);
    boolean updateProfile(int userId, String fullName, String phone);
    boolean updateLoginInfo(int userId, String ip);

    /** Nhân sự: danh sách user theo role (SHIPPER / MANAGER) */
    List<User> findByRole(String role);

    /** Admin: đổi role một user */
    boolean updateRole(int userId, String role);
}
