package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Combo;
import com.purenut.shop.model.ComboItem;
import com.purenut.shop.service.ComboService;
import com.purenut.shop.service.impl.ComboServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@WebServlet(urlPatterns = {
    "/admin/combo",
    "/admin/combo/them",
    "/admin/combo/sua",
    "/admin/combo/xoa"
})
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024,
    fileSizeThreshold = 1024 * 1024
)
public class AdminComboController extends HttpServlet {

    private static final Set<String> ALLOWED_IMG_TYPES =
            Set.of("image/jpeg", "image/png", "image/webp", "image/gif");

    private final ComboService comboService = new ComboServiceImpl();
    private final ProductDao productDao = new ProductDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/combo".equals(path)) {
            req.setAttribute("combos", comboService.getAllCombosForAdmin());
            req.setAttribute("pageTitle", "Quản lý Combo");
            req.getRequestDispatcher("/WEB-INF/views/admin/combo-list.jsp").forward(req, resp);

        } else if ("/admin/combo/them".equals(path)) {
            req.setAttribute("products", productDao.findAll());
            req.setAttribute("pageTitle", "Thêm Combo Mới");
            req.getRequestDispatcher("/WEB-INF/views/admin/combo-form.jsp").forward(req, resp);

        } else if ("/admin/combo/sua".equals(path)) {
            int id = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("id"), -1);
            if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/admin/combo?error=BadId"); return; }
            Optional<Combo> cOpt = comboService.getComboById(id);
            if (cOpt.isPresent()) {
                req.setAttribute("combo", cOpt.get());
                req.setAttribute("products", productDao.findAll());
                req.setAttribute("pageTitle", "Sửa Combo");
                req.getRequestDispatcher("/WEB-INF/views/admin/combo-form.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/combo?error=Not found");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        var admin = (com.purenut.shop.model.User) req.getSession().getAttribute("adminUser");
        Integer adminId = admin != null ? admin.getUserId() : null;

        if ("/admin/combo/xoa".equals(path)) {
            int id = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("id"), -1);
            if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/admin/combo?error=BadId"); return; }
            comboService.deleteCombo(id);
            com.purenut.shop.util.AuditLogger.log(req, adminId, "DELETE_COMBO", "Combo #" + id, "Ẩn (xoá mềm) combo");
            resp.sendRedirect(req.getContextPath() + "/admin/combo?success=Deleted");
            return;
        }

        if (!"/admin/combo/them".equals(path) && !"/admin/combo/sua".equals(path)) return;

        String name = req.getParameter("name");
        String slug = req.getParameter("slug");
        String priceStr = req.getParameter("comboPrice");

        if (com.purenut.shop.util.Validators.isBlank(name)
                || com.purenut.shop.util.Validators.isBlank(slug)
                || com.purenut.shop.util.Validators.isBlank(priceStr)) {
            resp.sendRedirect(req.getContextPath() + "/admin/combo?error=MissingField");
            return;
        }

        BigDecimal price;
        try {
            price = new BigDecimal(priceStr.trim().replace(",", ""));
            if (price.signum() < 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/combo?error=BadPrice");
            return;
        }

        String imageUrl = handleImageUpload(req);

        Combo combo = new Combo();
        int comboId = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("comboId"), 0);
        combo.setComboId(comboId);
        combo.setName(name.trim());
        combo.setSlug(slug.trim());
        combo.setDescription(req.getParameter("description"));
        combo.setComboPrice(price);
        combo.setActive(req.getParameter("isActive") != null);

        List<ComboItem> items = parseComboItems(req);

        try {
            if (comboId > 0) {
                if (imageUrl == null) {
                    comboService.getComboById(comboId).ifPresent(old -> combo.setImageUrl(old.getImageUrl()));
                } else {
                    combo.setImageUrl(imageUrl);
                }
                comboService.updateCombo(combo, items);
                com.purenut.shop.util.AuditLogger.log(req, adminId, "UPDATE_COMBO", combo.getName(), "Cập nhật combo #" + comboId);
            } else {
                combo.setImageUrl(imageUrl);
                comboId = comboService.createCombo(combo, items);
                com.purenut.shop.util.AuditLogger.log(req, adminId, "CREATE_COMBO", combo.getName(), "Thêm combo mới #" + comboId);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/combo?success=Saved");
        } catch (IllegalArgumentException | IllegalStateException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/combo?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }

    /** Đọc mảng song song itemProductId[]/itemQuantity[] từ form (fixed-bundle: admin chọn đích danh sản phẩm). */
    private List<ComboItem> parseComboItems(HttpServletRequest req) {
        String[] productIds = req.getParameterValues("itemProductId");
        String[] quantities = req.getParameterValues("itemQuantity");
        List<ComboItem> items = new ArrayList<>();
        if (productIds == null || quantities == null) return items;

        for (int i = 0; i < productIds.length && i < quantities.length; i++) {
            int productId = com.purenut.shop.util.Validators.parsePositiveInt(productIds[i], 0);
            int quantity = com.purenut.shop.util.Validators.parsePositiveInt(quantities[i], 0);
            if (productId <= 0 || quantity <= 0) continue; // dòng bỏ trống trên form
            ComboItem item = new ComboItem();
            item.setProductId(productId);
            item.setQuantity(quantity);
            items.add(item);
        }
        return items;
    }

    private String handleImageUpload(HttpServletRequest req) throws IOException, ServletException {
        Part filePart = req.getPart("imageFile");
        if (filePart == null || filePart.getSize() == 0) return null;

        String contentType = filePart.getContentType();
        if (!ALLOWED_IMG_TYPES.contains(contentType)) return null;

        String ext = switch (contentType) {
            case "image/png"  -> ".png";
            case "image/webp" -> ".webp";
            case "image/gif"  -> ".gif";
            default           -> ".jpg";
        };

        String fileName = UUID.randomUUID().toString().substring(0, 12) + ext;
        String uploadDir = req.getServletContext().getRealPath("/resources/img/combos");
        Path dir = Paths.get(uploadDir);
        Files.createDirectories(dir);
        Path target = dir.resolve(fileName);
        try (var in = filePart.getInputStream()) {
            Files.copy(in, target);
        }
        return "/resources/img/combos/" + fileName;
    }
}
