<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  navbar.jsp — Thanh điều hướng dùng chung cho TẤT CẢ trang.
  CSS cho navbar được đặt ở đây (không còn trong style.css nữa),
  nhờ vậy mọi trang include file này đều có giao diện đồng nhất.
--%>

<style>
/* ═══════════════════════════════════════
   SHARED NAVBAR — áp dụng cho mọi trang
   ═══════════════════════════════════════ */
:root{
  --navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;
  --red:#CE2E2E;--green:#2BAC62;
  --cream:#FBF6EC;--paper:#FFFDF8;--sand:#E9DCBE;
  --ink:#241F18;--ink-soft:#6B6357;
  --line:rgba(36,31,24,.10);
  --fd:'Fraunces',serif;--fb:'Inter',sans-serif;
  --container:1180px;
  --shadow:0 18px 40px -18px rgba(20,30,20,.22);
  --shadow-sm:0 10px 28px -14px rgba(20,30,20,.18);
  --r:16px;--r-lg:26px;
}
/* Reset & base */
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased}
img{max-width:100%;display:block}a{text-decoration:none;color:inherit}
ul{list-style:none}button{font:inherit;cursor:pointer;border:none;background:none}
input,select{font:inherit}
h1,h2,h3{font-family:var(--fd);font-weight:600;letter-spacing:-.01em;line-height:1.12}
.container{max-width:var(--container);margin:0 auto;padding:0 28px}

