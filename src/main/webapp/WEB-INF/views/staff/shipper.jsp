<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
<meta name="theme-color" content="#111111">
<title>Shipper — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet"><style>
:root{
  --yellow:#FFC400;--yellow-dark:#E6A800;--black:#111;--gray:#181818;--gray-2:#282828;--white:#FFF;
  --muted:#A0A0A0;--green:#22C55E;--red:#EF4444;--blue:#3B82F6;--gradient:linear-gradient(135deg,#FFC400,#FF9100)
}
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent}
html{font-size:16px}
body{font-family:'Inter',sans-serif;background:var(--black);color:var(--white);min-height:100vh;-webkit-font-smoothing:antialiased}

/* ===== LAYOUT ===== */
.shipper-layout{display:flex;min-height:100vh;background:var(--black);width:100%}

/* Sidebar */
.shipper-sidebar{
  width:280px;background:var(--gray);border-right:1px solid var(--gray-2);
  display:flex;flex-direction:column;flex-shrink:0;padding:24px 16px;position:sticky;top:0;height:100vh
}
.sb-brand{
  font-size:22px;font-weight:900;color:var(--yellow);letter-spacing:.5px;
  margin-bottom:32px;display:flex;align-items:center;gap:10px;padding-left:8px;
  font-family:'Inter',sans-serif
}
.sb-brand b{color:var(--white)}
.sb-nav{display:flex;flex-direction:column;gap:8px}
.sb-item{
  display:flex;align-items:center;justify-content:space-between;
  width:100%;border:none;background:transparent;padding:14px 16px;
  border-radius:14px;color:var(--muted);font-size:15px;font-weight:700;
  cursor:pointer;text-align:left;transition:all .2s;font-family:inherit
}
.sb-item i{font-size:16px;width:22px}
.sb-item:hover{background:rgba(255,255,255,.05);color:var(--white)}
.sb-item.active{background:var(--yellow);color:var(--black)}
.sb-badge{
  font-size:11px;font-weight:800;padding:3px 9px;border-radius:8px;
  background:var(--gray-2);color:var(--white)
}
.sb-item.active .sb-badge{background:var(--black);color:var(--yellow)}

/* Main Content */
.shipper-main{flex:1;display:flex;flex-direction:column;min-width:0}

/* Header */
.hd{
  position:sticky;top:0;z-index:50;background:var(--yellow);color:var(--black);
  padding:14px 20px calc(14px + env(safe-area-inset-top));
  padding-top:calc(14px + env(safe-area-inset-top));
  display:flex;align-items:center;justify-content:space-between;
  box-shadow:0 4px 20px rgba(0,0,0,.35)
}
.hd-l{display:flex;align-items:center;gap:12px}
.hd-avatar{width:46px;height:46px;border-radius:14px;background:var(--black);color:var(--yellow);display:flex;align-items:center;justify-content:center;font-weight:900;font-size:20px}
.hd-name{font-weight:800;font-size:16.5px;line-height:1.25}
.hd-sub{font-size:12.5px;font-weight:600;opacity:.75}
.hd-r{display:flex;align-items:center;gap:8px}
.hd-toggle{border:none;border-radius:99px;padding:10px 16px;font-family:inherit;font-weight:800;font-size:12.5px;cursor:pointer;transition:all .2s;white-space:nowrap}
.hd-toggle.on{background:var(--black);color:var(--green)}
.hd-toggle.off{background:rgba(0,0,0,.15);color:var(--black)}
.hd-logout{width:40px;height:40px;flex-shrink:0;border-radius:12px;background:var(--black);color:var(--yellow);display:flex;align-items:center;justify-content:center;font-size:18px;text-decoration:none}
.hd-logout:active{transform:scale(.94)}

/* Mobile Tab bar */
.mobile-tabs{
  display:none;background:rgba(20,20,20,.85);backdrop-filter:blur(12px);
  position:sticky;top:72px;z-index:40;border-bottom:1px solid var(--gray-2);
  padding:4px 8px
}
.m-tab{
  flex:1;border:none;background:transparent;color:var(--muted);
  padding:12px 6px;font-family:inherit;font-size:12px;font-weight:800;
  text-align:center;cursor:pointer;border-bottom:3.5px solid transparent;
  transition:all .2s;display:flex;flex-direction:column;align-items:center;gap:4px
}
.m-tab i{font-size:15px}
.m-tab.active{color:var(--yellow);border-bottom-color:var(--yellow)}

