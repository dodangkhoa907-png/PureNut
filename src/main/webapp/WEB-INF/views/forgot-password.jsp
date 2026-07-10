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
body{font-family:var(--fb);background:var(--cream);color:var(--ink);min-height:100vh;min-height:100dvh;display:flex;align-items:center;justify-content:center;padding:28px;-webkit-font-smoothing:antialiased}
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
.email-hint{background:#EDF2FA;border-radius:12px;padding:10px 14px;margin-bottom:18px;font-size:13px;color:var(--navy-dark);font-weight:600;word-break:break-all;display:inline-flex;align-items:center;gap:6px}
.otp-wrap{display:flex;gap:8px;justify-content:center;margin-bottom:18px}
.otp-box{width:46px;height:56px;border-radius:12px;border:2px solid var(--line);background:#FFF;font-family:'Fraunces',serif;font-size:24px;font-weight:700;text-align:center;color:var(--navy);caret-color:var(--navy);transition:border-color .2s,box-shadow .2s,transform .15s}
.otp-box:focus{outline:none;border-color:var(--navy);box-shadow:0 0 0 3px rgba(27,79,158,.12);transform:translateY(-2px)}
.otp-box.filled{border-color:var(--green);background:#F0FAF4}
.otp-box.error{border-color:var(--red);background:#FFF5F5;animation:shake .4s}
@keyframes shake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-4px)}40%,80%{transform:translateX(4px)}}
.timer{text-align:center;margin-bottom:18px;font-size:13px;color:var(--ink-soft);font-weight:600}
.timer .time{font-family:'Fraunces',serif;font-size:18px;color:var(--navy);font-weight:700;margin-left:4px}
.timer .time.expired{color:var(--red)}
.resend-link{color:var(--navy);font-weight:700;cursor:pointer;transition:color .2s}
.resend-link:hover{color:var(--red);text-decoration:underline}
.resend-link.disabled{color:var(--ink-soft);pointer-events:none;opacity:.5}

/* ── Steps indicator ── */
.steps{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:24px}
.step-dot{width:10px;height:10px;border-radius:50%;background:var(--line);transition:all .3s}
.step-dot.active{width:28px;border-radius:99px;background:var(--navy)}
.step-dot.done{background:var(--green)}
.step-line{width:28px;height:2px;background:var(--line);margin:0 4px}
.step-line.done{background:var(--green)}

/* ── OTP paste hint ── */
.paste-hint{display:none;text-align:center;margin-bottom:14px;font-size:12px;color:var(--ink-soft);font-weight:500}
.paste-hint button{background:var(--navy);color:#fff;border:none;padding:6px 14px;border-radius:8px;font-size:12px;font-weight:600;margin-left:6px;cursor:pointer;transition:transform .15s}
.paste-hint button:active{transform:scale(.95)}

/* ══════════ 3D Box Loading Overlay ══════════ */
.loading-overlay{position:fixed;inset:0;z-index:9999;background:#FBF6EC;display:flex;flex-direction:column;align-items:center;justify-content:center;opacity:0;visibility:hidden;transition:opacity .35s,visibility .35s}
.loading-overlay.active{opacity:1;visibility:visible}
.loading-text{margin-top:50px;font-family:var(--fd);font-size:20px;font-weight:600;color:var(--navy-dark);text-align:center;position:relative;z-index:10;transform:translateZ(0)}
.loading-sub{margin-top:8px;font-size:13px;color:var(--ink-soft);font-weight:500;position:relative;z-index:10;transform:translateZ(0)}
.loading-dots::after{content:'';animation:dots 1.4s infinite steps(4)}
@keyframes dots{0%{content:''}25%{content:'.'}50%{content:'..'}75%{content:'...'}}

/* 3D Box Loader */
.loader-wrap{position:relative;width:200px;height:320px;margin:0 auto}
.loader{--duration:3s;--primary:rgba(27,79,158,1);--primary-light:#3A7AE0;--primary-rgba:rgba(27,79,158,0);width:200px;height:320px;position:relative;transform-style:preserve-3d}
.loader:before,.loader:after{--r:20.5deg;content:"";width:320px;height:140px;position:absolute;right:32%;bottom:-11px;background:#FBF6EC;transform:translateZ(200px) rotate(var(--r));animation:mask var(--duration) linear forwards infinite}
.loader:after{--r:-20.5deg;right:auto;left:32%}
.loader .ground{position:absolute;left:-50px;bottom:-120px;transform-style:preserve-3d;transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}
.loader .ground div{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(0);width:200px;height:200px;background:var(--primary);background:linear-gradient(45deg,var(--primary) 0%,var(--primary) 50%,var(--primary-light) 50%,var(--primary-light) 100%);transform-style:preserve-3d;animation:ground var(--duration) linear forwards infinite}
.loader .ground div:before,.loader .ground div:after{--rx:90deg;--ry:0deg;--x:44px;--y:162px;--z:-50px;content:"";width:156px;height:300px;opacity:0;background:linear-gradient(var(--primary),var(--primary-rgba));position:absolute;transform:rotateX(var(--rx)) rotateY(var(--ry)) translate(var(--x),var(--y)) translateZ(var(--z));animation:ground-shine var(--duration) linear forwards infinite}
.loader .ground div:after{--rx:90deg;--ry:90deg;--x:0;--y:177px;--z:150px}
.loader .box{--x:0;--y:0;position:absolute;animation:var(--duration) linear forwards infinite;transform:translate(var(--x),var(--y))}
.loader .box div{background-color:var(--primary);width:48px;height:48px;position:relative;transform-style:preserve-3d;animation:var(--duration) ease forwards infinite;transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}
.loader .box div:before,.loader .box div:after{--rx:90deg;--ry:0deg;--z:24px;--y:-24px;--x:0;content:"";position:absolute;background-color:inherit;width:inherit;height:inherit;transform:rotateX(var(--rx)) rotateY(var(--ry)) translate(var(--x),var(--y)) translateZ(var(--z));filter:brightness(var(--b,1.2))}
.loader .box div:after{--rx:0deg;--ry:90deg;--x:24px;--y:0;--b:1.4}
.loader .box.box0{--x:-40px;--y:-30px;left:58px;top:108px}
.loader .box.box1{--x:-50px;--y:30px;left:25px;top:120px}
.loader .box.box2{--x:30px;--y:-45px;left:58px;top:64px}
.loader .box.box3{--x:50px;--y:-10px;left:91px;top:120px}
.loader .box.box4{--x:15px;--y:45px;left:58px;top:132px}
.loader .box.box5{--x:-45px;--y:-25px;left:25px;top:76px}
.loader .box.box6{--x:-50px;--y:30px;left:91px;top:76px}
.loader .box.box7{--x:-45px;--y:40px;left:58px;top:87px}
.loader .box0{animation-name:box-move0}.loader .box0 div{animation-name:box-scale0}
.loader .box1{animation-name:box-move1}.loader .box1 div{animation-name:box-scale1}
.loader .box2{animation-name:box-move2}.loader .box2 div{animation-name:box-scale2}
.loader .box3{animation-name:box-move3}.loader .box3 div{animation-name:box-scale3}
.loader .box4{animation-name:box-move4}.loader .box4 div{animation-name:box-scale4}
.loader .box5{animation-name:box-move5}.loader .box5 div{animation-name:box-scale5}
.loader .box6{animation-name:box-move6}.loader .box6 div{animation-name:box-scale6}
.loader .box7{animation-name:box-move7}.loader .box7 div{animation-name:box-scale7}

@keyframes box-move0{12%{transform:translate(var(--x),var(--y))}25%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale0{6%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}14%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move1{16%{transform:translate(var(--x),var(--y))}29%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale1{10%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}18%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move2{20%{transform:translate(var(--x),var(--y))}33%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale2{14%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}22%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move3{24%{transform:translate(var(--x),var(--y))}37%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale3{18%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}26%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move4{28%{transform:translate(var(--x),var(--y))}41%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale4{22%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}30%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move5{32%{transform:translate(var(--x),var(--y))}45%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale5{26%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}34%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move6{36%{transform:translate(var(--x),var(--y))}49%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale6{30%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}38%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes box-move7{40%{transform:translate(var(--x),var(--y))}53%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
@keyframes box-scale7{34%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}42%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
@keyframes ground{0%,65%{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(0)}75%,90%{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(1)}100%{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(0)}}
@keyframes ground-shine{0%,70%{opacity:0}75%,87%{opacity:.2}100%{opacity:0}}
@keyframes mask{0%,65%{opacity:0}66%,100%{opacity:1}}

/* ══════════ Mobile ══════════ */
@media(max-width:520px){
  body{padding:16px 12px;align-items:flex-start;padding-top:68px}
  .back{top:14px;left:14px;padding:8px 14px;font-size:12px}
  .card{padding:28px 20px;border-radius:22px}
  .badge{width:64px;height:64px;font-size:28px;margin-bottom:14px}
  h1{font-size:22px}
  .sub{font-size:13px;margin:8px 0 18px}
  .steps{margin-bottom:18px}
  .step-dot{width:8px;height:8px}
  .step-dot.active{width:22px}
  .step-line{width:20px}
  .email-hint{font-size:12px;padding:8px 12px;margin-bottom:14px}
  .otp-wrap{gap:6px;margin-bottom:14px}
  .otp-box{width:42px;height:50px;font-size:20px;border-radius:10px}
  .timer{margin-bottom:14px;font-size:12px}
  .timer .time{font-size:16px}
  .submit{padding:13px;font-size:14px;border-radius:12px}
  .alt{margin-top:14px;font-size:13px}
  .field input{padding:12px 14px;font-size:14px;border-radius:12px}
  .paste-hint{display:block}
  .loader-wrap{width:160px;height:240px}
  .loader{zoom:.55}
  .loading-text{font-size:17px;margin-top:20px}
}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/login" class="back">&larr; Về đăng nhập</a>

<!-- ══════════ 3D Box Loading Overlay ══════════ -->
<div class="loading-overlay" id="loadingOverlay">
  <div class="loader-wrap">
    <div class="loader">
      <div class="box box0"><div></div></div>
      <div class="box box1"><div></div></div>
      <div class="box box2"><div></div></div>
      <div class="box box3"><div></div></div>
      <div class="box box4"><div></div></div>
      <div class="box box5"><div></div></div>
      <div class="box box6"><div></div></div>
      <div class="box box7"><div></div></div>
      <div class="ground"><div></div></div>
    </div>
  </div>
  <p class="loading-text">Đang gửi mã OTP<span class="loading-dots"></span></p>
  <p class="loading-sub">Vui lòng chờ trong giây lát</p>
</div>

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

    <div class="paste-hint" id="pasteHint">
      Đã copy mã OTP? <button type="button" id="pasteBtn">Dán mã</button>
    </div>

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

    <p class="alt" style="margin-top:14px">
      <a class="resend-link disabled" id="resendLink" href="${ctx}/resend-otp">Gửi lại mã</a>
    </p>
    <p class="alt"><a href="${ctx}/forgot-password">&larr; Quay lại nhập email</a></p>

    <script>
    (function(){
      var boxes = document.querySelectorAll('.otp-box');
      var form = document.getElementById('otpForm');

      function fillBoxes(data){
        for(var j=0;j<Math.min(data.length,boxes.length);j++){
          boxes[j].value=data[j];
          boxes[j].classList.add('filled');
        }
        var next=Math.min(data.length,boxes.length-1);
        boxes[next].focus();
        if(data.length>=6){
          var all=true;
          boxes.forEach(function(b){if(!b.value)all=false;});
          if(all) setTimeout(function(){form.submit();},200);
        }
      }

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
          fillBoxes(data);
        });
        box.addEventListener('focus', function(){ this.select(); });
      });

      // Paste button for mobile
      var pasteBtn = document.getElementById('pasteBtn');
      if(pasteBtn){
        pasteBtn.addEventListener('click', function(){
          if(navigator.clipboard && navigator.clipboard.readText){
            navigator.clipboard.readText().then(function(text){
              var data = text.replace(/[^0-9]/g,'');
              if(data.length > 0) fillBoxes(data);
            }).catch(function(){});
          }
        });
      }

      <c:if test="${not empty errorMessage}">
      boxes.forEach(function(b){ b.classList.add('error'); });
      </c:if>

      var resendEl = document.getElementById('resendLink');
      resendEl.addEventListener('click', function(){
        var overlay = document.getElementById('loadingOverlay');
        if(overlay) overlay.classList.add('active');
      });

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

    <form method="post" action="${ctx}/forgot-password" id="emailForm">
      <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
      <div class="field">
        <label for="email">Địa chỉ email</label>
        <input type="email" id="email" name="email" placeholder="ban@email.com" required autofocus value="${fn:escapeXml(param.email)}">
      </div>
      <button type="submit" class="submit" id="sendOtpBtn">Gửi mã OTP</button>
    </form>
    <p class="alt">Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay &rarr;</a></p>

    <script>
    (function(){
      var emailForm = document.getElementById('emailForm');
      var overlay = document.getElementById('loadingOverlay');
      emailForm.addEventListener('submit', function(e){
        var emailInput = document.getElementById('email');
        if(!emailInput.value || !emailInput.validity.valid) return;
        overlay.classList.add('active');
      });
    })();
    </script>
  </c:otherwise>
</c:choose>

</div>
</body>
</html>
