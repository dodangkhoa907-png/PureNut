<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
.dp-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px}
.dp-stat{background:var(--admin-surface);border-radius:16px;padding:20px;text-align:center;border:1px solid var(--admin-border);box-shadow:0 6px 18px -10px rgba(43,54,116,.15);transition:transform .2s}
.dp-stat:hover{transform:translateY(-2px)}
.dp-stat b{display:block;font-family:var(--fd);font-size:30px;margin-bottom:4px}
.dp-stat.blue b{color:var(--admin-primary)}.dp-stat.amber b{color:var(--status-pending)}.dp-stat.green b{color:var(--status-done)}.dp-stat.red b{color:var(--admin-red)}
.dp-stat span{font-size:12px;color:var(--admin-text-light);font-weight:600}

.dp-row{display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px dashed var(--admin-border);flex-wrap:wrap}
.dp-row:last-child{border-bottom:none}
.dp-oid{font-weight:800;font-size:14px;min-width:70px;color:var(--admin-primary)}
.dp-who{flex:1;min-width:180px}
.dp-who b{font-size:13.5px;display:block;color:var(--admin-text)}
.dp-who small{font-size:12px;color:var(--admin-text-light)}
.dp-amt{font-family:var(--fd);font-weight:700;color:var(--admin-red);font-size:15px}
.dp-row select{border:1.5px solid var(--admin-border);border-radius:10px;padding:8px 10px;font-size:13px;background:#fff;min-width:150px}
.dp-b{padding:9px 15px;border-radius:11px;font-weight:700;font-size:12.5px;border:none;cursor:pointer;transition:transform .15s,box-shadow .2s}
.dp-b:active{transform:scale(.95)}
.dp-b.assign{background:var(--admin-primary);color:#fff;box-shadow:0 6px 14px -6px rgba(27,79,158,.5)}
.dp-b.note{background:var(--admin-bg);border:1px solid var(--admin-border);color:var(--admin-text)}
.dp-b.ok{background:var(--status-done);color:#fff;box-shadow:0 6px 14px -6px rgba(18,183,106,.5)}
.dp-b.no{background:rgba(238,93,80,.1);color:var(--admin-red)}
.dp-pill{font-size:11px;font-weight:700;padding:5px 12px;border-radius:99px;background:rgba(122,90,248,.1);color:var(--status-shipping)}
.dp-muted{color:var(--admin-text-light);font-size:13.5px;padding:18px 0;text-align:center}
.dp-reason{font-size:12.5px;background:rgba(245,165,36,.08);border-left:3px solid var(--status-pending);border-radius:8px;padding:8px 12px;margin-top:6px;width:100%}
.dp-badge-n{font-size:11px;font-weight:800;background:var(--admin-red);color:#fff;min-width:20px;height:20px;border-radius:99px;display:inline-flex;align-items:center;justify-content:center;padding:0 6px}
.dp-section-title{font-family:var(--fd);font-size:17px;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:9px;color:var(--admin-text)}

/* chat dock */
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

/* notes modal */
.sheet{position:fixed;inset:0;z-index:100;background:rgba(14,46,92,.5);backdrop-filter:blur(3px);display:none;align-items:center;justify-content:center;padding:18px}
.sheet.show{display:flex}
.sheet-card{background:var(--admin-surface);border-radius:18px;width:100%;max-width:460px;max-height:80vh;display:flex;flex-direction:column;overflow:hidden;box-shadow:0 24px 60px -16px rgba(14,46,92,.35)}

@media(max-width:900px){
  .dp-stats{grid-template-columns:1fr 1fr;gap:10px}
}
</style>

<!-- Stats -->
<div class="dp-stats">
  <div class="dp-stat amber"><b>${fn:length(newOrders) + 0}</b><span>Đơn mới chờ xác nhận</span></div>
  <div class="dp-stat blue"><b>${fn:length(needAssign) + 0}</b><span>Cần gán shipper</span></div>
  <div class="dp-stat green"><b>${fn:length(shipping) + 0}</b><span>Đang giao</span></div>
  <div class="dp-stat red"><b>${fn:length(pendingCancel) + 0}</b><span>Chờ duyệt hủy</span></div>
</div>

<!-- Cần gán shipper -->
<div class="card">
  <div class="dp-section-title">🚚 Cần gán shipper <c:if test="${not empty needAssign}"><span class="dp-badge-n">${fn:length(needAssign)}</span></c:if></div>
  <c:forEach var="o" items="${needAssign}">
    <div class="dp-row" id="asg${o.orderId}">
      <span class="dp-oid">#${o.orderId}</span>
      <span class="dp-who"><b><c:out value="${o.fullName}"/> · <c:out value="${o.phone}"/></b><small><c:out value="${o.address}"/></small></span>
      <span class="dp-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
      <select id="sel${o.orderId}">
        <option value="">— Chọn shipper —</option>
        <c:forEach var="s" items="${shippers}">
          <option value="${s.userId}"><c:out value="${s.fullName}"/></option>
        </c:forEach>
      </select>
      <button class="dp-b assign" onclick="assign(${o.orderId})">Gán đơn</button>
      <button class="dp-b note" onclick="openNotes(${o.orderId})">💬</button>
    </div>
  </c:forEach>
  <c:if test="${empty needAssign}"><div class="dp-muted">Không có đơn nào chờ gán. 🎉</div></c:if>
  <c:if test="${empty shippers}"><div class="dp-reason">Chưa có tài khoản shipper — tạo trong mục <a href="${pageContext.request.contextPath}/admin/nhan-su" style="color:var(--admin-primary);font-weight:700">Quản lý Nhân sự</a>.</div></c:if>
</div>

<!-- Đang giao -->
<div class="card">
  <div class="dp-section-title">🛵 Đang giao <c:if test="${not empty shipping}"><span class="dp-badge-n" style="background:var(--status-done)">${fn:length(shipping)}</span></c:if></div>
  <c:forEach var="o" items="${shipping}">
    <div class="dp-row">
      <span class="dp-oid">#${o.orderId}</span>
      <span class="dp-who"><b><c:out value="${o.fullName}"/></b><small><c:out value="${o.address}"/></small></span>
      <span class="dp-pill">🛵 <c:out value="${not empty o.shipperName ? o.shipperName : 'Shipper'}"/></span>
      <span class="dp-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
      <button class="dp-b note" onclick="openNotes(${o.orderId})">💬 Ghi chú</button>
    </div>
  </c:forEach>
  <c:if test="${empty shipping}"><div class="dp-muted">Chưa có đơn đang giao.</div></c:if>
</div>

<!-- Chờ duyệt hủy -->
<div class="card">
  <div class="dp-section-title">⚠️ Yêu cầu hủy đơn <c:if test="${not empty pendingCancel}"><span class="dp-badge-n">${fn:length(pendingCancel)}</span></c:if></div>
  <c:forEach var="o" items="${pendingCancel}">
    <div class="dp-row" id="pc${o.orderId}">
      <span class="dp-oid">#${o.orderId}</span>
      <span class="dp-who"><b><c:out value="${o.fullName}"/> · <c:out value="${o.phone}"/></b><small>Trả trước · <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</small></span>
      <button class="dp-b ok" onclick="cancelAct(${o.orderId},'approve')">✓ Duyệt hủy + hoàn kho</button>
      <button class="dp-b no" onclick="cancelAct(${o.orderId},'reject')">✕ Từ chối</button>
      <c:if test="${not empty o.cancelReason}"><div class="dp-reason">Lý do: <c:out value="${o.cancelReason}"/></div></c:if>
    </div>
  </c:forEach>
  <c:if test="${empty pendingCancel}"><div class="dp-muted">Không có yêu cầu hủy nào.</div></c:if>
</div>

<!-- Đơn mới -->
<div class="card">
  <div class="dp-section-title">🕐 Đơn mới chờ xác nhận</div>
  <c:forEach var="o" items="${newOrders}">
    <div class="dp-row">
      <span class="dp-oid">#${o.orderId}</span>
      <span class="dp-who"><b><c:out value="${o.fullName}"/></b><small><c:out value="${o.paymentMethod == 'COD' ? 'COD' : 'Chuyển khoản'}"/> · <fmt:formatDate value="${o.createdAt}" pattern="HH:mm dd/MM"/></small></span>
      <span class="dp-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
    </div>
  </c:forEach>
  <c:if test="${empty newOrders}"><div class="dp-muted">Không có đơn mới.</div></c:if>
</div>

<!-- Chat dock -->
<button class="chat-fab" onclick="toggleChat()" aria-label="Chat nội bộ">
  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
</button>
<div class="dock" id="chatDock">
  <div class="dock-hd"><b>💬 Chat nội bộ PureNut</b><button class="dock-x" onclick="toggleChat()">×</button></div>
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
function roleTag(r){return r==='MANAGER'?'Quản lý':(r==='ADMIN'?'Admin':'Shipper')}
function render(list,box,append){
  if(!append)box.innerHTML='';
  list.forEach(function(m){
    var d=document.createElement('div');
    d.className='m '+(m.mine?'mine':'them');
    d.innerHTML=(m.mine?'':'<div class="who2">'+m.name+' · '+roleTag(m.role)+'</div>')+m.msg+'<small>'+m.time+'</small>';
    box.appendChild(d);
  });
  box.scrollTop=box.scrollHeight;
}
window.assign=function(orderId){
  var sel=document.getElementById('sel'+orderId);
  if(!sel.value){alert('Chọn shipper trước nhé!');return}
  ajax('/manager/gan-don',{orderId:orderId,shipperId:sel.value},function(d){
    if(d.ok){var r=document.getElementById('asg'+orderId);r.style.opacity='.45';r.querySelectorAll('button,select').forEach(function(x){x.disabled=true});setTimeout(function(){location.reload()},600)}
    else alert(d.msg||'Không gán được');
  });
};
window.cancelAct=function(orderId,action){
  if(!confirm(action==='approve'?'Duyệt hủy đơn #'+orderId+' và hoàn kho?':'Từ chối yêu cầu hủy đơn #'+orderId+'?'))return;
  ajax('/manager/duyet-huy',{orderId:orderId,action:action},function(d){
    if(d.ok){location.reload()}else alert(d.msg||'Không xử lý được');
  });
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
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
