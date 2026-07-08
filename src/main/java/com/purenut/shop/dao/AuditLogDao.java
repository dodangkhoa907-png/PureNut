package com.purenut.shop.dao;

import com.purenut.shop.model.AuditLog;
import java.util.List;

public interface AuditLogDao {
    /** Ghi 1 dòng nhật ký. Trả về true nếu thành công (không ném exception ra ngoài). */
    boolean insert(AuditLog log);

    /** Lấy N bản ghi gần nhất (kèm tên người thực hiện). */
    List<AuditLog> findRecent(int limit);
}
