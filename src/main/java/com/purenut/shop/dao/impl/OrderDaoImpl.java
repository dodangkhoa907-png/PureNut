package com.purenut.shop.dao.impl;

import com.google.gson.Gson;
import com.purenut.shop.config.Database;
import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.model.CartComboItem;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.ComboSelectionItem;
import com.purenut.shop.model.Order;

import java.sql.*;
import java.util.List;

public class OrderDaoImpl implements OrderDao {

    private static final Gson GSON = new Gson();

    @Override
    public int placeOrder(Order order, List<CartItem> cartItems, List<CartComboItem> comboItems) throws Exception {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psOrderItem = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psDeleteCart = null;
        PreparedStatement psOrderCombo = null;
        PreparedStatement psDeleteCartCombo = null;
        ResultSet rsKeys = null;

        int orderId = 0;
        boolean isBankTransfer = "BANK_TRANSFER".equals(order.getPaymentMethod());

        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lưu Order (kèm tọa độ Google Maps của khách nếu có).
            //    ExpiresAt chỉ set cho BANK_TRANSFER — đơn PENDING chờ chuyển khoản
            //    sẽ bị sweep job tự hủy + hoàn kho sau 15 phút nếu khách bỏ ngang.
            String sqlOrder = "INSERT INTO Orders (UserID, FullName, Phone, Address, TotalAmount, PaymentMethod, Status, CouponCode, Latitude, Longitude, ExpiresAt) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setNString(2, order.getFullName());
            psOrder.setString(3, order.getPhone());
            psOrder.setNString(4, order.getAddress());
            psOrder.setBigDecimal(5, order.getTotalAmount());
            psOrder.setString(6, order.getPaymentMethod());
            psOrder.setString(7, "PENDING");
            psOrder.setString(8, order.getCouponCode());
            if (order.getLatitude() != null)  psOrder.setBigDecimal(9,  java.math.BigDecimal.valueOf(order.getLatitude()));
            else                              psOrder.setNull(9,  java.sql.Types.DECIMAL);
            if (order.getLongitude() != null) psOrder.setBigDecimal(10, java.math.BigDecimal.valueOf(order.getLongitude()));
            else                              psOrder.setNull(10, java.sql.Types.DECIMAL);
            if (isBankTransfer) psOrder.setTimestamp(11, new Timestamp(System.currentTimeMillis() + 15 * 60 * 1000L));
            else                psOrder.setNull(11, java.sql.Types.TIMESTAMP);

            psOrder.executeUpdate();
            rsKeys = psOrder.getGeneratedKeys();
            if (rsKeys.next()) {
                orderId = rsKeys.getInt(1);
            } else {
                throw new SQLException("Không thể lấy OrderID");
            }

            // 2. Lưu OrderItem & Trừ tồn kho (CÓ KIỂM TRA đủ hàng để chống bán quá kho)
            String sqlOrderItem = "INSERT INTO OrderItems (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES (?, ?, ?, ?)";
            psOrderItem = conn.prepareStatement(sqlOrderItem);

            // Chỉ trừ khi tồn kho còn đủ; rowcount = 0 nghĩa là không đủ hàng.
            String sqlUpdateStock = "UPDATE Products SET StockQuantity = StockQuantity - ? " +
                                    "WHERE ProductID = ? AND StockQuantity >= ? AND IsDeleted = 0";
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cartItems) {
                // Trừ tồn kho có điều kiện — thực thi ngay để biết còn đủ hàng không
                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getProductId());
                psUpdateStock.setInt(3, item.getQuantity());
                int affected = psUpdateStock.executeUpdate();
                if (affected == 0) {
                    // Không đủ hàng (hoặc sản phẩm đã ẩn) -> rollback toàn bộ đơn
                    String name = item.getProductName() != null ? item.getProductName()
                            : ("#" + item.getProductId());
                    throw new com.purenut.shop.exception.OutOfStockException(name);
                }

