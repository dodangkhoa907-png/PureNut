package com.purenut.shop.dao.impl;

import com.purenut.shop.config.Database;
import com.purenut.shop.dao.OrderDao;
import com.purenut.shop.model.CartItem;
import com.purenut.shop.model.Order;

import java.sql.*;
import java.util.List;

public class OrderDaoImpl implements OrderDao {

    @Override
    public int placeOrder(Order order, List<CartItem> cartItems) throws Exception {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psOrderItem = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psDeleteCart = null;
        ResultSet rsKeys = null;
        
        int orderId = 0;
        
        try {
            conn = Database.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction
            
            // 1. Lưu Order
            String sqlOrder = "INSERT INTO Orders (UserID, FullName, Phone, Address, TotalAmount, PaymentMethod, Status, CouponCode) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setNString(2, order.getFullName());
            psOrder.setString(3, order.getPhone());
            psOrder.setNString(4, order.getAddress());
            psOrder.setBigDecimal(5, order.getTotalAmount());
            psOrder.setString(6, order.getPaymentMethod());
            psOrder.setString(7, "PENDING");
            psOrder.setString(8, order.getCouponCode());
            
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
        // Chỉ gán khi đơn đã CONFIRMED (hoặc gán lại khi đang SHIPPING)
        String sql = "UPDATE Orders SET ShipperID = ?, Status = 'SHIPPING' " +
                     "WHERE OrderID = ? AND Status IN ('CONFIRMED','SHIPPING')";
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            ps.setInt(2, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Order> findOrdersByShipper(int shipperId) {
        List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE ShipperID = ? " +
                     "ORDER BY CASE WHEN Status = 'SHIPPING' THEN 0 ELSE 1 END, CreatedAt DESC";
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
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> findAllOrdersPaged(int offset, int limit) {
        List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, o.FullName, o.Phone, o.Address, " +
                     "o.TotalAmount, o.PaymentMethod, o.Status, o.CouponCode, o.CreatedAt, " +
                     "o.CancelReason, o.CancelledAt, o.ShipperID, s.FullName AS ShipperName, " +
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
    }
}