/* Stats Box */
.stats{display:grid;grid-template-columns:1fr 1fr;gap:12px;padding:16px 20px;max-width:600px;width:100%;margin:0 auto}
.stat{background:var(--gray);border-radius:20px;padding:16px;text-align:center;border:1px solid var(--gray-2)}
.stat b{display:block;font-size:28px;font-weight:900;color:var(--yellow)}
.stat span{font-size:12px;font-weight:700;color:var(--muted);margin-top:2px;display:block}

/* Order wrap */
.wrap{padding:4px 20px 100px;max-width:600px;margin:0 auto;width:100%}

/* Card */
.card{
  background:var(--gray);border-radius:24px;margin-bottom:20px;
  overflow:hidden;border:1.5px solid var(--gray-2);
  transition:transform .3s,box-shadow .3s,border-color .3s;
}
.card:hover{
  border-color:var(--gray-2);box-shadow:0 12px 30px rgba(0,0,0,.45);
}
.card.done{opacity:.5}
.card-hd{display:flex;justify-content:space-between;align-items:center;padding:16px 20px;border-bottom:1px solid var(--gray-2)}
.card-id{font-weight:900;font-size:18px}
.chip{border-radius:99px;padding:6px 14px;font-size:11px;font-weight:800;letter-spacing:.5px}
.chip-ASSIGNED{background:rgba(59,130,246,.18);color:var(--blue)}
.chip-PICKING_UP{background:rgba(255,196,0,.15);color:var(--yellow)}
.chip-DELIVERING{background:rgba(255,196,0,.25);color:var(--yellow)}
.chip-COMPLETED{background:rgba(34,197,94,.18);color:var(--green)}
.chip-FAILED{background:rgba(239,68,68,.18);color:var(--red)}

.card-body{padding:18px 20px}
.cust{font-size:18px;font-weight:900;margin-bottom:4px}
.addr{font-size:14px;color:var(--muted);line-height:1.5;margin-bottom:14px}
.money{display:flex;align-items:center;gap:10px;background:var(--gray-2);border-radius:16px;padding:12px 16px;margin-bottom:14px}
.money.cod{background:rgba(255,196,0,.08);border:1.5px dashed rgba(255,196,0,.35)}
.money b{font-size:20px;font-weight:900;color:var(--yellow)}
.money small{font-size:12px;font-weight:700;color:var(--muted)}
.money.cod small{color:var(--yellow)}

/* Maps */
.map-box{border-radius:18px;overflow:hidden;margin-bottom:14px;border:1.5px solid var(--gray-2);position:relative}
.map-box iframe{display:block;width:100%;height:180px;border:0;filter:grayscale(1) invert(0.9) contrast(1.2)}

