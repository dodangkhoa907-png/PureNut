<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Thanh toán — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--navy-darker:#0B2547;--red:#CE2E2E;--green:#2BAC62;--cream:#FBF6EC;--paper:#FFFDF8;--sand:#E9DCBE;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif;--r-lg:24px;--container:1120px;--shadow:0 18px 40px -18px rgba(20,30,20,.22)}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.6;overflow-x:hidden;-webkit-font-smoothing:antialiased}
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
@media(max-width:520px){
  .wrap{padding:24px 0 60px}
  .container{padding:0 14px}
  h1.title{font-size:22px;margin-bottom:16px}
  .box{padding:18px 14px;border-radius:14px}
  .box h2{font-size:17px;margin-bottom:14px;padding-bottom:10px}
  .field span{font-size:12px}
  .field input{padding:11px 12px;font-size:13px;border-radius:10px}
  .pay{padding:11px 12px;font-size:13px;border-radius:10px}
  .srow{font-size:13px}
  .stotal{font-size:18px}
  .btn{padding:13px 18px;font-size:14px;width:100%}
  .oi .n{font-size:13px}
  .oi .s{font-size:12px}
}
@media(max-width:380px){
  h1.title{font-size:20px}
  .box{padding:14px 12px}
  .box h2{font-size:16px}
  .field input{font-size:12px}
  .stotal{font-size:16px}
}
/* ── QR thanh toán PayOS ── */
.qr-ov{position:fixed;inset:0;z-index:1000;background:rgba(11,37,71,.55);backdrop-filter:blur(4px);display:none;align-items:center;justify-content:center;padding:20px;opacity:0;transition:opacity .3s}
.qr-ov.show{display:flex;opacity:1}
.qr-card{background:var(--paper);border-radius:26px;width:100%;max-width:400px;box-shadow:0 30px 70px -20px rgba(11,37,71,.5);overflow:hidden;transform:translateY(24px) scale(.96);transition:transform .35s cubic-bezier(.34,1.56,.64,1)}
.qr-ov.show .qr-card{transform:translateY(0) scale(1)}
.qr-head{background:linear-gradient(135deg,var(--navy),var(--navy-darker));color:#fff;padding:22px 24px;position:relative}
.qr-head h3{font-size:20px;color:#fff;margin-bottom:3px}
.qr-head p{font-size:13px;opacity:.85}
.qr-close{position:absolute;top:16px;right:16px;width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.15);color:#fff;font-size:20px;display:flex;align-items:center;justify-content:center;transition:background .2s}
.qr-close:hover{background:rgba(255,255,255,.3)}
.qr-body{padding:24px;text-align:center}
.qr-img{width:230px;height:230px;margin:0 auto 4px;padding:14px;background:#fff;border-radius:18px;border:1.5px solid var(--line);box-shadow:0 10px 24px -12px rgba(20,30,20,.25)}
.qr-img img,.qr-img canvas{width:100%!important;height:100%!important}
.qr-amount{font-family:var(--fd);font-weight:700;font-size:28px;color:var(--red);margin:14px 0 2px}
.qr-hint{font-size:13px;color:var(--ink-soft);line-height:1.5;margin-bottom:16px}
.qr-status{display:inline-flex;align-items:center;gap:9px;font-weight:600;font-size:14px;padding:10px 18px;border-radius:99px;background:#FFF6E5;color:#B7791F}
.qr-status.paid{background:#E4F7EC;color:var(--green)}
.qr-spin{width:15px;height:15px;border:2.5px solid currentColor;border-top-color:transparent;border-radius:50%;animation:qrspin .8s linear infinite}
@keyframes qrspin{to{transform:rotate(360deg)}}
.qr-check{width:66px;height:66px;margin:0 auto 12px;border-radius:50%;background:var(--green);display:none;align-items:center;justify-content:center;animation:qrpop .5s cubic-bezier(.34,1.56,.64,1)}
@keyframes qrpop{0%{transform:scale(0)}100%{transform:scale(1)}}
.qr-alt{display:block;margin-top:16px;font-size:13px;color:var(--navy);font-weight:600;text-decoration:underline}
@media(max-width:520px){.qr-card{max-width:100%;border-radius:20px}.qr-img{width:200px;height:200px}.qr-amount{font-size:24px}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<main class="wrap"><div class="container">
  <h1 class="title">Thanh toán</h1>
  <form action="${ctx}/checkout" method="POST" id="checkoutForm">
    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
    <c:if test="${not empty param.items}"><input type="hidden" name="items" value="${fn:escapeXml(param.items)}"></c:if>
    <div class="grid">
      <div class="box">
        <h2>Thông tin giao hàng</h2>
        <c:if test="${not empty errorMessage}"><div class="err"><c:out value="${errorMessage}"/></div></c:if>
        <div class="two">
          <label class="field"><span>Họ và tên người nhận *</span><input type="text" name="fullName" value="${fn:escapeXml(not empty param.fullName ? param.fullName : (not empty savedName ? savedName : sessionScope.user.fullName))}" required></label>
          <label class="field"><span>Số điện thoại *</span><input type="tel" name="phone" value="${fn:escapeXml(not empty param.phone ? param.phone : (not empty savedPhone ? savedPhone : sessionScope.user.phone))}" pattern="0[0-9]{9,10}" maxlength="11" inputmode="numeric" title="Số điện thoại bắt đầu bằng 0, gồm 10–11 chữ số" required></label>
        </div>
        <label class="field"><span>Địa chỉ giao hàng *</span><input type="text" name="address" id="addrInput" value="${fn:escapeXml(not empty param.address ? param.address : savedAddress)}" placeholder="Số nhà, đường, phường, quận, thành phố" required></label>
        <button type="button" id="geoLocBtn" onclick="geoLocate()" style="display:inline-flex;align-items:center;justify-content:center;gap:8px;width:100%;padding:13px 16px;border-radius:12px;background:var(--paper);border:1.5px solid var(--navy);color:var(--navy);font-weight:600;font-size:14px;margin-bottom:14px;cursor:pointer;transition:all .2s">
          <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="3"/><line x1="12" y1="2" x2="12" y2="5"/><line x1="12" y1="19" x2="12" y2="22"/><line x1="2" y1="12" x2="5" y2="12"/><line x1="19" y1="12" x2="22" y2="12"/></svg>
          <span id="geoLocText">Định vị vị trí hiện tại</span>
        </button>
        <div id="addrMap" style="display:none;width:100%;height:180px;border-radius:12px;margin-bottom:14px;border:1.5px solid var(--line);overflow:hidden"></div>
        <label class="field"><span>Mã giảm giá</span><input type="text" name="couponCode" id="coupon" value="${fn:escapeXml(param.couponCode)}" placeholder="Nhập mã giảm giá (nếu có)"></label>
        <h3 style="font-size:17px;margin:24px 0 14px">Phương thức thanh toán</h3>
        <label class="pay"><input type="radio" name="paymentMethod" value="COD" ${param.paymentMethod == 'BANK_TRANSFER' ? '' : 'checked'}><span>Thanh toán khi nhận hàng (COD)</span></label>
        <label class="pay"><input type="radio" name="paymentMethod" value="BANK_TRANSFER" ${param.paymentMethod == 'BANK_TRANSFER' ? 'checked' : ''}><span>Chuyển khoản ngân hàng</span></label>
      </div>
      <div class="box summary">
        <h2>Tóm tắt đơn hàng</h2>
        <c:forEach var="item" items="${cartItems}">
          <div class="oi"><div><div class="n"><c:out value="${item.productName}"/></div><div class="s">${item.quantity} × ${item.formattedPrice} đ</div></div><div class="n">${item.formattedTotalPrice} đ</div></div>
        </c:forEach>
        <div class="srow" style="margin-top:16px"><span>Tạm tính</span><span>${formattedTotal} đ</span></div>
        <div class="srow" id="discountRow" style="display:none;color:var(--green)"><span>Giảm giá</span><span id="discountVal">-0 đ</span></div>
        <div class="srow"><span>Phí vận chuyển</span><span>Miễn phí</span></div>
        <div class="stotal"><span>Tổng</span><span id="grand" data-sub="${totalAmount}">${formattedTotal} đ</span></div>
        <button type="submit" class="btn btn-red" style="width:100%;margin-top:24px">Xác nhận đặt hàng</button>
      </div>
    </div>
  </form>
</div></main>

<!-- ── Cửa sổ QR thanh toán PayOS ── -->
<div class="qr-ov" id="qrOverlay">
  <div class="qr-card">
    <div class="qr-head">
      <button type="button" class="qr-close" onclick="closeQr()" aria-label="Đóng">&times;</button>
      <h3>Quét mã để thanh toán</h3>
      <p>Dùng app ngân hàng hoặc ví điện tử bất kỳ</p>
    </div>
    <div class="qr-body">
      <div class="qr-check" id="qrCheck">
        <svg viewBox="0 0 24 24" style="width:34px;height:34px;stroke:#fff;fill:none;stroke-width:3;stroke-linecap:round;stroke-linejoin:round"><polyline points="20 6 9 17 4 12"/></svg>
      </div>
      <div class="qr-img" id="qrImg"></div>
      <div class="qr-amount" id="qrAmount"></div>
      <div class="qr-hint">Mã QR tự động xác nhận sau khi bạn chuyển khoản thành công. Vui lòng không đóng cửa sổ này.</div>
      <div class="qr-status" id="qrStatus"><span class="qr-spin"></span><span id="qrStatusText">Đang chờ thanh toán…</span></div>
      <a class="qr-alt" id="qrAltLink" href="#" target="_blank" rel="noopener">Mở trang thanh toán PayOS ↗</a>
    </div>
  </div>
</div>

<script>
(function(){
  var pinIcon=L.divIcon({className:'',html:'<div style="position:relative;width:30px;height:45px;filter:drop-shadow(0 3px 4px rgba(0,0,0,.35));transition:transform .3s cubic-bezier(.34,1.56,.64,1)" id="pinSvg"><svg width="30" height="45" viewBox="0 0 30 45" xmlns="http://www.w3.org/2000/svg"><path d="M15 0C6.7 0 0 6.7 0 15c0 11.25 15 30 15 30s15-18.75 15-30C30 6.7 23.3 0 15 0z" fill="#CE2E2E"/><circle cx="15" cy="14" r="6" fill="#fff"/></svg></div>',iconSize:[30,45],iconAnchor:[15,45],popupAnchor:[0,-40]});
  var addrMap=null,addrMarker=null;
  function reverseGeoFill(lat,lng){
    fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat='+lat+'&lon='+lng+'&accept-language=vi&addressdetails=1')
    .then(function(r){return r.json()}).then(function(d){
      var a=d.address||{},parts=[];
      if(a.house_number)parts.push(a.house_number);
      if(a.road)parts.push(a.road);
      var ward=a.quarter||a.village||a.town||a.neighbourhood||'';if(ward)parts.push(ward);
      var district=a.county||a.suburb||a.city_district||'';if(district)parts.push(district);
      var city=a.city||a.state||a.province||'';if(city)parts.push(city);
      document.getElementById('addrInput').value=parts.join(', ');
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

  // ── Thanh toán PayOS (Chuyển khoản) ──────────────────────
  var CTX='${ctx}',pollTimer=null,curOrderCode=null,qrDone=false;
  var form=document.getElementById('checkoutForm');
  var submitBtn=form.querySelector('button[type=submit]');

  function fmt(n){return String(n).replace(/\B(?=(\d{3})+(?!\d))/g,'.')}

  form.addEventListener('submit',function(e){
    var pm=(form.querySelector('input[name=paymentMethod]:checked')||{}).value;
    if(pm!=='BANK_TRANSFER')return; // COD → submit thường
    e.preventDefault();
    if(!form.reportValidity())return;
    submitBtn.disabled=true;submitBtn.style.opacity='.6';submitBtn.textContent='Đang tạo mã QR…';
    var body=new URLSearchParams(new FormData(form));
    fetch(CTX+'/checkout',{method:'POST',body:body,headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'}})
      .then(function(r){return r.json()})
      .then(function(d){
        submitBtn.disabled=false;submitBtn.style.opacity='1';submitBtn.textContent='Xác nhận đặt hàng';
        if(!d.ok){alert(d.msg||'Không thể tạo thanh toán, vui lòng thử lại.');return}
        openQr(d);
      })
      .catch(function(){submitBtn.disabled=false;submitBtn.style.opacity='1';submitBtn.textContent='Xác nhận đặt hàng';alert('Lỗi kết nối, vui lòng thử lại.')});
  });

  function openQr(d){
    qrDone=false;curOrderCode=d.orderCode;
    var box=document.getElementById('qrImg');box.innerHTML='';
    if(typeof QRCode!=='undefined'){new QRCode(box,{text:d.qrCode,width:210,height:210,colorDark:'#0B2547',colorLight:'#ffffff',correctLevel:QRCode.CorrectLevel.M})}
    else{box.innerHTML='<div style="padding:20px;font-size:12px;color:#6B6357">Quét QR không khả dụng.<br>Dùng link bên dưới.</div>'}
    document.getElementById('qrAmount').textContent=fmt(d.amount)+' đ';
    document.getElementById('qrAltLink').href=d.checkoutUrl||'#';
    document.getElementById('qrCheck').style.display='none';
    document.getElementById('qrImg').style.display='block';
    var st=document.getElementById('qrStatus');st.className='qr-status';
    document.getElementById('qrStatusText').textContent='Đang chờ thanh toán…';
    document.getElementById('qrOverlay').classList.add('show');
    startPolling();
  }

  function startPolling(){
    clearInterval(pollTimer);
    pollTimer=setInterval(function(){
      if(!curOrderCode){return}
      fetch(CTX+'/checkout',{method:'POST',body:new URLSearchParams({action:'qr-status',orderCode:curOrderCode,_csrf:'${sessionScope._csrf}'}),headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'}})
        .then(function(r){return r.json()})
        .then(function(d){
          if(d.status==='PAID'){onPaid(d.redirect)}
          else if(d.status==='CANCELLED'||d.status==='EXPIRED'){onExpired(d.status)}
        }).catch(function(){});
    },3000);
  }

  function onPaid(redirect){
    if(qrDone)return;qrDone=true;clearInterval(pollTimer);
    document.getElementById('qrImg').style.display='none';
    document.getElementById('qrCheck').style.display='flex';
    var st=document.getElementById('qrStatus');st.className='qr-status paid';
    st.querySelector('.qr-spin').style.display='none';
    document.getElementById('qrStatusText').textContent='Thanh toán thành công!';
    setTimeout(function(){window.location.href=redirect||CTX+'/checkout/success'},1400);
  }

  function onExpired(status){
    clearInterval(pollTimer);
    var st=document.getElementById('qrStatus');st.className='qr-status';
    st.querySelector('.qr-spin').style.display='none';
    document.getElementById('qrStatusText').textContent=(status==='EXPIRED'?'Mã QR đã hết hạn':'Đã hủy thanh toán')+' — vui lòng thử lại';
  }

  window.closeQr=function(){
    if(qrDone){window.location.href=CTX+'/checkout/success';return}
    clearInterval(pollTimer);
    if(curOrderCode){navigator.sendBeacon?fetch(CTX+'/checkout',{method:'POST',body:new URLSearchParams({action:'qr-cancel',orderCode:curOrderCode,_csrf:'${sessionScope._csrf}'}),headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'}}).catch(function(){}):null}
    document.getElementById('qrOverlay').classList.remove('show');
  };
})();
</script>
<jsp:include page="/WEB-INF/views/layout/support-widget.jsp" />
</body>
</html>
