package com.purenut.shop.controller.admin;

import com.purenut.shop.util.OrderEventBus;

import jakarta.servlet.AsyncContext;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.function.Consumer;

@WebServlet(name = "AdminNotificationServlet",
        urlPatterns = "/admin/notifications/stream",
        asyncSupported = true)
public class AdminNotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/event-stream");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Connection", "keep-alive");
        resp.setHeader("X-Accel-Buffering", "no");

        AsyncContext async = req.startAsync();
        async.setTimeout(5 * 60 * 1000);

        PrintWriter writer = resp.getWriter();
        writer.write("event: connected\ndata: ok\n\n");
        writer.flush();

        @SuppressWarnings("unchecked")
        final Consumer<OrderEventBus.OrderEvent>[] holder = new Consumer[1];
        Consumer<OrderEventBus.OrderEvent> listener = event -> {
            try {
                String json = "{\"orderId\":" + event.orderId()
                        + ",\"customer\":\"" + escJson(event.customerName()) + "\""
                        + ",\"phone\":\"" + escJson(event.phone()) + "\""
                        + ",\"total\":" + event.totalAmount()
                        + ",\"payment\":\"" + escJson(event.paymentMethod()) + "\""
                        + ",\"time\":" + event.timestamp() + "}";

                writer.write("event: new-order\ndata: " + json + "\n\n");
                writer.flush();

                if (writer.checkError()) {
                    OrderEventBus.unsubscribe(holder[0]);
                    try { async.complete(); } catch (Exception ignored) {}
                }
            } catch (Exception e) {
                OrderEventBus.unsubscribe(holder[0]);
                try { async.complete(); } catch (Exception ignored) {}
            }
        };
        holder[0] = listener;

        OrderEventBus.subscribe(listener);

        async.addListener(new jakarta.servlet.AsyncListener() {
            @Override public void onComplete(jakarta.servlet.AsyncEvent e) { OrderEventBus.unsubscribe(listener); }
            @Override public void onTimeout(jakarta.servlet.AsyncEvent e) { OrderEventBus.unsubscribe(listener); try { async.complete(); } catch (Exception ignored) {} }
            @Override public void onError(jakarta.servlet.AsyncEvent e) { OrderEventBus.unsubscribe(listener); }
            @Override public void onStartAsync(jakarta.servlet.AsyncEvent e) {}
        });
    }

    private static String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n")
                .replace("\r", "\\r").replace("<", "\\u003c").replace(">", "\\u003e")
                .replace("&", "\\u0026").replace("/", "\\u002f");
    }
}
