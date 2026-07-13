package com.purenut.shop.filter;

import com.purenut.shop.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/cart/*", "/checkout/*", "/account/*", "/admin/*", "/shipper/*", "/staff/*"}, asyncSupported = true)
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

        // Cổng đăng nhập public: không chặn
        if ("/admin/login".equals(servletPath) || "/cart/count".equals(servletPath)
                || "/shipper/login".equals(servletPath) || "/shipper/logout".equals(servletPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean isAdminArea = servletPath.startsWith("/admin");
        String loginUri = req.getContextPath() + (isAdminArea ? "/admin/login" : "/login");

        if (isAdminArea) {
            User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
            if (admin != null && "ADMIN".equals(admin.getRole())) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(loginUri);
            }
            return;
        }

        User user = (session != null) ? (User) session.getAttribute("user") : null;
        User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
        User shipperUser = (session != null) ? (User) session.getAttribute("shipperUser") : null;

        // Khu vực Shipper: dùng session ĐỘC LẬP "shipperUser" (hoặc admin giám sát).
        // KHÔNG dùng "user" của khách → shipper không bao giờ bị đá về trang khách hàng.
        if (servletPath.startsWith("/shipper")) {
            if ((shipperUser != null && "SHIPPER".equals(shipperUser.getRole())) || admin != null) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(req.getContextPath() + "/shipper/login");
            }
            return;
        }

        // API nội bộ /staff/*: SHIPPER (session riêng) hoặc ADMIN
        if (servletPath.startsWith("/staff")) {
            boolean staff = (shipperUser != null && "SHIPPER".equals(shipperUser.getRole()))
                    || admin != null;
            if (staff) {
                chain.doFilter(request, response);
            } else {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
            }
            return;
        }

        if (user != null) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(loginUri);
        }
    }

    @Override
    public void destroy() {
    }
}
