package com.purenut.shop.filter;

import com.purenut.shop.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/cart/*", "/checkout/*", "/account/*", "/admin/*", "/shipper/*", "/manager/*", "/staff/*"}, asyncSupported = true)
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

        if ("/admin/login".equals(servletPath) || "/cart/count".equals(servletPath)) {
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

        // Khu vực Shipper: chỉ SHIPPER (hoặc admin xem giám sát)
        if (servletPath.startsWith("/shipper")) {
            if ((user != null && "SHIPPER".equals(user.getRole())) || admin != null) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(loginUri);
            }
            return;
        }

        // Khu vực Manager: chỉ MANAGER (hoặc admin)
        if (servletPath.startsWith("/manager")) {
            if ((user != null && "MANAGER".equals(user.getRole())) || admin != null) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(loginUri);
            }
            return;
        }

        // API nội bộ /staff/*: SHIPPER, MANAGER hoặc ADMIN
        if (servletPath.startsWith("/staff")) {
            boolean staff = (user != null && ("SHIPPER".equals(user.getRole()) || "MANAGER".equals(user.getRole())))
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
