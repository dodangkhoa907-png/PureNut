package com.purenut.shop.dao;

import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.Order;

import java.util.List;

public interface OrderDao {
    /**
     * Thực hiện đặt hàng với Transaction:
     * 1. Lưu Order
     * 2. Lưu OrderItem
     * 3. Trừ tồn kho (StockQuantity)
     * 4. Xóa CartItem
     * @return OrderID nếu thành công, 0 nếu thất bại
     */
    int placeOrder(Order order, List<CartItem> cartItems) throws Exception;

    /** Admin: Lấy tất cả đơn hàng */
    List<Order> findAllOrders();

    /** Admin: Lấy chi tiết đơn hàng (gồm items) */
    Order findOrderById(int orderId);

    /** Khách hàng: Lấy danh sách lịch sử đơn hàng của mình */
    List<Order> findOrdersByUserId(int userId);

    /** Admin: Cập nhật trạng thái đơn hàng */
    int updateOrderStatus(int orderId, String status);
}
