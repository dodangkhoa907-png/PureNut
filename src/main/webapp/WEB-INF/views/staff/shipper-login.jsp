<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
<meta name="theme-color" content="#FFC400">
<title>Đăng nhập Shipper — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--yellow:#FFC400;--yellow-dark:#E6A800;--black:#111;--gray:#1E1E1E;--gray-2:#2A2A2A;--white:#FFF;--muted:#9E9E9E;--red:#EF4444}
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent}
body{font-family:'Inter',sans-serif;background:var(--black);color:var(--white);min-height:100vh;display:flex;flex-direction:column;justify-content:center;padding:24px;-webkit-font-smoothing:antialiased}

.brand{text-align:center;margin-bottom:32px}
.brand-badge{width:80px;height:80px;margin:0 auto 16px;border-radius:24px;background:var(--yellow);display:flex;align-items:center;justify-content:center;font-size:40px;box-shadow:0 10px 30px rgba(255,196,0,.3)}
.brand h1{font-size:24px;font-weight:900;letter-spacing:-.02em}
.brand h1 b{color:var(--yellow)}
.brand p{font-size:14px;color:var(--muted);font-weight:600;margin-top:4px}

.card{background:var(--gray);border-radius:24px;padding:26px 22px;max-width:420px;width:100%;margin:0 auto;border:1px solid var(--gray-2)}
.card h2{font-size:18px;font-weight:800;margin-bottom:20px;text-align:center}

.err{background:rgba(239,68,68,.12);border:1px solid rgba(239,68,68,.4);color:#FCA5A5;border-radius:14px;padding:12px 16px;font-size:13.5px;font-weight:600;margin-bottom:18px;text-align:center}

.field{margin-bottom:16px}
.field label{display:block;font-size:12.5px;font-weight:800;color:var(--muted);margin-bottom:7px;letter-spacing:.3px}
.field input{width:100%;background:var(--gray-2);border:2px solid transparent;border-radius:16px;padding:16px 18px;color:#fff;font-family:inherit;font-size:16px;font-weight:600;outline:none;transition:border-color .2s}
.field input:focus{border-color:var(--yellow)}
.field input::placeholder{color:#6B6B6B;font-weight:500}

.pw-wrap{position:relative}
.pw-wrap button{position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);font-size:18px;cursor:pointer;padding:4px}

.submit{width:100%;border:none;border-radius:16px;padding:18px;background:var(--yellow);color:var(--black);font-family:inherit;font-size:16px;font-weight:900;letter-spacing:.3px;cursor:pointer;transition:transform .15s;margin-top:6px;text-transform:uppercase}
.submit:active{transform:scale(.97)}

.foot{text-align:center;margin-top:22px;font-size:12.5px;color:#6B6B6B;font-weight:600}
.foot a{color:var(--muted);text-decoration:none;border-bottom:1px dashed #4A4A4A}
</style>
</head>
<body>

<div class="brand">
  <div class="brand-badge">🛵</div>
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
        <button type="button" onclick="var p=document.getElementById('pw');p.type=p.type==='password'?'text':'password';this.textContent=p.type==='password'?'👁':'🙈'">👁</button>
      </div>
    </div>
    <button type="submit" class="submit">🛵 Vào ca làm việc</button>
  </form>

  <div class="foot">
    Không phải shipper? <a href="${ctx}/login">Đăng nhập khách hàng</a>
  </div>
</div>

</body>
</html>
