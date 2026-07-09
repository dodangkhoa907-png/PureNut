package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.CartItemDao;
import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.impl.CartItemDaoImpl;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.Order;
import com.purenut.shop.model.User;
import com.purenut.shop.util.Coupons;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/checkout/success"})
public class CheckoutController extends HttpServlet {

    private CartItemDao cartItemDao;
    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        cartItemDao = new CartItemDaoImpl();
        orderDao = new OrderDaoImpl();
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
        
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
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

                response.sendRedirect(request.getContextPath() + "/checkout/success");
            } else {
                request.setAttribute("errorMessage", "Không thể đặt hàng, vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (com.purenut.shop.exception.OutOfStockException e) {
            request.setAttribute("errorMessage", e.getMessage() + " Vui lòng giảm số lượng hoặc chọn sản phẩm khác.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống trong quá trình đặt hàng, vui lòng thử lại.");
            doGet(request, response);
        }
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
