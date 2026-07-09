<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
/* ═══════════ Stats ═══════════ */
.ol-stats{display:flex;gap:14px;margin-bottom:22px;flex-wrap:wrap}
.ol-stat{flex:1;min-width:140px;padding:18px 20px;border-radius:14px;background:var(--admin-surface);border:1.5px solid var(--admin-border);transition:transform .25s,box-shadow .25s,border-color .2s;cursor:pointer;user-select:none}
.ol-stat:hover{transform:translateY(-3px);box-shadow:0 12px 28px -10px rgba(0,0,0,.1)}
.ol-stat.active{border-color:var(--admin-primary);box-shadow:0 8px 24px -8px rgba(57,101,255,.25);transform:translateY(-2px)}
.ol-stat.active::after{content:'✓';position:absolute;top:10px;right:14px;font-size:14px;font-weight:800;color:var(--admin-primary)}
.ol-stat{position:relative}
.ol-stat-val{font-family:var(--fd);font-size:24px;font-weight:800;margin-bottom:2px}
.ol-stat-label{font-size:12px;font-weight:600;color:var(--admin-text-light);text-transform:uppercase;letter-spacing:.4px}
.v-blue{color:#3965FF}.v-orange{color:#D48806}.v-purple{color:#7A5AF8}.v-green{color:#12B76A}

/* ═══════════ Customer Cards Grid ═══════════ */
.cg-title{font-family:var(--fd);font-size:18px;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:10px}
.cg-title i{font-size:15px;color:var(--admin-primary);opacity:.6}
.cg-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-bottom:30px}

.cg-card{
    background:var(--admin-surface);border:1.5px solid var(--admin-border);border-radius:20px;
    padding:24px 22px;cursor:pointer;position:relative;overflow:hidden;
    transition:transform .35s cubic-bezier(.4,0,.2,1),box-shadow .35s,border-color .3s;
    transform-style:preserve-3d;
}
.cg-card::before{
    content:'';position:absolute;inset:0;border-radius:inherit;
    background:linear-gradient(135deg,rgba(57,101,255,.04),rgba(122,90,248,.03));
    opacity:0;transition:opacity .3s;pointer-events:none;
}
.cg-card:hover{
    transform:translateY(-6px) rotateX(2deg);
    box-shadow:0 20px 44px -14px rgba(14,46,92,.16);
    border-color:rgba(57,101,255,.22);z-index:5;
}
.cg-card:hover::before{opacity:1}
.cg-card:hover .cg-avatar{transform:scale(1.1) rotateY(12deg);box-shadow:0 8px 20px -6px rgba(57,101,255,.35)}

.cg-top{display:flex;align-items:center;gap:14px;margin-bottom:16px}
.cg-avatar{
    width:52px;height:52px;border-radius:16px;flex-shrink:0;
    background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;
    display:flex;align-items:center;justify-content:center;
    font-size:20px;font-weight:800;font-family:var(--fd);
    transition:transform .4s cubic-bezier(.4,0,.2,1),box-shadow .3s;
    transform-style:preserve-3d;
}
.cg-name{font-size:16px;font-weight:700;color:var(--admin-text);line-height:1.3}
.cg-phone{font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-top:2px}

