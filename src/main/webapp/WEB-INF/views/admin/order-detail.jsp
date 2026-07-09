<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        <i class="fa-solid ${order.status == 'PENDING' ? 'fa-clock' : order.status == 'CONFIRMED' ? 'fa-circle-check' : order.status == 'SHIPPING' ? 'fa-truck-fast' : order.status == 'DONE' ? 'fa-check-double' : 'fa-ban'}"></i>
        <c:choose>
            <c:when test="${order.status == 'PENDING'}">Chờ xử lý</c:when>
            <c:when test="${order.status == 'CONFIRMED'}">Đã xác nhận</c:when>
            <c:when test="${order.status == 'SHIPPING'}">Đang giao hàng</c:when>
            <c:when test="${order.status == 'DONE'}">Hoàn thành</c:when>
            <c:when test="${order.status == 'CANCELLED'}">Đã huỷ</c:when>
        </c:choose>
    </span>
    <span style="font-size:13px;color:var(--admin-text-light);margin-left:auto">
        <i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
    </span>
</div>

<!-- Timeline trạng thái -->
<c:if test="${order.status != 'CANCELLED'}">
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
                        <td class="p-name">${item.productName}</td>
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
                        <div class="od-info-val">${order.fullName}</div>
                    </div>
                </div>
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-phone"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Số điện thoại</div>
                        <div class="od-info-val">${order.phone}</div>
                    </div>
                </div>
                <c:if test="${not empty customer}">
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-envelope"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Email</div>
                        <div class="od-info-val">${customer.email}</div>
                    </div>
                </div>
                <div class="od-info-row">
                    <div class="od-info-ic"><i class="fa-solid fa-calendar-plus"></i></div>
                    <div class="od-info-body">
                        <div class="od-info-label">Ngày tạo tài khoản</div>
                        <div class="od-info-val"><fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>
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
                        <div class="od-info-val">${order.address}</div>
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
                        <c:otherwise>Có lỗi xảy ra.</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${order.status == 'DONE'}">
                    <div class="od-alert od-alert-ok"><i class="fa-solid fa-circle-check"></i> Đơn hàng đã hoàn thành.</div>
                </c:when>
                <c:when test="${order.status == 'CANCELLED'}">
                    <div class="od-alert" style="background:rgba(240,68,56,.1);color:#F04438"><i class="fa-solid fa-ban"></i> Đơn hàng đã bị huỷ.</div>
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
                        <div class="od-info-val">${order.couponCode}</div>
                    </div>
                </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
