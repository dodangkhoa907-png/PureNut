package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.Set;

@WebServlet(urlPatterns = {
    "/admin/don-hang",
    "/admin/don-hang/chi-tiet",
    "/admin/don-hang/cap-nhat",
    "/admin/don-hang/duyet-huy"
})
public class AdminOrderController extends HttpServlet {

    private final OrderDao orderDao = new OrderDaoImpl();
    private final UserDao userDao = new UserDaoImpl();

    private static final Set<String> ALLOWED_STATUS =
            Set.of("PENDING", "CONFIRMED", "SHIPPING", "DONE", "CANCELLED", "PENDING_CANCEL");

    private static final Map<String, Integer> STATUS_RANK = Map.ofEntries(
            Map.entry("PENDING", 0), Map.entry("CONFIRMED", 1),
            Map.entry("SHIPPING", 2), Map.entry("DONE", 3),
            Map.entry("PENDING_CANCEL", 98), Map.entry("CANCELLED", 99)
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        
        if ("/admin/don-hang".equals(path)) {
            req.setAttribute("orders", orderDao.findAllOrders());
            req.setAttribute("pageTitle", "Quản lý Đơn hàng");
            req.getRequestDispatcher("/WEB-INF/views/admin/order-list.jsp").forward(req, resp);
            
        } else if ("/admin/don-hang/chi-tiet".equals(path)) {
            Integer id = parseIntOrNull(req.getParameter("id"));
            if (id == null) { resp.sendRedirect(req.getContextPath() + "/admin/don-hang?error=BadId"); return; }
            Order order = orderDao.findOrderById(id);
            if (order != null) {
                req.setAttribute("order", order);
                req.setAttribute("pageTitle", "Chi tiết Đơn hàng #" + order.getOrderId());
                userDao.findById(order.getUserId()).ifPresent(u -> req.setAttribute("customer", u));
                req.getRequestDispatcher("/WEB-INF/views/admin/order-detail.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/don-hang?error=NotFound");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        com.purenut.shop.model.User admin = (com.purenut.shop.model.User) req.getSession().getAttribute("adminUser");
        int adminId = admin != null ? admin.getUserId() : 0;

        if ("/admin/don-hang/duyet-huy".equals(path)) {
            handleApproveRejectCancel(req, resp, adminId);
            return;
        }

        if ("/admin/don-hang/cap-nhat".equals(path)) {
            Integer orderId = parseIntOrNull(req.getParameter("orderId"));
            String status = req.getParameter("status");

            if (orderId == null || status == null || !ALLOWED_STATUS.contains(status)) {
                resp.sendRedirect(req.getContextPath() + "/admin/don-hang?error=BadInput");
                return;
            }

            Order current = orderDao.findOrderById(orderId);
            if (current == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/don-hang?error=NotFound");
                return;
            }

            String curStatus = current.getStatus();
            int curRank = STATUS_RANK.getOrDefault(curStatus, -1);
            int newRank = STATUS_RANK.getOrDefault(status, -1);

            if ("DONE".equals(curStatus) || "CANCELLED".equals(curStatus)) {
                resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&error=final");
                return;
            }
            if (!"CANCELLED".equals(status) && newRank < curRank) {
                resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&error=backward");
                return;
            }
            if ("SHIPPING".equals(curStatus) && "CANCELLED".equals(status)) {
                resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&error=nocancel");
                return;
            }

            if ("CANCELLED".equals(status)) {
                try {
                    orderDao.approveCancelOrder(orderId);
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&error=system");
                    return;
                }
            } else {
                orderDao.updateOrderStatus(orderId, status);
            }

            com.purenut.shop.util.AuditLogger.log(req, adminId,
                    "UPDATE_ORDER_STATUS", "Đơn #" + orderId, "Đổi trạng thái sang " + status);

            resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&success=true");
        }
    }

    private void handleApproveRejectCancel(HttpServletRequest req, HttpServletResponse resp, int adminId) throws IOException {
        Integer orderId = parseIntOrNull(req.getParameter("orderId"));
        String action = req.getParameter("action");

        if (orderId == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/don-hang?error=BadInput");
            return;
        }

        try {
            if ("approve".equals(action)) {
                orderDao.approveCancelOrder(orderId);
                com.purenut.shop.util.AuditLogger.log(req, adminId,
                        "APPROVE_CANCEL", "Đơn #" + orderId, "Duyệt hủy + hoàn tiền");
            } else if ("reject".equals(action)) {
                orderDao.rejectCancelOrder(orderId);
                com.purenut.shop.util.AuditLogger.log(req, adminId,
                        "REJECT_CANCEL", "Đơn #" + orderId, "Từ chối yêu cầu hủy");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&success=true");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/don-hang/chi-tiet?id=" + orderId + "&error=system");
        }
    }

    private static Integer parseIntOrNull(String s) {
        if (s == null) return null;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}
