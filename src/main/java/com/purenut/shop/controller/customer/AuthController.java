package com.purenut.shop.controller.customer;

import com.purenut.shop.model.User;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.service.UserService;
import com.purenut.shop.service.impl.UserServiceImpl;
import com.purenut.shop.dao.CartItemDao;
import com.purenut.shop.dao.impl.CartItemDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private UserService userService;
    private CartItemDao cartItemDao;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        cartItemDao = new CartItemDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        
        if ("/logout".equals(path)) {
            if (session != null) {
                session.removeAttribute("user");
                session.removeAttribute("cartItems");
                session.removeAttribute("cartCount");
            }
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Nếu đã login thì redirect về home
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        if ("/login".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Optional<User> userOpt = userService.authenticate(email, password);

        if (userOpt.isPresent()) {
            User user = userOpt.get();

            // Tách role: trang này CHỈ dành cho khách hàng
            if ("ADMIN".equals(user.getRole())) {
                request.setAttribute("errorMessage",
                        "Đây là tài khoản quản trị. Vui lòng đăng nhập tại trang Quản trị.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            request.changeSessionId(); // chống session fixation
            session.setAttribute("user", user);
            
            // Load cart items từ database
            List<CartItem> cartItems = cartItemDao.findByUserId(user.getUserId());
            int cartCount = cartItemDao.countItems(user.getUserId());
            session.setAttribute("cartItems", cartItems);
            session.setAttribute("cartCount", cartCount);
            
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d]).{8,}$")) {
            request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        try {
            User user = userService.register(fullName, email, phone, password);

            // Đăng nhập luôn
            HttpSession session = request.getSession();
            request.changeSessionId(); // chống session fixation
            session.setAttribute("user", user);
            
            // Giỏ hàng của user mới là rỗng
            session.setAttribute("cartItems", java.util.Collections.emptyList());
            session.setAttribute("cartCount", 0);
            
            response.sendRedirect(request.getContextPath() + "/");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Có lỗi hệ thống. Xin vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
