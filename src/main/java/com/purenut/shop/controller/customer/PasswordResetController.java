package com.purenut.shop.controller.customer;

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
import java.util.Optional;

@WebServlet(name = "PasswordResetController",
        urlPatterns = {"/forgot-password", "/verify-otp", "/resend-otp", "/reset-password"})
public class PasswordResetController extends HttpServlet {

    private static final long OTP_TTL_MS = 5L * 60 * 1000;
    private static final long RESEND_COOLDOWN_MS = 60L * 1000;
    private static final SecureRandom RANDOM = new SecureRandom();

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();

        switch (path) {
            case "/forgot-password" -> {
                clearResetSession(session);
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            }
            case "/verify-otp" -> {
                if (session.getAttribute("reset_email") == null) {
                    resp.sendRedirect(req.getContextPath() + "/forgot-password");
                    return;
                }
                Long expiresAt = (Long) session.getAttribute("reset_otp_expires");
                long remaining = (expiresAt != null) ? expiresAt - System.currentTimeMillis() : 0;
                req.setAttribute("remainingMs", Math.max(remaining, 0));
                req.setAttribute("resetEmail", session.getAttribute("reset_email"));
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            }
            case "/reset-password" -> {
                Boolean verified = (Boolean) session.getAttribute("reset_otp_verified");
                if (verified == null || !verified) {
                    resp.sendRedirect(req.getContextPath() + "/forgot-password");
                    return;
                }
                req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
            }
            default -> resp.sendRedirect(req.getContextPath() + "/forgot-password");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        switch (path) {
            case "/forgot-password" -> handleForgot(req, resp);
            case "/verify-otp"     -> handleVerifyOtp(req, resp);
            case "/resend-otp"     -> handleResend(req, resp);
            case "/reset-password" -> handleReset(req, resp);
        }
    }

    private void handleForgot(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null) email = email.trim().toLowerCase();

