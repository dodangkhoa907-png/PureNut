<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
.ol-stats{display:flex;gap:14px;margin-bottom:22px;flex-wrap:wrap}
.ol-stat{flex:1;min-width:140px;padding:18px 20px;border-radius:14px;background:var(--admin-card);border:1px solid var(--admin-border)}
.ol-stat-val{font-family:var(--fd);font-size:24px;font-weight:800;margin-bottom:2px}
.ol-stat-label{font-size:12px;font-weight:600;color:var(--admin-text-light);text-transform:uppercase;letter-spacing:.4px}
.ol-stat .v-blue{color:#3965FF}.ol-stat .v-orange{color:#D48806}.ol-stat .v-purple{color:#7A5AF8}.ol-stat .v-green{color:#12B76A}

.os-pill{display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:99px;font-size:12px;font-weight:700;white-space:nowrap}
.os-pill i{font-size:10px}
.os-PENDING{background:rgba(245,165,36,.1);color:#D48806}
.os-CONFIRMED{background:rgba(57,101,255,.1);color:#3965FF}
.os-SHIPPING{background:rgba(122,90,248,.1);color:#7A5AF8}
.os-DONE{background:rgba(43,172,98,.1);color:#12B76A}
.os-CANCELLED{background:rgba(240,68,56,.1);color:#F04438}

.ol-detail-btn{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border-radius:10px;background:rgba(57,101,255,.08);color:var(--admin-primary);font-size:13px;font-weight:600;text-decoration:none;transition:background .2s}
.ol-detail-btn:hover{background:rgba(57,101,255,.16)}
</style>

<!-- Stats bar -->
<div class="ol-stats">
    <c:set var="cntAll" value="${orders.size()}"/>
    <c:set var="cntPending" value="0"/><c:set var="cntShipping" value="0"/><c:set var="cntDone" value="0"/>
    <c:forEach var="o" items="${orders}">
        <c:if test="${o.status == 'PENDING' || o.status == 'CONFIRMED'}"><c:set var="cntPending" value="${cntPending + 1}"/></c:if>
        <c:if test="${o.status == 'SHIPPING'}"><c:set var="cntShipping" value="${cntShipping + 1}"/></c:if>
        <c:if test="${o.status == 'DONE'}"><c:set var="cntDone" value="${cntDone + 1}"/></c:if>
    </c:forEach>
    <div class="ol-stat"><div class="ol-stat-val v-blue">${cntAll}</div><div class="ol-stat-label">Tổng đơn</div></div>
    <div class="ol-stat"><div class="ol-stat-val v-orange">${cntPending}</div><div class="ol-stat-label">Chờ xử lý</div></div>
    <div class="ol-stat"><div class="ol-stat-val v-purple">${cntShipping}</div><div class="ol-stat-label">Đang giao</div></div>
    <div class="ol-stat"><div class="ol-stat-val v-green">${cntDone}</div><div class="ol-stat-label">Hoàn thành</div></div>
</div>

<div class="card">
    <div class="card-header">
        <div class="card-title"><i class="fa-solid fa-boxes-stacked" style="margin-right:8px;opacity:.6"></i>Tất cả đơn hàng</div>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div style="text-align:center;padding:60px 20px;color:var(--admin-text-light)">
                <i class="fa-solid fa-inbox" style="font-size:40px;opacity:.3;margin-bottom:14px;display:block"></i>
                <p style="font-size:15px;font-weight:600">Chưa có đơn hàng nào</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                        <tr>
                            <td><strong>#${o.orderId}</strong></td>
                            <td>
                                <strong>${o.fullName}</strong><br>
                                <span style="font-size:12.5px;color:var(--admin-text-light)">${o.phone}</span>
                            </td>
                            <td><strong style="color:var(--admin-primary)"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</strong></td>
                            <td style="font-size:13px">${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}</td>
                            <td>
                                <span class="os-pill os-${o.status}">
                                    <i class="fa-solid ${o.status == 'PENDING' ? 'fa-clock' : o.status == 'CONFIRMED' ? 'fa-circle-check' : o.status == 'SHIPPING' ? 'fa-truck-fast' : o.status == 'DONE' ? 'fa-check-double' : 'fa-ban'}"></i>
                                    <c:choose>
                                        <c:when test="${o.status == 'PENDING'}">Chờ xử lý</c:when>
                                        <c:when test="${o.status == 'CONFIRMED'}">Đã xác nhận</c:when>
                                        <c:when test="${o.status == 'SHIPPING'}">Đang giao</c:when>
                                        <c:when test="${o.status == 'DONE'}">Hoàn thành</c:when>
                                        <c:when test="${o.status == 'CANCELLED'}">Đã huỷ</c:when>
                                        <c:otherwise>${o.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td style="font-size:13px;white-space:nowrap"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/don-hang/chi-tiet?id=${o.orderId}" class="ol-detail-btn">
                                    <i class="fa-solid fa-eye"></i> Chi tiết
                                </a>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
