package com.purenut.shop.controller.staff;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
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

/**
 * Khu làm việc Shipper:
 *  GET  /shipper                → danh sách đơn được gán
 *  POST /shipper/hoan-thanh     → đánh dấu đã giao (SHIPPING → DONE)
 */
@WebServlet(name = "ShipperController", urlPatterns = {"/shipper", "/shipper/hoan-thanh"})
public class ShipperController extends HttpServlet {

    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
    }

    private User currentShipper(HttpServletRequest req) {
        User u = (User) req.getSession().getAttribute("user");
        if (u != null && "SHIPPER".equals(u.getRole())) return u;
        return (User) req.getSession().getAttribute("adminUser"); // admin giám sát
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User shipper = currentShipper(req);
        if (shipper == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<Order> orders = orderDao.findOrdersByShipper(shipper.getUserId());
        long shipping = orders.stream().filter(o -> "SHIPPING".equals(o.getStatus())).count();
        long done = orders.stream().filter(o -> "DONE".equals(o.getStatus())).count();

        req.setAttribute("orders", orders);
        req.setAttribute("shippingCount", shipping);
        req.setAttribute("doneCount", done);
        req.getRequestDispatcher("/WEB-INF/views/staff/shipper.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User shipper = currentShipper(req);
        if (shipper == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        if ("/shipper/hoan-thanh".equals(req.getServletPath())) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            if (orderId <= 0) { writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không hợp lệ\"}"); return; }

            // Chỉ được hoàn thành đơn ĐANG GIAO và được gán cho chính mình
            Order order = orderDao.findOrderById(orderId);
            if (order == null || !"SHIPPING".equals(order.getStatus())
                    || order.getShipperId() == null || order.getShipperId() != shipper.getUserId()) {
                writeJson(resp, "{\"ok\":false,\"msg\":\"Đơn không thuộc quyền xử lý của bạn.\"}");
                return;
            }

            orderDao.updateOrderStatus(orderId, "DONE");
            AuditLogger.log(req, shipper.getUserId(), "ORDER_DELIVERED",
                    "Đơn #" + orderId, "Shipper xác nhận giao thành công");
            writeJson(resp, "{\"ok\":true}");
        }
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
