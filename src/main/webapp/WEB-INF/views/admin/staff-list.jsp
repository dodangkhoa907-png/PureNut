<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<c:if test="${not empty param.success}">
    <div style="padding:12px 16px;background:#E8F9F3;color:#05CD99;border-radius:8px;margin-bottom:20px;">
        ${param.success == 'created' ? 'Tạo tài khoản nhân viên thành công!' : 'Cập nhật thành công!'}
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div style="padding:12px 16px;background:#FBE9E9;color:#CE2E2E;border-radius:8px;margin-bottom:20px;">
        <c:choose>
            <c:when test="${param.error == 'EmailExists'}">Email đã tồn tại trong hệ thống.</c:when>
            <c:when test="${param.error == 'BadInput'}">Dữ liệu không hợp lệ — kiểm tra email hợp lệ và mật khẩu ≥ 8 ký tự.</c:when>
            <c:otherwise>Không thực hiện được, vui lòng thử lại.</c:otherwise>
        </c:choose>
    </div>
</c:if>

<div class="card" style="margin-bottom:24px;">
    <div class="card-header">
        <div class="card-title">Tạo tài khoản nhân viên</div>
    </div>
    <form action="${pageContext.request.contextPath}/admin/nhan-su/tao" method="POST"
          style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px;align-items:end;">
        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
        <div>
            <label style="font-size:12px;font-weight:700;display:block;margin-bottom:5px;">Họ tên *</label>
            <input class="form-control" type="text" name="fullName" required maxlength="150" placeholder="Nguyễn Văn B">
        </div>
        <div>
            <label style="font-size:12px;font-weight:700;display:block;margin-bottom:5px;">Email *</label>
            <input class="form-control" type="email" name="email" required maxlength="150" placeholder="shipper@purenut.vn">
        </div>
        <div>
            <label style="font-size:12px;font-weight:700;display:block;margin-bottom:5px;">SĐT</label>
            <input class="form-control" type="tel" name="phone" maxlength="11" placeholder="09xx xxx xxx">
        </div>
        <div>
            <label style="font-size:12px;font-weight:700;display:block;margin-bottom:5px;">Mật khẩu (≥ 8 ký tự) *</label>
            <input class="form-control" type="text" name="password" required minlength="8" maxlength="72" placeholder="Mật khẩu tạm">
        </div>
        <div>
            <label style="font-size:12px;font-weight:700;display:block;margin-bottom:5px;">Vai trò *</label>
            <select class="form-control" name="role" required>
                <option value="SHIPPER">Shipper (giao hàng)</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary" style="padding:10px 18px;">+ Tạo tài khoản</button>
    </form>
</div>

<div class="card">
    <div class="card-header">
        <div class="card-title">Danh sách nhân viên</div>
    </div>
    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Họ tên</th>
                    <th>Liên hệ</th>
                    <th>Vai trò</th>
                    <th>Đăng nhập gần nhất</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${staffList}">
                    <tr>
                        <td><strong><c:out value="${u.fullName}"/></strong></td>
                        <td>
                            <div style="font-size:14px;"><c:out value="${u.email}"/></div>
                            <div style="font-size:13px;color:var(--admin-text-light);"><c:out value="${u.phone}"/></div>
                        </td>
                        <td>
                            <span class="badge badge-PENDING">Shipper</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty u.lastLoginAt}"><fmt:formatDate value="${u.lastLoginAt}" pattern="HH:mm dd/MM/yyyy"/></c:when>
                                <c:otherwise><span style="color:var(--admin-text-light)">Chưa đăng nhập</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/nhan-su/doi-role" method="POST" style="display:flex;gap:10px;">
                                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                                <input type="hidden" name="userId" value="${u.userId}">
                                <select name="role" class="form-control" style="padding:6px;width:150px;font-size:13px;">
                                    <option value="SHIPPER" ${u.role == 'SHIPPER' ? 'selected' : ''}>Shipper</option>
                                    <option value="CUSTOMER">Thu hồi quyền</option>
                                </select>
                                <button type="submit" class="btn btn-primary" style="padding:6px 12px;font-size:13px;">Lưu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty staffList}">
                    <tr><td colspan="5" style="text-align:center;padding:30px;">Chưa có nhân viên — tạo tài khoản đầu tiên ở form phía trên.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
