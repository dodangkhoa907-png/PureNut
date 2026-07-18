package com.purenut.shop.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private int orderId;
    private int userId;
    private String fullName;
    private String phone;
    private String address;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private String status;
    private String couponCode;
    private Date createdAt;
    private String cancelReason;
    private Date cancelledAt;
    private String email;
    private Date accountCreatedAt;
    private Integer shipperId;    // null = chưa gán shipper
    private String shipperName;   // join từ Users

    private String deliveryStatus;   // ASSIGNED | PICKING_UP | DELIVERING | COMPLETED | FAILED
    private Double latitude;         // tọa độ khách lúc đặt hàng
    private Double longitude;
    private String proofImage;       // ảnh bằng chứng giao hàng

    private Date deliveredAt;            // thời điểm shipper báo hoàn thành
    private Date receivedConfirmedAt;    // thời điểm khách xác nhận đã nhận hàng
    private Integer deliveryRating;      // 1..5 sao, null = chưa đánh giá
    private String deliveryReview;       // nhận xét tùy chọn

    private List<OrderItem> items;

    public Order() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCouponCode() { return couponCode; }
    public void setCouponCode(String couponCode) { this.couponCode = couponCode; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }

    public Date getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(Date cancelledAt) { this.cancelledAt = cancelledAt; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Date getAccountCreatedAt() { return accountCreatedAt; }
    public void setAccountCreatedAt(Date accountCreatedAt) { this.accountCreatedAt = accountCreatedAt; }

    public Integer getShipperId() { return shipperId; }
    public void setShipperId(Integer shipperId) { this.shipperId = shipperId; }

    public String getShipperName() { return shipperName; }
    public void setShipperName(String shipperName) { this.shipperName = shipperName; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public String getProofImage() { return proofImage; }
    public void setProofImage(String proofImage) { this.proofImage = proofImage; }

    public Date getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(Date deliveredAt) { this.deliveredAt = deliveredAt; }

    public Date getReceivedConfirmedAt() { return receivedConfirmedAt; }
    public void setReceivedConfirmedAt(Date receivedConfirmedAt) { this.receivedConfirmedAt = receivedConfirmedAt; }

    public Integer getDeliveryRating() { return deliveryRating; }
    public void setDeliveryRating(Integer deliveryRating) { this.deliveryRating = deliveryRating; }

    public String getDeliveryReview() { return deliveryReview; }
    public void setDeliveryReview(String deliveryReview) { this.deliveryReview = deliveryReview; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}
