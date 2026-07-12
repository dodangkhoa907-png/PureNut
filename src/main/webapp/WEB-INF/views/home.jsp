<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PureNut — Sữa Hạt Thuần Khiết Từ Hạt Việt</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700;0,9..144,800;1,9..144,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{
  --navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;
  --cream:#FBF6EC;--paper:#FFFDF8;--sand:#E9DCBE;--sand-deep:#D9C7A0;
  --ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);
  --dark:#0B1B3D;--dark-2:#0E2148;--dark-3:#122A55;
  --gold:#F3D98B;--gold-bright:#FFD95A;
  --lab-bg:#0B1B3D;--lab-card:rgba(255,255,255,.03);--lab-cream:#F6F4EE;--lab-red:#B71C1C;
  --fd:'Fraunces',serif;--fb:'Inter',sans-serif;
  --r:16px;--r-lg:26px;--container:1180px;
  --shadow:0 18px 40px -18px rgba(20,30,20,.22);--shadow-sm:0 10px 28px -14px rgba(20,30,20,.18);
}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased}
img{max-width:100%;display:block}a{text-decoration:none;color:inherit}ul{list-style:none}button{font:inherit;cursor:pointer;border:none;background:none}
h1,h2,h3{font-family:var(--fd);font-weight:600;letter-spacing:-.01em;line-height:1.12}
.container{max-width:var(--container);margin:0 auto;padding:0 26px}
.rv{opacity:0;transform:translateY(30px);transition:opacity .8s cubic-bezier(.2,.7,.2,1),transform .8s cubic-bezier(.2,.7,.2,1)}
.rv.in{opacity:1;transform:none}
.eyebrow{display:inline-block;font-weight:700;letter-spacing:.12em;text-transform:uppercase;font-size:12px;margin-bottom:14px}
.btn{display:inline-flex;align-items:center;gap:8px;padding:14px 28px;border-radius:99px;font-weight:600;font-size:15px;transition:transform .25s,box-shadow .25s,background .2s}
.btn-primary{background:var(--navy);color:#fff;box-shadow:0 12px 26px -12px rgba(27,79,158,.6)}
.btn-primary:hover{transform:translateY(-2px)}
.btn-ghost{background:transparent;color:var(--ink);border:1.5px solid var(--ink)}
.btn-ghost:hover{background:var(--ink);color:#fff;transform:translateY(-2px)}
.btn-red{background:var(--red);color:#fff;box-shadow:0 12px 26px -12px rgba(206,46,46,.55)}
.btn-red:hover{transform:translateY(-2px)}
.btn-white{background:#fff;color:var(--dark);font-weight:700;box-shadow:0 12px 30px -12px rgba(0,0,0,.3)}
.btn-white:hover{transform:translateY(-3px);box-shadow:0 18px 40px -14px rgba(0,0,0,.4)}
.btn-outline-light{border:1.5px solid rgba(255,255,255,.4);color:#fff;background:transparent}
.btn-outline-light:hover{background:#fff;color:var(--dark);transform:translateY(-2px)}

/* =================== 1. HERO =================== */
.hro{position:relative;min-height:100vh;display:flex;align-items:center;overflow:hidden;background:linear-gradient(135deg,#FEFCF7 0%,var(--cream) 40%,#F0E7D1 100%);padding:100px 0 60px}
.hro::after{content:'';position:absolute;bottom:0;left:0;right:0;height:200px;background:linear-gradient(to bottom,transparent,var(--cream));pointer-events:none}
.hro-in{position:relative;z-index:2;display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center}
.hro-txt .eyebrow{color:var(--red)}
.hro-txt h1{font-size:clamp(36px,5.2vw,62px);font-weight:800;margin-bottom:22px;line-height:1.06}
.hro-txt h1 em{font-style:normal;color:var(--navy)}
.hro-txt h1 .accent{display:block;background:linear-gradient(135deg,var(--navy),var(--red));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.hro-txt p{font-size:17px;color:var(--ink-soft);max-width:480px;margin-bottom:30px;line-height:1.7}
.hro-cta{display:flex;gap:14px;flex-wrap:wrap}
.hro-scene{position:relative;display:flex;align-items:center;justify-content:center;perspective:1000px}
.hro-product{width:min(100%,380px);aspect-ratio:3/4;position:relative;transform-style:preserve-3d;transition:transform .5s cubic-bezier(.2,.7,.2,1);will-change:transform;cursor:grab}
.hro-product:active{cursor:grabbing}
.hro-bottle{width:100%;height:100%;border-radius:var(--r-lg);overflow:hidden;background:linear-gradient(160deg,#F5ECD7,var(--sand));box-shadow:0 40px 80px -20px rgba(20,30,20,.25),0 0 0 1px rgba(255,255,255,.6) inset;position:relative;transform-style:preserve-3d}
.hro-bottle img{width:100%;height:100%;object-fit:cover;border-radius:var(--r-lg)}
.hro-bottle::after{content:'';position:absolute;inset:0;background:linear-gradient(135deg,rgba(255,255,255,.35) 0%,transparent 50%,rgba(0,0,0,.06) 100%);border-radius:var(--r-lg);pointer-events:none}
.hro-badge{position:absolute;top:-16px;left:-16px;width:100px;height:100px;border-radius:50%;background:var(--red);color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;font-size:11px;font-weight:700;line-height:1.35;box-shadow:0 14px 30px -10px rgba(206,46,46,.6);border:2px dashed rgba(255,255,255,.5);z-index:3;animation:badge-bob 4s ease-in-out infinite}
@keyframes badge-bob{0%,100%{transform:rotate(-5deg) translateY(0)}50%{transform:rotate(5deg) translateY(-6px)}}

.hro-float{position:absolute;border-radius:50%;opacity:.6;animation:hf 6s ease-in-out infinite;pointer-events:none;z-index:1}
.hf1{width:80px;height:80px;background:radial-gradient(circle,rgba(243,217,139,.7),transparent);top:10%;right:-20px;animation-delay:0s}
.hf2{width:60px;height:60px;background:radial-gradient(circle,rgba(206,46,46,.2),transparent);bottom:20%;left:-30px;animation-delay:1.5s}
.hf3{width:110px;height:110px;background:radial-gradient(circle,rgba(27,79,158,.12),transparent);top:60%;right:-40px;animation-delay:3s}
@keyframes hf{0%,100%{transform:translateY(0) scale(1)}50%{transform:translateY(-16px) scale(1.08)}}

/* =================== 2. MARQUEE =================== */
.marq{background:var(--dark);color:var(--gold);overflow:hidden;padding:16px 0;white-space:nowrap;position:relative;z-index:3}
.marq-track{display:inline-flex;gap:44px;animation:marq 28s linear infinite;font-weight:700;font-size:13.5px;letter-spacing:.08em;text-transform:uppercase}
.marq-track span{display:inline-flex;align-items:center;gap:10px}
.marq-track i{font-style:normal;opacity:.35}
@keyframes marq{to{transform:translateX(-50%)}}

/* =================== 3. TECH SPECS =================== */
.specs{background:linear-gradient(160deg,var(--navy-darker),var(--navy-dark));padding:0;position:relative;z-index:2}
.specs-row{display:grid;grid-template-columns:repeat(4,1fr);max-width:var(--container);margin:0 auto}
.spec{padding:44px 30px;text-align:center;border-right:1px solid rgba(255,255,255,.08);position:relative;overflow:hidden;transition:background .3s}
.spec:last-child{border-right:none}
.spec:hover{background:rgba(255,255,255,.04)}
.spec-val{font-family:var(--fd);font-size:clamp(32px,4vw,48px);font-weight:800;color:#fff;line-height:1;margin-bottom:6px}
.spec-val em{font-style:normal;color:var(--gold)}
.spec-lbl{font-size:13px;color:rgba(255,255,255,.55);font-weight:600;text-transform:uppercase;letter-spacing:.06em}
.spec-sub{font-size:11.5px;color:rgba(255,255,255,.3);margin-top:4px}

/* =================== 4. EXPLODED VIEW =================== */
.exploded{padding:100px 0;background:var(--paper);position:relative;overflow:hidden}
.exploded::before{content:'';position:absolute;top:-100px;right:-200px;width:500px;height:500px;border-radius:50%;background:radial-gradient(circle,rgba(243,217,139,.2),transparent);pointer-events:none}
.exp-head{text-align:center;margin-bottom:60px}
.exp-head .eyebrow{color:var(--navy)}
.exp-head h2{font-size:clamp(28px,4vw,44px)}
.exp-head p{color:var(--ink-soft);margin-top:10px;max-width:520px;margin-left:auto;margin-right:auto}
.exp-grid{display:grid;grid-template-columns:1fr 280px 1fr;gap:40px;align-items:center;max-width:960px;margin:0 auto}
.exp-left,.exp-right{display:flex;flex-direction:column;gap:28px}
.exp-item{display:flex;align-items:flex-start;gap:14px;padding:18px 20px;background:var(--cream);border-radius:18px;border:1px solid var(--line);transition:transform .3s,box-shadow .3s}
.exp-item:hover{transform:translateY(-4px);box-shadow:var(--shadow-sm)}
.exp-left .exp-item{flex-direction:row-reverse;text-align:right}
.exp-ic{width:44px;height:44px;border-radius:12px;background:var(--paper);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:22px;box-shadow:0 4px 12px -4px rgba(0,0,0,.08)}
.exp-item h4{font-family:var(--fb);font-size:14.5px;font-weight:700;margin-bottom:3px}
.exp-item p{font-size:12.5px;color:var(--ink-soft);line-height:1.5}
.exp-center{display:flex;align-items:center;justify-content:center;position:relative}
.exp-bottle{width:200px;height:320px;background:linear-gradient(180deg,#F8F0DA,var(--sand),#D4BC8A);border-radius:30px;position:relative;box-shadow:0 40px 80px -20px rgba(20,30,20,.2),0 0 0 1px rgba(255,255,255,.6) inset,-20px 0 40px -10px rgba(0,0,0,.05) inset;transform-style:preserve-3d;animation:bottle-float 5s ease-in-out infinite}
@keyframes bottle-float{0%,100%{transform:translateY(0) rotateY(0deg)}50%{transform:translateY(-10px) rotateY(3deg)}}
.exp-bottle::before{content:'PureNut';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%) rotate(-90deg);font-family:var(--fd);font-size:28px;font-weight:800;color:rgba(27,79,158,.12);letter-spacing:2px;white-space:nowrap}
.exp-bottle::after{content:'';position:absolute;inset:0;border-radius:30px;background:linear-gradient(135deg,rgba(255,255,255,.4) 0%,transparent 40%,rgba(0,0,0,.04) 100%);pointer-events:none}
.exp-line{position:absolute;width:1px;background:repeating-linear-gradient(to bottom,var(--navy) 0,var(--navy) 6px,transparent 6px,transparent 12px);z-index:1}

/* =================== 5. LIFESTYLE =================== */
.life{padding:100px 0;background:var(--cream)}
.life-block{display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center;margin-bottom:80px}
.life-block:last-child{margin-bottom:0}
.life-block.rev{direction:rtl}.life-block.rev>*{direction:ltr}
.life-img{border-radius:var(--r-lg);overflow:hidden;aspect-ratio:4/3;position:relative;background:linear-gradient(160deg,var(--sand),#D8C8A0);box-shadow:var(--shadow)}
.life-img-inner{width:100%;height:100%;display:flex;align-items:center;justify-content:center;position:relative}
.life-img-icon{font-size:72px;opacity:.7}
.life-img-overlay{position:absolute;bottom:16px;left:16px;background:rgba(255,255,255,.92);backdrop-filter:blur(10px);padding:10px 16px;border-radius:12px;font-size:12px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:6px;box-shadow:0 8px 20px -8px rgba(0,0,0,.15)}
.life-txt .eyebrow{color:var(--red)}
.life-txt h2{font-size:clamp(26px,3.4vw,38px);margin-bottom:14px}
.life-txt p{color:var(--ink-soft);font-size:16px;line-height:1.7;margin-bottom:22px}
.life-feat{display:flex;flex-direction:column;gap:10px}
.life-feat span{display:flex;align-items:center;gap:10px;font-weight:600;font-size:14px;color:var(--ink)}
.life-feat .ck{width:22px;height:22px;border-radius:50%;background:#DCF0E3;color:var(--green);display:inline-flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;flex-shrink:0}

/* =================== 6. STORE (giữ nguyên) =================== */
.sec{padding:80px 0}
.sec-head{text-align:center;max-width:620px;margin:0 auto 46px}
.sec-head h2{font-size:clamp(28px,4vw,44px)}
.sec-head p{color:var(--ink-soft);margin-top:12px}
.filter{display:flex;gap:10px;justify-content:center;flex-wrap:wrap;margin-bottom:38px}
.chip{padding:10px 20px;border-radius:99px;border:1.5px solid var(--line);font-weight:600;font-size:13.5px;color:var(--ink-soft);transition:all .2s}
.chip.on,.chip:hover{background:var(--navy);color:#fff;border-color:var(--navy)}
.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
.pcard{background:var(--paper);border-radius:var(--r-lg);overflow:hidden;border:1px solid var(--line);transition:transform .3s,box-shadow .3s;display:flex;flex-direction:column}
.pcard:hover{transform:translateY(-7px);box-shadow:var(--shadow)}
.pcard.hide{display:none}
.p-thumb{aspect-ratio:1/1;display:flex;align-items:center;justify-content:center;position:relative}
.p-thumb svg{width:44%;height:44%}
.p-tag{position:absolute;top:14px;left:14px;background:var(--red);color:#fff;font-size:11px;font-weight:700;padding:5px 12px;border-radius:99px}
.p-body{padding:20px}
.p-body h3{font-size:19px;margin-bottom:4px}
.p-body .meta{font-size:12.5px;color:var(--ink-soft);font-weight:600;margin-bottom:16px}
.p-foot{display:flex;align-items:center;justify-content:space-between;border-top:1px solid var(--line);padding-top:14px}
.p-price{font-family:var(--fd);font-weight:700;font-size:21px;color:var(--navy)}
.p-price small{font-size:13px;font-weight:400;color:var(--ink-soft)}
.add-btn{width:42px;height:42px;border-radius:12px;background:var(--navy);color:#fff;display:flex;align-items:center;justify-content:center;transition:transform .2s,background .2s}
.add-btn:hover{transform:scale(1.08);background:var(--navy-dark)}
.add-btn:disabled{opacity:.4;cursor:default}

/* =================== 7. DARK LAB — Deep Navy =================== */
.lab{background:var(--lab-bg);color:var(--lab-cream);padding:120px 0 100px;position:relative;overflow:hidden}
/* SVG wave divider top — injected via ::before with inline SVG data URI, kem color flipped */
.lab::before{content:'';position:absolute;top:-1px;left:0;right:0;height:60px;background:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 60' preserveAspectRatio='none'%3E%3Cpath d='M0,0 C360,55 1080,55 1440,0 L1440,0 L0,0 Z' fill='%23F6F4EE'/%3E%3C/svg%3E") no-repeat center top;background-size:100% 100%;pointer-events:none;z-index:2}
/* SVG wave divider bottom — same wave, not flipped */
.lab::after{content:'';position:absolute;bottom:-1px;left:0;right:0;height:60px;background:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 60' preserveAspectRatio='none'%3E%3Cpath d='M0,60 C360,5 1080,5 1440,60 L1440,60 L0,60 Z' fill='%23FBF6EC'/%3E%3C/svg%3E") no-repeat center bottom;background-size:100% 100%;pointer-events:none;z-index:2}
/* Atmospheric glow orbs */
.lab-glow{position:absolute;border-radius:50%;filter:blur(120px);pointer-events:none;z-index:0}
.lab-glow.g1{width:450px;height:450px;background:var(--lab-red);opacity:.08;top:5%;left:-8%}
.lab-glow.g2{width:380px;height:380px;background:rgba(246,244,238,.06);bottom:8%;right:-5%}
/* Header */
.lab-head{text-align:center;margin-bottom:70px;position:relative;z-index:3}
.lab-head .eyebrow{color:var(--lab-red);letter-spacing:.14em}
.lab-head h2{font-size:clamp(30px,4.4vw,50px);color:var(--lab-cream);font-weight:800}
.lab-head p{color:rgba(246,244,238,.55);margin-top:14px;max-width:540px;margin-left:auto;margin-right:auto;font-size:16px;line-height:1.7}
/* Cards grid */
.lab-steps{display:grid;grid-template-columns:repeat(3,1fr);gap:28px;position:relative;z-index:3}
/* Glassmorphism card — real glass effect */
.lab-step{background:rgba(255,255,255,.05);backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px);border:1px solid rgba(246,244,238,.08);border-radius:20px;padding:38px 30px;position:relative;overflow:hidden;transition:transform .4s cubic-bezier(.2,.7,.2,1),border-color .4s,box-shadow .4s}
.lab-step:hover{transform:translateY(-5px);border-color:rgba(183,28,28,.5);box-shadow:0 20px 50px -16px rgba(183,28,28,.2),0 0 0 1px rgba(183,28,28,.15)}
/* Top accent line on hover */
.lab-step::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--lab-red),rgba(183,28,28,.2));opacity:0;transition:opacity .4s}
.lab-step:hover::before{opacity:1}
/* Number — bright red + radial glow behind */
.lab-num{font-family:var(--fd);font-size:60px;font-weight:800;color:rgba(255,77,77,.15);position:absolute;top:16px;right:22px;line-height:1;z-index:0;transition:color .4s}
.lab-num::after{content:'';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:120px;height:120px;border-radius:50%;background:radial-gradient(circle,rgba(229,57,53,.3) 0%,rgba(11,27,61,0) 70%);pointer-events:none;z-index:-1}
.lab-step:hover .lab-num{color:rgba(255,77,77,.25)}
/* Icon container */
.lab-step-ic{width:54px;height:54px;border-radius:16px;background:rgba(183,28,28,.1);border:1px solid rgba(183,28,28,.15);display:flex;align-items:center;justify-content:center;margin-bottom:20px;position:relative;z-index:1;transition:background .3s,border-color .3s}
.lab-step:hover .lab-step-ic{background:rgba(183,28,28,.18);border-color:rgba(183,28,28,.3)}
.lab-step h3{font-size:19px;color:var(--lab-cream);margin-bottom:10px;font-weight:700;position:relative;z-index:1}
/* Paragraph — kem sáng, dễ đọc */
.lab-step p{font-size:14px;color:#F6F4EE;font-weight:450;line-height:1.7;position:relative;z-index:1;opacity:.85}
/* Badge tag — icon đỏ đun */
.lab-badge{display:inline-flex;align-items:center;gap:8px;background:rgba(246,244,238,.04);border:1px solid rgba(246,244,238,.1);border-radius:99px;padding:8px 16px;font-size:12px;font-weight:700;color:var(--lab-cream);margin-top:16px;position:relative;z-index:1;transition:border-color .3s,background .3s}
.lab-step:hover .lab-badge{border-color:rgba(183,28,28,.3);background:rgba(183,28,28,.08)}
.lab-badge svg{width:14px;height:14px;stroke:var(--lab-red)}

/* =================== 8. SMART FEATURES =================== */
.smart{padding:100px 0;background:var(--cream);overflow:hidden}
.smart-in{display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center}
.smart-phone{display:flex;justify-content:center;perspective:800px}
.phone-mock{width:240px;height:480px;background:var(--dark);border-radius:32px;padding:12px;box-shadow:0 50px 100px -30px rgba(0,0,0,.35),0 0 0 1px rgba(255,255,255,.1);position:relative;transform:rotateY(-8deg) rotateX(2deg);transition:transform .4s}
.phone-mock:hover{transform:rotateY(0deg) rotateX(0deg)}
.phone-screen{width:100%;height:100%;border-radius:22px;background:linear-gradient(180deg,var(--navy),var(--navy-darker));display:flex;flex-direction:column;align-items:center;padding:40px 16px 20px;overflow:hidden}
.phone-notch{position:absolute;top:12px;left:50%;transform:translateX(-50%);width:80px;height:22px;background:var(--dark);border-radius:0 0 14px 14px;z-index:2}
.phone-screen .ph-logo{font-family:var(--fd);font-size:18px;color:#fff;font-weight:700;margin-bottom:20px}
.phone-screen .ph-logo b{color:var(--gold)}
.ph-card{width:100%;background:rgba(255,255,255,.1);border-radius:14px;padding:14px;margin-bottom:12px;backdrop-filter:blur(10px)}
.ph-card-title{font-size:10px;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:.08em;font-weight:700;margin-bottom:6px}
.ph-card-val{font-family:var(--fd);font-size:20px;color:#fff;font-weight:700}
.ph-card-val em{font-style:normal;color:var(--gold)}
.ph-qr{width:80px;height:80px;background:#fff;border-radius:10px;display:flex;align-items:center;justify-content:center;margin:12px auto 8px}
.ph-qr-grid{width:56px;height:56px;display:grid;grid-template-columns:repeat(5,1fr);gap:2px}
.ph-qr-grid span{background:var(--dark);border-radius:1px}
.ph-qr-grid span:nth-child(even){background:transparent}
.smart-txt .eyebrow{color:var(--navy)}
.smart-txt h2{font-size:clamp(28px,3.6vw,40px);margin-bottom:14px}
.smart-txt p{color:var(--ink-soft);font-size:16px;line-height:1.7;margin-bottom:24px}
.smart-features{display:flex;flex-direction:column;gap:16px}
.sf{display:flex;align-items:flex-start;gap:14px;padding:16px 18px;background:var(--paper);border-radius:16px;border:1px solid var(--line);transition:transform .3s,box-shadow .3s}
.sf:hover{transform:translateX(6px);box-shadow:var(--shadow-sm)}
.sf-ic{width:42px;height:42px;border-radius:12px;background:var(--cream);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:20px}
.sf h4{font-family:var(--fb);font-size:14px;font-weight:700;margin-bottom:2px}
.sf p{font-size:12.5px;color:var(--ink-soft)}

/* =================== 9. TESTIMONIALS =================== */
.quotes-sec{padding:80px 0;background:var(--paper)}
.quotes{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
.quote{background:var(--cream);border:1px solid var(--line);border-radius:var(--r-lg);padding:28px;display:flex;flex-direction:column;gap:14px;transition:transform .3s,box-shadow .3s}
.quote:hover{transform:translateY(-6px);box-shadow:var(--shadow)}
.quote .strs{color:#F6AD37;font-size:15px;letter-spacing:2px}
.quote p{font-size:14.5px;color:var(--ink);line-height:1.65;font-style:italic}
.quote-who{display:flex;align-items:center;gap:11px;margin-top:auto}
.quote-ava{width:40px;height:40px;border-radius:50%;color:#fff;font-weight:700;font-size:15px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.quote-who b{display:block;font-size:13.5px}
.quote-who small{font-size:12px;color:var(--ink-soft)}

/* =================== 10. PRICING CTA =================== */
.pricing{padding:100px 0;background:linear-gradient(160deg,var(--navy),var(--navy-darker));color:#fff;position:relative;overflow:hidden}
.pricing::before{content:'';position:absolute;top:-100px;right:-100px;width:400px;height:400px;border-radius:50%;background:radial-gradient(circle,rgba(243,217,139,.1),transparent);pointer-events:none}
.pricing-head{text-align:center;margin-bottom:56px}
.pricing-head .eyebrow{color:var(--gold)}
.pricing-head h2{font-size:clamp(30px,4.4vw,48px);color:#fff}
.pricing-head p{color:rgba(255,255,255,.5);margin-top:12px;max-width:480px;margin-left:auto;margin-right:auto}
.plans{display:grid;grid-template-columns:repeat(3,1fr);gap:24px;max-width:900px;margin:0 auto}
.plan{background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.1);border-radius:24px;padding:36px 28px;text-align:center;transition:transform .35s,border-color .35s,background .35s;position:relative;backdrop-filter:blur(8px)}
.plan:hover{transform:translateY(-6px);border-color:rgba(255,255,255,.25);background:rgba(255,255,255,.1)}
.plan.pop{background:rgba(255,255,255,.12);border-color:var(--gold);box-shadow:0 0 0 1px var(--gold),0 30px 60px -20px rgba(0,0,0,.4)}
.plan.pop::before{content:'Phổ biến';position:absolute;top:-12px;left:50%;transform:translateX(-50%);background:var(--gold);color:var(--dark);font-size:11px;font-weight:800;padding:4px 14px;border-radius:99px;text-transform:uppercase;letter-spacing:.04em}
.plan-name{font-size:13px;font-weight:700;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:.08em;margin-bottom:12px}
.plan-price{font-family:var(--fd);font-size:40px;font-weight:800;color:#fff;margin-bottom:4px}
.plan-price small{font-size:16px;font-weight:500;color:rgba(255,255,255,.4)}
.plan-desc{font-size:13px;color:rgba(255,255,255,.4);margin-bottom:22px}
.plan-feats{text-align:left;margin-bottom:26px;display:flex;flex-direction:column;gap:10px}
.plan-feats span{display:flex;align-items:center;gap:8px;font-size:13.5px;color:rgba(255,255,255,.7);font-weight:500}
.plan-feats .pck{width:18px;height:18px;border-radius:50%;background:rgba(43,172,98,.2);color:var(--green);display:inline-flex;align-items:center;justify-content:center;font-size:10px;font-weight:800;flex-shrink:0}
.plan .btn{width:100%;justify-content:center}

/* =================== 11. PROMO =================== */
.promo{margin-top:-40px;position:relative;z-index:2}
.promo-card{background:var(--paper);border-radius:var(--r-lg);padding:40px;display:grid;grid-template-columns:1.2fr .8fr;gap:40px;align-items:center;box-shadow:0 30px 60px -20px rgba(20,30,20,.15);border:1px solid var(--line)}
.promo-card h2{font-size:clamp(24px,3vw,34px);margin-bottom:10px}
.promo-card h2 em{font-style:italic;color:var(--navy)}
.promo-card p{color:var(--ink-soft);margin-bottom:20px}
.ticket{background:var(--cream);border-radius:20px;padding:28px;text-align:center}
.ticket small{color:var(--ink-soft);font-weight:700;text-transform:uppercase;letter-spacing:.05em;font-size:11.5px}
.ticket .code{border:1.5px dashed var(--navy);border-radius:14px;padding:14px;font-family:var(--fd);font-weight:700;font-size:22px;color:var(--navy);letter-spacing:1.5px;margin:12px 0;cursor:pointer;transition:background .2s}
.ticket .code:hover{background:rgba(27,79,158,.06)}

/* =================== 12. FOOTER (giữ nguyên) =================== */
footer{background:var(--navy-darker);color:#C9D6EA;padding:60px 0 26px}
.foot-grid{display:grid;grid-template-columns:1.4fr 1fr 1fr 1.1fr;gap:36px;padding-bottom:34px;border-bottom:1px solid rgba(255,255,255,.1)}
.foot-grid .logo{color:#fff}.foot-grid .logo b{color:#fff}
.foot-brand p{margin-top:12px;font-size:14px;color:#9FB2CC;max-width:260px}
.foot-col h4{color:#fff;font-family:var(--fb);font-size:14px;font-weight:700;margin-bottom:14px}
.foot-col a,.foot-col p{display:block;font-size:13.5px;color:#9FB2CC;margin-bottom:9px}
.foot-col a:hover{color:#fff}
.foot-bottom{text-align:center;font-size:12.5px;color:#7E92AE;padding-top:22px}

/* =================== UTILITIES =================== */
.fly{position:fixed;z-index:300;width:24px;height:24px;border-radius:50%;background:var(--red);box-shadow:0 6px 16px rgba(0,0,0,.28);pointer-events:none;transition:transform .8s cubic-bezier(.5,-.25,.35,1),opacity .8s;will-change:transform,opacity}
.cart-ic.bump,.site-nav-icon.bump{animation:bump .45s}
@keyframes bump{0%{transform:scale(1)}40%{transform:scale(1.4)}100%{transform:scale(1)}}
.toast{position:fixed;left:50%;bottom:30px;transform:translateX(-50%) translateY(20px);background:var(--navy-darker);color:#fff;padding:14px 24px;border-radius:99px;font-weight:600;box-shadow:var(--shadow);opacity:0;pointer-events:none;transition:.3s;z-index:200;display:flex;align-items:center;gap:9px}
.toast.show{transform:translateX(-50%) translateY(0);opacity:1}
.toast .ck{background:var(--green);color:#fff;width:18px;height:18px;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-size:11px;font-weight:800}
.top-btn{position:fixed;left:22px;bottom:22px;z-index:900;width:44px;height:44px;border-radius:50%;background:var(--paper);border:1.5px solid var(--line);color:var(--navy);display:flex;align-items:center;justify-content:center;box-shadow:var(--shadow-sm);opacity:0;pointer-events:none;transform:translateY(12px);transition:opacity .3s,transform .3s}
.top-btn.show{opacity:1;pointer-events:auto;transform:translateY(0)}
.top-btn:hover{transform:translateY(-3px)}

/* =================== RESPONSIVE =================== */
@media(max-width:900px){
  .hro-in{grid-template-columns:1fr;gap:40px;text-align:center}
  .hro-txt p{margin-left:auto;margin-right:auto}
  .hro-cta{justify-content:center}
  .hro-scene{order:-1}
  .hro-product{width:260px}
  .specs-row{grid-template-columns:repeat(2,1fr)}
  .spec{border-right:none;border-bottom:1px solid rgba(255,255,255,.06);padding:30px 20px}
  .exp-grid{grid-template-columns:1fr;gap:24px}
  .exp-center{order:-1}
  .exp-left .exp-item{flex-direction:row;text-align:left}
  .life-block,.life-block.rev{grid-template-columns:1fr;gap:30px;direction:ltr}
  .smart-in{grid-template-columns:1fr;gap:40px}
  .smart-phone{order:-1}
  .plans{grid-template-columns:1fr;max-width:360px}
  .promo-card{grid-template-columns:1fr;gap:24px}
  .grid{grid-template-columns:repeat(2,1fr)}
  .quotes{grid-template-columns:1fr}
  .foot-grid{grid-template-columns:repeat(2,1fr)}
  .lab-steps{grid-template-columns:1fr;gap:18px}
}
@media(max-width:600px){
  .hro{padding:80px 0 40px;min-height:auto}
  .hro-product{width:220px}
  .hro-badge{width:80px;height:80px;font-size:10px;top:-10px;left:-10px}
  .specs-row{grid-template-columns:1fr 1fr}
  .spec{padding:24px 16px}
  .spec-val{font-size:28px}
  .grid{grid-template-columns:1fr 1fr;gap:10px}
  .p-thumb{aspect-ratio:4/3}
  .p-thumb svg{width:36%;height:36%}
  .p-body{padding:10px 12px 14px}
  .p-body h3{font-size:14px;margin-bottom:2px}
  .p-body .meta{font-size:10.5px;margin-bottom:10px}
  .p-foot{padding-top:10px}
  .p-price{font-size:15px}
  .p-price small{font-size:10px}
  .add-btn{width:34px;height:34px;border-radius:10px}
  .add-btn svg{width:18px;height:18px}
  .p-tag{font-size:9px;padding:3px 8px;top:8px;left:8px}
  .chip{padding:7px 14px;font-size:12px}
  .filter{gap:6px;margin-bottom:24px}
  .foot-grid{grid-template-columns:1fr}
  .marq-track{font-size:11.5px;gap:26px}
  .top-btn{left:14px;bottom:14px;width:38px;height:38px}
  .phone-mock{width:200px;height:400px}
  .plan{padding:28px 20px}
  .plan-price{font-size:32px}
  .life-txt h2{font-size:24px}
  .toast{font-size:13px;padding:12px 20px;left:16px;right:16px;transform:translateX(0) translateY(20px);bottom:80px}
  .toast.show{transform:translateX(0) translateY(0)}
}
</style>
<script>window.CTX = '${ctx}';</script>
</head>
<body>

<%-- ═══ NAVBAR ═══ --%>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<!-- ===================== 1. HERO ===================== -->
<section class="hro">
  <div class="container hro-in">
    <div class="hro-txt rv">
      <span class="eyebrow">● 100% thuần thực vật · sản xuất tại Việt Nam</span>
      <h1>Tinh túy hạt Việt,<br><em>đỉnh cao dinh dưỡng.</em></h1>
      <p>Trải nghiệm dòng sữa hạt nguyên bản, ép lạnh nguyên vẹn dưỡng chất. Không đường tinh luyện, không chất bảo quản.</p>
      <div class="hro-cta">
        <a href="${ctx}/products" class="btn btn-red" style="padding:16px 34px;font-size:16px">Đặt Mua Ngay — Giảm 20%</a>
        <a href="${ctx}/about" class="btn btn-ghost">Về PureNut →</a>
      </div>
    </div>
    <div class="hro-scene rv">
      <div class="hro-float hf1"></div>
      <div class="hro-float hf2"></div>
      <div class="hro-float hf3"></div>
      <div class="hro-product" id="heroProduct">
        <div class="hro-bottle">
          <img src="${ctx}/resources/img/hero.jpg" alt="Sữa hạt PureNut" onerror="this.style.display='none'">
        </div>
        <div class="hro-badge">
          <span style="font-size:10px;opacity:.85">Không</span>
          <span>chất bảo quản</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 2. MARQUEE ===================== -->
<div class="marq" aria-hidden="true">
  <div class="marq-track" id="marqTrack">
    <span>🌱 100% thuần thực vật <i>•</i></span>
    <span>🥜 Xay nguyên hạt <i>•</i></span>
    <span>🚚 Giao trong ngày nội thành <i>•</i></span>
    <span>✅ Chuẩn HACCP &amp; Halal <i>•</i></span>
    <span>💧 Không chất bảo quản <i>•</i></span>
    <span>🇻🇳 Hạt Việt Nam chọn lọc <i>•</i></span>
  </div>
</div>

<!-- ===================== 3. TECH SPECS ===================== -->
<section class="specs">
  <div class="specs-row">
    <div class="spec rv">
      <div class="spec-val">100<em>%</em></div>
      <div class="spec-lbl">Nguyên bản</div>
      <div class="spec-sub">Không pha trộn</div>
    </div>
    <div class="spec rv">
      <div class="spec-val">9<em>g</em></div>
      <div class="spec-lbl">Protein thực vật</div>
      <div class="spec-sub">Nuôi dưỡng cơ bắp</div>
    </div>
    <div class="spec rv">
      <div class="spec-val">0<em>%</em></div>
      <div class="spec-lbl">Đường tinh luyện</div>
      <div class="spec-sub">Ngọt thanh từ chà là</div>
    </div>
    <div class="spec rv">
      <div class="spec-val">24<em>h</em></div>
      <div class="spec-lbl">Giao hàng lạnh</div>
      <div class="spec-sub">Giữ trọn sự tươi mới</div>
    </div>
  </div>
</section>

<!-- ===================== 4. EXPLODED VIEW ===================== -->
<section class="exploded">
  <div class="container">
    <div class="exp-head rv">
      <span class="eyebrow">Bên trong mỗi chai</span>
      <h2>Bóc tách thành phần PureNut</h2>
      <p>Mỗi thành phần được chọn lọc kỹ lưỡng, không phụ gia, không chất tạo đặc.</p>
    </div>
    <div class="exp-grid">
      <div class="exp-left">
        <div class="exp-item rv">
          <div class="exp-ic">🥜</div>
          <div><h4>Hạt chọn lọc</h4><p>Đậu nành Non-GMO, óc chó, hạnh nhân — đạt chuẩn xuất khẩu, kiểm định từng lô.</p></div>
        </div>
        <div class="exp-item rv">
          <div class="exp-ic">💧</div>
          <div><h4>Nước khoáng kiềm</h4><p>Giữ vị thanh mát tự nhiên, cân bằng pH cho đường ruột.</p></div>
        </div>
        <div class="exp-item rv">
          <div class="exp-ic">🌿</div>
          <div><h4>Chà là nguyên chất</h4><p>Ngọt thanh tự nhiên thay thế đường tinh luyện, giàu khoáng chất.</p></div>
        </div>
      </div>
      <div class="exp-center rv">
        <div class="exp-bottle"></div>
      </div>
      <div class="exp-right">
        <div class="exp-item rv">
          <div class="exp-ic">🧊</div>
          <div><h4>Ép lạnh Cold-Pressed</h4><p>Giữ nguyên 99% enzyme và vitamin, vượt trội so với nấu thủ công.</p></div>
        </div>
        <div class="exp-item rv">
          <div class="exp-ic">🍶</div>
          <div><h4>Chai thủy tinh vô trùng</h4><p>An toàn tuyệt đối, tái sử dụng được, thân thiện môi trường.</p></div>
        </div>
        <div class="exp-item rv">
          <div class="exp-ic">❄️</div>
          <div><h4>Bảo quản lạnh 2-6°C</h4><p>Giao xe lạnh chuyên dụng, tươi mới đến tận cửa nhà bạn.</p></div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 5. LIFESTYLE ===================== -->
<section class="life">
  <div class="container">
    <div class="life-block rv">
      <div class="life-img">
        <div class="life-img-inner">
          <div class="life-img-icon">🧘‍♀️</div>
          <div class="life-img-overlay">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
            Năng lượng tức thì
          </div>
        </div>
      </div>
      <div class="life-txt">
        <span class="eyebrow">Ứng dụng trong đời sống</span>
        <h2>Nạp năng lượng tức thì</h2>
        <p>Đồng hành cùng mọi buổi tập, phục hồi cơ bắp nhẹ nhàng mà không gây đầy bụng. Protein thực vật hấp thu nhanh, cung cấp amino acid thiết yếu cho cơ thể hoạt động.</p>
        <div class="life-feat">
          <span><i class="ck">✓</i>9g protein mỗi chai 300ml</span>
          <span><i class="ck">✓</i>Dễ tiêu hóa, không đầy hơi</span>
          <span><i class="ck">✓</i>Phù hợp người tập thể dục, yoga</span>
        </div>
      </div>
    </div>
    <div class="life-block rev rv">
      <div class="life-img" style="background:linear-gradient(160deg,#E8E0D0,#C9BBA3)">
        <div class="life-img-inner">
          <div class="life-img-icon">💻</div>
          <div class="life-img-overlay">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
            Tập trung cả ngày
          </div>
        </div>
      </div>
      <div class="life-txt">
        <span class="eyebrow">Bữa sáng thông minh</span>
        <h2>Tập trung đỉnh cao</h2>
        <p>Bữa sáng tiện lợi chỉ trong 3 giây. Cung cấp Omega-3 từ hạt óc chó cho não bộ làm việc hiệu quả, giúp bạn duy trì sự tập trung suốt cả ngày dài.</p>
        <div class="life-feat">
          <span><i class="ck">✓</i>Omega-3 từ hạt óc chó tự nhiên</span>
          <span><i class="ck">✓</i>Tiện lợi — mở nắp là uống</span>
          <span><i class="ck">✓</i>Không caffeine, không gây mất ngủ</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 6. STORE (GIỮ NGUYÊN) ===================== -->
<section class="container sec">
  <div class="sec-head rv">
    <span class="eyebrow" style="color:var(--navy)">Cửa hàng</span>
    <h2>Chọn hương vị của bạn</h2>
    <p>Chai 300ml, giá thân thiện. Đặt từ 6 chai được miễn phí giao nội thành.</p>
  </div>
  <div class="filter rv">
    <button class="chip on" data-f="all">Tất cả</button>
    <button class="chip" data-f="dau-nanh">Dòng đậu nành</button>
    <button class="chip" data-f="dac-biet">Dòng đặc biệt</button>
  </div>
  <div class="grid">
    <c:forEach var="p" items="${products}">
      <article class="pcard rv" data-cat="${p.categorySlug}">
        <a href="${ctx}/products/${p.slug}">
          <div class="p-thumb" style="background:${fn:escapeXml(not empty p.bgColorHex ? p.bgColorHex : '#E9DCBE')}">
            <c:if test="${p.featured}"><span class="p-tag">⭐ Nổi bật</span></c:if>
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" fill="rgba(255,255,255,.9)"/></svg>
          </div>
        </a>
        <div class="p-body">
          <a href="${ctx}/products/${p.slug}"><h3><c:out value="${p.name}"/></h3></a>
          <div class="meta"><c:out value="${p.categoryName}"/> · ${p.volumeMl}ml · ${p.kcalPer100ml} kcal</div>
          <div class="p-foot">
            <span class="p-price">${p.formattedPrice}<small> đ</small></span>
            <c:choose>
              <c:when test="${p.stockQuantity > 0}"><button class="add-btn" data-id="${p.productId}" data-name="${fn:escapeXml(p.name)}" aria-label="Thêm"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg></button></c:when>
              <c:otherwise><button class="add-btn" disabled>—</button></c:otherwise>
            </c:choose>
          </div>
        </div>
      </article>
    </c:forEach>
  </div>
</section>

<!-- ===================== 7. DARK LAB — Chuẩn mực ép lạnh ===================== -->
<section class="lab">
  <!-- Atmospheric glow orbs -->
  <div class="lab-glow g1"></div>
  <div class="lab-glow g2"></div>
  <div class="container">
    <!-- Section header -->
    <div class="lab-head rv">
      <span class="eyebrow">Quy trình sản xuất</span>
      <h2>Chuẩn mực ép lạnh<br>Cold-Pressed.</h2>
      <p>Giữ trọn 99% dưỡng chất và enzyme tự nhiên so với phương pháp nấu truyền thống.</p>
    </div>
    <!-- 3-column glassmorphism cards -->
    <div class="lab-steps">
      <!-- Card 01: Ép Lạnh Nguyên Bản -->
      <div class="lab-step rv">
        <span class="lab-num">01</span>
        <div class="lab-step-ic">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M12 3c-4 3-7 6.5-7 10a7 7 0 0014 0c0-3.5-3-7-7-10z" stroke="var(--lab-cream)" stroke-width="1.6" stroke-linejoin="round"/><path d="M9 13.5c0 2 1.5 3.5 3 3.5" stroke="var(--lab-cream)" stroke-width="1.6" stroke-linecap="round"/></svg>
        </div>
        <h3>Ép Lạnh Nguyên Bản</h3>
        <p>Không sinh nhiệt, không biến đổi chất. Toàn bộ quy trình diễn ra ở nhiệt độ thấp, bảo toàn cấu trúc phân tử và giá trị dinh dưỡng nguyên vẹn của từng loại hạt.</p>
        <div class="lab-badge">
          <svg viewBox="0 0 24 24" fill="none" stroke="var(--lab-cream)" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M8 12.5l2.5 2.5L16 9"/></svg>
          Dưới 4°C toàn trình
        </div>
      </div>
      <!-- Card 02: Thanh Trùng Khép Kín -->
      <div class="lab-step rv">
        <span class="lab-num">02</span>
        <div class="lab-step-ic">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="var(--lab-cream)" stroke-width="1.6"/><path d="M12 7v5l3.5 2" stroke="var(--lab-cream)" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Thanh Trùng Khép Kín</h3>
        <p>Công nghệ vô trùng an toàn tuyệt đối. Quy trình thanh trùng tự động trong hệ thống inox kín, loại bỏ vi khuẩn mà không cần chất bảo quản.</p>
        <div class="lab-badge">
          <svg viewBox="0 0 24 24" fill="none" stroke="var(--lab-cream)" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Chuẩn HACCP &amp; Halal
        </div>
      </div>
      <!-- Card 03: Chai Thủy Tinh Cao Cấp -->
      <div class="lab-step rv">
        <span class="lab-num">03</span>
        <div class="lab-step-ic">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M8 2v4M16 2v4M8 6h8l1 4v8a2 2 0 01-2 2h-6a2 2 0 01-2-2v-8l1-4z" stroke="var(--lab-cream)" stroke-width="1.6" stroke-linejoin="round"/><path d="M8 14h8" stroke="var(--lab-cream)" stroke-width="1.4" stroke-linecap="round" opacity=".5"/></svg>
        </div>
        <h3>Chai Thủy Tinh Cao Cấp</h3>
        <p>Bảo vệ môi trường, giữ vị thanh mát. Chai thủy tinh vô trùng có thể tái sử dụng, không thôi nhiễm hóa chất vào sản phẩm như nhựa thông thường.</p>
        <div class="lab-badge">
          <svg viewBox="0 0 24 24" fill="none" stroke="var(--lab-cream)" stroke-width="2"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
          Tái sử dụng 100%
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 8. SMART FEATURES ===================== -->
<section class="smart">
  <div class="container smart-in">
    <div class="smart-phone rv">
      <div class="phone-mock" id="phoneMock">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="ph-logo">Pure<b>Nut</b></div>
          <div class="ph-card">
            <div class="ph-card-title">Thẻ thành viên</div>
            <div class="ph-card-val">Hạng <em>Gold</em></div>
          </div>
          <div class="ph-card">
            <div class="ph-card-title">Điểm tích lũy</div>
            <div class="ph-card-val"><em>2,450</em> điểm</div>
          </div>
          <div class="ph-qr">
            <div class="ph-qr-grid">
              <span></span><span></span><span></span><span></span><span></span>
              <span></span><span></span><span></span><span></span><span></span>
              <span></span><span></span><span></span><span></span><span></span>
              <span></span><span></span><span></span><span></span><span></span>
              <span></span><span></span><span></span><span></span><span></span>
            </div>
          </div>
          <div style="font-size:9px;color:rgba(255,255,255,.4);text-align:center">Quét mã truy xuất nguồn gốc</div>
        </div>
      </div>
    </div>
    <div class="smart-txt rv">
      <span class="eyebrow">Thông minh hơn. Tiết kiệm hơn.</span>
      <h2>Chương trình Thành Viên PureNut</h2>
      <p>Đăng ký tài khoản để tích điểm, nhận ưu đãi cá nhân hóa và truy xuất nguồn gốc từng chai sữa qua mã QR.</p>
      <div class="smart-features">
        <div class="sf">
          <div class="sf-ic">📱</div>
          <div><h4>Quét QR truy xuất nguồn gốc</h4><p>Biết rõ lô hạt nào, ngày sản xuất, hạn dùng — minh bạch 100%.</p></div>
        </div>
        <div class="sf">
          <div class="sf-ic">🎁</div>
          <div><h4>Tích điểm đổi quà</h4><p>Mỗi đơn hàng tích điểm, đổi voucher giảm giá hoặc sản phẩm miễn phí.</p></div>
        </div>
        <div class="sf">
          <div class="sf-ic">🚚</div>
          <div><h4>Gói Subscription tự động</h4><p>Đăng ký nhận sữa tươi mỗi sáng — freeship trọn đời, không cần đặt lại.</p></div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 9. TESTIMONIALS ===================== -->
<section class="quotes-sec">
  <div class="container">
    <div class="sec-head rv">
      <span class="eyebrow" style="color:var(--navy)">Khách hàng nói gì</span>
      <h2>Hơn 2.800 người đã tin chọn</h2>
    </div>
    <div class="quotes">
      <div class="quote rv">
        <div class="strs">★★★★★</div>
        <p>"Sữa óc chó thơm béo tự nhiên, không gắt đường như mấy hãng khác. Cả nhà mình uống mỗi sáng, con nhỏ cũng nghiện luôn."</p>
        <div class="quote-who">
          <span class="quote-ava" style="background:var(--navy)">TH</span>
          <span><b>Thu Hà</b><small>Quận 3, TP.HCM</small></span>
        </div>
      </div>
      <div class="quote rv">
        <div class="strs">★★★★★</div>
        <p>"Mình bị lactose intolerance nên chuyển hẳn sang PureNut. Giao nhanh, chai thủy tinh xinh, uống xong trả chai còn được giảm giá."</p>
        <div class="quote-who">
          <span class="quote-ava" style="background:var(--red)">MK</span>
          <span><b>Minh Khôi</b><small>Quận 7, TP.HCM</small></span>
        </div>
      </div>
      <div class="quote rv">
        <div class="strs">★★★★★</div>
        <p>"Đặt 6 chai mỗi tuần cho văn phòng. Vị đậu nành mè đen là chân ái — đồng nghiệp ai thử cũng xin link đặt hàng."</p>
        <div class="quote-who">
          <span class="quote-ava" style="background:var(--green)">NL</span>
          <span><b>Ngọc Lan</b><small>Bình Thạnh, TP.HCM</small></span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 10. PRICING CTA ===================== -->
<section class="pricing">
  <div class="container">
    <div class="pricing-head rv">
      <span class="eyebrow">Sẵn sàng thay đổi?</span>
      <h2>Chọn gói phù hợp với bạn</h2>
      <p>Bắt đầu hành trình healthy cùng PureNut. Càng đặt nhiều, càng tiết kiệm.</p>
    </div>
    <div class="plans">
      <div class="plan rv">
        <div class="plan-name">Dùng thử</div>
        <div class="plan-price">149k<small> /3 chai</small></div>
        <div class="plan-desc">Trải nghiệm lần đầu</div>
        <div class="plan-feats">
          <span><i class="pck">✓</i>3 chai 300ml mix vị</span>
          <span><i class="pck">✓</i>Giao lạnh nội thành</span>
          <span><i class="pck">✓</i>Đổi trả nếu không ưng</span>
        </div>
        <a href="${ctx}/products" class="btn btn-outline-light">Chọn gói này</a>
      </div>
      <div class="plan pop rv">
        <div class="plan-name">Gói tuần</div>
        <div class="plan-price">279k<small> /6 chai</small></div>
        <div class="plan-desc">Tiết kiệm 15% — Freeship</div>
        <div class="plan-feats">
          <span><i class="pck">✓</i>6 chai 300ml tùy chọn</span>
          <span><i class="pck">✓</i>Miễn phí giao hàng</span>
          <span><i class="pck">✓</i>Tích 2x điểm thành viên</span>
          <span><i class="pck">✓</i>Ưu tiên giao sáng sớm</span>
        </div>
        <a href="${ctx}/products" class="btn btn-white">Chọn gói này</a>
      </div>
      <div class="plan rv">
        <div class="plan-name">Gói tháng</div>
        <div class="plan-price">999k<small> /24 chai</small></div>
        <div class="plan-desc">Tiết kiệm 25% — VIP</div>
        <div class="plan-feats">
          <span><i class="pck">✓</i>24 chai giao 4 đợt/tháng</span>
          <span><i class="pck">✓</i>Freeship trọn đời</span>
          <span><i class="pck">✓</i>Hạng Gold tự động</span>
          <span><i class="pck">✓</i>Tặng 1 chai mỗi đợt</span>
        </div>
        <a href="${ctx}/products" class="btn btn-outline-light">Chọn gói này</a>
      </div>
    </div>
  </div>
</section>

<!-- ===================== 11. PROMO ===================== -->
<section class="container promo rv" style="padding-bottom:80px">
  <div class="promo-card">
    <div>
      <span class="eyebrow" style="color:var(--navy)">Ưu đãi tháng này</span>
      <h2>Giảm ngay 20% <em>đơn đầu tiên</em></h2>
      <p>Áp dụng cho mọi sản phẩm khi đặt hàng lần đầu qua website. Nhập mã khi thanh toán.</p>
      <a href="${ctx}/products" class="btn btn-red">Mua ngay →</a>
    </div>
    <div class="ticket">
      <small>Mã ưu đãi</small>
      <div class="code" id="coupon" title="Bấm để sao chép">PURENUT20</div>
      <small id="copyNote" style="text-transform:none;letter-spacing:0">Bấm để sao chép</small>
    </div>
  </div>
</section>

<!-- ===================== 12. FOOTER (GIỮ NGUYÊN) ===================== -->
<footer>
  <div class="container foot-grid">
    <div class="foot-brand">
      <a href="${ctx}/" class="logo"><span class="dot"><svg width="20" height="20" viewBox="0 0 34 34"><path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.8"/></svg></span>Pure<b>Nut</b></a>
      <p>Sữa hạt thực vật 100% từ hạt Việt Nam. Từ hạt Việt — cho sức khỏe xanh.</p>
    </div>
    <div class="foot-col"><h4>Sản phẩm</h4><a href="${ctx}/products">Tất cả</a><a href="${ctx}/products?category=dau-nanh">Dòng đậu nành</a><a href="${ctx}/products?category=dac-biet">Dòng đặc biệt</a></div>
    <div class="foot-col"><h4>Công ty</h4><a href="${ctx}/about">Về PureNut</a><a href="${ctx}/about#lien-he">Trở thành đại lý</a><a href="${ctx}/cart">Giỏ hàng</a></div>
    <div class="foot-col"><h4>Liên hệ</h4><p>24 Nguyễn Thị Minh Khai, Q.1</p><p>0908 475 110</p><p>purenutmilkvn@gmail.com</p></div>
  </div>
  <div class="foot-bottom">© 2026 PureNut Việt Nam. Sản phẩm bổ sung — không thay thế tư vấn y tế.</div>
</footer>

<div class="toast" id="toast"><i class="ck">✓</i><span id="toastMsg">Đã thêm vào giỏ</span></div>

<button type="button" class="top-btn" id="topBtn" aria-label="Lên đầu trang">
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M5 12l7-7 7 7"/></svg>
</button>

<script>
var CTX='${ctx}';
document.addEventListener('DOMContentLoaded',function(){
  /* ─── Reveal on scroll ─── */
  var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target);}});},{threshold:.08,rootMargin:'0px 0px -50px'});
  document.querySelectorAll('.rv').forEach(function(el){io.observe(el);});

  /* ─── Mobile nav toggle ─── */
  var t=document.getElementById('siteNavToggle'),nl=document.getElementById('siteNavDrawer');
  if(t&&nl){t.addEventListener('click',function(){nl.classList.toggle('open');});}

  /* ─── Filter chips ─── */
  var chips=document.querySelectorAll('.chip'),cards=document.querySelectorAll('.pcard');
  chips.forEach(function(c){c.addEventListener('click',function(){chips.forEach(function(x){x.classList.remove('on');});c.classList.add('on');var f=c.dataset.f;cards.forEach(function(k){k.classList.toggle('hide',!(f==='all'||k.dataset.cat===f));});});});

  /* ─── Coupon copy ─── */
  var cp=document.getElementById('coupon'),note=document.getElementById('copyNote');
  if(cp)cp.addEventListener('click',function(){navigator.clipboard.writeText('PURENUT20').then(function(){note.textContent='Đã sao chép!';setTimeout(function(){note.textContent='Bấm để sao chép';},2000);}).catch(function(){});});

  /* ─── Add to cart + fly animation ─── */
  var toast=document.getElementById('toast'),tm=document.getElementById('toastMsg'),tt;
  function showToast(m){tm.textContent=m;toast.classList.add('show');clearTimeout(tt);tt=setTimeout(function(){toast.classList.remove('show');},2200);}
  function flyToCart(src){var cart=document.querySelector('.cart-ic')||document.querySelector('a[href$="/cart"]');if(!cart)return;var s=src.getBoundingClientRect(),e=cart.getBoundingClientRect();var f=document.createElement('div');f.className='fly';f.style.left=(s.left+s.width/2-12)+'px';f.style.top=(s.top+s.height/2-12)+'px';document.body.appendChild(f);requestAnimationFrame(function(){var dx=(e.left+e.width/2)-(s.left+s.width/2),dy=(e.top+e.height/2)-(s.top+s.height/2);f.style.transform='translate('+dx+'px,'+dy+'px) scale(.25)';f.style.opacity='.35';});setTimeout(function(){f.remove();cart.classList.add('bump');setTimeout(function(){cart.classList.remove('bump');},450);},820);}
  var badge=document.getElementById('siteCartBadge');
  document.querySelectorAll('.add-btn:not([disabled])').forEach(function(b){b.addEventListener('click',async function(){var id=b.dataset.id;if(!id)return;flyToCart(b);b.disabled=true;try{var r=await fetch(CTX+'/cart/add',{method:'POST',headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'},body:'productId='+id+'&quantity=1'});if(r.redirected){window.location=r.url;return;}var d=await r.json();if(d&&d.success){if(badge)badge.textContent=d.cartCount;showToast('Đã thêm "'+b.dataset.name+'" vào giỏ');}}catch(e){window.location=CTX+'/login';}finally{b.disabled=false;}});});

  /* ─── Marquee: nhân đôi ─── */
  var mt=document.getElementById('marqTrack');
  if(mt)mt.innerHTML+=mt.innerHTML;

  /* ─── Hero 3D product: hover nhẹ, bấm giữ mới xoay mạnh ─── */
  var product3d=document.getElementById('heroProduct');
  if(product3d&&window.matchMedia('(hover:hover) and (min-width:900px)').matches){
    var heroEl=document.querySelector('.hro');
    var dragging=false,dragStartX=0,dragStartY=0,dragRx=0,dragRy=0;
    heroEl.addEventListener('mousemove',function(e){
      var r=product3d.getBoundingClientRect();
      var cx=r.left+r.width/2,cy=r.top+r.height/2;
      var dx=(e.clientX-cx)/r.width,dy=(e.clientY-cy)/r.height;
      if(dragging){
        var rx=(e.clientX-dragStartX)*0.3+dragRy;
        var ry=-(e.clientY-dragStartY)*0.2+dragRx;
        product3d.style.transform='rotateY('+rx+'deg) rotateX('+ry+'deg)';
      }else{
        product3d.style.transform='rotateY('+(dx*3)+'deg) rotateX('+(-dy*2)+'deg)';
      }
    });
    product3d.addEventListener('mousedown',function(e){
      dragging=true;dragStartX=e.clientX;dragStartY=e.clientY;
      var t=product3d.style.transform;
      var my=t.match(/rotateY\(([^)]+)deg\)/),mx=t.match(/rotateX\(([^)]+)deg\)/);
      dragRy=my?parseFloat(my[1]):0;dragRx=mx?parseFloat(mx[1]):0;
      product3d.style.transition='none';
      e.preventDefault();
    });
    window.addEventListener('mouseup',function(){
      if(!dragging)return;dragging=false;
      product3d.style.transition='transform .5s cubic-bezier(.2,.7,.2,1)';
      product3d.style.transform='rotateY(0deg) rotateX(0deg)';
    });
    heroEl.addEventListener('mouseleave',function(){
      if(!dragging){product3d.style.transform='rotateY(0deg) rotateX(0deg)';}
    });
  }

  /* ─── Phone mock tilt ─── */
  var phone=document.getElementById('phoneMock');
  if(phone&&window.matchMedia('(hover:hover)').matches){
    phone.addEventListener('mousemove',function(e){
      var r=phone.getBoundingClientRect();
      var dx=(e.clientX-r.left-r.width/2)/r.width,dy=(e.clientY-r.top-r.height/2)/r.height;
      phone.style.transform='rotateY('+(dx*12)+'deg) rotateX('+(-dy*8)+'deg)';
    });
    phone.addEventListener('mouseleave',function(){phone.style.transform='rotateY(-8deg) rotateX(2deg)';});
  }

  /* ─── Back to top ─── */
  var topBtn=document.getElementById('topBtn');
  window.addEventListener('scroll',function(){topBtn.classList.toggle('show',window.scrollY>600);},{passive:true});
  topBtn.addEventListener('click',function(){window.scrollTo({top:0,behavior:'smooth'});});
});
</script>
<jsp:include page="/WEB-INF/views/layout/support-widget.jsp" />
</body>
</html>
