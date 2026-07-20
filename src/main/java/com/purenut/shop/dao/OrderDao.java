package com.purenut.shop.dao;

import com.purenut.shop.model.CartComboItem;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.Order;

import java.util.List;

public interface OrderDao {
    /**
     * Thực hiện đặt hàng với Transaction:
     * 1. Lưu Order (kèm ExpiresAt +15p nếu PaymentMethod=BANK_TRANSFER)
     * 2. Lưu OrderItem + trừ tồn kho cho từng sản phẩm thường
     * 3. Lưu OrderComboItem + trừ tồn kho cho từng sản phẩm trong combo (cùng cơ chế nguyên tử)
     * 4. Xóa CartItem + CartComboItem đã đặt
     * @return OrderID nếu thành công, 0 nếu thất bại
     */
    int placeOrder(Order order, List<CartItem> cartItems, List<CartComboItem> comboItems) throws Exception;

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

    /**
     * Khách hàng: xác nhận đã nhận hàng + đánh giá giao hàng (tùy chọn).
     * Chỉ áp dụng khi đơn đã DONE và chưa từng xác nhận trước đó (chống ghi đè).
     * @param rating 1-5 sao, null nếu khách chỉ xác nhận mà không đánh giá
     * @param review nhận xét tùy chọn, có thể null
     * @return số dòng update (0 = không phải chủ đơn / đơn chưa DONE / đã xác nhận rồi)
     */
    int confirmReceived(int orderId, int userId, Integer rating, String review);

    /** OrderID đang PENDING/BANK_TRANSFER đã quá hạn ExpiresAt — dùng cho sweep job. */
    List<Integer> findExpiredPendingBankTransferOrderIds();

    /**
     * Hủy 1 đơn hết hạn thanh toán + hoàn kho (sản phẩm thường + combo), atomic.
     * Re-check trạng thái bên trong lock trước khi hủy — nếu đơn không còn
     * PENDING/BANK_TRANSFER/quá hạn (vd đã CONFIRMED) thì bỏ qua, không hủy nhầm.
     * @return true nếu đã hủy, false nếu bỏ qua (đơn không còn khớp điều kiện)
     */
    boolean expireOrder(int orderId) throws Exception;
}
