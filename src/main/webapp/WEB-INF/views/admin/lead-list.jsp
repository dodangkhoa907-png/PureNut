<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<div class="card">
    <div class="card-header">
        <div class="card-title">Danh sách Khách hàng đăng ký Đại lý</div>
    </div>
    
    <c:if test="${not empty param.success}">
        <div style="padding: 12px 16px; background: #E8F9F3; color: #05CD99; border-radius: 8px; margin-bottom: 20px;">
            Cập nhật trạng thái thành công!
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Họ & Tên</th>
                    <th>Liên hệ</th>
                    <th>Khu vực (City)</th>
                    <th>Ngày đăng ký</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="lead" items="${leads}">
                    <tr>
                        <td><strong>${lead.fullName}</strong></td>
                        <td>
                            <div style="font-size: 14px;">${lead.phone}</div>
                            <div style="font-size: 13px; color: var(--admin-text-light);">${lead.email}</div>
                        </td>
                        <td>${lead.city}</td>
                        <td><fmt:formatDate value="${lead.createdAt}" pattern="dd/MM/yyyy" /></td>
                        <td>
                            <span class="badge badge-${lead.status}">
                                ${lead.status == 'PENDING' ? 'Chờ liên hệ' : (lead.status == 'CONTACTED' ? 'Đã liên hệ' : 'Từ chối')}
                            </span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/dai-ly/cap-nhat" method="POST" style="display: flex; gap: 10px;">
                                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                                <input type="hidden" name="leadId" value="${lead.leadId}">
                                <select name="status" class="form-control" style="padding: 6px; width: 130px; font-size: 13px;">
                                    <option value="PENDING" ${lead.status == 'PENDING' ? 'selected' : ''}>Chờ liên hệ</option>
                                    <option value="CONTACTED" ${lead.status == 'CONTACTED' ? 'selected' : ''}>Đã liên hệ</option>
                                    <option value="CLOSED" ${lead.status == 'CLOSED' ? 'selected' : ''}>Đóng</option>
                                </select>
                                <button type="submit" class="btn btn-primary" style="padding: 6px 12px; font-size: 13px;">Lưu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty leads}">
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px;">Chưa có khách đăng ký</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
