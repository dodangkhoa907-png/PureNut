package com.purenut.shop.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/privacy", "/terms"})
public class LegalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/privacy".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/privacy.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/terms.jsp").forward(req, resp);
        }
    }
}
