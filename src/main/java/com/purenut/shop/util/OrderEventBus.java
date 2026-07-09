package com.purenut.shop.util;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.function.Consumer;

public final class OrderEventBus {

    public record OrderEvent(int orderId, String customerName, String phone,
                             long totalAmount, String paymentMethod, long timestamp) {}

    private static final List<Consumer<OrderEvent>> LISTENERS = new CopyOnWriteArrayList<>();

    private OrderEventBus() {}

    public static void subscribe(Consumer<OrderEvent> listener) {
        LISTENERS.add(listener);
    }

    public static void unsubscribe(Consumer<OrderEvent> listener) {
        LISTENERS.remove(listener);
    }

    public static void publish(OrderEvent event) {
        for (Consumer<OrderEvent> l : LISTENERS) {
            try { l.accept(event); } catch (Exception ignored) {}
        }
    }
}
