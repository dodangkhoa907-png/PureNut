<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<div class="card">
    <div class="card-header">
        <div class="card-title">Tất cả đơn hàng</div>
    </div>
    
    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Mã ĐH</th>
                    <th>Khách Hàng</th>
                    <th>Tổng Tiền</th>
                    <th>Phương Thức</th>
                    <th>Trạng Thái</th>
                    <th>Ngày Đặt</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td><strong>#${o.orderId}</strong></td>
                        <td>
                            <strong>${o.fullName}</strong><br>
                            <span style="font-size: 13px; color: var(--admin-text-light);">${o.phone}</span>
                        </td>
                        <td><strong style="color: var(--admin-primary);"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong></td>
                        <td>${o.paymentMethod == 'COD' ? 'Thanh toán khi nhận hàng' : 'Chuyển khoản'}</td>
                        <td><span class="badge badge-${o.status}">${o.status}</span></td>
                        <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/don-hang/chi-tiet?id=${o.orderId}" class="btn" style="background: rgba(27,79,158,0.1); color: var(--admin-primary); padding: 8px 12px;">
                                <i class="fa-solid fa-eye"></i> Chi tiết
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
