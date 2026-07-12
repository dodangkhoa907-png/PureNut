package com.purenut.shop.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class AdminIpFilter implements Filter {

    private final Set<String> allowed = new HashSet<>();

    @Override
    public void init(FilterConfig cfg) {
        allowed.add("127.0.0.1");
        allowed.add("0:0:0:0:0:0:0:1");

        String extra = cfg.getInitParameter("allowedIps");
        if (extra != null && !extra.isBlank()) {
            Arrays.stream(extra.split(","))
                  .map(String::trim)
                  .filter(s -> !s.isEmpty())
                  .forEach(allowed::add);
        }
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpReq = (HttpServletRequest) req;
        String ip = httpReq.getRemoteAddr();

        if (allowed.contains(ip)) {
            chain.doFilter(req, res);
        } else {
            System.err.println("[ADMIN-BLOCK] IP=" + ip
                    + " | URI=" + httpReq.getRequestURI()
                    + " | Method=" + httpReq.getMethod()
                    + " | UA=" + httpReq.getHeader("User-Agent"));
            ((HttpServletResponse) res).sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
