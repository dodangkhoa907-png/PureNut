package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.CartItemDao;
import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.UserAddressDao;
import com.purenut.shop.dao.impl.CartItemDaoImpl;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.UserAddressDaoImpl;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.User;
import com.purenut.shop.model.UserAddress;
import com.purenut.shop.util.Coupons;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.purenut.shop.config.PayOSConfig;
import com.purenut.shop.service.PayOSService;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/checkout/success"})
public class CheckoutController extends HttpServlet {

    private CartItemDao cartItemDao;
    private OrderDao orderDao;
    private UserAddressDao addressDao;

    @Override
    public void init() throws ServletException {
        cartItemDao = new CartItemDaoImpl();
        orderDao = new OrderDaoImpl();
        addressDao = new UserAddressDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String path = request.getServletPath();
        
        if ("/checkout/success".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/checkout-success.jsp").forward(request, response);
            return;
        }
        
        User user = (User) request.getSession().getAttribute("user");
        List<CartItem> cartItems = cartItemDao.findByUserId(user.getUserId());

        String itemsParam = request.getParameter("items");
        if (itemsParam != null && !itemsParam.trim().isEmpty()) {
            Set<Integer> selectedIds = Arrays.stream(itemsParam.split(","))
                    .map(String::trim)
                    .filter(s -> s.matches("\\d+"))
                    .map(Integer::parseInt)
                    .collect(Collectors.toSet());
            cartItems = cartItems.stream()
                    .filter(ci -> selectedIds.contains(ci.getCartItemId()))
                    .collect(Collectors.toList());
        }

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            totalAmount = totalAmount.add(item.getTotalPrice());
        }
        
        DecimalFormat df = new DecimalFormat("#,###");
        String formattedTotal = df.format(totalAmount).replace(',', '.');
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("formattedTotal", formattedTotal);

        List<UserAddress> addresses = addressDao.findByUserId(user.getUserId());
        if (!addresses.isEmpty()) {
            UserAddress def = addresses.get(0);
            request.setAttribute("savedAddress", def.getFullAddress());
            request.setAttribute("savedPhone", def.getPhone());
            request.setAttribute("savedName", def.getRecipientName());
        }

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── PayOS: kiểm tra trạng thái / hủy QR (AJAX) ─────────
        String action = request.getParameter("action");
        if ("qr-status".equals(action)) { handleQrStatus(request, response); return; }
        if ("qr-cancel".equals(action)) { handleQrCancel(request, response); return; }

        boolean ajax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        User user = (User) request.getSession().getAttribute("user");
        List<CartItem> cartItems = cartItemDao.findByUserId(user.getUserId());

        String itemsParam = request.getParameter("items");
        if (itemsParam != null && !itemsParam.trim().isEmpty()) {
            Set<Integer> selectedIds = Arrays.stream(itemsParam.split(","))
                    .map(String::trim)
                    .filter(s -> s.matches("\\d+"))
                    .map(Integer::parseInt)
                    .collect(Collectors.toSet());
            cartItems = cartItems.stream()
                    .filter(ci -> selectedIds.contains(ci.getCartItemId()))
                    .collect(Collectors.toList());
        }

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        String couponCode = request.getParameter("couponCode"); // Nếu có

        // ── Validate phía server ──────────────────────────────
        String error = validate(fullName, phone, address, paymentMethod);
        if (error != null) {
            if (ajax) { writeJson(response, "{\"ok\":false,\"msg\":\"" + escJson(error) + "\"}"); return; }
            request.setAttribute("errorMessage", error);
            doGet(request, response);
            return;
        }

