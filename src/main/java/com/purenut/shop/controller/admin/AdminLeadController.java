package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.DealerLeadDao;
import com.purenut.shop.dao.impl.DealerLeadDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

// [DISABLED] Tính năng Đại lý tạm tắt — uncomment khi cần mở lại
// @WebServlet(urlPatterns = {
//     "/admin/dai-ly",
//     "/admin/dai-ly/cap-nhat"
// })
public class AdminLeadController extends HttpServlet {

    private final DealerLeadDao dealerLeadDao = new DealerLeadDaoImpl();
    private static final Set<String> ALLOWED_LEAD_STATUS = Set.of("PENDING", "CONTACTED", "CLOSED");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("leads", dealerLeadDao.findAll());
        req.setAttribute("pageTitle", "Khách đăng ký Đại lý");
        req.getRequestDispatcher("/WEB-INF/views/admin/lead-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        
        if ("/admin/dai-ly/cap-nhat".equals(path)) {
            int leadId = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("leadId"), -1);
            String status = req.getParameter("status");

            if (leadId <= 0 || status == null || !ALLOWED_LEAD_STATUS.contains(status)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dai-ly?error=BadInput");
                return;
            }

            dealerLeadDao.updateStatus(leadId, status);

            com.purenut.shop.model.User admin = (com.purenut.shop.model.User) req.getSession().getAttribute("user");
            com.purenut.shop.util.AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                    "UPDATE_LEAD_STATUS", "Lead #" + leadId, "Đổi trạng thái đại lý sang " + status);

            resp.sendRedirect(req.getContextPath() + "/admin/dai-ly?success=true");
        }
    }
}
