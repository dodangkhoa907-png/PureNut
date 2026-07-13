<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
.od-back{display:inline-flex;align-items:center;gap:6px;font-size:13.5px;font-weight:600;color:var(--admin-text-light);margin-bottom:20px;transition:color .2s;text-decoration:none}
.od-back:hover{color:var(--admin-primary)}
.od-back svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}

.od-grid{display:grid;grid-template-columns:1.6fr 1fr;gap:22px}
.od-card{background:var(--admin-card);border:1px solid var(--admin-border);border-radius:16px;padding:24px;margin-bottom:22px}
.od-card-t{font-family:var(--fd);font-size:17px;font-weight:700;display:flex;align-items:center;gap:10px;margin-bottom:18px}
.od-card-t i{width:34px;height:34px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:14px}
.od-card-t .ic-blue{background:rgba(57,101,255,.1);color:#3965FF}
.od-card-t .ic-green{background:rgba(43,172,98,.1);color:#12B76A}
.od-card-t .ic-purple{background:rgba(122,90,248,.1);color:#7A5AF8}
.od-card-t .ic-orange{background:rgba(245,165,36,.1);color:#D48806}

/* ── Status timeline ── */
.od-tl{display:flex;align-items:flex-start;gap:0;margin:0 0 8px;padding:8px 0}
.od-tl-step{display:flex;flex-direction:column;align-items:center;flex:1;position:relative}
.od-tl-dot{width:32px;height:32px;border-radius:50%;border:2.5px solid var(--admin-border);background:var(--admin-card);display:flex;align-items:center;justify-content:center;font-size:13px;color:var(--admin-text-light);position:relative;z-index:2;transition:all .3s}
.od-tl-step.done .od-tl-dot{background:#12B76A;border-color:#12B76A;color:#fff}
.od-tl-step.active .od-tl-dot{background:var(--admin-primary);border-color:var(--admin-primary);color:#fff;box-shadow:0 0 0 4px rgba(57,101,255,.18)}
.od-tl-step.cancelled .od-tl-dot{background:#F04438;border-color:#F04438;color:#fff}
.od-tl-label{font-size:11.5px;font-weight:600;color:var(--admin-text-light);margin-top:8px;text-align:center;white-space:nowrap}
.od-tl-step.done .od-tl-label,.od-tl-step.active .od-tl-label{color:var(--admin-text)}
.od-tl-line{flex:1;height:3px;background:var(--admin-border);margin-top:15px;border-radius:2px;min-width:20px}
.od-tl-line.done{background:#12B76A}

/* ── Product table ── */
.od-items{width:100%;border-collapse:separate;border-spacing:0}
.od-items th{font-size:11.5px;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:var(--admin-text-light);padding:10px 14px;border-bottom:1px solid var(--admin-border);text-align:left}
.od-items td{padding:14px;font-size:14px;border-bottom:1px solid rgba(255,255,255,.04)}
.od-items tr:last-child td{border-bottom:none}
.od-items .p-name{font-weight:600;color:var(--admin-text)}
.od-items .p-price{font-weight:700;color:var(--admin-primary)}
.od-items tfoot td{border-top:2px solid var(--admin-border);font-size:15px;padding-top:16px}

/* ── Info rows ── */
.od-info{display:flex;flex-direction:column;gap:14px}
.od-info-row{display:flex;align-items:flex-start;gap:12px}
.od-info-ic{width:36px;height:36px;border-radius:10px;background:rgba(255,255,255,.05);display:flex;align-items:center;justify-content:center;font-size:14px;color:var(--admin-text-light);flex-shrink:0}
.od-info-body{flex:1}
.od-info-label{font-size:11.5px;font-weight:600;text-transform:uppercase;letter-spacing:.4px;color:var(--admin-text-light);margin-bottom:2px}
.od-info-val{font-size:14.5px;font-weight:600;color:var(--admin-text)}

/* ── Status form ── */
.od-status-form select{width:100%;padding:12px 14px;border-radius:10px;border:1px solid var(--admin-border);background:var(--admin-bg);color:var(--admin-text);font-size:14px;font-weight:600;margin-bottom:14px;cursor:pointer;appearance:auto}
.od-status-form .btn-update{width:100%;padding:13px;border:none;border-radius:12px;background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;font-size:14px;font-weight:700;cursor:pointer;transition:transform .15s,box-shadow .15s;display:flex;align-items:center;justify-content:center;gap:8px}
.od-status-form .btn-update:hover{transform:translateY(-1px);box-shadow:0 6px 20px -6px rgba(57,101,255,.45)}
.od-status-form .btn-update i{font-size:13px}

/* ── Alert ── */
.od-alert{padding:12px 16px;border-radius:10px;font-size:13.5px;font-weight:600;display:flex;align-items:center;gap:8px;margin-bottom:16px}
.od-alert-ok{background:rgba(43,172,98,.1);color:#12B76A}

/* ── Total highlight ── */
.od-total{display:flex;align-items:center;justify-content:space-between;padding:18px 20px;border-radius:14px;background:linear-gradient(135deg,rgba(57,101,255,.08),rgba(122,90,248,.08));margin-top:18px}
.od-total-label{font-size:14px;font-weight:600;color:var(--admin-text-light)}
.od-total-val{font-size:22px;font-weight:800;color:var(--admin-primary);font-family:var(--fd)}

/* ── Status pill ── */
.od-pill{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;border-radius:99px;font-size:12px;font-weight:700}
.od-pill-PENDING{background:rgba(245,165,36,.1);color:#D48806}
.od-pill-CONFIRMED{background:rgba(57,101,255,.1);color:#3965FF}
.od-pill-SHIPPING{background:rgba(122,90,248,.1);color:#7A5AF8}
.od-pill-DONE{background:rgba(43,172,98,.1);color:#12B76A}
.od-pill-CANCELLED{background:rgba(240,68,56,.1);color:#F04438}
.od-pill-PENDING_CANCEL{background:rgba(234,179,8,.12);color:#B45309}

.od-cancel-reason{padding:16px 18px;border-radius:12px;margin-bottom:18px;border:1px solid}
.od-cancel-reason.warn{background:rgba(234,179,8,.06);border-color:rgba(234,179,8,.2)}
.od-cancel-reason.red{background:rgba(240,68,56,.06);border-color:rgba(240,68,56,.15)}
.od-cancel-reason-label{font-size:11.5px;font-weight:700;text-transform:uppercase;letter-spacing:.4px;margin-bottom:4px}
.od-cancel-reason-val{font-size:14px;font-weight:600}
.od-approve-actions{display:flex;gap:10px;margin-top:14px}
.od-approve-actions button{flex:1;padding:12px;border:none;border-radius:12px;font-size:13.5px;font-weight:700;cursor:pointer;transition:all .15s}
.btn-approve{background:linear-gradient(135deg,#12B76A,#0E9F5A);color:#fff}
.btn-approve:hover{transform:translateY(-1px);box-shadow:0 6px 18px -6px rgba(18,183,106,.4)}
.btn-reject{background:rgba(255,255,255,.08);color:var(--admin-text-light);border:1px solid var(--admin-border)!important}
.btn-reject:hover{background:rgba(255,255,255,.12)}

@media(max-width:860px){
  .od-grid{grid-template-columns:1fr}
}
</style>

<a href="${pageContext.request.contextPath}/admin/don-hang" class="od-back">
    <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
    Quay lại danh sách
</a>

<div style="display:flex;align-items:center;gap:14px;margin-bottom:24px;flex-wrap:wrap">
    <h2 style="font-family:var(--fd);font-size:22px;font-weight:800;margin:0">Đơn hàng #${order.orderId}</h2>
    <span class="od-pill od-pill-${order.status}">
        <i class="fa-solid ${order.status == 'PENDING' ? 'fa-clock' : order.status == 'CONFIRMED' ? 'fa-circle-check' : order.status == 'SHIPPING' ? 'fa-truck-fast' : order.status == 'DONE' ? 'fa-check-double' : order.status == 'PENDING_CANCEL' ? 'fa-hourglass-half' : 'fa-ban'}"></i>
        <c:choose>
            <c:when test="${order.status == 'PENDING'}">Chờ xử lý</c:when>
            <c:when test="${order.status == 'CONFIRMED'}">Đã xác nhận</c:when>
            <c:when test="${order.status == 'SHIPPING'}">Đang giao hàng</c:when>
            <c:when test="${order.status == 'DONE'}">Hoàn thành</c:when>
            <c:when test="${order.status == 'CANCELLED'}">Đã huỷ</c:when>
            <c:when test="${order.status == 'PENDING_CANCEL'}">Chờ duyệt hủy</c:when>
        </c:choose>
    </span>
    <span style="font-size:13px;color:var(--admin-text-light);margin-left:auto">
        <i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
    </span>
</div>

<!-- Timeline trạng thái -->
<c:if test="${order.status != 'CANCELLED' && order.status != 'PENDING_CANCEL'}">
<div class="od-card" style="margin-bottom:22px">
    <div class="od-tl">
        <div class="od-tl-step done">
            <div class="od-tl-dot"><i class="fa-solid fa-file-lines" style="font-size:12px"></i></div>
            <div class="od-tl-label">Đơn mới</div>
        </div>
        <div class="od-tl-line done"></div>

        <c:set var="cDone" value="${order.status == 'CONFIRMED' || order.status == 'SHIPPING' || order.status == 'DONE'}"/>
        <div class="od-tl-step ${cDone ? (order.status == 'CONFIRMED' ? 'active' : 'done') : ''}">
            <div class="od-tl-dot"><i class="fa-solid fa-circle-check" style="font-size:12px"></i></div>
            <div class="od-tl-label">Xác nhận</div>
        </div>
        <div class="od-tl-line ${order.status == 'SHIPPING' || order.status == 'DONE' ? 'done' : ''}"></div>

        <div class="od-tl-step ${order.status == 'SHIPPING' ? 'active' : (order.status == 'DONE' ? 'done' : '')}">
            <div class="od-tl-dot"><i class="fa-solid fa-truck-fast" style="font-size:11px"></i></div>
            <div class="od-tl-label">Đang giao</div>
        </div>
        <div class="od-tl-line ${order.status == 'DONE' ? 'done' : ''}"></div>

        <div class="od-tl-step ${order.status == 'DONE' ? 'done' : ''}">
            <div class="od-tl-dot"><i class="fa-solid fa-check-double" style="font-size:11px"></i></div>
            <div class="od-tl-label">Hoàn thành</div>
        </div>
    </div>
</div>
</c:if>

<c:if test="${order.status == 'CANCELLED'}">
<div class="od-card" style="margin-bottom:22px">
    <div class="od-tl">
        <div class="od-tl-step done">
            <div class="od-tl-dot"><i class="fa-solid fa-file-lines" style="font-size:12px"></i></div>
            <div class="od-tl-label">Đơn mới</div>
        </div>
        <div class="od-tl-line" style="background:#F04438"></div>
        <div class="od-tl-step cancelled">
            <div class="od-tl-dot"><i class="fa-solid fa-ban" style="font-size:12px"></i></div>
            <div class="od-tl-label">Đã huỷ</div>
        </div>
    </div>
</div>
</c:if>
<c:if test="${order.status == 'PENDING_CANCEL'}">
<div class="od-card" style="margin-bottom:22px">
    <div class="od-tl">
        <div class="od-tl-step done">
            <div class="od-tl-dot"><i class="fa-solid fa-file-lines" style="font-size:12px"></i></div>
            <div class="od-tl-label">Đơn mới</div>
        </div>
        <div class="od-tl-line" style="background:#EAB308"></div>
        <div class="od-tl-step active">
            <div class="od-tl-dot" style="background:#EAB308;border-color:#EAB308"><i class="fa-solid fa-hourglass-half" style="font-size:11px"></i></div>
            <div class="od-tl-label">Chờ duyệt hủy</div>
        </div>
    </div>
</div>
</c:if>

<div class="od-grid">
    <!-- Cột trái -->
    <div>
        <!-- Sản phẩm -->
        <div class="od-card">
            <div class="od-card-t">
                <i class="fa-solid fa-box ic-blue"></i>
                Sản phẩm đã đặt
            </div>
            <table class="od-items">
                <thead>
                    <tr>
                        <th style="width:45%">Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>SL</th>
                        <th style="text-align:right">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.items}">
                    <tr>
                        <td class="p-name"><c:out value="${item.productName}"/></td>
                        <td><fmt:formatNumber value="${item.priceAtTime}" type="number" maxFractionDigits="0"/>đ</td>
                        <td>x${item.quantity}</td>
                        <td class="p-price" style="text-align:right"><fmt:formatNumber value="${item.priceAtTime * item.quantity}" type="number" maxFractionDigits="0"/>đ</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="od-total">
                <span class="od-total-label"><i class="fa-solid fa-receipt" style="margin-right:6px"></i>Tổng cộng</span>
                <span class="od-total-val"><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/>đ</span>
            </div>
        </div>

        <!-- Thông tin khách hàng -->
        <div class="od-card">
            <div class="od-card-t">
                <i class="fa-solid fa-user-circle ic-blue"></i>
                Thông tin khách hàng
            </div>
            <div class="od-info">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-user"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Người đặt hàng</div>
                        <div class="od-info-val"><c:out value="${order.fullName}"/></div>
                    </div>
                </div>
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-phone"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Số điện thoại</div>
                        <div class="od-info-val"><c:out value="${order.phone}"/></div>
                    </div>
                </div>
                <c:if test="${not empty customer}">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-envelope"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Email</div>
                        <div class="od-info-val"><c:out value="${customer.email}"/></div>
                    </div>
                </div>
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-calendar-plus"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Ngày tạo tài khoản</div>
                        <div class="od-info-val"><fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>
                <c:if test="${not empty customer.lastLoginIP}">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-network-wired"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Đăng nhập gần nhất</div>
                        <div class="od-info-val"><c:out value="${customer.lastLoginIP}"/> — <fmt:formatDate value="${customer.lastLoginAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>
                </c:if>
                </c:if>
            </div>
        </div>

        <!-- Thông tin giao hàng -->
        <div class="od-card">
            <div class="od-card-t">
                <i class="fa-solid fa-location-dot ic-green"></i>
                Thông tin giao hàng
            </div>
            <div class="od-info">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-map-pin"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Địa chỉ</div>
                        <div class="od-info-val"><c:out value="${order.address}"/></div>
                    </div>
                </div>
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-credit-card"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Phương thức thanh toán</div>
                        <div class="od-info-val">${order.paymentMethod == 'COD' ? 'Thanh toán khi nhận hàng' : 'Chuyển khoản ngân hàng'}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cột phải -->
    <div>
        <!-- Cập nhật trạng thái -->
        <div class="od-card">
            <div class="od-card-t">
                <i class="fa-solid fa-arrows-rotate ic-purple"></i>
                Cập nhật trạng thái
            </div>

            <c:if test="${not empty param.success}">
                <div class="od-alert od-alert-ok">
                    <i class="fa-solid fa-circle-check"></i> Cập nhật trạng thái thành công!
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="od-alert" style="background:rgba(240,68,56,.1);color:#F04438">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <c:choose>
                        <c:when test="${param.error == 'backward'}">Không thể quay lại trạng thái trước đó!</c:when>
                        <c:when test="${param.error == 'final'}">Đơn hàng đã kết thúc, không thể thay đổi.</c:when>
                        <c:when test="${param.error == 'nocancel'}">Đơn đang giao không thể huỷ.</c:when>
                        <c:when test="${param.error == 'system'}">Có lỗi hệ thống, vui lòng thử lại.</c:when>
                        <c:otherwise>Có lỗi xảy ra.</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty order.cancelReason}">
                <div class="od-cancel-reason ${order.status == 'PENDING_CANCEL' ? 'warn' : 'red'}">
                    <div class="od-cancel-reason-label" style="color:${order.status == 'PENDING_CANCEL' ? '#B45309' : '#F04438'}">
                        <i class="fa-solid fa-comment-dots" style="margin-right:4px"></i>Lý do hủy từ khách hàng
                    </div>
                    <div class="od-cancel-reason-val" style="color:var(--admin-text)"><c:out value="${order.cancelReason}"/></div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${order.status == 'DONE'}">
                    <div class="od-alert od-alert-ok"><i class="fa-solid fa-circle-check"></i> Đơn hàng đã hoàn thành.</div>
                </c:when>
                <c:when test="${order.status == 'CANCELLED'}">
                    <div class="od-alert" style="background:rgba(240,68,56,.1);color:#F04438"><i class="fa-solid fa-ban"></i> Đơn hàng đã bị huỷ.</div>
                </c:when>
                <c:when test="${order.status == 'PENDING_CANCEL'}">
                    <div class="od-alert" style="background:rgba(234,179,8,.08);color:#B45309">
                        <i class="fa-solid fa-hourglass-half"></i> Khách hàng yêu cầu hủy đơn. Vui lòng duyệt hoặc từ chối.
                    </div>
                    <div class="od-approve-actions">
                        <form action="${pageContext.request.contextPath}/admin/don-hang/duyet-huy" method="POST" style="flex:1;display:flex">
                            <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn-approve" style="width:100%">
                                <i class="fa-solid fa-check" style="margin-right:5px"></i>Duyệt hủy + Hoàn tiền
                            </button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/don-hang/duyet-huy" method="POST" style="flex:1;display:flex">
                            <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn-reject" style="width:100%">
                                <i class="fa-solid fa-xmark" style="margin-right:5px"></i>Từ chối hủy
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/admin/don-hang/cap-nhat" method="POST" class="od-status-form">
                        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <select name="status">
                            <c:if test="${order.status == 'PENDING'}">
                                <option value="PENDING" selected>&#xf017; Chờ xử lý (PENDING)</option>
                                <option value="CONFIRMED">&#xf058; Đã xác nhận (CONFIRMED)</option>
                                <option value="SHIPPING">&#xf0d1; Đang giao hàng (SHIPPING)</option>
                                <option value="DONE">&#xf560; Hoàn thành (DONE)</option>
                                <option value="CANCELLED">&#xf05e; Đã huỷ (CANCELLED)</option>
                            </c:if>
                            <c:if test="${order.status == 'CONFIRMED'}">
                                <option value="CONFIRMED" selected>&#xf058; Đã xác nhận (CONFIRMED)</option>
                                <option value="SHIPPING">&#xf0d1; Đang giao hàng (SHIPPING)</option>
                                <option value="DONE">&#xf560; Hoàn thành (DONE)</option>
                                <option value="CANCELLED">&#xf05e; Đã huỷ (CANCELLED)</option>
                            </c:if>
                            <c:if test="${order.status == 'SHIPPING'}">
                                <option value="SHIPPING" selected>&#xf0d1; Đang giao hàng (SHIPPING)</option>
                                <option value="DONE">&#xf560; Hoàn thành (DONE)</option>
                            </c:if>
                        </select>
                        <button type="submit" class="btn-update">
                            <i class="fa-solid fa-arrow-rotate-right"></i>
                            Cập nhật trạng thái
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Mã đơn & thời gian -->
        <div class="od-card">
            <div class="od-card-t">
                <i class="fa-solid fa-circle-info ic-orange"></i>
                Thông tin đơn hàng
            </div>
            <div class="od-info">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-hashtag"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Mã đơn hàng</div>
                        <div class="od-info-val">#${order.orderId}</div>
                    </div>
                </div>
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-regular fa-calendar"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Ngày đặt hàng</div>
                        <div class="od-info-val"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>
                <c:if test="${not empty order.couponCode}">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-ticket"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Mã giảm giá</div>
                        <div class="od-info-val"><c:out value="${order.couponCode}"/></div>
                    </div>
                </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Shipper Assignment Prompt Modal -->
<div class="modal-overlay" id="shipperPrompt" style="position:fixed;inset:0;z-index:200;background:rgba(14,46,92,.55);backdrop-filter:blur(4px);display:none;align-items:center;justify-content:center;padding:18px">
  <div style="background:var(--admin-surface);border-radius:20px;width:100%;max-width:460px;box-shadow:0 30px 70px -16px rgba(14,46,92,.4);animation:spIn .35s ease;overflow:hidden">
    <div style="background:linear-gradient(135deg,var(--admin-sidebar),var(--admin-sidebar-2));padding:28px 24px;text-align:center;color:#fff">
      <div style="width:64px;height:64px;border-radius:50%;background:rgba(255,255,255,.15);display:flex;align-items:center;justify-content:center;margin:0 auto 14px;font-size:28px">
        <i class="fa-solid fa-truck-fast"></i>
      </div>
      <div style="font-family:var(--fd);font-size:20px;font-weight:700">Gán shipper giao hàng?</div>
      <p style="font-size:13px;color:rgba(255,255,255,.7);margin-top:6px">Đơn #${order.orderId} đã chuyển sang trạng thái <strong>Đang giao</strong></p>
    </div>
    <div style="padding:24px;text-align:center">
      <p style="font-size:14px;color:var(--admin-text);margin-bottom:20px;line-height:1.6">
        Bạn có muốn chuyển đến trang <strong>Điều phối</strong> để gán shipper cho đơn này ngay không?
      </p>
      <div style="display:flex;gap:10px">
        <button onclick="dismissShipperPrompt()" style="flex:1;padding:13px;border-radius:12px;border:1.5px solid var(--admin-border);background:var(--admin-bg);color:var(--admin-text);font-weight:700;font-size:14px;cursor:pointer;transition:background .2s">
          Để sau
        </button>
        <a href="${pageContext.request.contextPath}/admin/dieu-phoi" style="flex:1;padding:13px;border-radius:12px;background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;font-weight:700;font-size:14px;text-decoration:none;text-align:center;display:flex;align-items:center;justify-content:center;gap:6px;box-shadow:0 8px 20px -6px rgba(57,101,255,.5);transition:transform .15s">
          <i class="fa-solid fa-arrow-right"></i> Gán shipper ngay
        </a>
      </div>
    </div>
  </div>
</div>
<style>
@keyframes spIn{from{opacity:0;transform:translateY(24px) scale(.94)}to{opacity:1;transform:none}}

/* Unassigned reminder banner */
.ship-reminder{padding:14px 20px;border-radius:14px;background:linear-gradient(135deg,rgba(245,165,36,.08),rgba(238,93,80,.06));border:1.5px solid rgba(245,165,36,.2);margin-bottom:20px;display:flex;align-items:center;gap:12px;animation:remPulse 2s ease infinite}
@keyframes remPulse{0%,100%{box-shadow:0 0 0 0 rgba(245,165,36,0)}50%{box-shadow:0 0 0 6px rgba(245,165,36,.1)}}
.ship-reminder i{font-size:20px;color:var(--status-pending)}
.ship-reminder-text{flex:1;font-size:13.5px;font-weight:600;color:var(--admin-text)}
.ship-reminder-text strong{color:var(--admin-red)}
.ship-reminder a{padding:8px 16px;border-radius:10px;background:var(--admin-primary);color:#fff;font-weight:700;font-size:12.5px;text-decoration:none;white-space:nowrap;display:inline-flex;align-items:center;gap:5px}
</style>

<script>
(function(){
  var orderId = ${order.orderId};
  var status = '${order.status}';
  var hasShipper = ${order.shipperId != null};

  // Show prompt if just changed to SHIPPING (success=true in URL + status=SHIPPING)
  var params = new URLSearchParams(location.search);
  if(params.get('success') === 'true' && status === 'SHIPPING' && !hasShipper){
    setTimeout(function(){
      document.getElementById('shipperPrompt').style.display = 'flex';
    }, 600);
  }

  // 30-minute reminder for unassigned SHIPPING orders
  if(status === 'SHIPPING' && !hasShipper){
    var storageKey = 'shipReminder_' + orderId;
    var lastRemind = parseInt(localStorage.getItem(storageKey) || '0');
    var now = Date.now();
    var thirtyMin = 30 * 60 * 1000;

    function showReminder(){
      var existing = document.querySelector('.ship-reminder');
      if(existing) return;
      var ctx = document.querySelector('meta[name="ctx"]').content;
      var div = document.createElement('div');
      div.className = 'ship-reminder';
      div.innerHTML = '<i class="fa-solid fa-exclamation-triangle"></i>' +
        '<div class="ship-reminder-text"><strong>Đơn #'+orderId+'</strong> đang giao nhưng chưa được gán shipper. Vui lòng gán shipper để tránh ảnh hưởng trải nghiệm khách hàng.</div>' +
        '<a href="'+ctx+'/admin/dieu-phoi"><i class="fa-solid fa-truck-fast"></i> Gán ngay</a>';
      var header = document.querySelector('.admin-header');
      if(header && header.nextSibling) header.parentNode.insertBefore(div, header.nextSibling);
      localStorage.setItem(storageKey, String(Date.now()));
    }

    if(now - lastRemind >= thirtyMin){
      showReminder();
    }
    setInterval(function(){
      showReminder();
    }, thirtyMin);
  }
})();

function dismissShipperPrompt(){
  document.getElementById('shipperPrompt').style.display = 'none';
}
document.getElementById('shipperPrompt').addEventListener('click',function(e){
  if(e.target===this) dismissShipperPrompt();
});
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