        // ── Tính tổng + áp mã giảm giá PURENUT20 ──────────────
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            subtotal = subtotal.add(item.getTotalPrice());
        }
        boolean couponValid = Coupons.isValid(couponCode);
        BigDecimal totalAmount = Coupons.applyDiscount(couponCode, subtotal);

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setFullName(fullName.trim());
        order.setPhone(phone.trim());
        order.setAddress(address.trim());
        order.setPaymentMethod(paymentMethod);
        order.setTotalAmount(totalAmount);
        order.setCouponCode(couponValid ? Coupons.PURENUT20 : null);

        boolean bankTransfer = "BANK_TRANSFER".equals(paymentMethod);
        long amount = totalAmount.longValue();

        // ── Chuyển khoản: tạo QR PayOS TRƯỚC khi đặt hàng ─────
        // (tránh đơn "mồ côi" nếu PayOS lỗi — chỉ đặt hàng khi có QR hợp lệ)
        Map<String, Object> qr = null;
        long orderCode = 0;
        if (bankTransfer) {
            if (!PayOSConfig.isConfigured()) {
                writeJson(response, "{\"ok\":false,\"msg\":\"Cổng thanh toán chưa được cấu hình.\"}");
                return;
            }
            if (amount < 1000) {
                writeJson(response, "{\"ok\":false,\"msg\":\"Số tiền tối thiểu 1.000đ.\"}");
                return;
            }
            try {
                orderCode = System.currentTimeMillis() % 100_000_000L;
                String baseUrl = request.getScheme() + "://" + request.getServerName()
                        + ":" + request.getServerPort() + request.getContextPath();
                qr = PayOSService.createPayment(orderCode, amount, "PureNut " + orderCode, baseUrl);
                if (!Boolean.TRUE.equals(qr.get("ok"))) {
                    writeJson(response, "{\"ok\":false,\"msg\":\"" + escJson("Không tạo được mã QR: " + qr.get("msg")) + "\"}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                writeJson(response, "{\"ok\":false,\"msg\":\"Lỗi kết nối cổng thanh toán, vui lòng thử lại.\"}");
                return;
            }
        }

        try {
            int orderId = orderDao.placeOrder(order, cartItems);
            if (orderId > 0) {
                int newCartCount = cartItemDao.countItems(user.getUserId());
                request.getSession().setAttribute("cartCount", newCartCount);

                com.purenut.shop.util.OrderEventBus.publish(
                    new com.purenut.shop.util.OrderEventBus.OrderEvent(
                        orderId, fullName.trim(), phone.trim(),
                        totalAmount.longValue(), paymentMethod,
                        System.currentTimeMillis()));

                if (bankTransfer) {
                    // Lưu ánh xạ orderCode → orderId để xác nhận khi thanh toán thành công
                    request.getSession().setAttribute("payos_" + orderCode, orderId);
                    writeJson(response, "{\"ok\":true,\"payos\":true"
                            + ",\"qrCode\":\"" + escJson((String) qr.get("qrCode")) + "\""
                            + ",\"checkoutUrl\":\"" + escJson((String) qr.get("checkoutUrl")) + "\""
                            + ",\"orderCode\":" + orderCode
                            + ",\"amount\":" + amount + "}");
                    return;
                }

                // COD
                if (ajax) {
                    writeJson(response, "{\"ok\":true,\"redirect\":\"" + request.getContextPath() + "/checkout/success\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/checkout/success");
                }
            } else {
                failCheckout(request, response, ajax, "Không thể đặt hàng, vui lòng thử lại.");
            }
        } catch (com.purenut.shop.exception.OutOfStockException e) {
            failCheckout(request, response, ajax, e.getMessage() + " Vui lòng giảm số lượng hoặc chọn sản phẩm khác.");
        } catch (Exception e) {
            e.printStackTrace();
            failCheckout(request, response, ajax, "Lỗi hệ thống trong quá trình đặt hàng, vui lòng thử lại.");
        }
    }

    private void failCheckout(HttpServletRequest request, HttpServletResponse response,
                              boolean ajax, String msg) throws ServletException, IOException {
        if (ajax) { writeJson(response, "{\"ok\":false,\"msg\":\"" + escJson(msg) + "\"}"); return; }
        request.setAttribute("errorMessage", msg);
        doGet(request, response);
    }

    // ── PayOS: kiểm tra trạng thái thanh toán ──────────────────
    private void handleQrStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String codeParam = request.getParameter("orderCode");
        if (codeParam == null || !codeParam.matches("\\d+")) {
            writeJson(response, "{\"status\":\"UNKNOWN\"}");
            return;
        }
        try {
            long orderCode = Long.parseLong(codeParam);
            String status = PayOSService.checkStatus(orderCode);
            if ("PAID".equals(status)) {
                HttpSession session = request.getSession();
                Object oid = session.getAttribute("payos_" + orderCode);
                if (oid instanceof Integer orderId) {
                    orderDao.updateOrderStatus(orderId, "CONFIRMED");
                    session.removeAttribute("payos_" + orderCode);
                }
                writeJson(response, "{\"status\":\"PAID\",\"redirect\":\""
                        + request.getContextPath() + "/checkout/success\"}");
                return;
            }
            writeJson(response, "{\"status\":\"" + escJson(status) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, "{\"status\":\"UNKNOWN\"}");
        }
    }

    // ── PayOS: hủy QR (khách đóng cửa sổ thanh toán) ───────────
    private void handleQrCancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String codeParam = request.getParameter("orderCode");
        if (codeParam == null || !codeParam.matches("\\d+")) { writeJson(response, "{\"ok\":false}"); return; }
        long orderCode = Long.parseLong(codeParam);
        boolean ok = PayOSService.cancelPayment(orderCode);
        writeJson(response, "{\"ok\":" + ok + "}");
    }

    private void writeJson(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) { out.print(json); }
    }

    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", " ").replace("\r", " ");
    }

    /** Trả về thông báo lỗi đầu tiên, hoặc null nếu hợp lệ. */
    private String validate(String fullName, String phone, String address, String paymentMethod) {
        if (Validators.isBlank(fullName)) {
            return "Vui lòng nhập họ tên người nhận.";
        }
        if (!Validators.isValidPhone(phone)) {
            return "Số điện thoại không hợp lệ (bắt đầu bằng 0, 10–11 chữ số).";
        }
        if (Validators.isBlank(address)) {
            return "Vui lòng nhập địa chỉ giao hàng.";
        }
        if (!"COD".equals(paymentMethod) && !"BANK_TRANSFER".equals(paymentMethod)) {
            return "Vui lòng chọn phương thức thanh toán hợp lệ.";
        }
        return null;
    }
}
