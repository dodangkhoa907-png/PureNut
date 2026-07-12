<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<div class="card">
    <div class="card-header">
        <div class="card-title">Phản hồi &amp; Hỗ trợ khách hàng
            <c:if test="${newCount > 0}">
                <span class="badge badge-PENDING" style="margin-left:8px">${newCount} mới</span>
            </c:if>
        </div>
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
                    <th>Khách hàng</th>
                    <th>Liên hệ</th>
                    <th>Đánh giá</th>
                    <th>Nội dung</th>
                    <th>Thời gian</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="fb" items="${feedbacks}">
                    <tr>
                        <td>
                            <strong><c:out value="${fb.name}"/></strong>
                            <c:if test="${not empty fb.userId}">
                                <div style="font-size:12px;color:var(--admin-text-light)">Tài khoản #${fb.userId}</div>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty fb.phone}"><div style="font-size:14px;"><c:out value="${fb.phone}"/></div></c:if>
                            <c:if test="${not empty fb.email}"><div style="font-size:13px;color:var(--admin-text-light);"><c:out value="${fb.email}"/></div></c:if>
                            <c:if test="${empty fb.phone and empty fb.email}"><span style="color:var(--admin-text-light)">—</span></c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty fb.rating}">
                                    <span style="color:#F6AD37;letter-spacing:1px;font-size:15px">
                                        <c:forEach begin="1" end="${fb.rating}">&#9733;</c:forEach><c:forEach begin="${fb.rating+1}" end="5"><span style="color:#D9D9D9">&#9733;</span></c:forEach>
                                    </span>
                                </c:when>
                                <c:otherwise><span style="color:var(--admin-text-light)">—</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="max-width:340px;white-space:pre-wrap;word-break:break-word;"><c:out value="${fb.message}"/></td>
                        <td><fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>
                            <span class="badge badge-${fb.status == 'NEW' ? 'PENDING' : (fb.status == 'SEEN' ? 'CONTACTED' : 'CLOSED')}">
                                ${fb.status == 'NEW' ? 'Mới' : (fb.status == 'SEEN' ? 'Đã xem' : 'Đã xử lý')}
                            </span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/phan-hoi/cap-nhat" method="POST" style="display:flex;gap:10px;">
                                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                                <input type="hidden" name="feedbackId" value="${fb.feedbackId}">
                                <select name="status" class="form-control" style="padding:6px;width:120px;font-size:13px;">
                                    <option value="NEW" ${fb.status == 'NEW' ? 'selected' : ''}>Mới</option>
                                    <option value="SEEN" ${fb.status == 'SEEN' ? 'selected' : ''}>Đã xem</option>
                                    <option value="RESOLVED" ${fb.status == 'RESOLVED' ? 'selected' : ''}>Đã xử lý</option>
                                </select>
                                <button type="submit" class="btn btn-primary" style="padding:6px 12px;font-size:13px;">Lưu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty feedbacks}">
                    <tr>
                        <td colspan="7" style="text-align:center;padding:30px;">Chưa có phản hồi nào</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
    <div style="display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-top:1px solid var(--admin-border)">
        <span style="font-size:13px;color:var(--admin-text-light);font-weight:500">Tổng ${totalItems} phản hồi · Trang ${currentPage}/${totalPages}</span>
        <div style="display:flex;gap:6px">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/admin/phan-hoi?page=${currentPage - 1}" style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;border:1.5px solid var(--admin-border);background:var(--admin-surface);color:var(--admin-text);font-size:14px;text-decoration:none;font-weight:600;transition:all .2s">&laquo;</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="p">
                <c:choose>
                    <c:when test="${p == currentPage}">
                        <span style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;font-size:14px;font-weight:700">${p}</span>
                    </c:when>
                    <c:when test="${p <= 3 || p >= totalPages - 1 || (p >= currentPage - 1 && p <= currentPage + 1)}">
                        <a href="${pageContext.request.contextPath}/admin/phan-hoi?page=${p}" style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;border:1.5px solid var(--admin-border);background:var(--admin-surface);color:var(--admin-text);font-size:14px;text-decoration:none;font-weight:600;transition:all .2s">${p}</a>
                    </c:when>
                    <c:when test="${p == 4 || p == totalPages - 2}">
                        <span style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;font-size:14px;color:var(--admin-text-light)">...</span>
                    </c:when>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/admin/phan-hoi?page=${currentPage + 1}" style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;border:1.5px solid var(--admin-border);background:var(--admin-surface);color:var(--admin-text);font-size:14px;text-decoration:none;font-weight:600;transition:all .2s">&raquo;</a>
            </c:if>
        </div>
    </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
