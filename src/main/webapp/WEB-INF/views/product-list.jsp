<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cửa hàng — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700;1,9..144,500&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--sand:#E9DCBE;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif;--container:1200px;--shadow:0 22px 46px -20px rgba(20,30,20,.26);--shadow-sm:0 10px 28px -14px rgba(20,30,20,.18)}
*{margin:0;padding:0;box-sizing:border-box}html{scroll-behavior:smooth}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased}
img{max-width:100%;display:block}a{text-decoration:none;color:inherit}ul{list-style:none}button{font:inherit;cursor:pointer;border:none;background:none}
h1,h2,h3{font-family:var(--fd);font-weight:600;letter-spacing:-.01em;line-height:1.1}
.container{max-width:var(--container);margin:0 auto;padding:0 26px}
.eyebrow{display:inline-block;font-weight:700;letter-spacing:.1em;text-transform:uppercase;font-size:12.5px;margin-bottom:10px}
.btn{display:inline-flex;align-items:center;gap:8px;padding:13px 26px;border-radius:99px;font-weight:600;font-size:15px;transition:transform .2s,background .2s}
.btn-primary{background:var(--navy);color:#fff}.btn-primary:hover{transform:translateY(-2px)}
.reveal{opacity:0;transform:translateY(30px);transition:opacity .8s cubic-bezier(.2,.7,.2,1),transform .8s cubic-bezier(.2,.7,.2,1)}
.reveal.in{opacity:1;transform:none}
/* nav — dùng navbar.jsp chung */
/* grain + họa tiết chìm nền */
body::after{content:"";position:fixed;inset:0;z-index:1;pointer-events:none;opacity:.045;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='180'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
.deco{position:fixed;z-index:0;pointer-events:none;opacity:.045;color:var(--ink)}
.deco.tl{top:120px;left:-30px;width:280px;transform:rotate(-8deg)}
.deco.br{bottom:80px;right:-40px;width:320px;transform:rotate(6deg)}
/* page head */
.head{position:relative;text-align:center;padding:52px 0 60px}
.head-script{position:absolute;top:40%;left:50%;transform:translate(-50%,-50%) rotate(-6deg);font-family:var(--fd);font-style:italic;font-weight:500;font-size:clamp(120px,20vw,240px);color:var(--ink);opacity:.045;white-space:nowrap;pointer-events:none;z-index:0;letter-spacing:-.02em}
.head>.container{position:relative;z-index:2}
.head h1{font-size:clamp(32px,5vw,52px)}.head p{color:var(--ink-soft);margin-top:10px;font-size:17px}
/* hộp lọc "chốt" đè lên ranh giới kem–nâu (50/50) */
.qnav{display:inline-flex;gap:6px;flex-wrap:wrap;justify-content:center;margin-top:26px;position:relative;z-index:5;background:#FFFDF8;border:1px solid var(--line);border-radius:99px;padding:7px;box-shadow:0 20px 40px -18px rgba(20,30,20,.4),0 5px 14px -8px rgba(20,30,20,.22)}
.qnav a{padding:10px 22px;border-radius:99px;font-weight:600;font-size:13.5px;color:var(--ink-soft);transition:all .2s}
.qnav a:hover,.qnav a.on{background:var(--navy);color:#fff}

/* ============ ZONE HERO (banner lớn cho mỗi khu) ============ */
.zone{position:relative}
.zhero{position:relative;overflow:hidden;padding:78px 0 92px;background:linear-gradient(180deg,var(--a) 0%,var(--a2) 100%)}
.ztop{position:absolute;top:-1px;left:0;width:100%;height:56px;z-index:2;display:block}
.zhero .ghost{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-family:var(--fd);font-weight:700;font-size:clamp(88px,19vw,250px);line-height:.8;letter-spacing:.02em;color:rgba(255,255,255,.06);white-space:nowrap;text-transform:uppercase;pointer-events:none;user-select:none}
.zhero-inner{position:relative;z-index:2;display:grid;grid-template-columns:1.15fr .85fr;gap:34px;align-items:center;color:#fff;perspective:1000px}
.zh-art{transition:transform .25s ease-out;transform-style:preserve-3d;will-change:transform}
.zf{position:absolute;border-radius:50%;background:rgba(255,255,255,.1);pointer-events:none;z-index:1}
.zf1{width:74px;height:74px;top:15%;left:6%;animation:drift 12s ease-in-out infinite}
.zf2{width:40px;height:40px;bottom:18%;left:20%;animation:drift 9s ease-in-out infinite reverse}
.zf3{width:26px;height:26px;top:26%;right:9%;animation:drift 14s ease-in-out infinite}
@keyframes drift{0%,100%{transform:translate(0,0)}50%{transform:translate(16px,-24px)}}
.zh-num{display:inline-flex;align-items:center;gap:12px;font-family:var(--fd);font-weight:700;font-size:14px;letter-spacing:.22em;color:#fff;text-shadow:0 1px 6px rgba(0,0,0,.25)}
.zh-num::before{content:'';width:40px;height:2px;background:rgba(255,255,255,.7)}
.zhero h2{font-size:clamp(34px,5.4vw,60px);margin:16px 0 14px;color:#fff;line-height:1.02;text-shadow:0 2px 14px rgba(0,0,0,.28)}
.zhero p{color:#fff;font-weight:500;max-width:460px;margin-bottom:22px;font-size:16.5px;text-shadow:0 1px 8px rgba(0,0,0,.3)}
.zh-badges{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:26px}
.zh-badges span{background:rgba(255,255,255,.2);border:1px solid rgba(255,255,255,.34);backdrop-filter:blur(4px);padding:8px 15px;border-radius:99px;font-size:12.5px;font-weight:700;cursor:default;transition:background .25s,color .25s,border-color .25s,transform .25s,box-shadow .25s}
.zh-badges span:hover{transform:translateY(-3px) scale(1.06);color:#fff;box-shadow:0 10px 20px -8px rgba(0,0,0,.4)}
.zh-badges span:nth-child(1):hover{background:#2BAC62;border-color:#2BAC62}
.zh-badges span:nth-child(2):hover{background:#F2B705;border-color:#F2B705;color:#3a2b00}
.zh-badges span:nth-child(3):hover{background:#CE2E2E;border-color:#CE2E2E}
/* mưa hạt / dòng sữa nền */
.zrain{position:absolute;inset:0;overflow:hidden;pointer-events:none;z-index:1}
.rain-p{position:absolute;top:-40px;will-change:transform,opacity;opacity:0;filter:drop-shadow(0 4px 6px rgba(0,0,0,.15))}
@keyframes fall{0%{transform:translateY(-40px) rotate(0);opacity:0}12%{opacity:.95}80%{opacity:.7}100%{transform:translateY(var(--fh)) rotate(var(--fr));opacity:0}}
.rain-s{position:absolute;top:-60px;width:6px;border-radius:6px;background:linear-gradient(180deg,rgba(255,255,255,.95),rgba(255,255,255,0));will-change:transform,opacity;opacity:0}
@keyframes stream{0%{transform:translateY(-60px) scaleY(.6);opacity:0}18%{opacity:.85}100%{transform:translateY(var(--fh)) scaleY(1.25);opacity:0}}
.zh-cta{display:inline-flex;align-items:center;gap:9px;background:#fff;color:var(--a2);padding:13px 28px;border-radius:99px;font-weight:700;font-size:15px;box-shadow:0 14px 30px -12px rgba(0,0,0,.4);transition:transform .2s}
.zh-cta:hover{transform:translateY(-3px)}
.zh-art{display:flex;align-items:center;justify-content:center;position:relative;min-height:230px}
.zh-bubble{width:250px;height:250px;border-radius:50%;background:rgba(255,255,255,.18);border:2px dashed rgba(255,255,255,.55);display:flex;align-items:center;justify-content:center;font-size:120px;animation:bob 5.5s ease-in-out infinite;box-shadow:inset 0 10px 40px rgba(255,255,255,.25)}
@keyframes bob{0%,100%{transform:translateY(0) rotate(-3deg)}50%{transform:translateY(-16px) rotate(3deg)}}
.zh-dot{position:absolute;border-radius:50%;background:rgba(255,255,255,.28)}
.zh-dot.a{width:44px;height:44px;top:6%;left:12%;animation:bob 7s ease-in-out infinite}.zh-dot.b{width:26px;height:26px;bottom:12%;right:16%;animation:bob 9s ease-in-out infinite}
/* wave nối hero xuống lưới */
.zwave{display:block;width:100%;height:70px;margin-top:-1px}

/* ============ ZONE GRID (lưới sản phẩm) ============ */
.zbody{padding:46px 0 66px}
.zbody-head{display:flex;align-items:baseline;justify-content:space-between;gap:16px;margin-bottom:26px;flex-wrap:wrap}
.zbody-head h3{font-size:clamp(22px,3vw,30px);color:var(--navy-dark)}
.zbody-head h3 span{color:var(--a2)}
.zbody-head .count{font-weight:700;font-size:13.5px;color:var(--ink-soft);background:#fff;border:1px solid var(--line);padding:7px 16px;border-radius:99px}
.grid{display:grid;grid-template-columns:repeat(4,1fr);gap:24px}
.pcard{background:#fff;border-radius:22px;overflow:hidden;border:1px solid var(--line);transition:transform .35s cubic-bezier(.2,.7,.2,1),box-shadow .35s;display:flex;flex-direction:column}
.pcard:hover{transform:translateY(-10px);box-shadow:var(--shadow)}
.p-thumb{aspect-ratio:1/1;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden}.p-thumb svg{width:42%;height:42%;filter:drop-shadow(0 12px 16px rgba(0,0,0,.2));transition:transform .4s cubic-bezier(.2,.7,.2,1)}
.pcard:hover .p-thumb svg{transform:translateY(-6px) scale(1.05)}
.p-tag{position:absolute;top:14px;left:14px;background:#fff;color:var(--a2);font-size:11px;font-weight:800;padding:5px 12px;border-radius:99px;box-shadow:var(--shadow-sm)}
.p-body{padding:18px 20px 20px}.p-body h4{font-family:var(--fd);font-weight:600;font-size:18px;margin-bottom:4px}.p-body .meta{font-size:12.5px;color:var(--ink-soft);font-weight:600;margin-bottom:15px}
.p-foot{display:flex;align-items:center;border-top:1px solid var(--line);padding-top:14px}
.p-price{font-family:var(--fd);font-weight:700;font-size:21px;color:var(--a2);white-space:nowrap}.p-price small{font-size:12px;font-weight:400;color:var(--ink-soft)}
.add-btn{width:100%;margin-top:12px;height:46px;border-radius:13px;background:linear-gradient(135deg,var(--a),var(--a2));color:#fff;display:flex;align-items:center;justify-content:center;gap:8px;font-weight:700;font-size:14.5px;white-space:nowrap;transition:transform .2s,filter .2s,box-shadow .25s}
.add-btn:hover{filter:brightness(1.06);transform:translateY(-2px);box-shadow:0 12px 22px -10px var(--a2)}
.add-btn:disabled{opacity:.45;cursor:default;transform:none;box-shadow:none;background:var(--ink-soft)}
/* dải trang trí ngăn cách 2 khu */
.zdivider{display:flex;align-items:center;justify-content:center;gap:22px;max-width:var(--container);margin:0 auto 54px;padding:18px 26px 6px}
.zdivider .ln{flex:1;max-width:360px;height:3px;border-radius:3px;background:repeating-linear-gradient(90deg,var(--sand) 0,var(--sand) 9px,transparent 9px,transparent 18px)}
.zdivider .em{width:58px;height:58px;border-radius:50%;background:#fff;border:2px solid var(--sand);display:flex;align-items:center;justify-content:center;font-size:26px;box-shadow:var(--shadow-sm);flex:none}
.empty{grid-column:1/-1;text-align:center;padding:40px 0;color:var(--ink-soft);font-weight:600}
footer{background:var(--navy-darker);color:#9FB2CC;font-size:14px}
.ft-top{max-width:var(--container);margin:0 auto;padding:60px 26px 40px;display:grid;grid-template-columns:1.4fr 1fr 1fr 1.5fr;gap:40px}
.ft-col h5{color:#fff;font-family:var(--fd);font-weight:600;font-size:16px;margin-bottom:16px;letter-spacing:.02em}
.ft-brand .logo{color:#fff;margin-bottom:14px}.ft-brand .logo b{color:#fff}
.ft-brand p{line-height:1.7;margin-bottom:14px;max-width:280px}
.ft-brand .contact{font-size:13.5px;line-height:2}.ft-brand .contact b{color:#fff}
.ft-col ul li{margin-bottom:10px}.ft-col ul a{transition:color .2s}.ft-col ul a:hover{color:#fff}
.ft-news p{line-height:1.6;margin-bottom:14px}
.ft-form{display:flex;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.18);border-radius:99px;padding:5px;max-width:320px}
.ft-form input{flex:1;background:none;border:none;outline:none;color:#fff;padding:9px 16px;font:inherit;font-size:13.5px}.ft-form input::placeholder{color:#8ba0bd}
.ft-form button{background:var(--red);color:#fff;border-radius:99px;padding:9px 18px;font-weight:700;font-size:13.5px;white-space:nowrap;transition:filter .2s}.ft-form button:hover{filter:brightness(1.1)}
.ft-socials{display:flex;gap:10px;margin-top:16px}
.ft-socials a{width:38px;height:38px;border-radius:50%;background:rgba(255,255,255,.1);display:flex;align-items:center;justify-content:center;transition:background .2s}.ft-socials a:hover{background:var(--red)}
.ft-bottom{border-top:1px solid rgba(255,255,255,.12);text-align:center;padding:20px 26px;font-size:13px}
.ft-bottom a{color:#fff}
@media(max-width:820px){.ft-top{grid-template-columns:1fr 1fr;gap:34px}}
@media(max-width:520px){.ft-top{grid-template-columns:1fr}}
.fly{position:fixed;z-index:300;width:24px;height:24px;border-radius:50%;background:var(--red);box-shadow:0 6px 16px rgba(0,0,0,.28);pointer-events:none;transition:transform .8s cubic-bezier(.5,-.25,.35,1),opacity .8s;will-change:transform,opacity}
.cart-ic.bump,.site-nav-icon.bump{animation:bump .45s}
@keyframes bump{0%{transform:scale(1)}40%{transform:scale(1.4)}100%{transform:scale(1)}}
.toast{position:fixed;left:50%;bottom:30px;transform:translateX(-50%) translateY(20px);background:var(--navy-darker);color:#fff;padding:14px 24px;border-radius:99px;font-weight:600;box-shadow:var(--shadow);opacity:0;pointer-events:none;transition:.3s;z-index:200}
.toast.show{transform:translateX(-50%) translateY(0);opacity:1}
@media(max-width:960px){.grid{grid-template-columns:repeat(3,1fr)}.zhero-inner{grid-template-columns:1fr;text-align:center}.zh-badges,.zh-num{justify-content:center}.zh-num::before{display:none}.zh-art{order:-1}.zh-bubble{width:190px;height:190px;font-size:88px}}
@media(max-width:720px){.grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<svg class="deco tl" viewBox="0 0 200 200" fill="none" stroke="currentColor" stroke-width="2"><path d="M100 190 C100 120 60 90 30 70 M100 190 C100 120 140 90 170 70 M100 190 L100 40 M100 90 C70 80 45 55 40 25 M100 90 C130 80 155 55 160 25 M100 140 C75 132 55 112 50 88 M100 140 C125 132 145 112 150 88"/></svg>
<svg class="deco br" viewBox="0 0 200 120" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 60 C60 20 120 100 190 40 M20 80 C70 45 130 110 180 65 M40 30 C60 40 55 60 40 65"/></svg>
<section class="head">
  <span class="head-script">Pure</span>
  <div class="container">
    <span class="eyebrow" style="color:var(--navy)">Cửa hàng PureNut</span>
    <h1>Hai dòng sản phẩm, một tiêu chuẩn thuần khiết</h1>
    <p>Ghé thăm khu Đậu Nành béo bùi và khu Sữa Đặc Biệt cao cấp của chúng tôi.</p>
    <div class="qnav">
      <a href="${ctx}/products" class="${empty currentCategory ? 'on' : ''}">Tất cả</a>
      <a href="#khu-dau">🌰 Khu Đậu Nành</a>
      <a href="#khu-sua">🥛 Khu Sữa Đặc Biệt</a>
    </div>
  </div>
</section>

<!-- ============ KHU 01 · ĐẬU NÀNH ============ -->
<c:if test="${empty currentCategory or currentCategory == 'dau-nanh'}">
<section class="zone" id="khu-dau" style="--a:#CBA267;--a2:#6E4A1C;--b:#F3D98B">
  <div class="zhero" data-rain="bean">
    <svg class="ztop" viewBox="0 0 1200 56" preserveAspectRatio="none"><path d="M0,0 L1200,0 L1200,16 C900,20 760,52 600,52 C440,52 300,20 0,16 Z" fill="var(--cream)"/></svg>
    <span class="ghost">Đậu Nành</span>
    <span class="zf zf1"></span><span class="zf zf2"></span><span class="zf zf3"></span>
    <div class="zrain"></div>
    <div class="container">
      <div class="zhero-inner">
        <div class="reveal">
          <span class="zh-num">01 · KHU ĐẬU NÀNH</span>
          <h2>Béo bùi,<br>giàu đạm thực vật</h2>
          <p>Đậu nành Non-GMO xay nguyên hạt, kết hợp hạnh nhân, óc chó, mè đen — ít đường, dễ tiêu, thơm ngậy tự nhiên.</p>
          <div class="zh-badges"><span>✓ Non-GMO</span><span>✓ Ít đường</span><span>✓ Giàu đạm</span></div>
          <a href="#dau-grid" class="zh-cta">Xem sản phẩm ↓</a>
        </div>
        <div class="zh-art reveal"><span class="zh-dot a"></span><span class="zh-dot b"></span><div class="zh-bubble">🌰</div></div>
      </div>
    </div>
  </div>
  <svg class="zwave" viewBox="0 0 1200 70" preserveAspectRatio="none"><path d="M0,0 C300,80 520,80 620,40 C740,-8 980,0 1200,58 L1200,70 L0,70 Z" fill="var(--cream)"/></svg>
  <div class="zbody">
    <div class="container" id="dau-grid">
      <c:set var="beanCount" value="0"/><c:forEach var="p" items="${products}"><c:if test="${p.categorySlug=='dau-nanh'}"><c:set var="beanCount" value="${beanCount+1}"/></c:if></c:forEach>
      <div class="zbody-head reveal">
        <h3>Sản phẩm <span>Đậu Nành</span></h3>
        <span class="count">${beanCount} sản phẩm</span>
      </div>
      <div class="grid">
        <c:forEach var="p" items="${products}"><c:if test="${p.categorySlug=='dau-nanh'}">
          <article class="pcard reveal">
            <a href="${ctx}/products/${p.slug}"><div class="p-thumb" style="background:${not empty p.bgColorHex ? p.bgColorHex : '#E7C9A0'}"><c:if test="${p.featured}"><span class="p-tag">⭐ Nổi bật</span></c:if><svg viewBox="0 0 24 24" fill="none"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" fill="rgba(255,255,255,.9)"/></svg></div></a>
            <div class="p-body">
              <a href="${ctx}/products/${p.slug}"><h4>${p.name}</h4></a>
              <div class="meta">${p.volumeMl}ml · ${p.kcalPer100ml} kcal/100ml</div>
              <div class="p-foot"><span class="p-price">${p.formattedPrice}<small> đ</small></span></div>
              <c:choose><c:when test="${p.stockQuantity>0}"><button class="add-btn" data-id="${p.productId}" data-name="${p.name}"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg><span class="lbl">Thêm vào giỏ</span></button></c:when><c:otherwise><button class="add-btn" disabled>Hết hàng</button></c:otherwise></c:choose>
            </div>
          </article>
        </c:if></c:forEach>
        <c:if test="${beanCount==0}"><p class="empty">Đang cập nhật sản phẩm...</p></c:if>
      </div>
    </div>
  </div>
</section>
</c:if>

<c:if test="${empty currentCategory}">
<div class="zdivider"><span class="ln"></span><span class="em">🌱</span><span class="ln"></span></div>
</c:if>

<!-- ============ KHU 02 · SỮA ĐẶC BIỆT ============ -->
<c:if test="${empty currentCategory or currentCategory == 'dac-biet'}">
<section class="zone" id="khu-sua" style="--a:#5AA0DC;--a2:#175A99;--b:#BFE0F2">
  <div class="zhero" data-rain="milk">
    <svg class="ztop" viewBox="0 0 1200 56" preserveAspectRatio="none"><path d="M0,0 L1200,0 L1200,16 C900,20 760,52 600,52 C440,52 300,20 0,16 Z" fill="var(--cream)"/></svg>
    <span class="ghost">Sữa Hạt</span>
    <span class="zf zf1"></span><span class="zf zf2"></span><span class="zf zf3"></span>
    <div class="zrain"></div>
    <div class="container">
      <div class="zhero-inner">
        <div class="reveal">
          <span class="zh-num">02 · KHU SỮA ĐẶC BIỆT</span>
          <h2>Công thức cao cấp<br>từ nhiều loại hạt</h2>
          <p>Sữa 9 loại hạt và sữa yến mạch — hoà quyện tinh tế, không đường, mịn màng và tròn vị cho mỗi sáng.</p>
          <div class="zh-badges"><span>✓ Không đường</span><span>✓ Nhiều loại hạt</span><span>✓ Cao cấp</span></div>
          <a href="#sua-grid" class="zh-cta">Xem sản phẩm ↓</a>
        </div>
        <div class="zh-art reveal"><span class="zh-dot a"></span><span class="zh-dot b"></span><div class="zh-bubble">🥛</div></div>
      </div>
    </div>
  </div>
  <svg class="zwave" viewBox="0 0 1200 70" preserveAspectRatio="none"><path d="M0,58 C250,0 470,-8 620,40 C720,80 940,80 1200,0 L1200,70 L0,70 Z" fill="var(--cream)"/></svg>
  <div class="zbody">
    <div class="container" id="sua-grid">
      <c:set var="milkCount" value="0"/><c:forEach var="p" items="${products}"><c:if test="${p.categorySlug=='dac-biet'}"><c:set var="milkCount" value="${milkCount+1}"/></c:if></c:forEach>
      <div class="zbody-head reveal">
        <h3>Sản phẩm <span>Sữa Đặc Biệt</span></h3>
        <span class="count">${milkCount} sản phẩm</span>
      </div>
      <div class="grid">
        <c:forEach var="p" items="${products}"><c:if test="${p.categorySlug=='dac-biet'}">
          <article class="pcard reveal">
            <a href="${ctx}/products/${p.slug}"><div class="p-thumb" style="background:${not empty p.bgColorHex ? p.bgColorHex : '#BFE0F2'}"><c:if test="${p.featured}"><span class="p-tag">⭐ Nổi bật</span></c:if><svg viewBox="0 0 24 24" fill="none"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" fill="rgba(255,255,255,.9)"/></svg></div></a>
            <div class="p-body">
              <a href="${ctx}/products/${p.slug}"><h4>${p.name}</h4></a>
              <div class="meta">${p.volumeMl}ml · ${p.kcalPer100ml} kcal/100ml</div>
              <div class="p-foot"><span class="p-price">${p.formattedPrice}<small> đ</small></span></div>
              <c:choose><c:when test="${p.stockQuantity>0}"><button class="add-btn" data-id="${p.productId}" data-name="${p.name}"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg><span class="lbl">Thêm vào giỏ</span></button></c:when><c:otherwise><button class="add-btn" disabled>Hết hàng</button></c:otherwise></c:choose>
            </div>
          </article>
        </c:if></c:forEach>
        <c:if test="${milkCount==0}"><p class="empty">Đang cập nhật sản phẩm...</p></c:if>
      </div>
    </div>
  </div>
</section>
</c:if>

<footer>
  <div class="ft-top">
    <div class="ft-col ft-brand">
      <a href="${ctx}/" class="logo"><span class="dot"><svg width="20" height="20" viewBox="0 0 34 34"><path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.8"/></svg></span>Pure<b>Nut</b></a>
      <p>Sữa hạt thuần khiết từ hạt Việt — không chất bảo quản, vì một sức khoẻ xanh mỗi ngày.</p>
      <div class="contact">📍 123 Nguyễn Văn Cừ, Q.5, TP.HCM<br>📞 Hotline: <b>1900 6789</b><br>✉️ <b>hello@purenut.vn</b></div>
    </div>
    <div class="ft-col">
      <h5>Liên kết nhanh</h5>
      <ul><li><a href="${ctx}/about">Về chúng tôi</a></li><li><a href="${ctx}/products">Cửa hàng</a></li><li><a href="${ctx}/about#vi-sao">Câu chuyện</a></li><li><a href="${ctx}/cart">Giỏ hàng</a></li></ul>
    </div>
    <div class="ft-col">
      <h5>Chính sách</h5>
      <ul><li><a href="${ctx}/about">Giao hàng</a></li><li><a href="${ctx}/about">Đổi trả</a></li><li><a href="${ctx}/about">Bảo mật</a></li><li><a href="${ctx}/about#lien-he">Liên hệ</a></li></ul>
    </div>
    <div class="ft-col ft-news">
      <h5>Nhận bản tin</h5>
      <p>Đăng ký email để nhận <b style="color:#fff">mã giảm giá</b> và ưu đãi mới nhất.</p>
      <form class="ft-form" onsubmit="return false"><input type="email" placeholder="Email của bạn..."><button type="submit">Đăng ký</button></form>
      <div class="ft-socials"><a href="#" aria-label="Facebook">f</a><a href="#" aria-label="Instagram">◎</a><a href="#" aria-label="YouTube">▶</a></div>
    </div>
  </div>
  <div class="ft-bottom">© 2026 PureNut Việt Nam · <a href="${ctx}/about">Giới thiệu</a> · <a href="${ctx}/cart">Giỏ hàng</a></div>
</footer>
<div class="toast" id="toast">✓ <span id="toastMsg">Đã thêm vào giỏ</span></div>

<script>
var CTX='${ctx}';
document.addEventListener('DOMContentLoaded',function(){
  var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target);}});},{threshold:.12,rootMargin:'0px 0px -40px'});
  document.querySelectorAll('.reveal').forEach(function(el){io.observe(el);});
  // 3D: nghiêng minh hoạ theo chuột
  document.querySelectorAll('.zhero').forEach(function(hero){
    var art=hero.querySelector('.zh-art');if(!art)return;
    hero.addEventListener('mousemove',function(e){var r=hero.getBoundingClientRect();var px=(e.clientX-r.left)/r.width-.5,py=(e.clientY-r.top)/r.height-.5;art.style.transform='rotateY('+(px*16)+'deg) rotateX('+(-py*16)+'deg)';});
    hero.addEventListener('mouseleave',function(){art.style.transform='';});
    // mưa hạt / dòng sữa
    var layer=hero.querySelector('.zrain'),kind=hero.getAttribute('data-rain'),timer=null;
    function spawn(){var w=hero.clientWidth,h=hero.clientHeight;
      if(kind==='milk'){var s=document.createElement('div');s.className='rain-s';s.style.left=(Math.random()*w)+'px';s.style.height=(28+Math.random()*46)+'px';s.style.setProperty('--fh',(h+90)+'px');s.style.animation='stream '+(1+Math.random()*0.9)+'s linear forwards';layer.appendChild(s);setTimeout(function(){s.remove();},2100);}
      else{var p=document.createElement('div');p.className='rain-p';p.textContent=Math.random()<0.5?'🌰':'🥜';p.style.left=(Math.random()*w)+'px';p.style.fontSize=(15+Math.random()*15)+'px';p.style.setProperty('--fh',(h+90)+'px');p.style.setProperty('--fr',(Math.random()*720-360)+'deg');p.style.animation='fall '+(1.6+Math.random()*1.3)+'s linear forwards';layer.appendChild(p);setTimeout(function(){p.remove();},3200);}}
    hero.addEventListener('mouseenter',function(){if(timer||!layer)return;for(var i=0;i<4;i++)spawn();timer=setInterval(spawn,kind==='milk'?130:170);});
    hero.addEventListener('mouseleave',function(){clearInterval(timer);timer=null;});
  });
  // parallax nhẹ cho chữ chìm khi cuộn
  var ghosts=document.querySelectorAll('.zhero .ghost');
  window.addEventListener('scroll',function(){var vh=window.innerHeight;ghosts.forEach(function(g){var rect=g.closest('.zhero').getBoundingClientRect();var off=(rect.top+rect.height/2-vh/2)*-0.05;g.style.transform='translate(-50%,calc(-50% + '+off.toFixed(1)+'px))';});},{passive:true});
  document.querySelectorAll('.grid').forEach(function(g){Array.prototype.slice.call(g.querySelectorAll('.pcard')).forEach(function(c,i){c.style.transitionDelay=(i*70)+'ms';});});
  var toast=document.getElementById('toast'),tm=document.getElementById('toastMsg'),tt;function showToast(m){tm.textContent=m;toast.classList.add('show');clearTimeout(tt);tt=setTimeout(function(){toast.classList.remove('show');},2200);}
  function flyToCart(src){var cart=document.querySelector('.cart-ic')||document.querySelector('a[href$="/cart"]');if(!cart)return;var s=src.getBoundingClientRect(),e=cart.getBoundingClientRect();var f=document.createElement('div');f.className='fly';f.style.left=(s.left+s.width/2-12)+'px';f.style.top=(s.top+s.height/2-12)+'px';document.body.appendChild(f);requestAnimationFrame(function(){var dx=(e.left+e.width/2)-(s.left+s.width/2),dy=(e.top+e.height/2)-(s.top+s.height/2);f.style.transform='translate('+dx+'px,'+dy+'px) scale(.25)';f.style.opacity='.35';});setTimeout(function(){f.remove();cart.classList.add('bump');setTimeout(function(){cart.classList.remove('bump');},450);},820);}
  var badge=document.getElementById('siteCartBadge');
  document.querySelectorAll('.add-btn:not([disabled])').forEach(function(b){b.addEventListener('click',async function(){var id=b.dataset.id;if(!id)return;flyToCart(b);b.disabled=true;try{var r=await fetch(CTX+'/cart/add',{method:'POST',headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'},body:'productId='+id+'&quantity=1'});if(r.redirected){window.location=r.url;return;}var d=await r.json();if(d&&d.success){if(badge)badge.textContent=d.cartCount;showToast('Đã thêm "'+b.dataset.name+'" vào giỏ');}}catch(e){window.location=CTX+'/login';}finally{b.disabled=false;}});});
});
</script>
</body>
</html>
