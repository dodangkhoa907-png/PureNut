<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PureNut — Sữa Hạt Thuần Khiết Từ Hạt Việt</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700;1,9..144,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{
  --navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;
  --cream:#FBF6EC;--paper:#FFFDF8;--sand:#E9DCBE;--sand-deep:#D9C7A0;
  --ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);
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
.reveal{opacity:0;transform:translateY(26px);transition:opacity .7s cubic-bezier(.2,.7,.2,1),transform .7s cubic-bezier(.2,.7,.2,1)}
.reveal.in{opacity:1;transform:none}
.eyebrow{display:inline-block;color:var(--navy);font-weight:700;letter-spacing:.1em;text-transform:uppercase;font-size:12.5px;margin-bottom:12px}
.btn{display:inline-flex;align-items:center;gap:8px;padding:14px 28px;border-radius:99px;font-weight:600;font-size:15px;transition:transform .2s,box-shadow .2s,background .2s}
.btn-primary{background:var(--navy);color:#fff;box-shadow:0 12px 26px -12px rgba(27,79,158,.6)}
.btn-primary:hover{transform:translateY(-2px)}
.btn-ghost{background:transparent;color:var(--ink);border:1.5px solid var(--ink)}
.btn-ghost:hover{background:var(--ink);color:#fff;transform:translateY(-2px)}
.btn-red{background:var(--red);color:#fff;box-shadow:0 12px 26px -12px rgba(206,46,46,.55)}
.btn-red:hover{transform:translateY(-2px)}
/* nav — dùng navbar.jsp chung */

/* Hero */
.hero{position:relative;overflow:hidden;background:linear-gradient(180deg,var(--cream) 0%,var(--cream) 72%,var(--sand) 100%);padding:80px 0 90px}
.hero-blob{position:absolute;top:-12%;right:-8%;width:560px;height:560px;border-radius:50%;background:radial-gradient(circle at 40% 40%,rgba(243,217,139,.5),rgba(243,217,139,0) 70%)}
.hero-in{position:relative;z-index:1;display:grid;grid-template-columns:1.05fr .95fr;gap:44px;align-items:center}
.hero h1{font-size:clamp(38px,5.4vw,62px);margin-bottom:20px}
.hero h1 em{font-style:italic;font-weight:500;color:var(--navy)}
.hero p{font-size:17px;color:var(--ink-soft);max-width:460px;margin-bottom:30px}
.hero-cta{display:flex;gap:14px;flex-wrap:wrap;margin-bottom:28px}
.hero-trust{display:flex;gap:22px;flex-wrap:wrap}
.hero-trust span{display:flex;align-items:center;gap:7px;font-size:13.5px;color:var(--ink-soft);font-weight:600}
.ck{width:18px;height:18px;border-radius:50%;background:#DCF0E3;color:var(--green);display:inline-flex;align-items:center;justify-content:center;font-size:11px;font-weight:800}
.hero-visual{display:flex;justify-content:center;position:relative}
.hero-frame{width:min(100%,370px);border-radius:var(--r-lg);overflow:hidden;box-shadow:var(--shadow);transform:rotate(3deg);border:6px solid var(--paper);background:var(--sand);aspect-ratio:3/4}
.hero-frame img{width:100%;height:100%;object-fit:cover}
.stamp{position:absolute;top:-8px;left:0;width:104px;height:104px;border-radius:50%;background:var(--red);color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;font-size:12px;font-weight:700;line-height:1.3;box-shadow:0 14px 26px -10px rgba(206,46,46,.55);border:2px dashed rgba(255,255,255,.55)}

/* trust bar */
.trust{background:var(--paper);border-top:1px solid var(--line);border-bottom:1px solid var(--line)}
.trust-row{display:grid;grid-template-columns:repeat(4,1fr);gap:22px;padding:32px 0}
.trust-item{display:flex;align-items:center;gap:13px}
.trust-ic{width:46px;height:46px;border-radius:13px;background:var(--cream);display:flex;align-items:center;justify-content:center;color:var(--navy);flex-shrink:0}
.trust-item h4{font-family:var(--fb);font-size:14.5px;font-weight:700;margin-bottom:1px}
.trust-item p{font-size:12.5px;color:var(--ink-soft)}

.sec{padding:80px 0}
.sec-head{text-align:center;max-width:620px;margin:0 auto 46px}
.sec-head h2{font-size:clamp(28px,4vw,44px)}
.sec-head p{color:var(--ink-soft);margin-top:12px}

/* store */
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

/* promo */
.promo{background:linear-gradient(160deg,var(--navy),var(--navy-dark) 60%,var(--navy-darker));border-radius:var(--r-lg);padding:52px;display:grid;grid-template-columns:1.2fr .8fr;gap:40px;align-items:center;color:#fff;box-shadow:var(--shadow)}
.promo h2{font-size:clamp(28px,3.6vw,40px);margin-bottom:12px}
.promo h2 em{font-style:italic;color:#F3D98B}
.promo p{color:#C9D9EF;margin-bottom:22px}
.ticket{background:var(--paper);border-radius:20px;padding:28px;text-align:center;box-shadow:var(--shadow-sm);color:var(--ink)}
.ticket small{color:var(--ink-soft);font-weight:700;text-transform:uppercase;letter-spacing:.05em;font-size:11.5px}
.ticket .code{border:1.5px dashed var(--navy);border-radius:14px;padding:14px;font-family:var(--fd);font-weight:700;font-size:22px;color:var(--navy);letter-spacing:1.5px;margin:12px 0;cursor:pointer}

/* about teaser */
.teaser{display:grid;grid-template-columns:1fr 1fr;gap:50px;align-items:center}
.teaser-img{border-radius:var(--r-lg);overflow:hidden;box-shadow:var(--shadow);background:var(--sand);aspect-ratio:4/3}
.teaser-img img{width:100%;height:100%;object-fit:cover}
.teaser ul{display:flex;flex-direction:column;gap:13px;margin:20px 0 26px}
.teaser li{display:flex;align-items:center;gap:11px;color:var(--ink-soft);font-weight:500}

/* cta */
.cta{background:linear-gradient(160deg,var(--navy),var(--navy-darker));border-radius:var(--r-lg);padding:70px 30px;text-align:center;color:#fff;box-shadow:var(--shadow)}
.cta h2{font-size:clamp(32px,4.6vw,50px);margin-bottom:14px}
.cta h2 em{font-style:italic;color:#F3D98B}
.cta p{color:#C9D9EF;max-width:470px;margin:0 auto 28px;font-size:16px}

/* footer */
footer{background:var(--navy-darker);color:#C9D6EA;padding:60px 0 26px}
.foot-grid{display:grid;grid-template-columns:1.4fr 1fr 1fr 1.1fr;gap:36px;padding-bottom:34px;border-bottom:1px solid rgba(255,255,255,.1)}
.foot-grid .logo{color:#fff}.foot-grid .logo b{color:#fff}
.foot-brand p{margin-top:12px;font-size:14px;color:#9FB2CC;max-width:260px}
.foot-col h4{color:#fff;font-family:var(--fb);font-size:14px;font-weight:700;margin-bottom:14px}
.foot-col a,.foot-col p{display:block;font-size:13.5px;color:#9FB2CC;margin-bottom:9px}
.foot-col a:hover{color:#fff}
.foot-bottom{text-align:center;font-size:12.5px;color:#7E92AE;padding-top:22px}

.fly{position:fixed;z-index:300;width:24px;height:24px;border-radius:50%;background:var(--red);box-shadow:0 6px 16px rgba(0,0,0,.28);pointer-events:none;transition:transform .8s cubic-bezier(.5,-.25,.35,1),opacity .8s;will-change:transform,opacity}
.cart-ic.bump,.site-nav-icon.bump{animation:bump .45s}
@keyframes bump{0%{transform:scale(1)}40%{transform:scale(1.4)}100%{transform:scale(1)}}
.toast{position:fixed;left:50%;bottom:30px;transform:translateX(-50%) translateY(20px);background:var(--navy-darker);color:#fff;padding:14px 24px;border-radius:99px;font-weight:600;box-shadow:var(--shadow);opacity:0;pointer-events:none;transition:.3s;z-index:200;display:flex;align-items:center;gap:9px}
.toast.show{transform:translateX(-50%) translateY(0);opacity:1}
.toast .ck{background:var(--green);color:#fff}

@media(max-width:900px){.hero-in,.promo,.teaser{grid-template-columns:1fr;gap:32px}.grid{grid-template-columns:repeat(2,1fr)}.trust-row,.foot-grid{grid-template-columns:repeat(2,1fr)}.hero-visual{order:-1}}
@media(max-width:600px){
  .grid{grid-template-columns:1fr 1fr;gap:10px}
  .foot-grid,.trust-row{grid-template-columns:1fr}
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
}
@media(max-width:480px){
  .hero{padding:80px 0 40px}
  .hero-in h1{font-size:28px}
  .hero-in p{font-size:14px}
  .promo,.teaser{gap:20px}
  .section-title{font-size:24px}
  .card{border-radius:16px}
  .toast{font-size:13px;padding:12px 20px;left:16px;right:16px;transform:translateX(0) translateY(20px);bottom:80px}
  .toast.show{transform:translateX(0) translateY(0)}
}
</style>
<script>window.CTX = '${ctx}';</script>
</head>
<body>

<%-- ═══ NAVBAR CHUNG ═══ --%>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<!-- HERO -->
<section class="hero">
  <div class="hero-blob"></div>
  <div class="container hero-in">
    <div class="reveal">
      <span class="eyebrow">100% thuần thực vật · sản xuất tại Việt Nam</span>
      <h1>Tinh túy hạt Việt,<br><em>dinh dưỡng thuần khiết.</em></h1>
      <p>PureNut chọn lọc những hạt ngon nhất từ nông trại Việt Nam, xay nguyên hạt, giữ trọn dưỡng chất — không chất bảo quản, không lo lactose.</p>
      <div class="hero-cta">
        <a href="${ctx}/products" class="btn btn-primary">Xem sản phẩm</a>
        <a href="${ctx}/about" class="btn btn-ghost">Về PureNut →</a>
      </div>
      <div class="hero-trust">
        <span><i class="ck">✓</i>Giao hàng trong ngày</span>
        <span><i class="ck">✓</i>Đổi trả 100%</span>
        <span><i class="ck">✓</i>Thanh toán khi nhận</span>
      </div>
    </div>
    <div class="hero-visual reveal">
      <div class="hero-frame"><img src="${ctx}/resources/img/hero.jpg" alt="Sữa hạt PureNut" onerror="this.style.display='none'"></div>
      <div class="stamp"><span style="font-size:10px;opacity:.85">Không</span><span>chất bảo quản</span></div>
    </div>
  </div>
</section>

<!-- TRUST -->
<section class="trust">
  <div class="container trust-row">
    <div class="trust-item reveal"><div class="trust-ic"><svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M3 9l9-6 9 6v11a1 1 0 01-1 1h-5v-7H9v7H4a1 1 0 01-1-1V9z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></svg></div><div><h4>Hạt Việt 100%</h4><p>Nguồn gốc rõ ràng</p></div></div>
    <div class="trust-item reveal"><div class="trust-ic"><svg width="24" height="24" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.6"/><path d="M8 12.5l2.5 2.5L16 9" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/></svg></div><div><h4>Non-GMO</h4><p>Không biến đổi gen</p></div></div>
    <div class="trust-item reveal"><div class="trust-ic"><svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M12 21s-7-4.35-9.5-9C1 8 3 4 7 4c2.2 0 3.8 1.3 5 3 1.2-1.7 2.8-3 5-3 4 0 6 4 4.5 8-2.5 4.65-9.5 9-9.5 9z" stroke="currentColor" stroke-width="1.6"/></svg></div><div><h4>Không bảo quản</h4><p>Nguyên chất tự nhiên</p></div></div>
    <div class="trust-item reveal"><div class="trust-ic"><svg width="24" height="24" viewBox="0 0 24 24" fill="none"><rect x="2" y="6" width="13" height="12" rx="2" stroke="currentColor" stroke-width="1.6"/><path d="M15 10h4l3 3v4a1 1 0 01-1 1h-6V10z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/><circle cx="6" cy="18" r="1.6" stroke="currentColor" stroke-width="1.6"/><circle cx="18" cy="18" r="1.6" stroke="currentColor" stroke-width="1.6"/></svg></div><div><h4>Giao nhanh</h4><p>Trong ngày nội thành</p></div></div>
  </div>
</section>

<!-- STORE -->
<section class="container sec">
  <div class="sec-head reveal">
    <span class="eyebrow">Cửa hàng</span>
    <h2>Chọn hương vị của bạn</h2>
    <p>Chai 300ml, giá thân thiện. Đặt từ 6 chai được miễn phí giao nội thành.</p>
  </div>
  <div class="filter reveal">
    <button class="chip on" data-f="all">Tất cả</button>
    <button class="chip" data-f="dau-nanh">Dòng đậu nành</button>
    <button class="chip" data-f="dac-biet">Dòng đặc biệt</button>
  </div>
  <div class="grid">
    <c:forEach var="p" items="${products}">
      <article class="pcard reveal" data-cat="${p.categorySlug}">
        <a href="${ctx}/products/${p.slug}">
          <div class="p-thumb" style="background:${not empty p.bgColorHex ? p.bgColorHex : '#E9DCBE'}">
            <c:if test="${p.featured}"><span class="p-tag">⭐ Nổi bật</span></c:if>
            <svg viewBox="0 0 24 24" fill="none"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" fill="rgba(255,255,255,.9)"/></svg>
          </div>
        </a>
        <div class="p-body">
          <a href="${ctx}/products/${p.slug}"><h3>${p.name}</h3></a>
          <div class="meta">${p.categoryName} · ${p.volumeMl}ml · ${p.kcalPer100ml} kcal</div>
          <div class="p-foot">
            <span class="p-price">${p.formattedPrice}<small> đ</small></span>
            <c:choose>
              <c:when test="${p.stockQuantity > 0}"><button class="add-btn" data-id="${p.productId}" data-name="${p.name}" aria-label="Thêm"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg></button></c:when>
              <c:otherwise><button class="add-btn" disabled>—</button></c:otherwise>
            </c:choose>
          </div>
        </div>
      </article>
    </c:forEach>
  </div>
</section>

<!-- PROMO -->
<section class="container sec" style="padding-top:0">
  <div class="promo reveal">
    <div>
      <span class="eyebrow" style="color:#9FC4EE">Ưu đãi tháng này</span>
      <h2>Giảm ngay 20% <em>đơn đầu tiên</em></h2>
      <p>Áp dụng cho mọi sản phẩm khi đặt hàng lần đầu qua website. Nhập mã khi thanh toán.</p>
      <a href="${ctx}/products" class="btn btn-red">Mua ngay</a>
    </div>
    <div class="ticket">
      <small>Mã ưu đãi</small>
      <div class="code" id="coupon" title="Bấm để sao chép">PURENUT20</div>
      <small id="copyNote" style="text-transform:none;letter-spacing:0">Bấm để sao chép</small>
    </div>
  </div>
</section>

<!-- ABOUT TEASER -->
<section class="container sec" style="padding-top:0">
  <div class="teaser">
    <div class="teaser-img reveal"><img src="${ctx}/resources/img/poster.jpg" alt="Poster PureNut" onerror="this.style.display='none'"></div>
    <div class="reveal">
      <span class="eyebrow">Về PureNut</span>
      <h2>Câu chuyện từ <em style="font-style:italic;color:var(--navy)">hạt Việt</em></h2>
      <p style="color:var(--ink-soft)">PureNut ra đời với mong muốn mang đến nguồn dinh dưỡng thực vật thuần khiết, chọn lọc từ những hạt ngon nhất của nông trại Việt Nam.</p>
      <ul>
        <li><i class="ck">✓</i>Đậu nành Non-GMO, nguồn gốc Việt Nam</li>
        <li><i class="ck">✓</i>Xay nguyên hạt, giữ trọn dưỡng chất</li>
        <li><i class="ck">✓</i>Đạt chuẩn HACCP, Halal, an toàn thực phẩm</li>
      </ul>
      <a href="${ctx}/about" class="btn btn-primary">Tìm hiểu thêm</a>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="container sec" style="padding-top:0">
  <div class="cta reveal">
    <h2>Sẵn sàng thử <em>ly đầu tiên?</em></h2>
    <p>Ly sữa hạt thuần khiết đang chờ bạn. Bắt đầu hành trình healthy cùng PureNut hôm nay.</p>
    <a href="${ctx}/products" class="btn btn-red" style="padding:16px 40px;font-size:16px">Đặt hàng ngay</a>
  </div>
</section>

<!-- FOOTER -->
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

<script>
var CTX='${ctx}';
document.addEventListener('DOMContentLoaded',function(){
  var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target);}});},{threshold:.1,rootMargin:'0px 0px -40px'});
  document.querySelectorAll('.reveal').forEach(function(el){io.observe(el);});
  var t=document.getElementById('siteNavToggle'),nl=document.getElementById('siteNavDrawer');
  if(t&&nl){t.addEventListener('click',function(){nl.classList.toggle('open');});}
  var chips=document.querySelectorAll('.chip'),cards=document.querySelectorAll('.pcard');
  chips.forEach(function(c){c.addEventListener('click',function(){chips.forEach(function(x){x.classList.remove('on');});c.classList.add('on');var f=c.dataset.f;cards.forEach(function(k){k.classList.toggle('hide',!(f==='all'||k.dataset.cat===f));});});});
  var cp=document.getElementById('coupon'),note=document.getElementById('copyNote');
  cp.addEventListener('click',function(){navigator.clipboard.writeText('PURENUT20').then(function(){note.textContent='Đã sao chép!';setTimeout(function(){note.textContent='Bấm để sao chép';},2000);}).catch(function(){});});
  var toast=document.getElementById('toast'),tm=document.getElementById('toastMsg'),tt;
  function showToast(m){tm.textContent=m;toast.classList.add('show');clearTimeout(tt);tt=setTimeout(function(){toast.classList.remove('show');},2200);}
  function flyToCart(src){var cart=document.querySelector('.cart-ic')||document.querySelector('a[href$="/cart"]');if(!cart)return;var s=src.getBoundingClientRect(),e=cart.getBoundingClientRect();var f=document.createElement('div');f.className='fly';f.style.left=(s.left+s.width/2-12)+'px';f.style.top=(s.top+s.height/2-12)+'px';document.body.appendChild(f);requestAnimationFrame(function(){var dx=(e.left+e.width/2)-(s.left+s.width/2),dy=(e.top+e.height/2)-(s.top+s.height/2);f.style.transform='translate('+dx+'px,'+dy+'px) scale(.25)';f.style.opacity='.35';});setTimeout(function(){f.remove();cart.classList.add('bump');setTimeout(function(){cart.classList.remove('bump');},450);},820);}
  var badge=document.getElementById('siteCartBadge');
  document.querySelectorAll('.add-btn:not([disabled])').forEach(function(b){b.addEventListener('click',async function(){var id=b.dataset.id;if(!id)return;flyToCart(b);b.disabled=true;try{var r=await fetch(CTX+'/cart/add',{method:'POST',headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'},body:'productId='+id+'&quantity=1'});if(r.redirected){window.location=r.url;return;}var d=await r.json();if(d&&d.success){if(badge)badge.textContent=d.cartCount;showToast('Đã thêm "'+b.dataset.name+'" vào giỏ');}}catch(e){window.location=CTX+'/login';}finally{b.disabled=false;}});});
});
</script>
</body>
</html>