                // Lưu OrderItem
                psOrderItem.setInt(1, orderId);
                psOrderItem.setInt(2, item.getProductId());
                psOrderItem.setInt(3, item.getQuantity());
                psOrderItem.setBigDecimal(4, item.getProductPrice());
                psOrderItem.addBatch();
            }

            psOrderItem.executeBatch();

            // 3. Xóa CartItems
            String sqlDeleteCart = "DELETE FROM CartItems WHERE CartItemID = ?";
            psDeleteCart = conn.prepareStatement(sqlDeleteCart);
            for (CartItem item : cartItems) {
                psDeleteCart.setInt(1, item.getCartItemId());
                psDeleteCart.addBatch();
            }
            psDeleteCart.executeBatch();

            // 4. Combo (fixed-bundle): nội dung combo (sản phẩm+số lượng) KHÔNG do
            //    khách chọn — lấy đích danh từ ComboItems ngay trong transaction này
            //    (không tin dữ liệu từ tầng trên), rồi trừ kho + ghi snapshot JSON
            //    vào OrderComboItems.SelectionJson để restoreStock dùng lại sau này.
            if (comboItems != null && !comboItems.isEmpty()) {
                String sqlOrderCombo = "INSERT INTO OrderComboItems (OrderID, ComboID, ComboName, Quantity, PriceAtPurchase, SelectionJson) " +
                                       "VALUES (?, ?, ?, ?, ?, ?)";
                psOrderCombo = conn.prepareStatement(sqlOrderCombo);

                try (PreparedStatement psComboItems = conn.prepareStatement(
                        "SELECT ProductID, Quantity FROM ComboItems WHERE ComboID = ?")) {
                    for (CartComboItem cci : comboItems) {
                        List<ComboSelectionItem> fixedItems = new java.util.ArrayList<>();
                        psComboItems.setInt(1, cci.getComboId());
                        try (ResultSet rsItems = psComboItems.executeQuery()) {
                            while (rsItems.next()) {
                                fixedItems.add(new ComboSelectionItem(rsItems.getInt("ProductID"), rsItems.getInt("Quantity")));
                            }
                        }

                        for (ComboSelectionItem sel : fixedItems) {
                            int totalQty = sel.getQty() * cci.getQuantity();
                            psUpdateStock.setInt(1, totalQty);
                            psUpdateStock.setInt(2, sel.getProductId());
                            psUpdateStock.setInt(3, totalQty);
                            int affected = psUpdateStock.executeUpdate();
                            if (affected == 0) {
                                throw new com.purenut.shop.exception.OutOfStockException(
                                        cci.getComboName() != null ? cci.getComboName() : ("Combo #" + cci.getComboId()));
                            }
                        }

                        psOrderCombo.setInt(1, orderId);
                        psOrderCombo.setInt(2, cci.getComboId());
                        psOrderCombo.setNString(3, cci.getComboName());
                        psOrderCombo.setInt(4, cci.getQuantity());
                        psOrderCombo.setBigDecimal(5, cci.getComboPrice());
                        psOrderCombo.setString(6, GSON.toJson(fixedItems));
                        psOrderCombo.addBatch();
                    }
                }
                psOrderCombo.executeBatch();

                String sqlDeleteCartCombo = "DELETE FROM CartComboItems WHERE CartComboItemID = ?";
                psDeleteCartCombo = conn.prepareStatement(sqlDeleteCartCombo);
                for (CartComboItem cci : comboItems) {
                    psDeleteCartCombo.setInt(1, cci.getCartComboItemId());
                    psDeleteCartCombo.addBatch();
                }
                psDeleteCartCombo.executeBatch();
            }

            // Nếu mọi thứ OK -> Commit
            conn.commit();
            return orderId;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Có lỗi -> Rollback
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (rsKeys != null) rsKeys.close();
            if (psOrder != null) psOrder.close();
            if (psOrderItem != null) psOrderItem.close();
            if (psUpdateStock != null) psUpdateStock.close();
            if (psDeleteCart != null) psDeleteCart.close();
            if (psOrderCombo != null) psOrderCombo.close();
            if (psDeleteCartCombo != null) psDeleteCartCombo.close();
            if (conn != null) {
                conn.setAutoCommit(true); // Trả lại trạng thái mặc định
                conn.close();
            }
        }
    }

    @Override
    public List<Order> findAllOrders() {
        List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, o.FullName, o.Phone, o.Address, " +
                     "o.TotalAmount, o.PaymentMethod, o.Status, o.CouponCode, o.CreatedAt, " +
                     "o.CancelReason, o.CancelledAt, o.ShipperID, s.FullName AS ShipperName, " +
                     "o.DeliveryStatus, o.DeliveredAt, o.ReceivedConfirmedAt, o.DeliveryRating, o.DeliveryReview, " +
                     "u.Email AS UserEmail, u.CreatedAt AS AccountCreatedAt " +
                     "FROM Orders o LEFT JOIN Users u ON o.UserID = u.UserID " +
                     "LEFT JOIN Users s ON o.ShipperID = s.UserID " +
                     "ORDER BY o.CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("OrderID"));
                o.setUserId(rs.getInt("UserID"));
                o.setFullName(rs.getNString("FullName"));
                o.setPhone(rs.getString("Phone"));
                o.setAddress(rs.getNString("Address"));
                o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setStatus(rs.getString("Status"));
                o.setCouponCode(rs.getString("CouponCode"));
                o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                o.setCancelReason(rs.getNString("CancelReason"));
                o.setCancelledAt(rs.getTimestamp("CancelledAt"));
                int sid = rs.getInt("ShipperID");
                o.setShipperId(rs.wasNull() ? null : sid);
                o.setShipperName(rs.getNString("ShipperName"));
                o.setDeliveryStatus(rs.getString("DeliveryStatus"));
                o.setDeliveredAt(rs.getTimestamp("DeliveredAt"));
                o.setReceivedConfirmedAt(rs.getTimestamp("ReceivedConfirmedAt"));
                int rating = rs.getInt("DeliveryRating");
                o.setDeliveryRating(rs.wasNull() ? null : rating);
                o.setDeliveryReview(rs.getNString("DeliveryReview"));
                o.setEmail(rs.getString("UserEmail"));
                o.setAccountCreatedAt(rs.getTimestamp("AccountCreatedAt"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> findOrdersByUserId(int userId) {
        List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE UserID = ? ORDER BY CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("OrderID"));
                    o.setUserId(rs.getInt("UserID"));
                    o.setFullName(rs.getNString("FullName"));
                    o.setPhone(rs.getString("Phone"));
                    o.setAddress(rs.getNString("Address"));
                    o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    o.setPaymentMethod(rs.getString("PaymentMethod"));
                    o.setStatus(rs.getString("Status"));
                    o.setCouponCode(rs.getString("CouponCode"));
                    o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    o.setCancelReason(rs.getNString("CancelReason"));
                    o.setCancelledAt(rs.getTimestamp("CancelledAt"));
                    int sid = rs.getInt("ShipperID");
                    o.setShipperId(rs.wasNull() ? null : sid);
                    o.setDeliveryStatus(rs.getString("DeliveryStatus"));
                    o.setProofImage(rs.getNString("ProofImage"));
                    java.math.BigDecimal lat = rs.getBigDecimal("Latitude");
                    java.math.BigDecimal lng = rs.getBigDecimal("Longitude");
                    o.setLatitude(lat != null ? lat.doubleValue() : null);
                    o.setLongitude(lng != null ? lng.doubleValue() : null);
                    o.setDeliveredAt(rs.getTimestamp("DeliveredAt"));
                    o.setReceivedConfirmedAt(rs.getTimestamp("ReceivedConfirmedAt"));
                    int rating = rs.getInt("DeliveryRating");
                    o.setDeliveryRating(rs.wasNull() ? null : rating);
                    o.setDeliveryReview(rs.getNString("DeliveryReview"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Order findOrderById(int orderId) {
        Order o = null;
        String sqlOrder = "SELECT * FROM Orders WHERE OrderID = ?";
        String sqlItems = "SELECT oi.*, p.Name AS ProductName " +
                          "FROM OrderItems oi " +
                          "JOIN Products p ON oi.ProductID = p.ProductID " +
                          "WHERE oi.OrderID = ?";
                          
        try (Connection con = Database.getConnection()) {
            // Lấy Order
            try (PreparedStatement ps = con.prepareStatement(sqlOrder)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        o = new Order();
                        o.setOrderId(rs.getInt("OrderID"));
                        o.setUserId(rs.getInt("UserID"));
                        o.setFullName(rs.getNString("FullName"));
                        o.setPhone(rs.getString("Phone"));
                        o.setAddress(rs.getNString("Address"));
                        o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                        o.setPaymentMethod(rs.getString("PaymentMethod"));
                        o.setStatus(rs.getString("Status"));
                        o.setCouponCode(rs.getString("CouponCode"));
                        o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                        o.setCancelReason(rs.getNString("CancelReason"));
                        o.setCancelledAt(rs.getTimestamp("CancelledAt"));
                        int sid = rs.getInt("ShipperID");
                        o.setShipperId(rs.wasNull() ? null : sid);
                        o.setDeliveryStatus(rs.getString("DeliveryStatus"));
                        o.setProofImage(rs.getNString("ProofImage"));
                        java.math.BigDecimal lat = rs.getBigDecimal("Latitude");
                        java.math.BigDecimal lng = rs.getBigDecimal("Longitude");
                        o.setLatitude(lat != null ? lat.doubleValue() : null);
                        o.setLongitude(lng != null ? lng.doubleValue() : null);
                        o.setDeliveredAt(rs.getTimestamp("DeliveredAt"));
                        o.setReceivedConfirmedAt(rs.getTimestamp("ReceivedConfirmedAt"));
                        int rating = rs.getInt("DeliveryRating");
                        o.setDeliveryRating(rs.wasNull() ? null : rating);
                        o.setDeliveryReview(rs.getNString("DeliveryReview"));
                    }
                }
            }

            // Lấy OrderItems
            if (o != null) {
                List<com.purenut.shop.model.OrderItem> items = new java.util.ArrayList<>();
                try (PreparedStatement ps = con.prepareStatement(sqlItems)) {
                    ps.setInt(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            com.purenut.shop.model.OrderItem item = new com.purenut.shop.model.OrderItem();
                            item.setOrderItemId(rs.getInt("OrderItemID"));
                            item.setOrderId(rs.getInt("OrderID"));
                            item.setProductId(rs.getInt("ProductID"));
                            item.setQuantity(rs.getInt("Quantity"));
                            item.setPriceAtTime(rs.getBigDecimal("PriceAtPurchase"));
                            item.setProductName(rs.getNString("ProductName"));
                            items.add(item);
                        }
                    }
                }
                o.setItems(items);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return o;
    }

    @Override
    public int updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int cancelOrder(int orderId, int userId, String reason) throws Exception {
        Connection conn = null;
        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT Status, UserID FROM Orders WHERE OrderID = ?")) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new IllegalStateException("Đơn hàng không tồn tại");
                    if (rs.getInt("UserID") != userId) throw new SecurityException("Không có quyền hủy đơn này");
                    String st = rs.getString("Status");
                    if (!"PENDING".equals(st) && !"CONFIRMED".equals(st))
                        throw new IllegalStateException("Không thể hủy đơn ở trạng thái " + st);
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Orders SET Status='CANCELLED', CancelReason=?, CancelledAt=DATEADD(HOUR,7,GETUTCDATE()) WHERE OrderID=?")) {
                ps.setNString(1, reason);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            restoreStock(conn, orderId);
            conn.commit();
            return 1;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    @Override
    public int requestCancelOrder(int orderId, int userId, String reason) throws Exception {
        try (Connection con = Database.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT Status, UserID FROM Orders WHERE OrderID = ?")) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new IllegalStateException("Đơn hàng không tồn tại");
                    if (rs.getInt("UserID") != userId) throw new SecurityException("Không có quyền hủy đơn này");
                    String st = rs.getString("Status");
                    if (!"PENDING".equals(st) && !"CONFIRMED".equals(st))
                        throw new IllegalStateException("Không thể hủy đơn ở trạng thái " + st);
                }
            }
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE Orders SET Status='PENDING_CANCEL', CancelReason=? WHERE OrderID=?")) {
                ps.setNString(1, reason);
                ps.setInt(2, orderId);
                return ps.executeUpdate();
            }
        }
    }

    @Override
    public int approveCancelOrder(int orderId) throws Exception {
        Connection conn = null;
        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT Status FROM Orders WITH (UPDLOCK, ROWLOCK) WHERE OrderID = ?")) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new IllegalStateException("Đơn hàng không tồn tại");
                    String st = rs.getString("Status");
                    if ("DONE".equals(st) || "CANCELLED".equals(st))
                        throw new IllegalStateException("Đơn đã kết thúc, không thể hủy");
                    if ("SHIPPING".equals(st))
                        throw new IllegalStateException("Đơn đang giao, không thể hủy");
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Orders SET Status='CANCELLED', CancelledAt=DATEADD(HOUR,7,GETUTCDATE()) WHERE OrderID=?")) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            restoreStock(conn, orderId);
            conn.commit();
            return 1;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    @Override
    public int rejectCancelOrder(int orderId) throws Exception {
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE Orders SET Status='CONFIRMED', CancelReason=NULL WHERE OrderID=? AND Status='PENDING_CANCEL'")) {
            ps.setInt(1, orderId);
            return ps.executeUpdate();
        }
    }

    @Override
    public int assignShipper(int orderId, int shipperId) {
        // Gán khi đơn CONFIRMED (hoặc gán lại khi SHIPPING) → khởi động state machine ASSIGNED
        String sql = "UPDATE Orders SET ShipperID = ?, Status = 'SHIPPING', DeliveryStatus = 'ASSIGNED', ProofImage = NULL " +
                     "WHERE OrderID = ? AND Status IN ('CONFIRMED','SHIPPING')";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            ps.setInt(2, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[OrderDao] assignShipper: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public List<Order> findOrdersByShipper(int shipperId) {
        List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE ShipperID = ? " +
                     "ORDER BY CASE WHEN DeliveryStatus IN ('ASSIGNED','PICKING_UP','DELIVERING') THEN 0 ELSE 1 END, CreatedAt DESC";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("OrderID"));
                    o.setUserId(rs.getInt("UserID"));
                    o.setFullName(rs.getNString("FullName"));
                    o.setPhone(rs.getString("Phone"));
                    o.setAddress(rs.getNString("Address"));
                    o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    o.setPaymentMethod(rs.getString("PaymentMethod"));
                    o.setStatus(rs.getString("Status"));
                    o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    int sid = rs.getInt("ShipperID");
                    o.setShipperId(rs.wasNull() ? null : sid);
                    o.setDeliveryStatus(rs.getString("DeliveryStatus"));
                    java.math.BigDecimal lat = rs.getBigDecimal("Latitude");
                    java.math.BigDecimal lng = rs.getBigDecimal("Longitude");
                    o.setLatitude(lat != null ? lat.doubleValue() : null);
                    o.setLongitude(lng != null ? lng.doubleValue() : null);
                    o.setProofImage(rs.getNString("ProofImage"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            System.err.println("[OrderDao] findOrdersByShipper: " + e.getMessage());
        }
        return list;
    }

    @Override
    public int updateDeliveryStatus(int orderId, int shipperId, String from, String to) {
        // CAS atomic: WHERE khóa cả chủ đơn lẫn trạng thái nguồn → không thể nhảy cóc,
        // không thể race (2 request cùng lúc chỉ 1 cái thắng).
        // COMPLETED đồng bộ Status='DONE' + ghi nhận DeliveredAt (thời điểm shipper báo hoàn thành);
        // FAILED giữ Status='SHIPPING' để admin xử lý tiếp.
        String sql = "UPDATE Orders SET DeliveryStatus = ?, " +
                     "Status = CASE WHEN ? = 'COMPLETED' THEN 'DONE' ELSE Status END, " +
                     "DeliveredAt = CASE WHEN ? = 'COMPLETED' THEN DATEADD(HOUR,7,GETUTCDATE()) ELSE DeliveredAt END " +
                     "WHERE OrderID = ? AND ShipperID = ? AND DeliveryStatus = ?";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, to);
            ps.setString(2, to);
            ps.setString(3, to);
            ps.setInt(4, orderId);
            ps.setInt(5, shipperId);
            ps.setString(6, from);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[OrderDao] updateDeliveryStatus: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public int confirmReceived(int orderId, int userId, Integer rating, String review) {
        // Chỉ chủ đơn + đơn đã DONE mới xác nhận được; không cho xác nhận lại (chặn spam đổi đánh giá qua endpoint này)
        String sql = "UPDATE Orders SET ReceivedConfirmedAt = DATEADD(HOUR,7,GETUTCDATE()), " +
                     "DeliveryRating = ?, DeliveryReview = ? " +
                     "WHERE OrderID = ? AND UserID = ? AND Status = 'DONE' AND ReceivedConfirmedAt IS NULL";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (rating != null) ps.setInt(1, rating); else ps.setNull(1, Types.INTEGER);
            ps.setNString(2, review);
            ps.setInt(3, orderId);
            ps.setInt(4, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[OrderDao] confirmReceived: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public int setProofImage(int orderId, int shipperId, String imagePath) {
        String sql = "UPDATE Orders SET ProofImage = ? " +
                     "WHERE OrderID = ? AND ShipperID = ? AND DeliveryStatus = 'DELIVERING'";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, imagePath);
            ps.setInt(2, orderId);
            ps.setInt(3, shipperId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[OrderDao] setProofImage: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public List<Order> findAllOrdersPaged(int offset, int limit) {
        List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, o.FullName, o.Phone, o.Address, " +
                     "o.TotalAmount, o.PaymentMethod, o.Status, o.CouponCode, o.CreatedAt, " +
                     "o.CancelReason, o.CancelledAt, o.ShipperID, s.FullName AS ShipperName, " +
                     "o.DeliveryStatus, o.DeliveredAt, o.ReceivedConfirmedAt, o.DeliveryRating, o.DeliveryReview, " +
                     "u.Email AS UserEmail, u.CreatedAt AS AccountCreatedAt " +
                     "FROM Orders o LEFT JOIN Users u ON o.UserID = u.UserID " +
                     "LEFT JOIN Users s ON o.ShipperID = s.UserID " +
                     "ORDER BY o.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("OrderID"));
                    o.setUserId(rs.getInt("UserID"));
                    o.setFullName(rs.getNString("FullName"));
                    o.setPhone(rs.getString("Phone"));
                    o.setAddress(rs.getNString("Address"));
                    o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    o.setPaymentMethod(rs.getString("PaymentMethod"));
                    o.setStatus(rs.getString("Status"));
                    o.setCouponCode(rs.getString("CouponCode"));
                    o.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    o.setCancelReason(rs.getNString("CancelReason"));
                    o.setCancelledAt(rs.getTimestamp("CancelledAt"));
                    int sid = rs.getInt("ShipperID");
                    o.setShipperId(rs.wasNull() ? null : sid);
                    o.setShipperName(rs.getNString("ShipperName"));
                    o.setDeliveryStatus(rs.getString("DeliveryStatus"));
                    o.setDeliveredAt(rs.getTimestamp("DeliveredAt"));
                    o.setReceivedConfirmedAt(rs.getTimestamp("ReceivedConfirmedAt"));
                    int rating = rs.getInt("DeliveryRating");
                    o.setDeliveryRating(rs.wasNull() ? null : rating);
                    o.setDeliveryReview(rs.getNString("DeliveryReview"));
                    o.setEmail(rs.getString("UserEmail"));
                    o.setAccountCreatedAt(rs.getTimestamp("AccountCreatedAt"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void restoreStock(Connection conn, int orderId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT ProductID, Quantity FROM OrderItems WHERE OrderID = ?")) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                try (PreparedStatement upd = conn.prepareStatement(
                        "UPDATE Products SET StockQuantity = StockQuantity + ? WHERE ProductID = ?")) {
                    while (rs.next()) {
                        upd.setInt(1, rs.getInt("Quantity"));
                        upd.setInt(2, rs.getInt("ProductID"));
                        upd.addBatch();
                    }
                    upd.executeBatch();
                }
            }
        }
        restoreComboStock(conn, orderId);
    }

    /** Hoàn kho cho các sản phẩm cụ thể nằm trong combo đã đặt của đơn này. */
    private void restoreComboStock(Connection conn, int orderId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT Quantity, SelectionJson FROM OrderComboItems WHERE OrderID = ?")) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                try (PreparedStatement upd = conn.prepareStatement(
                        "UPDATE Products SET StockQuantity = StockQuantity + ? WHERE ProductID = ?")) {
                    while (rs.next()) {
                        int comboQty = rs.getInt("Quantity");
                        ComboSelectionItem[] items = GSON.fromJson(rs.getString("SelectionJson"), ComboSelectionItem[].class);
                        if (items == null) continue;
                        for (ComboSelectionItem item : items) {
                            upd.setInt(1, item.getQty() * comboQty);
                            upd.setInt(2, item.getProductId());
                            upd.addBatch();
                        }
                    }
                    upd.executeBatch();
                }
            }
        }
    }

    @Override
    public List<Integer> findExpiredPendingBankTransferOrderIds() {
        List<Integer> ids = new java.util.ArrayList<>();
        String sql = "SELECT OrderID FROM Orders " +
                     "WHERE Status='PENDING' AND PaymentMethod='BANK_TRANSFER' AND ExpiresAt < GETDATE()";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) ids.add(rs.getInt("OrderID"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    @Override
    public boolean expireOrder(int orderId) throws Exception {
        Connection conn = null;
        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT Status, PaymentMethod, ExpiresAt FROM Orders WITH (UPDLOCK, ROWLOCK) WHERE OrderID = ?")) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return false;
                    // Re-check bên trong lock — tránh race với qr-status polling vừa CONFIRMED đơn.
                    boolean stillPending = "PENDING".equals(rs.getString("Status"))
                            && "BANK_TRANSFER".equals(rs.getString("PaymentMethod"));
                    Timestamp expiresAt = rs.getTimestamp("ExpiresAt");
                    if (!stillPending || expiresAt == null || expiresAt.after(new Timestamp(System.currentTimeMillis()))) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Orders SET Status='CANCELLED', CancelReason=N'Hết hạn thanh toán tự động', " +
                    "CancelledAt=DATEADD(HOUR,7,GETUTCDATE()) WHERE OrderID=?")) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            restoreStock(conn, orderId);
            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }
}
