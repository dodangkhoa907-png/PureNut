package com.purenut.shop.dao;

import com.purenut.shop.model.StaffMessage;
import java.util.List;

public interface StaffMessageDao {
    /* ── Chat chung ── */
    int insertChat(int userId, String message);
    /** Tin mới hơn afterId (afterId=0 → lấy 50 tin gần nhất) */
    List<StaffMessage> findChatAfter(int afterId);

    /* ── Ghi chú theo đơn ── */
    int insertNote(int orderId, int userId, String message);
    List<StaffMessage> findNotesByOrder(int orderId);
}
