package com.purenut.shop.model;

/** Danh mục sản phẩm (Dòng đậu nành / Dòng đặc biệt). */
public class Category {
    private int categoryId;
    private String name;
    private String slug;

    public Category() { }

    public Category(int categoryId, String name, String slug) {
        this.categoryId = categoryId;
        this.name = name;
        this.slug = slug;
    }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
}
