package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.OrderDaoImpl;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/admin", "/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    private final ProductDao productDao = new ProductDaoImpl();
    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<Order> orders = orderDao.findAllOrders();
        int totalOrders = orders.size();

        int pendingOrders = 0, doneOrders = 0, cancelledOrders = 0, shippingOrders = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal todayRevenue = BigDecimal.ZERO;
        int todayOrders = 0;

        LocalDate today = LocalDate.now();
        ZoneId zone = ZoneId.systemDefault();

        // Chuẩn bị chuỗi doanh thu 7 ngày gần nhất
        DateTimeFormatter lbl = DateTimeFormatter.ofPattern("dd/MM");
        List<String> chartLabels = new ArrayList<>();
        long[] daily = new long[7];
        LocalDate[] days = new LocalDate[7];
        for (int i = 0; i < 7; i++) {
            days[i] = today.minusDays(6 - i);
            chartLabels.add(days[i].format(lbl));
        }

        for (Order o : orders) {
            String st = o.getStatus() == null ? "" : o.getStatus();
            BigDecimal amt = o.getTotalAmount() == null ? BigDecimal.ZERO : o.getTotalAmount();

            switch (st) {
                case "PENDING"   -> pendingOrders++;
                case "SHIPPING", "CONFIRMED" -> shippingOrders++;
                case "DONE"      -> { doneOrders++; totalRevenue = totalRevenue.add(amt); }
                case "CANCELLED" -> cancelledOrders++;
                default -> {}
            }

            LocalDate d = o.getCreatedAt() == null ? null
                    : o.getCreatedAt().toInstant().atZone(zone).toLocalDate();
            if (d != null) {
                if (d.equals(today)) { todayOrders++; if ("DONE".equals(st)) todayRevenue = todayRevenue.add(amt); }
                if ("DONE".equals(st)) {
                    for (int i = 0; i < 7; i++) {
                        if (d.equals(days[i])) { daily[i] += amt.longValue(); break; }
                    }
                }
            }
        }

        // AOV (giá trị trung bình mỗi đơn hoàn thành)
        BigDecimal aov = doneOrders > 0
                ? totalRevenue.divide(BigDecimal.valueOf(doneOrders), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // Tỷ lệ hoàn thành / huỷ
        int successRate = totalOrders > 0 ? Math.round(doneOrders * 100f / totalOrders) : 0;
        int cancelRate  = totalOrders > 0 ? Math.round(cancelledOrders * 100f / totalOrders) : 0;

        // chart values -> chuỗi "a,b,c" cho JS
        StringBuilder cv = new StringBuilder();
        long chartMax = 1;
        for (int i = 0; i < 7; i++) { if (daily[i] > chartMax) chartMax = daily[i]; }
        for (int i = 0; i < 7; i++) { if (i > 0) cv.append(','); cv.append(daily[i]); }

        int totalProducts = productDao.findAll().size();

        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("pendingOrders", pendingOrders);
        req.setAttribute("shippingOrders", shippingOrders);
        req.setAttribute("doneOrders", doneOrders);
        req.setAttribute("cancelledOrders", cancelledOrders);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("todayRevenue", todayRevenue);
        req.setAttribute("todayOrders", todayOrders);
        req.setAttribute("aov", aov);
        req.setAttribute("successRate", successRate);
        req.setAttribute("cancelRate", cancelRate);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("chartLabels", chartLabels);
        req.setAttribute("chartValues", cv.toString());
        req.setAttribute("chartMax", chartMax);

        int maxRecent = Math.min(6, orders.size());
        req.setAttribute("recentOrders", orders.subList(0, maxRecent));

        req.setAttribute("pageTitle", "Dashboard Tổng Quan");
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
