package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.CartComboItemDao;
import com.purenut.shop.dao.impl.CartComboItemDaoImpl;
import com.purenut.shop.model.Combo;
import com.purenut.shop.model.User;
import com.purenut.shop.service.ComboService;
import com.purenut.shop.service.impl.ComboServiceImpl;
import com.purenut.shop.util.Validators;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Optional;

/**
 * Trang combo phía khách hàng (fixed-bundle): nội dung combo do admin định
 * sẵn, khách chỉ xem và chọn số lượng combo muốn mua — không tự chọn sản
 * phẩm nào.
 */
@WebServlet(name = "ComboController", urlPatterns = {"/combo", "/combo/*"})
public class ComboController extends HttpServlet {

    private ComboService comboService;
    private CartComboItemDao cartComboItemDao;

    @Override
    public void init() throws ServletException {
        comboService = new ComboServiceImpl();
        cartComboItemDao = new CartComboItemDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            request.setAttribute("combos", comboService.getActiveCombos());
            request.getRequestDispatcher("/WEB-INF/views/combo-list.jsp").forward(request, response);
            return;
        }

        String slug = pathInfo.substring(1);
        Optional<Combo> comboOpt = comboService.getComboBySlug(slug);
        if (comboOpt.isEmpty() || !comboOpt.get().isActive()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy combo");
            return;
        }

        request.setAttribute("combo", comboOpt.get());
        request.getRequestDispatcher("/WEB-INF/views/combo-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (!"/them-vao-gio".equals(pathInfo)) {
            response.sendRedirect(request.getContextPath() + "/combo");
            return;
        }

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean ajax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        int comboId = Validators.parsePositiveInt(request.getParameter("comboId"), 0);
        int quantity = Validators.parsePositiveInt(request.getParameter("quantity"), 1);

        Optional<Combo> comboOpt = comboService.getComboById(comboId);
        if (comboOpt.isEmpty() || !comboOpt.get().isActive()) {
            String msg = "Combo không tồn tại hoặc đã ngừng bán";
            if (ajax) { writeJson(response, "{\"success\":false,\"msg\":\"" + escJson(msg) + "\"}"); return; }
            response.sendRedirect(request.getContextPath() + "/combo?error=" +
                    java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        cartComboItemDao.insertOrUpdate(user.getUserId(), comboId, quantity);

        if (ajax) {
            writeJson(response, "{\"success\":true}");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart?success=added");
        }
    }

    private void writeJson(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) { out.print(json); }
    }

    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
}
