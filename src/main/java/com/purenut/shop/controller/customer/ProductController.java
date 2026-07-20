package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.ReviewDao;
import com.purenut.shop.dao.impl.ReviewDaoImpl;
import com.purenut.shop.model.Category;
import com.purenut.shop.model.Product;
import com.purenut.shop.model.Review;
import com.purenut.shop.service.CategoryService;
import com.purenut.shop.service.ComboService;
import com.purenut.shop.service.ProductService;
import com.purenut.shop.service.impl.CategoryServiceImpl;
import com.purenut.shop.service.impl.ComboServiceImpl;
import com.purenut.shop.service.impl.ProductServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ProductController", urlPatterns = {"/products/*"})
public class ProductController extends HttpServlet {

    private ProductService productService;
    private CategoryService categoryService;
    private ReviewDao reviewDao;
    private ComboService comboService;

    @Override
    public void init() throws ServletException {
        productService = new ProductServiceImpl();
        categoryService = new CategoryServiceImpl();
        reviewDao = new ReviewDaoImpl();
        comboService = new ComboServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String pathInfo = request.getPathInfo();
        
        // Trưởng hợp 1: /products hoặc /products/ (Danh sách sản phẩm)
        if (pathInfo == null || pathInfo.equals("/")) {
            showProductList(request, response);
        } 
        // Trường hợp 2: /products/{slug} (Chi tiết sản phẩm)
        else {
            String slug = pathInfo.substring(1); // Bỏ dấu '/' ở đầu
            showProductDetail(request, response, slug);
        }
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String categorySlug = request.getParameter("category");
        
        List<Product> products = productService.getProductsByCategory(categorySlug);
        List<Category> categories = categoryService.getAllCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentCategory", categorySlug);
        
        request.getRequestDispatcher("/WEB-INF/views/product-list.jsp").forward(request, response);
    }
    
    private void showProductDetail(HttpServletRequest request, HttpServletResponse response, String slug) 
            throws ServletException, IOException {
            
        Optional<Product> optionalProduct = productService.getProductBySlug(slug);
        
        if (optionalProduct.isPresent()) {
            Product product = optionalProduct.get();
            request.setAttribute("product", product);
            
            // Sản phẩm liên quan
            List<Product> relatedProducts = productService.getRelatedProducts(product.getCategoryId(), product.getProductId(), 4);
            request.setAttribute("relatedProducts", relatedProducts);

            // Đánh giá từ khách hàng đã mua (ghi tự động khi khách xác nhận nhận hàng)
            List<Review> reviews = reviewDao.findByProductId(product.getProductId());
            request.setAttribute("reviews", reviews);
            double avgRating = 0;
            if (!reviews.isEmpty()) {
                int sum = 0;
                for (Review r : reviews) sum += r.getRating();
                avgRating = Math.round((sum / (double) reviews.size()) * 10) / 10.0;
            }
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviews.size());

            // Combo đang bán có chứa sản phẩm này — mục "Mua cùng Combo" ở cuối trang
            request.setAttribute("relatedCombos", comboService.getCombosForProduct(product.getProductId()));

            request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
        } else {
            // Không tìm thấy sản phẩm -> 404
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
        }
    }
}