/* Action row */
.act-row{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:14px}
.act{display:flex;align-items:center;justify-content:center;gap:8px;border-radius:16px;padding:16px 10px;font-size:15px;font-weight:800;text-decoration:none;transition:transform .15s}
.act:active{transform:scale(.96)}
.act-call{background:var(--gray-2);color:var(--white)}
.act-dir{background:var(--blue);color:#fff}

/* Big button */
.big-btn{position:relative;overflow:hidden;width:100%;border:none;border-radius:18px;padding:20px;font-family:inherit;font-size:16.5px;font-weight:900;letter-spacing:.3px;cursor:pointer;color:var(--black);background:var(--yellow);transition:transform .15s;text-transform:uppercase}
.big-btn:active{transform:scale(.97)}
.big-btn:disabled{opacity:.5}
.ripple{position:absolute;border-radius:50%;background:rgba(0,0,0,.25);transform:scale(0);animation:rip .55s ease-out;pointer-events:none}
@keyframes rip{to{transform:scale(3.2);opacity:0}}

/* Camera */
.proof-row{display:flex;gap:10px;margin-bottom:14px}
.proof-btn{flex:1;display:flex;align-items:center;justify-content:center;gap:8px;border:2px dashed var(--yellow);background:transparent;color:var(--yellow);border-radius:16px;padding:16px;font-family:inherit;font-size:14px;font-weight:800;cursor:pointer}
.proof-thumb{width:60px;height:60px;border-radius:14px;object-fit:cover;border:2px solid var(--green);display:none}
.proof-thumb.show{display:block}

/* Swipe */
.swipe{position:relative;height:68px;background:var(--gray-2);border-radius:99px;overflow:hidden;user-select:none;touch-action:pan-y}
.swipe-fill{position:absolute;inset:0;width:0;background:linear-gradient(90deg,rgba(34,197,94,.35),rgba(34,197,94,.65));transition:width .1s}
.swipe-txt{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;font-size:14.5px;font-weight:800;color:var(--muted);letter-spacing:.5px}
.swipe-knob{position:absolute;top:5px;left:5px;width:58px;height:58px;border-radius:50%;background:var(--green);display:flex;align-items:center;justify-content:center;font-size:22px;color:#fff;box-shadow:0 4px 12px rgba(0,0,0,.4);transition:left .25s cubic-bezier(.2,.8,.3,1)}
.swipe.locked{opacity:.45;pointer-events:none}
.swipe.done .swipe-fill{width:100%}
.swipe.done .swipe-txt{color:#fff}

.fail-link{display:block;text-align:center;margin-top:12px;background:none;border:none;color:var(--red);font-family:inherit;font-size:13.5px;font-weight:700;cursor:pointer;padding:8px;width:100%}
.proof-view{width:100%;border-radius:16px;margin-top:10px;max-height:180px;object-fit:cover}

/* Empty */
.empty{text-align:center;padding:80px 20px;color:var(--muted);font-weight:600}
.empty b{display:block;font-size:48px;margin-bottom:14px}

/* Toast */
.toast{position:fixed;left:50%;bottom:100px;transform:translateX(-50%) translateY(20px);background:var(--white);color:var(--black);font-size:14px;font-weight:800;padding:14px 26px;border-radius:99px;opacity:0;transition:all .3s;z-index:200;box-shadow:0 12px 36px rgba(0,0,0,.6);max-width:90vw;text-align:center}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

/* Chat */
.fab{position:fixed;right:20px;bottom:calc(20px + env(safe-area-inset-bottom));width:64px;height:64px;border-radius:50%;background:var(--yellow);color:var(--black);border:none;font-size:26px;cursor:pointer;box-shadow:0 8px 24px rgba(255,196,0,.4);z-index:90;display:flex;align-items:center;justify-content:center}
.sheet{position:fixed;inset:0;z-index:100;display:none}
.sheet.show{display:block}
.sheet-bg{position:absolute;inset:0;background:rgba(0,0,0,.7)}
.sheet-body{position:absolute;left:0;right:0;bottom:0;background:var(--gray);border-radius:24px 24px 0 0;max-height:80vh;display:flex;flex-direction:column;padding-bottom:env(safe-area-inset-bottom);border:1px solid var(--gray-2)}
.sheet-hd{display:flex;justify-content:space-between;align-items:center;padding:18px 20px;border-bottom:1px solid var(--gray-2);font-weight:800;font-size:17px}
.sheet-hd button{background:none;border:none;color:var(--muted);font-size:24px;cursor:pointer}
.msgs{flex:1;overflow-y:auto;padding:16px;min-height:240px;max-height:46vh}
.m{max-width:80%;margin-bottom:12px;padding:12px 16px;border-radius:18px;font-size:14.5px;line-height:1.45;word-break:break-word}
.m.them{background:var(--gray-2)}
.m.mine{background:var(--yellow);color:var(--black);margin-left:auto;font-weight:600}
.m small{display:block;font-size:10.5px;opacity:.6;margin-top:4px}
.m .who{font-size:11.5px;font-weight:800;color:var(--yellow);margin-bottom:3px}
.m.mine .who{display:none}
.chat-in{display:flex;gap:10px;padding:14px;border-top:1px solid var(--gray-2)}
.chat-in input{flex:1;background:var(--gray-2);border:none;border-radius:99px;padding:14px 20px;color:#fff;font-family:inherit;font-size:14.5px;outline:none}
.chat-in button{background:var(--yellow);color:var(--black);border:none;border-radius:99px;width:52px;font-size:20px;cursor:pointer;display:flex;align-items:center;justify-content:center}

@media(max-width:767.98px){
  .shipper-sidebar{display:none}
  .mobile-tabs{display:flex}
  .hd{position:sticky;top:0;z-index:50}
}
</style>
</head>
<body>
<c:set var="me" value="${not empty sessionScope.shipperUser ? sessionScope.shipperUser : sessionScope.adminUser}"/>
<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="todayDate" value="${now}" pattern="yyyy-MM-dd"/>

<div class="shipper-layout">
  <!-- Sidebar cho màn hình Desktop/Tablet -->
  <aside class="shipper-sidebar">
    <div class="sb-brand">
      Pure<b>Nut</b> Shipper
    </div>
    <nav class="sb-nav">
      <button type="button" class="sb-item active" data-tab="active">
        <span><i class="fa-solid fa-truck-fast"></i> Đang giao</span>
        <span class="sb-badge badge-active">${activeCount}</span>
      </button>
      <button type="button" class="sb-item" data-tab="today">
        <span><i class="fa-solid fa-calendar-day"></i> Đơn hôm nay</span>
        <span class="sb-badge badge-today">0</span>
      </button>
      <button type="button" class="sb-item" data-tab="completed">
        <span><i class="fa-solid fa-circle-check"></i> Đơn đã giao</span>
        <span class="sb-badge badge-completed">${doneCount}</span>
      </button>
    </nav>
  </aside>

  <!-- Vùng nội dung chính -->
  <div class="shipper-main">
    <header class="hd">
      <div class="hd-l">
        <div class="hd-avatar">${fn:toUpperCase(fn:substring(me.fullName,0,1))}</div>
        <div>
          <div class="hd-name"><c:out value="${me.fullName}"/></div>
          <div class="hd-sub">
            <c:if test="${not empty profile.vehiclePlate}">🏍 <c:out value="${profile.vehiclePlate}"/> · </c:if>Shipper PureNut
          </div>
        </div>
      </div>
      <div class="hd-r">
        <button type="button" id="statusToggle"
                class="hd-toggle ${profile.status == 'ACTIVE' ? 'on' : 'off'}"
                data-status="${profile.status}">
          ${profile.status == 'ACTIVE' ? '● Đang nhận đơn' : '○ Tạm nghỉ'}
        </button>
        <a class="hd-logout" href="${ctx}/shipper/logout" title="Đăng xuất" aria-label="Đăng xuất">⏻</a>
      </div>
    </header>

    <!-- Tab bar cho Mobile -->
    <div class="mobile-tabs">
      <button type="button" class="m-tab active" data-tab="active">
        <i class="fa-solid fa-truck-fast"></i>
        <div>Đang giao (<span class="badge-active">${activeCount}</span>)</div>
      </button>
      <button type="button" class="m-tab" data-tab="today">
        <i class="fa-solid fa-calendar-day"></i>
        <div>Hôm nay (<span class="badge-today">0</span>)</div>
      </button>
      <button type="button" class="m-tab" data-tab="completed">
        <i class="fa-solid fa-circle-check"></i>
        <div>Đã giao (<span class="badge-completed">${doneCount}</span>)</div>
      </button>
    </div>

    <div class="stats">
      <div class="stat"><b>${activeCount}</b><span>Đơn đang chạy</span></div>
      <div class="stat"><b>${doneCount}</b><span>Đã hoàn thành</span></div>
    </div>

    <div class="wrap">
      <div class="empty-state" id="emptyState" style="display:none">
        <div class="empty"><b>📭</b>Chưa có đơn nào trong mục này.</div>
      </div>
      <c:if test="${empty orders}">
        <div class="empty" id="noOrdersAtAll"><b>📭</b>Chưa có đơn nào được gán.<br>Chờ điều phối từ PureNut nhé!</div>
      </c:if>

      <c:forEach var="o" items="${orders}">
        <fmt:formatDate var="orderDate" value="${o.createdAt}" pattern="yyyy-MM-dd"/>
        <c:set var="isToday" value="${orderDate == todayDate}"/>
        <c:set var="ds" value="${empty o.deliveryStatus ? 'ASSIGNED' : o.deliveryStatus}"/>
        <c:set var="isActive" value="${ds == 'ASSIGNED' || ds == 'PICKING_UP' || ds == 'DELIVERING'}"/>
        <div class="card ${isActive ? '' : 'done'}" id="card${o.orderId}" data-status="${ds}" data-today="${isToday}">
    <div class="card-hd">
      <span class="card-id">#${o.orderId}</span>
      <span class="chip chip-${ds}" id="chip${o.orderId}">
        <c:choose>
          <c:when test="${ds == 'ASSIGNED'}">CHỜ BÀN GIAO</c:when>
          <c:when test="${ds == 'PICKING_UP'}">ĐANG BÀN GIAO</c:when>
          <c:when test="${ds == 'DELIVERING'}">ĐANG GIAO</c:when>
          <c:when test="${ds == 'COMPLETED'}">HOÀN THÀNH ✓</c:when>
          <c:otherwise>THẤT BẠI</c:otherwise>
        </c:choose>
      </span>
    </div>
    <div class="card-body">
      <div class="cust"><c:out value="${o.fullName}"/></div>
      <div class="addr">📍 <c:out value="${o.address}"/></div>

      <div class="money ${o.paymentMethod == 'COD' ? 'cod' : ''}">
        <div style="flex:1">
          <b><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>₫</b><br>
          <small>${o.paymentMethod == 'COD' ? '⚠ THU TIỀN MẶT KHI GIAO' : '✓ Đã thanh toán online'}</small>
        </div>
      </div>

      <c:if test="${isActive}">
        <%-- Bản đồ vị trí khách: ưu tiên tọa độ, fallback địa chỉ text --%>
        <div class="map-box">
          <c:choose>
            <c:when test="${o.latitude != null && o.longitude != null}">
              <iframe loading="lazy" referrerpolicy="no-referrer-when-downgrade"
                      src="https://maps.google.com/maps?q=${o.latitude},${o.longitude}&z=16&output=embed"></iframe>
            </c:when>
            <c:otherwise>
              <iframe loading="lazy" referrerpolicy="no-referrer-when-downgrade"
                      src="https://maps.google.com/maps?q=${fn:escapeXml(o.address)}&z=15&output=embed"></iframe>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="act-row">
          <a class="act act-call" href="tel:${o.phone}">📞 Gọi khách</a>
          <c:choose>
            <c:when test="${o.latitude != null && o.longitude != null}">
              <a class="act act-dir" target="_blank" rel="noopener"
                 href="https://www.google.com/maps/dir/?api=1&destination=${o.latitude},${o.longitude}&travelmode=driving">🧭 Chỉ đường</a>
            </c:when>
            <c:otherwise>
              <a class="act act-dir" target="_blank" rel="noopener"
                 href="https://www.google.com/maps/dir/?api=1&destination=${fn:escapeXml(o.address)}&travelmode=driving">🧭 Chỉ đường</a>
            </c:otherwise>
          </c:choose>
        </div>

        <%-- ===== STATE MACHINE UI ===== --%>
        <div id="stage${o.orderId}">
          <c:if test="${ds == 'ASSIGNED'}">
            <button type="button" class="big-btn" onclick="transition(this,${o.orderId},'ASSIGNED','PICKING_UP')">🏪 Xác nhận & qua lấy hàng</button>
          </c:if>

          <c:if test="${ds == 'PICKING_UP'}">
            <button type="button" class="big-btn" onclick="transition(this,${o.orderId},'PICKING_UP','DELIVERING')">🛵 Đã nhận được hàng — Bắt đầu giao</button>
            <button type="button" class="fail-link" onclick="markFail(${o.orderId},'PICKING_UP')">✕ Không lấy được hàng</button>
          </c:if>

          <c:if test="${ds == 'DELIVERING'}">
            <div class="proof-row">
              <button type="button" class="proof-btn" onclick="document.getElementById('cam${o.orderId}').click()">
                📷 <span id="camTxt${o.orderId}">${empty o.proofImage ? 'Chụp ảnh xác nhận' : 'Chụp lại ảnh'}</span>
              </button>
              <img class="proof-thumb ${empty o.proofImage ? '' : 'show'}" id="thumb${o.orderId}"
                   src="${empty o.proofImage ? '' : ctx.concat(o.proofImage)}" alt="proof">
              <input type="file" id="cam${o.orderId}" accept="image/*" capture="environment"
                     style="display:none" onchange="uploadProof(${o.orderId},this)">
            </div>
            <div class="swipe ${empty o.proofImage ? 'locked' : ''}" id="swipe${o.orderId}" data-order="${o.orderId}">
              <div class="swipe-fill"></div>
              <div class="swipe-txt">VUỐT ĐỂ HOÀN THÀNH ĐƠN →</div>
              <div class="swipe-knob">➤</div>
            </div>
            <button type="button" class="fail-link" onclick="markFail(${o.orderId},'DELIVERING')">✕ Giao thất bại (khách không nhận)</button>
          </c:if>
        </div>
      </c:if>

      <c:if test="${ds == 'COMPLETED' && not empty o.proofImage}">
        <img class="proof-view" src="${ctx}${o.proofImage}" alt="Bằng chứng giao hàng" loading="lazy">
      </c:if>
    </div>
  </div>
</c:forEach>
</div>

<div class="toast" id="toast"></div>

<button type="button" class="fab" id="chatFab">💬</button>
<div class="sheet" id="chatSheet">
  <div class="sheet-bg" onclick="closeChat()"></div>
  <div class="sheet-body">
    <div class="sheet-hd">Kênh nội bộ PureNut <button type="button" onclick="closeChat()">✕</button></div>
    <div class="msgs" id="chatMsgs"></div>
    <div class="chat-in">
      <input type="text" id="chatInput" placeholder="Nhắn cho điều phối..." maxlength="500">
      <button type="button" onclick="sendChat()">➤</button>
    </div>
  </div>
</div>

  </div> <!-- .shipper-main -->
</div> <!-- .shipper-layout -->

<script>
var CTX='${ctx}',CSRF='${sessionScope._csrf}';
var lastChatId=0,chatTimer=null;

/* ===== Helpers ===== */
function toast(msg){var t=document.getElementById('toast');t.textContent=msg;t.classList.add('show');setTimeout(function(){t.classList.remove('show')},2600)}
function esc(s){var d=document.createElement('div');d.textContent=s;return d.innerHTML}
function post(url,data,cb){
  var p=new URLSearchParams();p.append('_csrf',CSRF);
  for(var k in data)p.append(k,data[k]);
  fetch(CTX+url,{method:'POST',body:p,headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'}})
    .then(function(r){return r.json()}).then(cb)
    .catch(function(){toast('Mất kết nối — thử lại')});
}
function addRipple(btn,e){
  var r=document.createElement('span');r.className='ripple';
  var rect=btn.getBoundingClientRect(),size=Math.max(rect.width,rect.height);
  var x=(e&&e.clientX?e.clientX-rect.left:rect.width/2)-size/2;
  var y=(e&&e.clientY?e.clientY-rect.top:rect.height/2)-size/2;
  r.style.cssText='width:'+size+'px;height:'+size+'px;left:'+x+'px;top:'+y+'px';
  btn.appendChild(r);setTimeout(function(){r.remove()},600);
}
document.addEventListener('click',function(e){var b=e.target.closest('.big-btn');if(b)addRipple(b,e)});

/* ===== State machine ===== */
window.transition=function(btn,orderId,from,to){
  if(btn)btn.disabled=true;
  post('/shipper/cap-nhat',{orderId:orderId,from:from,to:to},function(d){
    if(d.ok){toast('Đã cập nhật ✓');setTimeout(function(){location.reload()},500)}
    else{
      if(btn)btn.disabled=false;
      toast(d.msg||'Không cập nhật được');
      // Reset nút vuốt nếu giao dịch thất bại và bị kẹt chữ ĐANG CHỐT ĐƠN
      var sw=document.getElementById('swipe'+orderId);
      if(sw){
        sw.classList.remove('done');
        var knob=sw.querySelector('.swipe-knob'),fill=sw.querySelector('.swipe-fill'),txt=sw.querySelector('.swipe-txt');
        if(knob)knob.style.left='5px';
        if(fill)fill.style.width='0';
        if(txt)txt.textContent='VUỐT ĐỂ HOÀN THÀNH ĐƠN →';
      }
    }
  });
};
window.markFail=function(orderId,from){
  if(!confirm('Xác nhận GIAO THẤT BẠI đơn #'+orderId+'?\nĐơn sẽ chuyển về điều phối xử lý.'))return;
  post('/shipper/cap-nhat',{orderId:orderId,from:from,to:'FAILED'},function(d){
    if(d.ok){toast('Đã báo thất bại');setTimeout(function(){location.reload()},500)}
    else toast(d.msg||'Không cập nhật được');
  });
};

/* ===== Proof upload (camera) ===== */
window.uploadProof=function(orderId,input){
  if(!input.files||!input.files[0])return;
  var f=input.files[0];
  if(f.size>5*1024*1024){toast('Ảnh quá lớn (tối đa 5MB)');return}
  document.getElementById('camTxt'+orderId).textContent='Đang tải ảnh...';
  var fd=new FormData();fd.append('_csrf',CSRF);fd.append('orderId',orderId);fd.append('proofImage',f);
  fetch(CTX+'/shipper/proof',{method:'POST',body:fd,headers:{'X-Requested-With':'XMLHttpRequest'}})
    .then(function(r){return r.json()})
    .then(function(d){
      if(d.ok){
        var img=document.getElementById('thumb'+orderId);
        img.src=CTX+d.path;img.classList.add('show');
        document.getElementById('camTxt'+orderId).textContent='Chụp lại ảnh';
        document.getElementById('swipe'+orderId).classList.remove('locked');
        toast('Đã lưu ảnh ✓ — Vuốt để chốt đơn');
      }else{
        document.getElementById('camTxt'+orderId).textContent='Chụp ảnh xác nhận';
        toast(d.msg||'Không tải được ảnh');
      }
    }).catch(function(){
      document.getElementById('camTxt'+orderId).textContent='Chụp ảnh xác nhận';
      toast('Mất kết nối — thử lại');
    });
};

/* ===== Swipe to complete ===== */
document.querySelectorAll('.swipe').forEach(function(sw){
  var knob=sw.querySelector('.swipe-knob'),fill=sw.querySelector('.swipe-fill');
  var dragging=false,startX=0,maxX=0;
  function down(e){
    if(sw.classList.contains('locked')||sw.classList.contains('done'))return;
    dragging=true;startX=(e.touches?e.touches[0].clientX:e.clientX);
    maxX=sw.offsetWidth-knob.offsetWidth-10;knob.style.transition='none';
  }
  function move(e){
    if(!dragging)return;
    var x=(e.touches?e.touches[0].clientX:e.clientX)-startX;
    x=Math.max(0,Math.min(x,maxX));
    knob.style.left=(5+x)+'px';fill.style.width=(x+59)+'px';
    if(e.cancelable)e.preventDefault();
  }
  function up(e){
    if(!dragging)return;dragging=false;knob.style.transition='left .25s cubic-bezier(.2,.8,.3,1)';
    var x=parseFloat(knob.style.left||5)-5;
    if(x>=maxX*0.88){
      sw.classList.add('done');knob.style.left=(5+maxX)+'px';
      sw.querySelector('.swipe-txt').textContent='ĐANG CHỐT ĐƠN...';
      transition(null,parseInt(sw.dataset.order),'DELIVERING','COMPLETED');
    }else{knob.style.left='5px';fill.style.width='0'}
  }
  sw.addEventListener('touchstart',down,{passive:true});
  sw.addEventListener('touchmove',move,{passive:false});
  sw.addEventListener('touchend',up);
  sw.addEventListener('mousedown',down);
  document.addEventListener('mousemove',move);
  document.addEventListener('mouseup',up);
});

/* ===== Toggle ACTIVE/OFFLINE ===== */
document.getElementById('statusToggle').addEventListener('click',function(){
  var btn=this,cur=btn.dataset.status,next=cur==='ACTIVE'?'OFFLINE':'ACTIVE';
  post('/shipper/trang-thai',{status:next},function(d){
    if(d.ok){
      btn.dataset.status=next;
      btn.className='hd-toggle '+(next==='ACTIVE'?'on':'off');
      btn.textContent=next==='ACTIVE'?'● Đang nhận đơn':'○ Tạm nghỉ';
      toast(next==='ACTIVE'?'Bật nhận đơn ✓':'Đã tạm nghỉ');
    }else toast(d.msg||'Lỗi');
  });
});

/* ===== Chat nội bộ ===== */
function renderChat(list,append){
  var box=document.getElementById('chatMsgs');
  if(!append)box.innerHTML='';
  list.forEach(function(m){
    if(m.id>lastChatId)lastChatId=m.id;
    var d=document.createElement('div');
    d.className='m '+(m.mine?'mine':'them');
    d.innerHTML=(m.mine?'':'<div class="who">'+esc(m.name)+'</div>')+esc(m.msg)+'<small>'+esc(m.time)+'</small>';
    box.appendChild(d);
  });
  if(list.length)box.scrollTop=box.scrollHeight;
}
function pollChat(){
  fetch(CTX+'/staff/chat?after='+lastChatId,{headers:{'X-Requested-With':'XMLHttpRequest'}})
    .then(function(r){return r.json()})
    .then(function(d){if(d.ok)renderChat(d.items,lastChatId>0)})
    .catch(function(){});
}
document.getElementById('chatFab').addEventListener('click',function(){
  document.getElementById('chatSheet').classList.add('show');
  lastChatId=0;pollChat();
  chatTimer=setInterval(pollChat,5000);
});
window.closeChat=function(){
  document.getElementById('chatSheet').classList.remove('show');
  if(chatTimer)clearInterval(chatTimer);
};
window.sendChat=function(){
  var i=document.getElementById('chatInput'),v=i.value.trim();
  if(!v)return;i.value='';
  post('/staff/chat',{message:v},function(d){if(d.ok)pollChat();else toast(d.msg||'Không gửi được')});
};
document.getElementById('chatInput').addEventListener('keydown',function(e){if(e.key==='Enter')sendChat()});

/* ===== Tabs / Filtering Logic ===== */
(function() {
  var currentTab = 'active';

  function filterOrders() {
    var cards = document.querySelectorAll('.wrap .card');
    var visibleCount = 0;

    cards.forEach(function(card) {
      var status = card.getAttribute('data-status');
      var isToday = card.getAttribute('data-today') === 'true';
      var show = false;

      if (currentTab === 'active') {
        show = (status === 'ASSIGNED' || status === 'PICKING_UP' || status === 'DELIVERING');
      } else if (currentTab === 'today') {
        show = isToday;
      } else if (currentTab === 'completed') {
        show = (status === 'COMPLETED' || status === 'FAILED');
      }

      if (show) {
        card.style.display = '';
        visibleCount++;
      } else {
        card.style.display = 'none';
      }
    });

    // Handle empty state
    var emptyState = document.getElementById('emptyState');
    var noOrders = document.getElementById('noOrdersAtAll');
    if (noOrders) {
      if (currentTab === 'active') {
        noOrders.style.display = (cards.length === 0) ? '' : 'none';
        emptyState.style.display = 'none';
      } else {
        noOrders.style.display = 'none';
        emptyState.style.display = (visibleCount === 0) ? '' : 'none';
      }
    } else {
      emptyState.style.display = (visibleCount === 0) ? '' : 'none';
    }
  }

  function updateBadgeCounts() {
    var cards = document.querySelectorAll('.wrap .card');
    var activeCnt = 0;
    var todayCnt = 0;
    var completedCnt = 0;

    cards.forEach(function(card) {
      var status = card.getAttribute('data-status');
      var isToday = card.getAttribute('data-today') === 'true';

      if (status === 'ASSIGNED' || status === 'PICKING_UP' || status === 'DELIVERING') {
        activeCnt++;
      }
      if (isToday) {
        todayCnt++;
      }
      if (status === 'COMPLETED' || status === 'FAILED') {
        completedCnt++;
      }
    });

    // Update all badges
    document.querySelectorAll('.badge-active').forEach(function(el) { el.textContent = activeCnt; });
    document.querySelectorAll('.badge-today').forEach(function(el) { el.textContent = todayCnt; });
    document.querySelectorAll('.badge-completed').forEach(function(el) { el.textContent = completedCnt; });
    
    // Also update stats if they exist
    var statActive = document.querySelector('.stat b');
    if (statActive) {
      statActive.textContent = activeCnt;
      var statCompleted = document.querySelectorAll('.stat b')[1];
      if (statCompleted) statCompleted.textContent = completedCnt;
    }
  }

  function switchTab(tabId) {
    currentTab = tabId;
    
    // Update active class on Sidebar items
    document.querySelectorAll('.sb-item').forEach(function(btn) {
      if (btn.getAttribute('data-tab') === tabId) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });

    // Update active class on Mobile tabs
    document.querySelectorAll('.m-tab').forEach(function(btn) {
      if (btn.getAttribute('data-tab') === tabId) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });

    filterOrders();
  }

  // Bind click event listeners
  document.querySelectorAll('.sb-item, .m-tab').forEach(function(btn) {
    btn.addEventListener('click', function() {
      var tabId = this.getAttribute('data-tab');
      switchTab(tabId);
    });
  });

  // Initial runs
  updateBadgeCounts();
  filterOrders();

  // Expose function globally
  window.refreshTabFilters = function() {
    updateBadgeCounts();
    filterOrders();
  };
})();
</script>
</body>
</html>
