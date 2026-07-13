package com.purenut.shop.filter;

import com.purenut.shop.dao.ShipperDao;
import com.purenut.shop.dao.impl.ShipperDaoImpl;
import com.purenut.shop.model.Shipper;
import com.purenut.shop.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * MÀNG LỌC THÉP cho khu vực /shipper/*:
 *  - Mỗi shipper có danh sách IP nội bộ được cấp (Shippers.Allowed_IP, CSV).
 *  - Request từ IP ngoài danh sách → 403 Forbidden, ghi log cảnh báo.
 *  - Allowed_IP NULL/rỗng = shipper chưa bị khóa IP (giai đoạn chuyển tiếp).
 *  - Admin giám sát không bị chặn IP (đã qua AdminIpFilter riêng).
 *
 * Cache whitelist 60s/shipper để không query DB mỗi request
 * (shipper.jsp polling chat 5s/lần — không cache sẽ dội DB).
 */
@WebFilter(filterName = "ShipperIpFilter", urlPatterns = {"/shipper/*"}, asyncSupported = true)
public class ShipperIpFilter implements Filter {

    private static final long CACHE_TTL_MS = 60_000;

    private ShipperDao shipperDao;
    private final ConcurrentHashMap<Integer, CacheEntry> cache = new ConcurrentHashMap<>();

    private static final class CacheEntry {
        final Set<String> ips;      // rỗng = không khóa IP
        final long loadedAt;
        CacheEntry(Set<String> ips, long loadedAt) { this.ips = ips; this.loadedAt = loadedAt; }
    }

    @Override
    public void init(FilterConfig cfg) {
        shipperDao = new ShipperDaoImpl();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Cổng đăng nhập/đăng xuất shipper: không khóa IP (chưa có session)
        String path = req.getServletPath();
        if ("/shipper/login".equals(path) || "/shipper/logout".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User shipperUser = (session != null) ? (User) session.getAttribute("shipperUser") : null;
        User admin       = (session != null) ? (User) session.getAttribute("adminUser") : null;

        // Admin giám sát: cho qua (AuthFilter + AdminIpFilter đã siết)
        if (admin != null && "ADMIN".equals(admin.getRole())) {
            chain.doFilter(request, response);
            return;
        }

        // Chưa đăng nhập shipper: để AuthFilter xử lý redirect về /shipper/login
        if (shipperUser == null || !"SHIPPER".equals(shipperUser.getRole())) {
            chain.doFilter(request, response);
            return;
        }

        Set<String> allowed = allowedIpsOf(shipperUser.getUserId());

        // Chưa cấu hình IP cho shipper này → không khóa (admin cấp dần)
        if (allowed.isEmpty()) {
            chain.doFilter(request, response);
            return;
        }

        String ip = req.getRemoteAddr();
        if (allowed.contains(ip)) {
            chain.doFilter(request, response);
            return;
        }

        // IP lạ → chặn cứng + cảnh báo
        System.err.println("[ShipperIpFilter] BLOCKED shipper #" + shipperUser.getUserId()
                + " từ IP lạ " + ip + " (whitelist: " + allowed + ")");
        com.purenut.shop.util.AuditLogger.log(req, shipperUser.getUserId(),
                "SHIPPER_IP_BLOCKED", "IP " + ip, "Truy cập /shipper từ IP ngoài whitelist");
        res.sendError(HttpServletResponse.SC_FORBIDDEN, "IP không được cấp quyền truy cập khu vực Shipper");
    }

    private Set<String> allowedIpsOf(int shipperId) {
        long now = System.currentTimeMillis();
        CacheEntry e = cache.get(shipperId);
        if (e != null && now - e.loadedAt < CACHE_TTL_MS) return e.ips;

        Set<String> ips = new HashSet<>();
        String csv = shipperDao.findById(shipperId).map(Shipper::getAllowedIp).orElse(null);
        if (csv != null && !csv.isBlank()) {
            Arrays.stream(csv.split(","))
                  .map(String::trim)
                  .filter(s -> !s.isEmpty())
                  .forEach(ips::add);
        }
        cache.put(shipperId, new CacheEntry(ips, now));
        return ips;
    }

    @Override
    public void destroy() {
        cache.clear();
    }
}
