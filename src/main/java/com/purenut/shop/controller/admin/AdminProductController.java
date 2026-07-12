package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.CategoryDao;
import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.CategoryDaoImpl;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Product;

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
import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@WebServlet(urlPatterns = {
    "/admin/san-pham",
    "/admin/san-pham/them",
    "/admin/san-pham/sua",
    "/admin/san-pham/xoa",
    "/admin/san-pham/noi-bat",
    "/admin/san-pham/check-name"
})
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024,
    fileSizeThreshold = 1024 * 1024
)
public class AdminProductController extends HttpServlet {

    private static final java.util.Set<String> ALLOWED_IMG_TYPES =
            java.util.Set.of("image/jpeg", "image/png", "image/webp", "image/gif");

    private final ProductDao productDao = new ProductDaoImpl();
    private final CategoryDao categoryDao = new CategoryDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        
        if ("/admin/san-pham".equals(path)) {
            req.setAttribute("products", productDao.findAll());
            req.setAttribute("pageTitle", "Quản lý Sản phẩm");
            req.getRequestDispatcher("/WEB-INF/views/admin/product-list.jsp").forward(req, resp);
            
        } else if ("/admin/san-pham/them".equals(path)) {
            req.setAttribute("categories", categoryDao.findAll());
            req.setAttribute("pageTitle", "Thêm Sản Phẩm Mới");
            req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
            
        } else if ("/admin/san-pham/check-name".equals(path)) {
            handleCheckName(req, resp);

        } else if ("/admin/san-pham/sua".equals(path)) {
            int id = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("id"), -1);
            if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=BadId"); return; }
            Optional<Product> pOpt = productDao.findById(id);
            if (pOpt.isPresent()) {
                req.setAttribute("product", pOpt.get());
                req.setAttribute("categories", categoryDao.findAll());
                req.setAttribute("pageTitle", "Sửa Sản Phẩm");
                req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=Not found");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        
        var admin = (com.purenut.shop.model.User) req.getSession().getAttribute("adminUser");
        Integer adminId = admin != null ? admin.getUserId() : null;

        if ("/admin/san-pham/xoa".equals(path)) {
            int id = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("id"), -1);
            if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=BadId"); return; }
            productDao.softDelete(id);
            com.purenut.shop.util.AuditLogger.log(req, adminId, "DELETE_PRODUCT", "Sản phẩm #" + id, "Ẩn (xoá mềm) sản phẩm");
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?success=Deleted");

        } else if ("/admin/san-pham/noi-bat".equals(path)) {
            int id = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("id"), -1);
            if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=BadId"); return; }
            boolean featured = Boolean.parseBoolean(req.getParameter("featured"));
            productDao.toggleFeatured(id, !featured); // toggle
            com.purenut.shop.util.AuditLogger.log(req, adminId, "TOGGLE_FEATURED", "Sản phẩm #" + id, "Đặt nổi bật = " + (!featured));
            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?success=Updated");

        } else if ("/admin/san-pham/them".equals(path) || "/admin/san-pham/sua".equals(path)) {
            String name = req.getParameter("name");
            String slug = req.getParameter("slug");
            String categoryIdStr = req.getParameter("categoryId");
            String priceStr = req.getParameter("price");

            if (com.purenut.shop.util.Validators.isBlank(name)
                    || com.purenut.shop.util.Validators.isBlank(slug)
                    || com.purenut.shop.util.Validators.isBlank(categoryIdStr)
                    || com.purenut.shop.util.Validators.isBlank(priceStr)) {
                resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=MissingField");
                return;
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr.trim().replace(",", ""));
                if (price.signum() < 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=BadPrice");
                return;
            }

            String imageUrl = handleImageUpload(req);

            Product p = new Product();
            int productId = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("productId"), 0);
            p.setProductId(productId);
            p.setName(name.trim());
            p.setSlug(slug.trim());
            p.setCategoryId(com.purenut.shop.util.Validators.parsePositiveInt(categoryIdStr, 0));
            p.setDescription(req.getParameter("description"));
            p.setPrice(price);
            p.setImageUrl(imageUrl);
            p.setBgColorHex(req.getParameter("bgColorHex"));
            p.setVolumeMl(com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("volumeMl"), 300));
            p.setKcalPer100ml(com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("kcalPer100ml"), 0));
            p.setStockQuantity(com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("stockQuantity"), 0));
            p.setFeatured(req.getParameter("isFeatured") != null);

            if (p.getProductId() > 0) {
                if (imageUrl == null) {
                    productDao.findById(productId).ifPresent(old -> p.setImageUrl(old.getImageUrl()));
                }
                productDao.update(p);
                com.purenut.shop.util.AuditLogger.log(req, adminId, "UPDATE_PRODUCT", p.getName(), "Cập nhật sản phẩm #" + p.getProductId());
            } else {
                if (imageUrl == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=MissingImage");
                    return;
                }
                productDao.insert(p);
                com.purenut.shop.util.AuditLogger.log(req, adminId, "CREATE_PRODUCT", p.getName(), "Thêm sản phẩm mới");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?success=Saved");
        }
    }

    private void handleCheckName(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        String excludeIdStr = req.getParameter("excludeId");
        int excludeId = 0;
        if (excludeIdStr != null) {
            try { excludeId = Integer.parseInt(excludeIdStr.trim()); } catch (NumberFormatException ignored) {}
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (name == null || name.trim().isEmpty()) {
            try (PrintWriter out = resp.getWriter()) { out.write("{\"matches\":[]}"); }
            return;
        }

        List<Product> matches = productDao.searchByName(name.trim());
        StringBuilder sb = new StringBuilder("{\"matches\":[");
        boolean first = true;
        for (Product p : matches) {
            if (p.getProductId() == excludeId) continue;
            if (!first) sb.append(',');
            first = false;
            sb.append("{\"id\":").append(p.getProductId())
              .append(",\"name\":\"").append(escJson(p.getName())).append('"')
              .append(",\"price\":").append(p.getPrice())
              .append(",\"slug\":\"").append(escJson(p.getSlug())).append('"')
              .append(",\"imageUrl\":\"").append(escJson(p.getImageUrl() != null ? p.getImageUrl() : "")).append('"')
              .append(",\"categoryName\":\"").append(escJson(p.getCategoryName() != null ? p.getCategoryName() : "")).append('"')
              .append(",\"stock\":").append(p.getStockQuantity())
              .append('}');
        }
        sb.append("]}");
        try (PrintWriter out = resp.getWriter()) { out.write(sb.toString()); }
    }

    private static String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n")
                .replace("\r", "\\r").replace("<", "\\u003c").replace(">", "\\u003e")
                .replace("&", "\\u0026").replace("/", "\\u002f");
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
        String uploadDir = req.getServletContext().getRealPath("/resources/img/products");
        Path dir = Paths.get(uploadDir);
        Files.createDirectories(dir);
        Path target = dir.resolve(fileName);
        try (var in = filePart.getInputStream()) {
            Files.copy(in, target);
        }
        return "/resources/img/products/" + fileName;
    }
}
