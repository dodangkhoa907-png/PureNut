<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${sessionScope._csrf}">
<title><c:out value="${combo.name}"/> — PureNut</title>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700;1,9..144,500&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
.cd-head{padding:44px 0 30px}
.cd-head-inner{display:grid;grid-template-columns:320px 1fr;gap:36px;align-items:start}
.cd-thumb{aspect-ratio:4/3;border-radius:22px;overflow:hidden;background:#EDE6D2}
.cd-thumb img{width:100%;height:100%;object-fit:cover}
.cd-head h1{font-size:clamp(26px,3.6vw,38px);margin-bottom:10px}
.cd-head p{color:var(--ink-soft);margin-bottom:16px}
.cd-price-row{display:flex;align-items:baseline;gap:12px;margin-bottom:22px}
.cd-price{font-family:var(--fd);font-weight:700;font-size:30px;color:var(--navy)}
.cd-price-orig{font-size:16px;color:var(--ink-soft);text-decoration:line-through}

.cd-qty-row{display:flex;align-items:center;gap:16px;margin-bottom:18px}
.cd-stepper{display:flex;align-items:center;gap:0;border:1.5px solid var(--line);border-radius:12px;overflow:hidden}
.cd-stepper button{width:40px;height:44px;background:var(--cream);border:none;font-weight:700;font-size:16px;cursor:pointer}
.cd-stepper input{width:56px;height:44px;text-align:center;border:none;border-left:1.5px solid var(--line);border-right:1.5px solid var(--line);font-weight:700;font-size:15px}

.cd-items-title{font-weight:700;font-size:16px;margin:30px 0 14px}
.cd-items{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:14px}
.cd-item{display:flex;align-items:center;gap:12px;border:1px solid var(--line);border-radius:14px;padding:12px 14px;background:#fff}
.cd-item img{width:48px;height:48px;border-radius:10px;object-fit:cover;background:#f0ebe0;flex-shrink:0}
.cd-item-name{font-size:13.5px;font-weight:600;flex:1;min-width:0}
.cd-item-qty{font-size:13px;font-weight:800;color:var(--navy);white-space:nowrap}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<c:if test="${not empty param.error}">
<div class="toast show" style="background:#CE2E2E"><c:out value="${param.error}"/></div>
</c:if>

<section class="cd-head">
  <div class="container cd-head-inner">
    <div class="cd-thumb">
      <img src="${ctx}${combo.imageUrl}" alt="${fn:escapeXml(combo.name)}"
           onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'200\' height=\'150\'%3E%3Crect width=\'100%25\' height=\'100%25\' fill=\'%23EDE6D2\'/%3E%3Ctext x=\'50%25\' y=\'56%25\' font-size=\'56\' text-anchor=\'middle\'%3E%F0%9F%8E%81%3C/text%3E%3C/svg%3E'">
    </div>
    <div>
      <h1><c:out value="${combo.name}"/></h1>
      <p><c:out value="${combo.description}"/></p>
      <div class="cd-price-row">
        <span class="cd-price">${combo.formattedPrice}₫</span>
        <c:if test="${combo.originalTotalPrice > combo.comboPrice}">
          <span class="cd-price-orig">${combo.formattedOriginalTotalPrice}₫</span>
        </c:if>
      </div>

      <form id="comboForm" action="${ctx}/combo/them-vao-gio" method="POST">
        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
        <input type="hidden" name="comboId" value="${combo.comboId}">
        <div class="cd-qty-row">
          <div class="cd-stepper">
            <button type="button" id="qtyDec">−</button>
            <input type="text" name="quantity" id="qtyInput" value="1" readonly>
            <button type="button" id="qtyInc">+</button>
          </div>
          <button type="submit" class="btn btn-primary">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
            Thêm vào giỏ
          </button>
        </div>
      </form>

      <div class="cd-items-title">Combo này gồm có:</div>
      <div class="cd-items">
        <c:forEach var="it" items="${combo.items}">
          <div class="cd-item">
            <img src="${ctx}${it.productImageUrl}" alt="${fn:escapeXml(it.productName)}" onerror="this.style.visibility='hidden'">
            <div class="cd-item-name"><c:out value="${it.productName}"/></div>
            <div class="cd-item-qty">×${it.quantity}</div>
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
(function(){
    var qtyInput = document.getElementById('qtyInput');
    document.getElementById('qtyInc').addEventListener('click', function(){
        qtyInput.value = (parseInt(qtyInput.value) || 1) + 1;
    });
    document.getElementById('qtyDec').addEventListener('click', function(){
        qtyInput.value = Math.max(1, (parseInt(qtyInput.value) || 1) - 1);
    });
})();
</script>
</body>
</html>
