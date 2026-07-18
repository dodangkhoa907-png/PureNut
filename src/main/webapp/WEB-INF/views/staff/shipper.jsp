<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
<meta name="theme-color" content="#F3F4F6">
<title>Shipper — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
/* ==========================================================================
   DESIGN TOKENS — Light Mode, GrabDriver/ShopeeFood-style
   ========================================================================== */
:root{
  --bg:#F3F4F6;            /* nền tổng thể, chống chói ngoài trời */
  --card:#FFFFFF;           /* nền thẻ */
  --accent:#F59E0B;         /* vàng cam thương hiệu — CTA / active */
  --accent-dark:#D97706;
  --accent-soft:#FEF3C7;
  --text-dark:#1F2937;      /* chữ chính */
  --text-muted:#6B7280;     /* chữ phụ */
  --border:#E5E7EB;
  --green:#16A34A;          /* hoàn thành */
  --green-soft:#DCFCE7;
  --red:#EF4444;            /* thất bại / gấp */
  --red-soft:#FEE2E2;
  --blue:#2563EB;           /* chờ bàn giao */
  --blue-soft:#DBEAFE;
  --radius-card:22px;
  --radius-btn:16px;
  --shadow-card:0 1px 3px rgba(17,24,39,.04), 0 8px 24px -12px rgba(17,24,39,.10);
  --font:'Inter',system-ui,sans-serif;
}
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent}
html{font-size:16px}
body{
  font-family:var(--font);background:var(--bg);color:var(--text-dark);
  min-height:100vh;-webkit-font-smoothing:antialiased;line-height:1.4;
}
button,input{font-family:inherit}
a{text-decoration:none;color:inherit}

/* ==========================================================================
   APP SHELL
   < 768px   : xếp chồng 1 cột, Nav ghim xuống đáy (Bottom Navigation)
   768-1023  : xếp chồng 1 cột, Nav dạng thanh ngang dưới profile
   >= 1024px : Sidebar (trái, cố định) + Main Content (phải, order GRID)
   ========================================================================== */
.app-shell{display:flex;flex-direction:column;min-height:100vh}
.main-content{flex:1;min-width:0}

/* ==========================================================================
   SIDEBAR — logo, profile card (tên + toggle), menu điều hướng
   ========================================================================== */
.sidebar{
  background:var(--card);box-shadow:0 4px 20px rgba(0,0,0,.05);
  position:sticky;top:0;z-index:50;
}
.sidebar-inner{padding:calc(14px + env(safe-area-inset-top)) 18px 12px}
.sidebar-brand{
  display:flex;align-items:center;gap:7px;margin-bottom:12px;
  font-size:12px;font-weight:800;color:var(--accent-dark);letter-spacing:.4px;text-transform:uppercase;
}
.sidebar-brand svg{width:17px;height:17px}

.profile-card{display:flex;align-items:center;gap:12px;margin-bottom:12px}
.avatar{
  width:46px;height:46px;border-radius:14px;flex-shrink:0;
  background:var(--accent-soft);color:var(--accent-dark);
  display:flex;align-items:center;justify-content:center;font-weight:800;font-size:18px;
}
.profile-info{min-width:0;flex:1}
.tb-name{font-weight:700;font-size:15.5px;color:var(--text-dark);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.tb-sub{font-size:12.5px;color:var(--text-muted);font-weight:500;margin-top:1px}
.logout-btn{
  width:38px;height:38px;border-radius:12px;border:1px solid var(--border);background:var(--bg);
  display:flex;align-items:center;justify-content:center;color:var(--text-muted);flex-shrink:0;
}
.logout-btn svg{width:17px;height:17px}
.logout-btn:active{transform:scale(.94)}

/* Toggle switch — nút gạt trực tuyến/nghỉ ngơi */
.toggle-row{
  display:flex;align-items:center;justify-content:space-between;gap:10px;
  background:var(--bg);border-radius:14px;padding:10px 14px;margin-bottom:12px;
}
.toggle-label{font-size:13px;font-weight:700;color:var(--text-muted);white-space:nowrap}
.toggle-label.on{color:var(--green)}
.switch{position:relative;width:46px;height:27px;flex-shrink:0}
.switch input{position:absolute;opacity:0;width:100%;height:100%;margin:0;cursor:pointer;z-index:2}
.switch .track{position:absolute;inset:0;background:var(--border);border-radius:99px;transition:background .25s}
.switch .knob{
  position:absolute;top:3px;left:3px;width:21px;height:21px;border-radius:50%;
  background:#fff;box-shadow:0 1px 3px rgba(0,0,0,.25);transition:transform .25s cubic-bezier(.4,0,.2,1);
}
.switch input:checked ~ .track{background:var(--green)}
.switch input:checked ~ .knob{transform:translateX(19px)}

/* Menu điều hướng (nav-item dùng chung cho cả 3 breakpoint, đổi layout qua CSS) */
.side-nav{display:flex;gap:6px}
.nav-item{
  flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:3px;
  border:none;background:transparent;color:var(--text-muted);
  padding:9px 4px;font-size:11px;font-weight:700;border-radius:12px;cursor:pointer;
  transition:background .25s,color .25s;text-align:center;
}
.nav-item svg{width:19px;height:19px}
.nav-item.active{background:var(--accent);color:#fff;box-shadow:0 4px 10px -2px rgba(245,158,11,.5)}

/* ==========================================================================
   DASHBOARD STATS — 2 ô vuông
   ========================================================================== */
.stats-row{display:grid;grid-template-columns:1fr 1fr;gap:10px;padding:14px 18px 0}
.stat-box{
  background:var(--card);border-radius:18px;padding:16px 14px;
  border:1px solid var(--border);box-shadow:var(--shadow-card);
}
.stat-box .num{font-size:30px;font-weight:900;color:var(--text-dark);line-height:1;letter-spacing:-.5px}
.stat-box.active .num{color:var(--accent-dark)}
.stat-box.done .num{color:var(--green)}
.stat-box .lbl{font-size:12.5px;font-weight:600;color:var(--text-muted);margin-top:6px}

/* ==========================================================================
   4. ORDER CARD — trái tim của UI
   ========================================================================== */
.order-list{padding:16px 18px 110px;display:flex;flex-direction:column;gap:16px}
.order-card{
  background:var(--card);border-radius:var(--radius-card);
  box-shadow:var(--shadow-card);border:1px solid var(--border);
  overflow:hidden;animation:cardIn .3s ease both;
}
@keyframes cardIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:none}}
.order-card.is-history{opacity:.72}

