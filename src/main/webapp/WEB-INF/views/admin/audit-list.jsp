<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
/* ── Tabs ── */
.al-tabs{display:flex;gap:0;margin-bottom:22px;background:var(--admin-surface);border-radius:14px;padding:5px;border:1px solid var(--admin-border);overflow-x:auto}
.al-tab{
    padding:11px 18px;font-size:13.5px;font-weight:700;color:var(--admin-text-light);
    cursor:pointer;border-radius:10px;transition:background .2s,color .2s;white-space:nowrap;
    display:flex;align-items:center;gap:7px;
}
.al-tab:hover{color:var(--admin-text);background:rgba(57,101,255,.04)}
.al-tab.active{background:var(--admin-primary);color:#fff;box-shadow:0 4px 14px -4px rgba(57,101,255,.35)}
.al-tab .al-cnt{
    font-size:11px;font-weight:800;padding:2px 7px;border-radius:6px;
    background:rgba(255,255,255,.2);color:inherit;
}
.al-tab:not(.active) .al-cnt{background:rgba(57,101,255,.08);color:var(--admin-primary)}

/* ── Badge ── */
.act-badge{padding:5px 12px;border-radius:8px;font-size:12px;font-weight:800;letter-spacing:.02em}
.act-LOGIN,.act-ADMIN_LOGIN{background:rgba(57,101,255,.12);color:#3965FF}
.act-CHANGE_PASSWORD{background:rgba(245,165,36,.12);color:#B67B12}
.act-UPDATE_ORDER_STATUS{background:rgba(122,90,248,.12);color:#7A5AF8}
.act-DEFAULT{background:var(--admin-bg);color:var(--admin-text-light)}
.mono{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12.5px;color:var(--admin-text-light)}

/* ── Order status detail pills ── */
.audit-status{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:8px;font-size:11.5px;font-weight:700}
.as-CONFIRMED{background:rgba(57,101,255,.1);color:#3965FF}
.as-SHIPPING{background:rgba(122,90,248,.1);color:#7A5AF8}
.as-DONE{background:rgba(43,172,98,.1);color:#12B76A}
.as-CANCELLED{background:rgba(240,68,56,.1);color:#F04438}

/* ── Tab pane ── */
.al-pane{display:none}.al-pane.active{display:block}
</style>

<%-- Count logs by category --%>
<c:set var="cntAll" value="${fn:length(logs)}"/>
<c:set var="cntOrder" value="0"/>
<c:set var="cntConfirmed" value="0"/>
<c:set var="cntShipping" value="0"/>
<c:set var="cntDone" value="0"/>
<c:set var="cntCancelled" value="0"/>
<c:set var="cntOther" value="0"/>
<c:forEach var="log" items="${logs}">
    <c:choose>
        <c:when test="${log.action == 'UPDATE_ORDER_STATUS'}">
            <c:set var="cntOrder" value="${cntOrder + 1}"/>
            <c:if test="${fn:contains(log.detail, 'CONFIRMED')}"><c:set var="cntConfirmed" value="${cntConfirmed + 1}"/></c:if>
            <c:if test="${fn:contains(log.detail, 'SHIPPING')}"><c:set var="cntShipping" value="${cntShipping + 1}"/></c:if>
            <c:if test="${fn:contains(log.detail, 'DONE')}"><c:set var="cntDone" value="${cntDone + 1}"/></c:if>
            <c:if test="${fn:contains(log.detail, 'CANCELLED')}"><c:set var="cntCancelled" value="${cntCancelled + 1}"/></c:if>
        </c:when>
        <c:otherwise><c:set var="cntOther" value="${cntOther + 1}"/></c:otherwise>
    </c:choose>
</c:forEach>

<!-- Tabs -->
<div class="al-tabs">
    <div class="al-tab active" data-tab="all" onclick="switchAuditTab(this)"><i class="fa-solid fa-list" style="font-size:12px"></i> Tất cả <span class="al-cnt">${cntAll}</span></div>
    <div class="al-tab" data-tab="confirmed" onclick="switchAuditTab(this)"><i class="fa-solid fa-circle-check" style="font-size:12px"></i> Đã xác nhận <span class="al-cnt">${cntConfirmed}</span></div>
    <div class="al-tab" data-tab="shipping" onclick="switchAuditTab(this)"><i class="fa-solid fa-truck-fast" style="font-size:12px"></i> Đang giao <span class="al-cnt">${cntShipping}</span></div>
    <div class="al-tab" data-tab="done" onclick="switchAuditTab(this)"><i class="fa-solid fa-check-double" style="font-size:12px"></i> Hoàn thành <span class="al-cnt">${cntDone}</span></div>
    <div class="al-tab" data-tab="cancelled" onclick="switchAuditTab(this)"><i class="fa-solid fa-ban" style="font-size:12px"></i> Đã huỷ <span class="al-cnt">${cntCancelled}</span></div>
    <div class="al-tab" data-tab="other" onclick="switchAuditTab(this)"><i class="fa-solid fa-ellipsis" style="font-size:12px"></i> Khác <span class="al-cnt">${cntOther}</span></div>
</div>

<div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
        <div style="font-family:var(--fd);font-size:19px;font-weight:700">
            <i class="fa-solid fa-clock-rotate-left" style="margin-right:8px;opacity:.5"></i>Nhật ký hoạt động
            <small style="display:block;font-family:var(--fb);font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-top:2px">200 hành động gần nhất trong hệ thống</small>
        </div>
    </div>
    <div class="table-responsive">
        <table class="admin-table">
            <thead><tr><th>Thời gian</th><th>Người thực hiện</th><th>Hành động</th><th>Đối tượng</th><th>Chi tiết</th><th>IP</th></tr></thead>
            <tbody id="auditBody">
                <c:forEach var="log" items="${logs}">
                    <c:set var="logCat" value="other"/>
                    <c:if test="${log.action == 'UPDATE_ORDER_STATUS'}">
                        <c:set var="logCat" value="order"/>
                        <c:if test="${fn:contains(log.detail, 'CONFIRMED')}"><c:set var="logCat" value="confirmed"/></c:if>
                        <c:if test="${fn:contains(log.detail, 'SHIPPING')}"><c:set var="logCat" value="shipping"/></c:if>
                        <c:if test="${fn:contains(log.detail, 'DONE')}"><c:set var="logCat" value="done"/></c:if>
                        <c:if test="${fn:contains(log.detail, 'CANCELLED')}"><c:set var="logCat" value="cancelled"/></c:if>
                    </c:if>
                    <tr data-cat="${logCat}">
                        <td style="white-space:nowrap"><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                        <td><strong>${empty log.userName ? 'Hệ thống' : log.userName}</strong></td>
                        <td><span class="act-badge act-${log.action != 'LOGIN' && log.action != 'ADMIN_LOGIN' && log.action != 'CHANGE_PASSWORD' && log.action != 'UPDATE_ORDER_STATUS' ? 'DEFAULT' : log.action}">${log.action}</span></td>
                        <td>${log.target}</td>
                        <td>
                            <c:choose>
                                <c:when test="${log.action == 'UPDATE_ORDER_STATUS' && fn:contains(log.detail, 'CONFIRMED')}">
                                    <span class="audit-status as-CONFIRMED"><i class="fa-solid fa-circle-check"></i> ${log.detail}</span>
                                </c:when>
                                <c:when test="${log.action == 'UPDATE_ORDER_STATUS' && fn:contains(log.detail, 'SHIPPING')}">
                                    <span class="audit-status as-SHIPPING"><i class="fa-solid fa-truck-fast"></i> ${log.detail}</span>
                                </c:when>
                                <c:when test="${log.action == 'UPDATE_ORDER_STATUS' && fn:contains(log.detail, 'DONE')}">
                                    <span class="audit-status as-DONE"><i class="fa-solid fa-check-double"></i> ${log.detail}</span>
                                </c:when>
                                <c:when test="${log.action == 'UPDATE_ORDER_STATUS' && fn:contains(log.detail, 'CANCELLED')}">
                                    <span class="audit-status as-CANCELLED"><i class="fa-solid fa-ban"></i> ${log.detail}</span>
                                </c:when>
                                <c:otherwise>${log.detail}</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="mono">${log.ipAddress}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty logs}">
                    <tr data-cat="all"><td colspan="6" style="text-align:center;padding:40px;color:var(--admin-text-light)">
                        Chưa có nhật ký nào.
                    </td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<script>
function switchAuditTab(el){
    document.querySelectorAll('.al-tab').forEach(function(t){ t.classList.remove('active'); });
    el.classList.add('active');
    var tab = el.dataset.tab;
    var rows = document.querySelectorAll('#auditBody tr[data-cat]');
    rows.forEach(function(tr){
        var cat = tr.dataset.cat;
        if(tab === 'all'){
            tr.style.display = '';
        } else {
            tr.style.display = (cat === tab) ? '' : 'none';
        }
    });
}
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
