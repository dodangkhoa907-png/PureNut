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

    /** Khách hàng COD: Hủy đơn ngay + hoàn kho */
    int cancelOrder(int orderId, int userId, String reason) throws Exception;

    /** Khách hàng trả trước: Gửi yêu cầu hủy → PENDING_CANCEL */
    int requestCancelOrder(int orderId, int userId, String reason) throws Exception;

    /** Admin duyệt hủy đơn trả trước → CANCELLED + hoàn kho */
    int approveCancelOrder(int orderId) throws Exception;

    /** Admin từ chối hủy → trả về CONFIRMED */
    int rejectCancelOrder(int orderId) throws Exception;

    /** Admin điều phối: gán shipper cho đơn + Status=SHIPPING + DeliveryStatus=ASSIGNED */
    int assignShipper(int orderId, int shipperId);

    /** Shipper: các đơn được gán cho mình (đang giao) */
    List<Order> findOrdersByShipper(int shipperId);

    /**
     * State machine giao hàng — CAS atomic: chỉ update khi DeliveryStatus
     * đang đúng {@code from} VÀ đơn thuộc đúng shipper. Chống race + nhảy cóc.
     * to=COMPLETED đồng bộ Status='DONE'.
     * @return số dòng update (0 = sai trạng thái nguồn / sai chủ đơn)
     */
    int updateDeliveryStatus(int orderId, int shipperId, String from, String to);

    /** Shipper: lưu ảnh bằng chứng giao hàng (chỉ chủ đơn) */
    int setProofImage(int orderId, int shipperId, String imagePath);

    List<Order> findAllOrdersPaged(int offset, int limit);
    int countOrders();
}
