package com.purenut.shop.dao;

import com.purenut.shop.model.Feedback;
import java.util.List;

public interface FeedbackDao {
    int insert(Feedback fb);
    List<Feedback> findAll();
    int countByStatus(String status);
    int updateStatus(int feedbackId, String status);

    List<Feedback> findAllPaged(int offset, int limit);
    int countAll();
}
