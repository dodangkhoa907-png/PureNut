<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<title>${product.name} — PureNut</title>
<meta name="description" content="${product.description}">
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
  overflow:hidden;position:sticky;top:80px;
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
.info-tabs{display:flex;gap:4px;margin-bottom:18px;border-bottom:2px solid var(--line);padding-bottom:0}
.info-tab{
  padding:10px 18px;font-size:13.5px;font-weight:700;color:var(--ink-soft);
  border:none;background:none;cursor:pointer;position:relative;transition:color .15s;
}
.info-tab:hover{color:var(--navy)}
.info-tab.active{color:var(--navy)}
.info-tab.active::after{content:'';position:absolute;bottom:-2px;left:0;right:0;height:2.5px;background:var(--navy);border-radius:99px}
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
.rel{padding:16px 0 80px}
.rel-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:28px}
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

.section-divider{border:none;border-top:1px solid var(--line);margin:0}

/* Toast & Fly */
.fly{position:fixed;z-index:300;width:24px;height:24px;border-radius:50%;background:var(--red);box-shadow:0 6px 16px rgba(0,0,0,.28);pointer-events:none;transition:transform .8s cubic-bezier(.5,-.25,.35,1),opacity .8s;will-change:transform,opacity}
.toast{position:fixed;left:50%;bottom:30px;transform:translateX(-50%) translateY(20px);background:var(--navy-darker);color:#fff;padding:14px 26px;border-radius:99px;font-weight:600;box-shadow:var(--shadow);opacity:0;pointer-events:none;transition:.3s;z-index:200;font-size:14px;display:flex;align-items:center;gap:8px}
.toast.show{transform:translateX(-50%) translateY(0);opacity:1}

@media(max-width:880px){.detail{grid-template-columns:1fr;gap:30px}.gallery{position:static}.grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:520px){.grid{grid-template-columns:1fr 1fr}.opt-pills{gap:4px}.opt-pill{padding:8px 14px;font-size:13px}}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<div class="container">
  <nav class="crumb" aria-label="Breadcrumb">
    <a href="${ctx}/">Trang chủ</a><span class="crumb-sep">›</span>
    <a href="${ctx}/products">Sản phẩm</a><span class="crumb-sep">›</span>
    <span style="color:var(--ink)">${product.name}</span>
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
  </div>

  <!-- Info -->
  <div class="info-pane">
    <span class="eyebrow-pill" style="color:${accA};background:${accA}18;border-color:${accA}44">${product.categoryName}</span>
    <h1>${product.name}</h1>
    <div class="price">${product.formattedPrice} đ</div>
    <div class="price-sub">/ chai ${product.volumeMl}ml · Đã bao gồm VAT</div>

    <c:if test="${product.stockQuantity > 0}">
    <!-- ── Sweetness ── -->
    <div class="opt-section">
      <div class="opt-label"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg>Độ ngọt</div>
      <div class="opt-pills" id="sweetPills">
        <button class="opt-pill" data-val="0%">0%</button>
        <button class="opt-pill" data-val="25%">25%</button>
        <button class="opt-pill sel" data-val="50%">50%</button>
        <button class="opt-pill" data-val="100%">100%</button>
      </div>
    </div>

    <!-- ── Subscription upsell ── -->
    <div class="sub-upsell" id="subUpsell">
      <div class="sub-check"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div>
      <div class="sub-text">
        <strong>Giao định kỳ mỗi tuần</strong>
        <span>Tự động giao hàng mỗi tuần — hủy bất kỳ lúc nào</span>
      </div>
      <span class="sub-badge">Giảm 10%</span>
    </div>
    </c:if>

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
        <p>${product.description}</p>
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
          <div class="pcard-thumb" style="background:${not empty rel.bgColorHex ? rel.bgColorHex : '#E9DCBE'}">
            <div class="pcard-thumb-emoji">${isBean ? '🌰' : '🥛'}</div>
            <c:if test="${rel.featured}"><span class="pcard-feat-badge">⭐ Nổi bật</span></c:if>
          </div>
          <div class="pcard-body">
            <div class="pcard-name">${rel.name}</div>
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

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

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
      var d=await r.json();if(d&&d.success)showToast('Đã thêm vào giỏ hàng ✓');
    }catch(e){window.location=CTX+'/login'}
  }

  document.getElementById('addBtn').addEventListener('click',function(){flyToCart(this);addToCart()});
  document.getElementById('buyBtn').addEventListener('click',function(){
    var form=document.createElement('form');form.method='POST';form.action=CTX+'/cart/add';
    form.innerHTML='<input name="productId" value="'+f.querySelector('input[name=productId]').value+'"><input name="quantity" value="'+inp.value+'"><input name="action" value="buy_now">';
    document.body.appendChild(form);form.submit();
  });
})();
</script>
</body>
</html>
