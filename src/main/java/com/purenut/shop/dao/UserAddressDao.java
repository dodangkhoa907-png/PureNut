package com.purenut.shop.dao;

import com.purenut.shop.model.UserAddress;
import java.util.List;

public interface UserAddressDao {
    List<UserAddress> findByUserId(int userId);
    int insert(UserAddress address);
    boolean delete(int addressId, int userId);
    boolean setDefault(int addressId, int userId);
}
