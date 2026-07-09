<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đặt lại mật khẩu — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.12);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:28px;-webkit-font-smoothing:antialiased}
body::after{content:"";position:fixed;inset:0;pointer-events:none;opacity:.05;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='180'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
a{text-decoration:none;color:inherit}button{font:inherit;cursor:pointer;border:none}
.blob{position:fixed;border-radius:50%;filter:blur(60px);opacity:.35;pointer-events:none;z-index:0;animation:drift 14s ease-in-out infinite}
.blob.b1{width:340px;height:340px;background:#C9EBD6;top:-110px;right:-90px}
.blob.b2{width:300px;height:300px;background:#BFE0F2;bottom:-100px;left:-80px;animation-delay:-6s}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(26px,-30px)}}
.back{position:fixed;top:22px;left:24px;z-index:20;display:inline-flex;align-items:center;gap:8px;background:var(--paper);border:1px solid var(--line);padding:10px 20px;border-radius:99px;font-weight:600;font-size:13.5px;color:var(--ink-soft);box-shadow:0 10px 26px -14px rgba(20,30,20,.3);transition:transform .2s,color .2s}
.back:hover{transform:translateX(-3px);color:var(--navy)}
@keyframes cardIn{from{opacity:0;transform:translateY(36px) scale(.97)}to{opacity:1;transform:none}}
.card{position:relative;z-index:5;width:min(480px,100%);background:var(--paper);border-radius:28px;border:1px solid var(--line);box-shadow:0 40px 90px -36px rgba(20,80,40,.35);padding:46px 44px;animation:cardIn .7s cubic-bezier(.16,1,.3,1);text-align:center}
.badge{width:84px;height:84px;border-radius:50%;background:linear-gradient(135deg,#35C878,#187A43);display:flex;align-items:center;justify-content:center;margin:0 auto 20px;font-size:36px;box-shadow:0 18px 34px -14px rgba(43,172,98,.55);animation:bob 5s ease-in-out infinite}
@keyframes bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
h1{font-family:var(--fd);font-weight:600;font-size:28px}
.sub{color:var(--ink-soft);margin:10px 0 24px;font-size:14.5px;line-height:1.6}
.alert{border-radius:14px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:16px;display:flex;gap:9px;text-align:left;background:#FCE9E9;color:#A31F1F;border:1px solid #F3C2C2}
.field{text-align:left;margin-bottom:16px}
.field label{display:block;font-size:12px;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:var(--ink-soft);margin-bottom:7px}
.field .box{position:relative}
.field input{width:100%;padding:14px 16px;border-radius:14px;border:1.5px solid var(--line);background:#FFF;font:inherit;font-size:15px;transition:border-color .2s,box-shadow .2s}
.field input:focus{outline:none;border-color:var(--green);box-shadow:0 0 0 4px rgba(43,172,98,.12)}
.field input.err-border{border-color:var(--red);box-shadow:0 0 0 4px rgba(206,46,46,.08)}
.eye{position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;color:var(--ink-soft);display:flex;padding:4px}

/* ── Steps indicator ── */
.steps{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:28px}
.step-dot{width:10px;height:10px;border-radius:50%;background:var(--line);transition:all .3s}
.step-dot.active{width:28px;border-radius:99px;background:var(--green)}
.step-dot.done{background:var(--green)}
.step-line{width:32px;height:2px;background:var(--line);margin:0 4px}
.step-line.done{background:var(--green)}

/* ── Password strength bar ── */
.strength-wrap{margin-top:10px}
.strength-track{display:flex;gap:4px}
.strength-seg{flex:1;height:4px;border-radius:99px;background:var(--line);transition:background .3s}
.strength-label{display:flex;justify-content:space-between;align-items:center;margin-top:5px}
.strength-text{font-size:11px;font-weight:700;transition:color .3s}
.strength-pct{font-size:10px;color:var(--ink-soft);font-weight:600}

/* ── Password rules checklist ── */
.pw-rules{background:#F8F6F1;border:1px solid var(--line);border-radius:14px;padding:14px 16px;margin-top:12px;text-align:left}
.pw-rules-title{font-size:11px;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:var(--ink-soft);margin-bottom:10px}
.pw-rule{display:flex;align-items:center;gap:10px;padding:6px 0;font-size:13px;font-weight:500;color:var(--ink-soft);transition:color .3s}
.pw-rule + .pw-rule{border-top:1px solid rgba(36,31,24,.06)}
.pw-rule.pass{color:var(--green)}
.pw-rule.fail{color:var(--ink-soft)}

.pw-rule .icon{width:22px;height:22px;border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:12px;font-weight:700;transition:all .3s;border:1.5px solid var(--line);background:#fff;color:var(--ink-soft)}
.pw-rule.pass .icon{background:var(--green);border-color:var(--green);color:#fff;transform:scale(1);animation:popIn .3s cubic-bezier(.34,1.56,.64,1)}
.pw-rule.fail .icon{transform:scale(.9)}
@keyframes popIn{0%{transform:scale(0)}60%{transform:scale(1.2)}100%{transform:scale(1)}}

/* ── Match indicator ── */
.match-row{display:flex;align-items:center;gap:8px;margin-top:8px;font-size:12.5px;font-weight:600;min-height:20px;transition:all .3s}
.match-row.ok{color:var(--green)}
.match-row.bad{color:var(--red)}
.match-row .dot{width:8px;height:8px;border-radius:50%;flex-shrink:0;transition:background .3s}
.match-row.ok .dot{background:var(--green)}
.match-row.bad .dot{background:var(--red)}

/* ── Submit ── */
.submit{width:100%;margin-top:20px;padding:15px;border-radius:14px;background:linear-gradient(135deg,#2BAC62,#187A43);color:#fff;font-weight:700;font-size:15.5px;box-shadow:0 16px 30px -14px rgba(43,172,98,.6);transition:transform .2s,opacity .2s}
.submit:hover:not(:disabled){transform:translateY(-2px)}
.submit:disabled{opacity:.45;cursor:not-allowed;transform:none}
</style>
</head>
<body>
<span class="blob b1"></span><span class="blob b2"></span>
<a href="${ctx}/login" class="back">← Về đăng nhập</a>

<div class="card">
  <div class="steps">
    <span class="step-dot done"></span>
    <span class="step-line done"></span>
    <span class="step-dot done"></span>
    <span class="step-line done"></span>
    <span class="step-dot done"></span>
    <span class="step-line done"></span>
    <span class="step-dot active"></span>
  </div>

  <div class="badge">🔒</div>
  <h1>Đặt lại mật khẩu</h1>
  <p class="sub">Tạo mật khẩu mới cho tài khoản của bạn. Sau khi đổi thành công, bạn sẽ được đưa về trang đăng nhập.</p>

  <c:if test="${not empty errorMessage}"><div class="alert">⚠️ <c:out value="${errorMessage}"/></div></c:if>

  <form method="post" action="${ctx}/reset-password" id="resetForm">
    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
    <div class="field">
      <label for="password">Mật khẩu mới</label>
      <div class="box">
        <input type="password" id="password" name="password" placeholder="••••••••" required autofocus autocomplete="new-password">
        <button type="button" class="eye" onclick="togglePw('password',this)" aria-label="Hiện mật khẩu"><svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg></button>
      </div>

      <!-- Strength bar -->
      <div class="strength-wrap">
        <div class="strength-track">
          <span class="strength-seg" id="seg0"></span>
          <span class="strength-seg" id="seg1"></span>
          <span class="strength-seg" id="seg2"></span>
          <span class="strength-seg" id="seg3"></span>
          <span class="strength-seg" id="seg4"></span>
        </div>
        <div class="strength-label">
          <span class="strength-text" id="strengthText"></span>
          <span class="strength-pct" id="strengthPct"></span>
        </div>
      </div>

      <!-- Rules checklist -->
      <div class="pw-rules">
        <div class="pw-rules-title">Yêu cầu mật khẩu</div>
        <div class="pw-rule fail" id="rule-len">
          <span class="icon">—</span>
          <span>Ít nhất <b>8 ký tự</b></span>
        </div>
        <div class="pw-rule fail" id="rule-upper">
          <span class="icon">—</span>
          <span>Có chữ <b>hoa</b> (A-Z)</span>
        </div>
        <div class="pw-rule fail" id="rule-lower">
          <span class="icon">—</span>
          <span>Có chữ <b>thường</b> (a-z)</span>
        </div>
        <div class="pw-rule fail" id="rule-digit">
          <span class="icon">—</span>
          <span>Có <b>chữ số</b> (0-9)</span>
        </div>
        <div class="pw-rule fail" id="rule-special">
          <span class="icon">—</span>
          <span>Có <b>ký tự đặc biệt</b> (!@#$...)</span>
        </div>
      </div>
    </div>

    <div class="field">
      <label for="confirmPassword">Xác nhận mật khẩu mới</label>
      <div class="box">
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required autocomplete="new-password">
        <button type="button" class="eye" onclick="togglePw('confirmPassword',this)" aria-label="Hiện mật khẩu"><svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg></button>
      </div>
      <div class="match-row" id="matchRow"></div>
    </div>

    <button type="submit" class="submit" id="submitBtn" disabled>Đổi mật khẩu</button>
  </form>
</div>

<script>
function togglePw(id, btn){
  var inp = document.getElementById(id);
  var show = inp.type === 'password';
  inp.type = show ? 'text' : 'password';
  var svg = btn.querySelector('svg');
  svg.style.opacity = show ? '.5' : '1';
}

(function(){
  var pw = document.getElementById('password');
  var confirm = document.getElementById('confirmPassword');
  var submitBtn = document.getElementById('submitBtn');
  var matchRow = document.getElementById('matchRow');

  var rules = {
    len:     { el: document.getElementById('rule-len'),     test: function(v){ return v.length >= 8; } },
    upper:   { el: document.getElementById('rule-upper'),   test: function(v){ return /[A-Z]/.test(v); } },
    lower:   { el: document.getElementById('rule-lower'),   test: function(v){ return /[a-z]/.test(v); } },
    digit:   { el: document.getElementById('rule-digit'),   test: function(v){ return /\d/.test(v); } },
    special: { el: document.getElementById('rule-special'), test: function(v){ return /[^a-zA-Z\d]/.test(v); } }
  };

  var segs = [
    document.getElementById('seg0'),
    document.getElementById('seg1'),
    document.getElementById('seg2'),
    document.getElementById('seg3'),
    document.getElementById('seg4')
  ];
  var strengthText = document.getElementById('strengthText');
  var strengthPct = document.getElementById('strengthPct');

  var levels = [
    { color: '#CE2E2E', label: 'Rất yếu' },
    { color: '#E67E22', label: 'Yếu' },
    { color: '#F2B705', label: 'Trung bình' },
    { color: '#84CC16', label: 'Khá mạnh' },
    { color: '#2BAC62', label: 'Mạnh' }
  ];

  function checkRules(){
    var v = pw.value;
    var passed = 0;

    for(var key in rules){
      var r = rules[key];
      var ok = r.test(v);
      r.el.className = 'pw-rule ' + (ok ? 'pass' : 'fail');
      r.el.querySelector('.icon').textContent = ok ? '✓' : '—';
      if(ok) passed++;
    }

    // Strength bar
    if(!v){
      segs.forEach(function(s){ s.style.background = ''; });
      strengthText.textContent = '';
      strengthPct.textContent = '';
    } else {
      var lvl = levels[Math.max(passed - 1, 0)];
      segs.forEach(function(s, i){
        s.style.background = i < passed ? lvl.color : '';
      });
      strengthText.textContent = lvl.label;
      strengthText.style.color = lvl.color;
      strengthPct.textContent = (passed * 20) + '%';
    }

    checkMatch();
  }

  function checkMatch(){
    var v1 = pw.value;
    var v2 = confirm.value;

    // Count passed rules
    var allPass = true;
    for(var key in rules){
      if(!rules[key].test(v1)){ allPass = false; break; }
    }

    if(!v2){
      matchRow.className = 'match-row';
      matchRow.innerHTML = '';
      confirm.classList.remove('err-border');
      submitBtn.disabled = true;
      return;
    }

    if(v1 === v2){
      matchRow.className = 'match-row ok';
      matchRow.innerHTML = '<span class="dot"></span> Mật khẩu khớp';
      confirm.classList.remove('err-border');
      submitBtn.disabled = !allPass;
    } else {
      matchRow.className = 'match-row bad';
      matchRow.innerHTML = '<span class="dot"></span> Mật khẩu không khớp';
      confirm.classList.add('err-border');
      submitBtn.disabled = true;
    }
  }

  pw.addEventListener('input', checkRules);
  confirm.addEventListener('input', checkMatch);
})();
</script>
</body>
</html>
