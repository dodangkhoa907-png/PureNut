package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.ShipperDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.ShipperDaoImpl;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.Shipper;
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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {
        "/admin/nhan-su",
        "/admin/nhan-su/tao",
        "/admin/nhan-su/doi-role",
        "/admin/nhan-su/cap-nhat",
        "/admin/nhan-su/doi-mat-khau"
})
public class AdminStaffController extends HttpServlet {

    private UserDao userDao;
    private ShipperDao shipperDao;
    private OrderDao orderDao;
    private static final Set<String> STAFF_ROLES = Set.of("SHIPPER", "CUSTOMER");

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
        shipperDao = new ShipperDaoImpl();
        orderDao = new OrderDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<User> staff = new ArrayList<>(userDao.findByRole("SHIPPER"));
        List<Shipper> shipperProfiles = shipperDao.findAll();
        Map<Integer, Shipper> profileMap = shipperProfiles.stream()
                .collect(Collectors.toMap(Shipper::getShipperId, s -> s, (a, b) -> a));

        List<Order> allOrders = orderDao.findAllOrders();
        Map<Integer, Long> shippingCount = allOrders.stream()
                .filter(o -> "SHIPPING".equals(o.getStatus()) && o.getShipperId() != null)
                .collect(Collectors.groupingBy(o -> o.getShipperId(), Collectors.counting()));
        Map<Integer, Long> doneCount = allOrders.stream()
                .filter(o -> "DONE".equals(o.getStatus()) && o.getShipperId() != null)
                .collect(Collectors.groupingBy(o -> o.getShipperId(), Collectors.counting()));

        req.setAttribute("staffList", staff);
        req.setAttribute("profileMap", profileMap);
        req.setAttribute("shippingCount", shippingCount);
        req.setAttribute("doneCount", doneCount);
        req.setAttribute("pageTitle", "Quản lý Nhân sự");
        req.getRequestDispatcher("/WEB-INF/views/admin/staff-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        User admin = (User) req.getSession().getAttribute("adminUser");
        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

        if ("/admin/nhan-su/tao".equals(path)) {
            handleCreate(req, resp, admin);
            return;
        }
        if ("/admin/nhan-su/doi-role".equals(path)) {
            handleRoleChange(req, resp, admin, isAjax);
            return;
        }
        if ("/admin/nhan-su/cap-nhat".equals(path)) {
            handleUpdateProfile(req, resp, admin);
            return;
        }
        if ("/admin/nhan-su/doi-mat-khau".equals(path)) {
            handleResetPassword(req, resp, admin);
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, User admin)
            throws IOException {
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (fullName == null || fullName.isEmpty() || !Validators.isValidEmail(email)
                || password == null || password.length() < 8
                || !"SHIPPER".equals(role)) {
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
            shipperDao.ensureProfile(id, fullName, phone);
            AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                    "CREATE_STAFF", email, "Tạo tài khoản " + role + ": " + fullName);
            resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?success=created");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?error=InsertFail");
        }
    }

    private void handleRoleChange(HttpServletRequest req, HttpServletResponse resp,
                                  User admin, boolean isAjax) throws IOException {
        int userId = Validators.parsePositiveInt(req.getParameter("userId"), -1);
        String role = req.getParameter("role");
        if (userId <= 0 || role == null || !STAFF_ROLES.contains(role)) {
            if (isAjax) { writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}"); }
            else { resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?error=BadInput"); }
            return;
        }
        userDao.updateRole(userId, role);
        AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                "UPDATE_STAFF_ROLE", "User #" + userId, "Đổi role sang " + role);
        if (isAjax) { writeJson(resp, "{\"ok\":true}"); }
        else { resp.sendRedirect(req.getContextPath() + "/admin/nhan-su?success=updated"); }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp,
                                     User admin) throws IOException {
        int userId = Validators.parsePositiveInt(req.getParameter("userId"), -1);
        String fullName = trim(req.getParameter("fullName"));
        String phone = trim(req.getParameter("phone"));
        if (userId <= 0 || fullName == null || fullName.isEmpty()) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Dữ liệu không hợp lệ\"}");
            return;
        }
        boolean ok = userDao.updateProfile(userId, fullName, phone);
        if (ok) {
            AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                    "UPDATE_STAFF_PROFILE", "User #" + userId, "Cập nhật: " + fullName);
        }
        writeJson(resp, ok ? "{\"ok\":true}" : "{\"ok\":false,\"msg\":\"Không cập nhật được\"}");
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp,
                                     User admin) throws IOException {
        int userId = Validators.parsePositiveInt(req.getParameter("userId"), -1);
        String newPassword = req.getParameter("newPassword");
        if (userId <= 0 || newPassword == null || newPassword.length() < 8) {
            writeJson(resp, "{\"ok\":false,\"msg\":\"Mật khẩu phải >= 8 ký tự\"}");
            return;
        }
        boolean ok = userDao.updatePassword(userId, Passwords.hash(newPassword));
        if (ok) {
            AuditLogger.log(req, admin != null ? admin.getUserId() : null,
                    "RESET_STAFF_PASSWORD", "User #" + userId, "Admin reset mật khẩu");
        }
        writeJson(resp, ok ? "{\"ok\":true}" : "{\"ok\":false,\"msg\":\"Không đổi được mật khẩu\"}");
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }

    private static String trim(String s) { return s == null ? null : s.trim(); }
}
