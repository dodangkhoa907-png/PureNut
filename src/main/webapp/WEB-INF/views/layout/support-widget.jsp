<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ══════════ Bong bóng Hỗ trợ khách hàng ══════════ -->
<style>
.sp-float{position:fixed;right:22px;bottom:22px;z-index:990;width:58px;height:58px;border-radius:50%;background:linear-gradient(135deg,#CE2E2E,#A31F1F);color:#fff;display:flex;align-items:center;justify-content:center;cursor:pointer;border:none;box-shadow:0 10px 26px -8px rgba(206,46,46,.55),0 3px 8px rgba(0,0,0,.12);transition:transform .3s cubic-bezier(.34,1.56,.64,1),box-shadow .3s}
.sp-float:hover{transform:translateY(-4px) scale(1.06);box-shadow:0 16px 34px -8px rgba(206,46,46,.6)}
.sp-float svg{transition:transform .3s}
.sp-float.open svg.sp-ic-chat{transform:rotate(90deg) scale(0)}
.sp-float .sp-ic-close{position:absolute;transform:rotate(-90deg) scale(0);transition:transform .3s}
.sp-float.open .sp-ic-close{transform:rotate(0) scale(1)}
.sp-float::after{content:'';position:absolute;inset:-4px;border-radius:50%;border:2px solid rgba(206,46,46,.4);animation:sp-pulse 2.2s ease-out infinite;pointer-events:none}
.sp-float.open::after{display:none}
@keyframes sp-pulse{0%{transform:scale(.9);opacity:1}100%{transform:scale(1.35);opacity:0}}
.sp-panel{position:fixed;right:22px;bottom:92px;z-index:991;width:min(360px,calc(100vw - 32px));background:#FFFDF8;border-radius:22px;box-shadow:0 24px 60px -16px rgba(11,37,71,.4),0 4px 16px rgba(0,0,0,.08);overflow:hidden;opacity:0;pointer-events:none;transform:translateY(18px) scale(.96);transform-origin:bottom right;transition:opacity .3s,transform .35s cubic-bezier(.34,1.56,.64,1)}
.sp-panel.show{opacity:1;pointer-events:auto;transform:translateY(0) scale(1)}
.sp-head{background:linear-gradient(135deg,#1B4F9E,#0B2547);color:#fff;padding:18px 20px;display:flex;align-items:center;gap:12px}
.sp-head-ava{width:42px;height:42px;border-radius:50%;background:rgba(255,255,255,.16);display:flex;align-items:center;justify-content:center;flex-shrink:0}
.sp-head h4{font-family:'Fraunces',serif;font-size:17px;margin:0;color:#fff}
.sp-head p{font-size:12px;margin:0;opacity:.85;display:flex;align-items:center;gap:5px}
.sp-dot{width:7px;height:7px;border-radius:50%;background:#3DDC84;display:inline-block;animation:sp-blink 1.6s infinite}
@keyframes sp-blink{50%{opacity:.4}}
.sp-body{padding:16px 18px 18px;max-height:min(430px,60vh);overflow-y:auto}
.sp-msg{background:#F0F4FB;border-radius:14px 14px 14px 4px;padding:11px 14px;font-size:13.5px;color:#241F18;line-height:1.55;margin-bottom:14px}
.sp-links{display:flex;flex-direction:column;gap:8px;margin-bottom:16px}
.sp-link{display:flex;align-items:center;gap:10px;padding:10px 13px;border-radius:12px;border:1.5px solid rgba(36,31,24,.1);background:#fff;font-size:13px;font-weight:600;color:#241F18;text-decoration:none;transition:border-color .2s,transform .2s}
.sp-link:hover{border-color:#1B4F9E;transform:translateX(3px)}
.sp-link .sp-lk-ic{width:30px;height:30px;border-radius:9px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.sp-form label{display:block;font-size:12px;font-weight:600;color:#6B6357;margin:10px 0 5px}
.sp-form input,.sp-form textarea{width:100%;border:1.5px solid rgba(36,31,24,.12);border-radius:11px;padding:10px 12px;font-size:13.5px;font-family:inherit;background:#fff;box-sizing:border-box;transition:border-color .2s}
.sp-form input:focus,.sp-form textarea:focus{outline:none;border-color:#1B4F9E}
.sp-form textarea{resize:vertical;min-height:74px}
.sp-stars{display:flex;gap:6px;margin-top:2px}
.sp-star{font-size:24px;color:#D9D9D9;cursor:pointer;transition:transform .15s,color .15s;user-select:none;background:none;border:none;padding:0;line-height:1}
.sp-star:hover{transform:scale(1.25)}
.sp-star.on{color:#F6AD37}
.sp-send{width:100%;margin-top:14px;padding:12px;border-radius:99px;border:none;background:#CE2E2E;color:#fff;font-weight:700;font-size:14px;font-family:inherit;cursor:pointer;transition:transform .2s,box-shadow .2s;box-shadow:0 8px 18px -8px rgba(206,46,46,.5)}
.sp-send:hover{transform:translateY(-2px);box-shadow:0 12px 22px -8px rgba(206,46,46,.55)}
.sp-send:disabled{opacity:.6;transform:none;cursor:default}
.sp-done{display:none;text-align:center;padding:26px 10px}
.sp-done-ic{width:60px;height:60px;margin:0 auto 12px;border-radius:50%;background:#2BAC62;display:flex;align-items:center;justify-content:center;animation:sp-pop .5s cubic-bezier(.34,1.56,.64,1)}
@keyframes sp-pop{from{transform:scale(0)}to{transform:scale(1)}}
.sp-done h5{font-family:'Fraunces',serif;font-size:17px;margin:0 0 5px;color:#241F18}
.sp-done p{font-size:13px;color:#6B6357;margin:0}
.sp-err{display:none;font-size:12.5px;color:#CE2E2E;font-weight:600;margin-top:8px}
@media(max-width:520px){
  .sp-float{right:14px;bottom:14px;width:52px;height:52px}
  .sp-panel{right:14px;left:14px;bottom:78px;width:auto;border-radius:18px}
  .sp-body{max-height:55vh;padding:14px 14px 16px}
  .sp-head{padding:15px 16px}
  .sp-msg{font-size:13px}
}
</style>

<button type="button" class="sp-float" id="spFloat" onclick="spToggle()" aria-label="Hỗ trợ khách hàng">
  <svg class="sp-ic-chat" width="26" height="26" viewBox="0 0 24 24" fill="none" aria-hidden="true">
    <path d="M12 2C6.48 2 2 6.02 2 11c0 2.9 1.6 5.47 4.1 7.13L5.5 22l4.3-2.16c.7.12 1.43.18 2.2.18 5.52 0 10-4.02 10-9S17.52 2 12 2z" fill="#fff"/>
    <circle cx="8" cy="11" r="1.3" fill="#CE2E2E"/><circle cx="12" cy="11" r="1.3" fill="#CE2E2E"/><circle cx="16" cy="11" r="1.3" fill="#CE2E2E"/>
  </svg>
  <svg class="sp-ic-close" width="20" height="20" viewBox="0 0 24 24" fill="none" aria-hidden="true">
    <path d="M6 6l12 12M18 6L6 18" stroke="#fff" stroke-width="2.6" stroke-linecap="round"/>
  </svg>
</button>

<div class="sp-panel" id="spPanel" role="dialog" aria-label="Hỗ trợ khách hàng">
  <div class="sp-head">
    <div class="sp-head-ava">
      <svg width="24" height="24" viewBox="0 0 34 34" aria-hidden="true">
        <circle cx="17" cy="17" r="17" fill="#CE2E2E"/>
        <path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.6"/>
        <path d="M11 14.5c1.5-1.8 3.6-2.8 6-2.8" fill="none" stroke="#fff" stroke-width="1.6" stroke-linecap="round"/>
      </svg>
    </div>
    <div>
      <h4>Hỗ trợ PureNut</h4>
      <p><span class="sp-dot"></span> Thường trả lời trong vài phút</p>
    </div>
  </div>
  <div class="sp-body">
    <div class="sp-msg">Xin chào 👋 PureNut có thể giúp gì cho bạn? Chat nhanh qua Zalo/Messenger, hoặc để lại lời nhắn bên dưới nhé!</div>
    <div class="sp-links">
      <a class="sp-link" href="https://zalo.me/1900888800" target="_blank" rel="noopener">
        <span class="sp-lk-ic" style="background:#E8F1FE">
          <svg width="17" height="17" viewBox="0 0 24 24" fill="none"><path d="M12 2C6.48 2 2 6.02 2 11c0 2.9 1.6 5.47 4.1 7.13L5.5 22l4.3-2.16c.7.12 1.43.18 2.2.18 5.52 0 10-4.02 10-9S17.52 2 12 2z" fill="#1B4F9E"/></svg>
        </span>
        Chat Zalo — phản hồi nhanh nhất
      </a>
      <a class="sp-link" href="tel:19008888">
        <span class="sp-lk-ic" style="background:#FBE9E9">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3-8.7A2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.13.96.36 1.9.7 2.8a2 2 0 0 1-.45 2.1L8.1 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.45c.9.34 1.84.57 2.8.7A2 2 0 0 1 22 16.9z" fill="#CE2E2E"/></svg>
        </span>
        Hotline 1900 8888 (8h–21h)
      </a>
    </div>
    <form class="sp-form" id="spForm">
      <div style="font-size:13px;font-weight:700;color:#241F18;padding-bottom:2px;border-bottom:1px dashed rgba(36,31,24,.12)">Hoặc để lại lời nhắn 💬</div>
      <c:if test="${empty sessionScope.user}">
        <label for="spName">Tên của bạn *</label>
        <input type="text" id="spName" maxlength="150" placeholder="Nguyễn Văn A">
        <label for="spPhone">SĐT hoặc Email (để được liên hệ lại)</label>
        <input type="text" id="spPhone" maxlength="150" placeholder="09xx xxx xxx">
      </c:if>
      <label>Đánh giá trải nghiệm (tùy chọn)</label>
      <div class="sp-stars" id="spStars">
        <button type="button" class="sp-star" data-v="1">&#9733;</button><button type="button" class="sp-star" data-v="2">&#9733;</button><button type="button" class="sp-star" data-v="3">&#9733;</button><button type="button" class="sp-star" data-v="4">&#9733;</button><button type="button" class="sp-star" data-v="5">&#9733;</button>
      </div>
      <label for="spMsg">Nội dung *</label>
      <textarea id="spMsg" maxlength="1000" placeholder="Góp ý, thắc mắc về đơn hàng, sản phẩm…"></textarea>
      <div class="sp-err" id="spErr"></div>
      <button type="submit" class="sp-send" id="spSend">Gửi cho PureNut</button>
    </form>
    <div class="sp-done" id="spDone">
      <div class="sp-done-ic">
        <svg viewBox="0 0 24 24" style="width:30px;height:30px;stroke:#fff;fill:none;stroke-width:3;stroke-linecap:round;stroke-linejoin:round"><polyline points="20 6 9 17 4 12"/></svg>
      </div>
      <h5>Đã gửi thành công!</h5>
      <p>Cảm ơn bạn. PureNut sẽ phản hồi sớm nhất có thể 🌱</p>
    </div>
  </div>
</div>

<script>
(function(){
  var CTX='${pageContext.request.contextPath}';
  var panel=document.getElementById('spPanel'),float=document.getElementById('spFloat');
  var rating=0;
  window.spToggle=function(){
    var open=panel.classList.toggle('show');
    float.classList.toggle('open',open);
  };
  document.addEventListener('click',function(e){
    if(panel.classList.contains('show')&&!panel.contains(e.target)&&!float.contains(e.target)){
      panel.classList.remove('show');float.classList.remove('open');
    }
  });
  document.getElementById('spStars').addEventListener('click',function(e){
    var b=e.target.closest('.sp-star');if(!b)return;
    rating=parseInt(b.dataset.v,10);
    document.querySelectorAll('#spStars .sp-star').forEach(function(s){
      s.classList.toggle('on',parseInt(s.dataset.v,10)<=rating);
    });
  });
  document.getElementById('spForm').addEventListener('submit',function(e){
    e.preventDefault();
    var err=document.getElementById('spErr'),send=document.getElementById('spSend');
    var msg=document.getElementById('spMsg').value.trim();
    var nameEl=document.getElementById('spName'),phoneEl=document.getElementById('spPhone');
    var name=nameEl?nameEl.value.trim():'';
    var contact=phoneEl?phoneEl.value.trim():'';
    err.style.display='none';
    if(nameEl&&!name){err.textContent='Vui lòng nhập tên của bạn.';err.style.display='block';return}
    if(!msg){err.textContent='Vui lòng nhập nội dung.';err.style.display='block';return}
    send.disabled=true;send.textContent='Đang gửi…';
    var p=new URLSearchParams();
    p.append('_csrf','${sessionScope._csrf}');
    p.append('message',msg);
    if(name)p.append('name',name);
    if(contact){/[@]/.test(contact)?p.append('email',contact):p.append('phone',contact)}
    if(rating>0)p.append('rating',rating);
    fetch(CTX+'/feedback',{method:'POST',body:p,headers:{'Content-Type':'application/x-www-form-urlencoded'}})
      .then(function(r){return r.json()})
      .then(function(d){
        if(d.ok){
          document.getElementById('spForm').style.display='none';
          document.getElementById('spDone').style.display='block';
        }else{
          err.textContent=d.msg||'Không gửi được, vui lòng thử lại.';err.style.display='block';
          send.disabled=false;send.textContent='Gửi cho PureNut';
        }
      })
      .catch(function(){
        err.textContent='Lỗi kết nối, vui lòng thử lại.';err.style.display='block';
        send.disabled=false;send.textContent='Gửi cho PureNut';
      });
  });
})();
</script>
