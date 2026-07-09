<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isOtpStep" value="${not empty resetEmail}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${isOtpStep ? 'Xác thực OTP' : 'Quên mật khẩu'} — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.12);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:28px;-webkit-font-smoothing:antialiased}
body::after{content:"";position:fixed;inset:0;pointer-events:none;opacity:.05;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='180'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
a{text-decoration:none;color:inherit}button{font:inherit;cursor:pointer;border:none}
.blob{position:fixed;border-radius:50%;filter:blur(60px);opacity:.35;pointer-events:none;z-index:0;animation:drift 14s ease-in-out infinite}
.blob.b1{width:340px;height:340px;background:#BFE0F2;top:-110px;left:-90px}
.blob.b2{width:300px;height:300px;background:#F3D98B;bottom:-100px;right:-80px;animation-delay:-6s}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(26px,-30px)}}
.back{position:fixed;top:22px;left:24px;z-index:20;display:inline-flex;align-items:center;gap:8px;background:var(--paper);border:1px solid var(--line);padding:10px 20px;border-radius:99px;font-weight:600;font-size:13.5px;color:var(--ink-soft);box-shadow:0 10px 26px -14px rgba(20,30,20,.3);transition:transform .2s,color .2s}
.back:hover{transform:translateX(-3px);color:var(--navy)}
@keyframes cardIn{from{opacity:0;transform:translateY(36px) scale(.97)}to{opacity:1;transform:none}}
.card{position:relative;z-index:5;width:min(480px,100%);background:var(--paper);border-radius:28px;border:1px solid var(--line);box-shadow:0 40px 90px -36px rgba(11,37,71,.4);padding:46px 44px;animation:cardIn .7s cubic-bezier(.16,1,.3,1);text-align:center}
.badge{width:84px;height:84px;border-radius:50%;background:linear-gradient(135deg,#2E6BC0,var(--navy-darker));display:flex;align-items:center;justify-content:center;margin:0 auto 20px;font-size:36px;box-shadow:0 18px 34px -14px rgba(27,79,158,.55);animation:bob 5s ease-in-out infinite}
@keyframes bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
h1{font-family:var(--fd);font-weight:600;font-size:28px}
.sub{color:var(--ink-soft);margin:10px 0 24px;font-size:14.5px;line-height:1.6}
.alert{border-radius:14px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:16px;display:flex;gap:9px;text-align:left}
.alert.err{background:#FCE9E9;color:#A31F1F;border:1px solid #F3C2C2}
.alert.ok{background:#E7F6EC;color:#187A43;border:1px solid #BFE4CC}
.field{text-align:left;margin-bottom:18px}
.field label{display:block;font-size:12px;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:var(--ink-soft);margin-bottom:7px}
.field input{width:100%;padding:14px 16px;border-radius:14px;border:1.5px solid var(--line);background:#FFF;font:inherit;font-size:15px;transition:border-color .2s,box-shadow .2s}
.field input:focus{outline:none;border-color:var(--navy);box-shadow:0 0 0 4px rgba(27,79,158,.12)}
.submit{width:100%;padding:15px;border-radius:14px;background:linear-gradient(135deg,var(--navy),var(--navy-darker));color:#fff;font-weight:700;font-size:15.5px;box-shadow:0 16px 30px -14px rgba(27,79,158,.6);transition:transform .2s}
.submit:hover{transform:translateY(-2px)}
.alt{margin-top:20px;font-size:14px;color:var(--ink-soft)}
.alt a{color:var(--red);font-weight:700}
.alt a:hover{text-decoration:underline}

/* ── OTP step ── */
.email-hint{background:#EDF2FA;border-radius:12px;padding:12px 16px;margin-bottom:20px;font-size:13.5px;color:var(--navy-dark);font-weight:600;word-break:break-all}
.otp-wrap{display:flex;gap:10px;justify-content:center;margin-bottom:20px}
.otp-box{width:52px;height:62px;border-radius:14px;border:2px solid var(--line);background:#FFF;font-family:'Fraunces',serif;font-size:26px;font-weight:700;text-align:center;color:var(--navy);caret-color:var(--navy);transition:border-color .2s,box-shadow .2s,transform .15s}
.otp-box:focus{outline:none;border-color:var(--navy);box-shadow:0 0 0 4px rgba(27,79,158,.12);transform:translateY(-2px)}
.otp-box.filled{border-color:var(--green);background:#F0FAF4}
.otp-box.error{border-color:var(--red);background:#FFF5F5;animation:shake .4s}
@keyframes shake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-4px)}40%,80%{transform:translateX(4px)}}
.timer{text-align:center;margin-bottom:22px;font-size:14px;color:var(--ink-soft);font-weight:600}
.timer .time{font-family:'Fraunces',serif;font-size:20px;color:var(--navy);font-weight:700;margin-left:4px}
.timer .time.expired{color:var(--red)}
.resend-link{color:var(--navy);font-weight:700;cursor:pointer;transition:color .2s}
.resend-link:hover{color:var(--red);text-decoration:underline}
.resend-link.disabled{color:var(--ink-soft);pointer-events:none;opacity:.5}

/* ── Steps indicator ── */
.steps{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:28px}
.step-dot{width:10px;height:10px;border-radius:50%;background:var(--line);transition:all .3s}
.step-dot.active{width:28px;border-radius:99px;background:var(--navy)}
.step-dot.done{background:var(--green)}
.step-line{width:32px;height:2px;background:var(--line);margin:0 4px}
.step-line.done{background:var(--green)}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/login" class="back">← Về đăng nhập</a>

<div class="card">

<c:choose>
  <%-- ═══════════════ STEP 3: OTP VERIFICATION ═══════════════ --%>
  <c:when test="${isOtpStep}">
    <div class="steps">
      <span class="step-dot done"></span>
      <span class="step-line done"></span>
      <span class="step-dot done"></span>
      <span class="step-line done"></span>
      <span class="step-dot active"></span>
      <span class="step-line"></span>
      <span class="step-dot"></span>
    </div>

    <div class="badge">📲</div>
    <h1>Xác thực OTP</h1>
    <p class="sub">Nhập mã 6 chữ số đã gửi đến email của bạn.</p>

    <div class="email-hint">📧 ${resetEmail}</div>

    <c:if test="${not empty errorMessage}"><div class="alert err">⚠️ <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/verify-otp" id="otpForm">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="otp-wrap" id="otpWrap">
        <input type="text" name="d1" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]" autocomplete="one-time-code" autofocus>
        <input type="text" name="d2" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d3" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d4" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d5" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
        <input type="text" name="d6" class="otp-box" maxlength="1" inputmode="numeric" pattern="[0-9]">
      </div>

      <div class="timer" id="timerArea">
        <span id="timerText">Mã hết hạn sau <span class="time" id="countdown"></span></span>
      </div>

      <button type="submit" class="submit" id="verifyBtn">Xác nhận mã OTP</button>
    </form>

    <p class="alt" style="margin-top:16px">
      <a class="resend-link disabled" id="resendLink" href="${ctx}/resend-otp">Gửi lại mã</a>
    </p>
    <p class="alt"><a href="${ctx}/forgot-password">← Quay lại nhập email</a></p>

    <script>
    (function(){
      var boxes = document.querySelectorAll('.otp-box');
      var form = document.getElementById('otpForm');

      boxes.forEach(function(box, i){
        box.addEventListener('input', function(){
          var v = this.value.replace(/[^0-9]/g,'');
          this.value = v;
          if(v){
            this.classList.add('filled');
            this.classList.remove('error');
            if(i < boxes.length - 1) boxes[i+1].focus();
          } else {
            this.classList.remove('filled');
          }
        });
        box.addEventListener('keydown', function(e){
          if(e.key === 'Backspace' && !this.value && i > 0){
            boxes[i-1].focus();
            boxes[i-1].value = '';
            boxes[i-1].classList.remove('filled');
          }
          if(e.key === 'ArrowLeft' && i > 0) boxes[i-1].focus();
          if(e.key === 'ArrowRight' && i < boxes.length-1) boxes[i+1].focus();
        });
        box.addEventListener('paste', function(e){
          e.preventDefault();
          var data = (e.clipboardData || window.clipboardData).getData('text').replace(/[^0-9]/g,'');
          for(var j = 0; j < Math.min(data.length, boxes.length); j++){
            boxes[j].value = data[j];
            boxes[j].classList.add('filled');
          }
          var next = Math.min(data.length, boxes.length - 1);
          boxes[next].focus();
        });
        box.addEventListener('focus', function(){ this.select(); });
      });

      <c:if test="${not empty errorMessage}">
      boxes.forEach(function(b){ b.classList.add('error'); });
      </c:if>

      // Countdown timer
      var remaining = ${remainingMs};
      var countdownEl = document.getElementById('countdown');
      var timerText = document.getElementById('timerText');
      var resendLink = document.getElementById('resendLink');

      function pad(n){ return n < 10 ? '0' + n : '' + n; }

      function tick(){
        if(remaining <= 0){
          countdownEl.textContent = '00:00';
          countdownEl.classList.add('expired');
          timerText.innerHTML = 'Mã OTP đã hết hạn';
          resendLink.classList.remove('disabled');
          return;
        }
        var m = Math.floor(remaining / 60000);
        var s = Math.floor((remaining % 60000) / 1000);
        countdownEl.textContent = pad(m) + ':' + pad(s);
        remaining -= 1000;
        setTimeout(tick, 1000);
      }
      tick();

      // Auto-submit when last digit entered
      boxes[boxes.length-1].addEventListener('input', function(){
        var all = true;
        boxes.forEach(function(b){ if(!b.value) all = false; });
        if(all) setTimeout(function(){ form.submit(); }, 150);
      });
    })();
    </script>
  </c:when>

  <%-- ═══════════════ STEP 1: EMAIL INPUT ═══════════════ --%>
  <c:otherwise>
    <div class="steps">
      <span class="step-dot active"></span>
      <span class="step-line"></span>
      <span class="step-dot"></span>
      <span class="step-line"></span>
      <span class="step-dot"></span>
      <span class="step-line"></span>
      <span class="step-dot"></span>
    </div>

    <div class="badge">🔑</div>
    <h1>Quên mật khẩu?</h1>
    <p class="sub">Nhập email đã đăng ký — chúng tôi sẽ gửi mã OTP 6 chữ số để xác thực (hiệu lực 5 phút).</p>

    <c:if test="${not empty errorMessage}"><div class="alert err">⚠️ <c:out value="${errorMessage}"/></div></c:if>

    <form method="post" action="${ctx}/forgot-password">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="email">Địa chỉ email</label>
        <input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}">
      </div>
      <button type="submit" class="submit">Gửi mã OTP</button>
    </form>
    <p class="alt">Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay →</a></p>
  </c:otherwise>
</c:choose>

</div>
</body>
</html>
