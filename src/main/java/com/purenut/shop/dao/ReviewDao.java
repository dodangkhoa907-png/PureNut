package com.purenut.shop.dao;

import com.purenut.shop.model.Review;

import java.util.List;

/**
 * DAO cho bảng Reviews (đánh giá sản phẩm).
 * Được ghi tự động khi khách xác nhận đã nhận hàng kèm đánh giá sao (xem AccountController).
 * Implementation: {@link com.purenut.shop.dao.impl.ReviewDaoImpl}
 */
public interface ReviewDao {

    /** Thêm đánh giá mới cho sản phẩm, trả về reviewId vừa tạo (0 nếu lỗi). */
    int insert(Review review);

    /** Danh sách đánh giá của một sản phẩm, mới nhất trước, kèm tên/ảnh người đánh giá (JOIN Users). */
    List<Review> findByProductId(int productId);
}
