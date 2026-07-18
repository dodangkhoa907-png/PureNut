package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.ReviewDao;
import com.purenut.shop.dao.UserAddressDao;
import com.purenut.shop.dao.UserDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.ReviewDaoImpl;
import com.purenut.shop.dao.impl.UserAddressDaoImpl;
import com.purenut.shop.dao.impl.UserDaoImpl;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.OrderItem;
import com.purenut.shop.model.Review;
import com.purenut.shop.model.User;
import com.purenut.shop.model.UserAddress;
import com.purenut.shop.util.AuditLogger;
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
                       "/account/address", "/account/address/delete", "/account/address/default",
                       "/account/order/cancel", "/account/order/confirm", "/account/avatar"})
public class AccountController extends HttpServlet {

    private OrderDao orderDao;
    private UserDao userDao;
    private UserAddressDao addressDao;
    private ReviewDao reviewDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        userDao = new UserDaoImpl();
        addressDao = new UserAddressDaoImpl();
        reviewDao = new ReviewDaoImpl();
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
        int doneCount = 0;          // DONE đã xác nhận — khớp với tab Lịch sử
        int totalDoneCount = 0;     // toàn bộ DONE (đã xác nhận + chờ xác nhận) — dùng cho thẻ thống kê "Hoàn thành"
        int awaitingConfirmCount = 0;

        for (Order o : orderHistory) {
            if ("DONE".equals(o.getStatus())) {
                totalSpent = totalSpent.add(o.getTotalAmount());
                totalDoneCount++;
                if (o.getReceivedConfirmedAt() != null) {
                    doneCount++;
                } else {
                    awaitingConfirmCount++;
                }
            }
            if ("PENDING".equals(o.getStatus()) || "CONFIRMED".equals(o.getStatus()) || "SHIPPING".equals(o.getStatus()) || "PENDING_CANCEL".equals(o.getStatus())) {
                pendingCount++;
            }
        }

        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalSpent", totalSpent);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("doneCount", doneCount);
        req.setAttribute("totalDoneCount", totalDoneCount);
        req.setAttribute("awaitingConfirmCount", awaitingConfirmCount);

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
            case "/account/order/cancel"    -> handleCancelOrder(req, resp, user);
            case "/account/order/confirm"   -> handleConfirmReceived(req, resp, user);
            case "/account/avatar"         -> handleUpdateAvatar(req, resp, user);
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

