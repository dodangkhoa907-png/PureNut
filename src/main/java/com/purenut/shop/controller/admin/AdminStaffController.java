package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.User;
import com.purenut.shop.util.AuditLogger;
import com.purenut.shop.util.Passwords;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Admin quản lý nhân sự (SHIPPER / MANAGER):
 *  GET  /admin/nhan-su            → danh sách nhân viên
 *  POST /admin/nhan-su/tao        → tạo tài khoản nhân viên
 *  POST /admin/nhan-su/doi-role   → đổi role (SHIPPER ↔ MANAGER ↔ CUSTOMER = khóa)
 */
@WebServlet(urlPatterns = {"/admin/nhan-su", "/admin/nhan-su/tao", "/admin/nhan-su/doi-role"})
public class AdminStaffController extends HttpServlet {

    private UserDao userDao;
    private static final Set<String> STAFF_ROLES = Set.of("SHIPPER", "MANAGER", "CUSTOMER");

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<User> staff = new ArrayList<>();
        staff.addAll(userDao.findByRole("MANAGER"));
        staff.addAll(userDao.findByRole("SHIPPER"));
        req.setAttribute("staffList", staff);
        req.setAttribute("pageTitle", "Quản lý Nhân sự");
        req.getRequestDispatcher("/WEB-INF/views/admin/staff-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        User admin = (User) req.getSession().getAttribute("adminUser");

        if ("/admin/nhan-su/tao".equals(path)) {
            String fullName = trim(req.getParameter("fullName"));
            String email = trim(req.getParameter("email"));
            String phone = trim(req.getParameter("phone"));
            String password = req.getParameter("password");
            String role = req.getParameter("role");

            if (fullName == null || fullName.isEmpty() || !Validators.isValidEmail(email)
                    || password == null || password.length() < 8
                    || (!"SHIPPER".equals(role) && !"MANAGER".equals(role))) {
                resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?error=BadInput");
                return;
            }
            if (userDao.existsByEmail(email)) {
                resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?error=EmailExists");
                return;
            }

            User u = new User(fullName, email, phone, Passwords.hash(password), role);
            int id = userDao.insert(u);
            if (id > 0) {
                AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                        "CREATE_STAFF", email, "Tạo tài khoản " + role + ": " + fullName);
                resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?success=created");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?error=InsertFail");
            }
            return;
        }

        if ("/admin/nhan-su/doi-role".equals(path)) {
            int userId = Validators.parsePositiveInt(req.getParameter("userId"), -1);
            String role = req.getParameter("role");
            if (userId <= 0 || role == null || !STAFF_ROLES.contains(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?error=BadInput");
                return;
            }
            userDao.updateRole(userId, role);
            AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                    "UPDATE_STAFF_ROLE", "User #" + userId, "Đổi role sang " + role);
            resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?success=updated");
        }
    }

    private static String trim(String s) { return s == null ? null : s.trim(); }
}
