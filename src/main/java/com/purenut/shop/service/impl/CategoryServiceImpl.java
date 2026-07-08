package com.purenut.shop.service.impl;

import com.purenut.shop.dao.CategoryDao;
import com.purenut.shop.dao.impl.CategoryDaoImpl;
import com.purenut.shop.model.Category;
import com.purenut.shop.service.CategoryService;

import java.util.List;
import java.util.Optional;

/**
 * Triển khai CategoryService.
 * Khởi tạo DAO nội bộ — không cần DI framework.
 */
public class CategoryServiceImpl implements CategoryService {

    private final CategoryDao categoryDao;

    /** Constructor mặc định — Servlet dùng {@code new CategoryServiceImpl()}. */
    public CategoryServiceImpl() {
        this.categoryDao = new CategoryDaoImpl();
    }

    /** Constructor tiêm DAO — dùng cho unit test mock. */
    public CategoryServiceImpl(CategoryDao categoryDao) {
        this.categoryDao = categoryDao;
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryDao.findAll();
    }

    @Override
    public Optional<Category> getCategoryBySlug(String slug) {
        if (slug == null || slug.isBlank()) return Optional.empty();
        return categoryDao.findBySlug(slug.trim());
    }

    @Override
    public Optional<Category> getCategoryById(int id) {
        if (id <= 0) return Optional.empty();
        return categoryDao.findById(id);
    }
}
