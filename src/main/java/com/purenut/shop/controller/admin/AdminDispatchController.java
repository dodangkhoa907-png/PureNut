package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.ShipperDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.ShipperDaoImpl;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.User;
import com.purenut.shop.util.AuditLogger;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Điều phối giao hàng — chuyển từ role MANAGER (đã hủy) về ADMIN:
 *  GET  /admin/dieu-phoi              → dashboard điều phối đơn
 *  POST /admin/dieu-phoi/gan-don      → gán shipper (CONFIRMED → SHIPPING + ASSIGNED)
 *  POST /admin/dieu-phoi/duyet-huy    → duyệt/từ chối yêu cầu hủy
 *  POST /admin/dieu-phoi/cap-ip       → cấp IP nội bộ + biển số xe cho shipper
 */
@WebServlet(name = "AdminDispatchController", urlPatterns = {
        "/admin/dieu-phoi", "/admin/dieu-phoi/gan-don",
        "/admin/dieu-phoi/duyet-huy", "/admin/dieu-phoi/cap-ip",
        "/admin/dieu-phoi/xac-nhan"})
public class AdminDispatchController extends HttpServlet {

    private OrderDao orderDao;
    private UserDao userDao;
    private ShipperDao shipperDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        userDao = new UserDaoImpl();
        shipperDao = new ShipperDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Order> all = orderDao.findAllOrders();
        List<Order> needAssign = all.stream()
                .filter(o -> "CONFIRMED".equals(o.getStatus()) && o.getShipperId() == null)
                .collect(Collectors.toList());
        List<Order> shipping = all.stream()
                .filter(o -> "SHIPPING".equals(o.getStatus()))
                .collect(Collectors.toList());
        List<Order> pendingCancel = all.stream()
                .filter(o -> "PENDING_CANCEL".equals(o.getStatus()))
                .collect(Collectors.toList());
        List<Order> newOrders = all.stream()
                .filter(o -> "PENDING".equals(o.getStatus()))
                .collect(Collectors.toList());

        req.setAttribute("needAssign", needAssign);
        req.setAttribute("shipping", shipping);
        req.setAttribute("pendingCancel", pendingCancel);
        req.setAttribute("newOrders", newOrders);
        req.setAttribute("shippers", userDao.findByRole("SHIPPER"));
        req.setAttribute("shipperProfiles", shipperDao.findAll());
        req.setAttribute("pageTitle", "Điều phối giao hàng");
        req.getRequestDispatcher("/WEB-INF/views/admin/dispatch.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User admin = (User) req.getSession().getAttribute("adminUser");
        if (admin == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        String path = req.getServletPath();

        if ("/admin/dieu-phoi/gan-don".equals(path)) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            int shipperId = Validators.parsePositiveInt(req.getParameter("shipperId"), -1);
            if (orderId <= 0 || shipperId <= 0) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}"); return;
            }
            boolean validShipper = userDao.findById(shipperId)
                    .map(u -> "SHIPPER".equals(u.getRole())).orElse(false);
            if (!validShipper) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Shipper không hợp lệ\"}"); return;
            }
            int n = orderDao.assignShipper(orderId, shipperId);
            if (n > 0) {
                AuditLogger.log(req, admin.getUserId(), "ASSIGN_SHIPPER",
                        "Đơn #" + orderId, "Gán shipper #" + shipperId + " — SHIPPING + ASSIGNED");
                writeJson(resp, "{\"ok\":true}");
            } else {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không ở trạng thái gán được (cần CONFIRMED)\"}");
            }
            return;
        }

        if ("/admin/dieu-phoi/duyet-huy".equals(path)) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            String action = req.getParameter("action");
            if (orderId <= 0 || (!"approve".equals(action) && !"reject".equals(action))) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}"); return;
            }
            try {
                int n = "approve".equals(action)
                        ? orderDao.approveCancelOrder(orderId)
                        : orderDao.rejectCancelOrder(orderId);
                if (n > 0) {
                    AuditLogger.log(req, admin.getUserId(),
                            "approve".equals(action) ? "APPROVE_CANCEL" : "REJECT_CANCEL",
                            "Đơn #" + orderId,
                            "approve".equals(action) ? "Admin duyệt hủy + hoàn kho" : "Admin từ chối hủy");
                    writeJson(resp, "{\"ok\":true}");
                } else {
                    writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không ở trạng thái chờ duyệt hủy\"}");
                }
            } catch (Exception e) {
                System.err.println("[AdminDispatch] duyet-huy: " + e.getMessage());
                writeJson(resp, "{\"ok\":false,\"msg\":\"Lỗi hệ thống\"}");
            }
            return;
        }

        if ("/admin/dieu-phoi/xac-nhan".equals(path)) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            if (orderId <= 0) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}"); return;
            }
            int n = orderDao.updateOrderStatus(orderId, "CONFIRMED");
            if (n > 0) {
                AuditLogger.log(req, admin.getUserId(), "CONFIRM_ORDER",
                        "Đơn #" + orderId, "Admin xác nhận đơn — PENDING → CONFIRMED");
                writeJson(resp, "{\"ok\":true}");
            } else {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không ở trạng thái chờ xác nhận\"}");
            }
            return;
        }

        if ("/admin/dieu-phoi/cap-ip".equals(path)) {
            int shipperId = Validators.parsePositiveInt(req.getParameter("shipperId"), -1);
            String allowedIp = req.getParameter("allowedIp");
            String vehiclePlate = req.getParameter("vehiclePlate");
            if (shipperId <= 0) { writeJson(resp, "{\"ok\":false,\"msg\":\"Shipper không hợp lệ\"}"); return; }

            // Validate CSV IP: chỉ chấp nhận IPv4/IPv6 đơn giản, chặn ký tự lạ
            if (allowedIp != null && !allowedIp.isBlank()
                    && !allowedIp.matches("[0-9a-fA-F:.,\\s]{1,200}")) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Danh sách IP không hợp lệ\"}"); return;
            }
            if (vehiclePlate != null && vehiclePlate.length() > 20) vehiclePlate = vehiclePlate.substring(0, 20);

            shipperDao.ensureProfile(shipperId,
                    userDao.findById(shipperId).map(User::getFullName).orElse("Shipper"),
                    userDao.findById(shipperId).map(User::getPhone).orElse(null));
            boolean ok = shipperDao.updateAllowedIp(shipperId,
                    (allowedIp == null || allowedIp.isBlank()) ? null : allowedIp.trim(), vehiclePlate);
            if (ok) {
                AuditLogger.log(req, admin.getUserId(), "SHIPPER_IP_GRANT",
                        "Shipper #" + shipperId, "Cấp IP: " + allowedIp);
            }
            writeJson(resp, ok ? "{\"ok\":true}" : "{\"ok\":false,\"msg\":\"Không cập nhật được\"}");
        }
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