/* -- Header: mã đơn + tag trạng thái -- */
.oc-header{
  display:flex;align-items:center;justify-content:space-between;
  padding:16px 18px;border-bottom:1px solid var(--border);
}
.oc-id{font-size:17px;font-weight:800;color:var(--text-dark)}
.oc-tag{
  font-size:11px;font-weight:800;letter-spacing:.3px;padding:6px 12px;border-radius:99px;
  white-space:nowrap;
}
.tag-ASSIGNED{background:var(--blue-soft);color:var(--blue)}
.tag-PICKING_UP{background:var(--accent-soft);color:var(--accent-dark)}
.tag-DELIVERING{background:var(--accent-soft);color:var(--accent-dark)}
.tag-COMPLETED{background:var(--green-soft);color:var(--green)}
.tag-FAILED{background:var(--red-soft);color:var(--red)}

/* -- Body: thông tin khách -- */
.oc-body{padding:16px 18px 18px}
.oc-customer{font-size:17px;font-weight:800;color:var(--text-dark);margin-bottom:8px}
.oc-address{
  display:flex;align-items:flex-start;gap:8px;font-size:14px;color:var(--text-muted);
  line-height:1.5;font-weight:500;margin-bottom:14px;
}
.oc-address svg{width:17px;height:17px;flex-shrink:0;margin-top:1px;color:var(--text-muted)}

