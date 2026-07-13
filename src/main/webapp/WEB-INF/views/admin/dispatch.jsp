<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
/* ── Stats ── */
.dp-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:28px}
.dp-stat{background:var(--admin-surface);border-radius:16px;padding:22px;text-align:center;border:1px solid var(--admin-border);box-shadow:0 6px 18px -10px rgba(43,54,116,.15);transition:transform .2s}
.dp-stat:hover{transform:translateY(-2px)}
.dp-stat b{display:block;font-family:var(--fd);font-size:32px;margin-bottom:4px}
.dp-stat.amber b{color:var(--status-pending)}.dp-stat.blue b{color:var(--admin-primary)}.dp-stat.green b{color:var(--status-done)}.dp-stat.red b{color:var(--admin-red)}
.dp-stat span{font-size:12px;color:var(--admin-text-light);font-weight:600}

/* ── Shipper Command Center ── */
.shipper-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px;margin-bottom:8px}
.shipper-card{background:var(--admin-surface);border-radius:16px;padding:18px;border:1.5px solid var(--admin-border);transition:transform .2s,box-shadow .2s;position:relative;overflow:hidden}
.shipper-card:hover{transform:translateY(-2px);box-shadow:0 12px 28px -12px rgba(43,54,116,.2)}
.shipper-card.online{border-color:rgba(18,183,106,.35)}
.shipper-card.offline{opacity:.7}
.shipper-card .sc-status{position:absolute;top:14px;right:14px;width:10px;height:10px;border-radius:50%;border:2px solid var(--admin-surface)}
.shipper-card.online .sc-status{background:var(--status-done);box-shadow:0 0 0 3px rgba(18,183,106,.2)}
.shipper-card.offline .sc-status{background:var(--admin-text-light)}
.sc-avatar{width:48px;height:48px;border-radius:14px;background:linear-gradient(135deg,var(--admin-primary),var(--status-shipping));color:#fff;display:flex;align-items:center;justify-content:center;font-family:var(--fd);font-size:18px;font-weight:700;margin-bottom:12px}
.sc-name{font-weight:700;font-size:14.5px;margin-bottom:2px;color:var(--admin-text)}
.sc-phone{font-size:12px;color:var(--admin-text-light);margin-bottom:10px}
.sc-metrics{display:flex;gap:8px}
.sc-metric{flex:1;text-align:center;padding:8px 4px;background:var(--admin-bg);border-radius:10px}
.sc-metric b{display:block;font-family:var(--fd);font-size:18px;color:var(--admin-text)}
.sc-metric small{font-size:10px;color:var(--admin-text-light);font-weight:600}
.sc-plate{font-size:11px;color:var(--admin-text-light);margin-top:8px;display:flex;align-items:center;gap:4px}
.sc-plate i{font-size:10px}

/* ── Section titles ── */
.dp-section-title{font-family:var(--fd);font-size:18px;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:10px;color:var(--admin-text)}
.dp-badge-n{font-size:11px;font-weight:800;background:var(--admin-red);color:#fff;min-width:22px;height:22px;border-radius:99px;display:inline-flex;align-items:center;justify-content:center;padding:0 7px}

/* ── Order cards (replacing rows) ── */
.order-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:14px}
.order-card{background:var(--admin-bg);border-radius:14px;padding:16px;border:1px solid var(--admin-border);transition:transform .15s}
.order-card:hover{transform:translateY(-1px)}
.oc-head{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:10px}
.oc-id{font-weight:800;font-size:14px;color:var(--admin-primary)}
.oc-amt{font-family:var(--fd);font-weight:700;color:var(--admin-red);font-size:15px}
.oc-customer{margin-bottom:8px}
.oc-customer b{font-size:13.5px;display:block;color:var(--admin-text)}
.oc-customer small{font-size:12px;color:var(--admin-text-light);display:block;margin-top:2px;line-height:1.4}
.oc-meta{display:flex;gap:8px;align-items:center;flex-wrap:wrap;font-size:12px;color:var(--admin-text-light);margin-bottom:10px}
.oc-meta i{font-size:10px}
.oc-actions{display:flex;gap:8px;flex-wrap:wrap;align-items:center}
.oc-actions select{border:1.5px solid var(--admin-border);border-radius:10px;padding:8px 10px;font-size:13px;background:#fff;min-width:140px;flex:1}
.dp-b{padding:9px 16px;border-radius:11px;font-weight:700;font-size:12.5px;border:none;cursor:pointer;transition:transform .15s,box-shadow .2s;display:inline-flex;align-items:center;gap:6px}
.dp-b:active{transform:scale(.95)}
.dp-b.assign{background:var(--admin-primary);color:#fff;box-shadow:0 6px 14px -6px rgba(27,79,158,.5)}
.dp-b.confirm{background:var(--status-done);color:#fff;box-shadow:0 6px 14px -6px rgba(18,183,106,.5)}
.dp-b.note{background:var(--admin-bg);border:1px solid var(--admin-border);color:var(--admin-text)}
.dp-b.ok{background:var(--status-done);color:#fff;box-shadow:0 6px 14px -6px rgba(18,183,106,.5)}
.dp-b.no{background:rgba(238,93,80,.1);color:var(--admin-red)}
.dp-pill{font-size:11px;font-weight:700;padding:5px 12px;border-radius:99px;display:inline-flex;align-items:center;gap:5px}
.dp-pill.shipping{background:rgba(122,90,248,.1);color:var(--status-shipping)}
.dp-pill.cod{background:rgba(245,165,36,.1);color:var(--status-pending)}
.dp-pill.transfer{background:rgba(57,101,255,.1);color:var(--status-confirmed)}
.dp-muted{color:var(--admin-text-light);font-size:13.5px;padding:18px 0;text-align:center}
.dp-reason{font-size:12.5px;background:rgba(245,165,36,.08);border-left:3px solid var(--status-pending);border-radius:8px;padding:8px 12px;margin-top:6px}
.dp-recommend{font-size:10px;color:var(--status-done);font-weight:700;letter-spacing:.04em}

/* ── IP config (inline in shipper card) ── */
.sc-config{margin-top:10px;padding-top:10px;border-top:1px dashed var(--admin-border);display:none}
.shipper-card.expanded .sc-config{display:block}
.sc-config input{width:100%;border:1.5px solid var(--admin-border);border-radius:8px;padding:6px 10px;font-size:12px;margin-bottom:6px;background:#fff}
.sc-config-btns{display:flex;gap:6px}
.sc-config-btns button{flex:1}
.sc-toggle{font-size:11px;color:var(--admin-primary);cursor:pointer;border:none;background:none;font-weight:700;margin-top:6px;padding:0}

/* ── Chat dock ── */
.chat-fab{position:fixed;right:28px;bottom:28px;z-index:90;width:54px;height:54px;border-radius:50%;background:var(--admin-primary);color:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 12px 28px -10px rgba(27,79,158,.65);transition:transform .25s;border:none;cursor:pointer}
.chat-fab:hover{transform:translateY(-3px) scale(1.05)}
.dock{position:fixed;right:28px;bottom:94px;z-index:91;width:min(380px,calc(100vw - 32px));height:min(480px,70vh);background:var(--admin-surface);border-radius:18px;box-shadow:0 24px 60px -16px rgba(14,46,92,.35);border:1px solid var(--admin-border);display:none;flex-direction:column;overflow:hidden}
.dock.show{display:flex}
.dock-hd{background:linear-gradient(135deg,var(--admin-sidebar),var(--admin-sidebar-2));color:#fff;padding:14px 18px;display:flex;justify-content:space-between;align-items:center}
.dock-hd b{font-family:var(--fd);font-size:15px}
.dock-x{color:#fff;font-size:18px;width:28px;height:28px;border-radius:50%;background:rgba(255,255,255,.15);display:flex;align-items:center;justify-content:center;border:none;cursor:pointer}
.msgs{flex:1;overflow-y:auto;padding:14px 16px;display:flex;flex-direction:column;gap:9px}
.m{max-width:84%;padding:8px 12px;border-radius:14px;font-size:13px;line-height:1.5}
.m small{display:block;font-size:10px;opacity:.65;margin-top:2px}
.m.them{background:var(--admin-bg);border-bottom-left-radius:4px;align-self:flex-start}
.m.mine{background:var(--admin-primary);color:#fff;border-bottom-right-radius:4px;align-self:flex-end}
.m .who2{font-size:10.5px;font-weight:700;color:var(--admin-primary);margin-bottom:1px}
.m.mine .who2{display:none}
.send-row{display:flex;gap:8px;padding:10px 14px;border-top:1px solid var(--admin-border)}
.send-row input{flex:1;border:1.5px solid var(--admin-border);border-radius:99px;padding:9px 14px;font-size:13.5px;font-family:inherit;background:#fff}
.send-row input:focus{outline:none;border-color:var(--admin-primary)}
.send-row button{width:38px;height:38px;border-radius:50%;background:var(--admin-primary);color:#fff;display:flex;align-items:center;justify-content:center;flex-shrink:0;border:none;cursor:pointer}

/* ── Notes modal ── */
.sheet{position:fixed;inset:0;z-index:100;background:rgba(14,46,92,.5);backdrop-filter:blur(3px);display:none;align-items:center;justify-content:center;padding:18px}
.sheet.show{display:flex}
.sheet-card{background:var(--admin-surface);border-radius:18px;width:100%;max-width:460px;max-height:80vh;display:flex;flex-direction:column;overflow:hidden;box-shadow:0 24px 60px -16px rgba(14,46,92,.35)}

@media(max-width:900px){
  .dp-stats{grid-template-columns:1fr 1fr;gap:10px}
  .shipper-grid{grid-template-columns:1fr 1fr}
  .order-grid{grid-template-columns:1fr}
}
@media(max-width:560px){
  .shipper-grid{grid-template-columns:1fr}
}
</style>

<!-- Stats -->
<div class="dp-stats">
  <div class="dp-stat amber"><b>${fn:length(newOrders) + 0}</b><span>Đơn mới chờ xác nhận</span></div>
  <div class="dp-stat blue"><b>${fn:length(needAssign) + 0}</b><span>Cần gán shipper</span></div>
  <div class="dp-stat green"><b>${fn:length(shipping) + 0}</b><span>Đang giao</span></div>
  <div class="dp-stat red"><b>${fn:length(pendingCancel) + 0}</b><span>Chờ duyệt hủy</span></div>
</div>

<!-- Shipper Command Center -->
<div class="card">
  <div class="dp-section-title"><i class="fa-solid fa-headset" style="color:var(--admin-primary)"></i> Trung tâm điều phối Shipper
    <c:if test="${not empty shipperProfiles}">
      <span style="font-size:12px;font-weight:500;color:var(--admin-text-light);margin-left:auto">
        <c:set var="onlineCount" value="0"/>
        <c:forEach var="s" items="${shipperProfiles}"><c:if test="${s.status == 'ACTIVE'}"><c:set var="onlineCount" value="${onlineCount + 1}"/></c:if></c:forEach>
        ${onlineCount} online / ${fn:length(shipperProfiles)} tổng
      </span>
    </c:if>
  </div>
  <div class="shipper-grid">
    <c:forEach var="s" items="${shipperProfiles}">
      <div class="shipper-card ${s.status == 'ACTIVE' ? 'online' : 'offline'}" id="sc${s.shipperId}">
        <div class="sc-status"></div>
        <div class="sc-avatar">${fn:substring(s.fullName, 0, 1)}</div>
        <div class="sc-name"><c:out value="${s.fullName}"/></div>
        <div class="sc-phone"><i class="fa-solid fa-phone" style="font-size:10px;margin-right:3px"></i><c:out value="${empty s.phone ? '—' : s.phone}"/></div>
        <div class="sc-metrics">
          <div class="sc-metric"><b>${s.activeOrders}</b><small>Đang giao</small></div>
          <div class="sc-metric"><b>${s.completedToday}</b><small>Hoàn thành</small></div>
        </div>
        <c:if test="${not empty s.vehiclePlate}">
          <div class="sc-plate"><i class="fa-solid fa-motorcycle"></i> <c:out value="${s.vehiclePlate}"/></div>
        </c:if>
        <button class="sc-toggle" onclick="toggleConfig(${s.shipperId})"><i class="fa-solid fa-gear" style="font-size:10px"></i> Cấu hình IP &amp; biển số</button>
        <div class="sc-config">
          <input type="text" id="plate${s.shipperId}" value="${fn:escapeXml(s.vehiclePlate)}" placeholder="Biển số xe">
          <input type="text" id="ip${s.shipperId}" value="${fn:escapeXml(s.allowedIp)}" placeholder="IP nội bộ (CSV) — trống = không khóa">
          <div class="sc-config-btns">
            <button class="dp-b assign" style="font-size:11px;padding:7px 12px" onclick="grantIp(${s.shipperId})"><i class="fa-solid fa-floppy-disk"></i> Lưu</button>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
  <c:if test="${empty shipperProfiles}"><div class="dp-muted">Chưa có shipper nào. Tạo tài khoản ở mục <a href="${pageContext.request.contextPath}/admin/nhan-su" style="color:var(--admin-primary);font-weight:700">Quản lý Nhân sự</a>.</div></c:if>
</div>

<!-- Đơn mới chờ xác nhận — quick confirm -->
<div class="card">
  <div class="dp-section-title"><i class="fa-solid fa-clock" style="color:var(--status-pending)"></i> Đơn mới chờ xác nhận
    <c:if test="${not empty newOrders}"><span class="dp-badge-n" style="background:var(--status-pending)">${fn:length(newOrders)}</span></c:if>
  </div>
  <div class="order-grid">
    <c:forEach var="o" items="${newOrders}">
      <div class="order-card" id="new${o.orderId}">
        <div class="oc-head">
          <span class="oc-id">#${o.orderId}</span>
          <span class="oc-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        </div>
        <div class="oc-customer">
          <b><c:out value="${o.fullName}"/></b>
          <small><c:out value="${o.address}"/></small>
        </div>
        <div class="oc-meta">
          <span class="dp-pill ${o.paymentMethod == 'COD' ? 'cod' : 'transfer'}">${o.paymentMethod == 'COD' ? 'COD' : 'Chuyển khoản'}</span>
          <span><i class="fa-regular fa-clock"></i> <fmt:formatDate value="${o.createdAt}" pattern="HH:mm dd/MM"/></span>
        </div>
        <div class="oc-actions">
          <button class="dp-b confirm" onclick="confirmOrder(${o.orderId})"><i class="fa-solid fa-check"></i> Xác nhận đơn</button>
          <button class="dp-b note" onclick="openNotes(${o.orderId})"><i class="fa-regular fa-comment"></i></button>
        </div>
      </div>
    </c:forEach>
  </div>
  <c:if test="${empty newOrders}"><div class="dp-muted">Không có đơn mới.</div></c:if>
</div>

<!-- Cần gán shipper — smart assignment -->
<div class="card">
  <div class="dp-section-title"><i class="fa-solid fa-truck-fast" style="color:var(--admin-primary)"></i> Cần gán shipper
    <c:if test="${not empty needAssign}"><span class="dp-badge-n">${fn:length(needAssign)}</span></c:if>
  </div>
  <div class="order-grid">
    <c:forEach var="o" items="${needAssign}">
      <div class="order-card" id="asg${o.orderId}">
        <div class="oc-head">
          <span class="oc-id">#${o.orderId}</span>
          <span class="oc-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        </div>
        <div class="oc-customer">
          <b><c:out value="${o.fullName}"/> &middot; <c:out value="${o.phone}"/></b>
          <small><c:out value="${o.address}"/></small>
        </div>
        <div class="oc-actions">
          <select id="sel${o.orderId}">
            <option value="">— Chọn shipper —</option>
            <c:forEach var="s" items="${shipperProfiles}">
              <c:if test="${s.status == 'ACTIVE'}">
                <option value="${s.shipperId}"><c:out value="${s.fullName}"/> (${s.activeOrders} đơn)</option>
              </c:if>
            </c:forEach>
          </select>
          <button class="dp-b assign" onclick="assign(${o.orderId})"><i class="fa-solid fa-paper-plane"></i> Gán</button>
          <button class="dp-b note" onclick="openNotes(${o.orderId})"><i class="fa-regular fa-comment"></i></button>
        </div>
      </div>
    </c:forEach>
  </div>
  <c:if test="${empty needAssign}"><div class="dp-muted">Không có đơn nào chờ gán.</div></c:if>
</div>

<!-- Đang giao -->
<div class="card">
  <div class="dp-section-title"><i class="fa-solid fa-motorcycle" style="color:var(--status-shipping)"></i> Đang giao
    <c:if test="${not empty shipping}"><span class="dp-badge-n" style="background:var(--status-done)">${fn:length(shipping)}</span></c:if>
  </div>
  <div class="order-grid">
    <c:forEach var="o" items="${shipping}">
      <div class="order-card">
        <div class="oc-head">
          <span class="oc-id">#${o.orderId}</span>
          <span class="oc-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        </div>
        <div class="oc-customer">
          <b><c:out value="${o.fullName}"/></b>
          <small><c:out value="${o.address}"/></small>
        </div>
        <div class="oc-meta">
          <span class="dp-pill shipping"><i class="fa-solid fa-motorcycle"></i> <c:out value="${not empty o.shipperName ? o.shipperName : 'Shipper'}"/></span>
          <c:if test="${not empty o.deliveryStatus}">
            <span class="dp-pill transfer">${o.deliveryStatus}</span>
          </c:if>
        </div>
        <div class="oc-actions">
          <button class="dp-b note" onclick="openNotes(${o.orderId})"><i class="fa-regular fa-comment"></i> Ghi chú</button>
        </div>
      </div>
    </c:forEach>
  </div>
  <c:if test="${empty shipping}"><div class="dp-muted">Chưa có đơn đang giao.</div></c:if>
</div>

<!-- Chờ duyệt hủy -->
<div class="card">
  <div class="dp-section-title"><i class="fa-solid fa-triangle-exclamation" style="color:var(--admin-red)"></i> Yêu cầu hủy đơn
    <c:if test="${not empty pendingCancel}"><span class="dp-badge-n">${fn:length(pendingCancel)}</span></c:if>
  </div>
  <div class="order-grid">
    <c:forEach var="o" items="${pendingCancel}">
      <div class="order-card" id="pc${o.orderId}">
        <div class="oc-head">
          <span class="oc-id">#${o.orderId}</span>
          <span class="oc-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        </div>
        <div class="oc-customer">
          <b><c:out value="${o.fullName}"/> &middot; <c:out value="${o.phone}"/></b>
        </div>
        <c:if test="${not empty o.cancelReason}">
          <div class="dp-reason"><i class="fa-solid fa-quote-left" style="font-size:10px;margin-right:4px;opacity:.5"></i><c:out value="${o.cancelReason}"/></div>
        </c:if>
        <div class="oc-actions" style="margin-top:10px">
          <button class="dp-b ok" onclick="cancelAct(${o.orderId},'approve')"><i class="fa-solid fa-check"></i> Duyệt hủy</button>
          <button class="dp-b no" onclick="cancelAct(${o.orderId},'reject')"><i class="fa-solid fa-xmark"></i> Từ chối</button>
        </div>
      </div>
    </c:forEach>
  </div>
  <c:if test="${empty pendingCancel}"><div class="dp-muted">Không có yêu cầu hủy nào.</div></c:if>
</div>

<!-- Chat dock -->
<button class="chat-fab" onclick="toggleChat()" aria-label="Chat nội bộ">
  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
</button>
<div class="dock" id="chatDock">
  <div class="dock-hd"><b>Chat nội bộ PureNut</b><button class="dock-x" onclick="toggleChat()">×</button></div>
  <div class="msgs" id="chatMsgs"></div>
  <div class="send-row">
    <input type="text" id="chatInput" maxlength="500" placeholder="Nhắn cho đội giao hàng…">
    <button onclick="sendChat()" aria-label="Gửi"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg></button>
  </div>
</div>

<!-- Notes modal -->
<div class="sheet" id="noteSheet">
  <div class="sheet-card">
    <div class="dock-hd"><b id="noteTitle">Ghi chú đơn</b><button class="dock-x" onclick="document.getElementById('noteSheet').classList.remove('show')">×</button></div>
    <div class="msgs" id="noteMsgs" style="min-height:200px"></div>
    <div class="send-row">
      <input type="text" id="noteInput" maxlength="500" placeholder="VD: Giao trước 17h, gọi trước khi đến…">
      <button onclick="sendNote()" aria-label="Gửi"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg></button>
    </div>
  </div>
</div>

<script>
var CTX='${pageContext.request.contextPath}',CSRF='${sessionScope._csrf}';
var curOrder=0,lastChatId=0,chatTimer=null;

function ajax(url,data,cb){
  var opt={headers:{'X-Requested-With':'XMLHttpRequest'}};
  if(data){var p=new URLSearchParams();p.append('_csrf',CSRF);for(var k in data)p.append(k,data[k]);opt.method='POST';opt.body=p;opt.headers['Content-Type']='application/x-www-form-urlencoded'}
  fetch(CTX+url,opt).then(function(r){return r.json()}).then(cb).catch(function(){});
}
function esc(s){var d=document.createElement('div');d.textContent=s;return d.innerHTML}
function roleTag(r){return r==='ADMIN'?'Admin':'Shipper'}
function render(list,box,append){
  if(!append)box.innerHTML='';
  list.forEach(function(m){
    var d=document.createElement('div');
    d.className='m '+(m.mine?'mine':'them');
    d.innerHTML=(m.mine?'':'<div class="who2">'+esc(m.name)+' · '+roleTag(m.role)+'</div>')+esc(m.msg)+'<small>'+esc(m.time)+'</small>';
    box.appendChild(d);
  });
  box.scrollTop=box.scrollHeight;
}
function fadeOut(el){el.style.opacity='.4';el.querySelectorAll('button,select').forEach(function(x){x.disabled=true})}

window.confirmOrder=function(orderId){
  ajax('/admin/dieu-phoi/xac-nhan',{orderId:orderId},function(d){
    if(d.ok){fadeOut(document.getElementById('new'+orderId));setTimeout(function(){location.reload()},600)}
    else alert(d.msg||'Không xác nhận được');
  });
};

window.assign=function(orderId){
  var sel=document.getElementById('sel'+orderId);
  if(!sel.value){alert('Chọn shipper trước nhé!');return}
  ajax('/admin/dieu-phoi/gan-don',{orderId:orderId,shipperId:sel.value},function(d){
    if(d.ok){fadeOut(document.getElementById('asg'+orderId));setTimeout(function(){location.reload()},600)}
    else alert(d.msg||'Không gán được');
  });
};

window.cancelAct=function(orderId,action){
  if(!confirm(action==='approve'?'Duyệt hủy đơn #'+orderId+' và hoàn kho?':'Từ chối yêu cầu hủy đơn #'+orderId+'?'))return;
  ajax('/admin/dieu-phoi/duyet-huy',{orderId:orderId,action:action},function(d){
    if(d.ok)location.reload();else alert(d.msg||'Không xử lý được');
  });
};

window.grantIp=function(shipperId){
  var ip=document.getElementById('ip'+shipperId).value.trim();
  var plate=document.getElementById('plate'+shipperId).value.trim();
  ajax('/admin/dieu-phoi/cap-ip',{shipperId:shipperId,allowedIp:ip,vehiclePlate:plate},function(d){
    if(d.ok)alert('Đã lưu cấu hình shipper #'+shipperId);
    else alert(d.msg||'Không lưu được');
  });
};

window.toggleConfig=function(shipperId){
  document.getElementById('sc'+shipperId).classList.toggle('expanded');
};

window.openNotes=function(orderId){
  curOrder=orderId;
  document.getElementById('noteTitle').textContent='Ghi chú đơn #'+orderId;
  document.getElementById('noteSheet').classList.add('show');
  loadNotes();
};
function loadNotes(){ajax('/staff/notes?orderId='+curOrder,null,function(d){if(d.ok)render(d.items,document.getElementById('noteMsgs'))})}
window.sendNote=function(){
  var i=document.getElementById('noteInput'),v=i.value.trim();if(!v)return;i.value='';
  ajax('/staff/notes',{orderId:curOrder,message:v},function(){loadNotes()});
};

window.toggleChat=function(){
  var dk=document.getElementById('chatDock');
  var show=dk.classList.toggle('show');
  if(show){lastChatId=0;pollChat();clearInterval(chatTimer);chatTimer=setInterval(pollChat,4000)}
  else clearInterval(chatTimer);
};
function pollChat(){
  ajax('/staff/chat?after='+lastChatId,null,function(d){
    if(!d.ok||!d.items.length)return;
    render(d.items,document.getElementById('chatMsgs'),lastChatId>0);
    lastChatId=d.items[d.items.length-1].id;
  });
}
window.sendChat=function(){
  var i=document.getElementById('chatInput'),v=i.value.trim();if(!v)return;i.value='';
  ajax('/staff/chat',{message:v},function(){pollChat()});
};

document.getElementById('noteInput').addEventListener('keydown',function(e){if(e.key==='Enter')sendNote()});
document.getElementById('chatInput').addEventListener('keydown',function(e){if(e.key==='Enter')sendChat()});

// Auto-select recommended shipper (least active orders)
document.querySelectorAll('[id^="sel"]').forEach(function(sel){
  var opts=sel.querySelectorAll('option[value]');
  if(opts.length===0)return;
  var best=null,minLoad=999;
  opts.forEach(function(o){
    if(!o.value)return;
    var m=o.textContent.match(/\((\d+) đơn\)/);
    var load=m?parseInt(m[1]):0;
    if(load<minLoad){minLoad=load;best=o}
  });
  if(best){best.selected=true;best.parentElement.previousElementSibling&&(0)}
});
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
