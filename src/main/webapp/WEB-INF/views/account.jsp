<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tài khoản — PureNut</title>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@500;700;800&display=swap" rel="stylesheet">
    <style>
    /* ═════════════════════════════════════════════════
       PureNut — Customer Account (F&B · Organic · Rich)
       ═════════════════════════════════════════════════ */
    .acc-page{padding-top:0;padding-bottom:60px;background:linear-gradient(180deg,var(--cream) 0%,#F3EDE0 100%);min-height:100vh}
    .acc-num{font-family:'EB Garamond',var(--fd),serif;letter-spacing:-.02em}

    /* ── Banner ── */
    .acc-banner{
        background:linear-gradient(135deg,#1B4F9E 0%,#11335E 55%,#0B2547 100%);
        padding:36px 40px 62px;color:#fff;position:relative;overflow:hidden;
    }
    .acc-banner::before{content:'';position:absolute;top:-80px;right:-60px;width:280px;height:280px;background:radial-gradient(circle,rgba(206,46,46,.16) 0%,transparent 70%);border-radius:50%}
    .acc-banner::after{content:'';position:absolute;bottom:-100px;left:18%;width:380px;height:380px;background:radial-gradient(circle,rgba(255,210,122,.09) 0%,transparent 70%);border-radius:50%}
    .ban-deco{position:absolute;top:20px;right:40px;opacity:.04;font-size:120px;font-family:var(--fd);font-weight:700;color:#fff;pointer-events:none;z-index:0}
    .ban-inner{display:flex;align-items:center;gap:24px;position:relative;z-index:1}
    .ban-avatar{
        width:80px;height:80px;border-radius:50%;flex-shrink:0;
        background:linear-gradient(135deg,rgba(255,255,255,.2),rgba(255,255,255,.08));
        backdrop-filter:blur(8px);
        display:flex;align-items:center;justify-content:center;
        font-size:32px;font-weight:800;font-family:var(--fd);
        border:3px solid rgba(255,255,255,.25);box-shadow:0 10px 30px rgba(0,0,0,.25);
        position:relative;
    }
    .ban-avatar .av-dot{position:absolute;bottom:2px;right:2px;width:16px;height:16px;border-radius:50%;background:#2BAC62;border:3px solid #11335E}
    .ban-info h1{font-family:var(--fd);font-size:24px;font-weight:700;margin-bottom:2px}
    .ban-meta{display:flex;align-items:center;gap:14px;flex-wrap:wrap}
    .ban-meta span{display:inline-flex;align-items:center;gap:5px;font-size:13px;color:rgba(255,255,255,.65)}
    .ban-meta svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
    .tier-badge{
        display:inline-flex;align-items:center;gap:5px;
        padding:5px 14px;border-radius:99px;font-size:11.5px;font-weight:800;
        letter-spacing:.05em;text-transform:uppercase;
    }
    .tier-MOI{background:rgba(255,255,255,.18);color:#fff}
    .tier-BAC{background:linear-gradient(135deg,#C0C0C0,#E8E8E8);color:#333}
    .tier-VANG{background:linear-gradient(135deg,#FFD27A,#F5A524);color:#241F18;box-shadow:0 4px 14px rgba(245,165,36,.35)}
    .tier-KIM_CUONG{background:linear-gradient(135deg,#B8E6F0,#7DD3FC);color:#0B2547;box-shadow:0 4px 14px rgba(125,211,252,.35)}

    /* ── Stats ── */
    .acc-stats{
        display:grid;grid-template-columns:repeat(3,1fr);gap:14px;
        max-width:var(--container);margin:-34px auto 0;padding:0 28px;position:relative;z-index:2;
    }
    .st-card{
        background:#fff;border-radius:18px;padding:22px 20px;
        box-shadow:0 8px 28px -10px rgba(0,0,0,.1);
        display:flex;align-items:center;gap:15px;transition:transform .2s,box-shadow .2s;
        border-bottom:3px solid transparent;
    }
    .st-card:hover{transform:translateY(-3px);box-shadow:0 14px 36px -12px rgba(0,0,0,.14)}
    .st-card.c1{border-bottom-color:#1B4F9E}.st-card.c2{border-bottom-color:#F5A524}.st-card.c3{border-bottom-color:#2BAC62}.st-card.c4{border-bottom-color:#CE2E2E}
    .st-ic{width:50px;height:50px;border-radius:14px;flex-shrink:0;display:flex;align-items:center;justify-content:center}
    .st-ic svg{width:24px;height:24px;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;fill:none}
    .st-ic.c1{background:linear-gradient(135deg,rgba(27,79,158,.12),rgba(57,101,255,.08))}.st-ic.c1 svg{stroke:#1B4F9E}
    .st-ic.c2{background:linear-gradient(135deg,rgba(245,165,36,.14),rgba(255,210,122,.08))}.st-ic.c2 svg{stroke:#E8950A}
    .st-ic.c3{background:linear-gradient(135deg,rgba(43,172,98,.12),rgba(52,211,153,.06))}.st-ic.c3 svg{stroke:#2BAC62}
    .st-ic.c4{background:linear-gradient(135deg,rgba(206,46,46,.1),rgba(238,93,80,.06))}.st-ic.c4 svg{stroke:#CE2E2E}
    .st-lb{font-size:12px;color:var(--ink-soft);font-weight:600;margin-bottom:2px}
    .st-val{font-size:22px;font-weight:800;color:var(--ink);font-family:'EB Garamond',var(--fd),serif}

    /* ── Body ── */
    .acc-body{
        max-width:var(--container);margin:24px auto 0;padding:0 28px;
        display:grid;grid-template-columns:250px 1fr;gap:22px;
    }

    /* ── Sidebar ── */
    .acc-side{
        background:#fff;border-radius:20px;padding:10px;
        box-shadow:0 8px 28px -14px rgba(0,0,0,.07);align-self:start;
        position:sticky;top:80px;
    }
    .side-lbl{font-size:10px;font-weight:800;color:var(--navy);text-transform:uppercase;letter-spacing:.12em;padding:12px 14px 6px;opacity:.5}
    .side-nav{list-style:none;padding:0;margin:0}
    .side-nav li{margin-bottom:2px}
    .side-nav a,.side-nav button{
        display:flex;align-items:center;gap:12px;padding:12px 16px;width:100%;
        border-radius:14px;font-size:14px;font-weight:600;
        color:var(--ink);background:none;border:none;cursor:pointer;
        transition:all .18s;text-align:left;position:relative;
    }
    .side-nav a:hover,.side-nav button:hover{background:rgba(27,79,158,.04);color:var(--navy)}
    .side-nav a.active,.side-nav button.active{
        background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;
        box-shadow:0 8px 22px -8px rgba(27,79,158,.45);
    }
    .side-nav a.active svg,.side-nav button.active svg{stroke:#fff}
    .side-nav svg{width:19px;height:19px;stroke:var(--ink-soft);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0;transition:stroke .18s}
    .side-badge{margin-left:auto;min-width:22px;height:22px;padding:0 6px;border-radius:99px;background:var(--red);color:#fff;font-size:10px;font-weight:800;display:flex;align-items:center;justify-content:center;box-shadow:0 3px 8px rgba(206,46,46,.3)}
    .side-div{height:1px;background:linear-gradient(90deg,transparent,var(--line),transparent);margin:8px 16px}
    .side-nav a.out{color:var(--ink-soft)}.side-nav a.out:hover{background:rgba(206,46,46,.04);color:var(--red)}
    .side-nav a.out:hover svg{stroke:var(--red)}
    .side-nav a.adm{color:var(--red)}.side-nav a.adm svg{stroke:var(--red)}

    /* ── Content ── */
    .acc-content{min-width:0}
    .acc-tab{display:none}.acc-tab.show{display:block}
    .acc-card{background:#fff;border-radius:20px;padding:26px 28px;box-shadow:0 8px 28px -14px rgba(0,0,0,.07);margin-bottom:18px;border:1px solid rgba(0,0,0,.03)}
    .acc-card-h{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;padding-bottom:16px;border-bottom:1.5px solid var(--line)}
    .acc-card-t{font-family:var(--fd);font-size:18px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:9px}
    .acc-card-t svg{width:22px;height:22px;stroke:var(--navy);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .tab-link{font-size:13px;font-weight:700;color:var(--navy);display:inline-flex;align-items:center;gap:4px;transition:color .15s}
    .tab-link:hover{color:var(--red)}
    .tab-link svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}

    /* ── Promo Row ── */
    .promo-row{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:18px}
    .promo-c{border-radius:18px;padding:22px 24px;display:flex;align-items:center;gap:16px;position:relative;overflow:hidden;transition:transform .2s,box-shadow .2s;color:#fff;text-decoration:none}
    .promo-c:hover{transform:translateY(-3px);box-shadow:0 14px 36px -10px rgba(0,0,0,.2)}
    .promo-c.p1{background:linear-gradient(135deg,#1B4F9E 0%,#3965FF 100%)}
    .promo-c.p2{background:linear-gradient(135deg,#F5A524 0%,#FFD27A 100%);color:#241F18}
    .promo-c.p2 .promo-ic{background:rgba(255,255,255,.3)}
    .promo-c.p2 .promo-ic svg{stroke:#241F18; width: 28px; height: 28px}
    .promo-c::before{content:'';position:absolute;right:-30px;top:-30px;width:100px;height:100px;background:rgba(255,255,255,.08);border-radius:50%}
    .promo-c::after{content:'';position:absolute;right:20px;bottom:-20px;width:60px;height:60px;background:rgba(255,255,255,.05);border-radius:50%}
    .promo-ic{width:48px;height:48px;border-radius:14px;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;flex-shrink:0;backdrop-filter:blur(4px)}
    .promo-ic svg{width:24px;height:24px;stroke:#fff;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .promo-tt{font-weight:700;font-size:15px;margin-bottom:2px}
    .promo-ds{font-size:12.5px;opacity:.8}

    /* ── Live Tracking Banner ── */
    .track-banner{background:linear-gradient(135deg,rgba(122,90,248,.04),rgba(122,90,248,.01));border:1.5px solid rgba(122,90,248,.12);position:relative;overflow:hidden}
    .track-banner::before{content:'';position:absolute;top:-40px;right:-40px;width:120px;height:120px;background:radial-gradient(circle,rgba(122,90,248,.08) 0%,transparent 70%);border-radius:50%}
    .track-banner-inner{display:flex;align-items:center;gap:16px;position:relative;z-index:1;margin-bottom:20px}
    .track-icon{
        width:52px;height:52px;border-radius:16px;flex-shrink:0;
        background:linear-gradient(135deg,#7A5AF8,#9B7DFF);
        display:flex;align-items:center;justify-content:center;
        box-shadow:0 6px 18px -6px rgba(122,90,248,.4);
        animation:truck-bounce 2s ease-in-out infinite;
    }
    @keyframes truck-bounce{0%,100%{transform:translateX(0)}50%{transform:translateX(4px)}}
    .track-icon svg{width:24px;height:24px;stroke:#fff;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .track-title{font-size:15px;font-weight:700;color:var(--ink);margin-bottom:2px}
    .track-sub{font-size:13px;color:var(--ink-soft)}
    .track-btn{
        margin-left:auto;padding:9px 20px;border-radius:99px;font-size:13px;font-weight:700;
        background:linear-gradient(135deg,#7A5AF8,#9B7DFF);color:#fff;white-space:nowrap;
        box-shadow:0 4px 14px -4px rgba(122,90,248,.4);transition:transform .18s,box-shadow .18s;
    }
    .track-btn:hover{transform:translateY(-2px);box-shadow:0 8px 20px -6px rgba(122,90,248,.5)}
    .track-timeline{
        display:flex;align-items:center;gap:0;position:relative;z-index:1;
        padding:16px 8px 4px;border-top:1.5px solid rgba(122,90,248,.08);
    }
    .tl-step{display:flex;flex-direction:column;align-items:center;gap:6px;flex-shrink:0}
    .tl-dot{
        width:18px;height:18px;border-radius:50%;
        border:2.5px solid rgba(0,0,0,.1);background:#fff;
        transition:all .3s;position:relative;
    }
    .tl-step.done .tl-dot{background:#2BAC62;border-color:#2BAC62;box-shadow:0 2px 8px rgba(43,172,98,.3)}
    .tl-step.done .tl-dot::after{content:'';position:absolute;inset:3px;border-left:2px solid #fff;border-bottom:2px solid #fff;width:6px;height:4px;transform:rotate(-45deg);top:4px;left:4px}
    .tl-step.active .tl-dot{background:#7A5AF8;border-color:#7A5AF8;box-shadow:0 0 0 5px rgba(122,90,248,.15),0 2px 8px rgba(122,90,248,.3);animation:pulse-track 2s infinite}
    @keyframes pulse-track{0%,100%{box-shadow:0 0 0 5px rgba(122,90,248,.15),0 2px 8px rgba(122,90,248,.3)}50%{box-shadow:0 0 0 8px rgba(122,90,248,.08),0 2px 8px rgba(122,90,248,.3)}}
    .tl-label{font-size:11px;font-weight:700;color:var(--ink-soft);white-space:nowrap}
    .tl-step.done .tl-label{color:#2BAC62}
    .tl-step.active .tl-label{color:#7A5AF8;font-weight:800}
    .tl-line{flex:1;height:3px;background:rgba(0,0,0,.06);border-radius:99px;min-width:20px;margin:0 2px;margin-bottom:20px}
    .tl-line.done{background:linear-gradient(90deg,#2BAC62,#34D399)}

    /* ── Order Timeline (in orders tab) ── */
    .order-track{padding:12px 16px;background:linear-gradient(135deg,rgba(122,90,248,.03),transparent);border-radius:12px;margin-top:8px}
    .order-track .track-timeline{border-top:none;padding:8px 0 0}

    /* ── Overview Order Cards ── */
    .ov-order-card{
        border:1.5px solid var(--line);border-radius:16px;padding:18px 20px;margin-bottom:12px;
        transition:all .2s;background:#fff;
    }
    .ov-order-card:last-child{margin-bottom:0}
    .ov-order-card:hover{border-color:rgba(27,79,158,.15);box-shadow:0 6px 20px -8px rgba(0,0,0,.08)}
    .ov-order-card.ov-shipping{border-color:rgba(122,90,248,.2);background:linear-gradient(135deg,rgba(122,90,248,.02),transparent)}
    .ov-order-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px}
    .ov-order-id{display:flex;align-items:center;gap:8px;font-size:14.5px;color:var(--ink)}
    .ov-order-id svg{width:20px;height:20px;stroke:var(--navy);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
    .ov-order-id .ov-truck{stroke:#7A5AF8;animation:truck-bounce 2s ease-in-out infinite}
    .ov-order-detail{display:flex;align-items:center;justify-content:space-between;font-size:13.5px;color:var(--ink-soft);padding-bottom:4px}
    .ov-order-card .order-track{margin-top:4px}

    /* ── Order Cards — 3-column grid ── */
    .o-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}

    .o-card{
        border:1.5px solid var(--line);border-radius:18px;
        background:#fff;cursor:pointer;position:relative;overflow:visible;
        transition:transform .35s cubic-bezier(.4,0,.2,1),box-shadow .35s,border-color .3s;
        transform-style:preserve-3d;
    }
    .o-card::before{
        content:'';position:absolute;inset:0;border-radius:inherit;
        background:linear-gradient(135deg,rgba(27,79,158,.04),rgba(122,90,248,.03));
        opacity:0;transition:opacity .3s;pointer-events:none;z-index:0;
    }
    .o-card:hover{
        transform:translateY(-6px) rotateX(2deg);
        box-shadow:0 20px 44px -14px rgba(0,0,0,.14),0 6px 16px -6px rgba(27,79,158,.1);
        border-color:rgba(27,79,158,.18);z-index:10;
    }
    .o-card:hover::before{opacity:1}

    .o-card-body{padding:18px 18px 14px;position:relative;z-index:1}

    .o-card-icon{
        width:46px;height:46px;border-radius:14px;margin:0 auto 12px;
        display:flex;align-items:center;justify-content:center;
        transition:transform .4s cubic-bezier(.4,0,.2,1),box-shadow .3s;
    }
    .o-card:hover .o-card-icon{transform:scale(1.12) rotateY(12deg);box-shadow:0 6px 18px -6px rgba(0,0,0,.2)}
    .o-card-icon svg{width:22px;height:22px;stroke:#fff;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .o-card-icon.ic-pending{background:linear-gradient(135deg,#F5A524,#FFD27A)}
    .o-card-icon.ic-confirmed{background:linear-gradient(135deg,#3965FF,#6B8AFF)}
    .o-card-icon.ic-shipping{background:linear-gradient(135deg,#7A5AF8,#9B7DFF);animation:truck-bounce 2s ease-in-out infinite}
    .o-card-icon.ic-done{background:linear-gradient(135deg,#12B76A,#34D399)}
    .o-card-icon.ic-cancelled{background:linear-gradient(135deg,#CE2E2E,#EE5D50)}
    .o-card-icon.ic-pending_cancel{background:linear-gradient(135deg,#EAB308,#FCD34D)}

    .o-card-id{font-family:'EB Garamond',var(--fd),serif;font-size:17px;font-weight:800;color:var(--navy);text-align:center;margin-bottom:4px}
    .o-card-price{font-family:'EB Garamond',var(--fd),serif;font-size:20px;font-weight:800;color:var(--ink);text-align:center;margin-bottom:8px}
    .o-card-date{font-size:11.5px;color:var(--ink-soft);text-align:center;margin-bottom:10px}
    .o-card-pill{text-align:center}

    /* hover tooltip dropdown */
    .o-card-hover{
        position:absolute;top:calc(100% + 8px);left:50%;z-index:30;
        width:max-content;min-width:180px;max-width:240px;
        transform:translateX(-50%) translateY(-6px);
        background:#fff;border:1.5px solid rgba(27,79,158,.14);
        border-radius:14px;padding:12px 16px 14px;
        box-shadow:0 12px 32px -8px rgba(0,0,0,.15);
        opacity:0;visibility:hidden;
        transition:opacity .22s cubic-bezier(.4,0,.2,1),visibility .22s,transform .22s cubic-bezier(.4,0,.2,1);
        pointer-events:none;
    }
    .o-card-hover::before{
        content:'';position:absolute;bottom:100%;left:50%;transform:translateX(-50%);
        border:7px solid transparent;border-bottom-color:#fff;
        filter:drop-shadow(0 -2px 2px rgba(0,0,0,.06));
    }
    .o-card:hover .o-card-hover{opacity:1;visibility:visible;transform:translateX(-50%) translateY(0);pointer-events:auto}
    .o-card-hover-row{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--ink-soft);margin-bottom:6px}
    .o-card-hover-row:last-child{margin-bottom:0}
    .o-card-hover-row svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
    .o-card-hover-row strong{color:var(--ink);font-weight:600}
    .o-card-hover-cta{display:flex;align-items:center;justify-content:center;gap:5px;margin-top:8px;padding:7px 0;border-top:1px solid rgba(0,0,0,.05);font-size:11.5px;font-weight:700;color:var(--navy)}
    .o-card-hover-cta svg{width:12px;height:12px;stroke:var(--navy);fill:none;stroke-width:2.5;stroke-linecap:round;stroke-linejoin:round}

    /* detail overlay (click) */
    .o-detail-overlay{
        display:none;position:fixed;inset:0;z-index:9000;
        background:rgba(11,37,71,.45);backdrop-filter:blur(6px);
        align-items:center;justify-content:center;
    }
    .o-detail-overlay.open{display:flex}
    .o-detail-panel{
        background:#fff;border-radius:22px;width:92%;max-width:520px;padding:28px 28px 22px;
        box-shadow:0 28px 72px -16px rgba(0,0,0,.3);
        animation:ovSlide .28s cubic-bezier(.4,0,.2,1);
        position:relative;
    }
    .o-detail-close{
        position:absolute;top:14px;right:14px;width:34px;height:34px;border-radius:50%;
        border:none;background:rgba(0,0,0,.04);display:flex;align-items:center;justify-content:center;
        cursor:pointer;font-size:18px;color:var(--ink-soft);transition:all .15s;
    }
    .o-detail-close:hover{background:rgba(206,46,46,.08);color:var(--red)}
    .o-detail-header{text-align:center;margin-bottom:20px}
    .o-detail-header .o-card-icon{margin:0 auto 10px}
    .o-detail-header h3{font-family:'EB Garamond',var(--fd),serif;font-size:20px;font-weight:800;color:var(--navy);margin-bottom:4px}
    .o-detail-header .o-detail-meta{font-size:13px;color:var(--ink-soft)}
    .o-detail-info{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px;padding:16px;background:rgba(27,79,158,.02);border-radius:14px}
    .o-detail-info-item{font-size:13px}
    .o-detail-info-item .di-label{font-size:10.5px;font-weight:700;color:var(--ink-soft);text-transform:uppercase;letter-spacing:.04em;margin-bottom:2px}
    .o-detail-info-item .di-val{font-weight:700;color:var(--ink)}
    .o-detail-timeline{padding:0 8px}
    .o-detail-timeline .track-timeline{border-top:none;padding:0}

    /* ── Shipping 3D Box Animation ── */
    .ship-anim{text-align:center;padding:18px 0 8px;display:none}
    .ship-anim.show{display:block}
    .ship-anim-text{font-family:'EB Garamond',var(--fd),serif;font-size:16px;font-weight:700;color:#7A5AF8;margin-top:16px;position:relative;z-index:10}
    .ship-anim-sub{font-size:11.5px;color:var(--ink-soft);margin-top:4px;position:relative;z-index:10}
    .ship-dots::after{content:'';animation:ship-d 1.4s infinite steps(4)}
    @keyframes ship-d{0%{content:''}25%{content:'.'}50%{content:'..'}75%{content:'...'}}
    .mini-loader{--duration:3s;--primary:#7A5AF8;--primary-light:#9B7DFF;--primary-rgba:rgba(122,90,248,0);width:120px;height:192px;position:relative;transform-style:preserve-3d;margin:0 auto;zoom:.5}
    .mini-loader:before,.mini-loader:after{--r:20.5deg;content:"";width:320px;height:140px;position:absolute;right:32%;bottom:-11px;background:#fff;transform:translateZ(200px) rotate(var(--r));animation:ml-mask var(--duration) linear forwards infinite;pointer-events:none}
    .mini-loader:after{--r:-20.5deg;right:auto;left:32%}
    .mini-loader .ml-ground{position:absolute;left:-50px;bottom:-120px;transform-style:preserve-3d;transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}
    .mini-loader .ml-ground div{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(0);width:200px;height:200px;background:var(--primary);background:linear-gradient(45deg,var(--primary) 0%,var(--primary) 50%,var(--primary-light) 50%,var(--primary-light) 100%);transform-style:preserve-3d;animation:ml-ground var(--duration) linear forwards infinite}
    .mini-loader .ml-ground div:before,.mini-loader .ml-ground div:after{--rx:90deg;--ry:0deg;--x:44px;--y:162px;--z:-50px;content:"";width:156px;height:300px;opacity:0;background:linear-gradient(var(--primary),var(--primary-rgba));position:absolute;transform:rotateX(var(--rx)) rotateY(var(--ry)) translate(var(--x),var(--y)) translateZ(var(--z));animation:ml-gs var(--duration) linear forwards infinite}
    .mini-loader .ml-ground div:after{--rx:90deg;--ry:90deg;--x:0;--y:177px;--z:150px}
    .mini-loader .ml-box{--x:0;--y:0;position:absolute;animation:var(--duration) linear forwards infinite;transform:translate(var(--x),var(--y))}
    .mini-loader .ml-box div{background-color:var(--primary);width:48px;height:48px;position:relative;transform-style:preserve-3d;animation:var(--duration) ease forwards infinite;transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}
    .mini-loader .ml-box div:before,.mini-loader .ml-box div:after{--rx:90deg;--ry:0deg;--z:24px;--y:-24px;--x:0;content:"";position:absolute;background-color:inherit;width:inherit;height:inherit;transform:rotateX(var(--rx)) rotateY(var(--ry)) translate(var(--x),var(--y)) translateZ(var(--z));filter:brightness(var(--b,1.2))}
    .mini-loader .ml-box div:after{--rx:0deg;--ry:90deg;--x:24px;--y:0;--b:1.4}
    .mini-loader .ml-b0{--x:-220px;--y:-120px;left:58px;top:108px;animation-name:ml-m0}.mini-loader .ml-b0 div{animation-name:ml-s0}
    .mini-loader .ml-b1{--x:-260px;--y:120px;left:25px;top:120px;animation-name:ml-m1}.mini-loader .ml-b1 div{animation-name:ml-s1}
    .mini-loader .ml-b2{--x:120px;--y:-190px;left:58px;top:64px;animation-name:ml-m2}.mini-loader .ml-b2 div{animation-name:ml-s2}
    .mini-loader .ml-b3{--x:280px;--y:-40px;left:91px;top:120px;animation-name:ml-m3}.mini-loader .ml-b3 div{animation-name:ml-s3}
    .mini-loader .ml-b4{--x:60px;--y:200px;left:58px;top:132px;animation-name:ml-m4}.mini-loader .ml-b4 div{animation-name:ml-s4}
    .mini-loader .ml-b5{--x:-220px;--y:-120px;left:25px;top:76px;animation-name:ml-m5}.mini-loader .ml-b5 div{animation-name:ml-s5}
    .mini-loader .ml-b6{--x:-260px;--y:120px;left:91px;top:76px;animation-name:ml-m6}.mini-loader .ml-b6 div{animation-name:ml-s6}
    .mini-loader .ml-b7{--x:-240px;--y:200px;left:58px;top:87px;animation-name:ml-m7}.mini-loader .ml-b7 div{animation-name:ml-s7}
    @keyframes ml-m0{12%{transform:translate(var(--x),var(--y))}25%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s0{6%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}14%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m1{16%{transform:translate(var(--x),var(--y))}29%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s1{10%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}18%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m2{20%{transform:translate(var(--x),var(--y))}33%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s2{14%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}22%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m3{24%{transform:translate(var(--x),var(--y))}37%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s3{18%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}26%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m4{28%{transform:translate(var(--x),var(--y))}41%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s4{22%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}30%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m5{32%{transform:translate(var(--x),var(--y))}45%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s5{26%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}34%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m6{36%{transform:translate(var(--x),var(--y))}49%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s6{30%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}38%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-m7{40%{transform:translate(var(--x),var(--y))}53%,52%{transform:translate(0,0)}80%{transform:translate(0,-32px)}90%,100%{transform:translate(0,188px)}}
    @keyframes ml-s7{34%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0)}42%,100%{transform:rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1)}}
    @keyframes ml-ground{0%,65%{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(0)}75%,90%{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(1)}100%{transform:rotateX(90deg) rotateY(0deg) translate(-48px,-120px) translateZ(100px) scale(0)}}
    @keyframes ml-gs{0%,70%{opacity:0}75%,87%{opacity:.2}100%{opacity:0}}
    @keyframes ml-mask{0%,65%{opacity:0}66%,100%{opacity:1}}

    @media(max-width:900px){.o-cards{grid-template-columns:repeat(2,1fr)}}
    @media(max-width:560px){.o-cards{grid-template-columns:1fr;gap:12px}}
    .s-pill{display:inline-flex;align-items:center;gap:5px;padding:5px 13px;border-radius:99px;font-size:11.5px;font-weight:700}
    .s-pill .s-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0}
    .s-PENDING{background:rgba(245,165,36,.1);color:#D48806}.s-PENDING .s-dot{background:#D48806}
    .s-CONFIRMED{background:rgba(57,101,255,.1);color:#3965FF}.s-CONFIRMED .s-dot{background:#3965FF}
    .s-SHIPPING{background:rgba(122,90,248,.1);color:#7A5AF8}.s-SHIPPING .s-dot{background:#7A5AF8}
    .s-DONE{background:rgba(43,172,98,.1);color:#12B76A}.s-DONE .s-dot{background:#12B76A}
    .s-CANCELLED{background:rgba(206,46,46,.1);color:#CE2E2E}.s-CANCELLED .s-dot{background:#CE2E2E}
    .s-PENDING_CANCEL{background:rgba(234,179,8,.12);color:#B45309}.s-PENDING_CANCEL .s-dot{background:#EAB308}

    /* ── Cancel Section ── */
    .cancel-section{text-align:center;margin-top:18px;padding-top:16px;border-top:1px dashed rgba(0,0,0,.08)}
    .cancel-btn{
        display:inline-flex;align-items:center;gap:7px;
        padding:10px 28px;border-radius:12px;font-size:13.5px;font-weight:700;
        color:#CE2E2E;background:transparent;border:1.5px solid #CE2E2E;
        cursor:pointer;transition:all .2s
    }
    .cancel-btn:hover{background:#CE2E2E;color:#fff}
    .cancel-btn svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
    .pending-cancel-notice{
        text-align:center;margin-top:18px;padding:14px 18px;
        border-radius:12px;background:rgba(234,179,8,.08);
        border:1px solid rgba(234,179,8,.2);font-size:13px;color:#92400E
    }

    /* ── Rate / Confirm Receipt Section ── */
    .rate-section{text-align:center;margin-top:18px;padding-top:16px;border-top:1px dashed rgba(0,0,0,.08)}
    .rate-btn{
        display:inline-flex;align-items:center;gap:7px;
        padding:11px 30px;border-radius:12px;font-size:13.5px;font-weight:700;
        color:#fff;background:#12B76A;border:1.5px solid #12B76A;
        cursor:pointer;transition:all .2s
    }
    .rate-btn:hover{background:#0D9C5A}
    .rate-btn svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
    .rate-done{
        text-align:center;padding:14px 18px;border-radius:12px;
        background:rgba(43,172,98,.07);border:1px solid rgba(43,172,98,.18);
    }
    .rate-done-title{font-size:12.5px;font-weight:700;color:#0D9C5A;display:flex;align-items:center;justify-content:center;gap:6px;margin-bottom:8px}
    .rate-done-title svg{width:15px;height:15px}
    .rate-stars-view{display:flex;align-items:center;justify-content:center;gap:3px;margin-bottom:6px}
    .rate-stars-view svg{width:20px;height:20px}
    .rate-stars-view svg.on{fill:#F2B705;stroke:#F2B705}
    .rate-stars-view svg.off{fill:none;stroke:rgba(0,0,0,.18)}
    .rate-done-review{font-size:12.5px;color:var(--ink-soft);font-style:italic;max-width:340px;margin:0 auto}

    /* ── Awaiting Confirmation Widget (Overview tab) ── */
    .awaiting-card{background:linear-gradient(135deg,#FFFBEB,#FFF7ED);border:1.5px solid rgba(217,119,6,.25);box-shadow:0 8px 28px -14px rgba(217,119,6,.2)}
    .awaiting-card .acc-card-h{border-bottom-color:rgba(217,119,6,.2)}
    .awaiting-card .acc-card-t{color:#B45309}
    .awaiting-card .acc-card-t svg{stroke:#D97706}
    .awaiting-note{font-size:13px;color:#92400E;margin:-10px 0 16px;line-height:1.5}
    .awaiting-count-badge{min-width:26px;height:26px;padding:0 8px;border-radius:99px;background:#D97706;color:#fff;font-size:12.5px;font-weight:800;display:flex;align-items:center;justify-content:center;box-shadow:0 3px 8px rgba(217,119,6,.3)}
    .s-AWAITING{background:rgba(217,119,6,.12);color:#D97706}.s-AWAITING .s-dot{background:#D97706;animation:pulseDot 1.6s infinite}
    @keyframes pulseDot{0%,100%{opacity:1}50%{opacity:.3}}

    /* ── Rate Modal (đánh giá + xác nhận đã nhận hàng) ── */
    .rate-modal{
        position:fixed;top:0;left:0;width:100%;height:100%;z-index:9999;
        display:none;align-items:center;justify-content:center;
        background:rgba(0,0,0,.45);backdrop-filter:blur(4px);
        opacity:0;transition:opacity .25s
    }
    .rate-modal.open{display:flex;opacity:1}
    .rate-modal .cm-panel{transform:translateY(20px);transition:transform .3s}
    .rate-modal.open .cm-panel{transform:translateY(0)}
    .rm-stars{display:flex;align-items:center;justify-content:center;gap:8px;margin:6px 0 4px}
    .rm-star{background:none;border:none;cursor:pointer;padding:4px}
    .rm-star svg{width:34px;height:34px;fill:none;stroke:rgba(0,0,0,.2);stroke-width:1.6;transition:all .15s}
    .rm-star.on svg{fill:#F2B705;stroke:#F2B705;transform:scale(1.05)}
    .rm-star-label{text-align:center;font-size:12.5px;font-weight:600;color:var(--ink-soft);min-height:18px;margin-bottom:14px}
    .rm-skip{text-align:center;margin-top:10px}
    .rm-skip button{background:none;border:none;color:var(--ink-soft);font-size:12.5px;font-weight:600;text-decoration:underline;cursor:pointer}

    /* ── Cancel Modal ── */
    .cancel-modal{
        position:fixed;top:0;left:0;width:100%;height:100%;z-index:9999;
        display:none;align-items:center;justify-content:center;
        background:rgba(0,0,0,.45);backdrop-filter:blur(4px);
        opacity:0;transition:opacity .25s
    }
    .cancel-modal.open{display:flex;opacity:1}
    .cm-panel{
        background:#fff;border-radius:20px;padding:32px;width:92%;max-width:420px;
        box-shadow:0 24px 64px rgba(0,0,0,.18);position:relative;
        transform:translateY(20px);transition:transform .3s
    }
    .cancel-modal.open .cm-panel{transform:translateY(0)}
    .cm-close{position:absolute;top:14px;right:14px;width:32px;height:32px;border:none;background:var(--cream);border-radius:50%;cursor:pointer;font-size:18px;color:var(--ink-soft);display:flex;align-items:center;justify-content:center}
    .cm-title{font-family:var(--fd);font-size:20px;font-weight:700;color:var(--navy);margin-bottom:4px}
    .cm-sub{font-size:13px;color:var(--ink-soft);margin-bottom:18px}
    .cm-reasons label{
        display:flex;align-items:center;gap:10px;
        padding:11px 14px;border-radius:10px;margin-bottom:8px;
        cursor:pointer;font-size:13.5px;color:var(--ink);
        border:1.5px solid rgba(0,0,0,.06);transition:all .15s
    }
    .cm-reasons label:hover{border-color:var(--navy);background:rgba(27,79,158,.03)}
    .cm-reasons input[type=radio]{accent-color:var(--navy);width:16px;height:16px;flex-shrink:0}
    .cm-reasons input[type=radio]:checked + span{font-weight:600}
    .cm-other{display:none;margin-top:4px}
    .cm-other textarea{
        width:100%;min-height:70px;resize:vertical;border:1.5px solid rgba(0,0,0,.1);
        border-radius:10px;padding:10px 12px;font-size:13px;font-family:inherit;
        outline:none;transition:border-color .2s
    }
    .cm-other textarea:focus{border-color:var(--navy)}
    .cm-actions{display:flex;gap:10px;margin-top:18px}
    .cm-actions button{flex:1;padding:11px;border-radius:12px;font-size:13.5px;font-weight:700;cursor:pointer;border:none;transition:all .2s}
    .cm-cancel-back{background:var(--cream);color:var(--ink)}
    .cm-cancel-confirm{background:#CE2E2E;color:#fff}
    .cm-cancel-confirm:disabled{opacity:.5;cursor:not-allowed}
    .cm-msg{text-align:center;padding:12px;border-radius:10px;font-size:13px;margin-top:12px;display:none}
    .cm-msg.success{display:block;background:rgba(43,172,98,.1);color:#12B76A}
    .cm-msg.error{display:block;background:rgba(206,46,46,.1);color:#CE2E2E}

    /* ── Taste Profile ── */
    .taste-section{margin-bottom:22px}
    .taste-label{font-size:13.5px;font-weight:700;color:var(--ink);margin-bottom:10px;display:flex;align-items:center;gap:9px}
    .taste-label svg{width:20px;height:20px;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .taste-label .tl-blue svg{stroke:var(--navy)}
    .taste-label .tl-gold svg{stroke:#F5A524}
    .taste-label .tl-red svg{stroke:var(--red)}
    .sweet-bar{display:flex;gap:6px}
    .sweet-bar button{
        flex:1;padding:12px 0;border-radius:12px;border:1.5px solid var(--line);
        background:#fff;font-size:13.5px;font-weight:700;color:var(--ink-soft);cursor:pointer;
        transition:all .18s;
    }
    .sweet-bar button:hover{border-color:var(--navy);color:var(--navy);background:rgba(27,79,158,.02)}
    .sweet-bar button.sel{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;border-color:#1B4F9E;box-shadow:0 4px 14px -4px rgba(27,79,158,.4)}
    .chip-grid{display:flex;flex-wrap:wrap;gap:8px}
    .chip{
        padding:9px 18px;border-radius:99px;border:1.5px solid var(--line);
        background:#fff;font-size:13.5px;font-weight:600;color:var(--ink);cursor:pointer;
        transition:all .18s;display:inline-flex;align-items:center;gap:6px;
    }
    .chip:hover{border-color:var(--navy);color:var(--navy);background:rgba(27,79,158,.02)}
    .chip.sel{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;border-color:#1B4F9E;box-shadow:0 4px 12px -4px rgba(27,79,158,.35)}
    .chip.allergy.sel{background:linear-gradient(135deg,#CE2E2E,#EE5D50);color:#fff;border-color:#CE2E2E;box-shadow:0 4px 12px -4px rgba(206,46,46,.35)}
    .chip.disabled{opacity:.35;cursor:not-allowed;pointer-events:none;border-style:dashed;text-decoration:line-through}
    .taste-save{
        margin-top:20px;padding:12px 30px;border-radius:99px;
        background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;
        font-size:14.5px;font-weight:700;border:none;cursor:pointer;
        box-shadow:0 8px 22px -8px rgba(27,79,158,.45);transition:transform .2s,box-shadow .2s;
    }
    .taste-save:hover{transform:translateY(-2px);box-shadow:0 12px 28px -8px rgba(27,79,158,.5)}
    .taste-saved{display:inline-flex;align-items:center;gap:6px;color:#2BAC62;font-size:13.5px;font-weight:700;margin-left:14px;opacity:0;transition:opacity .3s}
    .taste-saved.show{opacity:1}
    .taste-saved svg{width:16px;height:16px;stroke:#2BAC62;fill:none;stroke-width:2.5;stroke-linecap:round}

    /* ── Empty State ── */
    .acc-empty{text-align:center;padding:44px 20px}
    .acc-empty-ic{width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--cream),#F3EDE0);margin:0 auto 18px;display:flex;align-items:center;justify-content:center;border:1.5px solid var(--line)}
    .acc-empty-ic svg{width:34px;height:34px;stroke:var(--ink-soft);fill:none;stroke-width:1.5;stroke-linecap:round;stroke-linejoin:round;opacity:.4}
    .acc-empty p{color:var(--ink-soft);font-size:15px;margin-bottom:18px}

    /* ═══════════════
       OVERLAY
       ═══════════════ */
    .ov-backdrop{
        display:none;position:fixed;inset:0;z-index:9000;
        background:rgba(11,37,71,.5);backdrop-filter:blur(8px);
        align-items:center;justify-content:center;
    }
    .ov-backdrop.open{display:flex}
    .ov-panel{
        background:#fff;border-radius:24px;width:94%;max-width:660px;
        max-height:88vh;overflow:hidden;display:flex;flex-direction:column;
        box-shadow:0 28px 72px -16px rgba(0,0,0,.35);animation:ovSlide .28s cubic-bezier(.4,0,.2,1);
    }
    @keyframes ovSlide{from{opacity:0;transform:translateY(24px) scale(.97)}to{opacity:1;transform:none}}
    .ov-header{
        padding:22px 28px;border-bottom:1.5px solid var(--line);display:flex;align-items:center;justify-content:space-between;
        background:linear-gradient(135deg,#FDFBF7,#FBF6EC);
    }
    .ov-tabs{display:flex;gap:6px}
    .ov-tab{
        padding:10px 20px;border-radius:99px;font-size:14px;font-weight:700;
        border:none;background:none;color:var(--ink-soft);cursor:pointer;transition:all .18s;
    }
    .ov-tab:hover{background:rgba(27,79,158,.06);color:var(--navy)}
    .ov-tab.active{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;box-shadow:0 4px 14px -4px rgba(27,79,158,.4)}
    .ov-close{
        width:40px;height:40px;border-radius:50%;border:none;background:rgba(0,0,0,.04);
        display:flex;align-items:center;justify-content:center;cursor:pointer;
        color:var(--ink);font-size:20px;transition:all .15s;
    }
    .ov-close:hover{background:rgba(206,46,46,.08);color:var(--red)}
    .ov-body{padding:26px 28px;overflow-y:auto;flex:1}
    .ov-pane{display:none}.ov-pane.show{display:block}
    .ov-field{margin-bottom:18px}
    .ov-label{display:block;font-size:11.5px;font-weight:800;color:var(--navy);text-transform:uppercase;letter-spacing:.05em;margin-bottom:7px;opacity:.6}
    .ov-input{
        width:100%;padding:13px 18px;border:1.5px solid var(--line);border-radius:14px;
        font-size:15px;color:var(--ink);background:#fff;transition:all .2s;
    }
    .ov-input:focus{border-color:var(--navy);outline:none;box-shadow:0 0 0 4px rgba(27,79,158,.08)}
    .ov-input:read-only{background:linear-gradient(135deg,#FDFBF7,#FBF6EC);color:var(--ink-soft);border-color:rgba(233,220,190,.5)}
    select.ov-input{cursor:pointer;appearance:auto}
    .ov-btn{
        padding:13px 30px;border-radius:99px;font-size:15px;font-weight:700;
        border:none;cursor:pointer;transition:transform .18s,box-shadow .18s;
    }
    .ov-btn.primary{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;box-shadow:0 8px 22px -8px rgba(27,79,158,.45)}
    .ov-btn.primary:hover{transform:translateY(-2px);box-shadow:0 12px 28px -8px rgba(27,79,158,.5)}
    .ov-msg{padding:12px 18px;border-radius:12px;font-size:13.5px;font-weight:600;margin-bottom:16px;display:none;align-items:center;gap:8px}
    .ov-msg.err{display:flex;background:rgba(206,46,46,.06);color:var(--red);border:1px solid rgba(206,46,46,.1)}
    .ov-msg.ok{display:flex;background:rgba(43,172,98,.06);color:#2BAC62;border:1px solid rgba(43,172,98,.1)}

    /* Avatar section */
    .ov-avatar-section{display:flex;flex-direction:column;align-items:center;margin-bottom:24px;padding-bottom:22px;border-bottom:1.5px solid var(--line)}
    .ov-avatar-wrap{
        position:relative;cursor:pointer;width:96px;height:96px;border-radius:50%;
        transition:transform .2s;
    }
    .ov-avatar-wrap:hover{transform:scale(1.05)}
    .ov-avatar{
        width:96px;height:96px;border-radius:50%;overflow:hidden;
        background:linear-gradient(135deg,#1B4F9E,#2A5FB8);
        display:flex;align-items:center;justify-content:center;
        box-shadow:0 8px 28px -8px rgba(27,79,158,.4);
        border:3.5px solid #fff;
    }
    .ov-avatar img{width:100%;height:100%;object-fit:cover}
    .ov-avatar-initial{
        font-family:var(--fd);font-size:38px;font-weight:700;color:#fff;
        text-transform:uppercase;user-select:none;
    }
    .ov-avatar-cam{
        position:absolute;bottom:0;right:0;
        width:32px;height:32px;border-radius:50%;
        background:linear-gradient(135deg,var(--navy),var(--navy-dark));
        display:flex;align-items:center;justify-content:center;
        border:2.5px solid #fff;
        box-shadow:0 3px 10px rgba(0,0,0,.2);
        transition:transform .2s;
    }
    .ov-avatar-wrap:hover .ov-avatar-cam{transform:scale(1.1)}
    .ov-avatar-cam svg{width:15px;height:15px;stroke:#fff;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .ov-avatar-hint{font-size:12px;color:var(--ink-soft);margin-top:10px;font-weight:500}

    /* Address cards */
    .addr-card{padding:18px 20px;background:linear-gradient(135deg,#FDFBF7,#FBF6EC);border-radius:16px;margin-bottom:10px;position:relative;border:1px solid rgba(233,220,190,.4);transition:border-color .15s}
    .addr-card:hover{border-color:var(--navy)}
    .addr-card .addr-label{font-size:11px;font-weight:800;color:var(--navy);text-transform:uppercase;letter-spacing:.06em;margin-bottom:4px;display:flex;align-items:center;gap:6px}
    .addr-card .def-badge{font-size:10px;background:linear-gradient(135deg,#2BAC62,#34D399);color:#fff;padding:2px 9px;border-radius:99px;font-weight:700}
    .addr-card .addr-name{font-size:14.5px;font-weight:600;color:var(--ink);margin-bottom:2px}
    .addr-card .addr-detail{font-size:13px;color:var(--ink-soft);line-height:1.45}
    .addr-card .addr-actions{position:absolute;top:16px;right:16px;display:flex;gap:6px}
    .addr-card .addr-actions button{
        width:32px;height:32px;border-radius:10px;border:none;
        background:rgba(0,0,0,.04);display:flex;align-items:center;justify-content:center;
        cursor:pointer;transition:all .15s;
    }
    .addr-card .addr-actions button:hover{background:rgba(206,46,46,.1);color:var(--red)}
    .addr-card .addr-actions button svg{width:15px;height:15px;stroke:var(--ink-soft);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
    .addr-add-form{border:2px dashed rgba(27,79,158,.15);border-radius:16px;padding:22px;margin-top:12px;background:rgba(27,79,158,.01)}
    .addr-add-form .form-title{font-size:15px;font-weight:700;color:var(--navy);margin-bottom:16px;display:flex;align-items:center;gap:8px}
    .addr-row{display:grid;grid-template-columns:1fr 1fr;gap:14px}

    /* Security info box */
    .sec-info{
        padding:18px 22px;border-radius:16px;display:flex;align-items:center;gap:14px;margin-bottom:22px;
        background:linear-gradient(135deg,rgba(43,172,98,.06),rgba(43,172,98,.02));
        border:1.5px solid rgba(43,172,98,.12);
    }
    .sec-info svg{width:24px;height:24px;stroke:#2BAC62;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
    .sec-info p{font-size:14px;color:var(--ink);line-height:1.5}
    .sec-info strong{color:var(--navy);font-weight:700}

    /* ── Crop Modal ── */
    .crop-modal{position:fixed;inset:0;z-index:10000;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,.6);backdrop-filter:blur(6px)}
    .crop-modal.open{display:flex}
    .crop-panel{background:#fff;border-radius:22px;width:94%;max-width:460px;padding:0;overflow:hidden;box-shadow:0 28px 72px rgba(0,0,0,.3);animation:ovSlide .28s cubic-bezier(.4,0,.2,1)}
    .crop-header{padding:18px 24px;display:flex;align-items:center;justify-content:space-between;border-bottom:1.5px solid var(--line);background:linear-gradient(135deg,#FDFBF7,#FBF6EC)}
    .crop-header h3{font-family:var(--fd);font-size:17px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:8px}
    .crop-header h3 svg{width:20px;height:20px;stroke:var(--navy);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .crop-close{width:34px;height:34px;border-radius:50%;border:none;background:rgba(0,0,0,.04);display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:18px;color:var(--ink-soft);transition:all .15s}
    .crop-close:hover{background:rgba(206,46,46,.08);color:var(--red)}
    .crop-area{position:relative;width:100%;aspect-ratio:1;background:#111;overflow:hidden;cursor:grab;touch-action:none}
    .crop-area:active{cursor:grabbing}
    .crop-area img{position:absolute;transform-origin:0 0;pointer-events:none;max-width:none}
    .crop-circle{position:absolute;top:50%;left:50%;width:70%;aspect-ratio:1;transform:translate(-50%,-50%);border-radius:50%;box-shadow:0 0 0 9999px rgba(0,0,0,.55);pointer-events:none;border:2px solid rgba(255,255,255,.5)}
    .crop-controls{padding:16px 24px;display:flex;align-items:center;gap:12px}
    .crop-controls svg{width:16px;height:16px;stroke:var(--ink-soft);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
    .crop-slider{flex:1;-webkit-appearance:none;appearance:none;height:4px;background:var(--line);border-radius:99px;outline:none}
    .crop-slider::-webkit-slider-thumb{-webkit-appearance:none;width:18px;height:18px;border-radius:50%;background:linear-gradient(135deg,#1B4F9E,#2A5FB8);cursor:pointer;box-shadow:0 2px 8px rgba(27,79,158,.3)}
    .crop-slider::-moz-range-thumb{width:18px;height:18px;border-radius:50%;background:linear-gradient(135deg,#1B4F9E,#2A5FB8);cursor:pointer;border:none}
    .crop-actions{padding:0 24px 20px;display:flex;gap:10px}
    .crop-actions button{flex:1;padding:12px;border-radius:14px;font-size:14px;font-weight:700;cursor:pointer;border:none;transition:all .2s}
    .crop-cancel{background:var(--cream);color:var(--ink)}
    .crop-cancel:hover{background:rgba(0,0,0,.06)}
    .crop-save{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;box-shadow:0 6px 18px -6px rgba(27,79,158,.4)}
    .crop-save:hover{transform:translateY(-1px);box-shadow:0 8px 22px -6px rgba(27,79,158,.5)}
    .crop-save:disabled{opacity:.5;cursor:not-allowed;transform:none}

    /* ── Mobile strip ── */
    .mob-strip{display:none;gap:8px;overflow-x:auto;padding:0 16px 8px;margin:14px auto 0;max-width:var(--container);-webkit-overflow-scrolling:touch;scrollbar-width:none}
    .mob-strip::-webkit-scrollbar{display:none}
    .mob-btn{
        flex-shrink:0;display:inline-flex;align-items:center;gap:7px;
        padding:10px 16px;border-radius:99px;background:#fff;border:1.5px solid var(--line);
        font-size:12.5px;font-weight:600;color:var(--ink);white-space:nowrap;cursor:pointer;transition:all .15s;
        text-decoration:none;
    }
    .mob-btn svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .mob-btn.active{background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;border-color:#1B4F9E;box-shadow:0 4px 14px -4px rgba(27,79,158,.4)}

    @media(max-width:900px){
        .acc-stats{grid-template-columns:repeat(3,1fr);margin-top:-24px}
        .acc-body{grid-template-columns:1fr}
        .acc-side{display:none}
        .mob-strip{display:flex}
        .acc-banner{padding:28px 22px 52px}
        .promo-row{grid-template-columns:1fr}
        .addr-row{grid-template-columns:1fr}
        .track-banner-inner{flex-wrap:wrap}.track-btn{margin-left:0;margin-top:8px;width:100%;text-align:center}
        .track-timeline{overflow-x:auto;padding-bottom:8px}
        .ov-panel{width:100%;max-width:100%;border-radius:20px 20px 0 0;max-height:92vh;margin-top:auto}
        .ov-header{padding:16px 18px}
        .ov-tab{padding:8px 14px;font-size:13px}
        .ov-body{padding:20px 18px}
        .ov-input{padding:12px 14px;font-size:14px;border-radius:12px}
        .ov-btn{padding:12px 24px;font-size:14px;width:100%}
        .ov-avatar-wrap{width:76px;height:76px}
        .ov-avatar-section{margin-bottom:18px;padding-bottom:16px}
    }
    @media(max-width:560px){
        .acc-stats{grid-template-columns:repeat(2,1fr);gap:8px;padding:0 14px;margin-top:-5px}
        .acc-stats .st-card:first-child{grid-column: 1 / -1}
        .st-card{padding:12px 10px;gap:6px;border-radius:12px}.st-val{font-size:16px}
        .st-ic{width:36px;height:36px;border-radius:9px}.st-ic svg{width:18px;height:18px}
        .st-lb{font-size:10.5px}
        .acc-card{padding:16px 12px;border-radius:14px}
        .acc-card-h{flex-direction:column;align-items:flex-start;gap:6px}
        .acc-card-t{font-size:15px}
        .ban-avatar{width:56px;height:56px;font-size:22px;border-width:2px}
        .ban-avatar .av-dot{width:12px;height:12px;border-width:2px}
        .ban-info h1{font-size:18px;margin-bottom:6px}
        .ban-inner{gap:16px}
        .ban-meta{gap:8px 12px;flex-wrap:wrap}
        .ban-meta span{font-size:12px}
        .ban-meta svg{width:13px;height:13px}
        .acc-banner{padding:28px 20px 48px}
        .ban-deco{display:none}
        .acc-body{padding:0 10px;margin-top:14px}
        
        .o-cards{grid-template-columns:repeat(2,1fr);gap:10px}
        .o-card{aspect-ratio: 1/1}
        .o-card-body{padding:10px; height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center}
        .o-card-icon{width:36px;height:36px;margin-bottom:8px}
        .o-card-icon svg{width:18px;height:18px}
        .o-card-id{font-size:14px;margin-bottom:2px}
        .o-card-price{font-size:15px;margin-bottom:4px}
        .o-card-date{font-size:10px;margin-bottom:6px}
        .o-card .s-pill{font-size:10px;padding:3px 8px}

        .o-table th,.o-table td{padding:8px 6px;font-size:11.5px}
        .track-timeline .tl-label{font-size:9px}
        .ov-order-top{flex-direction:column;align-items:flex-start;gap:4px}
        .ov-order-detail{flex-direction:column;align-items:flex-start;gap:2px}
        .promo-row{grid-template-columns:1fr}
        .promo-c{padding:14px 14px}
        .promo-tt{font-size:13px}
        .acc-empty p{font-size:13px}
        .tier-badge{font-size:9.5px;padding:3px 9px}
        .mob-strip{padding:0 10px 4px;gap:5px}
        .mob-btn{padding:7px 11px;font-size:11px}
        .mob-btn svg{width:13px;height:13px}
        .ov-panel{border-radius:16px 16px 0 0;max-height:94vh}
        .ov-header{padding:14px 16px}
        .ov-tab{padding:7px 12px;font-size:12px}
        .ov-body{padding:16px 14px}
        .ov-field{margin-bottom:14px}
        .ov-label{font-size:10.5px;margin-bottom:5px}
        .ov-input{padding:10px 12px;font-size:13px;border-radius:10px}
        .ov-btn{padding:10px 20px;font-size:13px}
        .ov-avatar-wrap{width:64px;height:64px}
        .ov-avatar{width:64px;height:64px;border-width:2.5px}
        .ov-avatar-initial{font-size:26px}
        .ov-avatar-cam{width:26px;height:26px;border-width:2px}
        .ov-avatar-cam svg{width:12px;height:12px}
        .ov-avatar-hint{font-size:10.5px;margin-top:6px}
        .ov-avatar-section{margin-bottom:14px;padding-bottom:12px}
        .addr-card{padding:14px 14px;border-radius:12px}
        .addr-card .addr-name{font-size:13px}
        .addr-card .addr-detail{font-size:12px}
        .addr-add-form{padding:16px}
        .sec-info{padding:14px 16px;gap:10px;border-radius:12px}
        .sec-info svg{width:20px;height:20px}
        .sec-info p{font-size:12.5px}
        .ov-close{width:34px;height:34px;font-size:17px}
    }
    @media(max-width:400px){
        .acc-stats{gap:6px;padding:0 10px}
        .st-card{padding:10px 8px;gap:4px}.st-val{font-size:14px}
        .st-ic{width:30px;height:30px;border-radius:8px}.st-ic svg{width:16px;height:16px}
        .st-lb{font-size:9.5px}
        .ban-avatar{width:40px;height:40px;font-size:16px}
        .ban-info h1{font-size:14.5px}
        .ban-meta span{font-size:9.5px}
        .acc-banner{padding:14px 10px 32px}
        .acc-body{padding:0 8px;margin-top:12px}
        .acc-card{padding:14px 10px;border-radius:12px}
        .mob-strip{padding:0 8px 4px;gap:4px}
        .mob-btn{padding:6px 9px;font-size:10.5px}
    }
    </style>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<main class="acc-page">

<!-- ════════ BANNER ════════ -->
<div class="acc-banner">
    <div class="ban-deco">PureNut</div>
    <div class="ban-inner" style="max-width:var(--container);margin:0 auto">
        <div class="ban-avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.user.profileImage}"><img src="${fn:escapeXml(sessionScope.user.profileImage)}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%"></c:when>
                <c:otherwise>${fn:substring(sessionScope.user.fullName, 0, 1)}</c:otherwise>
            </c:choose>
            <span class="av-dot"></span>
        </div>
        <div class="ban-info">
            <h1><c:out value="${sessionScope.user.fullName}"/></h1>
            <div class="ban-meta">
                <span class="tier-badge tier-${memberTier}">
                    <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22 12 18.56 5.82 22 7 14.14l-5-4.87 6.91-1.01z"/></svg>
                    <c:choose>
                        <c:when test="${memberTier == 'KIM_CUONG'}">Kim Cương</c:when>
                        <c:when test="${memberTier == 'VANG'}">Vàng</c:when>
                        <c:when test="${memberTier == 'BAC'}">Bạc</c:when>
                        <c:otherwise>Thành viên mới</c:otherwise>
                    </c:choose>
                </span>
                <span><svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg><c:out value="${sessionScope.user.email}"/></span>
                <span><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg><c:out value="${sessionScope.user.phone}"/></span>
                <span><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>Từ <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MM/yyyy"/></span>
            </div>
        </div>
    </div>
</div>

<!-- ════════ STATS ════════ -->
<div class="acc-stats">
    <div class="st-card c1"><div class="st-ic c1"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></div><div><div class="st-lb">Tổng đơn hàng</div><div class="st-val acc-num">${totalOrders}</div></div></div>
    <div class="st-card c3"><div class="st-ic c3"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div><div><div class="st-lb">Hoàn thành</div><div class="st-val acc-num">${totalDoneCount}</div></div></div>
    <div class="st-card c4"><div class="st-ic c4"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><div><div class="st-lb">Đang xử lý</div><div class="st-val acc-num">${pendingCount}</div></div></div>
</div>

<!-- ════════ Mobile Strip ════════ -->
<div class="mob-strip" id="mobStrip">
    <button class="mob-btn active" data-tab="overview"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>Tổng quan<c:if test="${awaitingConfirmCount > 0}"><span class="side-badge" style="margin-left:4px">${awaitingConfirmCount}</span></c:if></button>
    <button class="mob-btn" data-tab="orders"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>Lịch sử</button>
    <button class="mob-btn" data-tab="taste"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>Khẩu vị</button>
    <button class="mob-btn" onclick="openOverlay()"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>Tài khoản</button>
    <a class="mob-btn" href="${pageContext.request.contextPath}/logout" style="color:var(--red);border-color:rgba(206,46,46,.2)"><svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>Đăng xuất</a>
</div>

<!-- ════════ BODY ════════ -->
<div class="acc-body">

<!-- ── Sidebar ── -->
<aside class="acc-side">
    <div class="side-lbl">Mua sắm</div>
    <ul class="side-nav">
        <li><a href="#" class="active" data-tab="overview"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>Tổng quan<c:if test="${awaitingConfirmCount > 0}"><span class="side-badge">${awaitingConfirmCount}</span></c:if></a></li>
        <li><a href="#" data-tab="orders"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>Lịch sử đơn hàng<c:if test="${doneCount > 0}"><span class="side-badge" style="background:var(--navy)">${doneCount}</span></c:if></a></li>
    </ul>
    <div class="side-lbl">Cá nhân</div>
    <ul class="side-nav">
        <li><a href="#" data-tab="taste"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>Hồ sơ khẩu vị</a></li>
    </ul>
    <div class="side-div"></div>
    <ul class="side-nav">
        <li><button type="button" onclick="openOverlay()"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>Tài khoản & Bảo mật</button></li>
        <c:if test="${sessionScope.user.role == 'ADMIN'}">
            <li><a href="${pageContext.request.contextPath}/admin" class="adm"><svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>Trang Quản trị</a></li>
        </c:if>
        <li><a href="${pageContext.request.contextPath}/logout" class="out"><svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>Đăng xuất</a></li>
    </ul>
</aside>

<!-- ── Content ── -->
<div class="acc-content">

<!-- ═══ TAB: Tổng quan ═══ -->
<div id="tab-overview" class="acc-tab show">

    <!-- Promo row -->
    <div class="promo-row">
        <a href="${pageContext.request.contextPath}/products" class="promo-c p1">
            <div class="promo-ic"><svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg></div>
            <div><div class="promo-tt">Mua sắm ngay</div><div class="promo-ds">Sữa hạt tươi mới mỗi ngày</div></div>
        </a>
        <div class="promo-c p2">
            <div class="promo-ic">
                <svg viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="6" fill="#FFF2C5"/>
                    <line x1="12" y1="1" x2="12" y2="3"/>
                    <line x1="12" y1="21" x2="12" y2="23"/>
                    <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/>
                    <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                    <line x1="1" y1="12" x2="3" y2="12"/>
                    <line x1="21" y1="12" x2="23" y2="12"/>
                    <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>
                    <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
                    
                    <!-- Cute Eyes -->
                    <circle cx="9.5" cy="10.5" r="1.2" fill="#241F18" stroke="none" />
                    <circle cx="14.5" cy="10.5" r="1.2" fill="#241F18" stroke="none" />

                    <!-- Clear Smile -->
                    <path d="M9 13.5c1.5 1.5 4.5 1.5 6 0" />
                </svg>
            </div>
            <div>
                <div class="promo-tt">Xin chào!</div>
                <div class="promo-ds">Chúc bạn một ngày tốt lành</div>
            </div>
        </div>
    </div>

    <!-- Đơn hàng chờ xác nhận -->
    <c:if test="${awaitingConfirmCount > 0}">
    <div class="acc-card awaiting-card">
        <div class="acc-card-h">
            <div class="acc-card-t">
                <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></svg>
                Đơn hàng chờ xác nhận
            </div>
            <span class="awaiting-count-badge">${awaitingConfirmCount}</span>
        </div>
        <p class="awaiting-note">Đơn đã được giao xong — xác nhận đã nhận hàng và đánh giá để đơn chuyển vào lịch sử.</p>
        <div class="o-cards">
        <c:forEach var="o" items="${orderHistory}">
            <c:if test="${o.status == 'DONE' && empty o.receivedConfirmedAt}">
                <div class="o-card" onclick="openOrderOverlay(this)" data-oid="${o.orderId}" data-status="${o.status}" data-deliv="${o.deliveryStatus}" data-total="<fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>" data-date="<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>" data-pay="${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}" data-received="${o.receivedConfirmedAt != null}" data-rating="${o.deliveryRating != null ? o.deliveryRating : 0}" data-review="${fn:escapeXml(o.deliveryReview)}">
                    <div class="o-card-body">
                        <div class="o-card-icon ic-done">
                            <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                        </div>
                        <div class="o-card-id">Đơn #${o.orderId}</div>
                        <div class="o-card-price"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</div>
                        <div class="o-card-date"><fmt:formatDate value="${not empty o.deliveredAt ? o.deliveredAt : o.createdAt}" pattern="dd/MM/yyyy"/></div>
                        <div class="o-card-pill"><span class="s-pill s-AWAITING"><span class="s-dot"></span>Chờ bạn xác nhận</span></div>
                    </div>
                    <div class="o-card-hover">
                        <div class="o-card-hover-row"><svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg><strong>${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}</strong></div>
                        <div class="o-card-hover-cta" style="color:#D97706"><svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>Nhấn để xác nhận đã nhận hàng</div>
                    </div>
                </div>
            </c:if>
        </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- Đơn hàng đang xử lý -->
    <div class="acc-card">
        <div class="acc-card-h">
            <div class="acc-card-t">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                Đơn hàng đang xử lý
            </div>
            <c:if test="${not empty orderHistory}">
                <a href="#" class="tab-link" data-tab="orders">Lịch sử <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></a>
            </c:if>
        </div>

        <c:set var="hasActive" value="false"/>
        <c:if test="${not empty orderHistory}">
            <div class="o-cards">
            <c:forEach var="o" items="${orderHistory}">
                <c:if test="${o.status == 'PENDING' || o.status == 'CONFIRMED' || o.status == 'SHIPPING' || o.status == 'PENDING_CANCEL'}">
                    <c:set var="hasActive" value="true"/>
                    <div class="o-card" onclick="openOrderOverlay(this)" data-oid="${o.orderId}" data-status="${o.status}" data-deliv="${o.deliveryStatus}" data-total="<fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>" data-date="<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>" data-pay="${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}" data-received="${o.receivedConfirmedAt != null}" data-rating="${o.deliveryRating != null ? o.deliveryRating : 0}" data-review="${fn:escapeXml(o.deliveryReview)}">
                        <div class="o-card-body">
                            <div class="o-card-icon ic-${fn:toLowerCase(o.status)}">
                                <c:choose>
                                    <c:when test="${o.status == 'PENDING'}"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></c:when>
                                    <c:when test="${o.status == 'CONFIRMED'}"><svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></c:when>
                                    <c:when test="${o.status == 'SHIPPING'}"><svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg></c:when>
                                    <c:when test="${o.status == 'PENDING_CANCEL'}"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg></c:when>
                                </c:choose>
                            </div>
                            <div class="o-card-id">Đơn #${o.orderId}</div>
                            <div class="o-card-price"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</div>
                            <div class="o-card-date"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/></div>
                            <div class="o-card-pill"><span class="s-pill s-${o.status}"><span class="s-dot"></span><c:choose><c:when test="${o.status == 'PENDING'}">Chờ xác nhận</c:when><c:when test="${o.status == 'CONFIRMED'}">Đã xác nhận</c:when><c:when test="${o.status == 'SHIPPING'}"><c:choose><c:when test="${o.deliveryStatus == 'ASSIGNED' || o.deliveryStatus == 'PICKING_UP'}">Chờ lấy hàng</c:when><c:when test="${o.deliveryStatus == 'DELIVERING'}">Đang giao hàng</c:when><c:otherwise>Đang giao</c:otherwise></c:choose></c:when><c:when test="${o.status == 'PENDING_CANCEL'}">Chờ duyệt hủy</c:when></c:choose></span></div>
                        </div>
                        <div class="o-card-hover">
                            <div class="o-card-hover-row"><svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg><strong>${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}</strong></div>
                            <div class="o-card-hover-row"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg><strong><fmt:formatDate value="${o.createdAt}" pattern="HH:mm dd/MM/yyyy"/></strong></div>
                            <div class="o-card-hover-cta"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>Nhấn xem chi tiết</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
            </div>
        </c:if>

        <c:if test="${!hasActive}">
            <div class="acc-empty" style="padding:30px 20px">
                <div class="acc-empty-ic" style="width:64px;height:64px;margin-bottom:14px">
                    <svg viewBox="0 0 24 24" style="width:28px;height:28px"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <p style="margin-bottom:10px">Không có đơn hàng đang xử lý. <a href="#" data-tab="orders" style="color:var(--navy);font-weight:700;text-decoration:underline">Xem lịch sử</a></p>
            </div>
        </c:if>
    </div>
</div>

<!-- ═══ TAB: Lịch sử đơn hàng (DONE + CANCELLED only) ═══ -->
<div id="tab-orders" class="acc-tab">
    <div class="acc-card">
        <div class="acc-card-h">
            <div class="acc-card-t"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>Lịch sử đơn hàng</div>
            <c:if test="${doneCount > 0}"><span style="font-size:13px;color:var(--ink-soft);font-weight:600">${doneCount} hoàn thành</span></c:if>
        </div>
        <c:set var="hasHistory" value="false"/>
        <c:if test="${not empty orderHistory}">
            <div class="o-cards">
            <c:forEach var="o" items="${orderHistory}">
                <c:if test="${(o.status == 'DONE' && not empty o.receivedConfirmedAt) || o.status == 'CANCELLED'}">
                    <c:set var="hasHistory" value="true"/>
                    <div class="o-card" onclick="openOrderOverlay(this)" data-oid="${o.orderId}" data-status="${o.status}" data-deliv="${o.deliveryStatus}" data-total="<fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>" data-date="<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>" data-pay="${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}" data-received="${o.receivedConfirmedAt != null}" data-rating="${o.deliveryRating != null ? o.deliveryRating : 0}" data-review="${fn:escapeXml(o.deliveryReview)}">
                        <div class="o-card-body">
                            <div class="o-card-icon ic-${fn:toLowerCase(o.status)}">
                                <c:choose>
                                    <c:when test="${o.status == 'DONE'}"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></c:when>
                                    <c:when test="${o.status == 'CANCELLED'}"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg></c:when>
                                </c:choose>
                            </div>
                            <div class="o-card-id">Đơn #${o.orderId}</div>
                            <div class="o-card-price"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</div>
                            <div class="o-card-date"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/></div>
                            <div class="o-card-pill"><span class="s-pill s-${o.status}"><span class="s-dot"></span><c:choose><c:when test="${o.status == 'DONE'}">Hoàn thành</c:when><c:when test="${o.status == 'CANCELLED'}">Đã hủy</c:when></c:choose></span></div>
                        </div>
                        <div class="o-card-hover">
                            <div class="o-card-hover-row"><svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg><strong>${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}</strong></div>
                            <div class="o-card-hover-row"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg><strong><fmt:formatDate value="${o.createdAt}" pattern="HH:mm dd/MM/yyyy"/></strong></div>
                            <div class="o-card-hover-cta"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>Nhấn xem chi tiết</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
            </div>
        </c:if>
        <c:if test="${!hasHistory}">
            <div class="acc-empty" style="padding:30px 20px">
                <div class="acc-empty-ic" style="width:64px;height:64px;margin-bottom:14px">
                    <svg viewBox="0 0 24 24" style="width:28px;height:28px"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                </div>
                <p style="margin-bottom:10px">Chưa có đơn hàng hoàn thành nào.</p>
            </div>
        </c:if>
    </div>
</div>


<!-- ═══ TAB: Hồ sơ khẩu vị ═══ -->
<div id="tab-taste" class="acc-tab">
    <div class="acc-card">
        <div class="acc-card-h"><div class="acc-card-t"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>Hồ sơ khẩu vị</div></div>

        <div class="taste-section">
            <div class="taste-label"><span class="tl-blue"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg></span>Độ ngọt yêu thích</div>
            <div class="sweet-bar" id="sweetBar">
                <button data-val="0">Không đường</button>
                <button data-val="25">25%</button>
                <button data-val="50" class="sel">50%</button>
                <button data-val="75">75%</button>
                <button data-val="100">100%</button>
            </div>
        </div>

        <div class="taste-section">
            <div class="taste-label"><span class="tl-gold"><svg viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22 12 18.56 5.82 22 7 14.14l-5-4.87 6.91-1.01z"/></svg></span>Loại hạt yêu thích</div>
            <div class="chip-grid" id="nutChips">
                <button class="chip" data-nut="hanh_nhan">🥜 Hạnh nhân</button>
                <button class="chip" data-nut="oc_cho">🌰 Óc chó</button>
                <button class="chip" data-nut="macca">✨ Macca</button>
                <button class="chip" data-nut="hat_dieu">🥜 Hạt điều</button>
                <button class="chip" data-nut="hat_sen">🪷 Hạt sen</button>
                <button class="chip" data-nut="hat_chia">🌱 Hạt chia</button>
                <button class="chip" data-nut="hat_lanh">🌾 Hạt lanh</button>
                <button class="chip" data-nut="dau_phong">🥜 Đậu phộng</button>
                <button class="chip" data-nut="hat_de">🌰 Hạt dẻ</button>
                <button class="chip" data-nut="hat_bi">🎃 Hạt bí</button>
            </div>
        </div>

        <div class="taste-section">
            <div class="taste-label"><span class="tl-red"><svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></span>Thành phần dị ứng</div>
            <div class="chip-grid" id="allergyChips">
                <button class="chip allergy" data-allergy="dau_phong">Đậu phộng</button>
                <button class="chip allergy" data-allergy="hanh_nhan">Hạnh nhân</button>
                <button class="chip allergy" data-allergy="dau_nanh">Đậu nành</button>
                <button class="chip allergy" data-allergy="sua_bo">Sữa bò</button>
                <button class="chip allergy" data-allergy="gluten">Gluten</button>
                <button class="chip allergy" data-allergy="hat_me">Hạt mè</button>
            </div>
        </div>

        <div style="display:flex;align-items:center">
            <button class="taste-save" onclick="saveTaste()">Lưu khẩu vị</button>
            <span class="taste-saved" id="tasteSaved"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>Đã lưu!</span>
        </div>
    </div>
</div>


</div><!-- /acc-content -->
</div><!-- /acc-body -->

<!-- ════════ Order Detail Overlay ════════ -->
<div class="o-detail-overlay" id="orderOverlay">
    <div class="o-detail-panel">
        <button class="o-detail-close" onclick="closeOrderOverlay()">&times;</button>
        <div class="o-detail-header">
            <div class="o-card-icon" id="ovIcon"></div>
            <h3 id="ovTitle"></h3>
            <div class="o-detail-meta" id="ovMeta"></div>
        </div>
        <div class="o-detail-info" id="ovInfo"></div>
        <div class="o-detail-timeline" id="ovTimeline"></div>
        <div class="cancel-section" id="cancelSection" style="display:none">
            <button class="cancel-btn" onclick="showCancelModal()">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                Hủy đơn hàng
            </button>
        </div>
        <div class="pending-cancel-notice" id="pendingCancelNotice" style="display:none">
            Yêu cầu hủy đã được gửi. Đang chờ admin duyệt hoàn tiền.
        </div>
        <div class="rate-section" id="rateSection" style="display:none">
            <button class="rate-btn" id="rateBtn" onclick="showRateModal()">
                <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                Xác nhận đã nhận hàng
            </button>
            <div class="rate-done" id="rateDone" style="display:none">
                <div class="rate-done-title">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                    Bạn đã xác nhận nhận hàng
                </div>
                <div class="rate-stars-view" id="rateStarsView"></div>
                <div class="rate-done-review" id="rateReviewView"></div>
            </div>
        </div>
        <div class="ship-anim" id="shipAnim">
            <div class="mini-loader">
                <div class="ml-box ml-b0"><div></div></div>
                <div class="ml-box ml-b1"><div></div></div>
                <div class="ml-box ml-b2"><div></div></div>
                <div class="ml-box ml-b3"><div></div></div>
                <div class="ml-box ml-b4"><div></div></div>
                <div class="ml-box ml-b5"><div></div></div>
                <div class="ml-box ml-b6"><div></div></div>
                <div class="ml-box ml-b7"><div></div></div>
                <div class="ml-ground"><div></div></div>
            </div>
            <p class="ship-anim-text">Đơn hàng đang trên đường đến bạn<span class="ship-dots"></span></p>
            <p class="ship-anim-sub">Shipper sẽ liên hệ khi gần đến nơi</p>
        </div>
    </div>
</div>

<!-- ════════ Cancel Reason Modal ════════ -->
<div class="cancel-modal" id="cancelModal">
    <div class="cm-panel">
        <button class="cm-close" onclick="closeCancelModal()">&times;</button>
        <div class="cm-title">Lý do hủy đơn hàng</div>
        <div class="cm-sub">Vui lòng cho chúng tôi biết lý do bạn muốn hủy</div>
        <div class="cm-reasons">
            <label><input type="radio" name="cancelReason" value="Đổi ý không muốn mua nữa"><span>Đổi ý không muốn mua nữa</span></label>
            <label><input type="radio" name="cancelReason" value="Muốn thay đổi sản phẩm / số lượng"><span>Muốn thay đổi sản phẩm / số lượng</span></label>
            <label><input type="radio" name="cancelReason" value="Tìm được giá tốt hơn ở nơi khác"><span>Tìm được giá tốt hơn ở nơi khác</span></label>
            <label><input type="radio" name="cancelReason" value="Thời gian giao hàng quá lâu"><span>Thời gian giao hàng quá lâu</span></label>
            <label><input type="radio" name="cancelReason" value="other"><span>Khác</span></label>
        </div>
        <div class="cm-other" id="cmOther"><textarea id="cmOtherText" placeholder="Nhập lý do của bạn..."></textarea></div>
        <div class="cm-actions">
            <button class="cm-cancel-back" onclick="closeCancelModal()">Quay lại</button>
            <button class="cm-cancel-confirm" id="cmConfirmBtn" disabled onclick="submitCancel()">Xác nhận hủy</button>
        </div>
        <div class="cm-msg" id="cmMsg"></div>
    </div>
</div>

<!-- ════════ Xác nhận nhận hàng + Đánh giá Modal ════════ -->
<div class="rate-modal" id="rateModal">
    <div class="cm-panel">
        <button class="cm-close" onclick="closeRateModal()">&times;</button>
        <div class="cm-title">Xác nhận đã nhận hàng</div>
        <div class="cm-sub">Đơn hàng đến tay bạn thế nào? Đánh giá sao là tùy chọn.</div>
        <div class="rm-stars" id="rmStars">
            <button type="button" class="rm-star" data-v="1"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26"/></svg></button>
            <button type="button" class="rm-star" data-v="2"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26"/></svg></button>
            <button type="button" class="rm-star" data-v="3"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26"/></svg></button>
            <button type="button" class="rm-star" data-v="4"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26"/></svg></button>
            <button type="button" class="rm-star" data-v="5"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26"/></svg></button>
        </div>
        <div class="rm-star-label" id="rmStarLabel"></div>
        <div class="cm-other" id="rmReviewWrap" style="display:block">
            <textarea id="rmReviewText" placeholder="Viết vài dòng nhận xét (không bắt buộc)..." maxlength="500"></textarea>
        </div>
        <div class="cm-actions">
            <button class="cm-cancel-back" onclick="closeRateModal()">Để sau</button>
            <button class="cm-cancel-confirm" id="rmConfirmBtn" style="background:#12B76A" onclick="submitConfirmReceived()">Xác nhận</button>
        </div>
        <div class="cm-msg" id="rmMsg"></div>
    </div>
</div>

<!-- ════════ Avatar Crop Modal ════════ -->
<div class="crop-modal" id="cropModal">
    <div class="crop-panel">
        <div class="crop-header">
            <h3><svg viewBox="0 0 24 24"><path d="M6.13 1L6 16a2 2 0 0 0 2 2h15"/><path d="M1 6.13L16 6a2 2 0 0 1 2 2v15"/></svg>Cắt ảnh đại diện</h3>
            <button class="crop-close" onclick="closeCropModal()">&times;</button>
        </div>
        <div class="crop-area" id="cropArea">
            <img id="cropImg" src="" alt="">
            <div class="crop-circle"></div>
        </div>
        <div class="crop-controls">
            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><line x1="8" y1="11" x2="14" y2="11"/></svg>
            <input type="range" class="crop-slider" id="cropZoom" min="100" max="300" value="100">
            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><line x1="11" y1="8" x2="11" y2="14"/><line x1="8" y1="11" x2="14" y2="11"/></svg>
        </div>
        <div class="crop-actions">
            <button class="crop-cancel" onclick="closeCropModal()">Hủy</button>
            <button class="crop-save" id="cropSaveBtn" onclick="saveCrop()">Lưu ảnh đại diện</button>
        </div>
    </div>
</div>

</main>

<!-- ════════════════════════════════
     OVERLAY — Tài khoản & Bảo mật
     ════════════════════════════════ -->
<div class="ov-backdrop" id="ovBackdrop">
    <div class="ov-panel">
        <div class="ov-header">
            <div class="ov-tabs">
                <button class="ov-tab active" data-otab="info">Thông tin</button>
                <button class="ov-tab" data-otab="address">Địa chỉ</button>
                <button class="ov-tab" data-otab="security">Bảo mật</button>
            </div>
            <button class="ov-close" onclick="closeOverlay()">&times;</button>
        </div>
        <div class="ov-body">

            <!-- Thông tin -->
            <div id="otab-info" class="ov-pane show">
                <div class="ov-msg" id="profileMsg"></div>

                <!-- Avatar Upload -->
                <div class="ov-avatar-section">
                    <div class="ov-avatar-wrap" onclick="document.getElementById('avatarInput').click()">
                        <div class="ov-avatar" id="ovAvatarPreview">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.profileImage}"><img src="${fn:escapeXml(sessionScope.user.profileImage)}" alt="Avatar" style="width:100%;height:100%;object-fit:cover"></c:when>
                                <c:otherwise><span class="ov-avatar-initial" id="avatarInitial">${fn:substring(sessionScope.user.fullName, 0, 1)}</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="ov-avatar-cam">
                            <svg viewBox="0 0 24 24"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                        </div>
                    </div>
                    <input type="file" id="avatarInput" accept="image/jpeg,image/png,image/webp" style="display:none" onchange="openCropModal(this)">
                    <div class="ov-avatar-hint">Nhấn vào ảnh để thay đổi</div>
                </div>

                <div class="ov-field"><label class="ov-label">Nickname (Tên hiển thị)</label><input type="text" class="ov-input" id="profNickname" value="" placeholder="Tên của bạn"></div>
                <div class="ov-field"><label class="ov-label">Họ và tên</label><input type="text" class="ov-input" id="profName" value="${fn:escapeXml(sessionScope.user.fullName)}"></div>
                <div class="ov-field"><label class="ov-label">Email</label><input type="email" class="ov-input" id="profEmail" value="${fn:escapeXml(sessionScope.user.email)}" readonly></div>
                <div class="ov-field"><label class="ov-label">Số điện thoại</label><input type="tel" class="ov-input" id="profPhone" value="${fn:escapeXml(sessionScope.user.phone)}" pattern="0[0-9]{9,10}" maxlength="11"></div>
                <div class="ov-field"><label class="ov-label">Ngày tham gia</label><input type="text" class="ov-input" value="<fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy"/>" readonly></div>
                <button class="ov-btn primary" onclick="saveProfile()">Lưu thay đổi</button>
            </div>

            <!-- Địa chỉ -->
            <div id="otab-address" class="ov-pane">
                <div class="ov-msg" id="addrMsg"></div>
                <div id="addrList">
                    <c:forEach var="addr" items="${addresses}">
                        <div class="addr-card" data-id="${addr.addressId}">
                            <div class="addr-label"><c:out value="${addr.label}"/><c:if test="${addr.isDefault()}"><span class="def-badge">Mặc định</span></c:if></div>
                            <div class="addr-name"><c:out value="${addr.recipientName}"/> · <c:out value="${addr.phone}"/></div>
                            <div class="addr-detail"><c:out value="${addr.fullAddress}"/></div>
                            <div class="addr-actions"><button title="Xóa" onclick="deleteAddr(${addr.addressId})"><svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></button></div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty addresses}"><p style="color:var(--ink-soft);font-size:14px;margin-bottom:14px">Chưa có địa chỉ nào được lưu.</p></c:if>
                </div>
                <div class="addr-add-form">
                    <div class="form-title"><svg viewBox="0 0 24 24" style="width:18px;height:18px;stroke:var(--navy);fill:none;stroke-width:2;stroke-linecap:round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Thêm địa chỉ mới</div>
                    <div class="addr-row" style="margin-bottom:14px">
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Nhãn</label><select class="ov-input" id="addrLabel"><option>Nhà riêng</option><option>Công ty</option><option>Khác</option></select></div>
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Người nhận</label><input type="text" class="ov-input" id="addrName" placeholder="${fn:escapeXml(sessionScope.user.fullName)}"></div>
                    </div>
                    <div class="addr-row" style="margin-bottom:14px">
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">SĐT</label><input type="tel" class="ov-input" id="addrPhone" placeholder="${fn:escapeXml(sessionScope.user.phone)}" pattern="0[0-9]{9,10}"></div>
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Tỉnh / Thành phố</label><input type="text" class="ov-input" id="addrProvince" placeholder="TP. Hồ Chí Minh"></div>
                    </div>
                    <div class="addr-row" style="margin-bottom:14px">
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Quận / Huyện</label><input type="text" class="ov-input" id="addrDistrict"></div>
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Phường / Xã</label><input type="text" class="ov-input" id="addrWard"></div>
                    </div>
                    <div class="ov-field"><label class="ov-label">Số nhà, đường</label><input type="text" class="ov-input" id="addrStreet" placeholder="123 Nguyễn Văn A"></div>
                    <button type="button" class="ov-btn" id="geoLocBtn" onclick="geoLocate()" style="background:var(--paper);border:1.5px solid var(--navy);color:var(--navy);margin-bottom:10px;gap:8px;width:100%"><svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="3"/><line x1="12" y1="2" x2="12" y2="5"/><line x1="12" y1="19" x2="12" y2="22"/><line x1="2" y1="12" x2="5" y2="12"/><line x1="19" y1="12" x2="22" y2="12"/></svg><span id="geoLocText">Định vị vị trí hiện tại</span></button>
                    <div id="addrMap" style="display:none;width:100%;height:200px;border-radius:12px;margin-bottom:12px;border:1.5px solid var(--line);overflow:hidden"></div>
                    <button class="ov-btn primary" onclick="saveAddr()">Thêm địa chỉ</button>
                </div>
            </div>

            <!-- Bảo mật -->
            <div id="otab-security" class="ov-pane">
                <div class="ov-msg" id="secMsg"></div>
                <div class="sec-info">
                    <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <p>Mật khẩu được mã hóa <strong>BCrypt</strong> — không ai có thể đọc được, kể cả quản trị viên.</p>
                </div>
                <form id="secForm" autocomplete="off" onsubmit="event.preventDefault();changePw()">
                <div class="ov-field"><label class="ov-label">Mật khẩu hiện tại</label><input type="password" class="ov-input" id="secOldPw" name="oldPassword" autocomplete="current-password"></div>
                <div class="ov-field"><label class="ov-label">Mật khẩu mới</label><input type="password" class="ov-input" id="secNewPw" name="newPassword" autocomplete="new-password"><div style="font-size:11.5px;color:var(--ink-soft);margin-top:5px">Ít nhất 8 ký tự, gồm hoa, thường, số và ký tự đặc biệt.</div></div>
                <div class="ov-field"><label class="ov-label">Xác nhận mật khẩu mới</label><input type="password" class="ov-input" id="secConfirmPw" name="confirmPassword" autocomplete="new-password"></div>
                <button type="submit" class="ov-btn primary">Đổi mật khẩu</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
(function(){
    var CTX='${pageContext.request.contextPath}';

    function switchTab(name){
        document.querySelectorAll('.acc-tab').forEach(function(t){t.classList.remove('show')});
        var el=document.getElementById('tab-'+name);if(el)el.classList.add('show');
        document.querySelectorAll('.side-nav a[data-tab],.side-nav button[data-tab]').forEach(function(a){a.classList.remove('active')});
        var s=document.querySelector('.side-nav [data-tab="'+name+'"]');if(s)s.classList.add('active');
        document.querySelectorAll('.mob-btn[data-tab]').forEach(function(b){b.classList.remove('active')});
        var m=document.querySelector('.mob-btn[data-tab="'+name+'"]');if(m)m.classList.add('active');
    }
    document.querySelectorAll('[data-tab]').forEach(function(el){
        el.addEventListener('click',function(e){e.preventDefault();switchTab(this.getAttribute('data-tab'))});
    });

    window.openOverlay=function(){document.getElementById('ovBackdrop').classList.add('open')};
    window.closeOverlay=function(){document.getElementById('ovBackdrop').classList.remove('open')};
    document.getElementById('ovBackdrop').addEventListener('click',function(e){if(e.target===this)closeOverlay()});
    document.addEventListener('keydown',function(e){if(e.key==='Escape')closeOverlay()});

    document.querySelectorAll('.ov-tab').forEach(function(tab){
        tab.addEventListener('click',function(){
            document.querySelectorAll('.ov-tab').forEach(function(t){t.classList.remove('active')});
            document.querySelectorAll('.ov-pane').forEach(function(p){p.classList.remove('show')});
            this.classList.add('active');
            var p=document.getElementById('otab-'+this.getAttribute('data-otab'));if(p)p.classList.add('show');
        });
    });

    function post(url,data,cb){
        var p=new URLSearchParams();p.append('_csrf','${sessionScope._csrf}');for(var k in data)p.append(k,data[k]);
        fetch(CTX+url,{method:'POST',body:p,headers:{'Content-Type':'application/x-www-form-urlencoded'}}).then(function(r){return r.json().then(function(j){cb(r.ok,j)})}).catch(function(){cb(false,{error:'Lỗi kết nối.'})});
    }
    function showMsg(id,ok,text){var el=document.getElementById(id);el.className='ov-msg '+(ok?'ok':'err');el.textContent=text}

    /* ── Avatar Crop ── */
    var cropState={img:null,natW:0,natH:0,scale:1,ox:0,oy:0,dragging:false,sx:0,sy:0};

    window.openCropModal=function(input){
        if(!input.files||!input.files[0])return;
        var file=input.files[0];
        if(file.size>10*1024*1024){showMsg('profileMsg',false,'Ảnh quá lớn (tối đa 10MB).');input.value='';return}
        var reader=new FileReader();
        reader.onload=function(e){
            var img=document.getElementById('cropImg');
            img.onload=function(){
                cropState.natW=img.naturalWidth;cropState.natH=img.naturalHeight;
                cropState.scale=1;cropState.ox=0;cropState.oy=0;
                document.getElementById('cropZoom').value=100;
                positionCropImg();
                document.getElementById('cropModal').classList.add('open');
            };
            img.src=e.target.result;
        };
        reader.readAsDataURL(file);
    };
    window.closeCropModal=function(){
        document.getElementById('cropModal').classList.remove('open');
        document.getElementById('avatarInput').value='';
    };
    document.getElementById('cropModal').addEventListener('click',function(e){if(e.target===this)closeCropModal()});

    function positionCropImg(){
        var area=document.getElementById('cropArea'),img=document.getElementById('cropImg');
        var aw=area.offsetWidth,ah=area.offsetHeight;
        var fitScale=Math.max(aw/cropState.natW,ah/cropState.natH);
        var s=fitScale*cropState.scale;
        var iw=cropState.natW*s,ih=cropState.natH*s;
        var maxOx=(iw-aw)/2,maxOy=(ih-ah)/2;
        cropState.ox=Math.max(-maxOx,Math.min(maxOx,cropState.ox));
        cropState.oy=Math.max(-maxOy,Math.min(maxOy,cropState.oy));
        var x=(aw-iw)/2+cropState.ox,y=(ah-ih)/2+cropState.oy;
        img.style.width=iw+'px';img.style.height=ih+'px';
        img.style.left=x+'px';img.style.top=y+'px';
        img.style.transform='none';
    }

    document.getElementById('cropZoom').addEventListener('input',function(){
        cropState.scale=this.value/100;positionCropImg();
    });

    var cropArea=document.getElementById('cropArea');
    function startDrag(ex,ey){cropState.dragging=true;cropState.sx=ex;cropState.sy=ey}
    function moveDrag(ex,ey){if(!cropState.dragging)return;cropState.ox+=ex-cropState.sx;cropState.oy+=ey-cropState.sy;cropState.sx=ex;cropState.sy=ey;positionCropImg()}
    function endDrag(){cropState.dragging=false}
    cropArea.addEventListener('mousedown',function(e){e.preventDefault();startDrag(e.clientX,e.clientY)});
    document.addEventListener('mousemove',function(e){moveDrag(e.clientX,e.clientY)});
    document.addEventListener('mouseup',endDrag);
    cropArea.addEventListener('touchstart',function(e){if(e.touches.length===1){e.preventDefault();startDrag(e.touches[0].clientX,e.touches[0].clientY)}},{passive:false});
    cropArea.addEventListener('touchmove',function(e){if(e.touches.length===1){e.preventDefault();moveDrag(e.touches[0].clientX,e.touches[0].clientY)}},{passive:false});
    cropArea.addEventListener('touchend',endDrag);

    window.saveCrop=function(){
        var btn=document.getElementById('cropSaveBtn');
        btn.disabled=true;btn.textContent='Đang lưu...';
        var area=document.getElementById('cropArea'),img=document.getElementById('cropImg');
        var aw=area.offsetWidth,ah=area.offsetHeight;
        var circle=area.querySelector('.crop-circle');
        var cr=circle.offsetWidth;
        var cx=(aw-cr)/2,cy=(ah-cr)/2;
        var canvas=document.createElement('canvas');
        var outSize=256;
        canvas.width=outSize;canvas.height=outSize;
        var ctx=canvas.getContext('2d');
        ctx.beginPath();ctx.arc(outSize/2,outSize/2,outSize/2,0,Math.PI*2);ctx.closePath();ctx.clip();
        var imgLeft=parseFloat(img.style.left),imgTop=parseFloat(img.style.top);
        var imgW=parseFloat(img.style.width),imgH=parseFloat(img.style.height);
        var srcX=(cx-imgLeft)/imgW*cropState.natW;
        var srcY=(cy-imgTop)/imgH*cropState.natH;
        var srcSize=cr/imgW*cropState.natW;
        ctx.drawImage(img,srcX,srcY,srcSize,srcSize,0,0,outSize,outSize);
        var dataUrl=canvas.toDataURL('image/jpeg',0.85);
        var p=new URLSearchParams();
        p.append('_csrf','${sessionScope._csrf}');
        p.append('imageData',dataUrl);
        fetch(CTX+'/account/avatar',{method:'POST',body:p,headers:{'Content-Type':'application/x-www-form-urlencoded'}})
        .then(function(r){return r.json().then(function(j){return{ok:r.ok,data:j}})})
        .then(function(res){
            if(res.ok&&res.data.success){
                document.getElementById('ovAvatarPreview').innerHTML='<img src="'+dataUrl+'" alt="Avatar" style="width:100%;height:100%;object-fit:cover">';
                var banAv=document.querySelector('.ban-avatar');
                var avDot=banAv.querySelector('.av-dot');
                banAv.innerHTML='<img src="'+dataUrl+'" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%">';
                banAv.appendChild(avDot);
                closeCropModal();
                showMsg('profileMsg',true,'Đã cập nhật ảnh đại diện!');
            } else {
                showMsg('profileMsg',false,res.data.error||'Có lỗi xảy ra');
            }
            btn.disabled=false;btn.textContent='Lưu ảnh đại diện';
        }).catch(function(){
            showMsg('profileMsg',false,'Lỗi kết nối.');
            btn.disabled=false;btn.textContent='Lưu ảnh đại diện';
        });
    };

    window.saveProfile=function(){
        var n=document.getElementById('profName').value.trim(),p=document.getElementById('profPhone').value.trim();
        var nick=document.getElementById('profNickname')?document.getElementById('profNickname').value.trim():'';
        if(!n){showMsg('profileMsg',false,'Vui lòng nhập họ tên.');return}
        if(!/^0[0-9]{9,10}$/.test(p)){showMsg('profileMsg',false,'SĐT không hợp lệ.');return}
        var data={fullName:n,phone:p};
        if(nick) data.nickname=nick;
        post('/account/profile',data,function(ok,j){
            showMsg('profileMsg',ok,ok?'Đã lưu thông tin!':j.error);
            if(ok){document.querySelector('.ban-info h1').textContent=n;var ba=document.querySelector('.ban-avatar');if(!ba.querySelector('img'))ba.childNodes[0].textContent=n.charAt(0)}
        });
    };

    window.changePw=function(){
        var o=document.getElementById('secOldPw').value,n=document.getElementById('secNewPw').value,c=document.getElementById('secConfirmPw').value;
        if(!o||!n){showMsg('secMsg',false,'Vui lòng điền đầy đủ.');return}
        if(n!==c){showMsg('secMsg',false,'Mật khẩu xác nhận không khớp.');return}
        post('/account/password',{oldPassword:o,newPassword:n,confirmPassword:c},function(ok,j){
            showMsg('secMsg',ok,ok?'Đổi mật khẩu thành công!':j.error);
            if(ok){document.getElementById('secOldPw').value='';document.getElementById('secNewPw').value='';document.getElementById('secConfirmPw').value=''}
        });
    };

    window.saveAddr=function(){
        var st=document.getElementById('addrStreet').value.trim();
        if(!st){showMsg('addrMsg',false,'Vui lòng nhập địa chỉ.');return}
        post('/account/address',{label:document.getElementById('addrLabel').value,recipientName:document.getElementById('addrName').value.trim(),phone:document.getElementById('addrPhone').value.trim(),province:document.getElementById('addrProvince').value.trim(),district:document.getElementById('addrDistrict').value.trim(),ward:document.getElementById('addrWard').value.trim(),street:st},function(ok,j){
            showMsg('addrMsg',ok,ok?'Đã thêm địa chỉ!':j.error);if(ok)setTimeout(function(){location.reload()},600);
        });
    };

    window.deleteAddr=function(id){
        if(!confirm('Xóa địa chỉ này?'))return;
        post('/account/address/delete',{addressId:id},function(ok,j){if(ok){var c=document.querySelector('.addr-card[data-id="'+id+'"]');if(c)c.remove()}else showMsg('addrMsg',false,j.error)});
    };

    var statusNames={PENDING:'Chờ xác nhận',CONFIRMED:'Đã xác nhận',SHIPPING:'Đang giao hàng',DONE:'Hoàn thành',CANCELLED:'Đã hủy',PENDING_CANCEL:'Chờ duyệt hủy'};
    var statusIcons={
        PENDING:'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>',
        CONFIRMED:'<svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
        SHIPPING:'<svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>',
        DONE:'<svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>',
        CANCELLED:'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>',
        PENDING_CANCEL:'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>'
    };
    var statusRank={PENDING:0,CONFIRMED:1,SHIPPING:2,DONE:3};
    var currentCancelOid=null;

    window.openOrderOverlay=function(card){
        var s=card.dataset.status,oid=card.dataset.oid,ds=card.dataset.deliv;
        var ov=document.getElementById('orderOverlay');
        var icon=document.getElementById('ovIcon');
        icon.className='o-card-icon ic-'+s.toLowerCase();
        icon.innerHTML=statusIcons[s]||'';
        document.getElementById('ovTitle').textContent='Đơn hàng #'+oid;
        
        var displayStatusName = statusNames[s] || '';
        if (s === 'SHIPPING') {
            if (ds === 'ASSIGNED' || ds === 'PICKING_UP') {
                displayStatusName = 'Chờ lấy hàng';
            } else if (ds === 'DELIVERING') {
                displayStatusName = 'Đang giao hàng';
            }
        }
        
        document.getElementById('ovMeta').innerHTML='<span class="s-pill s-'+s+'"><span class="s-dot"></span>'+displayStatusName+'</span>';
        document.getElementById('ovInfo').innerHTML=
            '<div class="o-detail-info-item"><div class="di-label">Tổng tiền</div><div class="di-val" style="font-size:17px;color:var(--navy);font-family:\'EB Garamond\',serif">'+card.dataset.total+'đ</div></div>'+
            '<div class="o-detail-info-item"><div class="di-label">Ngày đặt</div><div class="di-val">'+card.dataset.date+'</div></div>'+
            '<div class="o-detail-info-item"><div class="di-label">Thanh toán</div><div class="di-val">'+card.dataset.pay+'</div></div>'+
            '<div class="o-detail-info-item"><div class="di-label">Trạng thái</div><div class="di-val">'+displayStatusName+'</div></div>';
        var tl='';
        if(s==='CANCELLED'){
            tl='<div class="track-timeline">'+
                '<div class="tl-step done"><div class="tl-dot"></div><div class="tl-label">Đơn mới</div></div>'+
                '<div class="tl-line" style="background:#CE2E2E"></div>'+
                '<div class="tl-step"><div class="tl-dot" style="background:#CE2E2E;border-color:#CE2E2E"></div><div class="tl-label" style="color:#CE2E2E">Đã hủy</div></div>'+
                '</div>';
        } else if(s==='PENDING_CANCEL'){
            tl='<div class="track-timeline">'+
                '<div class="tl-step done"><div class="tl-dot"></div><div class="tl-label">Đơn mới</div></div>'+
                '<div class="tl-line" style="background:#EAB308"></div>'+
                '<div class="tl-step active"><div class="tl-dot" style="background:#EAB308;border-color:#EAB308"></div><div class="tl-label" style="color:#B45309">Chờ duyệt hủy</div></div>'+
                '</div>';
        } else {
            var rank=statusRank[s]||0;
            var shippingStepLabel = 'Đang giao';
            if (s === 'SHIPPING' && (ds === 'ASSIGNED' || ds === 'PICKING_UP')) {
                shippingStepLabel = 'Chờ lấy hàng';
            }
            var steps=[{l:'Đơn mới',r:0},{l:'Đã xác nhận',r:1},{l:shippingStepLabel,r:2},{l:'Giao thành công',r:3}];
            tl='<div class="track-timeline">';
            for(var i=0;i<steps.length;i++){
                var cls=steps[i].r<rank?'done':(steps[i].r===rank?'active':'');
                tl+='<div class="tl-step '+cls+'"><div class="tl-dot"></div><div class="tl-label">'+steps[i].l+'</div></div>';
                if(i<steps.length-1) tl+='<div class="tl-line '+(steps[i].r<rank?'done':'')+'"></div>';
            }
            tl+='</div>';
        }
        document.getElementById('ovTimeline').innerHTML=tl;
        var shipAnim=document.getElementById('shipAnim');
        if(shipAnim) {
            if (s === 'SHIPPING') {
                shipAnim.classList.add('show');
                var animText = shipAnim.querySelector('.ship-anim-text');
                var animSub = shipAnim.querySelector('.ship-anim-sub');
                if (ds === 'ASSIGNED' || ds === 'PICKING_UP') {
                    if (animText) animText.innerHTML = 'Đang chuẩn bị bàn giao cho shipper<span class="ship-dots"></span>';
                    if (animSub) animSub.textContent = 'Shipper đang chuẩn bị nhận hàng tại cửa hàng';
                } else {
                    if (animText) animText.innerHTML = 'Đơn hàng đang trên đường đến bạn<span class="ship-dots"></span>';
                    if (animSub) animSub.textContent = 'Shipper sẽ liên hệ khi gần đến nơi';
                }
            } else {
                shipAnim.classList.remove('show');
            }
        }
        var cancelSec=document.getElementById('cancelSection');
        var pendingNotice=document.getElementById('pendingCancelNotice');
        if(cancelSec) cancelSec.style.display=(s==='PENDING'||s==='CONFIRMED')?'block':'none';
        if(pendingNotice) pendingNotice.style.display=(s==='PENDING_CANCEL')?'block':'none';

        var rateSec=document.getElementById('rateSection');
        if(rateSec){
            if(s==='DONE'){
                rateSec.style.display='block';
                var received=card.dataset.received==='true';
                var rateBtn=document.getElementById('rateBtn');
                var rateDone=document.getElementById('rateDone');
                if(received){
                    rateBtn.style.display='none';
                    rateDone.style.display='block';
                    var rating=parseInt(card.dataset.rating||'0',10);
                    var starsHtml='';
                    for(var si=1;si<=5;si++){
                        starsHtml+='<svg class="'+(si<=rating?'on':'off')+'" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26"/></svg>';
                    }
                    document.getElementById('rateStarsView').innerHTML=rating>0?starsHtml:'';
                    var review=card.dataset.review||'';
                    document.getElementById('rateReviewView').textContent=review?'"'+review+'"':'';
                } else {
                    rateBtn.style.display='inline-flex';
                    rateDone.style.display='none';
                }
            } else {
                rateSec.style.display='none';
            }
        }

        currentCancelOid=oid;
        ov.classList.add('open');
    };
    window.closeOrderOverlay=function(){document.getElementById('orderOverlay').classList.remove('open')};
    document.getElementById('orderOverlay').addEventListener('click',function(e){if(e.target===this)closeOrderOverlay()});
    document.addEventListener('keydown',function(e){if(e.key==='Escape'){closeCancelModal();closeRateModal();closeOrderOverlay();closeOverlay()}});

    window.showCancelModal=function(){
        var m=document.getElementById('cancelModal');
        m.querySelectorAll('input[name=cancelReason]').forEach(function(r){r.checked=false});
        document.getElementById('cmOther').style.display='none';
        document.getElementById('cmOtherText').value='';
        document.getElementById('cmConfirmBtn').disabled=true;
        var msg=document.getElementById('cmMsg');msg.className='cm-msg';msg.textContent='';
        m.classList.add('open');
    };
    window.closeCancelModal=function(){document.getElementById('cancelModal').classList.remove('open')};
    document.getElementById('cancelModal').addEventListener('click',function(e){if(e.target===this)closeCancelModal()});

    document.querySelectorAll('input[name=cancelReason]').forEach(function(r){
        r.addEventListener('change',function(){
            var isOther=this.value==='other';
            document.getElementById('cmOther').style.display=isOther?'block':'none';
            document.getElementById('cmConfirmBtn').disabled=isOther&&!document.getElementById('cmOtherText').value.trim();
        });
    });
    document.getElementById('cmOtherText').addEventListener('input',function(){
        var sel=document.querySelector('input[name=cancelReason]:checked');
        document.getElementById('cmConfirmBtn').disabled=!(sel&&(sel.value!=='other'||this.value.trim()));
    });

    window.submitCancel=function(){
        var sel=document.querySelector('input[name=cancelReason]:checked');
        if(!sel)return;
        var reason=sel.value==='other'?document.getElementById('cmOtherText').value.trim():sel.value;
        if(!reason)return;
        var btn=document.getElementById('cmConfirmBtn');
        btn.disabled=true;btn.textContent='Đang xử lý...';
        fetch(CTX+'/account/order/cancel',{
            method:'POST',
            headers:{'Content-Type':'application/x-www-form-urlencoded','X-Requested-With':'XMLHttpRequest'},
            body:'_csrf='+encodeURIComponent('${sessionScope._csrf}')+'&orderId='+currentCancelOid+'&reason='+encodeURIComponent(reason)
        }).then(function(r){return r.json()}).then(function(d){
            var msg=document.getElementById('cmMsg');
            if(d.success){
                msg.className='cm-msg success';
                msg.textContent=d.message;
                setTimeout(function(){closeCancelModal();closeOrderOverlay();location.reload()},1500);
            } else {
                msg.className='cm-msg error';
                msg.textContent=d.error||'Có lỗi xảy ra';
                btn.disabled=false;btn.textContent='Xác nhận hủy';
            }
        }).catch(function(){
            var msg=document.getElementById('cmMsg');
            msg.className='cm-msg error';msg.textContent='Lỗi kết nối. Vui lòng thử lại.';
            btn.disabled=false;btn.textContent='Xác nhận hủy';
        });
    };

    /* ═══ Xác nhận nhận hàng + Đánh giá sao ═══ */
    var rmSelectedStars=0;
    var rmStarLabels=['','Rất tệ','Không hài lòng','Bình thường','Hài lòng','Tuyệt vời!'];

    window.showRateModal=function(){
        rmSelectedStars=0;
        document.querySelectorAll('.rm-star').forEach(function(b){b.classList.remove('on')});
        document.getElementById('rmStarLabel').textContent='';
        document.getElementById('rmReviewText').value='';
        var msg=document.getElementById('rmMsg');msg.className='cm-msg';msg.textContent='';
        var btn=document.getElementById('rmConfirmBtn');btn.disabled=false;btn.textContent='Xác nhận';
        document.getElementById('rateModal').classList.add('open');
    };
    window.closeRateModal=function(){document.getElementById('rateModal').classList.remove('open')};
    document.getElementById('rateModal').addEventListener('click',function(e){if(e.target===this)closeRateModal()});

    document.querySelectorAll('.rm-star').forEach(function(star){
        var v=parseInt(star.dataset.v,10);
        star.addEventListener('mouseenter',function(){paintStars(v)});
        star.addEventListener('click',function(){rmSelectedStars=v;paintStars(v);document.getElementById('rmStarLabel').textContent=rmStarLabels[v]});
    });
    document.getElementById('rmStars').addEventListener('mouseleave',function(){paintStars(rmSelectedStars);document.getElementById('rmStarLabel').textContent=rmStarLabels[rmSelectedStars]||''});
    function paintStars(v){
        document.querySelectorAll('.rm-star').forEach(function(b){
            b.classList.toggle('on',parseInt(b.dataset.v,10)<=v);
        });
    }

    window.submitConfirmReceived=function(){
        var btn=document.getElementById('rmConfirmBtn');
        btn.disabled=true;btn.textContent='Đang xử lý...';
        var review=document.getElementById('rmReviewText').value.trim();
        var body='_csrf='+encodeURIComponent('${sessionScope._csrf}')+'&orderId='+currentCancelOid;
        if(rmSelectedStars>0) body+='&rating='+rmSelectedStars;
        if(review) body+='&review='+encodeURIComponent(review);
        fetch(CTX+'/account/order/confirm',{
            method:'POST',
            headers:{'Content-Type':'application/x-www-form-urlencoded','X-Requested-With':'XMLHttpRequest'},
            body:body
        }).then(function(r){return r.json()}).then(function(d){
            var msg=document.getElementById('rmMsg');
            if(d.success){
                msg.className='cm-msg success';
                msg.textContent=d.message;
                setTimeout(function(){closeRateModal();closeOrderOverlay();location.reload()},1200);
            } else {
                msg.className='cm-msg error';
                msg.textContent=d.error||'Có lỗi xảy ra';
                btn.disabled=false;btn.textContent='Xác nhận';
            }
        }).catch(function(){
            var msg=document.getElementById('rmMsg');
            msg.className='cm-msg error';msg.textContent='Lỗi kết nối. Vui lòng thử lại.';
            btn.disabled=false;btn.textContent='Xác nhận';
        });
    };

    var allergyToNut={dau_phong:'dau_phong',hanh_nhan:'hanh_nhan'};

    function syncAllergyNutConflict(){
        var activeAllergies=[];
        document.querySelectorAll('#allergyChips .chip.sel').forEach(function(c){activeAllergies.push(c.getAttribute('data-allergy'))});
        document.querySelectorAll('#nutChips .chip').forEach(function(c){
            var nut=c.getAttribute('data-nut');
            var blocked=false;
            for(var a in allergyToNut){if(allergyToNut[a]===nut && activeAllergies.indexOf(a)>=0){blocked=true;break}}
            if(blocked){c.classList.remove('sel');c.classList.add('disabled')}
            else{c.classList.remove('disabled')}
        });
    }

    var taste=JSON.parse(localStorage.getItem('purenut_taste')||'{}');
    var sweetBar=document.getElementById('sweetBar');
    if(taste.sweetness!==undefined){sweetBar.querySelectorAll('button').forEach(function(b){b.classList.remove('sel')});var s=sweetBar.querySelector('[data-val="'+taste.sweetness+'"]');if(s)s.classList.add('sel')}
    sweetBar.querySelectorAll('button').forEach(function(b){b.addEventListener('click',function(){sweetBar.querySelectorAll('button').forEach(function(x){x.classList.remove('sel')});this.classList.add('sel')})});
    var nuts=taste.nuts||[];document.querySelectorAll('#nutChips .chip').forEach(function(c){if(nuts.indexOf(c.getAttribute('data-nut'))>=0)c.classList.add('sel');c.addEventListener('click',function(){if(!this.classList.contains('disabled'))this.classList.toggle('sel')})});
    var allergies=taste.allergies||[];document.querySelectorAll('#allergyChips .chip').forEach(function(c){if(allergies.indexOf(c.getAttribute('data-allergy'))>=0)c.classList.add('sel');c.addEventListener('click',function(){this.classList.toggle('sel');syncAllergyNutConflict()})});
    syncAllergyNutConflict();

    window.saveTaste=function(){
        var sw=sweetBar.querySelector('.sel'),sn=[],sa=[];
        document.querySelectorAll('#nutChips .chip.sel').forEach(function(c){sn.push(c.getAttribute('data-nut'))});
        document.querySelectorAll('#allergyChips .chip.sel').forEach(function(c){sa.push(c.getAttribute('data-allergy'))});
        localStorage.setItem('purenut_taste',JSON.stringify({sweetness:sw?sw.getAttribute('data-val'):'50',nuts:sn,allergies:sa}));
        var sv=document.getElementById('tasteSaved');sv.classList.add('show');setTimeout(function(){sv.classList.remove('show')},2500);
    };
    var pinIcon=L.divIcon({className:'',html:'<div style="position:relative;width:30px;height:45px;filter:drop-shadow(0 3px 4px rgba(0,0,0,.35));transition:transform .3s cubic-bezier(.34,1.56,.64,1)" id="pinSvg"><svg width="30" height="45" viewBox="0 0 30 45" xmlns="http://www.w3.org/2000/svg"><path d="M15 0C6.7 0 0 6.7 0 15c0 11.25 15 30 15 30s15-18.75 15-30C30 6.7 23.3 0 15 0z" fill="#CE2E2E"/><circle cx="15" cy="14" r="6" fill="#fff"/></svg></div>',iconSize:[30,45],iconAnchor:[15,45],popupAnchor:[0,-40]});
    var addrMap=null,addrMarker=null;
    function reverseGeoFill(lat,lng){
        fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat='+lat+'&lon='+lng+'&accept-language=vi&addressdetails=1')
        .then(function(r){return r.json()}).then(function(d){
            var a=d.address||{};
            document.getElementById('addrProvince').value=a.city||a.state||a.province||'';
            document.getElementById('addrDistrict').value=a.county||a.suburb||a.city_district||'';
            document.getElementById('addrWard').value=a.quarter||a.village||a.town||a.neighbourhood||'';
            document.getElementById('addrStreet').value=(a.house_number?a.house_number+' ':'')+(a.road||'');
            if(addrMarker){var short=(a.road||'')+(a.quarter?', '+a.quarter:'');addrMarker.bindPopup('<b>'+short+'</b><br><small>Kéo ghim để chỉnh vị trí</small>').openPopup()}
        }).catch(function(){});
    }
    function showMap(lat,lng){
        var mapDiv=document.getElementById('addrMap');mapDiv.style.display='block';
        if(!addrMap){
            addrMap=L.map('addrMap').setView([lat,lng],17);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:19,attribution:'&copy; OpenStreetMap'}).addTo(addrMap);
            addrMarker=L.marker([lat,lng],{draggable:true,icon:pinIcon}).addTo(addrMap);
            addrMarker.on('dragstart',function(){var el=addrMarker._icon.querySelector('div');if(el){el.style.transform='translateY(-12px) scale(1.15)';el.style.filter='drop-shadow(0 8px 8px rgba(0,0,0,.3))'}});
            addrMarker.on('dragend',function(){var el=addrMarker._icon.querySelector('div');if(el){el.style.transform='translateY(0) scale(1)';el.style.filter='drop-shadow(0 3px 4px rgba(0,0,0,.35))'}var p=addrMarker.getLatLng();reverseGeoFill(p.lat,p.lng)});
        }else{addrMap.setView([lat,lng],17);addrMarker.setLatLng([lat,lng])}
        setTimeout(function(){addrMap.invalidateSize()},100);
    }
    window.geoLocate=function(){
        var btn=document.getElementById('geoLocBtn'),txt=document.getElementById('geoLocText');
        if(!navigator.geolocation){txt.textContent='Trình duyệt không hỗ trợ định vị';return}
        txt.textContent='Đang định vị...';btn.disabled=true;btn.style.opacity='.6';
        navigator.geolocation.getCurrentPosition(function(pos){
            var lat=pos.coords.latitude,lng=pos.coords.longitude;
            reverseGeoFill(lat,lng);
            showMap(lat,lng);
            txt.textContent='Kéo ghim 📍 trên bản đồ để chỉnh vị trí';btn.style.opacity='1';btn.disabled=false;
            btn.style.borderColor='var(--green)';btn.style.color='var(--green)';
        },function(err){
            var msg='Không thể định vị';
            if(err.code===1)msg='Bạn đã từ chối quyền truy cập vị trí';
            else if(err.code===2)msg='Không tìm thấy vị trí';
            else if(err.code===3)msg='Hết thời gian chờ';
            txt.textContent=msg;btn.style.opacity='1';btn.disabled=false;
        },{enableHighAccuracy:true,timeout:15000,maximumAge:0});
    };
})();
</script>
</body>
</html>
