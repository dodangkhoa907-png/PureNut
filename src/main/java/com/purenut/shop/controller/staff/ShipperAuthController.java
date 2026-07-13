package com.purenut.shop.controller.staff;

import com.purenut.shop.dao.ShipperDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.ShipperDaoImpl;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.User;
import com.purenut.shop.service.UserService;
import com.purenut.shop.service.impl.UserServiceImpl;
import com.purenut.shop.util.AuditLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

/**
 * Cổng đăng nhập ĐỘC LẬP cho Shipper — tách hoàn toàn khỏi khách hàng.
 *  - URL riêng: /shipper/login, /shipper/logout
 *  - Session riêng: "shipperUser" (không đụng "user" của khách, "adminUser" của admin)
 *  - Chỉ chấp nhận Role = SHIPPER
 * Nhờ session riêng, một trình duyệt có thể vừa là khách vừa là shipper mà không xung đột,
 * và vào /shipper KHÔNG bao giờ bị đá về trang khách hàng.
 */
@WebServlet(name = "ShipperAuthController", urlPatterns = {"/shipper/login", "/shipper/logout"})
public class ShipperAuthController extends HttpServlet {

    private UserService userService;
    private UserDao userDao;
    private ShipperDao shipperDao;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        userDao = new UserDaoImpl();
        shipperDao = new ShipperDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);

        if ("/shipper/logout".equals(path)) {
            if (session != null) {
                session.removeAttribute("shipperUser");
                request.changeSessionId();
            }
            response.sendRedirect(request.getContextPath() + "/shipper/login");
            return;
        }

        // Đã đăng nhập shipper rồi → vào thẳng khu làm việc
        if (session != null && session.getAttribute("shipperUser") instanceof User u
                && "SHIPPER".equals(u.getRole())) {
            response.sendRedirect(request.getContextPath() + "/shipper");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/staff/shipper-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Optional<User> userOpt = userService.authenticate(email, password);

        if (userOpt.isPresent() && "SHIPPER".equals(userOpt.get().getRole())) {
            User shipper = userOpt.get();
            HttpSession session = request.getSession();
            request.changeSessionId(); // chống session fixation
            session.setAttribute("shipperUser", shipper);
            userDao.updateLoginInfo(shipper.getUserId(), request.getRemoteAddr());
            shipperDao.ensureProfile(shipper.getUserId(), shipper.getFullName(), shipper.getPhone());
            AuditLogger.log(request, shipper.getUserId(),
                    "SHIPPER_LOGIN", shipper.getEmail(), "Đăng nhập cổng Shipper");
            response.sendRedirect(request.getContextPath() + "/shipper");
        } else if (userOpt.isPresent()) {
            request.setAttribute("errorMessage", "Tài khoản này không phải Shipper.");
            request.getRequestDispatcher("/WEB-INF/views/staff/shipper-login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/WEB-INF/views/staff/shipper-login.jsp").forward(request, response);
        }
    }
}
