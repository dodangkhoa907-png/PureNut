package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.User;
import com.purenut.shop.util.EmailUtil;
import com.purenut.shop.util.Passwords;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;

/**
 * Cài đặt tài khoản quản trị: đổi mật khẩu bằng mã xác nhận (OTP) gửi về email admin.
 *  GET  /admin/settings                 -> trang cài đặt
 *  POST /admin/settings?action=send-code    -> gửi OTP 6 số về email admin (hiệu lực 10')
 *  POST /admin/settings?action=change-password -> xác thực OTP + đổi mật khẩu
 */
@WebServlet(name = "AdminSettingsController", urlPatterns = {"/admin/settings"})
public class AdminSettingsController extends HttpServlet {

    private static final long OTP_TTL_MS = 10L * 60 * 1000; // 10 phút
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("pageTitle", "Cài đặt & Bảo mật");
        req.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        req.setAttribute("pageTitle", "Cài đặt & Bảo mật");

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("adminUser");
        if (admin == null) { resp.sendRedirect(req.getContextPath() + "/admin/login"); return; }

        String action = req.getParameter("action");
        if ("send-code".equals(action)) {
            handleSendCode(req, admin, session);
        } else if ("change-password".equals(action)) {
            handleChangePassword(req, admin, session);
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(req, resp);
    }

    private void handleSendCode(HttpServletRequest req, User admin, HttpSession session) {
        String code = String.format("%06d", RANDOM.nextInt(1_000_000));
        session.setAttribute("pwOtp", code);
        session.setAttribute("pwOtpExpire", System.currentTimeMillis() + OTP_TTL_MS);

        String html = "<div style=\"font-family:Arial,sans-serif;max-width:520px;margin:0 auto;"
                + "background:#F4F7FE;border-radius:14px;padding:28px;color:#2B3674\">"
                + "<h2 style=\"color:#1B4F9E;margin:0 0 8px\">PureNut Admin — Mã xác nhận đổi mật khẩu</h2>"
                + "<p>Xin chào <b>" + admin.getFullName() + "</b>,</p>"
                + "<p>Mã xác nhận để đổi mật khẩu tài khoản quản trị của bạn là:</p>"
                + "<p style=\"text-align:center;margin:22px 0\">"
                + "<span style=\"display:inline-block;background:#1B4F9E;color:#fff;font-size:30px;letter-spacing:10px;"
                + "font-weight:bold;padding:14px 26px;border-radius:12px\">" + code + "</span></p>"
                + "<p style=\"font-size:13px;color:#707EAE\">Mã có hiệu lực trong <b>10 phút</b>. "
                + "Nếu bạn không thực hiện yêu cầu này, hãy bỏ qua email.</p></div>";

        boolean sent = EmailUtil.sendEmail(admin.getEmail(), "PureNut Admin — Mã xác nhận đổi mật khẩu", html);
        if (sent) {
            req.setAttribute("infoMessage", "Đã gửi mã xác nhận tới email " + maskEmail(admin.getEmail()) + " (hiệu lực 10 phút).");
            req.setAttribute("codeSent", Boolean.TRUE);
        } else {
            req.setAttribute("errorMessage", "Không gửi được email. Vui lòng kiểm tra cấu hình SMTP và thử lại.");
        }
    }

    private void handleChangePassword(HttpServletRequest req, User admin, HttpSession session) {
        String code = req.getParameter("code");
        String current = req.getParameter("currentPassword");
        String pw = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        String otp = (String) session.getAttribute("pwOtp");
        Long exp = (Long) session.getAttribute("pwOtpExpire");

        req.setAttribute("codeSent", Boolean.TRUE);

        if (otp == null || exp == null || exp < System.currentTimeMillis()) {
            req.setAttribute("errorMessage", "Mã xác nhận không tồn tại hoặc đã hết hạn. Vui lòng gửi lại mã.");
            req.removeAttribute("codeSent");
            return;
        }
        if (code == null || !code.trim().equals(otp)) {
            req.setAttribute("errorMessage", "Mã xác nhận không đúng.");
            return;
        }
        if (!Passwords.matches(current, admin.getPasswordHash())) {
            req.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
            return;
        }
        if (pw == null || !pw.equals(confirm)) {
            req.setAttribute("errorMessage", "Mật khẩu mới xác nhận không khớp.");
            return;
        }
        if (!pw.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d]).{8,}$")) {
            req.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            return;
        }

        String newHash = Passwords.hash(pw);
        boolean ok = userDao.updatePassword(admin.getUserId(), newHash);
        if (ok) {
            admin.setPasswordHash(newHash);          // cập nhật trong session
            session.removeAttribute("pwOtp");
            session.removeAttribute("pwOtpExpire");
            req.removeAttribute("codeSent");
            com.purenut.shop.util.AuditLogger.log(req, admin.getUserId(),
                    "CHANGE_PASSWORD", admin.getEmail(), "Đổi mật khẩu quản trị (xác thực OTP email)");
            req.setAttribute("successMessage", "Đổi mật khẩu thành công! Lần đăng nhập tới hãy dùng mật khẩu mới.");
        } else {
            req.setAttribute("errorMessage", "Có lỗi hệ thống, vui lòng thử lại.");
        }
    }

    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        String[] p = email.split("@");
        String name = p[0];
        String shown = name.length() <= 2 ? name.charAt(0) + "***"
                : name.substring(0, 2) + "***" + name.charAt(name.length() - 1);
        return shown + "@" + p[1];
    }
}
