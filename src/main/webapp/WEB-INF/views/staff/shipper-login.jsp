<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
<meta name="theme-color" content="#F3F4F6">
<title>Đăng nhập Shipper — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
/* ==========================================================================
   Cùng design token với shipper.jsp — Light Mode, GrabDriver/ShopeeFood-style
   ========================================================================== */
:root{
  --bg:#F3F4F6;--card:#FFFFFF;
  --accent:#F59E0B;--accent-dark:#D97706;--accent-soft:#FEF3C7;
  --text-dark:#1F2937;--text-muted:#6B7280;--border:#E5E7EB;
  --red:#EF4444;--red-soft:#FEE2E2;
  --radius-card:22px;--radius-btn:16px;
  --shadow-card:0 1px 3px rgba(17,24,39,.04), 0 8px 24px -12px rgba(17,24,39,.10);
  --font:'Inter',system-ui,sans-serif;
}
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent}
body{
  font-family:var(--font);background:var(--bg);color:var(--text-dark);
  min-height:100vh;display:flex;flex-direction:column;justify-content:center;
  padding:24px;-webkit-font-smoothing:antialiased;
}
button,input{font-family:inherit}
a{text-decoration:none;color:inherit}

.login-wrap{max-width:420px;width:100%;margin:0 auto}

.brand{text-align:center;margin-bottom:28px}
.brand-badge{
  width:72px;height:72px;margin:0 auto 16px;border-radius:20px;
  background:var(--accent-soft);color:var(--accent-dark);
  display:flex;align-items:center;justify-content:center;
  box-shadow:0 10px 24px -10px rgba(245,158,11,.4);
}
.brand-badge svg{width:34px;height:34px}
.brand h1{font-size:22px;font-weight:800;color:var(--text-dark);letter-spacing:-.02em}
.brand h1 b{color:var(--accent-dark)}
.brand p{font-size:13.5px;color:var(--text-muted);font-weight:500;margin-top:4px}

.card{
  background:var(--card);border-radius:var(--radius-card);padding:28px 24px;
  border:1px solid var(--border);box-shadow:var(--shadow-card);
}
.card h2{font-size:17px;font-weight:800;margin-bottom:20px;text-align:center;color:var(--text-dark)}

.err{
  background:var(--red-soft);border:1px solid #FCA5A5;color:#B91C1C;
  border-radius:14px;padding:12px 16px;font-size:13.5px;font-weight:600;
  margin-bottom:18px;text-align:center;
}

.field{margin-bottom:16px}
.field label{display:block;font-size:12.5px;font-weight:700;color:var(--text-muted);margin-bottom:7px;letter-spacing:.2px}
.field input{
  width:100%;background:var(--bg);border:1.5px solid var(--border);border-radius:var(--radius-btn);
  padding:15px 16px;color:var(--text-dark);font-family:inherit;font-size:15.5px;font-weight:600;
  outline:none;transition:border-color .2s,box-shadow .2s;
}
.field input:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(245,158,11,.15)}
.field input::placeholder{color:#9CA3AF;font-weight:500}

.pw-wrap{position:relative}
.pw-wrap button{
  position:absolute;right:6px;top:50%;transform:translateY(-50%);
  width:38px;height:38px;background:none;border:none;color:var(--text-muted);
  display:flex;align-items:center;justify-content:center;cursor:pointer;border-radius:10px;
}
.pw-wrap button:active{background:var(--border)}
.pw-wrap button svg{width:19px;height:19px}

.submit{
  width:100%;border:none;border-radius:var(--radius-btn);padding:17px;
  background:var(--accent);color:#fff;font-family:inherit;font-size:15.5px;font-weight:800;
  letter-spacing:.2px;cursor:pointer;transition:transform .15s,box-shadow .15s;margin-top:6px;
  display:flex;align-items:center;justify-content:center;gap:9px;
  box-shadow:0 10px 20px -8px rgba(245,158,11,.55);
}
.submit svg{width:19px;height:19px}
.submit:active{transform:scale(.97)}

.foot{text-align:center;margin-top:22px;font-size:13px;color:var(--text-muted);font-weight:500}
.foot a{color:var(--accent-dark);font-weight:700;border-bottom:1px dashed var(--accent)}

@media(min-width:768px){
  body{padding:40px 24px}
  .login-wrap{max-width:440px}
  .card{padding:36px 32px}
}
</style>
</head>
<body>

<div class="login-wrap">
  <div class="brand">
    <div class="brand-badge">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="2"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="1.5"/><circle cx="17.5" cy="18.5" r="1.5"/></svg>
    </div>
    <h1>Pure<b>Nut</b> Shipper</h1>
    <p>Cổng làm việc dành cho đội giao hàng</p>
  </div>

  <div class="card">
    <h2>Đăng nhập</h2>

    <c:if test="${not empty errorMessage}">
      <div class="err">⚠ <c:out value="${errorMessage}"/></div>
    </c:if>

    <form action="${ctx}/shipper/login" method="POST">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label>Email nhân viên</label>
        <input type="email" name="email" placeholder="shipper@purenut.vn" required autofocus autocomplete="username">
      </div>
      <div class="field">
        <label>Mật khẩu</label>
        <div class="pw-wrap">
          <input type="password" name="password" id="pw" placeholder="••••••••" required autocomplete="current-password">
          <button type="button" id="pwToggle" aria-label="Hiện mật khẩu">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg>
          </button>
        </div>
      </div>
      <button type="submit" class="submit">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="2"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="1.5"/><circle cx="17.5" cy="18.5" r="1.5"/></svg>
        Vào ca làm việc
      </button>
    </form>

    <div class="foot">
      Không phải shipper? <a href="${ctx}/login">Đăng nhập khách hàng</a>
    </div>
  </div>
</div>

<script>
document.getElementById('pwToggle').addEventListener('click',function(){
  var p=document.getElementById('pw');
  p.type=p.type==='password'?'text':'password';
});
</script>
</body>
</html>
