<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Thanh toán — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--sand:#E9DCBE;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif;--r-lg:24px;--container:1120px;--shadow:0 18px 40px -18px rgba(20,30,20,.22)}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.6;-webkit-font-smoothing:antialiased}
img{max-width:100%;display:block}a{text-decoration:none;color:inherit}button{font:inherit;cursor:pointer;border:none;background:none}
h1,h2,h3{font-family:var(--fd);font-weight:600;letter-spacing:-.01em}
.container{max-width:var(--container);margin:0 auto;padding:0 26px}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:16px 26px;border-radius:99px;font-weight:600;font-size:16px;transition:transform .2s}
.btn-red{background:var(--red);color:#fff}.btn-red:hover{transform:translateY(-2px)}
/* nav — dùng navbar.jsp chung */
.wrap{padding:50px 0 90px}
h1.title{font-size:clamp(28px,4vw,40px);margin-bottom:28px}
.grid{display:grid;grid-template-columns:1.5fr 1fr;gap:32px;align-items:start}
.box{background:var(--paper);border:1px solid var(--line);border-radius:var(--r-lg);padding:32px}
.box h2{font-size:22px;margin-bottom:22px;padding-bottom:14px;border-bottom:1px solid var(--line)}
.field{display:flex;flex-direction:column;gap:7px;margin-bottom:18px}
.field span{font-size:13px;font-weight:600;color:var(--ink-soft)}
.field input{border:1.5px solid var(--line);border-radius:12px;padding:13px 15px;font-size:15px;background:#fff;transition:border-color .2s}
.field input:focus{outline:none;border-color:var(--navy)}
.two{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.pay{display:flex;align-items:center;gap:12px;border:1.5px solid var(--line);border-radius:12px;padding:14px 16px;margin-bottom:12px;cursor:pointer;font-weight:600;transition:border-color .2s}
.pay:hover,.pay input:checked+span{color:var(--navy)}.pay:has(input:checked){border-color:var(--navy);background:#F3F7FD}
.err{background:#FBE2E2;border-left:4px solid var(--red);color:var(--red);padding:13px 16px;border-radius:10px;font-weight:600;margin-bottom:20px}
.summary{position:sticky;top:90px}
.oi{display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px dashed var(--line)}
.oi .n{font-weight:600}.oi .s{font-size:13px;color:var(--ink-soft)}
.srow{display:flex;justify-content:space-between;margin:12px 0;font-size:15px;color:var(--ink-soft)}
.stotal{display:flex;justify-content:space-between;font-family:var(--fd);font-weight:700;font-size:24px;color:var(--red);margin-top:8px}
@media(max-width:860px){.grid{grid-template-columns:1fr}.summary{position:static}.two{grid-template-columns:1fr}}
@media(max-width:480px){
  .wrap{padding:24px 0 60px}
  h1.title{font-size:24px;margin-bottom:18px}
  .box{padding:20px 16px;border-radius:16px}
  .box h2{font-size:18px;margin-bottom:16px;padding-bottom:10px}
  .field input{padding:12px 13px;font-size:14px}
  .pay{padding:12px 14px;font-size:14px}
  .stotal{font-size:20px}
  .btn{padding:14px 20px;font-size:15px;width:100%}
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<main class="wrap"><div class="container">
  <h1 class="title">Thanh toán</h1>
  <form action="${ctx}/checkout" method="POST" id="checkoutForm">
    <div class="grid">
      <div class="box">
        <h2>Thông tin giao hàng</h2>
        <c:if test="${not empty errorMessage}"><div class="err">${errorMessage}</div></c:if>
        <div class="two">
          <label class="field"><span>Họ và tên người nhận *</span><input type="text" name="fullName" value="${not empty param.fullName ? param.fullName : sessionScope.user.fullName}" required></label>
          <label class="field"><span>Số điện thoại *</span><input type="tel" name="phone" value="${not empty param.phone ? param.phone : sessionScope.user.phone}" pattern="0[0-9]{9,10}" maxlength="11" inputmode="numeric" title="Số điện thoại bắt đầu bằng 0, gồm 10–11 chữ số" required></label>
        </div>
        <label class="field"><span>Địa chỉ giao hàng *</span><input type="text" name="address" value="${param.address}" placeholder="Số nhà, đường, phường, quận, thành phố" required></label>
        <label class="field"><span>Mã giảm giá</span><input type="text" name="couponCode" id="coupon" value="${param.couponCode}" placeholder="PURENUT20"></label>
        <h3 style="font-size:17px;margin:24px 0 14px">Phương thức thanh toán</h3>
        <label class="pay"><input type="radio" name="paymentMethod" value="COD" ${param.paymentMethod == 'BANK_TRANSFER' ? '' : 'checked'}><span>Thanh toán khi nhận hàng (COD)</span></label>
        <label class="pay"><input type="radio" name="paymentMethod" value="BANK_TRANSFER" ${param.paymentMethod == 'BANK_TRANSFER' ? 'checked' : ''}><span>Chuyển khoản ngân hàng</span></label>
      </div>
      <div class="box summary">
        <h2>Tóm tắt đơn hàng</h2>
        <c:forEach var="item" items="${cartItems}">
          <div class="oi"><div><div class="n">${item.productName}</div><div class="s">${item.quantity} × ${item.formattedPrice} đ</div></div><div class="n">${item.formattedTotalPrice} đ</div></div>
        </c:forEach>
        <div class="srow" style="margin-top:16px"><span>Tạm tính</span><span>${formattedTotal} đ</span></div>
        <div class="srow" id="discountRow" style="display:none;color:var(--green)"><span>Giảm giá (PURENUT20)</span><span id="discountVal">-0 đ</span></div>
        <div class="srow"><span>Phí vận chuyển</span><span>Miễn phí</span></div>
        <div class="stotal"><span>Tổng</span><span id="grand" data-sub="${totalAmount}">${formattedTotal} đ</span></div>
        <button type="submit" class="btn btn-red" style="width:100%;margin-top:24px">Xác nhận đặt hàng</button>
      </div>
    </div>
  </form>
</div></main>

<script>
(function(){
  var c=document.getElementById('coupon'),g=document.getElementById('grand'),dr=document.getElementById('discountRow'),dv=document.getElementById('discountVal');
  var sub=Math.round(parseFloat(g.getAttribute('data-sub'))||0);
  function fmt(n){return n.toLocaleString('vi-VN').replace(/,/g,'.');}
  function calc(){var code=(c.value||'').trim().toUpperCase();if(code==='PURENUT20'){var d=Math.round(sub*.2);dr.style.display='flex';dv.textContent='-'+fmt(d)+' đ';g.textContent=fmt(sub-d)+' đ';}else{dr.style.display='none';g.textContent=fmt(sub)+' đ';}}
  c.addEventListener('input',calc);
})();
</script>
</body>
</html>