/* Buttons */
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:13px 26px;border-radius:99px;font-weight:700;font-size:14.5px;transition:transform .2s,box-shadow .2s,background .2s}
.btn-primary{background:var(--navy);color:#fff;box-shadow:0 8px 20px rgba(27,79,158,.22)}.btn-primary:hover{transform:translateY(-2px);box-shadow:0 12px 26px rgba(27,79,158,.30)}
.btn-red{background:var(--red);color:#fff;box-shadow:0 8px 20px rgba(206,46,46,.22)}.btn-red:hover{transform:translateY(-2px);box-shadow:0 12px 26px rgba(206,46,46,.30)}
.btn-ghost{background:transparent;color:var(--ink);border:1.5px solid var(--line)}.btn-ghost:hover{background:var(--ink);color:#fff;transform:translateY(-2px)}
.btn-sm{padding:8px 22px;font-size:13.5px}

/* ── Navbar ── */
.site-navbar{
  position:sticky;top:0;z-index:200;
  background:rgba(251,246,236,.92);
  backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);
  border-bottom:1px solid var(--line);
}
.site-nav-inner{
  max-width:var(--container);margin:0 auto;padding:0 28px;
  height:64px;display:flex;align-items:center;justify-content:space-between;gap:24px;
}

/* Logo — CHUẨN DUY NHẤT */
.site-logo{
  display:flex;align-items:center;gap:10px;flex-shrink:0;
  font-family:var(--fd);font-weight:700;font-size:22px;color:var(--navy);
  text-decoration:none;
}
.site-logo-dot{
  width:36px;height:36px;border-radius:50%;background:var(--red);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
  box-shadow:0 4px 12px rgba(206,46,46,.28);
  transition:transform .2s,box-shadow .2s;
}
.site-logo:hover .site-logo-dot{transform:scale(1.08);box-shadow:0 6px 16px rgba(206,46,46,.38)}
.site-logo b{color:var(--red)}

/* Nav links */
.site-nav-links{display:flex;align-items:center;gap:6px}
.site-nav-links a{
  font-size:14.5px;font-weight:600;color:var(--ink);padding:6px 14px;border-radius:99px;
  position:relative;transition:color .2s,background .2s,transform .2s,box-shadow .2s;
}
.site-nav-links a:hover{color:var(--navy);background:rgba(27,79,158,.07)}
.site-nav-links a.active{
  color:#fff;
  background:linear-gradient(135deg, var(--navy) 0%, var(--navy-dark) 100%);
  box-shadow:0 4px 16px rgba(27,79,158,.32), 0 1px 3px rgba(27,79,158,.18);
  transform:translateY(-1px);
}
.site-nav-links a.active:hover{
  background:linear-gradient(135deg, var(--navy) 0%, var(--navy-darker) 100%);
  box-shadow:0 6px 22px rgba(27,79,158,.40), 0 2px 5px rgba(27,79,158,.22);
  transform:translateY(-2px);
  color:#fff;
}

/* Nav actions */
.site-nav-actions{display:flex;align-items:center;gap:6px}
.site-nav-icon{
  width:40px;height:40px;border-radius:50%;display:flex;align-items:center;justify-content:center;
  color:var(--ink);transition:background .2s,color .2s;position:relative;
}
.site-nav-icon:hover{background:rgba(27,79,158,.08);color:var(--navy)}
.site-nav-icon svg{width:22px;height:22px;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.site-cart-badge{
  position:absolute;top:4px;right:4px;min-width:16px;height:16px;padding:0 4px;
  border-radius:99px;background:var(--red);color:#fff;font-size:10px;font-weight:700;
  display:flex;align-items:center;justify-content:center;line-height:1;
}
.site-cart-badge:empty{display:none}
.site-nav-btn{padding:8px 22px;font-size:14px;flex-shrink:0}

/* ── User dropdown ── */
.site-user-wrap{position:relative}
.site-user-dropdown{
  display:none;position:absolute;top:100%;right:0;margin-top:8px;
  min-width:200px;background:#fff;border-radius:14px;
  box-shadow:0 12px 36px -8px rgba(0,0,0,.15),0 0 0 1px rgba(0,0,0,.04);
  padding:6px;z-index:300;
  animation:sudFade .18s ease;
}
@keyframes sudFade{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:translateY(0)}}
.site-user-wrap:hover .site-user-dropdown{display:block}
.site-user-dropdown::before{content:'';position:absolute;top:-10px;left:0;right:0;height:10px}
.sud-item{
  display:flex;align-items:center;gap:10px;padding:10px 14px;
  border-radius:10px;font-size:14px;font-weight:600;color:var(--ink);
  transition:all .15s;
}
.sud-item:hover{background:rgba(27,79,158,.06);color:var(--navy)}
.sud-item svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0;opacity:.55}
.sud-item:hover svg{opacity:1}
.sud-divider{height:1px;background:var(--line);margin:4px 10px}
.sud-logout{color:var(--ink-soft)}
.sud-logout:hover{background:rgba(206,46,46,.06);color:var(--red)}
.sud-logout:hover svg{stroke:var(--red)}

/* Hamburger */
.site-nav-toggle{
  display:none;flex-direction:column;gap:5px;width:36px;height:36px;
  border-radius:50%;align-items:center;justify-content:center;padding:0;
  transition:background .2s;
}
.site-nav-toggle:hover{background:var(--line)}
.site-nav-toggle span{width:18px;height:2px;background:var(--ink);border-radius:2px;display:block;transition:transform .25s,opacity .25s}

/* Mobile nav drawer */
.site-nav-drawer{
  display:none;
  position:fixed;top:64px;left:0;right:0;z-index:199;
  background:rgba(251,246,236,.98);backdrop-filter:blur(14px);
  border-bottom:1px solid var(--line);
  flex-direction:column;padding:16px 28px 24px;gap:4px;
  box-shadow:0 16px 32px -16px rgba(0,0,0,.15);
}
.site-nav-drawer.open{display:flex}
.site-nav-drawer a{font-size:15px;font-weight:600;color:var(--ink);padding:12px 0;border-bottom:1px solid var(--line);display:block}
.site-nav-drawer a:last-child{border-bottom:none}
.site-nav-drawer a:hover{color:var(--navy)}
.site-nav-drawer a.active{
  color:var(--navy);font-weight:700;
  background:rgba(27,79,158,.06);
  padding-left:14px;
  border-left:3px solid var(--navy);
  border-radius:0 8px 8px 0;
}

/* Search modal */
.site-search-overlay{
  display:none;position:fixed;inset:0;background:rgba(251,246,236,.97);
  z-index:9000;align-items:center;justify-content:center;flex-direction:column;
  backdrop-filter:blur(4px);
}
.site-search-overlay.open{display:flex}
.site-search-close{
  position:absolute;top:32px;right:32px;width:44px;height:44px;
  border-radius:50%;background:var(--line);display:flex;align-items:center;justify-content:center;
  color:var(--ink);font-size:22px;transition:background .2s;
}
.site-search-close:hover{background:var(--sand)}
.site-search-form{width:100%;max-width:580px;position:relative}
.site-search-form input{
  width:100%;padding:18px 56px 18px 0;border:none;border-bottom:2.5px solid var(--navy);
  background:transparent;font-size:24px;color:var(--navy);outline:none;
  font-family:var(--fd);font-weight:600;
}
.site-search-form input::placeholder{color:rgba(27,79,158,.4)}
.site-search-form button{
  position:absolute;right:0;top:50%;transform:translateY(-50%);
  color:var(--navy);padding:8px;
}
.site-search-form button svg{width:28px;height:28px;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round}

/* Mobile/Desktop visibility */
.show-on-mobile{display:none !important}

/* Responsive */
@media(max-width:720px){
  .site-nav-links{display:none}
  .site-nav-toggle{display:flex}
  .site-nav-icon.hide-mobile{display:none}
  .hide-on-mobile{display:none !important}
  .show-on-mobile{display:flex !important}
}
@media(max-width:480px){
  .site-nav-inner{padding:0 14px;height:56px}
  .site-logo{font-size:19px;gap:8px}
  .site-logo-dot{width:30px;height:30px}
  .site-logo-dot svg{width:16px;height:16px}
  .site-nav-btn{padding:6px 14px;font-size:12.5px}
  .site-nav-drawer{padding:12px 16px 20px;top:56px}
  .site-search-form input{font-size:18px}
  .site-search-close{top:16px;right:16px;width:38px;height:38px}
  .container{padding:0 16px}
}

/* ═══════════════════════════════════════
   PAGE LOADER — Banter Loader (PureNut)
   ═══════════════════════════════════════ */
.page-loader{
  position:fixed;inset:0;z-index:99999;
  background:var(--cream,#FBF6EC);
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  transition:opacity .5s ease, visibility .5s ease;
}
.page-loader.loaded{
  opacity:0;visibility:hidden;pointer-events:none;
}
.page-loader__brand{
  margin-bottom:40px;text-align:center;
  font-family:var(--fd,'Fraunces',serif);font-weight:700;font-size:28px;
  color:var(--navy,#1B4F9E);letter-spacing:-.01em;
  display:flex;align-items:center;gap:12px;
  animation:loaderPulse 2s ease-in-out infinite;
}
.page-loader__brand-dot{
  width:40px;height:40px;border-radius:50%;background:var(--red,#CE2E2E);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
  box-shadow:0 4px 16px rgba(206,46,46,.30);
}
.page-loader__brand b{color:var(--red,#CE2E2E)}
@keyframes loaderPulse{
  0%,100%{opacity:1;transform:scale(1)}
  50%{opacity:.7;transform:scale(.97)}
}

.banter-loader{
  position:relative;
  width:72px;height:72px;
}
.banter-loader__box{
  float:left;position:relative;
  width:20px;height:20px;margin-right:6px;
}
.banter-loader__box:before{
  content:"";position:absolute;left:0;top:0;
  width:100%;height:100%;
  background:var(--navy,#1B4F9E);
  border-radius:3px;
}
.banter-loader__box:nth-child(3n){margin-right:0;margin-bottom:6px}
.banter-loader__box:nth-child(1):before,.banter-loader__box:nth-child(4):before{margin-left:26px}
.banter-loader__box:nth-child(3):before{margin-top:52px}
.banter-loader__box:last-child{margin-bottom:0}

/* ── Banter keyframes ── */
@keyframes moveBox-1{9.09%{transform:translate(-26px,0)}18.18%{transform:translate(0,0)}27.27%{transform:translate(0,0)}36.36%{transform:translate(26px,0)}45.45%{transform:translate(26px,26px)}54.55%{transform:translate(26px,26px)}63.64%{transform:translate(26px,26px)}72.73%{transform:translate(26px,0)}81.82%{transform:translate(0,0)}90.91%{transform:translate(-26px,0)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(1){animation:moveBox-1 4s infinite}

@keyframes moveBox-2{9.09%{transform:translate(0,0)}18.18%{transform:translate(26px,0)}27.27%{transform:translate(0,0)}36.36%{transform:translate(26px,0)}45.45%{transform:translate(26px,26px)}54.55%{transform:translate(26px,26px)}63.64%{transform:translate(26px,26px)}72.73%{transform:translate(26px,26px)}81.82%{transform:translate(0,26px)}90.91%{transform:translate(0,26px)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(2){animation:moveBox-2 4s infinite}

@keyframes moveBox-3{9.09%{transform:translate(-26px,0)}18.18%{transform:translate(-26px,0)}27.27%{transform:translate(0,0)}36.36%{transform:translate(-26px,0)}45.45%{transform:translate(-26px,0)}54.55%{transform:translate(-26px,0)}63.64%{transform:translate(-26px,0)}72.73%{transform:translate(-26px,0)}81.82%{transform:translate(-26px,-26px)}90.91%{transform:translate(0,-26px)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(3){animation:moveBox-3 4s infinite}

@keyframes moveBox-4{9.09%{transform:translate(-26px,0)}18.18%{transform:translate(-26px,0)}27.27%{transform:translate(-26px,-26px)}36.36%{transform:translate(0,-26px)}45.45%{transform:translate(0,0)}54.55%{transform:translate(0,-26px)}63.64%{transform:translate(0,-26px)}72.73%{transform:translate(0,-26px)}81.82%{transform:translate(-26px,-26px)}90.91%{transform:translate(-26px,0)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(4){animation:moveBox-4 4s infinite}

@keyframes moveBox-5{9.09%{transform:translate(0,0)}18.18%{transform:translate(0,0)}27.27%{transform:translate(0,0)}36.36%{transform:translate(26px,0)}45.45%{transform:translate(26px,0)}54.55%{transform:translate(26px,0)}63.64%{transform:translate(26px,0)}72.73%{transform:translate(26px,0)}81.82%{transform:translate(26px,-26px)}90.91%{transform:translate(0,-26px)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(5){animation:moveBox-5 4s infinite}

@keyframes moveBox-6{9.09%{transform:translate(0,0)}18.18%{transform:translate(-26px,0)}27.27%{transform:translate(-26px,0)}36.36%{transform:translate(0,0)}45.45%{transform:translate(0,0)}54.55%{transform:translate(0,0)}63.64%{transform:translate(0,0)}72.73%{transform:translate(0,26px)}81.82%{transform:translate(-26px,26px)}90.91%{transform:translate(-26px,0)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(6){animation:moveBox-6 4s infinite}

@keyframes moveBox-7{9.09%{transform:translate(26px,0)}18.18%{transform:translate(26px,0)}27.27%{transform:translate(26px,0)}36.36%{transform:translate(0,0)}45.45%{transform:translate(0,-26px)}54.55%{transform:translate(26px,-26px)}63.64%{transform:translate(0,-26px)}72.73%{transform:translate(0,-26px)}81.82%{transform:translate(0,0)}90.91%{transform:translate(26px,0)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(7){animation:moveBox-7 4s infinite}

@keyframes moveBox-8{9.09%{transform:translate(0,0)}18.18%{transform:translate(-26px,0)}27.27%{transform:translate(-26px,-26px)}36.36%{transform:translate(0,-26px)}45.45%{transform:translate(0,-26px)}54.55%{transform:translate(0,-26px)}63.64%{transform:translate(0,-26px)}72.73%{transform:translate(0,-26px)}81.82%{transform:translate(26px,-26px)}90.91%{transform:translate(26px,0)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(8){animation:moveBox-8 4s infinite}

@keyframes moveBox-9{9.09%{transform:translate(-26px,0)}18.18%{transform:translate(-26px,0)}27.27%{transform:translate(0,0)}36.36%{transform:translate(-26px,0)}45.45%{transform:translate(0,0)}54.55%{transform:translate(0,0)}63.64%{transform:translate(-26px,0)}72.73%{transform:translate(-26px,0)}81.82%{transform:translate(-52px,0)}90.91%{transform:translate(-26px,0)}100%{transform:translate(0,0)}}
.banter-loader__box:nth-child(9){animation:moveBox-9 4s infinite}

.page-loader__text{
  margin-top:32px;
  font-family:var(--fb,'Inter',sans-serif);font-size:13px;font-weight:500;
  color:var(--ink-soft,#6B6357);letter-spacing:.06em;text-transform:uppercase;
  animation:loaderPulse 2s ease-in-out infinite;
}
</style>

<!-- ══ Page Loader Overlay ══ -->
<div class="page-loader" id="pageLoader">
  <div class="page-loader__brand">
    <span class="page-loader__brand-dot">
      <svg width="20" height="20" viewBox="0 0 34 34" fill="none" aria-hidden="true">
        <path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" stroke="#fff" stroke-width="1.8"/>
        <path d="M11 14.5c1.5-1.8 3.6-2.8 6-2.8" stroke="#fff" stroke-width="1.8" stroke-linecap="round"/>
      </svg>
    </span>
    Pure<b>Nut</b>
  </div>
  <div class="banter-loader">
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
    <div class="banter-loader__box"></div>
  </div>
  <p class="page-loader__text">Đang tải...</p>
</div>

<header class="site-navbar" id="siteNavbar">
  <div class="site-nav-inner">

    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/" class="site-logo">
      <span class="site-logo-dot">
        <svg width="20" height="20" viewBox="0 0 34 34" fill="none" aria-hidden="true">
          <path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" stroke="#fff" stroke-width="1.8"/>
          <path d="M11 14.5c1.5-1.8 3.6-2.8 6-2.8" stroke="#fff" stroke-width="1.8" stroke-linecap="round"/>
        </svg>
      </span>
      Pure<b>Nut</b>
    </a>

    <!-- Desktop nav -->
    <nav class="site-nav-links" aria-label="Menu chính">
      <a href="${pageContext.request.contextPath}/">Trang chủ</a>
      <a href="${pageContext.request.contextPath}/about">Giới thiệu</a>
      <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
    </nav>

    <!-- Actions -->
    <div class="site-nav-actions">
      <!-- Search -->
      <button class="site-nav-icon hide-mobile" id="searchBtn" aria-label="Tìm kiếm" onclick="document.getElementById('siteSearchOverlay').classList.add('open')">
        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      </button>

      <!-- Cart (chỉ hiện khi đã đăng nhập) -->
      <c:if test="${not empty sessionScope.user}">
      <a href="${pageContext.request.contextPath}/cart" class="site-nav-icon" aria-label="Giỏ hàng">
        <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
        <span id="siteCartBadge" class="site-cart-badge"><c:if test="${sessionScope.cartCount gt 0}">${sessionScope.cartCount}</c:if></span>
      </a>
      </c:if>

      <!-- User (Desktop: button + hover dropdown | Mobile: icon link) -->
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <!-- Desktop: hover dropdown -->
          <div class="site-user-wrap hide-on-mobile">
            <a href="${pageContext.request.contextPath}/account" class="btn btn-sm btn-primary site-nav-btn">Tài khoản</a>
            <div class="site-user-dropdown">
              <a href="${pageContext.request.contextPath}/account" class="sud-item">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                Tài khoản của tôi
              </a>
              <a href="${pageContext.request.contextPath}/account#orders" class="sud-item" data-tab="orders">
                <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                Đơn mua
              </a>
              <div class="sud-divider"></div>
              <a href="${pageContext.request.contextPath}/logout" class="sud-item sud-logout">
                <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                Đăng xuất
              </a>
            </div>
          </div>
          <!-- Mobile: avatar icon -->
          <a href="${pageContext.request.contextPath}/account" class="site-nav-icon show-on-mobile" aria-label="Tài khoản">
            <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          </a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary site-nav-btn hide-on-mobile">Đăng nhập</a>
          <a href="${pageContext.request.contextPath}/login" class="site-nav-icon show-on-mobile" aria-label="Đăng nhập">
            <svg viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
          </a>
        </c:otherwise>
      </c:choose>

      <!-- Hamburger -->
      <button class="site-nav-toggle" id="siteNavToggle" aria-label="Mở menu" aria-expanded="false">
        <span></span><span></span><span></span>
      </button>
    </div>

  </div>
</header>

<!-- Mobile drawer -->
<nav class="site-nav-drawer" id="siteNavDrawer" aria-label="Menu mobile">
  <a href="${pageContext.request.contextPath}/">Trang chủ</a>
  <a href="${pageContext.request.contextPath}/about">Giới thiệu</a>
  <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
  <c:choose>
    <c:when test="${not empty sessionScope.user}">
      <a href="${pageContext.request.contextPath}/account">Tài khoản của tôi</a>
      <a href="${pageContext.request.contextPath}/account#orders">Đơn hàng</a>
      <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
      <a href="${pageContext.request.contextPath}/logout" style="color:var(--red)">Đăng xuất</a>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
      <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
    </c:otherwise>
  </c:choose>
</nav>

<!-- Search overlay -->
<div class="site-search-overlay" id="siteSearchOverlay" role="dialog" aria-label="Tìm kiếm">
  <button class="site-search-close" onclick="document.getElementById('siteSearchOverlay').classList.remove('open')" aria-label="Đóng">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
  </button>
  <form class="site-search-form" action="${pageContext.request.contextPath}/search" method="GET">
    <input type="text" name="q" placeholder="Tìm sản phẩm..." autofocus>
    <button type="submit" aria-label="Tìm">
      <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
    </button>
  </form>
</div>

<script>
(function(){
  // Toggle hamburger
  var toggle = document.getElementById('siteNavToggle');
  var drawer = document.getElementById('siteNavDrawer');
  if(toggle && drawer){
    toggle.addEventListener('click', function(){
      var open = drawer.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open);
      var spans = toggle.querySelectorAll('span');
      if(open){
        spans[0].style.transform='rotate(45deg) translate(5px,5px)';
        spans[1].style.opacity='0';
        spans[2].style.transform='rotate(-45deg) translate(5px,-5px)';
      } else {
        spans[0].style.transform='';spans[1].style.opacity='';spans[2].style.transform='';
      }
    });
  }
  // ESC để đóng search
  document.addEventListener('keydown',function(e){
    if(e.key==='Escape'){
      document.getElementById('siteSearchOverlay').classList.remove('open');
      if(drawer) drawer.classList.remove('open');
    }
  });
  // Active link — normalise paths rồi so sánh chính xác
  (function highlightActiveNav(){
    // Lấy context path từ JSP (vd: /Sua_Hat)
    var ctx = '${pageContext.request.contextPath}' || '';
    // Chuẩn hoá: bỏ trailing slash, lowercase
    function norm(p){ return (p||'').replace(/\/+$/,'').toLowerCase(); }
    var fullPath = norm(window.location.pathname);          // vd: /sua_hat/products
    var ctxNorm  = norm(ctx);                               // vd: /sua_hat
    // Phần path sau context (vd: "" cho home, "/about", "/products", "/products/123")
    var rel = fullPath.indexOf(ctxNorm) === 0
            ? fullPath.substring(ctxNorm.length)
            : fullPath;
    if(rel === '') rel = '/';  // home

    document.querySelectorAll('.site-nav-links a, .site-nav-drawer a').forEach(function(a){
      var href = norm(a.getAttribute('href'));
      var hrefRel = href.indexOf(ctxNorm) === 0
                  ? href.substring(ctxNorm.length)
                  : href;
      if(hrefRel === '') hrefRel = '/';

      var isActive = false;
      if(hrefRel === '/'){
        // Home chỉ active khi đúng trang chủ
        isActive = (rel === '/');
      } else {
        // Các trang khác: exact match HOẶC sub-path (vd: /products/123 → highlight "Sản phẩm")
        isActive = (rel === hrefRel || rel.indexOf(hrefRel + '/') === 0);
      }
      if(isActive) a.classList.add('active');
    });
  })();
  // Cart badge
  var badge = document.getElementById('siteCartBadge');
  if(badge && window.CTX){
    fetch(window.CTX+'/cart/count').then(function(r){return r.json();}).then(function(d){
      if(d && d.count > 0) badge.textContent = d.count;
    }).catch(function(){});
  }
  
  // Update cart badge khi thêm/xóa item (sử dụng custom event)
  document.addEventListener('cartUpdated', function(e){
    if(badge && e.detail && e.detail.count >= 0){
      badge.textContent = e.detail.count > 0 ? e.detail.count : '';
    }
  });
})();

// ── Page Loader: ẩn sau khi trang tải xong ──
(function(){
  var loader = document.getElementById('pageLoader');
  if(!loader) return;
  function hideLoader(){
    // Đợi tối thiểu 600ms để user thấy animation
    var minTime = 600;
    var elapsed = performance.now();
    var remaining = Math.max(0, minTime - elapsed);
    setTimeout(function(){
      loader.classList.add('loaded');
      // Xóa khỏi DOM sau khi fade xong
      setTimeout(function(){ loader.remove(); }, 550);
    }, remaining);
  }
  if(document.readyState === 'complete'){
    hideLoader();
  } else {
    window.addEventListener('load', hideLoader);
  }
})();
</script>
