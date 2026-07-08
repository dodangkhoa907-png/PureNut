package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.UserAddressDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.UserAddressDaoImpl;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.User;
import com.purenut.shop.model.UserAddress;
import com.purenut.shop.util.Passwords;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AccountController",
        urlPatterns = {"/account", "/account/profile", "/account/password",
                       "/account/address", "/account/address/delete", "/account/address/default"})
public class AccountController extends HttpServlet {

    private OrderDao orderDao;
    private UserDao userDao;
    private UserAddressDao addressDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        userDao = new UserDaoImpl();
        addressDao = new UserAddressDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = getUser(req);
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<Order> orderHistory = orderDao.findOrdersByUserId(user.getUserId());
        req.setAttribute("orderHistory", orderHistory);

        int totalOrders = orderHistory.size();
        BigDecimal totalSpent = BigDecimal.ZERO;
        int pendingCount = 0;
        int doneCount = 0;

        for (Order o : orderHistory) {
            if ("DONE".equals(o.getStatus())) {
                totalSpent = totalSpent.add(o.getTotalAmount());
                doneCount++;
            }
            if ("PENDING".equals(o.getStatus()) || "CONFIRMED".equals(o.getStatus()) || "SHIPPING".equals(o.getStatus())) {
                pendingCount++;
            }
        }

        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalSpent", totalSpent);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("doneCount", doneCount);

        String tier;
        if (totalSpent.compareTo(new BigDecimal("5000000")) >= 0) tier = "KIM_CUONG";
        else if (totalSpent.compareTo(new BigDecimal("2000000")) >= 0) tier = "VANG";
        else if (totalSpent.compareTo(new BigDecimal("500000")) >= 0) tier = "BAC";
        else tier = "MOI";
        req.setAttribute("memberTier", tier);

        List<UserAddress> addresses = addressDao.findByUserId(user.getUserId());
        req.setAttribute("addresses", addresses);

        req.getRequestDispatcher("/WEB-INF/views/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = getUser(req);
        if (user == null) { writeJson(resp, 401, "{\"error\":\"Unauthorized\"}"); return; }

        String path = req.getServletPath();
        switch (path) {
            case "/account/profile"         -> handleUpdateProfile(req, resp, user);
            case "/account/password"        -> handleChangePassword(req, resp, user);
            case "/account/address"         -> handleAddAddress(req, resp, user);
            case "/account/address/delete"  -> handleDeleteAddress(req, resp, user);
            case "/account/address/default" -> handleSetDefaultAddress(req, resp, user);
            default -> resp.sendRedirect(req.getContextPath() + "/account");
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()) {
            writeJson(resp, 400, "{\"error\":\"Vui lòng nhập họ tên.\"}");
            return;
        }
        if (phone == null || !phone.matches("0[0-9]{9,10}")) {
            writeJson(resp, 400, "{\"error\":\"Số điện thoại không hợp lệ.\"}");
            return;
        }

        boolean ok = userDao.updateProfile(user.getUserId(), fullName.trim(), phone.trim());
        if (ok) {
            user.setFullName(fullName.trim());
            user.setPhone(phone.trim());
            writeJson(resp, 200, "{\"success\":true,\"name\":\"" + escJson(fullName.trim()) + "\"}");
        } else {
            writeJson(resp, 500, "{\"error\":\"Có lỗi hệ thống.\"}");
        }
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String oldPw = req.getParameter("oldPassword");
        String newPw = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        User fresh = userDao.findById(user.getUserId()).orElse(null);
        if (fresh == null) { writeJson(resp, 400, "{\"error\":\"Tài khoản không tồn tại.\"}"); return; }

        if (oldPw == null || !Passwords.matches(oldPw, fresh.getPasswordHash())) {
            writeJson(resp, 400, "{\"error\":\"Mật khẩu hiện tại không đúng.\"}");
            return;
        }
        if (newPw == null || !newPw.equals(confirm)) {
            writeJson(resp, 400, "{\"error\":\"Mật khẩu xác nhận không khớp.\"}");
            return;
        }
        if (!newPw.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d]).{8,}$")) {
            writeJson(resp, 400, "{\"error\":\"Mật khẩu mới cần ít nhất 8 ký tự, gồm hoa, thường, số và đặc biệt.\"}");
            return;
        }

        boolean ok = userDao.updatePassword(user.getUserId(), Passwords.hash(newPw));
        if (ok) {
            writeJson(resp, 200, "{\"success\":true}");
        } else {
            writeJson(resp, 500, "{\"error\":\"Có lỗi hệ thống.\"}");
        }
    }

    private void handleAddAddress(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String label = req.getParameter("label");
        String recipientName = req.getParameter("recipientName");
        String phone = req.getParameter("phone");
        String province = req.getParameter("province");
        String district = req.getParameter("district");
        String ward = req.getParameter("ward");
        String street = req.getParameter("street");

        if (street == null || street.trim().isEmpty()) {
            writeJson(resp, 400, "{\"error\":\"Vui lòng nhập địa chỉ.\"}");
            return;
        }

        UserAddress addr = new UserAddress();
        addr.setUserId(user.getUserId());
        addr.setLabel(label != null && !label.isEmpty() ? label.trim() : "Nhà riêng");
        addr.setRecipientName(recipientName != null ? recipientName.trim() : user.getFullName());
        addr.setPhone(phone != null && !phone.isEmpty() ? phone.trim() : user.getPhone());
        addr.setProvince(province != null ? province.trim() : "");
        addr.setDistrict(district != null ? district.trim() : "");
        addr.setWard(ward != null ? ward.trim() : "");
        addr.setStreet(street.trim());

        int id = addressDao.insert(addr);
        if (id > 0) {
            writeJson(resp, 200, "{\"success\":true,\"addressId\":" + id + "}");
        } else {
            writeJson(resp, 500, "{\"error\":\"Có lỗi hệ thống.\"}");
        }
    }

    private void handleDeleteAddress(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        int addressId = Validators.parsePositiveInt(req.getParameter("addressId"), 0);
        if (addressId <= 0) { writeJson(resp, 400, "{\"error\":\"ID không hợp lệ.\"}"); return; }

        boolean ok = addressDao.delete(addressId, user.getUserId());
        writeJson(resp, ok ? 200 : 400, ok ? "{\"success\":true}" : "{\"error\":\"Không thể xóa.\"}");
    }

    private void handleSetDefaultAddress(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        int addressId = Validators.parsePositiveInt(req.getParameter("addressId"), 0);
        if (addressId <= 0) { writeJson(resp, 400, "{\"error\":\"ID không hợp lệ.\"}"); return; }

        boolean ok = addressDao.setDefault(addressId, user.getUserId());
        writeJson(resp, ok ? 200 : 500, ok ? "{\"success\":true}" : "{\"error\":\"Có lỗi.\"}");
    }

    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null ? (User) session.getAttribute("user") : null;
    }

    private void writeJson(HttpServletResponse resp, int status, String json) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try (PrintWriter out = resp.getWriter()) { out.write(json); }
    }

    private String escJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