        if (email == null || email.isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập địa chỉ email.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        Optional<User> userOpt = userDao.findByEmail(email);

        if (userOpt.isEmpty()) {
            req.setAttribute("errorMessage", "Nếu email này tồn tại trong hệ thống, mã OTP đã được gửi.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        User user = userOpt.get();
        HttpSession session = req.getSession();
        String otp = generateOtp();
        long expiresAt = System.currentTimeMillis() + OTP_TTL_MS;

        session.setAttribute("reset_email", user.getEmail());
        session.setAttribute("reset_user_id", user.getUserId());
        session.setAttribute("reset_user_name", user.getFullName());
        session.setAttribute("reset_otp", otp);
        session.setAttribute("reset_otp_expires", expiresAt);
        session.setAttribute("reset_otp_sent_at", System.currentTimeMillis());
        session.setAttribute("reset_otp_verified", false);
        session.setAttribute("reset_attempts", 0);

        sendOtpEmail(user.getEmail(), user.getFullName(), otp);

        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        String sessionEmail = (String) session.getAttribute("reset_email");
        if (sessionEmail == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String d1 = req.getParameter("d1");
        String d2 = req.getParameter("d2");
        String d3 = req.getParameter("d3");
        String d4 = req.getParameter("d4");
        String d5 = req.getParameter("d5");
        String d6 = req.getParameter("d6");

        if (d1 == null || d2 == null || d3 == null || d4 == null || d5 == null || d6 == null) {
            req.setAttribute("errorMessage", "Vui lòng nhập đủ 6 chữ số.");
            forwardToOtpPage(req, resp, session);
            return;
        }

        String inputOtp = d1 + d2 + d3 + d4 + d5 + d6;

        Integer attempts = (Integer) session.getAttribute("reset_attempts");
        if (attempts == null) attempts = 0;
        attempts++;
        session.setAttribute("reset_attempts", attempts);

        if (attempts > 5) {
            clearResetSession(session);
            req.setAttribute("errorMessage", "Bạn đã nhập sai quá nhiều lần. Vui lòng yêu cầu mã mới.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        String storedOtp = (String) session.getAttribute("reset_otp");
        Long expiresAt = (Long) session.getAttribute("reset_otp_expires");

        if (expiresAt == null || System.currentTimeMillis() > expiresAt) {
            req.setAttribute("errorMessage", "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã.");
            forwardToOtpPage(req, resp, session);
            return;
        }

        if (!inputOtp.equals(storedOtp)) {
            req.setAttribute("errorMessage", "Mã OTP không chính xác. Còn " + (5 - attempts) + " lần thử.");
            forwardToOtpPage(req, resp, session);
            return;
        }

        session.setAttribute("reset_otp_verified", true);
        session.removeAttribute("reset_otp");
        session.removeAttribute("reset_attempts");

        resp.sendRedirect(req.getContextPath() + "/reset-password");
    }

    private void handleResend(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        String email = (String) session.getAttribute("reset_email");
        Integer userId = (Integer) session.getAttribute("reset_user_id");
        String fullName = (String) session.getAttribute("reset_user_name");

        if (email == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        Long sentAt = (Long) session.getAttribute("reset_otp_sent_at");
        if (sentAt != null && System.currentTimeMillis() - sentAt < RESEND_COOLDOWN_MS) {
            resp.sendRedirect(req.getContextPath() + "/verify-otp");
            return;
        }

        String otp = generateOtp();
        long expiresAt = System.currentTimeMillis() + OTP_TTL_MS;

        session.setAttribute("reset_otp", otp);
        session.setAttribute("reset_otp_expires", expiresAt);
        session.setAttribute("reset_otp_sent_at", System.currentTimeMillis());
        session.setAttribute("reset_otp_verified", false);
        session.setAttribute("reset_attempts", 0);

        sendOtpEmail(email, fullName, otp);

        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleReset(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Boolean verified = (Boolean) session.getAttribute("reset_otp_verified");
        Integer userId = (Integer) session.getAttribute("reset_user_id");

        if (verified == null || !verified || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        if (password == null || !password.equals(confirm)) {
            req.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
            return;
        }
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d]).{8,}$")) {
            req.setAttribute("errorMessage",
                    "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
            return;
        }

        boolean ok = userDao.updatePassword(userId, Passwords.hash(password));
        clearResetSession(session);

        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/login?reset=success");
        } else {
            req.setAttribute("errorMessage", "Có lỗi hệ thống, vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/reset-password.jsp").forward(req, resp);
        }
    }

    private void forwardToOtpPage(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        Long expiresAt = (Long) session.getAttribute("reset_otp_expires");
        long remaining = (expiresAt != null) ? expiresAt - System.currentTimeMillis() : 0;
        req.setAttribute("remainingMs", Math.max(remaining, 0));
        req.setAttribute("resetEmail", session.getAttribute("reset_email"));
        req.setAttribute("step", "otp");
        req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
    }

    private String generateOtp() {
        int code = RANDOM.nextInt(900000) + 100000;
        return String.valueOf(code);
    }

    private void sendOtpEmail(String toEmail, String fullName, String otp) {
        String html = "<!DOCTYPE html>"
            + "<html><head><meta charset='UTF-8'></head><body style='margin:0;padding:0;background:#FBF6EC;font-family:Arial,Helvetica,sans-serif'>"
            + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#FBF6EC;padding:40px 20px'><tr><td align='center'>"
            + "<table width='520' cellpadding='0' cellspacing='0' style='background:#FFFDF8;border-radius:24px;overflow:hidden;box-shadow:0 8px 30px rgba(11,37,71,.08)'>"
            // Header navy
            + "<tr><td style='background:linear-gradient(135deg,#1B4F9E,#0B2547);padding:36px 40px;text-align:center'>"
            + "<div style='font-size:28px;margin-bottom:8px'>🔐</div>"
            + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:600'>Mã xác thực OTP</h1>"
            + "<p style='margin:8px 0 0;color:rgba(255,255,255,.8);font-size:14px'>Đặt lại mật khẩu tài khoản PureNut</p>"
            + "</td></tr>"
            // Body
            + "<tr><td style='padding:36px 40px'>"
            + "<p style='margin:0 0 16px;font-size:15px;color:#241F18'>Xin chào <b>" + fullName + "</b>,</p>"
            + "<p style='margin:0 0 28px;font-size:14.5px;color:#6B6357;line-height:1.6'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Sử dụng mã OTP bên dưới để tiếp tục:</p>"
            // OTP box
            + "<div style='text-align:center;margin:0 0 28px'>"
            + "<div style='display:inline-block;background:#FBF6EC;border:2px dashed #1B4F9E;border-radius:16px;padding:20px 36px'>"
            + "<span style='font-size:36px;font-weight:700;letter-spacing:12px;color:#1B4F9E;font-family:monospace'>" + otp + "</span>"
            + "</div>"
            + "<p style='margin:12px 0 0;font-size:13px;color:#CE2E2E;font-weight:600'>⏱ Mã có hiệu lực trong 5 phút</p>"
            + "</div>"
            // Warning
            + "<div style='background:#FCE9E9;border-radius:12px;padding:14px 18px;margin:0 0 24px'>"
            + "<p style='margin:0;font-size:13px;color:#A31F1F;font-weight:600'>⚠️ Không chia sẻ mã này với bất kỳ ai. Nhân viên PureNut sẽ không bao giờ hỏi mã OTP của bạn.</p>"
            + "</div>"
            + "<p style='margin:0;font-size:13.5px;color:#6B6357;line-height:1.5'>Nếu bạn không yêu cầu đặt lại mật khẩu, hãy bỏ qua email này — tài khoản của bạn vẫn an toàn.</p>"
            + "</td></tr>"
            // Footer
            + "<tr><td style='background:#F5F0E5;padding:20px 40px;text-align:center;border-top:1px solid rgba(36,31,24,.08)'>"
            + "<p style='margin:0;font-size:12px;color:#6B6357'>© 2025 PureNut — Sữa hạt thuần khiết từ hạt Việt 🌰</p>"
            + "</td></tr>"
            + "</table></td></tr></table></body></html>";

        EmailUtil.sendEmail(toEmail, "PureNut — Mã xác thực OTP", html);
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("reset_email");
        session.removeAttribute("reset_user_id");
        session.removeAttribute("reset_user_name");
        session.removeAttribute("reset_otp");
        session.removeAttribute("reset_otp_expires");
        session.removeAttribute("reset_otp_sent_at");
        session.removeAttribute("reset_otp_verified");
        session.removeAttribute("reset_attempts");
    }
}
