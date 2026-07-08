package com.purenut.shop.dao;

import com.purenut.shop.model.DealerLead;
import java.util.List;

public interface DealerLeadDao {
    int insert(DealerLead lead);
    List<DealerLead> findAll();
    int updateStatus(int leadId, String status);
}
