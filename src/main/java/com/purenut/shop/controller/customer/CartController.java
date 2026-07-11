package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.CartItemDao;
import com.purenut.shop.dao.impl.CartItemDaoImpl;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.User;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;

@WebServlet(name = "CartController",
        urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove", "/cart/count"})
public class CartController extends HttpServlet {

    private CartItemDao cartItemDao;

    @Override
    public void init() throws ServletException {
        cartItemDao = new CartItemDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/cart/count".equals(path)) {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                writeJson(response, "{\"count\":0}");
                return;
            }
            int count = cartItemDao.countItems(user.getUserId());
            request.getSession().setAttribute("cartCount", count);
            writeJson(response, "{\"count\":" + count + "}");
            return;
        }

        if ("/cart".equals(path)) {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            List<CartItem> cartItems = cartItemDao.findByUserId(user.getUserId());

            BigDecimal totalAmount = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                totalAmount = totalAmount.add(item.getTotalPrice());
            }

            DecimalFormat df = new DecimalFormat("#,###");
            String formattedTotal = df.format(totalAmount).replace(',', '.');

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("formattedTotal", formattedTotal);

            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        User user = (User) request.getSession().getAttribute("user");

        switch (path) {
            case "/cart/add":   handleAdd(request, response, user);    break;
            case "/cart/update": handleUpdate(request, response, user); break;
            case "/cart/remove":    handleDelete(request, response, user); break;
            default: response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int productId = Validators.parsePositiveInt(request.getParameter("productId"), 0);
        int quantity = Validators.parsePositiveInt(request.getParameter("quantity"), 1);
        String action = request.getParameter("action"); // buy_now | null

        if (productId > 0) {
            cartItemDao.insertOrUpdate(user.getUserId(), productId, quantity);
        }

        int count = cartItemDao.countItems(user.getUserId());
        request.getSession().setAttribute("cartCount", count);

        if (isAjax(request)) {
            writeJson(response, "{\"success\":true,\"cartCount\":" + count + "}");
            return;
        }

        if ("buy_now".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/checkout");
        } else {
            String referer = request.getHeader("Referer");
            String ctxUrl = request.getRequestURL().toString();
            String origin = ctxUrl.substring(0, ctxUrl.indexOf(request.getRequestURI()));
            if (referer != null && (referer.startsWith(origin + "/") || referer.equals(origin))) {
                referer = referer.replaceAll("[&?]success=[^&]*", "");
                String separator = referer.contains("?") ? "&" : "?";
                response.sendRedirect(referer + separator + "success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart?success=added");
            }
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int cartItemId = Validators.parsePositiveInt(request.getParameter("cartItemId"), 0);
        int quantity = Validators.parsePositiveInt(request.getParameter("quantity"), 1);

        if (cartItemId > 0) {
            cartItemDao.updateQuantity(cartItemId, user.getUserId(), quantity);
            int count = cartItemDao.countItems(user.getUserId());
            request.getSession().setAttribute("cartCount", count);

            if (isAjax(request)) {
                writeJson(response, "{\"success\":true,\"cartCount\":" + count + "}");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int cartItemId = Validators.parsePositiveInt(request.getParameter("cartItemId"), 0);
        if (cartItemId > 0) {
            cartItemDao.delete(cartItemId, user.getUserId());
            int count = cartItemDao.countItems(user.getUserId());
            request.getSession().setAttribute("cartCount", count);
            
            if (isAjax(request)) {
                writeJson(response, "{\"success\":true,\"cartCount\":" + count + "}");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
    }

    private void writeJson(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.write(json);
        }
    }
}
