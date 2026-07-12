package com.purenut.shop.model;

import java.util.Date;

/**
 * Tin nhắn nội bộ nhân viên.
 * orderId == null  → tin trong phòng chat chung (StaffMessages)
 * orderId != null  → ghi chú theo đơn hàng (OrderNotes)
 */
public class StaffMessage {
    private int id;
    private Integer orderId;
    private int userId;
    private String userName;  // join từ Users
    private String userRole;  // join từ Users
    private String message;
    private Date createdAt;

    public StaffMessage() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
