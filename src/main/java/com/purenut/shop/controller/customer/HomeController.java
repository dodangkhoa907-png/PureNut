package com.purenut.shop.controller.customer;

import com.purenut.shop.model.Product;
import com.purenut.shop.service.ProductService;
import com.purenut.shop.service.impl.ProductServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        // Khởi tạo Service
        productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // "/" và "/home" đều hiển thị trang chủ bán hàng
        request.setAttribute("products", productService.getAllProducts());
        request.setAttribute("featuredProducts", productService.getFeaturedProducts());
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
