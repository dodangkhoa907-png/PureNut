package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.FeedbackDao;
import com.purenut.shop.dao.impl.FeedbackDaoImpl;
import com.purenut.shop.model.Feedback;
import com.purenut.shop.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedDeque;

@WebServlet(name = "FeedbackController", urlPatterns = {"/feedback"})
public class FeedbackController extends HttpServlet {

    private FeedbackDao feedbackDao;

    private static final int MAX_REQUESTS = 3;
    private static final long WINDOW_MS = 5 * 60 * 1000; // 5 phút
    private final ConcurrentHashMap<String, ConcurrentLinkedDeque<Long>> ipHits = new ConcurrentHashMap<>();

    @Override
    public void init() throws ServletException {
        feedbackDao = new FeedbackDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String clientIp = getClientIp(req);

        if (isRateLimited(clientIp)) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Bạn gửi quá nhiều, vui lòng thử lại sau 5 phút.\"}");
            return;
        }

        String name    = trim(req.getParameter("name"));
        String phone   = trim(req.getParameter("phone"));
        String email   = trim(req.getParameter("email"));
        String message = trim(req.getParameter("message"));
        String ratingS = req.getParameter("rating");

        User user = (User) req.getSession().getAttribute("user");

        if (user != null) {
            if (isBlank(name))  name  = user.getFullName();
            if (isBlank(email)) email = user.getEmail();
            if (isBlank(phone)) phone = user.getPhone();
        }

        if (isBlank(name))    { writeJson(resp, "{\"ok\":false,\"msg\":\"Vui lòng nhập tên của bạn.\"}"); return; }
        if (isBlank(message)) { writeJson(resp, "{\"ok\":false,\"msg\":\"Vui lòng nhập nội dung.\"}"); return; }
        if (message.length() > 1000) message = message.substring(0, 1000);
        if (name.length() > 150)     name = name.substring(0, 150);

        Integer rating = null;
        if (ratingS != null && ratingS.matches("[1-5]")) rating = Integer.parseInt(ratingS);

        Feedback fb = new Feedback();
        fb.setUserId(user != null ? user.getUserId() : null);
        fb.setName(name);
        fb.setPhone(isBlank(phone) ? null : phone);
        fb.setEmail(isBlank(email) ? null : email);
        fb.setRating(rating);
        fb.setMessage(message);
        fb.setIpAddress(clientIp);

        int id = feedbackDao.insert(fb);
        if (id > 0) {
            writeJson(resp, "{\"ok\":true,\"msg\":\"Cảm ơn bạn! Chúng tôi đã nhận được phản hồi.\"}");
        } else {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Không gửi được, vui lòng thử lại.\"}");
        }
    }

    private boolean isRateLimited(String ip) {
        long now = System.currentTimeMillis();
        ConcurrentLinkedDeque<Long> hits = ipHits.computeIfAbsent(ip, k -> new ConcurrentLinkedDeque<>());

        while (!hits.isEmpty() && now - hits.peekFirst() > WINDOW_MS) {
            hits.pollFirst();
        }

        if (hits.size() >= MAX_REQUESTS) return true;

        hits.addLast(now);
        return false;
    }

    private static String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty()) {
            ip = ip.split(",")[0].trim();
        }
        if (ip == null || ip.isEmpty()) {
            ip = req.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty()) {
            ip = req.getRemoteAddr();
        }
        return ip;
    }

    private static String trim(String s) { return s == null ? null : s.trim(); }
    private static boolean isBlank(String s) { return s == null || s.isEmpty(); }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
