<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
    
    <div>
        <div class="card">
            <div class="card-header">
                <div class="card-title">Sản phẩm trong đơn hàng (#${order.orderId})</div>
            </div>
            
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.items}">
                        <tr>
                            <td><strong>${item.productName}</strong></td>
                            <td><fmt:formatNumber value="${item.priceAtTime}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                            <td>x${item.quantity}</td>
                            <td><strong style="color: var(--admin-primary);"><fmt:formatNumber value="${item.priceAtTime * item.quantity}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <div>
        <div class="card">
            <div class="card-header">
                <div class="card-title">Cập nhật Trạng thái</div>
            </div>
            <c:if test="${not empty param.success}">
                <div style="padding: 10px; background: #E8F9F3; color: #05CD99; border-radius: 8px; margin-bottom: 15px; font-size: 14px;">
                    Cập nhật thành công!
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/admin/don-hang/cap-nhat" method="POST">
                <input type="hidden" name="orderId" value="${order.orderId}">
                <div class="form-group">
                    <select name="status" class="form-control">
                        <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý (PENDING)</option>
                        <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận (CONFIRMED)</option>
                        <option value="SHIPPING" ${order.status == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng (SHIPPING)</option>
                        <option value="DONE" ${order.status == 'DONE' ? 'selected' : ''}>Hoàn thành (DONE)</option>
                        <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Đã huỷ (CANCELLED)</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">Cập nhật trạng thái</button>
            </form>
        </div>
        
        <div class="card">
            <div class="card-header">
                <div class="card-title">Thông tin Giao hàng</div>
            </div>
            <div style="font-size: 15px; line-height: 1.8;">
                <p><strong>Khách hàng:</strong> ${order.fullName}</p>
                <p><strong>Số điện thoại:</strong> ${order.phone}</p>
                <p><strong>Địa chỉ:</strong> ${order.address}</p>
                <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                <hr style="border: none; border-top: 1px solid var(--admin-border); margin: 15px 0;">
                <p><strong>Thanh toán:</strong> ${order.paymentMethod == 'COD' ? 'Thanh toán khi nhận hàng' : 'Chuyển khoản'}</p>
                <p><strong>Tổng cộng:</strong> <span style="font-size: 20px; color: var(--admin-primary); font-weight: bold;"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span></p>
            </div>
        </div>
    </div>
    
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
