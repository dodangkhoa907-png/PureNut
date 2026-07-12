package com.purenut.shop.controller.staff;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
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
 * Khu làm việc Manager:
 *  GET  /manager             → dashboard điều phối đơn
 *  POST /manager/gan-don     → gán shipper cho đơn (CONFIRMED → SHIPPING)
 *  POST /manager/duyet-huy   → duyệt/từ chối yêu cầu hủy đơn trả trước
 */
@WebServlet(name = "ManagerController", urlPatterns = {"/manager", "/manager/gan-don", "/manager/duyet-huy"})
public class ManagerController extends HttpServlet {

    private OrderDao orderDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        userDao = new UserDaoImpl();
    }

    private User currentManager(HttpServletRequest req) {
        User u = (User) req.getSession().getAttribute("user");
        if (u != null && "MANAGER".equals(u.getRole())) return u;
        return (User) req.getSession().getAttribute("adminUser"); // admin cũng vào được
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User mgr = currentManager(req);
        if (mgr == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

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
        req.setAttribute("pageTitle", "Điều phối đơn hàng");
        req.getRequestDispatcher("/WEB-INF/views/admin/dispatch.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User mgr = currentManager(req);
        if (mgr == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        String path = req.getServletPath();

        if ("/manager/gan-don".equals(path)) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            int shipperId = Validators.parsePositiveInt(req.getParameter("shipperId"), -1);
            if (orderId <= 0 || shipperId <= 0) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}");
                return;
            }
            // Shipper phải đúng role
            boolean validShipper = userDao.findById(shipperId)
                    .map(u -> "SHIPPER".equals(u.getRole())).orElse(false);
            if (!validShipper) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Shipper không hợp lệ\"}");
                return;
            }
            int n = orderDao.assignShipper(orderId, shipperId);
            if (n > 0) {
                AuditLogger.log(req, mgr.getUserId(), "ASSIGN_SHIPPER",
                        "Đơn #" + orderId, "Gán shipper #" + shipperId + " — chuyển SHIPPING");
                writeJson(resp, "{\"ok\":true}");
            } else {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không ở trạng thái gán được (cần CONFIRMED)\"}");
            }
            return;
        }

        if ("/manager/duyet-huy".equals(path)) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            String action = req.getParameter("action");
            if (orderId <= 0 || (!"approve".equals(action) && !"reject".equals(action))) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}");
                return;
            }
            try {
                int n = "approve".equals(action)
                        ? orderDao.approveCancelOrder(orderId)
                        : orderDao.rejectCancelOrder(orderId);
                if (n > 0) {
                    AuditLogger.log(req, mgr.getUserId(),
                            "approve".equals(action) ? "APPROVE_CANCEL" : "REJECT_CANCEL",
                            "Đơn #" + orderId,
                            "approve".equals(action) ? "Manager duyệt hủy + hoàn kho" : "Manager từ chối hủy");
                    writeJson(resp, "{\"ok\":true}");
                } else {
                    writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không ở trạng thái chờ duyệt hủy\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                writeJson(resp, "{\"ok\":false,\"msg\":\"Lỗi hệ thống\"}");
            }
        }
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
