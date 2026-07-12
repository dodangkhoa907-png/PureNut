<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Giỏ hàng — PureNut</title>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@500;700;800&display=swap" rel="stylesheet">
<script>window.CTX='${ctx}';</script>
<style>
/* ═══════════════════════════════════
   PureNut — Cart Page (F&B · Rich)
   ═══════════════════════════════════ */
.cart-page{padding-top:0;padding-bottom:80px;background:linear-gradient(180deg,var(--cream) 0%,#F3EDE0 100%);min-height:100vh}
.cart-banner{
    background:linear-gradient(135deg,#1B4F9E 0%,#11335E 55%,#0B2547 100%);
    padding:32px 0 28px;color:#fff;position:relative;overflow:hidden;
}
.cart-banner::before{content:'';position:absolute;top:-80px;right:-60px;width:260px;height:260px;background:radial-gradient(circle,rgba(206,46,46,.14) 0%,transparent 70%);border-radius:50%}
.cart-banner-inner{max-width:var(--container);margin:0 auto;padding:0 28px;position:relative;z-index:1;display:flex;align-items:center;gap:16px}
.cart-banner-inner svg{width:32px;height:32px;stroke:#fff;fill:none;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
.cart-banner h1{font-family:var(--fd);font-size:28px;font-weight:700}
.cart-banner .cb-count{font-size:14px;color:rgba(255,255,255,.55);font-weight:600;margin-left:4px}

.cart-body{max-width:var(--container);margin:28px auto 0;padding:0 28px;display:grid;grid-template-columns:1.65fr 1fr;gap:26px;align-items:start}

/* ── Cart Items ── */
.cart-items{background:#fff;border-radius:22px;box-shadow:0 8px 28px -14px rgba(0,0,0,.08);border:1px solid rgba(0,0,0,.03);overflow:hidden}
.ci-header{display:grid;grid-template-columns:40px 2fr auto auto auto;gap:16px;padding:16px 24px;background:rgba(27,79,158,.03);border-bottom:1.5px solid rgba(27,79,158,.08);font-size:11px;font-weight:800;color:var(--navy);text-transform:uppercase;letter-spacing:.06em;align-items:center}
.ci-row{
    display:grid;grid-template-columns:40px 2fr auto auto auto;gap:16px;align-items:center;
    padding:20px 24px;border-bottom:1px solid rgba(0,0,0,.04);transition:background .15s;
}
.ci-row.unchecked{opacity:.5}

/* ── Custom Checkbox (Emerald) ── */
.ci-check-wrap{display:flex;align-items:center;justify-content:center}
.checkbox-container{
    display:inline-block;position:relative;width:26px;height:26px;cursor:pointer;
    flex-shrink:0;user-select:none;transform:scale(0.75);
}
.checkbox-container .custom-checkbox{
    position:absolute;opacity:0;cursor:pointer;width:0;height:0;
}
.checkbox-container .checkmark{
    position:absolute;top:0;left:0;width:26px;height:26px;
    background:#eee;border-radius:8px;
    transition:all .25s cubic-bezier(.4,.0,.2,1);
    box-shadow:inset 0 1px 3px rgba(0,0,0,.08),0 1px 2px rgba(0,0,0,.06);
}
.checkbox-container .checkmark:after{
    content:"";position:absolute;display:none;
    left:9px;top:4px;width:6px;height:12px;
    border:solid #fff;border-width:0 2.5px 2.5px 0;
    transform:rotate(45deg);
}
.checkbox-container .custom-checkbox:checked ~ .checkmark{
    background:linear-gradient(135deg,#0F0F11 0%,#242428 40%,#4A4A52 100%);
    box-shadow:0 3px 10px -2px rgba(0,0,0,.45),inset 0 1px 0 rgba(255,255,255,.2);
}
.checkbox-container .custom-checkbox:checked ~ .checkmark:after{
    display:block;
    animation:checkAnim .25s cubic-bezier(.4,.0,.2,1) forwards;
}
@keyframes checkAnim{0%{height:0;opacity:0}100%{height:12px;opacity:1}}
.checkbox-container:hover .checkmark{
    box-shadow:0 0 0 3px rgba(0,0,0,.1),inset 0 1px 3px rgba(0,0,0,.08);
}

.ci-row:last-child{border-bottom:none}
.ci-row:hover{background:rgba(27,79,158,.015)}

/* Product cell */
.ci-prod{display:flex;align-items:center;gap:16px}
.ci-thumb{
    width:72px;height:72px;border-radius:16px;flex-shrink:0;
    display:flex;align-items:center;justify-content:center;
    overflow:hidden;position:relative;box-shadow:0 4px 14px -4px rgba(0,0,0,.12);
}
.ci-thumb img{width:100%;height:100%;object-fit:cover}
.ci-thumb-emoji{font-size:32px;position:relative;z-index:1;filter:drop-shadow(0 2px 4px rgba(0,0,0,.1))}
.ci-name{font-family:var(--fd);font-size:15.5px;font-weight:700;color:var(--ink);margin-bottom:3px}
.ci-name a{transition:color .15s}.ci-name a:hover{color:var(--navy)}
.ci-meta{font-size:12.5px;color:var(--ink-soft);line-height:1.4}
.ci-meta span{display:inline-flex;align-items:center;gap:4px}
.ci-meta .dot{color:var(--sand);margin:0 3px}

/* ── Quantity Stepper ── */
.ci-qty{display:inline-flex;align-items:center;gap:0;border-radius:12px;overflow:hidden;background:#fff;border:1.5px solid var(--line)}
.ci-qty button{
    width:38px;height:38px;font-size:18px;font-weight:700;color:var(--navy);
    background:rgba(27,79,158,.04);border:none;cursor:pointer;
    display:flex;align-items:center;justify-content:center;
    transition:all .15s;line-height:1;
}
.ci-qty button:hover{background:rgba(27,79,158,.12);color:#1B4F9E}
.ci-qty button:active{transform:scale(.92)}
.ci-qty input{
    width:44px;height:38px;text-align:center;border:none;
    border-left:1px solid var(--line);border-right:1px solid var(--line);
    font-weight:700;font-size:15px;outline:none;background:transparent;
    color:var(--ink);font-family:var(--fb);
    /* Ẩn spinner mặc định */
    -moz-appearance:textfield;
}
.ci-qty input::-webkit-outer-spin-button,
.ci-qty input::-webkit-inner-spin-button{
    -webkit-appearance:none;margin:0;
}

/* Actions wrapper — contents on desktop to fill grid columns */
.ci-actions-wrap{display:contents}

/* Line total */
.ci-total{font-family:'EB Garamond',var(--fd),serif;font-weight:700;font-size:17px;color:var(--ink);white-space:nowrap}

/* Delete */
.ci-del{
    width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;
    transition:all .15s;border:none;background:rgba(0,0,0,.03);cursor:pointer;
}
.ci-del:hover{background:rgba(206,46,46,.08)}
.ci-del svg{width:17px;height:17px;stroke:var(--ink-soft);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.ci-del:hover svg{stroke:var(--red)}

/* ── Summary ── */
.cart-summary{
    background:#fff;border-radius:22px;box-shadow:0 8px 28px -14px rgba(0,0,0,.08);
    border:1px solid rgba(0,0,0,.03);padding:26px 24px;
    position:sticky;top:80px;
}
.cs-title{font-family:var(--fd);font-size:19px;font-weight:700;color:var(--navy);margin-bottom:20px;padding-bottom:14px;border-bottom:1.5px solid var(--line);display:flex;align-items:center;gap:9px}
.cs-title svg{width:20px;height:20px;stroke:var(--navy);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}

/* Voucher */
.cs-voucher{display:flex;gap:8px;margin-bottom:20px}
.cs-voucher input{
    flex:1;padding:12px 16px;border:1.5px solid var(--line);border-radius:12px;
    font-size:14px;background:#fff;transition:border-color .2s;
}
.cs-voucher input:focus{border-color:var(--navy);outline:none;box-shadow:0 0 0 3px rgba(27,79,158,.08)}
.cs-voucher input::placeholder{color:var(--sand)}
.cs-voucher button{
    padding:12px 20px;border-radius:12px;font-size:13px;font-weight:700;
    background:linear-gradient(135deg,#1B4F9E,#2A5FB8);color:#fff;border:none;
    cursor:pointer;transition:transform .15s;white-space:nowrap;
}
.cs-voucher button:hover{transform:translateY(-1px)}

.cs-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;font-size:14.5px;color:var(--ink-soft)}
.cs-row b{color:var(--ink);font-weight:600}
.cs-divider{border:none;border-top:1.5px solid var(--line);margin:12px 0}
.cs-total{display:flex;justify-content:space-between;align-items:center;padding:4px 0}
.cs-total-label{font-size:16px;font-weight:700;color:var(--ink)}
.cs-total-val{font-family:'EB Garamond',var(--fd),serif;font-size:24px;font-weight:800;color:var(--red)}

.cs-btn{
    display:flex;align-items:center;justify-content:center;gap:8px;width:100%;
    padding:15px 20px;border-radius:99px;font-size:15.5px;font-weight:700;
    border:none;cursor:pointer;transition:transform .2s,box-shadow .2s;margin-top:18px;
}
.cs-btn.primary{background:linear-gradient(135deg,var(--red),#E8432E);color:#fff;box-shadow:0 8px 22px -8px rgba(206,46,46,.4)}
.cs-btn.primary:hover{transform:translateY(-2px);box-shadow:0 12px 28px -8px rgba(206,46,46,.5)}
.cs-btn.ghost{background:transparent;color:var(--ink);border:1.5px solid var(--line);margin-top:10px}
.cs-btn.ghost:hover{background:rgba(27,79,158,.03);border-color:var(--navy);color:var(--navy)}
.cs-btn svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}

/* Eco nudge */
.cs-eco{
    display:flex;align-items:center;gap:10px;margin-top:18px;padding:14px 16px;
    background:linear-gradient(135deg,rgba(43,172,98,.06),rgba(43,172,98,.02));
    border:1px solid rgba(43,172,98,.12);border-radius:14px;
}
.cs-eco svg{width:20px;height:20px;stroke:#2BAC62;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
.cs-eco p{font-size:12.5px;color:var(--ink-soft);line-height:1.45}
.cs-eco strong{color:#2BAC62;font-weight:700}

/* ── Empty ── */
.cart-empty{
    text-align:center;padding:80px 30px;background:#fff;border-radius:22px;
    box-shadow:0 8px 28px -14px rgba(0,0,0,.08);border:1px solid rgba(0,0,0,.03);
    grid-column:1/-1;
}
.ce-icon{
    width:100px;height:100px;border-radius:50%;margin:0 auto 22px;
    background:linear-gradient(135deg,rgba(27,79,158,.06),rgba(27,79,158,.02));
    border:1.5px solid rgba(27,79,158,.08);
    display:flex;align-items:center;justify-content:center;
}
.ce-icon svg{width:44px;height:44px;stroke:var(--ink-soft);fill:none;stroke-width:1.3;stroke-linecap:round;stroke-linejoin:round;opacity:.4}
.cart-empty h2{font-family:var(--fd);font-size:22px;margin-bottom:8px;color:var(--ink)}
.cart-empty p{color:var(--ink-soft);font-size:15px;margin-bottom:24px}

@media(max-width:860px){
    .cart-body{grid-template-columns:1fr;gap:14px}
    .cart-summary{position:static;border-radius:16px;padding:20px 18px}
    .cs-eco{display:none}
    .cs-title{font-size:15px;margin-bottom:12px;padding-bottom:10px;gap:7px}
    .cs-title svg{width:17px;height:17px}
    .cs-row{padding:5px 0;font-size:13px}
    .cs-divider{margin:8px 0}
    .cs-total-val{font-size:20px}
    .cs-total-label{font-size:14px}
    .cs-btn{margin-top:10px;padding:13px;font-size:14px;border-radius:14px}
    .cs-btn.ghost{margin-top:8px;padding:11px;font-size:13px}
    .cs-voucher input{padding:10px 14px;font-size:13px}
    .cs-voucher button{padding:10px 16px;font-size:12px}
    .ci-header{display:none}
    .ci-row{
        display:grid;grid-template-columns:auto 1fr;gap:0 10px;
        position:relative;padding:14px 44px 14px 14px;
        grid-template-rows:auto auto;
    }
    .ci-check-wrap{grid-row:1/3;align-self:center}
    .ci-prod{grid-column:2;display:flex;gap:10px;align-items:center;margin-bottom:8px}
    .ci-actions-wrap{grid-column:2;display:flex;align-items:center;justify-content:space-between;gap:10px}
    .ci-total{font-size:14px;margin-left:auto}
    .ci-del{position:absolute;top:12px;right:12px;width:32px;height:32px}
    .ci-thumb{width:60px;height:60px;border-radius:12px}
    .ci-name{font-size:13.5px}
    .ci-meta{font-size:11px}
    .ci-qty button{width:34px;height:34px;font-size:16px}
    .ci-qty input{width:38px;height:34px;font-size:13px}
    .cart-banner h1{font-size:22px}
    .cart-banner .cb-count{font-size:12px}
    .cart-banner{padding:22px 0 18px}
    .checkbox-container{transform:scale(.85)}
}
@media(max-width:520px){
    .cart-banner h1{font-size:18px}
    .cart-banner .cb-count{font-size:11px}
    .cart-banner{padding:16px 0 14px}
    .cart-banner-inner{padding:0 12px;gap:10px}
    .cart-banner-inner svg{width:24px;height:24px}
    .cart-body{padding:0 8px;margin-top:10px;gap:10px}
    .cart-items{border-radius:16px}
    .ci-thumb{width:50px;height:50px;border-radius:10px}
    .ci-thumb-emoji{font-size:24px}
    .ci-name{font-size:12.5px}
    .ci-meta{font-size:10px;line-height:1.3}
    .ci-meta .dot{display:none}
    .ci-meta span{display:inline}
    .ci-row{padding:12px 38px 12px 10px;gap:0 8px}
    .ci-prod{gap:8px;margin-bottom:6px}
    .ci-qty button{width:28px;height:28px;font-size:14px}
    .ci-qty input{width:32px;height:28px;font-size:12px}
    .ci-qty{border-radius:8px}
    .ci-total{font-size:13px;font-weight:700;margin-left:0}
    .ci-del{width:28px;height:28px;top:10px;right:8px;border-radius:8px}
    .ci-del svg{width:13px;height:13px}
    .cart-summary{padding:16px 14px;border-radius:14px}
    .cs-title{font-size:14px;margin-bottom:8px;padding-bottom:6px}
    .cs-row{font-size:12px;padding:4px 0}
    .cs-total-val{font-size:18px}
    .cs-total-label{font-size:13px}
    .cs-btn.primary{margin-top:8px;padding:12px;font-size:13px;border-radius:12px}
    .cs-btn.ghost{margin-top:6px;padding:10px;font-size:12px;border-radius:12px}
    .cs-btn svg{width:15px;height:15px}
    .cs-voucher{flex-direction:column;gap:6px;margin-bottom:14px}
    .cs-voucher input{padding:10px 12px;font-size:12px;border-radius:10px}
    .cs-voucher button{width:100%;padding:10px;font-size:12px;border-radius:10px}
    .checkbox-container{transform:scale(.65)}
}
@media(max-width:380px){
    .cart-banner h1{font-size:16px}
    .cart-banner{padding:14px 0 12px}
    .ci-thumb{width:44px;height:44px;border-radius:8px}
    .ci-name{font-size:11.5px}
    .ci-meta{font-size:9.5px}
    .ci-row{padding:10px 34px 10px 8px}
    .ci-qty button{width:26px;height:26px;font-size:13px}
    .ci-qty input{width:28px;height:26px;font-size:11px}
    .ci-total{font-size:12px;margin-left:8px}
    .ci-del{width:26px;height:26px;top:8px;right:6px}
    .cart-summary{padding:14px 12px}
    .cs-title{font-size:13px}
    .cs-row{font-size:11px}
    .cs-total-val{font-size:16px}
    .cs-total-label{font-size:12px}
    .cs-btn.primary{padding:11px;font-size:12px}
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<main class="cart-page">

<!-- Banner -->
<div class="cart-banner">
    <div class="cart-banner-inner">
        <svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
        <h1>Giỏ hàng của bạn<c:if test="${not empty cartItems}"><span class="cb-count">(${sessionScope.cartCount} sản phẩm)</span></c:if></h1>
    </div>
</div>

<div class="cart-body">
<c:choose>
<c:when test="${empty cartItems}">
    <div class="cart-empty">
        <div class="ce-icon"><svg viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg></div>
        <h2>Giỏ hàng đang trống</h2>
        <p>Hãy thêm sản phẩm sữa hạt yêu thích vào giỏ nhé!</p>
        <a href="${ctx}/products" class="cs-btn primary" style="display:inline-flex;width:auto;padding:14px 32px">
            <svg viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
            Khám phá sản phẩm
        </a>
    </div>
</c:when>
<c:otherwise>
    <!-- Items -->
    <div class="cart-items">
        <div class="ci-header">
            <div class="ci-check-wrap"><label class="checkbox-container"><input class="custom-checkbox" id="checkAll" type="checkbox" checked><span class="checkmark"></span></label></div>
            <span>Sản phẩm</span><span>Số lượng</span><span>Thành tiền</span><span></span>
        </div>
        <c:forEach var="item" items="${cartItems}">
            <div class="ci-row" data-price="${item.productPrice}" data-qty="${item.quantity}" data-id="${item.cartItemId}">
                <div class="ci-check-wrap"><label class="checkbox-container"><input class="custom-checkbox ci-item-check" type="checkbox" checked><span class="checkmark"></span></label></div>
                <div class="ci-prod">
                    <a href="${ctx}/products/${item.productSlug}" class="ci-thumb" style="background:${fn:escapeXml(not empty item.bgColorHex ? item.bgColorHex : '#E9DCBE')}">
                        <c:choose>
                            <c:when test="${not empty item.imageUrl}">
                                <img src="${ctx}${item.imageUrl}" alt="${fn:escapeXml(item.productName)}" onerror="this.style.display='none';this.parentElement.innerHTML='<span class=ci-thumb-emoji>🥛</span>'">
                            </c:when>
                            <c:otherwise>
                                <span class="ci-thumb-emoji">🥛</span>
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <div class="ci-info">
                        <div class="ci-name"><a href="${ctx}/products/${item.productSlug}"><c:out value="${item.productName}"/></a></div>
                        <div class="ci-meta">
                            <span>Chai thủy tinh ${item.volumeMl}ml</span>
                            <span class="dot">·</span>
                            <span>${item.formattedPrice} đ / chai</span>
                        </div>
                    </div>
                </div>
                <div class="ci-actions-wrap">
                    <form action="${ctx}/cart/update" method="POST" class="qty-form" style="margin:0">
                        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                        <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                        <div class="ci-qty">
                            <button type="button" class="q-minus">−</button>
                            <input type="number" name="quantity" min="1" value="${item.quantity}">
                            <button type="button" class="q-plus">+</button>
                        </div>
                    </form>
                    <div class="ci-total">${item.formattedTotalPrice} đ</div>
                </div>
                <form action="${ctx}/cart/remove" method="POST" style="margin:0" class="del-form">
                    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                    <button class="ci-del" title="Xóa sản phẩm">
                        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>

    <!-- Summary -->
    <aside class="cart-summary">
        <div class="cs-title">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            Tổng đơn hàng
        </div>

        <!-- Voucher -->
        <div class="cs-voucher">
            <input type="text" placeholder="Nhập mã giảm giá..." id="voucherInput">
            <button type="button" onclick="applyVoucher()">Áp dụng</button>
        </div>

        <div class="cs-row"><span id="csSubLabel">Tạm tính (${cartItems.size()} sản phẩm)</span><b id="csSubVal">${formattedTotal} đ</b></div>
        <div class="cs-row"><span>Phí giao hàng</span><b style="color:var(--green)">Tính khi thanh toán</b></div>
        <div class="cs-row" id="discountRow" style="display:none"><span id="discountLabel">Giảm giá</span><b id="discountVal" style="color:var(--green)">-0 đ</b></div>
        <hr class="cs-divider">
        <div class="cs-total">
            <span class="cs-total-label">Tổng cộng</span>
            <span class="cs-total-val">${formattedTotal} đ</span>
        </div>

        <a href="${ctx}/checkout" class="cs-btn primary" id="checkoutBtn">
            <svg viewBox="0 0 24 24"><polyline points="13 17 18 12 13 7"/><polyline points="6 17 11 12 6 7"/></svg>
            Tiến hành thanh toán
        </a>
        <a href="${ctx}/products" class="cs-btn ghost">
            <svg viewBox="0 0 24 24"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
            Tiếp tục mua sắm
        </a>

        <div class="cs-eco">
            <svg viewBox="0 0 24 24"><path d="M2 22c1.25-7.69 6-12.5 14-12.5"/><path d="M22 2c-1 4.5-3.5 8-8 10"/></svg>
            <p>Trả vỏ chai thủy tinh khi nhận hàng để tích điểm <strong>Hoàn Vỏ Chai</strong> — đổi sữa miễn phí!</p>
        </div>
    </aside>
</c:otherwise>
</c:choose>
</div>
</main>

<%-- Footer hidden on cart page for cleaner mobile UX --%>

<script>
(function(){
    document.querySelectorAll('.qty-form').forEach(function(f){
        var i=f.querySelector('input[name="quantity"]');
        var cid=f.querySelector('input[name="cartItemId"]').value;
        var timer=null;
        function sync(){
            clearTimeout(timer);
            timer=setTimeout(function(){
                fetch(window.CTX+'/cart/update',{
                    method:'POST',
                    headers:{'Content-Type':'application/x-www-form-urlencoded','X-Requested-With':'XMLHttpRequest'},
                    body:'cartItemId='+cid+'&quantity='+i.value
                });
            },400);
        }
        f.querySelector('.q-minus').addEventListener('click',function(e){e.preventDefault();var v=parseInt(i.value,10)||1;if(v>1){i.value=v-1;recalc();sync()}});
        f.querySelector('.q-plus').addEventListener('click',function(e){e.preventDefault();i.value=(parseInt(i.value,10)||1)+1;recalc();sync()});
        i.addEventListener('change',function(){if((parseInt(i.value,10)||0)<1)i.value=1;recalc();sync()});
        f.addEventListener('submit',function(e){e.preventDefault();recalc();sync()});
    });

    window.applyVoucher=function(){
        var code=document.getElementById('voucherInput').value.trim();
        if(!code){alert('Vui lòng nhập mã giảm giá.');return}
        alert('Tính năng mã giảm giá đang được phát triển.');
    };

    var checkAll=document.getElementById('checkAll');
    var itemChecks=document.querySelectorAll('.ci-item-check');
    var csSubLabel=document.getElementById('csSubLabel');
    var csSubVal=document.getElementById('csSubVal');
    var csTotalVal=document.querySelector('.cs-total-val');
    var checkoutBtn=document.getElementById('checkoutBtn');

    // Handle AJAX delete
    document.querySelectorAll('.del-form').forEach(function(f){
        f.addEventListener('submit', function(e){
            e.preventDefault();
            var btn = f.querySelector('.ci-del');
            if(btn) btn.style.opacity = '0.5';
            var cid = f.querySelector('input[name="cartItemId"]').value;
            var csrf = f.querySelector('input[name="_csrf"]').value;
            fetch(window.CTX+'/cart/remove', {
                method: 'POST',
                headers:{'Content-Type':'application/x-www-form-urlencoded','X-Requested-With':'XMLHttpRequest'},
                body: 'cartItemId='+cid+'&_csrf='+csrf
            }).then(function(r){
                if(r.redirected) {
                    // Nếu server chưa update code và trả về redirect 302, ta vẫn giả lập thành công để xóa UI
                    return { success: true };
                }
                return r.json();
            }).then(function(d){
                if(d && d.success){
                    var row = f.closest('.ci-row');
                    if(row) row.remove();
                    
                    itemChecks = document.querySelectorAll('.ci-item-check');
                    if(itemChecks.length === 0) {
                        window.location.reload();
                        return;
                    }
                    
                    recalc();
                    
                    if (d.cartCount !== undefined) {
                        var b1=document.getElementById('siteCartBadge');
                        if(b1) b1.textContent = d.cartCount;
                        var b2=document.getElementById('mobileCartBadge');
                        if(b2) b2.textContent = d.cartCount;
                        
                        var headerCount = document.querySelector('.cart-banner .cb-count');
                        if(headerCount) headerCount.textContent = '(' + d.cartCount + ' sản phẩm)';
                    }
                }
            }).catch(function(err){
                if(btn) btn.style.opacity = '1';
                console.error(err);
            });
        });
    });

    if(!checkAll || itemChecks.length===0) return;

    function fmt(n){return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g,'.');}

    function recalc(){
        var total=0, count=0;
        itemChecks.forEach(function(cb){
            var row=cb.closest('.ci-row');
            var price=parseFloat(row.getAttribute('data-price'))||0;
            var qty=parseInt(row.getAttribute('data-qty'))||0;
            var qtyInput=row.querySelector('input[name="quantity"]');
            if(qtyInput) qty=parseInt(qtyInput.value)||qty;
            var lineTotal=price*qty;
            var lineTotalEl=row.querySelector('.ci-total');
            if(lineTotalEl) lineTotalEl.textContent=fmt(lineTotal)+' đ';
            if(cb.checked){ total+=lineTotal; count++; row.classList.remove('unchecked'); }
            else { row.classList.add('unchecked'); }
        });
        if(csSubLabel) csSubLabel.textContent='Tạm tính ('+count+' sản phẩm)';
        if(csSubVal) csSubVal.textContent=fmt(total)+' đ';
        if(csTotalVal) csTotalVal.textContent=fmt(total)+' đ';
        if(checkoutBtn){
            if(count===0){
                checkoutBtn.style.opacity='.4';checkoutBtn.style.pointerEvents='none';
            } else {
                checkoutBtn.style.opacity='';checkoutBtn.style.pointerEvents='';
                var ids=[];
                itemChecks.forEach(function(cb){ if(cb.checked) ids.push(cb.closest('.ci-row').getAttribute('data-id')); });
                checkoutBtn.href=window.CTX+'/checkout?items='+ids.join(',');
            }
        }
        var allChecked=true;
        itemChecks.forEach(function(cb){if(!cb.checked)allChecked=false;});
        checkAll.checked=allChecked;
    }

    checkAll.addEventListener('change',function(){
        itemChecks.forEach(function(cb){cb.checked=checkAll.checked;});
        recalc();
    });
    itemChecks.forEach(function(cb){cb.addEventListener('change',recalc);});
    recalc();
})();
</script>
<jsp:include page="/WEB-INF/views/layout/support-widget.jsp" />
</body>
</html>
