package com.purenut.shop.controller.customer;

import com.purenut.shop.dao.ProductDao;
import com.purenut.shop.dao.impl.ProductDaoImpl;
import com.purenut.shop.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchController extends HttpServlet {

    private final ProductDao productDao = new ProductDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("q");
        if (keyword == null) keyword = "";
        
        List<Product> products = productDao.searchByName(keyword);
        
        req.setAttribute("keyword", keyword);
        req.setAttribute("products", products);
        
        req.getRequestDispatcher("/WEB-INF/views/search-results.jsp").forward(req, resp);
    }
}
