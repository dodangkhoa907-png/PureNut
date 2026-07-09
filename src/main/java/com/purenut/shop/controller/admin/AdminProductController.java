package com.purenut.shop.controller.admin;

import com.purenut.shop.dao.CategoryDao;
import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.CategoryDaoImpl;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Optional;

@WebServlet(urlPatterns = {
    "/admin/san-pham", 
    "/admin/san-pham/them", 
    "/admin/san-pham/sua", 
    "/admin/san-pham/xoa",
    "/admin/san-pham/noi-bat"
})
public class AdminProductController extends HttpServlet {

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

            // Validate bắt buộc
            if (com.purenut.shop.util.Validators.isBlank(name)
                    || com.purenut.shop.util.Validators.isBlank(slug)
                    || com.purenut.shop.util.Validators.isBlank(categoryIdStr)
                    || com.purenut.shop.util.Validators.isBlank(priceStr)) {
                resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=MissingField");
                return;
            }
            BigDecimal price;
            try {
                price = new BigDecimal(priceStr.trim());
                if (price.signum() < 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/san-pham?error=BadPrice");
                return;
            }

            Product p = new Product();
            int productId = com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("productId"), 0);
            p.setProductId(productId);
            p.setName(name.trim());
            p.setSlug(slug.trim());
            p.setCategoryId(com.purenut.shop.util.Validators.parsePositiveInt(categoryIdStr, 0));
            p.setDescription(req.getParameter("description"));
            p.setPrice(price);
            p.setImageUrl(req.getParameter("imageUrl"));
            p.setBgColorHex(req.getParameter("bgColorHex"));
            p.setVolumeMl(com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("volumeMl"), 300));
            p.setKcalPer100ml(com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("kcalPer100ml"), 0));
            p.setStockQuantity(com.purenut.shop.util.Validators.parsePositiveInt(req.getParameter("stockQuantity"), 0));
            p.setFeatured(req.getParameter("isFeatured") != null);

            if (p.getProductId() > 0) {
                productDao.update(p);
                com.purenut.shop.util.AuditLogger.log(req, adminId, "UPDATE_PRODUCT", p.getName(), "Cập nhật sản phẩm #" + p.getProductId());
            } else {
                productDao.insert(p);
                com.purenut.shop.util.AuditLogger.log(req, adminId, "CREATE_PRODUCT", p.getName(), "Thêm sản phẩm mới");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/san-pham?success=Saved");
        }
    }
}
