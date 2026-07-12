package com.purenut.shop.controller.staff;

import com.purenut.shop.dao.StaffMessageDao;
import com.purenut.shop.dao.impl.StaffMessageDaoImpl;
import com.purenut.shop.model.StaffMessage;
import com.purenut.shop.model.User;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * API nội bộ nhân viên (SHIPPER / MANAGER / ADMIN):
 *  GET  /staff/chat?after=ID     → tin chat chung mới hơn ID (polling)
 *  POST /staff/chat  (message)   → gửi tin chat chung
 *  GET  /staff/notes?orderId=N   → ghi chú của đơn N
 *  POST /staff/notes (orderId, message) → thêm ghi chú vào đơn N
 */
@WebServlet(name = "StaffChatController", urlPatterns = {"/staff/chat", "/staff/notes"})
public class StaffChatController extends HttpServlet {

    private StaffMessageDao dao;

    @Override
    public void init() throws ServletException {
        dao = new StaffMessageDaoImpl();
    }

    /** Người dùng hiện tại: nhân viên (session "user") hoặc admin (session "adminUser"). */
    private User currentStaff(HttpServletRequest req) {
        User u = (User) req.getSession().getAttribute("user");
        if (u != null && ("SHIPPER".equals(u.getRole()) || "MANAGER".equals(u.getRole()))) return u;
        User admin = (User) req.getSession().getAttribute("adminUser");
        return admin; // null nếu không phải staff
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User staff = currentStaff(req);
        if (staff == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        List<StaffMessage> list;
        if ("/staff/notes".equals(req.getServletPath())) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            if (orderId <= 0) { writeJson(resp, "{\"ok\":false,\"msg\":\"orderId không hợp lệ\"}"); return; }
            list = dao.findNotesByOrder(orderId);
        } else {
            int after = Validators.parsePositiveInt(req.getParameter("after"), 0);
            list = dao.findChatAfter(after);
        }
        writeJson(resp, toJson(list, staff.getUserId()));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        User staff = currentStaff(req);
        if (staff == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        String message = req.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Nội dung trống\"}");
            return;
        }
        message = message.trim();
        if (message.length() > 500) message = message.substring(0, 500);

        int id;
        if ("/staff/notes".equals(req.getServletPath())) {
            int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), -1);
            if (orderId <= 0) { writeJson(resp, "{\"ok\":false,\"msg\":\"orderId không hợp lệ\"}"); return; }
            id = dao.insertNote(orderId, staff.getUserId(), message);
        } else {
            id = dao.insertChat(staff.getUserId(), message);
        }
        writeJson(resp, id > 0 ? "{\"ok\":true,\"id\":" + id + "}" : "{\"ok\":false,\"msg\":\"Không gửi được\"}");
    }

    private String toJson(List<StaffMessage> list, int myId) {
        SimpleDateFormat fmt = new SimpleDateFormat("HH:mm dd/MM");
        StringBuilder sb = new StringBuilder("{\"ok\":true,\"items\":[");
        for (int i = 0; i < list.size(); i++) {
            StaffMessage m = list.get(i);
            if (i > 0) sb.append(',');
            sb.append("{\"id\":").append(m.getId())
              .append(",\"mine\":").append(m.getUserId() == myId)
              .append(",\"name\":\"").append(esc(m.getUserName())).append('"')
              .append(",\"role\":\"").append(esc(m.getUserRole())).append('"')
              .append(",\"msg\":\"").append(esc(m.getMessage())).append('"')
              .append(",\"time\":\"").append(m.getCreatedAt() != null ? fmt.format(m.getCreatedAt()) : "").append('"')
              .append('}');
        }
        return sb.append("]}").toString();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "")
                .replace("<", "\\u003c").replace(">", "\\u003e");
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
