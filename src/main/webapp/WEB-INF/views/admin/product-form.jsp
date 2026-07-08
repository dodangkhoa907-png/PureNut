<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<div class="card" style="max-width: 800px; margin: 0 auto;">
    <div class="card-header">
        <div class="card-title">${empty product ? 'Thêm Sản Phẩm Mới' : 'Sửa Sản Phẩm'}</div>
        <a href="${pageContext.request.contextPath}/admin/san-pham" class="btn btn-outline">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/admin/san-pham/${empty product ? 'them' : 'sua'}" method="POST">
        <c:if test="${not empty product}">
            <input type="hidden" name="productId" value="${product.productId}">
        </c:if>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label>Tên sản phẩm *</label>
                <input type="text" name="name" class="form-control" required value="${product.name}" onkeyup="generateSlug(this.value)">
            </div>
            <div class="form-group">
                <label>Slug (Đường dẫn tĩnh) *</label>
                <input type="text" name="slug" id="slugInput" class="form-control" required value="${product.slug}">
            </div>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label>Danh mục *</label>
                <select name="categoryId" class="form-control" required>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}" ${product.categoryId == c.categoryId ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Giá bán (VNĐ) *</label>
                <input type="number" name="price" class="form-control" required value="${product.price}">
            </div>
        </div>
        
        <div class="form-group">
            <label>Hình ảnh (Đường dẫn tĩnh: /resources/img/products/...) *</label>
            <input type="text" name="imageUrl" class="form-control" required value="${product.imageUrl != null ? product.imageUrl : '/resources/img/products/'}">
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label>Màu nền Hex (VD: #E7C9A0)</label>
                <div style="display: flex; gap: 10px;">
                    <input type="color" id="colorPicker" value="${product.bgColorHex != null ? product.bgColorHex : '#E7C9A0'}" style="height: 45px; width: 50px; border: none; border-radius: 8px; cursor: pointer;">
                    <input type="text" name="bgColorHex" id="colorHex" class="form-control" value="${product.bgColorHex != null ? product.bgColorHex : '#E7C9A0'}">
                </div>
            </div>
            <div class="form-group">
                <label>Thể tích (ml)</label>
                <input type="number" name="volumeMl" class="form-control" value="${product.volumeMl != null ? product.volumeMl : 300}">
            </div>
            <div class="form-group">
                <label>Kcal / 100ml</label>
                <input type="number" name="kcalPer100ml" class="form-control" value="${product.kcalPer100ml}">
            </div>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label>Số lượng tồn kho</label>
                <input type="number" name="stockQuantity" class="form-control" required value="${product.stockQuantity != null ? product.stockQuantity : 100}">
            </div>
            <div class="form-group" style="display: flex; align-items: center; gap: 10px; margin-top: 25px;">
                <input type="checkbox" name="isFeatured" id="isFeatured" style="width: 20px; height: 20px;" ${product.featured ? 'checked' : ''}>
                <label for="isFeatured" style="margin: 0; cursor: pointer;">Sản phẩm nổi bật</label>
            </div>
        </div>
        
        <div class="form-group">
            <label>Mô tả sản phẩm</label>
            <textarea name="description" class="form-control" rows="4">${product.description}</textarea>
        </div>
        
        <div style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px;">
            <a href="${pageContext.request.contextPath}/admin/san-pham" class="btn btn-outline">Hủy</a>
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-save"></i> ${empty product ? 'Thêm Sản Phẩm' : 'Lưu Thay Đổi'}
            </button>
        </div>
    </form>
</div>

<script>
    // Tự động sinh slug từ name
    function generateSlug(text) {
        let slug = text.toLowerCase();
        slug = slug.replace(/á|à|ả|ạ|ã|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ/gi, 'a');
        slug = slug.replace(/é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ/gi, 'e');
        slug = slug.replace(/i|í|ì|ỉ|ĩ|ị/gi, 'i');
        slug = slug.replace(/ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ/gi, 'o');
        slug = slug.replace(/ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự/gi, 'u');
        slug = slug.replace(/ý|ỳ|ỷ|ỹ|ỵ/gi, 'y');
        slug = slug.replace(/đ/gi, 'd');
        slug = slug.replace(/[^a-z0-9 -]/g, '');
        slug = slug.replace(/\s+/g, '-');
        slug = slug.replace(/-+/g, '-');
        
        if (!document.getElementById('slugInput').value || '${empty product}' === 'true') {
             document.getElementById('slugInput').value = slug;
        }
    }
    
    // Đồng bộ color picker và input hex
    document.getElementById('colorPicker').addEventListener('input', function() {
        document.getElementById('colorHex').value = this.value.toUpperCase();
    });
    document.getElementById('colorHex').addEventListener('input', function() {
        document.getElementById('colorPicker').value = this.value;
    });
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
