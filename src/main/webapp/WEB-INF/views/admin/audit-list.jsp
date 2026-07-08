<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
    .act-badge{padding:5px 12px;border-radius:8px;font-size:12px;font-weight:800;letter-spacing:.02em}
    .act-LOGIN,.act-ADMIN_LOGIN{background:rgba(57,101,255,.12);color:#3965FF}
    .act-CHANGE_PASSWORD{background:rgba(245,165,36,.12);color:#B67B12}
    .act-UPDATE_ORDER_STATUS{background:rgba(122,90,248,.12);color:#7A5AF8}
    .act-DEFAULT{background:var(--admin-bg);color:var(--admin-text-light)}
    .mono{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12.5px;color:var(--admin-text-light)}
</style>

<div class="card">
    <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
        <div class="card-title" style="font-family:var(--fd);font-size:19px;font-weight:700">Nhật ký hoạt động
            <small style="display:block;font-family:var(--fb);font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-top:2px">200 hành động gần nhất trong hệ thống</small>
        </div>
    </div>
    <div class="table-responsive">
        <table class="admin-table">
            <thead><tr><th>Thời gian</th><th>Người thực hiện</th><th>Hành động</th><th>Đối tượng</th><th>Chi tiết</th><th>IP</th></tr></thead>
            <tbody>
                <c:forEach var="log" items="${logs}">
                    <tr>
                        <td><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                        <td><strong>${empty log.userName ? 'Hệ thống' : log.userName}</strong></td>
                        <td><span class="act-badge act-${log.action}">${log.action}</span></td>
                        <td>${log.target}</td>
                        <td>${log.detail}</td>
                        <td class="mono">${log.ipAddress}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty logs}">
                    <tr><td colspan="6" style="text-align:center;padding:40px;color:var(--admin-text-light)">
                        Chưa có nhật ký nào. <br><span style="font-size:13px">Hãy chạy <b>upgrade_01_hardening.sql</b> để tạo bảng AuditLogs, sau đó thao tác admin sẽ được ghi lại.</span>
                    </td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
