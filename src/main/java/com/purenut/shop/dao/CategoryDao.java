package com.purenut.shop.dao;

import com.purenut.shop.model.Category;

import java.util.List;
import java.util.Optional;

/**
 * DAO interface cho bảng Categories.
 * Implementation: {@link com.purenut.shop.dao.impl.CategoryDaoImpl}
 */
public interface CategoryDao {

    /** Trả về toàn bộ danh mục, sắp xếp theo tên. */
    List<Category> findAll();

    /** Tìm danh mục theo slug (unique). */
    Optional<Category> findBySlug(String slug);

    /** Tìm danh mục theo ID. */
    Optional<Category> findById(int id);
}