.cg-stats{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px}
.cg-stat-chip{
    display:inline-flex;align-items:center;gap:4px;
    padding:4px 10px;border-radius:8px;font-size:11.5px;font-weight:700;
}
.cg-stat-chip.pending{background:rgba(245,165,36,.1);color:#D48806}
.cg-stat-chip.shipping{background:rgba(122,90,248,.1);color:#7A5AF8}
.cg-stat-chip.done{background:rgba(43,172,98,.1);color:#12B76A}

.cg-meta{display:flex;align-items:center;justify-content:space-between;padding-top:12px;border-top:1px solid rgba(224,229,242,.6)}
.cg-total{font-size:12px;color:var(--admin-text-light);font-weight:600}
.cg-total b{color:var(--admin-primary);font-size:14px}
.cg-arrow{width:28px;height:28px;border-radius:8px;background:rgba(57,101,255,.08);display:flex;align-items:center;justify-content:center;transition:background .2s,transform .2s}
.cg-card:hover .cg-arrow{background:rgba(57,101,255,.16);transform:translateX(2px)}
.cg-arrow i{font-size:12px;color:var(--admin-primary)}

/* ═══════════ Customer Detail Overlay ═══════════ */
.cd-overlay{
    display:none;position:fixed;inset:0;z-index:9000;
    background:rgba(14,46,92,.5);backdrop-filter:blur(6px);
    align-items:center;justify-content:center;
}
.cd-overlay.open{display:flex}
.cd-panel{
    background:var(--admin-surface);border-radius:22px;
    width:94%;max-width:860px;max-height:88vh;overflow:hidden;
    box-shadow:0 32px 80px -16px rgba(14,46,92,.35);
    animation:cdSlide .3s cubic-bezier(.4,0,.2,1);
    display:flex;flex-direction:column;
}
@keyframes cdSlide{from{opacity:0;transform:translateY(30px) scale(.96)}to{opacity:1;transform:none}}

.cd-header{
    display:flex;align-items:center;gap:16px;padding:24px 28px 20px;
    border-bottom:1px solid var(--admin-border);flex-shrink:0;
}
.cd-hdr-avatar{
    width:56px;height:56px;border-radius:16px;flex-shrink:0;
    background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;
    display:flex;align-items:center;justify-content:center;
    font-size:22px;font-weight:800;font-family:var(--fd);
}
.cd-hdr-info{flex:1}
.cd-hdr-name{font-family:var(--fd);font-size:20px;font-weight:800;color:var(--admin-text)}
.cd-hdr-sub{font-size:13px;color:var(--admin-text-light);font-weight:500;margin-top:2px}
.cd-close{
    width:36px;height:36px;border-radius:10px;border:none;
    background:rgba(224,229,242,.5);color:var(--admin-text-light);
    font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;
    transition:background .2s,color .2s;
}
.cd-close:hover{background:rgba(240,68,56,.1);color:#F04438}

/* Tabs */
.cd-tabs{display:flex;gap:0;padding:0 28px;border-bottom:1px solid var(--admin-border);flex-shrink:0}
.cd-tab{
    padding:14px 20px;font-size:14px;font-weight:700;color:var(--admin-text-light);
    cursor:pointer;border-bottom:2.5px solid transparent;transition:color .2s,border-color .2s;
    display:flex;align-items:center;gap:7px;
}
.cd-tab:hover{color:var(--admin-text)}
.cd-tab.active{color:var(--admin-primary);border-bottom-color:var(--admin-primary)}
.cd-tab i{font-size:13px}
.cd-tab .tab-badge{
    background:rgba(57,101,255,.1);color:var(--admin-primary);
    font-size:11px;font-weight:800;padding:2px 8px;border-radius:6px;
}

.cd-body{flex:1;overflow-y:auto;padding:24px 28px 28px}

/* Tab content */
.cd-pane{display:none}
.cd-pane.active{display:block}

/* ── Customer info ── */
.ci-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.ci-item{
    display:flex;align-items:flex-start;gap:12px;
    padding:16px;border-radius:14px;background:var(--admin-bg);
}
.ci-ic{
    width:40px;height:40px;border-radius:12px;flex-shrink:0;
    display:flex;align-items:center;justify-content:center;font-size:15px;
}
.ci-ic.blue{background:rgba(57,101,255,.1);color:#3965FF}
.ci-ic.green{background:rgba(43,172,98,.1);color:#12B76A}
.ci-ic.orange{background:rgba(245,165,36,.1);color:#D48806}
.ci-ic.purple{background:rgba(122,90,248,.1);color:#7A5AF8}
.ci-label{font-size:11.5px;font-weight:600;text-transform:uppercase;letter-spacing:.4px;color:var(--admin-text-light);margin-bottom:3px}
.ci-val{font-size:14.5px;font-weight:700;color:var(--admin-text)}
.ci-full{grid-column:1/-1}

/* ── Orders table in overlay ── */
.co-table{width:100%;border-collapse:separate;border-spacing:0}
.co-table th{font-size:11.5px;font-weight:700;text-transform:uppercase;letter-spacing:.4px;color:var(--admin-text-light);padding:12px 14px;border-bottom:1.5px solid var(--admin-border);text-align:left}
.co-table td{padding:14px;font-size:14px;font-weight:500;border-bottom:1px solid rgba(224,229,242,.4)}
.co-table tr:last-child td{border-bottom:none}
.co-table tbody tr{transition:background .15s}
.co-table tbody tr:hover{background:#F8FAFF}

.os-pill{display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:99px;font-size:12px;font-weight:700;white-space:nowrap}
.os-pill i{font-size:10px}
.os-PENDING{background:rgba(245,165,36,.1);color:#D48806}
.os-CONFIRMED{background:rgba(57,101,255,.1);color:#3965FF}
.os-SHIPPING{background:rgba(122,90,248,.1);color:#7A5AF8}
.os-DONE{background:rgba(43,172,98,.1);color:#12B76A}
.os-CANCELLED{background:rgba(240,68,56,.1);color:#F04438}

.co-detail-btn{
    display:inline-flex;align-items:center;gap:5px;padding:7px 12px;border-radius:8px;
    background:rgba(57,101,255,.08);color:var(--admin-primary);font-size:12.5px;font-weight:700;
    text-decoration:none;transition:background .2s;
}
.co-detail-btn:hover{background:rgba(57,101,255,.18)}

/* ── Status update form inline ── */
.co-status-form{display:inline-flex;align-items:center;gap:6px}
.co-status-form select{
    padding:6px 10px;border-radius:8px;border:1.5px solid var(--admin-border);
    background:var(--admin-bg);color:var(--admin-text);font-size:12.5px;font-weight:600;
    cursor:pointer;appearance:auto;
}
.co-status-form .btn-sm{
    padding:6px 12px;border:none;border-radius:8px;
    background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;
    font-size:12px;font-weight:700;cursor:pointer;transition:transform .15s,box-shadow .15s;
}
.co-status-form .btn-sm:hover{transform:translateY(-1px);box-shadow:0 4px 12px -4px rgba(57,101,255,.4)}

/* ═══════════ Responsive ═══════════ */
@media(max-width:1100px){.cg-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:700px){
    .cg-grid{grid-template-columns:1fr}
    .cd-panel{width:98%;max-height:94vh;border-radius:16px}
    .ci-grid{grid-template-columns:1fr}
    .cd-header{padding:18px 20px 16px}.cd-tabs{padding:0 20px}.cd-body{padding:18px 20px 24px}
}
</style>

<%-- ═══════════ Group orders by UserId ═══════════ --%>
<c:set var="cntAll" value="${orders.size()}"/>
<c:set var="cntPending" value="0"/><c:set var="cntShipping" value="0"/><c:set var="cntDone" value="0"/>
<c:forEach var="o" items="${orders}">
    <c:if test="${o.status == 'PENDING' || o.status == 'CONFIRMED'}"><c:set var="cntPending" value="${cntPending + 1}"/></c:if>
    <c:if test="${o.status == 'SHIPPING'}"><c:set var="cntShipping" value="${cntShipping + 1}"/></c:if>
    <c:if test="${o.status == 'DONE'}"><c:set var="cntDone" value="${cntDone + 1}"/></c:if>
</c:forEach>

<!-- Stats bar -->
<div class="ol-stats">
    <div class="ol-stat active" data-filter="ALL" onclick="filterByStatus(this)"><div class="ol-stat-val v-blue">${cntAll}</div><div class="ol-stat-label">Tổng đơn</div></div>
    <div class="ol-stat" data-filter="PENDING" onclick="filterByStatus(this)"><div class="ol-stat-val v-orange">${cntPending}</div><div class="ol-stat-label">Chờ xử lý</div></div>
    <div class="ol-stat" data-filter="SHIPPING" onclick="filterByStatus(this)"><div class="ol-stat-val v-purple">${cntShipping}</div><div class="ol-stat-label">Đang giao</div></div>
    <div class="ol-stat" data-filter="DONE" onclick="filterByStatus(this)"><div class="ol-stat-val v-green">${cntDone}</div><div class="ol-stat-label">Hoàn thành</div></div>
</div>

<c:choose>
<c:when test="${empty orders}">
    <div class="card" style="text-align:center;padding:60px 20px;color:var(--admin-text-light)">
        <i class="fa-solid fa-inbox" style="font-size:40px;opacity:.3;margin-bottom:14px;display:block"></i>
        <p style="font-size:15px;font-weight:600">Chưa có đơn hàng nào</p>
    </div>
</c:when>
<c:otherwise>

<%-- Build customer map using JS (JSTL can't do maps by userId easily) --%>
<div class="cg-title"><i class="fa-solid fa-users"></i> Khách hàng</div>
<div class="cg-grid" id="customerGrid"></div>

<%-- Filtered orders list --%>
<div id="filteredSection" style="display:none;margin-bottom:30px">
    <div class="cg-title" style="margin-bottom:14px"><i class="fa-solid fa-filter"></i> <span id="filterTitle">Đơn hàng</span></div>
    <div class="card" style="padding:0;overflow:hidden">
        <div class="table-responsive">
            <table class="co-table" style="margin:0">
                <thead><tr><th>Mã</th><th>Khách hàng</th><th>Tổng tiền</th><th>Thanh toán</th><th>Trạng thái</th><th>Ngày đặt</th><th></th></tr></thead>
                <tbody id="filteredBody"></tbody>
            </table>
        </div>
    </div>
</div>

<%-- Hidden data for JS to build cards --%>
<div id="ordersData" style="display:none">
    <c:forEach var="o" items="${orders}">
    <div class="order-data"
         data-oid="${o.orderId}"
         data-uid="${o.userId}"
         data-name="${fn:escapeXml(o.fullName)}"
         data-phone="${fn:escapeXml(o.phone)}"
         data-address="${fn:escapeXml(o.address)}"
         data-total="${o.totalAmount}"
         data-pay="${o.paymentMethod}"
         data-status="${o.status}"
         data-coupon="${fn:escapeXml(o.couponCode)}"
         data-date="<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>">
    </div>
    </c:forEach>
</div>

<%-- Customer Detail Overlay --%>
<div class="cd-overlay" id="cdOverlay">
    <div class="cd-panel">
        <div class="cd-header">
            <div class="cd-hdr-avatar" id="cdAvatar"></div>
            <div class="cd-hdr-info">
                <div class="cd-hdr-name" id="cdName"></div>
                <div class="cd-hdr-sub" id="cdSub"></div>
            </div>
            <button class="cd-close" onclick="closeCdOverlay()">&times;</button>
        </div>
        <div class="cd-tabs">
            <div class="cd-tab active" data-tab="info" onclick="switchCdTab(this)">
                <i class="fa-solid fa-user"></i> Thông tin khách hàng
            </div>
            <div class="cd-tab" data-tab="orders" onclick="switchCdTab(this)">
                <i class="fa-solid fa-boxes-stacked"></i> Đơn hàng <span class="tab-badge" id="cdOrderCount">0</span>
            </div>
        </div>
        <div class="cd-body">
            <div class="cd-pane active" id="paneInfo"></div>
            <div class="cd-pane" id="paneOrders"></div>
        </div>
    </div>
</div>

<script>
(function(){
    var ctx = document.querySelector('meta[name="ctx"]').content;
    var els = document.querySelectorAll('#ordersData .order-data');
    var customers = {};

    els.forEach(function(el){
        var d = el.dataset;
        var uid = d.uid;
        if(!customers[uid]){
            customers[uid] = {
                uid: uid, name: d.name, phone: d.phone,
                address: d.address, orders: []
            };
        }
        customers[uid].orders.push({
            oid: d.oid, total: parseFloat(d.total), pay: d.pay,
            status: d.status, coupon: d.coupon, date: d.date,
            address: d.address
        });
    });

    var grid = document.getElementById('customerGrid');
    var colors = ['#3965FF','#7A5AF8','#12B76A','#D48806','#CE2E2E','#E8950A'];
    var ci = 0;

    Object.keys(customers).forEach(function(uid){
        var c = customers[uid];
        var initial = c.name.charAt(0).toUpperCase();
        var color = colors[ci % colors.length]; ci++;

        var pending=0,shipping=0,done=0,cancelled=0,totalSum=0;
        c.orders.forEach(function(o){
            if(o.status==='PENDING'||o.status==='CONFIRMED') pending++;
            else if(o.status==='SHIPPING') shipping++;
            else if(o.status==='DONE') done++;
            else if(o.status==='CANCELLED') cancelled++;
            totalSum += o.total;
        });

        var card = document.createElement('div');
        card.className = 'cg-card';
        card.setAttribute('data-uid', uid);
        card.innerHTML =
            '<div class="cg-top">' +
                '<div class="cg-avatar" style="background:linear-gradient(135deg,'+color+','+color+'cc)">' + initial + '</div>' +
                '<div><div class="cg-name">' + c.name + '</div>' +
                '<div class="cg-phone"><i class="fa-solid fa-phone" style="font-size:10px;margin-right:4px;opacity:.5"></i>' + c.phone + '</div></div>' +
            '</div>' +
            '<div class="cg-stats">' +
                (pending ? '<span class="cg-stat-chip pending"><i class="fa-solid fa-clock" style="font-size:9px"></i> '+pending+' chờ</span>' : '') +
                (shipping ? '<span class="cg-stat-chip shipping"><i class="fa-solid fa-truck-fast" style="font-size:9px"></i> '+shipping+' giao</span>' : '') +
                (done ? '<span class="cg-stat-chip done"><i class="fa-solid fa-check" style="font-size:9px"></i> '+done+' xong</span>' : '') +
            '</div>' +
            '<div class="cg-meta">' +
                '<div class="cg-total">' + c.orders.length + ' đơn · Tổng <b>' + formatVND(totalSum) + '</b></div>' +
                '<div class="cg-arrow"><i class="fa-solid fa-chevron-right"></i></div>' +
            '</div>';

        card.onclick = function(){ openCustomer(uid); };
        grid.appendChild(card);
    });

    function formatVND(n){
        return n.toLocaleString('vi-VN').replace(/,/g,'.') + 'đ';
    }

    function statusLabel(s){
        var m = {PENDING:'Chờ xử lý',CONFIRMED:'Đã xác nhận',SHIPPING:'Đang giao',DONE:'Hoàn thành',CANCELLED:'Đã huỷ'};
        return m[s]||s;
    }
    function statusIcon(s){
        var m = {PENDING:'fa-clock',CONFIRMED:'fa-circle-check',SHIPPING:'fa-truck-fast',DONE:'fa-check-double',CANCELLED:'fa-ban'};
        return m[s]||'fa-circle';
    }

    var statusRank = {PENDING:0,CONFIRMED:1,SHIPPING:2,DONE:3,CANCELLED:99};
    function statusOptions(cur){
        var opts = [];
        if(cur==='DONE'||cur==='CANCELLED') return opts;
        if(cur==='PENDING'){
            opts.push({v:'PENDING',l:'Chờ xử lý'},{v:'CONFIRMED',l:'Đã xác nhận'},{v:'SHIPPING',l:'Đang giao'},{v:'DONE',l:'Hoàn thành'},{v:'CANCELLED',l:'Đã huỷ'});
        } else if(cur==='CONFIRMED'){
            opts.push({v:'CONFIRMED',l:'Đã xác nhận'},{v:'SHIPPING',l:'Đang giao'},{v:'DONE',l:'Hoàn thành'},{v:'CANCELLED',l:'Đã huỷ'});
        } else if(cur==='SHIPPING'){
            opts.push({v:'SHIPPING',l:'Đang giao'},{v:'DONE',l:'Hoàn thành'});
        }
        return opts;
    }

    window.openCustomer = function(uid){
        var c = customers[uid];
        if(!c) return;
        var initial = c.name.charAt(0).toUpperCase();
        document.getElementById('cdAvatar').textContent = initial;
        document.getElementById('cdName').textContent = c.name;
        document.getElementById('cdSub').innerHTML = '<i class="fa-solid fa-phone" style="font-size:11px;margin-right:4px;opacity:.5"></i>' + c.phone + '&nbsp;&nbsp;·&nbsp;&nbsp;<i class="fa-solid fa-boxes-stacked" style="font-size:11px;margin-right:4px;opacity:.5"></i>' + c.orders.length + ' đơn hàng';
        document.getElementById('cdOrderCount').textContent = c.orders.length;

        // Info pane
        var firstOrder = c.orders[c.orders.length - 1];
        var lastOrder = c.orders[0];
        var totalSpent = 0;
        c.orders.forEach(function(o){ totalSpent += o.total; });

        document.getElementById('paneInfo').innerHTML =
            '<div class="ci-grid">' +
                '<div class="ci-item"><div class="ci-ic blue"><i class="fa-solid fa-user"></i></div><div><div class="ci-label">Họ tên</div><div class="ci-val">' + c.name + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic green"><i class="fa-solid fa-phone"></i></div><div><div class="ci-label">Số điện thoại</div><div class="ci-val">' + c.phone + '</div></div></div>' +
                '<div class="ci-item ci-full"><div class="ci-ic orange"><i class="fa-solid fa-map-pin"></i></div><div><div class="ci-label">Địa chỉ giao hàng</div><div class="ci-val">' + c.address + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic purple"><i class="fa-solid fa-calendar"></i></div><div><div class="ci-label">Đơn đầu tiên</div><div class="ci-val">' + firstOrder.date + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic blue"><i class="fa-solid fa-calendar-check"></i></div><div><div class="ci-label">Đơn gần nhất</div><div class="ci-val">' + lastOrder.date + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic green"><i class="fa-solid fa-coins"></i></div><div><div class="ci-label">Tổng chi tiêu</div><div class="ci-val" style="color:#3965FF;font-size:17px">' + formatVND(totalSpent) + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic orange"><i class="fa-solid fa-boxes-stacked"></i></div><div><div class="ci-label">Số đơn hàng</div><div class="ci-val">' + c.orders.length + '</div></div></div>' +
            '</div>';

        // Orders pane
        var csrf = '<c:out value="${sessionScope._csrf}"/>';
        var rows = '';
        c.orders.forEach(function(o){
            var opts = statusOptions(o.status);
            var formHtml = '';
            if(opts.length > 0){
                formHtml = '<form action="'+ctx+'/admin/don-hang/cap-nhat" method="POST" class="co-status-form">' +
                    '<input type="hidden" name="_csrf" value="'+csrf+'">' +
                    '<input type="hidden" name="orderId" value="'+o.oid+'">' +
                    '<select name="status">';
                opts.forEach(function(op){
                    formHtml += '<option value="'+op.v+'"'+(op.v===o.status?' selected':'')+'>'+op.l+'</option>';
                });
                formHtml += '</select><button type="submit" class="btn-sm"><i class="fa-solid fa-arrow-rotate-right" style="font-size:11px"></i> Cập nhật</button></form>';
            } else {
                formHtml = '<span style="font-size:12px;color:var(--admin-text-light);font-style:italic">Đã kết thúc</span>';
            }

            rows +=
                '<tr>' +
                    '<td><strong>#' + o.oid + '</strong></td>' +
                    '<td><strong style="color:var(--admin-primary)">' + formatVND(o.total) + '</strong></td>' +
                    '<td style="font-size:13px">' + (o.pay==='COD'?'Khi nhận hàng':'Chuyển khoản') + '</td>' +
                    '<td><span class="os-pill os-'+o.status+'"><i class="fa-solid '+statusIcon(o.status)+'"></i> '+statusLabel(o.status)+'</span></td>' +
                    '<td style="font-size:13px;white-space:nowrap">' + o.date + '</td>' +
                    '<td>' + formHtml + '</td>' +
                    '<td><a href="'+ctx+'/admin/don-hang/chi-tiet?id='+o.oid+'" class="co-detail-btn"><i class="fa-solid fa-eye" style="font-size:11px"></i> Chi tiết</a></td>' +
                '</tr>';
        });

        document.getElementById('paneOrders').innerHTML =
            '<div class="table-responsive"><table class="co-table"><thead><tr>' +
            '<th>Mã</th><th>Tổng tiền</th><th>Thanh toán</th><th>Trạng thái</th><th>Ngày đặt</th><th>Cập nhật</th><th></th>' +
            '</tr></thead><tbody>' + rows + '</tbody></table></div>';

        // Reset to info tab
        var tabs = document.querySelectorAll('.cd-tab');
        var panes = document.querySelectorAll('.cd-pane');
        tabs.forEach(function(t,i){ t.classList.toggle('active',i===0); });
        panes.forEach(function(p,i){ p.classList.toggle('active',i===0); });

        document.getElementById('cdOverlay').classList.add('open');
        document.body.style.overflow = 'hidden';
    };

    window.closeCdOverlay = function(){
        document.getElementById('cdOverlay').classList.remove('open');
        document.body.style.overflow = '';
    };

    window.switchCdTab = function(el){
        var tab = el.dataset.tab;
        document.querySelectorAll('.cd-tab').forEach(function(t){ t.classList.toggle('active', t.dataset.tab===tab); });
        document.getElementById('paneInfo').classList.toggle('active', tab==='info');
        document.getElementById('paneOrders').classList.toggle('active', tab==='orders');
    };

    document.getElementById('cdOverlay').addEventListener('click', function(e){
        if(e.target === this) closeCdOverlay();
    });

    document.addEventListener('keydown', function(e){
        if(e.key==='Escape') closeCdOverlay();
    });

    // ═══════════ Filter by status ═══════════
    var allOrders = [];
    Object.keys(customers).forEach(function(uid){
        var c = customers[uid];
        c.orders.forEach(function(o){
            allOrders.push({oid:o.oid, name:c.name, phone:c.phone, total:o.total, pay:o.pay, status:o.status, date:o.date});
        });
    });

    var filterLabels = {ALL:'Tất cả đơn hàng',PENDING:'Đơn chờ xử lý',SHIPPING:'Đơn đang giao',DONE:'Đơn hoàn thành'};

    window.filterByStatus = function(el){
        var filter = el.dataset.filter;
        document.querySelectorAll('.ol-stat').forEach(function(s){ s.classList.remove('active'); });
        el.classList.add('active');

        var section = document.getElementById('filteredSection');
        var grid = document.getElementById('customerGrid');
        var gridTitle = document.querySelector('.cg-title');

        if(filter === 'ALL'){
            section.style.display = 'none';
            grid.style.display = '';
            gridTitle.style.display = '';
            return;
        }

        grid.style.display = 'none';
        gridTitle.style.display = 'none';
        section.style.display = 'block';
        document.getElementById('filterTitle').textContent = filterLabels[filter] || filter;

        var matchStatuses = filter === 'PENDING' ? ['PENDING','CONFIRMED'] : [filter];
        var filtered = allOrders.filter(function(o){ return matchStatuses.indexOf(o.status) >= 0; });

        var rows = '';
        if(filtered.length === 0){
            rows = '<tr><td colspan="7" style="text-align:center;padding:40px;color:var(--admin-text-light)">Không có đơn hàng nào</td></tr>';
        } else {
            filtered.forEach(function(o){
                rows +=
                    '<tr>' +
                        '<td><strong>#'+o.oid+'</strong></td>' +
                        '<td><strong>'+o.name+'</strong><br><span style="font-size:12px;color:var(--admin-text-light)">'+o.phone+'</span></td>' +
                        '<td><strong style="color:var(--admin-primary)">'+formatVND(o.total)+'</strong></td>' +
                        '<td style="font-size:13px">'+(o.pay==='COD'?'Khi nhận hàng':'Chuyển khoản')+'</td>' +
                        '<td><span class="os-pill os-'+o.status+'"><i class="fa-solid '+statusIcon(o.status)+'"></i> '+statusLabel(o.status)+'</span></td>' +
                        '<td style="font-size:13px;white-space:nowrap">'+o.date+'</td>' +
                        '<td><a href="'+ctx+'/admin/don-hang/chi-tiet?id='+o.oid+'" class="co-detail-btn"><i class="fa-solid fa-eye" style="font-size:11px"></i> Chi tiết</a></td>' +
                    '</tr>';
            });
        }
        document.getElementById('filteredBody').innerHTML = rows;
    };
})();
</script>

</c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
