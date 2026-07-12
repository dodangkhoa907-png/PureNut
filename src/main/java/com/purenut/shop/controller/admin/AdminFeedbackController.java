package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.FeedbackDao;
import com.purenut.shop.dao.impl.FeedbackDaoImpl;
import com.purenut.shop.model.User;
import com.purenut.shop.util.AuditLogger;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Set;

@WebServlet(urlPatterns = {"/admin/phan-hoi", "/admin/phan-hoi/cap-nhat"})
public class AdminFeedbackController extends HttpServlet {

    private final FeedbackDao feedbackDao = new FeedbackDaoImpl();
    private static final Set<String> ALLOWED_STATUS = Set.of("NEW", "SEEN", "RESOLVED");
    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = Validators.parsePositiveInt(req.getParameter("page"), 1);
        if (page < 1) page = 1;

        int totalItems = feedbackDao.countAll();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * PAGE_SIZE;

        req.setAttribute("feedbacks", feedbackDao.findAllPaged(offset, PAGE_SIZE));
        req.setAttribute("newCount", feedbackDao.countByStatus("NEW"));
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageTitle", "Phản hồi khách hàng");
        req.getRequestDispatcher("/WEB-INF/views/admin/feedback-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("/admin/phan-hoi/cap-nhat".equals(req.getServletPath())) {
            int id = Validators.parsePositiveInt(req.getParameter("feedbackId"), -1);
            String status = req.getParameter("status");

            if (id <= 0 || status == null || !ALLOWED_STATUS.contains(status)) {
                resp.sendRedirect(req.getContextPath() + "/admin/phan-hoi?error=BadInput");
                return;
            }

            feedbackDao.updateStatus(id, status);

            User admin = (User) req.getSession().getAttribute("adminUser");
            AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                    "UPDATE_FEEDBACK_STATUS", "Feedback #" + id, "Đổi trạng thái phản hồi sang " + status);

            String page = req.getParameter("page");
            resp.sendRedirect(req.getContextPath() + "/admin/phan-hoi?success=true" + (page != null ? "&page=" + page : ""));
        }
    }
}
