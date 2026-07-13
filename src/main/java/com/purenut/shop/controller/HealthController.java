package com.purenut.shop.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "HealthController", urlPatterns = {"/health"}, loadOnStartup = 1)
public class HealthController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");
        resp.getWriter().print("{\"status\":\"UP\",\"ts\":" + System.currentTimeMillis() + "}");
    }
}
