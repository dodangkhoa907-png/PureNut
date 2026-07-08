package com.purenut.shop.service;

import com.purenut.shop.model.User;

import java.util.Optional;

public interface UserService {
    /**
     * Xác thực người dùng bằng email và password
     * @return User object nếu đăng nhập thành công, ngược lại Optional.empty()
     */
    Optional<User> authenticate(String email, String rawPassword);

    /**
     * Đăng ký người dùng mới (Mặc định role CUSTOMER)
     * @return User vừa được tạo
     * @throws IllegalArgumentException nếu email đã tồn tại hoặc input không hợp lệ
     */
    User register(String fullName, String email, String phone, String rawPassword);
}