    private void handleCancelOrder(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String oidStr = req.getParameter("orderId");
        String reason = req.getParameter("reason");

        if (oidStr == null || reason == null || reason.trim().isEmpty()) {
            writeJson(resp, 400, "{\"error\":\"Vui lòng chọn lý do hủy.\"}");
            return;
        }

        int orderId;
        try { orderId = Integer.parseInt(oidStr.trim()); } catch (NumberFormatException e) {
            writeJson(resp, 400, "{\"error\":\"ID đơn hàng không hợp lệ.\"}");
            return;
        }

        Order order = orderDao.findOrderById(orderId);
        if (order == null) {
            writeJson(resp, 404, "{\"error\":\"Đơn hàng không tồn tại.\"}");
            return;
        }
        if (order.getUserId() != user.getUserId()) {
            writeJson(resp, 403, "{\"error\":\"Bạn không có quyền hủy đơn này.\"}");
            return;
        }

        String st = order.getStatus();
        if (!"PENDING".equals(st) && !"CONFIRMED".equals(st)) {
            writeJson(resp, 400, "{\"error\":\"Không thể hủy đơn ở trạng thái hiện tại.\"}");
            return;
        }

        try {
            if ("COD".equals(order.getPaymentMethod())) {
                orderDao.cancelOrder(orderId, user.getUserId(), reason.trim());
                AuditLogger.log(req, user.getUserId(), "CANCEL_ORDER",
                        "Đơn #" + orderId, reason.trim());
                writeJson(resp, 200, "{\"success\":true,\"message\":\"Đã hủy đơn hàng thành công.\"}");
            } else {
                orderDao.requestCancelOrder(orderId, user.getUserId(), reason.trim());
                AuditLogger.log(req, user.getUserId(), "REQUEST_CANCEL_ORDER",
                        "Đơn #" + orderId, reason.trim());
                writeJson(resp, 200, "{\"success\":true,\"pending\":true,\"message\":\"Yêu cầu hủy đã được gửi. Vui lòng chờ admin duyệt hoàn tiền.\"}");
            }
        } catch (SecurityException e) {
            writeJson(resp, 403, "{\"error\":\"" + escJson(e.getMessage()) + "\"}");
        } catch (IllegalStateException e) {
            writeJson(resp, 400, "{\"error\":\"" + escJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(resp, 500, "{\"error\":\"Có lỗi hệ thống. Vui lòng thử lại.\"}");
        }
    }

    /** Khách hàng xác nhận đã nhận hàng cho đơn DONE, kèm đánh giá sao tùy chọn (1-5) + nhận xét tùy chọn. */
    private void handleConfirmReceived(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        int orderId = Validators.parsePositiveInt(req.getParameter("orderId"), 0);
        if (orderId <= 0) { writeJson(resp, 400, "{\"error\":\"ID đơn hàng không hợp lệ.\"}"); return; }

        Order order = orderDao.findOrderById(orderId);
        if (order == null) { writeJson(resp, 404, "{\"error\":\"Đơn hàng không tồn tại.\"}"); return; }
        if (order.getUserId() != user.getUserId()) {
            writeJson(resp, 403, "{\"error\":\"Bạn không có quyền xác nhận đơn này.\"}");
            return;
        }
        if (!"DONE".equals(order.getStatus())) {
            writeJson(resp, 400, "{\"error\":\"Đơn hàng chưa được giao xong.\"}");
            return;
        }
        if (order.getReceivedConfirmedAt() != null) {
            writeJson(resp, 400, "{\"error\":\"Đơn hàng này đã được xác nhận trước đó.\"}");
            return;
        }

        Integer rating = null;
        String ratingParam = req.getParameter("rating");
        if (ratingParam != null && !ratingParam.isBlank()) {
            int r = Validators.parsePositiveInt(ratingParam, 0);
            if (r < 1 || r > 5) { writeJson(resp, 400, "{\"error\":\"Số sao không hợp lệ (1-5).\"}"); return; }
            rating = r;
        }
        String review = req.getParameter("review");
        if (review != null) {
            review = review.trim();
            if (review.length() > 500) review = review.substring(0, 500);
            if (review.isEmpty()) review = null;
        }

        int n = orderDao.confirmReceived(orderId, user.getUserId(), rating, review);
        if (n > 0) {
            AuditLogger.log(req, user.getUserId(), "CONFIRM_RECEIVED",
                    "Đơn #" + orderId, rating != null ? "Khách xác nhận nhận hàng, đánh giá " + rating + " sao" : "Khách xác nhận nhận hàng");

            if (rating != null && order.getItems() != null) {
                java.util.Set<Integer> reviewedProducts = new java.util.HashSet<>();
                for (OrderItem item : order.getItems()) {
                    if (!reviewedProducts.add(item.getProductId())) continue;
                    Review r = new Review();
                    r.setProductId(item.getProductId());
                    r.setUserId(user.getUserId());
                    r.setRating(rating);
                    r.setComment(review);
                    reviewDao.insert(r);
                }
            }

            writeJson(resp, 200, "{\"success\":true,\"message\":\"Cảm ơn bạn đã xác nhận!\"}");
        } else {
            writeJson(resp, 400, "{\"error\":\"Không thể xác nhận (đơn có thể đã được xác nhận ở nơi khác).\"}");
        }
    }

    private void handleUpdateAvatar(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String imageData = req.getParameter("imageData");
        if (imageData == null || imageData.isEmpty()) {
            writeJson(resp, 400, "{\"error\":\"Không có dữ liệu ảnh.\"}");
            return;
        }
        if (!imageData.startsWith("data:image/")) {
            writeJson(resp, 400, "{\"error\":\"Định dạng ảnh không hợp lệ.\"}");
            return;
        }
        if (imageData.length() > 200_000) {
            writeJson(resp, 400, "{\"error\":\"Ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn.\"}");
            return;
        }
        boolean ok = userDao.updateProfileImage(user.getUserId(), imageData);
        if (ok) {
            user.setProfileImage(imageData);
            writeJson(resp, 200, "{\"success\":true}");
        } else {
            writeJson(resp, 500, "{\"error\":\"Có lỗi hệ thống.\"}");
        }
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
