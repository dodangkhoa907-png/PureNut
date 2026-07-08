package com.purenut.shop.filter;

import com.purenut.shop.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/cart/*", "/checkout/*", "/account/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
            
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String servletPath = req.getServletPath();
        System.out.println("[AuthFilter] Path: " + servletPath + " | Method: " + req.getMethod());

        if ("/admin/login".equals(servletPath) || "/cart/count".equals(servletPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        // Khu vực /admin redirect về trang đăng nhập admin, còn lại về login khách
        boolean isAdminArea = servletPath.startsWith("/admin");
        String loginUri = req.getContextPath() + (isAdminArea ? "/admin/login" : "/login");

        boolean loggedIn = session != null && session.getAttribute("user") != null;
        System.out.println("[AuthFilter] LoggedIn: " + loggedIn + " | Session: " + (session != null));
        
        if (loggedIn) {
            User user = (User) session.getAttribute("user");
            String path = req.getServletPath();
            
            // Nếu người dùng không phải ADMIN mà truy cập vào /admin thì chặn
            if (path.startsWith("/admin") && !"ADMIN".equals(user.getRole())) {
                System.out.println("[AuthFilter] Forbidden - user role: " + user.getRole());
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
                return;
            }
            System.out.println("[AuthFilter] User authorized: " + user.getEmail());
            chain.doFilter(request, response);
        } else {
            System.out.println("[AuthFilter] Redirecting to: " + loginUri);
            res.sendRedirect(loginUri);
        }
    }

    @Override
    public void destroy() {
    }
}
