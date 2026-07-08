package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.AuditLogDao;
import com.purenut.shop.dao.impl.AuditLogDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/nhat-ky"})
public class AdminAuditController extends HttpServlet {

    private final AuditLogDao auditLogDao = new AuditLogDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("logs", auditLogDao.findRecent(200));
        req.setAttribute("pageTitle", "Nhật ký hoạt động");
        req.getRequestDispatcher("/WEB-INF/views/admin/audit-list.jsp").forward(req, resp);
    }
}
