package com.purenut.shop.util;

import org.mindrot.jbcrypt.BCrypt;

/** Tiện ích hash & kiểm tra mật khẩu bằng BCrypt. */
public final class Passwords {

    private Passwords() { }

    /** Hash mật khẩu thô trước khi lưu DB. */
    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(10));
    }

    /** So khớp mật khẩu thô với hash đã lưu. */
    public static boolean matches(String plain, String hash) {
        if (plain == null || hash == null || hash.isEmpty()) return false;
        try {
            return BCrypt.checkpw(plain, hash);
        } catch (IllegalArgumentException e) {
            return false; // hash sai định dạng
        }
    }
}
