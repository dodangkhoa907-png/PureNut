package com.purenut.shop.model;

import java.util.Date;

public class Shipper {
    private int shipperId;        // = Users.UserID
    private String fullName;
    private String phone;
    private String vehiclePlate;
    private String status;        // ACTIVE | OFFLINE
    private String allowedIp;     // CSV IP nội bộ, null = chưa khóa IP
    private Date createdAt;

    public int getShipperId() { return shipperId; }
    public void setShipperId(int shipperId) { this.shipperId = shipperId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getVehiclePlate() { return vehiclePlate; }
    public void setVehiclePlate(String vehiclePlate) { this.vehiclePlate = vehiclePlate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAllowedIp() { return allowedIp; }
    public void setAllowedIp(String allowedIp) { this.allowedIp = allowedIp; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