/* Khối báo giá COD */
.oc-cod{
  display:flex;align-items:center;justify-content:space-between;
  border-radius:14px;padding:13px 16px;margin-bottom:14px;
}
.oc-cod.is-cod{background:var(--red-soft)}
.oc-cod.is-paid{background:var(--green-soft)}
.oc-cod .cod-lbl{font-size:12px;font-weight:700;color:var(--text-muted)}
.oc-cod.is-cod .cod-lbl{color:#B91C1C}
.oc-cod.is-paid .cod-lbl{color:#15803D}
.oc-cod .cod-amt{font-size:20px;font-weight:900;letter-spacing:-.3px}
.oc-cod.is-cod .cod-amt{color:var(--red)}
.oc-cod.is-paid .cod-amt{color:var(--green)}

/* Mini map */
.oc-map{
  border-radius:16px;overflow:hidden;margin-bottom:14px;border:1px solid var(--border);
  background:var(--bg);position:relative;
}
.oc-map iframe{display:block;width:100%;height:150px;border:0}
.oc-map .map-placeholder{
  height:150px;display:flex;flex-direction:column;align-items:center;justify-content:center;
  gap:6px;color:var(--text-muted);font-size:12.5px;font-weight:600;
}
.oc-map .map-placeholder svg{width:26px;height:26px;opacity:.5}

/* -- Action buttons: hàng 1 (gọi/chỉ đường) -- */
.oc-quick-row{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:12px}
.btn-quick{
  display:flex;align-items:center;justify-content:center;gap:7px;
  background:var(--bg);color:var(--text-dark);border:1px solid var(--border);
  border-radius:var(--radius-btn);padding:14px 8px;font-size:14px;font-weight:700;
  transition:transform .15s,background .15s;
}
.btn-quick svg{width:17px;height:17px}
.btn-quick:active{transform:scale(.96);background:var(--border)}

/* -- Action buttons: hàng 2 (primary CTA khổng lồ) -- */
.btn-primary{
  position:relative;overflow:hidden;width:100%;min-height:56px;
  border:none;border-radius:var(--radius-btn);
  background:var(--accent);color:#fff;
  font-size:15.5px;font-weight:800;letter-spacing:.2px;
  display:flex;align-items:center;justify-content:center;gap:8px;
  cursor:pointer;transition:transform .15s,box-shadow .15s;
  box-shadow:0 10px 20px -8px rgba(245,158,11,.55);
}
.btn-primary svg{width:19px;height:19px}
.btn-primary:active{transform:scale(.97)}
.btn-primary:disabled{opacity:.5}
.ripple{position:absolute;border-radius:50%;background:rgba(255,255,255,.45);transform:scale(0);animation:rip .55s ease-out;pointer-events:none}
@keyframes rip{to{transform:scale(3.2);opacity:0}}

.fail-link{
  display:block;width:100%;text-align:center;margin-top:10px;background:none;border:none;
  color:var(--red);font-size:13px;font-weight:700;cursor:pointer;padding:8px;
}

/* Camera proof */
.proof-row{display:flex;gap:10px;margin-bottom:12px;align-items:center}
.proof-btn{
  flex:1;display:flex;align-items:center;justify-content:center;gap:8px;
  border:1.5px dashed var(--accent);background:var(--accent-soft);color:var(--accent-dark);
  border-radius:var(--radius-btn);padding:14px;font-size:13.5px;font-weight:700;cursor:pointer;
}
.proof-btn svg{width:17px;height:17px}
.proof-thumb{width:52px;height:52px;border-radius:12px;object-fit:cover;border:2px solid var(--green);display:none;flex-shrink:0}
.proof-thumb.show{display:block}

/* Swipe to complete */
.swipe{position:relative;height:60px;background:var(--bg);border-radius:99px;overflow:hidden;user-select:none;touch-action:pan-y;border:1px solid var(--border)}
.swipe-fill{position:absolute;inset:0;width:0;background:linear-gradient(90deg,#BBF7D0,#86EFAC);transition:width .1s}
.swipe-txt{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:800;color:var(--text-muted);letter-spacing:.3px}
.swipe-knob{position:absolute;top:4px;left:4px;width:52px;height:52px;border-radius:50%;background:var(--green);display:flex;align-items:center;justify-content:center;color:#fff;box-shadow:0 4px 10px rgba(22,163,74,.4);transition:left .25s cubic-bezier(.2,.8,.3,1)}
.swipe-knob svg{width:22px;height:22px}
.swipe.locked{opacity:.5;pointer-events:none}
.swipe.done .swipe-fill{width:100%}

.proof-view{width:100%;border-radius:14px;margin-top:10px;max-height:160px;object-fit:cover;display:block}

/* Empty state */
.empty{text-align:center;padding:70px 24px;color:var(--text-muted)}
.empty svg{width:46px;height:46px;opacity:.35;margin-bottom:14px}
.empty p{font-weight:600;font-size:14px}

/* Toast */
.toast{
  position:fixed;left:50%;bottom:100px;transform:translateX(-50%) translateY(16px);
  background:var(--text-dark);color:#fff;font-size:13.5px;font-weight:700;
  padding:13px 24px;border-radius:99px;opacity:0;transition:all .3s;z-index:200;
  box-shadow:0 12px 30px rgba(0,0,0,.25);max-width:88%;text-align:center;
}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}

/* Chat FAB + sheet */
.fab{
  position:fixed;right:18px;bottom:calc(20px + env(safe-area-inset-bottom));
  width:56px;height:56px;border-radius:50%;background:var(--accent);color:#fff;border:none;
  cursor:pointer;box-shadow:0 10px 26px -6px rgba(245,158,11,.6);z-index:90;
  display:flex;align-items:center;justify-content:center;
}
.fab svg{width:24px;height:24px}
@media(max-width:767.98px){.fab{bottom:calc(76px + env(safe-area-inset-bottom))}}
.sheet{position:fixed;inset:0;z-index:100;display:none}
.sheet.show{display:block}
.sheet-bg{position:absolute;inset:0;background:rgba(17,24,39,.5)}
.sheet-body{
  position:absolute;left:0;right:0;bottom:0;max-width:480px;margin:0 auto;
  background:var(--card);border-radius:24px 24px 0 0;max-height:78vh;
  display:flex;flex-direction:column;padding-bottom:env(safe-area-inset-bottom);
}
.sheet-hd{display:flex;justify-content:space-between;align-items:center;padding:16px 20px;border-bottom:1px solid var(--border);font-weight:800;font-size:16px}
.sheet-hd button{background:none;border:none;color:var(--text-muted);font-size:22px;cursor:pointer;line-height:1}
.msgs{flex:1;overflow-y:auto;padding:16px;min-height:220px;max-height:44vh}
.m{max-width:80%;margin-bottom:12px;padding:11px 15px;border-radius:16px;font-size:14px;line-height:1.45;word-break:break-word}
.m.them{background:var(--bg)}
.m.mine{background:var(--accent);color:#fff;margin-left:auto;font-weight:600}
.m small{display:block;font-size:10.5px;opacity:.6;margin-top:4px}
.m .who{font-size:11px;font-weight:800;color:var(--accent-dark);margin-bottom:3px}
.m.mine .who{display:none}
.chat-in{display:flex;gap:10px;padding:14px;border-top:1px solid var(--border)}
.chat-in input{flex:1;background:var(--bg);border:1px solid var(--border);border-radius:99px;padding:12px 18px;font-size:14px;outline:none;color:var(--text-dark)}
.chat-in button{background:var(--accent);color:#fff;border:none;border-radius:99px;width:46px;flex-shrink:0;display:flex;align-items:center;justify-content:center;cursor:pointer}
.chat-in button svg{width:18px;height:18px}

/* Camera sheet — chụp ảnh xác nhận (getUserMedia) */
.camera-body{background:#000}
.camera-body .sheet-hd{background:var(--card)}
.camera-stage{position:relative;background:#000;aspect-ratio:3/4;max-height:56vh;overflow:hidden}
.camera-stage video,.camera-stage img{width:100%;height:100%;object-fit:cover;display:block}
.camera-error{
  position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;
  gap:10px;color:#D1D5DB;padding:30px;text-align:center;background:#111827;
}
.camera-error svg{width:34px;height:34px;opacity:.6}
.camera-error p{font-size:13.5px;font-weight:500;line-height:1.5}
.camera-actions{
  display:flex;align-items:center;justify-content:space-between;gap:14px;
  padding:18px 24px;padding-bottom:calc(18px + env(safe-area-inset-bottom));background:var(--card);
}
.cam-btn{border:none;background:none;cursor:pointer;color:var(--text-dark);font-family:inherit}
.cam-btn-outline{
  display:flex;flex-direction:column;align-items:center;gap:4px;font-size:11px;font-weight:700;
  color:var(--text-muted);width:56px;
}
.cam-btn-outline svg{width:22px;height:22px}
.cam-shutter{
  width:68px;height:68px;border-radius:50%;background:#fff;border:4px solid var(--accent);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
}
.cam-shutter span{width:52px;height:52px;border-radius:50%;background:var(--accent)}
.cam-shutter:active{transform:scale(.95)}
.cam-btn-primary{
  display:flex;flex-direction:column;align-items:center;gap:4px;font-size:11px;font-weight:700;
  color:var(--green);width:56px;
}
.cam-btn-primary svg{width:22px;height:22px}

/* ==========================================================================
   RESPONSIVE — 3 chế độ (đặt SAU cùng để luôn thắng các rule .order-list/
   .sidebar/.side-nav mặc định phía trên trong cascade)
   ========================================================================== */

/* ---- < 768px: Mobile — Nav ghim xuống đáy màn hình, 1 cột ---- */
@media(max-width:767.98px){
  .side-nav{
    position:fixed;left:0;right:0;bottom:0;z-index:60;
    background:var(--card);box-shadow:0 -2px 16px rgba(0,0,0,.06);
    padding:6px 10px calc(6px + env(safe-area-inset-bottom));
  }
  .nav-item.active{box-shadow:none}
  .order-list{padding-bottom:96px}
}

/* ---- >= 768px: order card dàn thành lưới, tối đa 3 thẻ/hàng rồi kéo xuống ---- */
@media(min-width:768px){
  .order-list{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
    gap:18px;padding:18px 18px 40px;
  }
  .order-card{animation:none}
}
@media(min-width:1180px){
  .order-list{grid-template-columns:repeat(3,minmax(0,1fr))}
}

/* ---- >= 1024px: Desktop — Sidebar trái cố định + Main Content phải ---- */
@media(min-width:1024px){
  .app-shell{flex-direction:row}
  .sidebar{
    width:260px;flex-shrink:0;height:100vh;top:0;
    border-right:1px solid var(--border);box-shadow:none;
  }
  .sidebar-inner{
    padding:24px 18px;height:100%;display:flex;flex-direction:column;
  }
  .side-nav{position:static;flex-direction:column;margin-top:8px;background:none;box-shadow:none;padding:0}
  .nav-item{
    flex-direction:row;justify-content:flex-start;gap:11px;padding:12px 14px;font-size:14px;
  }
  .main-content{padding:0 32px}
  .stats-row{padding:24px 0 0;grid-template-columns:repeat(2,minmax(150px,210px));justify-content:start}
  .order-list{padding:24px 0 60px 0}
  .fab{right:32px}
}
</style>
</head>
<body>
<c:set var="me" value="${not empty sessionScope.shipperUser ? sessionScope.shipperUser : sessionScope.adminUser}"/>
<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="todayDate" value="${now}" pattern="yyyy-MM-dd"/>

<div class="app-shell">

  <!-- ===================== SIDEBAR (desktop) / Top+Bottom nav (mobile) ===================== -->
  <aside class="sidebar">
    <div class="sidebar-inner">
      <div class="sidebar-brand">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z"/></svg>
        PureNut Shipper
      </div>

      <!-- Profile card: avatar, tên, đăng xuất -->
      <div class="profile-card">
        <div class="avatar">${fn:toUpperCase(fn:substring(me.fullName,0,1))}</div>
        <div class="profile-info">
          <div class="tb-name"><c:out value="${me.fullName}"/></div>
          <div class="tb-sub"><c:if test="${not empty profile.vehiclePlate}">🏍 <c:out value="${profile.vehiclePlate}"/></c:if><c:if test="${empty profile.vehiclePlate}">Đối tác giao hàng</c:if></div>
        </div>
        <a class="logout-btn" href="${ctx}/shipper/logout" title="Đăng xuất" aria-label="Đăng xuất">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>
        </a>
      </div>

      <!-- Toggle: Trực tuyến / Nghỉ ngơi -->
      <div class="toggle-row">
        <span class="toggle-label ${profile.status == 'ACTIVE' ? 'on' : ''}" id="toggleLabel">${profile.status == 'ACTIVE' ? 'Trực tuyến' : 'Nghỉ ngơi'}</span>
        <label class="switch">
          <input type="checkbox" id="statusToggle" data-status="${profile.status}" ${profile.status == 'ACTIVE' ? 'checked' : ''}>
          <span class="track"></span>
          <span class="knob"></span>
        </label>
      </div>

      <!-- Menu điều hướng luồng đơn hàng (bottom-nav ở mobile, sidebar-nav ở desktop) -->
      <nav class="side-nav" id="tabs">
        <button type="button" class="nav-item active" data-tab="waiting">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13" rx="2"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="1.5"/><circle cx="17.5" cy="18.5" r="1.5"/></svg>
          <span>Chờ lấy hàng</span>
        </button>
        <button type="button" class="nav-item" data-tab="delivering">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.3 2.3c-.6.6-.2 1.7.7 1.7H17M9 21a1 1 0 100-2 1 1 0 000 2zM19 21a1 1 0 100-2 1 1 0 000 2z"/></svg>
          <span>Đang giao</span>
        </button>
        <button type="button" class="nav-item" data-tab="history">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
          <span>Lịch sử</span>
        </button>
      </nav>
    </div>
  </aside>

  <!-- ===================== MAIN CONTENT ===================== -->
  <main class="main-content">

  <!-- Thống kê nhanh -->
  <section class="stats-row">
    <div class="stat-box active"><div class="num" id="statActive">${activeCount}</div><div class="lbl">Đang giao</div></div>
    <div class="stat-box done"><div class="num" id="statDone">${doneCount}</div><div class="lbl">Hoàn thành</div></div>
  </section>

  <!-- Order grid -->
  <div class="order-list" id="orderList">

    <c:if test="${empty orders}">
      <div class="empty" id="noOrdersAtAll">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
        <p>Chưa có đơn nào được gán.<br>Chờ điều phối từ PureNut nhé!</p>
      </div>
    </c:if>
    <div class="empty" id="emptyState" style="display:none">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
      <p>Không có đơn nào trong mục này.</p>
    </div>

    <c:forEach var="o" items="${orders}">
      <fmt:formatDate var="orderDate" value="${o.createdAt}" pattern="yyyy-MM-dd"/>
      <c:set var="isToday" value="${orderDate == todayDate}"/>
      <c:set var="ds" value="${empty o.deliveryStatus ? 'ASSIGNED' : o.deliveryStatus}"/>
      <%-- Nhóm tab: waiting = chờ lấy hàng | delivering = đang bàn giao/đang giao | history = xong/thất bại --%>
      <c:set var="tabGroup" value="${ds == 'ASSIGNED' ? 'waiting' : (ds == 'PICKING_UP' || ds == 'DELIVERING' ? 'delivering' : 'history')}"/>
      <c:set var="isCod" value="${o.paymentMethod == 'COD'}"/>

      <article class="order-card ${tabGroup == 'history' ? 'is-history' : ''}"
               id="card${o.orderId}" data-tab-group="${tabGroup}" data-status="${ds}" data-today="${isToday}">

        <!-- Header: mã đơn + tag trạng thái -->
        <div class="oc-header">
          <span class="oc-id">#${o.orderId}</span>
          <span class="oc-tag tag-${ds}" id="chip${o.orderId}">
            <c:choose>
              <c:when test="${ds == 'ASSIGNED'}">CHỜ BÀN GIAO</c:when>
              <c:when test="${ds == 'PICKING_UP'}">ĐANG BÀN GIAO</c:when>
              <c:when test="${ds == 'DELIVERING'}">ĐANG GIAO</c:when>
              <c:when test="${ds == 'COMPLETED'}">HOÀN THÀNH ✓</c:when>
              <c:otherwise>THẤT BẠI</c:otherwise>
            </c:choose>
          </span>
        </div>

        <!-- Body: thông tin khách -->
        <div class="oc-body">
          <div class="oc-customer"><c:out value="${o.fullName}"/></div>
          <div class="oc-address">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 12-9 12s-9-5-9-12a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
            <span><c:out value="${o.address}"/></span>
          </div>

          <!-- Khối báo giá COD -->
          <div class="oc-cod ${isCod ? 'is-cod' : 'is-paid'}">
            <span class="cod-lbl">${isCod ? 'Thu tiền mặt khi giao' : 'Đã thanh toán online'}</span>
            <span class="cod-amt"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</span>
          </div>

          <c:if test="${tabGroup != 'history'}">
            <!-- Mini map -->
            <div class="oc-map">
              <c:choose>
                <c:when test="${o.latitude != null && o.longitude != null}">
                  <iframe loading="lazy" referrerpolicy="no-referrer-when-downgrade"
                          src="https://maps.google.com/maps?q=${o.latitude},${o.longitude}&z=16&output=embed"></iframe>
                </c:when>
                <c:otherwise>
                  <iframe loading="lazy" referrerpolicy="no-referrer-when-downgrade"
                          src="https://maps.google.com/maps?q=${fn:escapeXml(o.address)}&z=15&output=embed"></iframe>
                </c:otherwise>
              </c:choose>
            </div>

            <!-- Hàng 1: Gọi khách / Chỉ đường -->
            <div class="oc-quick-row">
              <a class="btn-quick" href="tel:${o.phone}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/></svg>
                Gọi khách
              </a>
              <c:choose>
                <c:when test="${o.latitude != null && o.longitude != null}">
                  <a class="btn-quick" target="_blank" rel="noopener"
                     href="https://www.google.com/maps/dir/?api=1&destination=${o.latitude},${o.longitude}&travelmode=driving">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="3 11 22 2 13 21 11 13 3 11"/></svg>
                    Chỉ đường
                  </a>
                </c:when>
                <c:otherwise>
                  <a class="btn-quick" target="_blank" rel="noopener"
                     href="https://www.google.com/maps/dir/?api=1&destination=${fn:escapeXml(o.address)}&travelmode=driving">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="3 11 22 2 13 21 11 13 3 11"/></svg>
                    Chỉ đường
                  </a>
                </c:otherwise>
              </c:choose>
            </div>

            <%-- ===== Hàng 2: STATE MACHINE — nút hành động chính ===== --%>
            <div id="stage${o.orderId}">
              <c:if test="${ds == 'ASSIGNED'}">
                <button type="button" class="btn-primary" onclick="transition(this,${o.orderId},'ASSIGNED','PICKING_UP')">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.3 2.3c-.6.6-.2 1.7.7 1.7H17M9 21a1 1 0 100-2 1 1 0 000 2zM19 21a1 1 0 100-2 1 1 0 000 2z"/></svg>
                  Xác nhận &amp; qua lấy hàng
                </button>
              </c:if>

              <c:if test="${ds == 'PICKING_UP'}">
                <button type="button" class="btn-primary" onclick="transition(this,${o.orderId},'PICKING_UP','DELIVERING')">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="2"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="1.5"/><circle cx="17.5" cy="18.5" r="1.5"/></svg>
                  Đã nhận hàng — Bắt đầu giao
                </button>
                <button type="button" class="fail-link" onclick="markFail(${o.orderId},'PICKING_UP')">✕ Không lấy được hàng</button>
              </c:if>

              <c:if test="${ds == 'DELIVERING'}">
                <div class="proof-row">
                  <button type="button" class="proof-btn" onclick="openCamera(${o.orderId})">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z"/><circle cx="12" cy="13" r="4"/></svg>
                    <span id="camTxt${o.orderId}">${empty o.proofImage ? 'Chụp ảnh xác nhận' : 'Chụp lại ảnh'}</span>
                  </button>
                  <img class="proof-thumb ${empty o.proofImage ? '' : 'show'}" id="thumb${o.orderId}"
                       src="${empty o.proofImage ? '' : ctx.concat(o.proofImage)}" alt="proof">
                  <%-- Fallback nếu trình duyệt không hỗ trợ getUserMedia (mở app camera gốc / thư viện ảnh) --%>
                  <input type="file" id="cam${o.orderId}" accept="image/*" capture="environment"
                         style="display:none" onchange="uploadProof(${o.orderId},this)">
                </div>
                <div class="swipe ${empty o.proofImage ? 'locked' : ''}" id="swipe${o.orderId}" data-order="${o.orderId}">
                  <div class="swipe-fill"></div>
                  <div class="swipe-txt">VUỐT ĐỂ HOÀN THÀNH ĐƠN →</div>
                  <div class="swipe-knob"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"/></svg></div>
                </div>
                <button type="button" class="fail-link" onclick="markFail(${o.orderId},'DELIVERING')">✕ Giao thất bại (khách không nhận)</button>
              </c:if>
            </div>
          </c:if>

          <c:if test="${ds == 'COMPLETED' && not empty o.proofImage}">
            <img class="proof-view" src="${ctx}${o.proofImage}" alt="Bằng chứng giao hàng" loading="lazy">
          </c:if>
        </div>
      </article>
    </c:forEach>
  </div><!-- .order-list -->

  </main><!-- .main-content -->

  <div class="toast" id="toast"></div>

  <button type="button" class="fab" id="chatFab" aria-label="Chat nội bộ">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
  </button>
  <div class="sheet" id="chatSheet">
    <div class="sheet-bg" onclick="closeChat()"></div>
    <div class="sheet-body">
      <div class="sheet-hd">Kênh nội bộ PureNut <button type="button" onclick="closeChat()">✕</button></div>
      <div class="msgs" id="chatMsgs"></div>
      <div class="chat-in">
        <input type="text" id="chatInput" placeholder="Nhắn cho điều phối..." maxlength="500">
        <button type="button" onclick="sendChat()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg></button>
      </div>
    </div>
  </div>

  <!-- Camera sheet — chụp ảnh xác nhận giao hàng bằng getUserMedia (live camera) -->
  <div class="sheet" id="cameraSheet">
    <div class="sheet-bg" onclick="closeCamera()"></div>
    <div class="sheet-body camera-body">
      <div class="sheet-hd">Chụp ảnh xác nhận <button type="button" onclick="closeCamera()">✕</button></div>
      <div class="camera-stage">
        <video id="cameraVideo" autoplay playsinline muted></video>
        <canvas id="cameraCanvas" style="display:none"></canvas>
        <img id="cameraPreview" style="display:none">
        <div class="camera-error" id="cameraError" style="display:none">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="9"/><path d="M12 8v5M12 16h.01"/></svg>
          <p>Không mở được camera. Hãy cấp quyền hoặc chọn ảnh từ thư viện.</p>
        </div>
      </div>
      <div class="camera-actions">
        <button type="button" class="cam-btn cam-btn-outline" id="camPickFile">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
          Thư viện
        </button>
        <button type="button" class="cam-btn cam-shutter" id="camShutter" aria-label="Chụp ảnh">
          <span></span>
        </button>
        <button type="button" class="cam-btn cam-btn-outline" id="camRetake" style="display:none">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15"/></svg>
          Chụp lại
        </button>
        <button type="button" class="cam-btn cam-btn-primary" id="camConfirm" style="display:none">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6L9 17l-5-5"/></svg>
          Dùng ảnh này
        </button>
      </div>
    </div>
  </div>

</div><!-- .app-shell -->

<script>
/* ==========================================================================
   BACKEND WIRING — không đổi so với bản cũ:
   endpoints /shipper/cap-nhat, /shipper/trang-thai, /shipper/proof, /staff/chat
   ========================================================================== */
var CTX='${ctx}',CSRF='${sessionScope._csrf}';
var lastChatId=0,chatTimer=null;

function toast(msg){var t=document.getElementById('toast');t.textContent=msg;t.classList.add('show');setTimeout(function(){t.classList.remove('show')},2600)}
function esc(s){var d=document.createElement('div');d.textContent=s;return d.innerHTML}
function post(url,data,cb){
  var p=new URLSearchParams();p.append('_csrf',CSRF);
  for(var k in data)p.append(k,data[k]);
  fetch(CTX+url,{method:'POST',body:p,headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'}})
    .then(function(r){return r.json()}).then(cb)
    .catch(function(){toast('Mất kết nối — thử lại')});
}
function addRipple(btn,e){
  var r=document.createElement('span');r.className='ripple';
  var rect=btn.getBoundingClientRect(),size=Math.max(rect.width,rect.height);
  var x=(e&&e.clientX?e.clientX-rect.left:rect.width/2)-size/2;
  var y=(e&&e.clientY?e.clientY-rect.top:rect.height/2)-size/2;
  r.style.cssText='width:'+size+'px;height:'+size+'px;left:'+x+'px;top:'+y+'px';
  btn.appendChild(r);setTimeout(function(){r.remove()},600);
}
document.addEventListener('click',function(e){var b=e.target.closest('.btn-primary');if(b)addRipple(b,e)});

/* ===== State machine (giữ nguyên hợp đồng API) ===== */
window.transition=function(btn,orderId,from,to){
  if(btn)btn.disabled=true;
  post('/shipper/cap-nhat',{orderId:orderId,from:from,to:to},function(d){
    if(d.ok){toast('Đã cập nhật ✓');setTimeout(function(){location.reload()},500)}
    else{
      if(btn)btn.disabled=false;
      toast(d.msg||'Không cập nhật được');
      var sw=document.getElementById('swipe'+orderId);
      if(sw){
        sw.classList.remove('done');
        var knob=sw.querySelector('.swipe-knob'),fill=sw.querySelector('.swipe-fill'),txt=sw.querySelector('.swipe-txt');
        if(knob)knob.style.left='4px';
        if(fill)fill.style.width='0';
        if(txt)txt.textContent='VUỐT ĐỂ HOÀN THÀNH ĐƠN →';
      }
    }
  });
};
window.markFail=function(orderId,from){
  if(!confirm('Xác nhận GIAO THẤT BẠI đơn #'+orderId+'?\nĐơn sẽ chuyển về điều phối xử lý.'))return;
  post('/shipper/cap-nhat',{orderId:orderId,from:from,to:'FAILED'},function(d){
    if(d.ok){toast('Đã báo thất bại');setTimeout(function(){location.reload()},500)}
    else toast(d.msg||'Không cập nhật được');
  });
};

/* ===== Proof upload — dùng chung cho cả file input (fallback) và camera live ===== */
function submitProof(orderId,fileOrBlob){
  if(fileOrBlob.size>5*1024*1024){toast('Ảnh quá lớn (tối đa 5MB)');return}
  var camTxt=document.getElementById('camTxt'+orderId);
  if(camTxt)camTxt.textContent='Đang tải ảnh...';
  var fd=new FormData();fd.append('_csrf',CSRF);fd.append('orderId',orderId);fd.append('proofImage',fileOrBlob,'proof.jpg');
  fetch(CTX+'/shipper/proof',{method:'POST',body:fd,headers:{'X-Requested-With':'XMLHttpRequest'}})
    .then(function(r){return r.json()})
    .then(function(d){
      if(d.ok){
        var img=document.getElementById('thumb'+orderId);
        img.src=CTX+d.path;img.classList.add('show');
        if(camTxt)camTxt.textContent='Chụp lại ảnh';
        document.getElementById('swipe'+orderId).classList.remove('locked');
        toast('Đã lưu ảnh ✓ — Vuốt để chốt đơn');
      }else{
        if(camTxt)camTxt.textContent='Chụp ảnh xác nhận';
        toast(d.msg||'Không tải được ảnh');
      }
    }).catch(function(){
      if(camTxt)camTxt.textContent='Chụp ảnh xác nhận';
      toast('Mất kết nối — thử lại');
    });
}
window.uploadProof=function(orderId,input){
  if(!input.files||!input.files[0])return;
  submitProof(orderId,input.files[0]);
  input.value='';
};

/* ===== Camera trực tiếp (getUserMedia) — chụp ảnh xác nhận giao hàng ===== */
(function(){
  var stream=null,curOrderId=null,capturedBlob=null;
  var sheet=document.getElementById('cameraSheet');
  var video=document.getElementById('cameraVideo');
  var canvas=document.getElementById('cameraCanvas');
  var preview=document.getElementById('cameraPreview');
  var errBox=document.getElementById('cameraError');
  var shutter=document.getElementById('camShutter');
  var retakeBtn=document.getElementById('camRetake');
  var confirmBtn=document.getElementById('camConfirm');
  var pickFileBtn=document.getElementById('camPickFile');

  function stopStream(){
    if(stream){stream.getTracks().forEach(function(t){t.stop()});stream=null}
  }

  function showLiveView(){
    capturedBlob=null;
    video.style.display='';preview.style.display='none';
    shutter.style.display='';retakeBtn.style.display='none';confirmBtn.style.display='none';
    pickFileBtn.style.display='';
  }

  window.openCamera=function(orderId){
    curOrderId=orderId;
    errBox.style.display='none';
    showLiveView();
    sheet.classList.add('show');

    if(!navigator.mediaDevices||!navigator.mediaDevices.getUserMedia){
      video.style.display='none';errBox.style.display='flex';
      return;
    }
    navigator.mediaDevices.getUserMedia({video:{facingMode:'environment'},audio:false})
      .then(function(s){
        stream=s;video.srcObject=s;
      })
      .catch(function(){
        video.style.display='none';errBox.style.display='flex';
      });
  };

  window.closeCamera=function(){
    sheet.classList.remove('show');
    stopStream();
    curOrderId=null;
  };

  shutter.addEventListener('click',function(){
    if(!stream)return;
    var w=video.videoWidth,h=video.videoHeight;
    if(!w||!h)return;
    canvas.width=w;canvas.height=h;
    canvas.getContext('2d').drawImage(video,0,0,w,h);
    canvas.toBlob(function(blob){
      if(!blob)return;
      capturedBlob=blob;
      preview.src=URL.createObjectURL(blob);
      video.style.display='none';preview.style.display='';
      shutter.style.display='none';pickFileBtn.style.display='none';
      retakeBtn.style.display='';confirmBtn.style.display='';
    },'image/jpeg',0.9);
  });

  retakeBtn.addEventListener('click',showLiveView);

  confirmBtn.addEventListener('click',function(){
    if(!capturedBlob||!curOrderId)return;
    submitProof(curOrderId,capturedBlob);
    closeCamera();
  });

  // Không mở được camera (quyền bị từ chối / trình duyệt không hỗ trợ) → mở file input làm dự phòng
  pickFileBtn.addEventListener('click',function(){
    if(!curOrderId)return;
    var input=document.getElementById('cam'+curOrderId);
    closeCamera();
    if(input)input.click();
  });
})();

/* ===== Swipe to complete ===== */
document.querySelectorAll('.swipe').forEach(function(sw){
  var knob=sw.querySelector('.swipe-knob'),fill=sw.querySelector('.swipe-fill');
  var dragging=false,startX=0,maxX=0;
  function down(e){
    if(sw.classList.contains('locked')||sw.classList.contains('done'))return;
    dragging=true;startX=(e.touches?e.touches[0].clientX:e.clientX);
    maxX=sw.offsetWidth-knob.offsetWidth-8;knob.style.transition='none';
  }
  function move(e){
    if(!dragging)return;
    var x=(e.touches?e.touches[0].clientX:e.clientX)-startX;
    x=Math.max(0,Math.min(x,maxX));
    knob.style.left=(4+x)+'px';fill.style.width=(x+56)+'px';
    if(e.cancelable)e.preventDefault();
  }
  function up(e){
    if(!dragging)return;dragging=false;knob.style.transition='left .25s cubic-bezier(.2,.8,.3,1)';
    var x=parseFloat(knob.style.left||4)-4;
    if(x>=maxX*0.88){
      sw.classList.add('done');knob.style.left=(4+maxX)+'px';
      sw.querySelector('.swipe-txt').textContent='ĐANG CHỐT ĐƠN...';
      transition(null,parseInt(sw.dataset.order),'DELIVERING','COMPLETED');
    }else{knob.style.left='4px';fill.style.width='0'}
  }
  sw.addEventListener('touchstart',down,{passive:true});
  sw.addEventListener('touchmove',move,{passive:false});
  sw.addEventListener('touchend',up);
  sw.addEventListener('mousedown',down);
  document.addEventListener('mousemove',move);
  document.addEventListener('mouseup',up);
});

/* ===== Toggle Trực tuyến / Nghỉ ngơi ===== */
document.getElementById('statusToggle').addEventListener('change',function(){
  var input=this,cur=input.dataset.status,next=cur==='ACTIVE'?'OFFLINE':'ACTIVE';
  var label=document.getElementById('toggleLabel');
  post('/shipper/trang-thai',{status:next},function(d){
    if(d.ok){
      input.dataset.status=next;
      label.textContent=next==='ACTIVE'?'Trực tuyến':'Nghỉ ngơi';
      label.className='toggle-label'+(next==='ACTIVE'?' on':'');
      toast(next==='ACTIVE'?'Bật nhận đơn ✓':'Đã tạm nghỉ');
    }else{
      input.checked=(cur==='ACTIVE'); // rollback UI nếu server từ chối
      toast(d.msg||'Lỗi');
    }
  });
});

/* ===== Chat nội bộ ===== */
function renderChat(list,append){
  var box=document.getElementById('chatMsgs');
  if(!append)box.innerHTML='';
  list.forEach(function(m){
    if(m.id>lastChatId)lastChatId=m.id;
    var d=document.createElement('div');
    d.className='m '+(m.mine?'mine':'them');
    d.innerHTML=(m.mine?'':'<div class="who">'+esc(m.name)+'</div>')+esc(m.msg)+'<small>'+esc(m.time)+'</small>';
    box.appendChild(d);
  });
  if(list.length)box.scrollTop=box.scrollHeight;
}
function pollChat(){
  fetch(CTX+'/staff/chat?after='+lastChatId,{headers:{'X-Requested-With':'XMLHttpRequest'}})
    .then(function(r){return r.json()})
    .then(function(d){if(d.ok)renderChat(d.items,lastChatId>0)})
    .catch(function(){});
}
document.getElementById('chatFab').addEventListener('click',function(){
  document.getElementById('chatSheet').classList.add('show');
  lastChatId=0;pollChat();
  chatTimer=setInterval(pollChat,5000);
});
window.closeChat=function(){
  document.getElementById('chatSheet').classList.remove('show');
  if(chatTimer)clearInterval(chatTimer);
};
window.sendChat=function(){
  var i=document.getElementById('chatInput'),v=i.value.trim();
  if(!v)return;i.value='';
  post('/staff/chat',{message:v},function(d){if(d.ok)pollChat();else toast(d.msg||'Không gửi được')});
};
document.getElementById('chatInput').addEventListener('keydown',function(e){if(e.key==='Enter')sendChat()});

/* ==========================================================================
   TABS — ẩn/hiện Order Card theo nhóm trạng thái (waiting / delivering / history)
   ========================================================================== */
(function(){
  var currentTab='waiting';
  var navBtns=document.querySelectorAll('.nav-item');
  var cards=document.querySelectorAll('.order-card');
  var emptyState=document.getElementById('emptyState');
  var noOrders=document.getElementById('noOrdersAtAll');

  function filterOrders(){
    var visible=0;
    cards.forEach(function(card){
      var show=card.getAttribute('data-tab-group')===currentTab;
      card.style.display=show?'':'none';
      if(show)visible++;
    });
    if(noOrders){
      noOrders.style.display=(cards.length===0)?'':'none';
      emptyState.style.display=(cards.length>0 && visible===0)?'':'none';
    }else{
      emptyState.style.display=(visible===0)?'':'none';
    }
  }

  function switchTab(tabId){
    currentTab=tabId;
    navBtns.forEach(function(b){b.classList.toggle('active',b.getAttribute('data-tab')===tabId)});
    filterOrders();
  }

  navBtns.forEach(function(btn){
    btn.addEventListener('click',function(){switchTab(btn.getAttribute('data-tab'))});
  });

  filterOrders();
})();
</script>
</body>
</html>
