<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700;1,9..144,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.12);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:28px;overflow-x:hidden;-webkit-font-smoothing:antialiased}
body::after{content:"";position:fixed;inset:0;pointer-events:none;opacity:.05;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='180'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
a{text-decoration:none;color:inherit}button{font:inherit;cursor:pointer;border:none}
/* blobs nền */
.blob{position:fixed;border-radius:50%;filter:blur(60px);opacity:.35;pointer-events:none;z-index:0;animation:drift 14s ease-in-out infinite}
.blob.b1{width:380px;height:380px;background:#F3D98B;top:-120px;left:-100px}
.blob.b2{width:320px;height:320px;background:#BFE0F2;bottom:-100px;right:-80px;animation-delay:-6s}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(26px,-30px)}}
/* nút quay lại */
.back{position:fixed;top:22px;left:24px;z-index:20;display:inline-flex;align-items:center;gap:8px;background:var(--paper);border:1px solid var(--line);padding:10px 20px;border-radius:99px;font-weight:600;font-size:13.5px;color:var(--ink-soft);box-shadow:0 10px 26px -14px rgba(20,30,20,.3);transition:transform .2s,color .2s}
.back:hover{transform:translateX(-3px);color:var(--navy)}
/* card */
@keyframes cardIn{from{opacity:0;transform:translateY(36px) scale(.97)}to{opacity:1;transform:none}}
.auth{position:relative;z-index:5;width:min(1020px,100%);display:grid;grid-template-columns:1.05fr .95fr;background:var(--paper);border-radius:30px;overflow:hidden;box-shadow:0 40px 90px -36px rgba(11,37,71,.45);border:1px solid var(--line);animation:cardIn .7s cubic-bezier(.16,1,.3,1)}
.pane{padding:52px 54px}
.logo{display:inline-flex;align-items:center;gap:9px;font-family:var(--fd);font-weight:600;font-size:22px;color:var(--navy);margin-bottom:26px}
.logo b{color:var(--red);font-weight:700}
.logo .dot{width:36px;height:36px;border-radius:50%;background:var(--red);display:flex;align-items:center;justify-content:center}
.pane h1{font-family:var(--fd);font-weight:600;font-size:clamp(26px,3vw,34px);line-height:1.12}
.pane .sub{color:var(--ink-soft);margin:10px 0 26px;font-size:15px}
.alert{border-radius:14px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:18px;display:flex;gap:9px;align-items:flex-start}
.alert.err{background:#FCE9E9;color:#A31F1F;border:1px solid #F3C2C2}
.alert.ok{background:#E7F6EC;color:#187A43;border:1px solid #BFE4CC}
.field{margin-bottom:16px}
.field label{display:block;font-size:12px;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:var(--ink-soft);margin-bottom:7px}
.field .box{position:relative}
.field input{width:100%;padding:14px 16px;border-radius:14px;border:1.5px solid var(--line);background:#FFF;font:inherit;font-size:15px;color:var(--ink);transition:border-color .2s,box-shadow .2s}
.field input:focus{outline:none;border-color:var(--navy);box-shadow:0 0 0 4px rgba(27,79,158,.12)}
.eye{position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;color:var(--ink-soft);display:flex;padding:4px}
.row{display:flex;align-items:center;justify-content:space-between;margin:2px 0 20px;font-size:13.5px}
.row label{display:flex;align-items:center;gap:7px;color:var(--ink-soft);font-weight:600;cursor:pointer}
.row a{color:var(--navy);font-weight:700}
.row a:hover{text-decoration:underline}
.submit{width:100%;padding:15px;border-radius:14px;background:linear-gradient(135deg,var(--navy),var(--navy-darker));color:#fff;font-weight:700;font-size:15.5px;box-shadow:0 16px 30px -14px rgba(27,79,158,.6);transition:transform .2s,box-shadow .2s}
.submit:hover{transform:translateY(-2px);box-shadow:0 20px 36px -14px rgba(27,79,158,.7)}
.alt{text-align:center;margin-top:22px;font-size:14px;color:var(--ink-soft)}
.alt a{color:var(--red);font-weight:700}
.alt a:hover{text-decoration:underline}
/* panel phải 3D */
.side{position:relative;background:linear-gradient(150deg,#2E6BC0 0%,var(--navy-dark) 55%,var(--navy-darker) 100%);color:#fff;display:flex;flex-direction:column;justify-content:center;padding:52px 46px;overflow:hidden;perspective:900px}
.side::before,.side::after{content:"";position:absolute;border-radius:50%;background:rgba(255,255,255,.07)}
.side::before{width:340px;height:340px;top:-120px;right:-110px}
.side::after{width:240px;height:240px;bottom:-90px;left:-70px}
.side-inner{position:relative;z-index:2;transform-style:preserve-3d;transition:transform .25s ease-out;will-change:transform}
.side .badge{width:86px;height:86px;border-radius:50%;background:rgba(255,255,255,.14);border:1.5px dashed rgba(255,255,255,.45);display:flex;align-items:center;justify-content:center;margin:0 auto 22px;font-size:38px;transform:translateZ(46px);animation:bob 5s ease-in-out infinite}
@keyframes bob{0%,100%{transform:translateZ(46px) translateY(0)}50%{transform:translateZ(46px) translateY(-9px)}}
.side h2{font-family:var(--fd);font-weight:600;font-size:26px;text-align:center;margin-bottom:10px;transform:translateZ(34px)}
.side p{text-align:center;color:rgba(255,255,255,.85);font-size:14.5px;max-width:300px;margin:0 auto 26px;transform:translateZ(24px)}
.perk{display:flex;align-items:center;gap:12px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.16);border-radius:14px;padding:13px 16px;margin-bottom:11px;font-size:13.5px;font-weight:600;transform:translateZ(18px);transition:background .3s,border-color .3s,transform .3s,box-shadow .3s,color .3s;cursor:default}
.perk .ic{width:34px;height:34px;border-radius:10px;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,.15);font-size:16px;flex:none;transition:transform .3s}
.perk:hover{transform:translateZ(30px) scale(1.03);box-shadow:0 16px 30px -14px rgba(0,0,0,.5)}
.perk:hover .ic{transform:scale(1.15) rotate(-6deg)}
.perk:nth-of-type(1):hover{background:#2BAC62;border-color:#2BAC62}
.perk:nth-of-type(2):hover{background:#F2B705;border-color:#F2B705;color:#3a2b00}
.perk:nth-of-type(3):hover{background:#CE2E2E;border-color:#CE2E2E}
@media(max-width:860px){.auth{grid-template-columns:1fr}.side{display:none}.pane{padding:42px 30px}}
@media(max-width:560px){
  body{padding:0;align-items:stretch;flex-direction:column}
  .blob{display:none}
  .back{position:fixed;top:0;left:0;right:0;z-index:20;margin:0;border-radius:0;border:none;border-bottom:1px solid var(--line);background:rgba(255,253,248,.92);backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);box-shadow:none;padding:14px 20px;font-size:13px;font-weight:700;color:var(--navy);gap:6px}
  .back:hover{transform:none}
  .auth{border-radius:0;box-shadow:none;border:none;min-height:100vh;min-height:100dvh;width:100%}
  .pane{padding:62px 28px 40px}
  .pane h1{font-size:28px}
  .logo{font-size:20px;margin-bottom:22px}
  .pane .sub{font-size:14.5px;margin:8px 0 28px}
  .field{margin-bottom:18px}
  .field label{font-size:11.5px;margin-bottom:6px}
  .field input{padding:14px 16px;font-size:15px;border-radius:12px}
  .submit{padding:15px;font-size:15.5px;border-radius:12px}
  .row{flex-direction:column;align-items:flex-start;gap:10px}
  .alt{margin-top:24px;font-size:14.5px}
}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/" class="back">← Về trang chủ</a>

<div class="auth">
  <div class="pane">
    <a href="${ctx}/" class="logo"><span class="dot"><svg width="20" height="20" viewBox="0 0 34 34"><path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.8"/></svg></span>Pure<b>Nut</b></a>
    <h1>Chào mừng trở lại!</h1>
    <p class="sub">Đăng nhập để tiếp tục mua sắm và nhận ưu đãi.</p>

    <c:if test="${param.reset == 'success'}"><div class="alert ok">✅ Mật khẩu đã được đặt lại thành công. Hãy đăng nhập bằng mật khẩu mới.</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert err">⚠️ <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/login" autocomplete="on">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="email">Địa chỉ email</label>
        <div class="box"><input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}"></div>
      </div>
      <div class="field">
        <label for="password">Mật khẩu</label>
        <div class="box">
          <input type="password" id="password" name="password" placeholder="••••••••" required>
          <button type="button" class="eye" onclick="togglePw('password')" aria-label="Hiện mật khẩu"><svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg></button>
        </div>
      </div>
      <div class="row">
        <label><input type="checkbox" name="remember"> Ghi nhớ đăng nhập</label>
        <a href="${ctx}/forgot-password">Quên mật khẩu?</a>
      </div>
      <button type="submit" class="submit">Đăng nhập</button>
    </form>
    <p class="alt">Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay →</a></p>
  </div>

  <div class="side" id="side3d">
    <div class="side-inner" id="sideInner">
      <div class="badge">🔐</div>
      <h2>Chào mừng đến PureNut</h2>
      <p>Sữa hạt thuần khiết từ hạt Việt — dinh dưỡng tự nhiên, mua sắm nhanh chóng và an toàn.</p>
      <div class="perk"><span class="ic">🌰</span> 100% hạt Việt Nam chất lượng cao</div>
      <div class="perk"><span class="ic">🚚</span> Giao hàng toàn quốc 2–3 ngày</div>
      <div class="perk"><span class="ic">↩️</span> Đổi trả miễn phí trong 7 ngày</div>
    </div>
  </div>
</div>

<script>
function togglePw(id){var i=document.getElementById(id);i.type=i.type==='password'?'text':'password';}
(function(){
  var side=document.getElementById('side3d'),inner=document.getElementById('sideInner');
  if(!side||!inner)return;
  side.addEventListener('mousemove',function(e){var r=side.getBoundingClientRect();var px=(e.clientX-r.left)/r.width-.5,py=(e.clientY-r.top)/r.height-.5;inner.style.transform='rotateY('+(px*14)+'deg) rotateX('+(-py*14)+'deg)';});
  side.addEventListener('mouseleave',function(){inner.style.transform='';});
})();
</script>
</body>
</html>
