package com.purenut.shop.controller.admin;

import com.purenut.shop.model.User;
import com.purenut.shop.service.UserService;
import com.purenut.shop.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

/**
 * Đăng nhập / đăng xuất RIÊNG cho khu vực quản trị.
 * Hoàn toàn tách biệt với AuthController của khách hàng:
 *  - URL riêng: /admin/login
 *  - Giao diện riêng: admin/login.jsp (admin.css)
 *  - Chỉ chấp nhận tài khoản Role = ADMIN
 */
@WebServlet(name = "AdminAuthController", urlPatterns = {"/admin/login", "/admin/logout"})
public class AdminAuthController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[AdminAuthController] GET called");
        String path = request.getServletPath();
        System.out.println("[AdminAuthController] Path: " + path);
        HttpSession session = request.getSession(false);

        if ("/admin/logout".equals(path)) {
            System.out.println("[AdminAuthController] Processing logout");
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Đã đăng nhập admin → vào thẳng dashboard
        if (session != null && session.getAttribute("user") instanceof User u
                && "ADMIN".equals(u.getRole())) {
            System.out.println("[AdminAuthController] Admin already logged in, redirecting to dashboard");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        System.out.println("[AdminAuthController] Forwarding to login.jsp");
        request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
        System.out.println("[AdminAuthController] Forward completed");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Optional<User> userOpt = userService.authenticate(email, password);

        if (userOpt.isPresent() && "ADMIN".equals(userOpt.get().getRole())) {
            HttpSession session = request.getSession();
            request.changeSessionId(); // chống session fixation
            session.setAttribute("user", userOpt.get());
            com.purenut.shop.util.AuditLogger.log(request, userOpt.get().getUserId(),
                    "ADMIN_LOGIN", userOpt.get().getEmail(), "Đăng nhập khu vực quản trị");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if (userOpt.isPresent()) {
            // Đúng mật khẩu nhưng là khách hàng → chặn
            request.setAttribute("errorMessage",
                    "Tài khoản này không có quyền quản trị.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu quản trị không đúng.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
        }
    }
}
