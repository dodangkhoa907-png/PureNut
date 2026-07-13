package com.purenut.shop.dao;

import com.purenut.shop.model.Shipper;

import java.util.List;
import java.util.Optional;

public interface ShipperDao {

    Optional<Shipper> findById(int shipperId);

    /** Danh sách shipper ACTIVE cho dropdown điều phối */
    List<Shipper> findActive();

    /** Tất cả shipper (cả OFFLINE) cho command center */
    List<Shipper> findAll();

    /** Tự tạo hồ sơ nếu user SHIPPER chưa có (đăng nhập lần đầu sau migration) */
    void ensureProfile(int userId, String fullName, String phone);

    /** Shipper tự bật/tắt trạng thái nhận đơn */
    boolean updateStatus(int shipperId, String status);

    /** Admin cấp/thu hồi IP nội bộ */
    boolean updateAllowedIp(int shipperId, String allowedIp, String vehiclePlate);
}
