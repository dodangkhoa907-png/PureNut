<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isBean" value="${product.categorySlug == 'dau-nanh'}"/>
<c:set var="accA" value="${isBean ? '#B9883A' : '#1877C4'}"/>
<c:set var="accB" value="${isBean ? '#F3D98B' : '#BFE0F2'}"/>
<c:set var="accGrad" value="${isBean ? 'linear-gradient(135deg,#F3D98B,#D4A93A,#B9883A)' : 'linear-gradient(135deg,#BFE0F2,#5BAEE8,#1877C4)'}"/>
<c:set var="zoneName" value="${isBean ? 'Khu Đậu Nành' : 'Khu Sữa Đặc Biệt'}"/>
<c:set var="zoneIcon" value="${isBean ? '🌰' : '🥛'}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${product.name}"/> — PureNut</title>
<meta name="description" content="${fn:escapeXml(fn:substring(product.description, 0, 160))}">
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@500;700;800&display=swap" rel="stylesheet">
<script>window.CTX='${ctx}';</script>
<style>
/* ── Breadcrumb ── */
.crumb{
  padding:18px 0;color:var(--ink-soft);font-size:13px;font-weight:600;
  display:flex;align-items:center;gap:8px;border-bottom:1px solid var(--line);
}
.crumb a{transition:.2s}.crumb a:hover{color:var(--navy)}
.crumb-sep{color:#C8BBB0;font-size:11px}

/* ── Detail layout ── */
.detail{display:grid;grid-template-columns:1fr 1fr;gap:52px;padding:36px 0 60px;align-items:start}

/* ── Gallery ── */
@keyframes bob{0%,100%{transform:translateY(0) rotate(-3deg)}50%{transform:translateY(-16px) rotate(3deg)}}
.gallery{
  position:relative;border-radius:28px;aspect-ratio:1/1;display:flex;align-items:center;
  justify-content:center;box-shadow:0 28px 60px -16px rgba(0,0,0,.18),0 0 0 1px rgba(0,0,0,.04);
  overflow:hidden;
}
.gallery-bg{position:absolute;inset:0;background:${accGrad}}
.gallery-noise{position:absolute;inset:0;pointer-events:none;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.05'/%3E%3C/svg%3E")}
.gallery-circle{
  width:58%;height:58%;border-radius:50%;background:rgba(255,255,255,.2);
  border:2.5px dashed rgba(255,255,255,.55);display:flex;align-items:center;justify-content:center;
  font-size:100px;animation:bob 5s ease-in-out infinite;position:relative;z-index:2;
  box-shadow:0 8px 32px rgba(0,0,0,.12);
}
.gallery-label{position:absolute;top:20px;left:20px;z-index:3;background:rgba(255,255,255,.22);border:1px solid rgba(255,255,255,.4);backdrop-filter:blur(6px);padding:8px 16px;border-radius:99px;font-weight:700;font-size:12.5px;color:#fff;box-shadow:0 2px 8px rgba(0,0,0,.1)}
.gallery-vol{position:absolute;bottom:20px;right:20px;z-index:3;background:rgba(255,255,255,.22);border:1px solid rgba(255,255,255,.4);backdrop-filter:blur(6px);padding:6px 14px;border-radius:99px;font-size:12px;font-weight:700;color:#fff}

/* ── Info pane ── */
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:none}}
.info-pane{animation:fadeUp .6s cubic-bezier(.16,1,.3,1) .15s both}
.eyebrow-pill{display:inline-flex;align-items:center;gap:6px;padding:5px 14px;border-radius:99px;font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;margin-bottom:14px;border:1.5px solid}
.info-pane h1{font-size:clamp(28px,3.6vw,42px);margin-bottom:14px;line-height:1.2;color:var(--ink)}
.price{display:inline-block;font-family:'EB Garamond',var(--fd),serif;font-weight:800;font-size:38px;margin-bottom:6px;background:${accGrad};-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.price-sub{font-size:13px;color:var(--ink-soft);margin-bottom:24px;font-weight:500}

/* ── Options — F&B Modifiers ── */
.opt-section{margin-bottom:22px}
.opt-label{font-size:12px;font-weight:800;color:var(--navy);text-transform:uppercase;letter-spacing:.06em;margin-bottom:10px;display:flex;align-items:center;gap:7px}
.opt-label svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.opt-pills{display:flex;gap:6px;flex-wrap:wrap}
.opt-pill{
  padding:10px 20px;border-radius:12px;font-size:14px;font-weight:600;
  border:1.5px solid var(--line);background:#fff;color:var(--ink);cursor:pointer;
  transition:all .18s;position:relative;
}
.opt-pill:hover{border-color:var(--navy);color:var(--navy);background:rgba(27,79,158,.02)}
.opt-pill.sel{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;border-color:#1B4F9E;box-shadow:0 4px 14px -4px rgba(27,79,158,.4)}
.opt-pill .pill-extra{font-size:11px;opacity:.7;margin-left:4px}

/* ── Subscription upsell ── */
.sub-upsell{
  padding:18px 20px;border-radius:16px;margin-bottom:24px;
  background:linear-gradient(135deg,rgba(43,172,98,.06),rgba(43,172,98,.02));
  border:1.5px solid rgba(43,172,98,.15);display:flex;align-items:center;gap:14px;
  cursor:pointer;transition:all .18s;
}
.sub-upsell:hover{border-color:rgba(43,172,98,.35);box-shadow:0 6px 18px -6px rgba(43,172,98,.12)}
.sub-upsell.active{border-color:#2BAC62;background:linear-gradient(135deg,rgba(43,172,98,.1),rgba(43,172,98,.04))}
.sub-check{
  width:24px;height:24px;border-radius:8px;border:2px solid var(--line);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
  transition:all .18s;background:#fff;
}
.sub-upsell.active .sub-check{background:#2BAC62;border-color:#2BAC62}
.sub-upsell.active .sub-check svg{opacity:1}
.sub-check svg{width:14px;height:14px;stroke:#fff;fill:none;stroke-width:2.5;stroke-linecap:round;opacity:0;transition:opacity .18s}
.sub-text{flex:1}
.sub-text strong{font-size:14px;color:var(--ink);display:block;margin-bottom:2px}
.sub-text span{font-size:12.5px;color:var(--ink-soft)}
.sub-badge{padding:4px 12px;border-radius:99px;font-size:11px;font-weight:800;background:linear-gradient(135deg,#2BAC62,#34D399);color:#fff;white-space:nowrap}

/* ── Nutrition + Tabs ── */
.info-tabs{display:flex;gap:8px;margin-bottom:18px;border-bottom:2px solid var(--line);padding-bottom:4px;overflow-x:auto;-webkit-overflow-scrolling:touch;scroll-snap-type:x mandatory}
.info-tabs::-webkit-scrollbar{display:none}
.info-tab{
  min-width:100px;flex:0 0 auto;padding:10px 18px;font-size:13.5px;font-weight:700;color:var(--ink-soft);
  border:none;background:none;cursor:pointer;position:relative;transition:color .15s;scroll-snap-align:start;text-align:center;
}
.info-tab:hover{color:var(--navy)}
.info-tab.active{color:var(--navy)}
.info-tab.active::after{content:'';position:absolute;bottom:-2px;left:12px;right:12px;height:2.5px;background:var(--navy);border-radius:99px}
.info-pane-tab{display:none}.info-pane-tab.show{display:block}

.nutri{background:var(--paper);border:1.5px solid var(--line);border-radius:18px;padding:18px 22px;box-shadow:0 4px 16px rgba(0,0,0,.04)}
.nutri-row{display:flex;justify-content:space-between;align-items:center;padding:9px 0;font-size:14px}
.nutri-row:not(:last-child){border-bottom:1px solid var(--line)}
.nutri-row .lbl{color:var(--ink-soft);font-weight:500}
.nutri-row b{font-weight:700;color:var(--ink)}

.desc-block{font-size:14.5px;color:var(--ink-soft);line-height:1.7}
.desc-block p{margin-bottom:12px}
.desc-block ul{padding-left:18px;margin-bottom:12px}
.desc-block ul li{margin-bottom:6px}
.desc-block strong{color:var(--ink)}

/* Qty */
.qwrap{display:flex;align-items:center;gap:18px;margin-bottom:22px}
.qty-label{font-weight:700;font-size:14px}
.qty{display:inline-flex;align-items:center;border:2px solid var(--line);border-radius:14px;overflow:hidden;background:var(--paper)}
.qty button{width:42px;height:44px;background:transparent;font-size:20px;color:var(--ink);font-weight:700;transition:background .2s;border:none;cursor:pointer}
.qty button:hover{background:var(--sand)}
.qty input{width:52px;height:44px;text-align:center;border:none;border-left:1px solid var(--line);border-right:1px solid var(--line);font-weight:700;font-size:16px;background:transparent;outline:none}
.qty-stock{font-size:13px;color:var(--ink-soft);font-weight:500}

.actions{display:flex;gap:14px}
.actions .btn{flex:1;display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:15px 28px;border-radius:99px;font-weight:700;font-size:14.5px;transition:transform .2s,box-shadow .2s;border:none;cursor:pointer}
.actions .btn svg{width:17px;height:17px;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.btn-accent{color:#fff;box-shadow:0 6px 18px ${accA}44}
.btn-accent:hover{transform:translateY(-2px);box-shadow:0 10px 24px ${accA}55}
.btn-red{background:var(--red);color:#fff;box-shadow:0 6px 18px rgba(206,46,46,.22)}
.btn-red:hover{transform:translateY(-2px);box-shadow:0 10px 24px rgba(206,46,46,.30)}

/* ── Related ── */
.rel{padding:60px 0 100px;margin:40px 0 0}
.rel-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:32px}
.rel-header h2{font-size:26px}
.rel-see-all{font-size:13.5px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:4px;transition:.2s}
.rel-see-all:hover{color:var(--red)}
.rel-see-all svg{width:14px;height:14px;fill:none;stroke:currentColor;stroke-width:2.5;stroke-linecap:round}
.grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px}
.pcard{background:var(--paper);border:1.5px solid var(--line);border-radius:22px;overflow:hidden;display:flex;flex-direction:column;transition:transform .3s cubic-bezier(.16,1,.3,1),box-shadow .3s;text-decoration:none;color:inherit}
.pcard:hover{transform:translateY(-6px);box-shadow:0 22px 44px -12px rgba(0,0,0,.15)}
.pcard-thumb{aspect-ratio:1/1;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden}
.pcard-thumb-emoji{font-size:48px;position:relative;z-index:2;filter:drop-shadow(0 4px 8px rgba(0,0,0,.12))}
.pcard-feat-badge{position:absolute;top:12px;left:12px;z-index:3;background:rgba(255,255,255,.88);backdrop-filter:blur(4px);padding:4px 10px;border-radius:99px;font-size:10.5px;font-weight:700;color:var(--ink);border:1px solid rgba(255,255,255,.95)}
.pcard-body{padding:16px 18px 18px;flex:1;display:flex;flex-direction:column}
.pcard-name{font-family:var(--fd);font-size:15px;font-weight:600;color:var(--ink);margin-bottom:5px;line-height:1.35}
.pcard-meta{font-size:12px;color:var(--ink-soft);margin-bottom:10px;font-weight:500}
.pcard-foot{display:flex;align-items:center;justify-content:space-between;margin-top:auto;padding-top:10px;border-top:1px solid var(--line)}
.pcard-price{font-family:var(--fd);font-weight:700;font-size:16px}
.pcard-arrow{width:30px;height:30px;border-radius:50%;background:rgba(0,0,0,.06);display:flex;align-items:center;justify-content:center;transition:all .2s;flex-shrink:0}
.pcard:hover .pcard-arrow{background:var(--navy);color:#fff}
.pcard-arrow svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round}

.section-divider{border:none;border-top:1px solid var(--line);margin:60px 0 0}

/* Toast & Fly */
.fly{position:fixed;z-index:300;width:24px;height:24px;border-radius:50%;background:var(--red);box-shadow:0 6px 16px rgba(0,0,0,.28);pointer-events:none;transition:transform .8s cubic-bezier(.5,-.25,.35,1),opacity .8s;will-change:transform,opacity}
.toast{position:fixed;left:50%;bottom:30px;transform:translateX(-50%) translateY(20px);background:var(--navy-darker);color:#fff;padding:14px 26px;border-radius:99px;font-weight:600;box-shadow:var(--shadow);opacity:0;pointer-events:none;transition:.3s;z-index:200;font-size:14px;display:flex;align-items:center;gap:8px}
.toast.show{transform:translateX(-50%) translateY(0);opacity:1}

/* ── Mobile-Only Elements (hidden on desktop) ── */
.mobile-pd-header,.mobile-action-bar,.pd-option-rows,.pd-reviews,.bottom-sheet,.bs-overlay,.mobile-carousel-dots,.carousel-badge{display:none}

@media(max-width:880px){
  .detail{grid-template-columns:1fr;gap:30px}.gallery{position:static}.grid{grid-template-columns:repeat(2,1fr)}
  .actions{flex-direction:column}.actions .btn{width:100%}
}

/* ══════════════════════════════════════════
   SHOPEE-STYLE MOBILE REDESIGN (≤860px)
   ══════════════════════════════════════════ */
@media(max-width:860px){
  /* ── Hide desktop-only elements ── */
  .site-nav,.crumb,.qwrap,.actions,.opt-section,.sub-upsell,.price-sub,.eyebrow-pill{display:none !important}
  body{padding-bottom:60px}

  /* ── Mobile Header (transparent → white on scroll) ── */
  .mobile-pd-header{
    display:flex !important;align-items:center;justify-content:space-between;
    position:fixed;top:0;left:0;right:0;z-index:150;padding:12px 16px;
    background:transparent;transition:background .3s,box-shadow .3s;
  }
  .mobile-pd-header.scrolled{background:#fff;box-shadow:0 2px 12px rgba(0,0,0,.08)}
  .mobile-pd-header .mph-back,.mobile-pd-header .mph-cart{
    width:36px;height:36px;border-radius:50%;background:rgba(0,0,0,.25);border:none;
    display:flex;align-items:center;justify-content:center;cursor:pointer;transition:.2s;
  }
  .mobile-pd-header.scrolled .mph-back,.mobile-pd-header.scrolled .mph-cart{background:transparent}
  .mobile-pd-header svg{width:20px;height:20px;stroke:#fff;fill:none;stroke-width:2.2;stroke-linecap:round;stroke-linejoin:round}
  .mobile-pd-header.scrolled svg{stroke:var(--ink)}
  .mph-right{display:flex;gap:8px}
  .mph-badge{position:absolute;top:-4px;right:-4px;width:18px;height:18px;border-radius:50%;background:var(--red);color:#fff;font-size:10px;font-weight:700;display:flex;align-items:center;justify-content:center;line-height:1}
  .mph-badge:empty{display:none}

  /* ── Hero Gallery (full-width carousel) ── */
  .gallery{
    width:100vw;margin-left:calc(-50vw + 50%);border-radius:0 !important;aspect-ratio:1/1;
    position:relative !important;box-shadow:none !important;
  }
  .gallery-label,.gallery-vol{display:none}
  .mobile-carousel-dots{
    display:flex !important;position:absolute;bottom:12px;left:50%;transform:translateX(-50%);
    gap:6px;z-index:5;
  }
  .mobile-carousel-dots .dot{width:6px;height:6px;border-radius:50%;background:rgba(255,255,255,.5);transition:.2s}
  .mobile-carousel-dots .dot.active{width:18px;border-radius:99px;background:#fff}
  .carousel-badge{
    display:flex !important;position:absolute;bottom:12px;right:14px;z-index:5;
    background:rgba(0,0,0,.5);color:#fff;padding:3px 10px;border-radius:99px;
    font-size:11px;font-weight:600;
  }

  /* ── Price + Social Proof block ── */
  .info-pane{animation:none !important;padding:0 16px}
  .price{font-family:var(--fb) !important;font-size:22px !important;color:var(--red) !important;-webkit-text-fill-color:var(--red) !important;background:none !important;margin-bottom:2px !important}
  .info-pane h1{font-size:16px !important;margin-bottom:8px !important;font-weight:600;line-height:1.4}
  .pd-social-proof{display:flex;align-items:center;gap:8px;font-size:12px;color:var(--ink-soft);margin-bottom:14px;padding-bottom:14px;border-bottom:1px solid var(--line)}
  .pd-social-proof .stars{color:#FFB800;letter-spacing:-1px}
  .pd-social-proof .sep{color:var(--line)}
  .pd-sold{margin-left:auto;font-weight:600}

  /* ── Bottom Sheet (purchase) ── */
  .bs-overlay{
    display:block !important;position:fixed;inset:0;z-index:199;background:rgba(0,0,0,.45);
    opacity:0;pointer-events:none;transition:opacity .3s;
  }
  .bs-overlay.open{opacity:1;pointer-events:auto}
  .bottom-sheet{
    display:flex !important;flex-direction:column;position:fixed;left:0;right:0;bottom:0;z-index:200;
    background:#fff;border-radius:18px 18px 0 0;max-height:70vh;
    transform:translateY(100%);transition:transform .35s cubic-bezier(.32,.72,0,1);
    box-shadow:0 -8px 30px rgba(0,0,0,.12);
  }
  .bottom-sheet.open{transform:translateY(0)}
  .bs-handle{width:36px;height:4px;border-radius:99px;background:#ddd;margin:10px auto 6px}
  .bs-close{position:absolute;top:14px;right:16px;background:none;border:none;font-size:22px;color:var(--ink-soft);cursor:pointer;padding:4px}
  .bs-body{padding:16px 20px;overflow-y:auto;flex:1}

  /* Purchase sheet product info */
  .bs-product{display:flex;gap:14px;padding-bottom:16px;border-bottom:1px solid var(--line);margin-bottom:16px}
  .bs-product-img{width:90px;height:90px;border-radius:12px;flex-shrink:0;display:flex;align-items:center;justify-content:center;overflow:hidden;font-size:40px}
  .bs-product-img img{width:100%;height:100%;object-fit:cover}
  .bs-product-info{flex:1;display:flex;flex-direction:column;justify-content:center}
  .bs-product-name{font-size:15px;font-weight:600;color:var(--ink);line-height:1.3;margin-bottom:6px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
  .bs-product-price{font-size:20px;font-weight:800;color:var(--red)}
  .bs-product-stock{font-size:12px;color:var(--ink-soft);margin-top:4px}
  /* Quantity in sheet */
  .bs-qty-wrap{display:flex;align-items:center;justify-content:space-between;padding:14px 0}
  .bs-qty-label{font-size:14px;font-weight:600;color:var(--ink)}
  .bs-qty{display:inline-flex;align-items:center;border:1.5px solid var(--line);border-radius:10px;overflow:hidden;background:var(--paper)}
  .bs-qty button{width:38px;height:38px;background:transparent;font-size:18px;color:var(--ink);font-weight:700;border:none;cursor:pointer}
  .bs-qty button:active{background:var(--sand)}
  .bs-qty input{width:48px;height:38px;text-align:center;border:none;border-left:1px solid var(--line);border-right:1px solid var(--line);font-weight:700;font-size:15px;background:transparent;outline:none;-moz-appearance:textfield}
  .bs-qty input::-webkit-inner-spin-button,.bs-qty input::-webkit-outer-spin-button{-webkit-appearance:none;margin:0}
  .bs-confirm{width:100%;padding:15px;border-radius:12px;border:none;color:#fff;font-weight:700;font-size:15px;cursor:pointer;margin-top:8px;transition:.15s}
  .bs-confirm:active{transform:scale(.97)}
  .bs-confirm.add{background:var(--navy)}
  .bs-confirm.buy{background:var(--red)}

  /* ── Tabs on mobile ── */
  .info-tabs{border-top:8px solid #f5f5f5;padding-top:8px;margin-top:0 !important}

  /* ── Sticky Bottom Action Bar ── */
  .mobile-action-bar{
    display:flex !important;position:fixed;bottom:0;left:0;right:0;z-index:100;
    background:#fff;border-top:1px solid rgba(0,0,0,.06);box-shadow:0 -2px 12px rgba(0,0,0,.06);
    height:54px;align-items:stretch;
  }
  .mab-add{
    width:50%;display:flex;align-items:center;justify-content:center;gap:6px;
    background:var(--navy);color:#fff;border:none;font-weight:700;font-size:14px;cursor:pointer;
  }
  .mab-add svg{width:18px;height:18px;stroke:#fff;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .mab-add:active{opacity:.85}
  .mab-buy{
    width:50%;display:flex;align-items:center;justify-content:center;gap:6px;
    background:var(--red);color:#fff;border:none;font-weight:700;font-size:14px;cursor:pointer;
  }
  .mab-buy:active{background:#B83020}

  /* ── Related on mobile ── */
  .rel{padding:16px 0 100px !important}
  .rel-header h2{font-size:18px !important}

  /* ── Misc mobile cleanup ── */
  .container.detail{padding:0 !important;gap:0 !important}
  .section-divider{display:none}
  .toast{bottom:70px !important}
}

@media(max-width:520px){
  .grid{grid-template-columns:1fr 1fr}
  .info-tab{padding:12px 14px;min-width:88px}.info-tabs{gap:6px}
  .price{font-size:20px !important}
  .info-pane h1{font-size:15px !important}
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<!-- ══ Mobile Header (transparent, floats on image) ══ -->
<div class="mobile-pd-header" id="mobileHeader">
  <button class="mph-back" onclick="history.back()">
    <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
  </button>
  <div class="mph-right">
    <a href="${ctx}/cart" class="mph-cart" style="position:relative;text-decoration:none">
      <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
      <span class="mph-badge" id="mobileCartBadge"><c:if test="${sessionScope.cartCount > 0}">${sessionScope.cartCount}</c:if></span>
    </a>
  </div>
</div>

<div class="container">
  <nav class="crumb" aria-label="Breadcrumb">
    <a href="${ctx}/">Trang chủ</a><span class="crumb-sep">›</span>
    <a href="${ctx}/products">Sản phẩm</a><span class="crumb-sep">›</span>
    <span style="color:var(--ink)"><c:out value="${product.name}"/></span>
  </nav>
</div>

<main class="container detail">
  <!-- Gallery -->
  <div class="gallery">
    <div class="gallery-bg"></div>
    <div class="gallery-noise"></div>
    <span class="gallery-label">${zoneIcon} ${zoneName}</span>
    <div class="gallery-circle">${zoneIcon}</div>
    <span class="gallery-vol">${product.volumeMl} ml</span>
    <!-- Mobile carousel indicators -->
    <div class="mobile-carousel-dots"><span class="dot active"></span></div>
    <span class="carousel-badge">1/1</span>
  </div>

  <!-- Info -->
  <div class="info-pane">
    <span class="eyebrow-pill" style="color:${accA};background:${accA}18;border-color:${accA}44"><c:out value="${product.categoryName}"/></span>
    <h1><c:out value="${product.name}"/></h1>
    <div class="price">${product.formattedPrice} đ</div>
    <div class="price-sub">/ chai ${product.volumeMl}ml · Đã bao gồm VAT</div>
    <!-- Mobile Social Proof -->
    <div class="pd-social-proof">
      <span class="stars">★★★★★</span>
      <span>4.9 (120 đánh giá)</span>
      <span class="sep">|</span>
      <span class="pd-sold">Đã bán 2k+</span>
    </div>

    <!-- ── Tabs: Thành phần / Lợi ích / Bảo quản ── -->
    <div class="info-tabs">
      <button class="info-tab active" data-itab="ingredients">Thành phần</button>
      <button class="info-tab" data-itab="benefits">Lợi ích</button>
      <button class="info-tab" data-itab="storage">Bảo quản</button>
    </div>

    <div id="itab-ingredients" class="info-pane-tab show">
      <div class="nutri">
        <div class="nutri-row"><span class="lbl">Dung tích</span><b>${product.volumeMl} ml</b></div>
        <div class="nutri-row"><span class="lbl">Năng lượng</span><b>${product.kcalPer100ml} kcal / 100ml</b></div>
        <div class="nutri-row"><span class="lbl">Tình trạng</span>
          <b style="color:${product.stockQuantity > 0 ? 'var(--green)' : 'var(--red)'}">
            ${product.stockQuantity > 0 ? '✓ Còn hàng' : '✗ Hết hàng'}
          </b>
        </div>
      </div>
      <div class="desc-block" style="margin-top:16px">
        <p><c:out value="${product.description}"/></p>
      </div>
    </div>

    <div id="itab-benefits" class="info-pane-tab">
      <div class="desc-block">
        <p><strong>Giàu dinh dưỡng thực vật:</strong> Cung cấp vitamin, khoáng chất và chất xơ tự nhiên từ hạt nguyên chất.</p>
        <ul>
          <li>Hỗ trợ tiêu hóa và sức khỏe đường ruột</li>
          <li>Giàu protein thực vật, phù hợp cho người ăn chay</li>
          <li>Không cholesterol, tốt cho tim mạch</li>
          <li>Ít calo hơn sữa động vật, phù hợp giảm cân</li>
        </ul>
        <p><strong>100% tự nhiên</strong> — Không chất bảo quản, không phẩm màu, không hương liệu nhân tạo.</p>
      </div>
    </div>

    <div id="itab-storage" class="info-pane-tab">
      <div class="desc-block">
        <ul>
          <li><strong>Hạn sử dụng:</strong> 3 ngày kể từ ngày sản xuất</li>
          <li><strong>Bảo quản:</strong> Ngăn mát tủ lạnh 2–6°C</li>
          <li><strong>Sau khi mở:</strong> Sử dụng trong vòng 24 giờ</li>
          <li><strong>Lắc đều trước khi uống</strong> — cặn lắng tự nhiên từ hạt là bình thường</li>
        </ul>
        <p>Sản phẩm được sản xuất trong điều kiện vô trùng, đóng chai thủy tinh giữ nguyên hương vị tươi ngon.</p>
      </div>
    </div>

    <c:choose>
      <c:when test="${product.stockQuantity > 0}">
        <form id="pform" style="margin-top:24px">
          <input type="hidden" name="productId" value="${product.productId}">
          <div class="qwrap">
            <span class="qty-label">Số lượng:</span>
            <div class="qty">
              <button type="button" class="minus">−</button>
              <input type="number" name="quantity" min="1" max="${product.stockQuantity}" value="1">
              <button type="button" class="plus">+</button>
            </div>
            <span class="qty-stock">Còn ${product.stockQuantity}</span>
          </div>
          <div class="actions">
            <button type="button" id="addBtn" class="btn btn-accent" style="background:${accA}">
              <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
              Thêm vào giỏ
            </button>
            <button type="button" id="buyBtn" class="btn btn-red">
              <svg viewBox="0 0 24 24"><polyline points="13 17 18 12 13 7"/><polyline points="6 17 11 12 6 7"/></svg>
              Mua ngay
            </button>
          </div>
        </form>
      </c:when>
      <c:otherwise>
        <button class="btn" disabled style="width:100%;opacity:.5;margin-top:24px;background:var(--ink-soft);color:#fff;padding:15px;border-radius:99px;font-weight:700;font-size:15px">Hết hàng tạm thời</button>
      </c:otherwise>
    </c:choose>
  </div>

</main>

<!-- ══ Purchase Bottom Sheet (mobile) ══ -->
<div class="bs-overlay" id="bsOverlay" onclick="closeAllSheets()"></div>
<div class="bottom-sheet" id="purchaseSheet">
  <div class="bs-handle"></div>
  <button class="bs-close" onclick="closeAllSheets()">&times;</button>
  <div class="bs-body">
    <div class="bs-product">
      <div class="bs-product-img" style="background:${fn:escapeXml(not empty product.bgColorHex ? product.bgColorHex : '#E9DCBE')}">
        <c:choose>
          <c:when test="${not empty product.imageUrl}"><img src="${ctx}${product.imageUrl}" alt="${fn:escapeXml(product.name)}"></c:when>
          <c:otherwise>${zoneIcon}</c:otherwise>
        </c:choose>
      </div>
      <div class="bs-product-info">
        <div class="bs-product-name"><c:out value="${product.name}"/></div>
        <div class="bs-product-price">${product.formattedPrice} đ</div>
        <div class="bs-product-stock">Còn ${product.stockQuantity} sản phẩm</div>
      </div>
    </div>
    <div class="bs-qty-wrap">
      <span class="bs-qty-label">Số lượng</span>
      <div class="bs-qty">
        <button type="button" id="bsQtyMinus">−</button>
        <input type="number" id="bsQtyInput" min="1" max="${product.stockQuantity}" value="1">
        <button type="button" id="bsQtyPlus">+</button>
      </div>
    </div>
    <button class="bs-confirm add" id="bsConfirmBtn">Thêm vào giỏ</button>
  </div>
</div>

<c:if test="${not empty relatedProducts}">
  <hr class="section-divider">
  <section class="container rel">
    <div class="rel-header">
      <h2>Sản phẩm cùng loại</h2>
      <a href="${ctx}/products" class="rel-see-all">Xem tất cả<svg viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg></a>
    </div>
    <div class="grid">
      <c:forEach var="rel" items="${relatedProducts}">
        <a href="${ctx}/products/${rel.slug}" class="pcard">
          <div class="pcard-thumb" style="background:${fn:escapeXml(not empty rel.bgColorHex ? rel.bgColorHex : '#E9DCBE')}">
            <div class="pcard-thumb-emoji">${isBean ? '🌰' : '🥛'}</div>
            <c:if test="${rel.featured}"><span class="pcard-feat-badge">⭐ Nổi bật</span></c:if>
          </div>
          <div class="pcard-body">
            <div class="pcard-name"><c:out value="${rel.name}"/></div>
            <div class="pcard-meta">${rel.volumeMl}ml · ${rel.kcalPer100ml} kcal/100ml</div>
            <div class="pcard-foot">
              <div class="pcard-price" style="color:${accA}">${rel.formattedPrice} đ</div>
              <div class="pcard-arrow"><svg viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg></div>
            </div>
          </div>
        </a>
      </c:forEach>
    </div>
  </section>
</c:if>

<div style="height:80px"></div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- ══ Mobile Sticky Bottom Action Bar ══ -->
<c:if test="${product.stockQuantity > 0}">
<div class="mobile-action-bar">
  <button class="mab-add" type="button" id="mabAddBtn">
    <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
    Thêm vào giỏ
  </button>
  <button class="mab-buy" type="button" id="mabBuyBtn">Mua ngay</button>
</div>
</c:if>

<div class="toast" id="toast">
  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="toastMsg">Đã thêm vào giỏ</span>
</div>

<script>
(function(){
  var CTX=window.CTX;

  // Option pills
  function initPills(containerId){
    var c=document.getElementById(containerId);if(!c)return;
    c.querySelectorAll('.opt-pill').forEach(function(p){
      p.addEventListener('click',function(){
        c.querySelectorAll('.opt-pill').forEach(function(x){x.classList.remove('sel')});
        this.classList.add('sel');
      });
    });
  }
  initPills('sweetPills');
  initPills('packPills');

  // Subscription upsell toggle
  var sub=document.getElementById('subUpsell');
  if(sub)sub.addEventListener('click',function(){this.classList.toggle('active')});

  // Info tabs
  document.querySelectorAll('.info-tab').forEach(function(tab){
    tab.addEventListener('click',function(){
      document.querySelectorAll('.info-tab').forEach(function(t){t.classList.remove('active')});
      document.querySelectorAll('.info-pane-tab').forEach(function(p){p.classList.remove('show')});
      this.classList.add('active');
      var p=document.getElementById('itab-'+this.getAttribute('data-itab'));
      if(p)p.classList.add('show');
    });
  });

  // Quantity
  var f=document.getElementById('pform');if(!f)return;
  var inp=f.querySelector('input[name="quantity"]');
  var max=parseInt(inp.getAttribute('max'),10)||999;
  f.querySelector('.minus').addEventListener('click',function(){var v=parseInt(inp.value,10)||1;if(v>1)inp.value=v-1});
  f.querySelector('.plus').addEventListener('click',function(){var v=parseInt(inp.value,10)||1;if(v<max)inp.value=v+1});

  // Toast
  var toast=document.getElementById('toast'),tm=document.getElementById('toastMsg'),tt;
  function showToast(m){tm.textContent=m;toast.classList.add('show');clearTimeout(tt);tt=setTimeout(function(){toast.classList.remove('show')},2400)}

  // Fly to cart
  function flyToCart(src){
    var cart=document.querySelector('.site-nav-icon[href*="/cart"]');if(!cart)return;
    var s=src.getBoundingClientRect(),e=cart.getBoundingClientRect();
    var dot=document.createElement('div');dot.className='fly';
    dot.style.left=(s.left+s.width/2-12)+'px';dot.style.top=(s.top+s.height/2-12)+'px';
    document.body.appendChild(dot);
    requestAnimationFrame(function(){
      var dx=(e.left+e.width/2)-(s.left+s.width/2),dy=(e.top+e.height/2)-(s.top+s.height/2);
      dot.style.transform='translate('+dx+'px,'+dy+'px) scale(.25)';dot.style.opacity='.35';
    });
    setTimeout(function(){dot.remove()},820);
  }

  // Add to cart
  async function addToCart(){
    var id=f.querySelector('input[name="productId"]').value,q=inp.value;
    try{
      var r=await fetch(CTX+'/cart/add',{method:'POST',headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'},body:'productId='+id+'&quantity='+q});
      if(r.redirected){window.location=r.url;return}
      var d=await r.json();
      if(d&&d.success){
        showToast('Đã thêm vào giỏ hàng ✓');
        var b1=document.getElementById('siteCartBadge');if(b1)b1.textContent=d.cartCount;
        var b2=document.getElementById('mobileCartBadge');if(b2)b2.textContent=d.cartCount;
      }
    }catch(e){window.location=CTX+'/login'}
  }

  document.getElementById('addBtn').addEventListener('click',function(){flyToCart(this);addToCart()});
  document.getElementById('buyBtn').addEventListener('click',function(){
    var form=document.createElement('form');form.method='POST';form.action=CTX+'/cart/add';
    form.innerHTML='<input name="_csrf" value="'+(document.querySelector('meta[name=_csrf]')||{content:''}).content+'"><input name="productId" value="'+f.querySelector('input[name=productId]').value+'"><input name="quantity" value="'+inp.value+'"><input name="action" value="buy_now">';
    document.body.appendChild(form);form.submit();
  });

  // ══ MOBILE INTERACTIONS ══
  var currentAction = 'add'; // 'add' or 'buy'

  // Mobile header scroll effect
  var mHeader=document.getElementById('mobileHeader');
  var galleryEl=document.querySelector('.gallery');
  if(mHeader && galleryEl){
    var obs=new IntersectionObserver(function(entries){
      entries.forEach(function(e){
        if(e.isIntersecting) mHeader.classList.remove('scrolled');
        else mHeader.classList.add('scrolled');
      });
    },{threshold:0.1});
    obs.observe(galleryEl);
  }

  // Bottom Sheet logic
  window.openSheet=function(id){
    var sheet=document.getElementById(id);
    var overlay=document.getElementById('bsOverlay');
    if(!sheet||!overlay)return;
    overlay.classList.add('open');
    sheet.classList.add('open');
    document.body.style.overflow='hidden';
  };
  window.closeAllSheets=function(){
    document.querySelectorAll('.bottom-sheet').forEach(function(s){s.classList.remove('open')});
    var overlay=document.getElementById('bsOverlay');
    if(overlay)overlay.classList.remove('open');
    document.body.style.overflow='';
  };

  // Purchase sheet quantity
  var bsQtyInput=document.getElementById('bsQtyInput');
  var bsMax=parseInt(bsQtyInput?bsQtyInput.getAttribute('max'):999,10)||999;
  var bsQtyMinus=document.getElementById('bsQtyMinus');
  var bsQtyPlus=document.getElementById('bsQtyPlus');
  if(bsQtyMinus)bsQtyMinus.addEventListener('click',function(){var v=parseInt(bsQtyInput.value,10)||1;if(v>1)bsQtyInput.value=v-1;});
  if(bsQtyPlus)bsQtyPlus.addEventListener('click',function(){var v=parseInt(bsQtyInput.value,10)||1;if(v<bsMax)bsQtyInput.value=v+1;});

  // Confirm button in purchase sheet
  var bsConfirmBtn=document.getElementById('bsConfirmBtn');
  if(bsConfirmBtn){
    bsConfirmBtn.addEventListener('click',function(){
      var qty=bsQtyInput?bsQtyInput.value:'1';
      if(inp)inp.value=qty; // sync desktop qty
      if(currentAction==='add'){
        addToCart();
        closeAllSheets();
      } else {
        var form=document.createElement('form');form.method='POST';form.action=CTX+'/cart/add';
        var pid=f?f.querySelector('input[name=productId]').value:'';
        form.innerHTML='<input name="_csrf" value="'+(document.querySelector('meta[name=_csrf]')||{content:''}).content+'"><input name="productId" value="'+pid+'"><input name="quantity" value="'+qty+'"><input name="action" value="buy_now">';
        document.body.appendChild(form);form.submit();
      }
    });
  }

  // Mobile action bar buttons
  var mabAdd=document.getElementById('mabAddBtn');
  var mabBuy=document.getElementById('mabBuyBtn');
  if(mabAdd){
    mabAdd.addEventListener('click',function(){
      currentAction='add';
      if(bsConfirmBtn){
        bsConfirmBtn.textContent='Thêm vào giỏ';
        bsConfirmBtn.className='bs-confirm add';
      }
      if(bsQtyInput)bsQtyInput.value='1';
      openSheet('purchaseSheet');
    });
  }
  if(mabBuy){
    mabBuy.addEventListener('click',function(){
      currentAction='buy';
      if(bsConfirmBtn){
        bsConfirmBtn.textContent='Mua ngay';
        bsConfirmBtn.className='bs-confirm buy';
      }
      if(bsQtyInput)bsQtyInput.value='1';
      openSheet('purchaseSheet');
    });
  }

})();
</script>
</body>
</html>
