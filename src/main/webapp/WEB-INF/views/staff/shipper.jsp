<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="me" value="${not empty sessionScope.user ? sessionScope.user : sessionScope.adminUser}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Shipper — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.5;-webkit-font-smoothing:antialiased;padding-bottom:76px}
button{font:inherit;cursor:pointer;border:none;background:none}
a{text-decoration:none;color:inherit}

.hd{background:linear-gradient(135deg,var(--navy),var(--navy-darker));color:#fff;padding:20px 18px 56px;border-radius:0 0 26px 26px}
.hd-row{display:flex;align-items:center;justify-content:space-between;max-width:680px;margin:0 auto}
.hd h1{font-family:var(--fd);font-size:20px;color:#fff}
.hd small{opacity:.8;font-size:12.5px}
.hd a.out{font-size:12.5px;font-weight:700;background:rgba(255,255,255,.14);padding:8px 14px;border-radius:99px}
.stats{display:grid;grid-template-columns:1fr 1fr;gap:12px;max-width:680px;margin:-38px auto 18px;padding:0 16px}
.stat{background:var(--paper);border:1px solid var(--line);border-radius:18px;padding:16px;text-align:center;box-shadow:0 10px 26px -14px rgba(11,37,71,.3)}
.stat b{display:block;font-family:var(--fd);font-size:26px;color:var(--navy)}
.stat span{font-size:12px;color:var(--ink-soft);font-weight:600}

.wrap{max-width:680px;margin:0 auto;padding:0 16px}
.oc{background:var(--paper);border:1px solid var(--line);border-radius:18px;padding:16px;margin-bottom:14px;transition:transform .2s,box-shadow .2s}
.oc:active{transform:scale(.99)}
.oc-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px}
.oc-id{font-weight:800;font-size:15px}
.pill{font-size:11px;font-weight:700;padding:4px 11px;border-radius:99px}
.pill.SHIPPING{background:#FFF3DC;color:#B7791F}
.pill.DONE{background:#E4F7EC;color:var(--green)}
.oc-name{font-weight:700;font-size:14.5px}
.oc-addr{font-size:13px;color:var(--ink-soft);margin:4px 0 10px;display:flex;gap:6px}
.oc-addr svg{flex-shrink:0;margin-top:2px}
.oc-foot{display:flex;gap:8px;align-items:center;border-top:1px dashed var(--line);padding-top:12px}
.oc-total{font-family:var(--fd);font-weight:700;font-size:17px;color:var(--red);margin-right:auto}
.ob{display:inline-flex;align-items:center;gap:6px;padding:9px 14px;border-radius:12px;font-weight:700;font-size:12.5px;transition:transform .15s}
.ob:active{transform:scale(.95)}
.ob.call{background:#E8F1FE;color:var(--navy)}
.ob.note{background:var(--cream);color:var(--ink);border:1px solid var(--line)}
.ob.done{background:var(--green);color:#fff;box-shadow:0 8px 16px -8px rgba(43,172,98,.6)}
.empty{text-align:center;padding:60px 20px;color:var(--ink-soft)}
.empty svg{margin-bottom:12px;opacity:.4}

/* tabs bottom */
.tabs{position:fixed;left:0;right:0;bottom:0;z-index:50;background:var(--paper);border-top:1px solid var(--line);display:flex;box-shadow:0 -6px 22px -12px rgba(11,37,71,.25)}
.tab{flex:1;padding:11px 0 13px;text-align:center;font-size:11.5px;font-weight:700;color:var(--ink-soft);display:flex;flex-direction:column;align-items:center;gap:3px}
.tab.on{color:var(--navy)}
.tab .dot-new{position:absolute;margin-left:22px;width:8px;height:8px;border-radius:50%;background:var(--red);display:none}

/* sheet (notes + chat) */
.sheet{position:fixed;inset:0;z-index:100;background:rgba(11,37,71,.5);backdrop-filter:blur(3px);display:none;align-items:flex-end}
.sheet.show{display:flex}
.sheet-card{background:var(--paper);border-radius:22px 22px 0 0;width:100%;max-width:680px;margin:0 auto;max-height:82vh;display:flex;flex-direction:column;animation:up .3s cubic-bezier(.2,.8,.3,1)}
@keyframes up{from{transform:translateY(60px);opacity:.4}to{transform:none;opacity:1}}
.sheet-hd{padding:16px 18px;border-bottom:1px solid var(--line);display:flex;justify-content:space-between;align-items:center}
.sheet-hd b{font-family:var(--fd);font-size:16px}
.sheet-x{width:32px;height:32px;border-radius:50%;background:var(--cream);font-size:17px;display:flex;align-items:center;justify-content:center}
.msgs{flex:1;overflow-y:auto;padding:16px 18px;display:flex;flex-direction:column;gap:10px;min-height:180px}
.m{max-width:82%;padding:9px 13px;border-radius:15px;font-size:13.5px;line-height:1.5}
.m small{display:block;font-size:10.5px;opacity:.65;margin-top:3px}
.m.them{background:#F0F4FB;border-bottom-left-radius:4px;align-self:flex-start}
.m.mine{background:var(--navy);color:#fff;border-bottom-right-radius:4px;align-self:flex-end}
.m .who{font-size:11px;font-weight:700;color:var(--navy);margin-bottom:2px}
.m.mine .who{display:none}
.send-row{display:flex;gap:8px;padding:12px 16px;border-top:1px solid var(--line)}
.send-row input{flex:1;border:1.5px solid var(--line);border-radius:99px;padding:11px 16px;font-size:14px;font-family:inherit;background:#fff}
.send-row input:focus{outline:none;border-color:var(--navy)}
.send-row button{width:44px;height:44px;border-radius:50%;background:var(--navy);color:#fff;display:flex;align-items:center;justify-content:center;flex-shrink:0}
</style>
</head>
<body>

<div class="hd">
  <div class="hd-row">
    <div>
      <h1>🛵 Giao hàng</h1>
      <small>Xin chào, <c:out value="${me.fullName}"/></small>
    </div>
    <a class="out" href="${ctx}/logout">Đăng xuất</a>
  </div>
</div>

<div class="stats">
  <div class="stat"><b>${shippingCount}</b><span>Đang giao</span></div>
  <div class="stat"><b>${doneCount}</b><span>Đã hoàn thành</span></div>
</div>

<div class="wrap" id="orderList">
  <c:forEach var="o" items="${orders}">
    <div class="oc" id="oc${o.orderId}">
      <div class="oc-top">
        <span class="oc-id">Đơn #${o.orderId}</span>
        <span class="pill ${o.status}" id="pill${o.orderId}">${o.status == 'SHIPPING' ? 'Đang giao' : (o.status == 'DONE' ? 'Đã giao' : o.status)}</span>
      </div>
      <div class="oc-name"><c:out value="${o.fullName}"/></div>
      <div class="oc-addr">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 12-9 12S3 17 3 10a9 9 0 1118 0z"/><circle cx="12" cy="10" r="3"/></svg>
        <c:out value="${o.address}"/>
      </div>
      <div class="oc-foot">
        <span class="oc-total"><fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> đ</span>
        <a class="ob call" href="tel:${o.phone}">📞 Gọi</a>
        <button class="ob note" onclick="openNotes(${o.orderId})">💬 Ghi chú</button>
        <c:if test="${o.status == 'SHIPPING'}">
          <button class="ob done" onclick="markDone(${o.orderId},this)">✓ Đã giao</button>
        </c:if>
      </div>
    </div>
  </c:forEach>
  <c:if test="${empty orders}">
    <div class="empty">
      <svg width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.4"><rect x="2" y="6" width="13" height="12" rx="2"/><path d="M15 10h4l3 3v4a1 1 0 01-1 1h-6V10z"/><circle cx="6" cy="18" r="1.6"/><circle cx="18" cy="18" r="1.6"/></svg>
      <p>Chưa có đơn nào được gán cho bạn.<br>Quản lý sẽ gán đơn — kiểm tra lại sau nhé!</p>
    </div>
  </c:if>
</div>

<!-- Bottom tabs -->
<nav class="tabs">
  <button class="tab on" onclick="location.reload()">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="13" height="12" rx="2"/><path d="M15 10h4l3 3v4a1 1 0 01-1 1h-6V10z"/><circle cx="6" cy="18" r="1.6"/><circle cx="18" cy="18" r="1.6"/></svg>
    Đơn hàng
  </button>
  <button class="tab" onclick="openChat()">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
    Chat nội bộ
  </button>
</nav>

<!-- Notes sheet -->
<div class="sheet" id="noteSheet">
  <div class="sheet-card">
    <div class="sheet-hd"><b id="noteTitle">Ghi chú đơn</b><button class="sheet-x" onclick="closeSheet('noteSheet')">×</button></div>
    <div class="msgs" id="noteMsgs"></div>
    <div class="send-row">
      <input type="text" id="noteInput" maxlength="500" placeholder="VD: Khách hẹn giao sau 17h…">
      <button onclick="sendNote()" aria-label="Gửi"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg></button>
    </div>
  </div>
</div>

<!-- Chat sheet -->
<div class="sheet" id="chatSheet">
  <div class="sheet-card">
    <div class="sheet-hd"><b>💬 Chat nội bộ PureNut</b><button class="sheet-x" onclick="closeSheet('chatSheet')">×</button></div>
    <div class="msgs" id="chatMsgs"></div>
    <div class="send-row">
      <input type="text" id="chatInput" maxlength="500" placeholder="Nhắn cho quản lý…">
      <button onclick="sendChat()" aria-label="Gửi"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg></button>
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
function esc(s){var d=document.createElement('div');d.textContent=s;return d.innerHTML;}
function render(list,box,append){
  if(!append)box.innerHTML='';
  list.forEach(function(m){
    var d=document.createElement('div');
    d.className='m '+(m.mine?'mine':'them');
    d.innerHTML=(m.mine?'':'<div class="who">'+esc(m.name)+' · '+roleTag(m.role)+'</div>')+esc(m.msg)+'<small>'+esc(m.time)+'</small>';
    box.appendChild(d);
  });
  box.scrollTop=box.scrollHeight;
}
/* Notes */
window.openNotes=function(orderId){
  curOrder=orderId;
  document.getElementById('noteTitle').textContent='Ghi chú đơn #'+orderId;
  document.getElementById('noteSheet').classList.add('show');
  loadNotes();
};
function loadNotes(){
  ajax('/staff/notes?orderId='+curOrder,null,function(d){if(d.ok)render(d.items,document.getElementById('noteMsgs'))});
}
window.sendNote=function(){
  var i=document.getElementById('noteInput'),v=i.value.trim();if(!v)return;
  i.value='';
  ajax('/staff/notes',{orderId:curOrder,message:v},function(){loadNotes()});
};
/* Chat */
window.openChat=function(){
  document.getElementById('chatSheet').classList.add('show');
  lastChatId=0;pollChat();
  clearInterval(chatTimer);chatTimer=setInterval(pollChat,4000);
};
function pollChat(){
  ajax('/staff/chat?after='+lastChatId,null,function(d){
    if(!d.ok||!d.items.length)return;
    render(d.items,document.getElementById('chatMsgs'),lastChatId>0);
    lastChatId=d.items[d.items.length-1].id;
  });
}
window.sendChat=function(){
  var i=document.getElementById('chatInput'),v=i.value.trim();if(!v)return;
  i.value='';
  ajax('/staff/chat',{message:v},function(){pollChat()});
};
window.closeSheet=function(id){
  document.getElementById(id).classList.remove('show');
  if(id==='chatSheet'){clearInterval(chatTimer)}
};
/* Done */
window.markDone=function(orderId,btn){
  if(!confirm('Xác nhận đã giao thành công đơn #'+orderId+'?'))return;
  btn.disabled=true;
  ajax('/shipper/hoan-thanh',{orderId:orderId},function(d){
    if(d.ok){
      var p=document.getElementById('pill'+orderId);
      p.className='pill DONE';p.textContent='Đã giao';
      btn.remove();
    }else{alert(d.msg||'Không cập nhật được');btn.disabled=false}
  });
};
/* Enter để gửi */
document.getElementById('noteInput').addEventListener('keydown',function(e){if(e.key==='Enter')sendNote()});
document.getElementById('chatInput').addEventListener('keydown',function(e){if(e.key==='Enter')sendChat()});
</script>
</body>
</html>
