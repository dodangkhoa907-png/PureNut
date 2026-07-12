<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="me" value="${not empty sessionScope.user ? sessionScope.user : sessionScope.adminUser}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản lý điều phối — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--amber:#B7791F;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.5;-webkit-font-smoothing:antialiased}
button{font:inherit;cursor:pointer;border:none;background:none}
a{text-decoration:none;color:inherit}
select{font:inherit}

.hd{background:linear-gradient(135deg,var(--navy),var(--navy-darker));color:#fff;padding:20px 24px 60px;border-radius:0 0 26px 26px}
.hd-row{display:flex;align-items:center;justify-content:space-between;max-width:1080px;margin:0 auto}
.hd h1{font-family:var(--fd);font-size:22px;color:#fff}
.hd small{opacity:.8;font-size:13px}
.hd a.out{font-size:13px;font-weight:700;background:rgba(255,255,255,.14);padding:9px 16px;border-radius:99px}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;max-width:1080px;margin:-40px auto 22px;padding:0 20px}
.stat{background:var(--paper);border:1px solid var(--line);border-radius:18px;padding:18px;text-align:center;box-shadow:0 10px 26px -14px rgba(11,37,71,.3)}
.stat b{display:block;font-family:var(--fd);font-size:28px}
.stat.blue b{color:var(--navy)}.stat.amber b{color:var(--amber)}.stat.green b{color:var(--green)}.stat.red b{color:var(--red)}
.stat span{font-size:12px;color:var(--ink-soft);font-weight:600}

.wrap{max-width:1080px;margin:0 auto;padding:0 20px 60px}
.card{background:var(--paper);border:1px solid var(--line);border-radius:20px;padding:22px;margin-bottom:20px}
.card>h2{font-family:var(--fd);font-size:18px;margin-bottom:16px;display:flex;align-items:center;gap:9px}
.badge-n{font-size:11px;font-weight:800;background:var(--red);color:#fff;min-width:20px;height:20px;border-radius:99px;display:inline-flex;align-items:center;justify-content:center;padding:0 6px}
.row{display:flex;align-items:center;gap:14px;padding:13px 0;border-bottom:1px dashed var(--line);flex-wrap:wrap}
.row:last-child{border-bottom:none}
.row .oid{font-weight:800;font-size:14px;min-width:70px}
.row .who{flex:1;min-width:180px}
.row .who b{font-size:13.5px;display:block}
.row .who small{font-size:12px;color:var(--ink-soft)}
.row .amt{font-family:var(--fd);font-weight:700;color:var(--red);font-size:15px}
.row select{border:1.5px solid var(--line);border-radius:10px;padding:8px 10px;font-size:13px;background:#fff;min-width:150px}
.b{padding:9px 15px;border-radius:11px;font-weight:700;font-size:12.5px;transition:transform .15s}
.b:active{transform:scale(.95)}
.b.assign{background:var(--navy);color:#fff}
.b.note{background:var(--cream);border:1px solid var(--line)}
.b.ok{background:var(--green);color:#fff}
.b.no{background:#FBE9E9;color:var(--red)}
.pill{font-size:11px;font-weight:700;padding:4px 11px;border-radius:99px;background:#FFF3DC;color:var(--amber)}
.muted{color:var(--ink-soft);font-size:13.5px;padding:14px 0}
.reason{font-size:12.5px;background:#FBF3E4;border-left:3px solid var(--amber);border-radius:8px;padding:8px 12px;margin-top:6px;width:100%}

/* chat dock */
.chat-fab{position:fixed;right:22px;bottom:22px;z-index:90;width:56px;height:56px;border-radius:50%;background:var(--navy);color:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 12px 28px -10px rgba(27,79,158,.65);transition:transform .25s}
.chat-fab:hover{transform:translateY(-3px) scale(1.05)}
.dock{position:fixed;right:22px;bottom:90px;z-index:91;width:min(370px,calc(100vw - 32px));height:min(500px,70vh);background:var(--paper);border-radius:20px;box-shadow:0 24px 60px -16px rgba(11,37,71,.45);display:none;flex-direction:column;overflow:hidden}
.dock.show{display:flex}
.dock-hd{background:linear-gradient(135deg,var(--navy),var(--navy-darker));color:#fff;padding:14px 18px;display:flex;justify-content:space-between;align-items:center}
.dock-hd b{font-family:var(--fd);font-size:15px}
.dock-x{color:#fff;font-size:18px;width:28px;height:28px;border-radius:50%;background:rgba(255,255,255,.15);display:flex;align-items:center;justify-content:center}
.msgs{flex:1;overflow-y:auto;padding:14px 16px;display:flex;flex-direction:column;gap:9px}
.m{max-width:84%;padding:8px 12px;border-radius:14px;font-size:13px;line-height:1.5}
.m small{display:block;font-size:10px;opacity:.65;margin-top:2px}
.m.them{background:#F0F4FB;border-bottom-left-radius:4px;align-self:flex-start}
.m.mine{background:var(--navy);color:#fff;border-bottom-right-radius:4px;align-self:flex-end}
.m .who2{font-size:10.5px;font-weight:700;color:var(--navy);margin-bottom:1px}
.m.mine .who2{display:none}
.send-row{display:flex;gap:8px;padding:10px 14px;border-top:1px solid var(--line)}
.send-row input{flex:1;border:1.5px solid var(--line);border-radius:99px;padding:9px 14px;font-size:13.5px;font-family:inherit;background:#fff}
.send-row input:focus{outline:none;border-color:var(--navy)}
.send-row button{width:38px;height:38px;border-radius:50%;background:var(--navy);color:#fff;display:flex;align-items:center;justify-content:center;flex-shrink:0}

/* notes modal reuse dock style, centered */
.sheet{position:fixed;inset:0;z-index:100;background:rgba(11,37,71,.5);backdrop-filter:blur(3px);display:none;align-items:center;justify-content:center;padding:18px}
.sheet.show{display:flex}
.sheet-card{background:var(--paper);border-radius:20px;width:100%;max-width:460px;max-height:80vh;display:flex;flex-direction:column;overflow:hidden}

@media(max-width:760px){
  .stats{grid-template-columns:1fr 1fr;gap:10px}
  .stat{padding:14px;border-radius:14px}
  .stat b{font-size:22px}
  .card{padding:16px;border-radius:16px}
  .row .amt{order:5}
  .hd{padding:16px 16px 54px}
}
</style>
</head>
<body>

<div class="hd">
  <div class="hd-row">
    <div>
      <h1>📋 Điều phối đơn hàng</h1>
      <small>Quản lý: <c:out value="${me.fullName}"/></small>
    </div>
    <a class="out" href="${ctx}/logout">Đăng xuất</a>
  </div>
</div>

<div class="stats">
  <div class="stat amber"><b>${fn:length(newOrders) + 0}</b><span>Đơn mới chờ xác nhận</span></div>
  <div class="stat blue"><b>${fn:length(needAssign) + 0}</b><span>Cần gán shipper</span></div>
  <div class="stat green"><b>${fn:length(shipping) + 0}</b><span>Đang giao</span></div>
  <div class="stat red"><b>${fn:length(pendingCancel) + 0}</b><span>Chờ duyệt hủy</span></div>
</div>

<div class="wrap">

  <!-- Cần gán shipper -->
  <div class="card">
    <h2>🚚 Cần gán shipper <c:if test="${not empty needAssign}"><span class="badge-n">${fn:length(needAssign)}</span></c:if></h2>
    <c:forEach var="o" items="${needAssign}">
      <div class="row" id="asg${o.orderId}">
        <span class="oid">#${o.orderId}</span>
        <span class="who"><b><c:out value="${o.fullName}"/> · <c:out value="${o.phone}"/></b><small><c:out value="${o.address}"/></small></span>
        <span class="amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        <select id="sel${o.orderId}">
          <option value="">— Chọn shipper —</option>
          <c:forEach var="s" items="${shippers}">
            <option value="${s.userId}"><c:out value="${s.fullName}"/></option>
          </c:forEach>
        </select>
        <button class="b assign" onclick="assign(${o.orderId})">Gán đơn</button>
        <button class="b note" onclick="openNotes(${o.orderId})">💬</button>
      </div>
    </c:forEach>
    <c:if test="${empty needAssign}"><div class="muted">Không có đơn nào chờ gán. 🎉</div></c:if>
    <c:if test="${empty shippers}"><div class="reason">Chưa có tài khoản shipper — nhờ Admin tạo trong mục "Quản lý nhân sự".</div></c:if>
  </div>

  <!-- Đang giao -->
  <div class="card">
    <h2>🛵 Đang giao <c:if test="${not empty shipping}"><span class="badge-n" style="background:var(--green)">${fn:length(shipping)}</span></c:if></h2>
    <c:forEach var="o" items="${shipping}">
      <div class="row">
        <span class="oid">#${o.orderId}</span>
        <span class="who"><b><c:out value="${o.fullName}"/></b><small><c:out value="${o.address}"/></small></span>
        <span class="pill">🛵 <c:out value="${not empty o.shipperName ? o.shipperName : 'Shipper'}"/></span>
        <span class="amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        <button class="b note" onclick="openNotes(${o.orderId})">💬 Ghi chú</button>
      </div>
    </c:forEach>
    <c:if test="${empty shipping}"><div class="muted">Chưa có đơn đang giao.</div></c:if>
  </div>

  <!-- Chờ duyệt hủy -->
  <div class="card">
    <h2>⚠️ Yêu cầu hủy đơn <c:if test="${not empty pendingCancel}"><span class="badge-n">${fn:length(pendingCancel)}</span></c:if></h2>
    <c:forEach var="o" items="${pendingCancel}">
      <div class="row" id="pc${o.orderId}">
        <span class="oid">#${o.orderId}</span>
        <span class="who"><b><c:out value="${o.fullName}"/> · <c:out value="${o.phone}"/></b><small>Trả trước · <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</small></span>
        <button class="b ok" onclick="cancelAct(${o.orderId},'approve')">✓ Duyệt hủy + hoàn kho</button>
        <button class="b no" onclick="cancelAct(${o.orderId},'reject')">✕ Từ chối</button>
        <c:if test="${not empty o.cancelReason}"><div class="reason">Lý do: <c:out value="${o.cancelReason}"/></div></c:if>
      </div>
    </c:forEach>
    <c:if test="${empty pendingCancel}"><div class="muted">Không có yêu cầu hủy nào.</div></c:if>
  </div>

  <!-- Đơn mới (chưa xác nhận — xử lý bên Admin) -->
  <div class="card">
    <h2>🕐 Đơn mới chờ xác nhận</h2>
    <c:forEach var="o" items="${newOrders}">
      <div class="row">
        <span class="oid">#${o.orderId}</span>
        <span class="who"><b><c:out value="${o.fullName}"/></b><small><c:out value="${o.paymentMethod == 'COD' ? 'COD' : 'Chuyển khoản'}"/> · <fmt:formatDate value="${o.createdAt}" pattern="HH:mm dd/MM"/></small></span>
        <span class="amt"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
      </div>
    </c:forEach>
    <c:if test="${empty newOrders}"><div class="muted">Không có đơn mới.</div></c:if>
  </div>
</div>

<!-- Chat dock -->
<button class="chat-fab" onclick="toggleChat()" aria-label="Chat nội bộ">
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
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
var CTX='${ctx}',CSRF='${sessionScope._csrf}';
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
</body>
</html>
