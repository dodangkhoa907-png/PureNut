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
        display:grid;grid-template-columns:repeat(4,1fr);gap:14px;
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
    .promo-c.p2{background:linear-gradient(135deg,#2BAC62 0%,#34D399 100%)}
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

    /* ── Order Table ── */
    .o-table{width:100%;border-collapse:separate;border-spacing:0}
    .o-table th{padding:13px 16px;text-align:left;font-size:11px;font-weight:800;color:var(--navy);text-transform:uppercase;letter-spacing:.06em;border-bottom:2px solid rgba(27,79,158,.1);background:rgba(27,79,158,.02)}
    .o-table th:first-child{border-radius:12px 0 0 0}.o-table th:last-child{border-radius:0 12px 0 0}
    .o-table td{padding:15px 16px;font-size:14px;font-weight:500;color:var(--ink);border-bottom:1px solid rgba(0,0,0,.03)}
    .o-table tbody tr{transition:background .12s}.o-table tbody tr:hover{background:rgba(27,79,158,.02)}
    .o-id{font-weight:800;color:var(--navy)}
    .o-price{font-weight:700}
    .s-pill{display:inline-flex;align-items:center;gap:5px;padding:5px 13px;border-radius:99px;font-size:11.5px;font-weight:700}
    .s-pill .s-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0}
    .s-PENDING{background:rgba(245,165,36,.1);color:#D48806}.s-PENDING .s-dot{background:#D48806}
    .s-CONFIRMED{background:rgba(57,101,255,.1);color:#3965FF}.s-CONFIRMED .s-dot{background:#3965FF}
    .s-SHIPPING{background:rgba(122,90,248,.1);color:#7A5AF8}.s-SHIPPING .s-dot{background:#7A5AF8}
    .s-DONE{background:rgba(43,172,98,.1);color:#12B76A}.s-DONE .s-dot{background:#12B76A}
    .s-CANCELLED{background:rgba(206,46,46,.1);color:#CE2E2E}.s-CANCELLED .s-dot{background:#CE2E2E}

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
        .acc-stats{grid-template-columns:repeat(2,1fr);margin-top:-24px}
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
        .acc-stats{grid-template-columns:repeat(2,1fr);gap:8px;padding:0 14px;margin-top:-20px}
        .st-card{padding:12px 10px;gap:6px;border-radius:12px}.st-val{font-size:16px}
        .st-ic{width:36px;height:36px;border-radius:9px}.st-ic svg{width:18px;height:18px}
        .st-lb{font-size:10.5px}
        .acc-card{padding:16px 12px;border-radius:14px}
        .acc-card-h{flex-direction:column;align-items:flex-start;gap:6px}
        .acc-card-t{font-size:15px}
        .ban-avatar{width:46px;height:46px;font-size:18px;border-width:2px}
        .ban-avatar .av-dot{width:11px;height:11px;border-width:2px}
        .ban-info h1{font-size:16px}
        .ban-inner{gap:12px}
        .ban-meta{gap:5px;flex-wrap:wrap}
        .ban-meta span{font-size:10.5px}
        .ban-meta svg{width:11px;height:11px}
        .acc-banner{padding:16px 12px 36px}
        .ban-deco{display:none}
        .acc-body{padding:0 10px;margin-top:14px}
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
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<main class="acc-page">

<!-- ════════ BANNER ════════ -->
<div class="acc-banner">
    <div class="ban-deco">PureNut</div>
    <div class="ban-inner" style="max-width:var(--container);margin:0 auto">
        <div class="ban-avatar">
            ${fn:substring(sessionScope.user.fullName, 0, 1)}
            <span class="av-dot"></span>
        </div>
        <div class="ban-info">
            <h1>${sessionScope.user.fullName}</h1>
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
                <span><svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>${sessionScope.user.email}</span>
                <span><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>${sessionScope.user.phone}</span>
                <span><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>Từ <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MM/yyyy"/></span>
            </div>
        </div>
    </div>
</div>

<!-- ════════ STATS ════════ -->
<div class="acc-stats">
    <div class="st-card c1"><div class="st-ic c1"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></div><div><div class="st-lb">Tổng đơn hàng</div><div class="st-val acc-num">${totalOrders}</div></div></div>
    <div class="st-card c2"><div class="st-ic c2"><svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div><div><div class="st-lb">Tích lũy chi tiêu</div><div class="st-val acc-num"><fmt:formatNumber value="${totalSpent}" type="number" maxFractionDigits="0"/>đ</div></div></div>
    <div class="st-card c3"><div class="st-ic c3"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div><div><div class="st-lb">Hoàn thành</div><div class="st-val acc-num">${doneCount}</div></div></div>
    <div class="st-card c4"><div class="st-ic c4"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><div><div class="st-lb">Đang xử lý</div><div class="st-val acc-num">${pendingCount}</div></div></div>
</div>

<!-- ════════ Mobile Strip ════════ -->
<div class="mob-strip" id="mobStrip">
    <button class="mob-btn active" data-tab="overview"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>Tổng quan</button>
    <button class="mob-btn" data-tab="orders"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/></svg>Đơn hàng</button>
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
        <li><a href="#" class="active" data-tab="overview"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>Tổng quan</a></li>
        <li><a href="#" data-tab="orders"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>Lịch sử đơn hàng<c:if test="${pendingCount > 0}"><span class="side-badge">${pendingCount}</span></c:if></a></li>
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
        <a href="${pageContext.request.contextPath}/about#dai-ly" class="promo-c p2">
            <div class="promo-ic"><svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
            <div><div class="promo-tt">Trở thành Đại lý</div><div class="promo-ds">Hợp tác kinh doanh PureNut</div></div>
        </a>
    </div>

    <!-- Đơn hàng gần đây -->
    <div class="acc-card">
        <div class="acc-card-h">
            <div class="acc-card-t">
                <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                Đơn hàng của bạn
            </div>
            <c:if test="${not empty orderHistory}">
                <a href="#" class="tab-link" data-tab="orders">Xem tất cả <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty orderHistory}">
                <div class="acc-empty">
                    <div class="acc-empty-ic">
                        <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                    </div>
                    <p>Bạn chưa có đơn hàng nào.<br><span style="font-size:13.5px;color:var(--sand)">Đặt hàng ngay để thưởng thức sữa hạt tươi mỗi ngày nhé!</span></p>
                    <a href="${pageContext.request.contextPath}/products" style="display:inline-flex;align-items:center;gap:8px;padding:13px 28px;border-radius:99px;background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;font-size:14.5px;font-weight:700;box-shadow:0 8px 22px -8px rgba(27,79,158,.45);transition:transform .2s,box-shadow .2s;text-decoration:none">
                        <svg viewBox="0 0 24 24" style="width:18px;height:18px;stroke:#fff;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
                        Mua sắm ngay
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:set var="hasActive" value="false"/>
                <c:forEach var="o" items="${orderHistory}">
                    <c:if test="${o.status == 'PENDING' || o.status == 'CONFIRMED' || o.status == 'SHIPPING'}">
                        <c:set var="hasActive" value="true"/>
                        <div class="ov-order-card ${o.status == 'SHIPPING' ? 'ov-shipping' : ''}">
                            <div class="ov-order-top">
                                <div class="ov-order-id">
                                    <c:choose>
                                        <c:when test="${o.status == 'SHIPPING'}">
                                            <svg viewBox="0 0 24 24" class="ov-truck"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
                                        </c:when>
                                        <c:otherwise>
                                            <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                                        </c:otherwise>
                                    </c:choose>
                                    <span>Đơn hàng <strong>#${o.orderId}</strong></span>
                                </div>
                                <span class="s-pill s-${o.status}"><span class="s-dot"></span>
                                    <c:choose>
                                        <c:when test="${o.status == 'PENDING'}">Chờ xác nhận</c:when>
                                        <c:when test="${o.status == 'CONFIRMED'}">Đã xác nhận</c:when>
                                        <c:when test="${o.status == 'SHIPPING'}">Đang giao hàng</c:when>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="ov-order-detail">
                                <span><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/> · <strong class="acc-num"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</strong></span>
                                <span style="font-size:12.5px;color:var(--ink-soft)">${o.paymentMethod == 'COD' ? 'Thanh toán khi nhận hàng' : 'Chuyển khoản'}</span>
                            </div>
                            <div class="order-track">
                                <div class="track-timeline">
                                    <div class="tl-step done"><div class="tl-dot"></div><div class="tl-label">Đơn mới</div></div>
                                    <div class="tl-line done"></div>
                                    <div class="tl-step ${o.status == 'CONFIRMED' ? 'active' : (o.status == 'SHIPPING' ? 'done' : '')}"><div class="tl-dot"></div><div class="tl-label">Đã xác nhận</div></div>
                                    <div class="tl-line ${o.status == 'SHIPPING' ? 'done' : ''}"></div>
                                    <div class="tl-step ${o.status == 'SHIPPING' ? 'active' : ''}"><div class="tl-dot"></div><div class="tl-label">Đang giao</div></div>
                                    <div class="tl-line"></div>
                                    <div class="tl-step"><div class="tl-dot"></div><div class="tl-label">Giao thành công</div></div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasActive}">
                    <div class="acc-empty" style="padding:30px 20px">
                        <div class="acc-empty-ic" style="width:64px;height:64px;margin-bottom:14px">
                            <svg viewBox="0 0 24 24" style="width:28px;height:28px"><polyline points="20 6 9 17 4 12"/></svg>
                        </div>
                        <p style="margin-bottom:10px">Tất cả đơn hàng đã hoàn thành! <a href="#" data-tab="orders" style="color:var(--navy);font-weight:700;text-decoration:underline">Xem lịch sử</a></p>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ═══ TAB: Đơn hàng ═══ -->
<div id="tab-orders" class="acc-tab">
    <div class="acc-card">
        <div class="acc-card-h">
            <div class="acc-card-t"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>Đơn hàng của tôi</div>
            <c:if test="${not empty orderHistory}"><span style="font-size:13px;color:var(--ink-soft);font-weight:600">${totalOrders} đơn</span></c:if>
        </div>
        <c:choose>
            <c:when test="${empty orderHistory}">
                <div class="acc-empty">
                    <div class="acc-empty-ic"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></div>
                    <p>Bạn chưa có đơn hàng nào.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Mua sắm ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="overflow-x:auto">
                    <table class="o-table">
                        <thead><tr><th>Mã ĐH</th><th>Ngày đặt</th><th>Tổng tiền</th><th>Thanh toán</th><th>Trạng thái</th></tr></thead>
                        <tbody>
                        <c:forEach var="o" items="${orderHistory}">
                            <tr>
                                <td class="o-id">#${o.orderId}</td>
                                <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/></td>
                                <td class="o-price"><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>đ</td>
                                <td>${o.paymentMethod == 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}</td>
                                <td><span class="s-pill s-${o.status}"><span class="s-dot"></span><c:choose><c:when test="${o.status == 'PENDING'}">Chờ xác nhận</c:when><c:when test="${o.status == 'CONFIRMED'}">Đã xác nhận</c:when><c:when test="${o.status == 'SHIPPING'}">Đang giao</c:when><c:when test="${o.status == 'DONE'}">Hoàn thành</c:when><c:when test="${o.status == 'CANCELLED'}">Đã hủy</c:when><c:otherwise>${o.status}</c:otherwise></c:choose></span></td>
                            </tr>
                            <c:if test="${o.status == 'SHIPPING' || o.status == 'CONFIRMED' || o.status == 'DONE'}">
                            <tr><td colspan="5" style="padding:0;border:none">
                                <div class="order-track">
                                    <div class="track-timeline">
                                        <div class="tl-step done"><div class="tl-dot"></div><div class="tl-label">Đơn mới</div></div>
                                        <div class="tl-line done"></div>
                                        <div class="tl-step ${o.status == 'CONFIRMED' ? 'active' : 'done'}"><div class="tl-dot"></div><div class="tl-label">Đã xác nhận</div></div>
                                        <div class="tl-line ${o.status == 'SHIPPING' || o.status == 'DONE' ? 'done' : ''}"></div>
                                        <div class="tl-step ${o.status == 'SHIPPING' ? 'active' : (o.status == 'DONE' ? 'done' : '')}"><div class="tl-dot"></div><div class="tl-label">Đang giao</div></div>
                                        <div class="tl-line ${o.status == 'DONE' ? 'done' : ''}"></div>
                                        <div class="tl-step ${o.status == 'DONE' ? 'done' : ''}"><div class="tl-dot"></div><div class="tl-label">Giao thành công</div></div>
                                    </div>
                                </div>
                            </td></tr>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
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
                            <span class="ov-avatar-initial" id="avatarInitial">${fn:substring(sessionScope.user.fullName, 0, 1)}</span>
                        </div>
                        <div class="ov-avatar-cam">
                            <svg viewBox="0 0 24 24"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                        </div>
                    </div>
                    <input type="file" id="avatarInput" accept="image/*" style="display:none" onchange="previewAvatar(this)">
                    <div class="ov-avatar-hint">Nhấn vào ảnh để thay đổi</div>
                </div>

                <div class="ov-field"><label class="ov-label">Nickname (Tên hiển thị)</label><input type="text" class="ov-input" id="profNickname" value="" placeholder="Tên của bạn"></div>
                <div class="ov-field"><label class="ov-label">Họ và tên</label><input type="text" class="ov-input" id="profName" value="${sessionScope.user.fullName}"></div>
                <div class="ov-field"><label class="ov-label">Email</label><input type="email" class="ov-input" id="profEmail" value="${sessionScope.user.email}" readonly></div>
                <div class="ov-field"><label class="ov-label">Số điện thoại</label><input type="tel" class="ov-input" id="profPhone" value="${sessionScope.user.phone}" pattern="0[0-9]{9,10}" maxlength="11"></div>
                <div class="ov-field"><label class="ov-label">Ngày tham gia</label><input type="text" class="ov-input" value="<fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy"/>" readonly></div>
                <button class="ov-btn primary" onclick="saveProfile()">Lưu thay đổi</button>
            </div>

            <!-- Địa chỉ -->
            <div id="otab-address" class="ov-pane">
                <div class="ov-msg" id="addrMsg"></div>
                <div id="addrList">
                    <c:forEach var="addr" items="${addresses}">
                        <div class="addr-card" data-id="${addr.addressId}">
                            <div class="addr-label">${addr.label}<c:if test="${addr.isDefault()}"><span class="def-badge">Mặc định</span></c:if></div>
                            <div class="addr-name">${addr.recipientName} · ${addr.phone}</div>
                            <div class="addr-detail">${addr.fullAddress}</div>
                            <div class="addr-actions"><button title="Xóa" onclick="deleteAddr(${addr.addressId})"><svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></button></div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty addresses}"><p style="color:var(--ink-soft);font-size:14px;margin-bottom:14px">Chưa có địa chỉ nào được lưu.</p></c:if>
                </div>
                <div class="addr-add-form">
                    <div class="form-title"><svg viewBox="0 0 24 24" style="width:18px;height:18px;stroke:var(--navy);fill:none;stroke-width:2;stroke-linecap:round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Thêm địa chỉ mới</div>
                    <div class="addr-row" style="margin-bottom:14px">
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Nhãn</label><select class="ov-input" id="addrLabel"><option>Nhà riêng</option><option>Công ty</option><option>Khác</option></select></div>
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Người nhận</label><input type="text" class="ov-input" id="addrName" placeholder="${sessionScope.user.fullName}"></div>
                    </div>
                    <div class="addr-row" style="margin-bottom:14px">
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">SĐT</label><input type="tel" class="ov-input" id="addrPhone" placeholder="${sessionScope.user.phone}" pattern="0[0-9]{9,10}"></div>
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Tỉnh / Thành phố</label><input type="text" class="ov-input" id="addrProvince" placeholder="TP. Hồ Chí Minh"></div>
                    </div>
                    <div class="addr-row" style="margin-bottom:14px">
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Quận / Huyện</label><input type="text" class="ov-input" id="addrDistrict"></div>
                        <div class="ov-field" style="margin-bottom:0"><label class="ov-label">Phường / Xã</label><input type="text" class="ov-input" id="addrWard"></div>
                    </div>
                    <div class="ov-field"><label class="ov-label">Số nhà, đường</label><input type="text" class="ov-input" id="addrStreet" placeholder="123 Nguyễn Văn A"></div>
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
                <div class="ov-field"><label class="ov-label">Mật khẩu hiện tại</label><input type="password" class="ov-input" id="secOldPw"></div>
                <div class="ov-field"><label class="ov-label">Mật khẩu mới</label><input type="password" class="ov-input" id="secNewPw"><div style="font-size:11.5px;color:var(--ink-soft);margin-top:5px">Ít nhất 8 ký tự, gồm hoa, thường, số và ký tự đặc biệt.</div></div>
                <div class="ov-field"><label class="ov-label">Xác nhận mật khẩu mới</label><input type="password" class="ov-input" id="secConfirmPw"></div>
                <button class="ov-btn primary" onclick="changePw()">Đổi mật khẩu</button>
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
        var fd=new FormData();for(var k in data)fd.append(k,data[k]);
        fetch(CTX+url,{method:'POST',body:fd}).then(function(r){return r.json().then(function(j){cb(r.ok,j)})}).catch(function(){cb(false,{error:'Lỗi kết nối.'})});
    }
    function showMsg(id,ok,text){var el=document.getElementById(id);el.className='ov-msg '+(ok?'ok':'err');el.textContent=text}

    /* Avatar preview */
    window.previewAvatar=function(input){
        if(input.files && input.files[0]){
            var reader=new FileReader();
            reader.onload=function(e){
                var wrap=document.getElementById('ovAvatarPreview');
                wrap.innerHTML='<img src="'+e.target.result+'" alt="Avatar" id="avatarImg" style="width:100%;height:100%;object-fit:cover">';
            };
            reader.readAsDataURL(input.files[0]);
        }
    };

    window.saveProfile=function(){
        var n=document.getElementById('profName').value.trim(),p=document.getElementById('profPhone').value.trim();
        var nick=document.getElementById('profNickname')?document.getElementById('profNickname').value.trim():'';
        if(!n){showMsg('profileMsg',false,'Vui lòng nhập họ tên.');return}
        if(!/^0[0-9]{9,10}$/.test(p)){showMsg('profileMsg',false,'SĐT không hợp lệ.');return}
        var data={fullName:n,phone:p};
        if(nick) data.nickname=nick;
        /* Upload avatar nếu có */
        var avatarFile=document.getElementById('avatarInput').files[0];
        if(avatarFile) data.avatar=avatarFile;
        post('/account/profile',data,function(ok,j){
            showMsg('profileMsg',ok,ok?'Đã lưu thông tin!':j.error);
            if(ok){document.querySelector('.ban-info h1').textContent=n;document.querySelector('.ban-avatar').childNodes[0].textContent=n.charAt(0)}
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
})();
</script>
</body>
</html>
