package com.purenut.shop.service;

import com.purenut.shop.model.Category;

import java.util.List;
import java.util.Optional;

/**
 * Service interface cho Category.
 * Implementation: {@link com.purenut.shop.service.impl.CategoryServiceImpl}
 */
public interface CategoryService {

    /** Trả về tất cả danh mục (dùng cho nav filter chip). */
    List<Category> getAllCategories();

    /** Tìm danh mục theo slug. */
    Optional<Category> getCategoryBySlug(String slug);

    /** Tìm danh mục theo ID. */
    Optional<Category> getCategoryById(int id);
}
