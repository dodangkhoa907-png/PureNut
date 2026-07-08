<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<div class="card">
    <div class="card-header">
        <div class="card-title">Danh sách sản phẩm</div>
        <a href="${pageContext.request.contextPath}/admin/san-pham/them" class="btn btn-primary">
            <i class="fa-solid fa-plus"></i> Thêm sản phẩm
        </a>
    </div>
    
    <c:if test="${not empty param.success}">
        <div style="padding: 12px 16px; background: #E8F9F3; color: #05CD99; border-radius: 8px; margin-bottom: 20px;">
            Thao tác thành công!
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Danh mục</th>
                    <th>Giá</th>
                    <th>Tồn kho</th>
                    <th>Nổi bật</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td style="display: flex; align-items: center; gap: 15px;">
                            <div style="width: 50px; height: 50px; background: ${p.bgColorHex}; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                <img src="${pageContext.request.contextPath}${p.imageUrl}" alt="${p.name}" style="height: 40px;" onerror="this.onerror=null;this.src=&quot;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40'%3E%3Ctext x='50%25' y='58%25' font-size='24' text-anchor='middle'%3E%F0%9F%A5%9B%3C/text%3E%3C/svg%3E&quot;">
                            </div>
                            <div>
                                <strong>${p.name}</strong>
                                <div style="font-size: 13px; color: var(--admin-text-light);">${p.volumeMl}ml | ${p.kcalPer100ml} kcal/100ml</div>
                            </div>
                        </td>
                        <td>${p.categoryName}</td>
                        <td><strong style="color: var(--admin-primary);"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${p.stockQuantity <= 10}">
                                    <span style="color: #EE5D50; font-weight: bold;">${p.stockQuantity} (Sắp hết)</span>
                                </c:when>
                                <c:otherwise>
                                    ${p.stockQuantity}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/san-pham/noi-bat" method="POST" style="display: inline;">
                                <input type="hidden" name="id" value="${p.productId}">
                                <input type="hidden" name="featured" value="${p.featured}">
                                <button type="submit" style="background:none; border:none; cursor:pointer; color: ${p.featured ? '#FFB547' : '#E0E5F2'}; font-size: 20px;">
                                    <i class="fa-solid fa-star"></i>
                                </button>
                            </form>
                        </td>
                        <td>
                            <div style="display: flex; gap: 10px;">
                                <a href="${pageContext.request.contextPath}/admin/san-pham/sua?id=${p.productId}" class="btn" style="background: rgba(27,79,158,0.1); color: var(--admin-primary); padding: 8px 12px;">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/san-pham/xoa" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn xoá sản phẩm này?');" style="display: inline;">
                                    <input type="hidden" name="id" value="${p.productId}">
                                    <button type="submit" class="btn" style="background: rgba(238,93,80,0.1); color: #EE5D50; padding: 8px 12px;">
                                        <i class="fa-solid fa-trash"></i> Xoá
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
