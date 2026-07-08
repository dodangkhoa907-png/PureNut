package com.purenut.shop.service.impl;

import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.User;
import com.purenut.shop.service.UserService;
import com.purenut.shop.util.Passwords;
import com.purenut.shop.util.Validators;

import java.util.Optional;

public class UserServiceImpl implements UserService {

    private final UserDao userDao;

    public UserServiceImpl() {
        this.userDao = new UserDaoImpl();
    }

    @Override
    public Optional<User> authenticate(String email, String rawPassword) {
        if (email == null || rawPassword == null) return Optional.empty();

        Optional<User> userOpt = userDao.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (Passwords.matches(rawPassword, user.getPasswordHash())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    @Override
    public User register(String fullName, String email, String phone, String rawPassword) {
        if (fullName == null || fullName.isBlank()) {
            throw new IllegalArgumentException("Họ tên không được để trống");
        }
        if (!Validators.isValidEmail(email)) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }
        if (!Validators.isBlank(phone) && !Validators.isValidPhone(phone)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ (bắt đầu bằng 0, 10–11 chữ số)");
        }
        if (rawPassword == null || rawPassword.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải từ 6 ký tự trở lên");
        }

        if (userDao.existsByEmail(email)) {
            throw new IllegalArgumentException("Email này đã được sử dụng");
        }

        String hashedPw = Passwords.hash(rawPassword);
        User user = new User(fullName, email, phone, hashedPw, "CUSTOMER");
        
        int userId = userDao.insert(user);
        if (userId > 0) {
            user.setUserId(userId);
            return user;
        } else {
            throw new RuntimeException("Lỗi hệ thống, không thể tạo tài khoản");
        }
    }
}
