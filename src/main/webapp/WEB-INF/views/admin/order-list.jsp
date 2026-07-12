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
.v-blue{color:#3965FF}.v-orange{color:#D48806}.v-purple{color:#7A5AF8}.v-green{color:#12B76A}.v-red{color:#F04438}

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

/* ═══════════ Customer Detail Overlay — 3D Premium ═══════════ */
.cd-overlay{
    display:none;position:fixed;inset:0;z-index:9000;
    background:rgba(14,46,92,.55);backdrop-filter:blur(8px);
    align-items:center;justify-content:center;
    perspective:1200px;
}
.cd-overlay.open{display:flex}
.cd-panel{
    background:var(--admin-surface);border-radius:24px;
    width:94%;max-width:920px;max-height:88vh;overflow:hidden;
    box-shadow:0 40px 100px -20px rgba(14,46,92,.4),0 0 0 1px rgba(255,255,255,.06) inset;
    animation:cdSlide .4s cubic-bezier(.22,1,.36,1);
    display:flex;flex-direction:column;
    transform-style:preserve-3d;
}
@keyframes cdSlide{from{opacity:0;transform:translateY(40px) rotateX(4deg) scale(.94)}to{opacity:1;transform:none}}

/* ── 3D Banner Header ── */
.cd-header{
    position:relative;padding:0;flex-shrink:0;overflow:hidden;
    background:linear-gradient(135deg,#1B4F9E 0%,#11335E 55%,#0B2547 100%);
    min-height:130px;
}
.cd-header::before{content:'';position:absolute;top:-60px;right:-40px;width:220px;height:220px;background:radial-gradient(circle,rgba(57,101,255,.2) 0%,transparent 70%);border-radius:50%}
.cd-header::after{content:'';position:absolute;bottom:-80px;left:15%;width:300px;height:300px;background:radial-gradient(circle,rgba(122,90,248,.12) 0%,transparent 70%);border-radius:50%}
.cd-hdr-inner{position:relative;z-index:2;display:flex;align-items:center;gap:20px;padding:28px 32px 24px}
.cd-hdr-avatar{
    width:72px;height:72px;border-radius:20px;flex-shrink:0;
    background:linear-gradient(145deg,rgba(255,255,255,.2),rgba(255,255,255,.06));
    backdrop-filter:blur(10px);
    color:#fff;display:flex;align-items:center;justify-content:center;
    font-size:28px;font-weight:800;font-family:var(--fd);
    border:2.5px solid rgba(255,255,255,.2);
    box-shadow:0 12px 32px -8px rgba(0,0,0,.35),0 4px 8px rgba(57,101,255,.15);
    transform:translateZ(20px);transform-style:preserve-3d;
    transition:transform .4s,box-shadow .3s;
}
.cd-hdr-avatar:hover{transform:translateZ(30px) scale(1.06) rotateY(8deg);box-shadow:0 16px 40px -8px rgba(0,0,0,.45)}
.cd-hdr-info{flex:1;color:#fff}
.cd-hdr-name{font-family:var(--fd);font-size:22px;font-weight:800;letter-spacing:-.02em}
.cd-hdr-sub{font-size:13px;color:rgba(255,255,255,.6);font-weight:500;margin-top:4px}
.cd-hdr-sub i{opacity:.5}
.cd-hdr-badges{display:flex;gap:8px;margin-top:10px;flex-wrap:wrap}
.cd-hdr-badge{
    display:inline-flex;align-items:center;gap:5px;
    padding:4px 12px;border-radius:99px;font-size:11px;font-weight:700;
    background:rgba(255,255,255,.12);color:rgba(255,255,255,.85);
    backdrop-filter:blur(4px);
}
.cd-hdr-badge i{font-size:9px}
.cd-close{
    position:absolute;top:16px;right:16px;z-index:5;
    width:34px;height:34px;border-radius:10px;border:none;
    background:rgba(255,255,255,.1);backdrop-filter:blur(4px);color:rgba(255,255,255,.7);
    font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;
    transition:background .2s,color .2s,transform .2s;
}
.cd-close:hover{background:rgba(240,68,56,.3);color:#fff;transform:scale(1.1)}

/* ── Tabs ── */
.cd-tabs{display:flex;gap:0;padding:0 32px;border-bottom:1px solid var(--admin-border);flex-shrink:0;background:var(--admin-surface)}
.cd-tab{
    padding:14px 18px;font-size:13.5px;font-weight:700;color:var(--admin-text-light);
    cursor:pointer;border-bottom:2.5px solid transparent;transition:color .2s,border-color .2s;
    display:flex;align-items:center;gap:7px;
}
.cd-tab:hover{color:var(--admin-text)}
.cd-tab.active{color:var(--admin-primary);border-bottom-color:var(--admin-primary)}
.cd-tab i{font-size:12px}
.cd-tab .tab-badge{
    background:rgba(57,101,255,.1);color:var(--admin-primary);
    font-size:10.5px;font-weight:800;padding:2px 8px;border-radius:6px;
}

.cd-body{flex:1;overflow-y:auto;padding:24px 32px 32px}

/* Tab content */
.cd-pane{display:none}
.cd-pane.active{display:block}

/* ── Customer info — 3D cards ── */
.ci-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;perspective:800px}
.ci-item{
    display:flex;align-items:flex-start;gap:12px;
    padding:18px;border-radius:16px;background:var(--admin-bg);
    border:1px solid var(--admin-border);
    transition:transform .35s cubic-bezier(.4,0,.2,1),box-shadow .35s,border-color .3s;
    transform-style:preserve-3d;cursor:default;
}
.ci-item:hover{
    transform:translateY(-4px) rotateX(2deg);
    box-shadow:0 14px 30px -10px rgba(14,46,92,.12);
    border-color:rgba(57,101,255,.15);
}
.ci-ic{
    width:42px;height:42px;border-radius:13px;flex-shrink:0;
    display:flex;align-items:center;justify-content:center;font-size:16px;
    transform:translateZ(8px);transition:transform .3s;
}
.ci-item:hover .ci-ic{transform:translateZ(14px) scale(1.08)}
.ci-ic.blue{background:rgba(57,101,255,.1);color:#3965FF}
.ci-ic.green{background:rgba(43,172,98,.1);color:#12B76A}
.ci-ic.orange{background:rgba(245,165,36,.1);color:#D48806}
.ci-ic.purple{background:rgba(122,90,248,.1);color:#7A5AF8}
.ci-ic.red{background:rgba(240,68,56,.1);color:#F04438}
.ci-ic.teal{background:rgba(20,184,166,.1);color:#14B8A6}
.ci-label{font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--admin-text-light);margin-bottom:3px}
.ci-val{font-size:15px;font-weight:700;color:var(--admin-text)}
.ci-full{grid-column:1/-1}

/* ── Highlight card (total spent) ── */
.ci-highlight{
    grid-column:1/-1;padding:22px 24px;border-radius:18px;
    background:linear-gradient(135deg,rgba(57,101,255,.06),rgba(122,90,248,.06));
    border:1.5px solid rgba(57,101,255,.12);
    display:flex;align-items:center;justify-content:space-between;gap:16px;
    transform-style:preserve-3d;transition:transform .35s,box-shadow .35s;
}
.ci-highlight:hover{transform:translateY(-3px) rotateX(1deg);box-shadow:0 16px 36px -12px rgba(57,101,255,.15)}
.ci-hl-left{display:flex;align-items:center;gap:14px}
.ci-hl-icon{
    width:52px;height:52px;border-radius:16px;flex-shrink:0;
    background:linear-gradient(135deg,#3965FF,#7A5AF8);color:#fff;
    display:flex;align-items:center;justify-content:center;font-size:20px;
    box-shadow:0 8px 20px -6px rgba(57,101,255,.4);
    transform:translateZ(12px);
}
.ci-hl-label{font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--admin-text-light);margin-bottom:2px}
.ci-hl-val{font-size:24px;font-weight:800;color:var(--admin-primary);font-family:var(--fd);letter-spacing:-.02em}

/* ── Stats Tab — 3D ring & bars ── */
.st-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px}
.st-card{
    padding:22px;border-radius:18px;background:var(--admin-bg);
    border:1px solid var(--admin-border);
    transition:transform .35s cubic-bezier(.4,0,.2,1),box-shadow .35s;
    transform-style:preserve-3d;
}
.st-card:hover{transform:translateY(-4px) rotateX(2deg);box-shadow:0 14px 30px -10px rgba(14,46,92,.12)}
.st-card-full{grid-column:1/-1}
.st-title{font-size:13px;font-weight:700;color:var(--admin-text);margin-bottom:16px;display:flex;align-items:center;gap:8px}
.st-title i{font-size:12px;color:var(--admin-primary);opacity:.6}

/* Ring chart */
.st-ring-wrap{display:flex;align-items:center;gap:28px}
.st-ring{position:relative;width:140px;height:140px;flex-shrink:0;perspective:400px}
.st-ring svg{width:140px;height:140px;transform:rotate(-90deg) rotateX(8deg);filter:drop-shadow(0 6px 12px rgba(0,0,0,.08))}
.st-ring circle{fill:none;stroke-width:16;stroke-linecap:round;transition:stroke-dashoffset .8s cubic-bezier(.4,0,.2,1)}
.st-ring-center{
    position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
    text-align:center;
}
.st-ring-num{font-size:28px;font-weight:800;font-family:var(--fd);color:var(--admin-text);line-height:1}
.st-ring-label{font-size:10.5px;font-weight:600;color:var(--admin-text-light);text-transform:uppercase;letter-spacing:.4px;margin-top:2px}
.st-legend{display:flex;flex-direction:column;gap:10px;flex:1}
.st-legend-item{display:flex;align-items:center;gap:10px;font-size:13px;font-weight:600;color:var(--admin-text)}
.st-legend-dot{width:10px;height:10px;border-radius:3px;flex-shrink:0}
.st-legend-count{margin-left:auto;font-weight:800;font-family:var(--fd);font-size:15px}

/* Bar chart */
.st-bars{display:flex;flex-direction:column;gap:12px}
.st-bar-row{display:flex;align-items:center;gap:12px}
.st-bar-label{width:90px;font-size:12px;font-weight:600;color:var(--admin-text-light);text-align:right;flex-shrink:0}
.st-bar-track{flex:1;height:28px;background:rgba(224,229,242,.3);border-radius:8px;overflow:hidden;position:relative}
.st-bar-fill{height:100%;border-radius:8px;display:flex;align-items:center;padding-left:10px;font-size:11.5px;font-weight:700;color:#fff;min-width:36px;transition:width .8s cubic-bezier(.4,0,.2,1);box-shadow:0 2px 8px -2px rgba(0,0,0,.15)}
.st-bar-val{font-size:13px;font-weight:800;font-family:var(--fd);width:70px;text-align:right;flex-shrink:0;color:var(--admin-text)}

/* KPI row */
.st-kpi-row{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.st-kpi{
    text-align:center;padding:18px 14px;border-radius:14px;
    background:var(--admin-bg);border:1px solid var(--admin-border);
    transition:transform .3s,box-shadow .3s;transform-style:preserve-3d;
}
.st-kpi:hover{transform:translateY(-3px);box-shadow:0 10px 24px -8px rgba(14,46,92,.1)}
.st-kpi-icon{font-size:20px;margin-bottom:8px;transform:translateZ(6px)}
.st-kpi-val{font-size:22px;font-weight:800;font-family:var(--fd);color:var(--admin-text);line-height:1.1}
.st-kpi-label{font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.4px;color:var(--admin-text-light);margin-top:4px}

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
.os-PENDING_CANCEL{background:rgba(234,179,8,.12);color:#B45309}

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
    .st-grid{grid-template-columns:1fr}
    .st-ring-wrap{flex-direction:column;align-items:flex-start}
    .st-kpi-row{grid-template-columns:1fr}
    .cd-hdr-inner{padding:20px 20px 18px;gap:14px}
    .cd-hdr-avatar{width:56px;height:56px;font-size:22px;border-radius:16px}
    .cd-hdr-name{font-size:18px}
    .cd-tabs{padding:0 20px;overflow-x:auto}.cd-tab{padding:12px 14px;font-size:12.5px;white-space:nowrap}
    .cd-body{padding:18px 20px 24px}
}
</style>

<%-- ═══════════ Group orders by UserId ═══════════ --%>
<c:set var="cntAll" value="${orders.size()}"/>
<c:set var="cntPending" value="0"/><c:set var="cntShipping" value="0"/><c:set var="cntDone" value="0"/><c:set var="cntCancelled" value="0"/><c:set var="cntPendingCancel" value="0"/>
<c:forEach var="o" items="${orders}">
    <c:if test="${o.status == 'PENDING' || o.status == 'CONFIRMED'}"><c:set var="cntPending" value="${cntPending + 1}"/></c:if>
    <c:if test="${o.status == 'SHIPPING'}"><c:set var="cntShipping" value="${cntShipping + 1}"/></c:if>
    <c:if test="${o.status == 'DONE'}"><c:set var="cntDone" value="${cntDone + 1}"/></c:if>
    <c:if test="${o.status == 'CANCELLED'}"><c:set var="cntCancelled" value="${cntCancelled + 1}"/></c:if>
    <c:if test="${o.status == 'PENDING_CANCEL'}"><c:set var="cntPendingCancel" value="${cntPendingCancel + 1}"/></c:if>
</c:forEach>

<!-- Stats bar -->
<div class="ol-stats">
    <div class="ol-stat active" data-filter="ALL" onclick="filterByStatus(this)"><div class="ol-stat-val v-blue">${cntAll}</div><div class="ol-stat-label">Tổng đơn</div></div>
    <div class="ol-stat" data-filter="PENDING" onclick="filterByStatus(this)"><div class="ol-stat-val v-orange">${cntPending}</div><div class="ol-stat-label">Chờ xử lý</div></div>
    <div class="ol-stat" data-filter="SHIPPING" onclick="filterByStatus(this)"><div class="ol-stat-val v-purple">${cntShipping}</div><div class="ol-stat-label">Đang giao</div></div>
    <div class="ol-stat" data-filter="DONE" onclick="filterByStatus(this)"><div class="ol-stat-val v-green">${cntDone}</div><div class="ol-stat-label">Hoàn thành</div></div>
    <div class="ol-stat" data-filter="CANCELLED" onclick="filterByStatus(this)"><div class="ol-stat-val v-red">${cntCancelled}</div><div class="ol-stat-label">Đã hủy</div></div>
    <c:if test="${cntPendingCancel > 0}">
    <div class="ol-stat" data-filter="PENDING_CANCEL" onclick="filterByStatus(this)"><div class="ol-stat-val" style="color:#B45309">${cntPendingCancel}</div><div class="ol-stat-label">Chờ duyệt hủy</div></div>
    </c:if>
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
         data-email="${fn:escapeXml(o.email)}"
         data-address="${fn:escapeXml(o.address)}"
         data-total="${o.totalAmount}"
         data-pay="${o.paymentMethod}"
         data-status="${o.status}"
         data-coupon="${fn:escapeXml(o.couponCode)}"
         data-date="<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>"
         data-account-date="<c:if test="${o.accountCreatedAt != null}"><fmt:formatDate value="${o.accountCreatedAt}" pattern="dd/MM/yyyy"/></c:if>">
    </div>
    </c:forEach>
</div>

<%-- Customer Detail Overlay --%>
<div class="cd-overlay" id="cdOverlay">
    <div class="cd-panel">
        <div class="cd-header">
            <button class="cd-close" onclick="closeCdOverlay()">&times;</button>
            <div class="cd-hdr-inner">
                <div class="cd-hdr-avatar" id="cdAvatar"></div>
                <div class="cd-hdr-info">
                    <div class="cd-hdr-name" id="cdName"></div>
                    <div class="cd-hdr-sub" id="cdSub"></div>
                    <div class="cd-hdr-badges" id="cdBadges"></div>
                </div>
            </div>
        </div>
        <div class="cd-tabs">
            <div class="cd-tab active" data-tab="info" onclick="switchCdTab(this)">
                <i class="fa-solid fa-user"></i> Thông tin
            </div>
            <div class="cd-tab" data-tab="stats" onclick="switchCdTab(this)">
                <i class="fa-solid fa-chart-pie"></i> Thống kê
            </div>
            <div class="cd-tab" data-tab="orders" onclick="switchCdTab(this)">
                <i class="fa-solid fa-boxes-stacked"></i> Đơn hàng <span class="tab-badge" id="cdOrderCount">0</span>
            </div>
        </div>
        <div class="cd-body">
            <div class="cd-pane active" id="paneInfo"></div>
            <div class="cd-pane" id="paneStats"></div>
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
                email: d.email || '', accountDate: d.accountDate || '',
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

        var pending=0,shipping=0,done=0,cancelled=0,pendingCancel=0,totalSum=0;
        c.orders.forEach(function(o){
            if(o.status==='PENDING'||o.status==='CONFIRMED') pending++;
            else if(o.status==='SHIPPING') shipping++;
            else if(o.status==='DONE') done++;
            else if(o.status==='CANCELLED') cancelled++;
            else if(o.status==='PENDING_CANCEL') pendingCancel++;
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
                (cancelled ? '<span class="cg-stat-chip" style="background:rgba(240,68,56,.1);color:#F04438"><i class="fa-solid fa-ban" style="font-size:9px"></i> '+cancelled+' hủy</span>' : '') +
                (pendingCancel ? '<span class="cg-stat-chip" style="background:rgba(234,179,8,.12);color:#B45309"><i class="fa-solid fa-hourglass-half" style="font-size:9px"></i> '+pendingCancel+' chờ duyệt hủy</span>' : '') +
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
        var m = {PENDING:'Chờ xử lý',CONFIRMED:'Đã xác nhận',SHIPPING:'Đang giao',DONE:'Hoàn thành',CANCELLED:'Đã huỷ',PENDING_CANCEL:'Chờ duyệt hủy'};
        return m[s]||s;
    }
    function statusIcon(s){
        var m = {PENDING:'fa-clock',CONFIRMED:'fa-circle-check',SHIPPING:'fa-truck-fast',DONE:'fa-check-double',CANCELLED:'fa-ban',PENDING_CANCEL:'fa-hourglass-half'};
        return m[s]||'fa-circle';
    }

    var statusRank = {PENDING:0,CONFIRMED:1,SHIPPING:2,DONE:3,PENDING_CANCEL:98,CANCELLED:99};
    function statusOptions(cur){
        var opts = [];
        if(cur==='DONE'||cur==='CANCELLED'||cur==='PENDING_CANCEL') return opts;
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

        var firstOrder = c.orders[c.orders.length - 1];
        var lastOrder = c.orders[0];
        var totalSpent=0,doneSpent=0,pendingN=0,confirmedN=0,shippingN=0,doneN=0,cancelledN=0,pendingCancelN=0;
        c.orders.forEach(function(o){
            totalSpent+=o.total;
            if(o.status==='PENDING') pendingN++;
            else if(o.status==='CONFIRMED') confirmedN++;
            else if(o.status==='SHIPPING') shippingN++;
            else if(o.status==='DONE'){doneN++;doneSpent+=o.total}
            else if(o.status==='CANCELLED') cancelledN++;
            else if(o.status==='PENDING_CANCEL') pendingCancelN++;
        });
        var avgOrder = c.orders.length > 0 ? totalSpent / c.orders.length : 0;
        var successRate = c.orders.length > 0 ? Math.round(doneN / c.orders.length * 100) : 0;

        var badges = '';
        if(doneSpent>=5000000) badges+='<span class="cd-hdr-badge" style="background:linear-gradient(135deg,rgba(255,210,122,.25),rgba(245,165,36,.2));color:#FFD27A"><i class="fa-solid fa-gem"></i> Kim Cương</span>';
        else if(doneSpent>=2000000) badges+='<span class="cd-hdr-badge" style="background:linear-gradient(135deg,rgba(245,165,36,.2),rgba(255,210,122,.15));color:#FFD27A"><i class="fa-solid fa-crown"></i> Vàng</span>';
        else if(doneSpent>=500000) badges+='<span class="cd-hdr-badge" style="background:rgba(192,192,192,.2);color:#E0E0E0"><i class="fa-solid fa-medal"></i> Bạc</span>';
        else badges+='<span class="cd-hdr-badge"><i class="fa-solid fa-seedling"></i> Mới</span>';
        badges+='<span class="cd-hdr-badge"><i class="fa-solid fa-receipt"></i> '+c.orders.length+' đơn</span>';
        if(pendingN+confirmedN+shippingN>0) badges+='<span class="cd-hdr-badge" style="background:rgba(245,165,36,.15);color:#FFD27A"><i class="fa-solid fa-clock"></i> '+(pendingN+confirmedN+shippingN)+' đang xử lý</span>';
        document.getElementById('cdBadges').innerHTML = badges;

        // Info pane
        document.getElementById('paneInfo').innerHTML =
            '<div class="ci-highlight">' +
                '<div class="ci-hl-left"><div class="ci-hl-icon"><i class="fa-solid fa-coins"></i></div><div><div class="ci-hl-label">Tổng chi tiêu</div><div class="ci-hl-val">'+formatVND(totalSpent)+'</div></div></div>' +
                '<div style="text-align:right"><div class="ci-hl-label">Đã hoàn thành</div><div class="ci-hl-val" style="font-size:18px;color:var(--admin-text)">'+formatVND(doneSpent)+'</div></div>' +
            '</div>' +
            '<div class="ci-grid" style="margin-top:18px">' +
                '<div class="ci-item"><div class="ci-ic blue"><i class="fa-solid fa-user"></i></div><div><div class="ci-label">Họ tên</div><div class="ci-val">' + c.name + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic green"><i class="fa-solid fa-phone"></i></div><div><div class="ci-label">Số điện thoại</div><div class="ci-val">' + c.phone + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic purple"><i class="fa-solid fa-envelope"></i></div><div><div class="ci-label">Email</div><div class="ci-val">' + (c.email || 'Chưa cập nhật') + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic teal"><i class="fa-solid fa-user-plus"></i></div><div><div class="ci-label">Ngày tham gia</div><div class="ci-val">' + (c.accountDate || 'N/A') + '</div></div></div>' +
                '<div class="ci-item ci-full"><div class="ci-ic orange"><i class="fa-solid fa-map-pin"></i></div><div><div class="ci-label">Địa chỉ giao hàng</div><div class="ci-val">' + c.address + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic blue"><i class="fa-solid fa-calendar"></i></div><div><div class="ci-label">Đơn đầu tiên</div><div class="ci-val">' + firstOrder.date + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic teal"><i class="fa-solid fa-calendar-check"></i></div><div><div class="ci-label">Đơn gần nhất</div><div class="ci-val">' + lastOrder.date + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic blue"><i class="fa-solid fa-boxes-stacked"></i></div><div><div class="ci-label">Tổng đơn hàng</div><div class="ci-val">' + c.orders.length + '</div></div></div>' +
                '<div class="ci-item"><div class="ci-ic green"><i class="fa-solid fa-calculator"></i></div><div><div class="ci-label">Giá trị TB/đơn</div><div class="ci-val" style="color:#3965FF">' + formatVND(avgOrder) + '</div></div></div>' +
            '</div>';

        // Stats pane — ring chart + bars + KPIs
        var total = c.orders.length;
        var circumference = 2 * Math.PI * 54;
        var segments = [
            {n:doneN,color:'#12B76A',label:'Hoàn thành'},
            {n:shippingN,color:'#7A5AF8',label:'Đang giao'},
            {n:confirmedN,color:'#3965FF',label:'Đã xác nhận'},
            {n:pendingN,color:'#D48806',label:'Chờ xử lý'},
            {n:pendingCancelN,color:'#EAB308',label:'Chờ duyệt hủy'},
            {n:cancelledN,color:'#F04438',label:'Đã hủy'}
        ];
        var ringSvg = '<circle cx="70" cy="70" r="54" stroke="rgba(224,229,242,.3)" stroke-width="16" fill="none"/>';
        var offset = 0;
        segments.forEach(function(seg){
            if(seg.n>0){
                var len = (seg.n/total)*circumference;
                ringSvg += '<circle cx="70" cy="70" r="54" stroke="'+seg.color+'" stroke-dasharray="'+len+' '+(circumference-len)+'" stroke-dashoffset="-'+offset+'" style="transition:stroke-dashoffset .8s"/>';
                offset += len;
            }
        });
        var legendHtml = '';
        segments.forEach(function(seg){
            if(seg.n>0) legendHtml += '<div class="st-legend-item"><div class="st-legend-dot" style="background:'+seg.color+'"></div>'+seg.label+'<span class="st-legend-count">'+seg.n+'</span></div>';
        });

        var maxTotal = 0;
        c.orders.forEach(function(o){if(o.total>maxTotal)maxTotal=o.total});
        var barsHtml = '';
        var barColors = {DONE:'#12B76A',SHIPPING:'#7A5AF8',CONFIRMED:'#3965FF',PENDING:'#D48806',CANCELLED:'#F04438',PENDING_CANCEL:'#EAB308'};
        var recentOrders = c.orders.slice(0,5);
        recentOrders.forEach(function(o){
            var pct = maxTotal>0?Math.max(8,Math.round(o.total/maxTotal*100)):8;
            barsHtml += '<div class="st-bar-row">'+
                '<div class="st-bar-label">#'+o.oid+'</div>'+
                '<div class="st-bar-track"><div class="st-bar-fill" style="width:'+pct+'%;background:linear-gradient(90deg,'+(barColors[o.status]||'#3965FF')+','+(barColors[o.status]||'#3965FF')+'aa)">'+statusLabel(o.status).substring(0,6)+'</div></div>'+
                '<div class="st-bar-val">'+formatVND(o.total)+'</div>'+
            '</div>';
        });

        document.getElementById('paneStats').innerHTML =
            '<div class="st-kpi-row" style="margin-bottom:20px">' +
                '<div class="st-kpi"><div class="st-kpi-icon" style="color:#3965FF"><i class="fa-solid fa-receipt"></i></div><div class="st-kpi-val">'+total+'</div><div class="st-kpi-label">Tổng đơn</div></div>' +
                '<div class="st-kpi"><div class="st-kpi-icon" style="color:#12B76A"><i class="fa-solid fa-circle-check"></i></div><div class="st-kpi-val">'+successRate+'%</div><div class="st-kpi-label">Tỉ lệ hoàn thành</div></div>' +
                '<div class="st-kpi"><div class="st-kpi-icon" style="color:#7A5AF8"><i class="fa-solid fa-chart-line"></i></div><div class="st-kpi-val">'+formatVND(avgOrder)+'</div><div class="st-kpi-label">TB/đơn</div></div>' +
            '</div>' +
            '<div class="st-grid">' +
                '<div class="st-card"><div class="st-title"><i class="fa-solid fa-chart-pie"></i> Phân bố trạng thái</div>' +
                    '<div class="st-ring-wrap"><div class="st-ring"><svg viewBox="0 0 140 140">'+ringSvg+'</svg><div class="st-ring-center"><div class="st-ring-num">'+total+'</div><div class="st-ring-label">Đơn</div></div></div>' +
                    '<div class="st-legend">'+legendHtml+'</div></div></div>' +
                '<div class="st-card"><div class="st-title"><i class="fa-solid fa-chart-bar"></i> Đơn gần nhất (top 5)</div>' +
                    '<div class="st-bars">'+barsHtml+'</div></div>' +
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
        document.querySelectorAll('.cd-tab').forEach(function(t){ t.classList.toggle('active', t.dataset.tab==='info'); });
        document.getElementById('paneInfo').classList.add('active');
        document.getElementById('paneStats').classList.remove('active');
        document.getElementById('paneOrders').classList.remove('active');

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
        document.getElementById('paneStats').classList.toggle('active', tab==='stats');
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

    var filterLabels = {ALL:'Tất cả đơn hàng',PENDING:'Đơn chờ xử lý',SHIPPING:'Đơn đang giao',DONE:'Đơn hoàn thành',CANCELLED:'Đơn đã hủy',PENDING_CANCEL:'Đơn chờ duyệt hủy'};

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

<%-- Pagination --%>
<c:if test="${totalPages > 1}">
<div style="display:flex;align-items:center;justify-content:space-between;padding:20px 0;margin-top:10px">
    <span style="font-size:13px;color:var(--admin-text-light);font-weight:500">Tổng ${totalItems} đơn hàng · Trang ${currentPage}/${totalPages}</span>
    <div style="display:flex;gap:6px">
        <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/admin/don-hang?page=${currentPage - 1}" style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;border:1.5px solid var(--admin-border);background:var(--admin-surface);color:var(--admin-text);font-size:14px;text-decoration:none;font-weight:600;transition:all .2s">&laquo;</a>
        </c:if>
        <c:forEach begin="1" end="${totalPages}" var="p">
            <c:choose>
                <c:when test="${p == currentPage}">
                    <span style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#3965FF,#1B4F9E);color:#fff;font-size:14px;font-weight:700">${p}</span>
                </c:when>
                <c:when test="${p <= 3 || p >= totalPages - 1 || (p >= currentPage - 1 && p <= currentPage + 1)}">
                    <a href="${pageContext.request.contextPath}/admin/don-hang?page=${p}" style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;border:1.5px solid var(--admin-border);background:var(--admin-surface);color:var(--admin-text);font-size:14px;text-decoration:none;font-weight:600;transition:all .2s">${p}</a>
                </c:when>
                <c:when test="${p == 4 || p == totalPages - 2}">
                    <span style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;font-size:14px;color:var(--admin-text-light)">...</span>
                </c:when>
            </c:choose>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/admin/don-hang?page=${currentPage + 1}" style="display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:10px;border:1.5px solid var(--admin-border);background:var(--admin-surface);color:var(--admin-text);font-size:14px;text-decoration:none;font-weight:600;transition:all .2s">&raquo;</a>
        </c:if>
    </div>
</div>
</c:if>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
