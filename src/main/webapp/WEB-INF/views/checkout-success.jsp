<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đặt hàng thành công — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif;--shadow:0 18px 40px -18px rgba(20,30,20,.22)}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:30px;-webkit-font-smoothing:antialiased}
a{text-decoration:none}
.card{background:var(--paper);border:1px solid var(--line);border-radius:28px;box-shadow:var(--shadow);max-width:520px;width:100%;text-align:center;padding:56px 44px}
.tick{width:96px;height:96px;border-radius:50%;background:#DCF0E3;display:flex;align-items:center;justify-content:center;margin:0 auto 26px;animation:pop .5s cubic-bezier(.2,1.4,.4,1)}
@keyframes pop{0%{transform:scale(0)}100%{transform:scale(1)}}
h1{font-family:var(--fd);font-weight:600;font-size:32px;color:var(--navy);margin-bottom:14px}
p{color:var(--ink-soft);font-size:16px;margin-bottom:30px}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:14px 28px;border-radius:99px;font-weight:600;font-size:15px;transition:transform .2s;margin:5px}
.btn-primary{background:var(--navy);color:#fff}.btn-primary:hover{transform:translateY(-2px)}
.btn-ghost{background:transparent;color:var(--ink);border:1.5px solid var(--ink)}.btn-ghost:hover{background:var(--ink);color:#fff}
</style>
</head>
<body>
<div class="card">
  <div class="tick"><svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#2BAC62" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6L9 17l-5-5"/></svg></div>
  <h1>Đặt hàng thành công!</h1>
  <p>Cảm ơn bạn đã tin tưởng PureNut. Chúng tôi sẽ gọi xác nhận và giao hàng trong thời gian sớm nhất.</p>
  <a href="${ctx}/account" class="btn btn-primary">Xem đơn hàng của tôi</a>
  <a href="${ctx}/products" class="btn btn-ghost">Tiếp tục mua sắm</a>
</div>
</body>
</html>
