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
<title>Combo ưu đãi — PureNut</title>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;0,9..144,700;1,9..144,500&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<style>
.cb-head{text-align:center;padding:52px 0 40px}
.cb-head h1{font-size:clamp(30px,4.6vw,46px)}
.cb-head p{color:var(--ink-soft);margin-top:10px;font-size:16px}
.cb-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:24px;padding:0 0 70px}
.cb-card{background:#fff;border-radius:22px;overflow:hidden;border:1px solid var(--line);transition:transform .3s,box-shadow .3s;display:flex;flex-direction:column}
.cb-card:hover{transform:translateY(-8px);box-shadow:var(--shadow)}

.cb-thumb{aspect-ratio:4/3;background:#EDE6D2;position:relative;overflow:hidden}
.cb-thumb img.cb-main-img{width:100%;height:100%;object-fit:cover;transition:transform .4s}
.cb-card:hover .cb-main-img{transform:scale(1.06)}

/* Hover overlay: blur nền + mini-thumbnail sản phẩm bên trong combo */
.cb-hover{
  position:absolute;inset:0;
  background:rgba(11,37,71,.62);backdrop-filter:blur(6px);-webkit-backdrop-filter:blur(6px);
  display:flex;flex-direction:column;align-items:center;justify-content:center;gap:14px;
  opacity:0;transition:opacity .3s ease;pointer-events:none;
}
.cb-card:hover .cb-hover{opacity:1}
.cb-hover-mini{display:flex;gap:8px;transform:translateY(10px);opacity:0;transition:transform .35s ease .05s,opacity .35s ease .05s}
.cb-card:hover .cb-hover-mini{transform:translateY(0);opacity:1}
.cb-hover-mini img{width:46px;height:46px;border-radius:12px;object-fit:cover;border:2px solid rgba(255,255,255,.85);background:#fff;box-shadow:0 6px 14px rgba(0,0,0,.25)}
.cb-hover-more{width:46px;height:46px;border-radius:12px;background:rgba(255,255,255,.18);border:2px solid rgba(255,255,255,.85);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:13px}
.cb-hover-btn{
  background:#fff;color:var(--navy);font-weight:700;font-size:13.5px;padding:10px 22px;border-radius:99px;
  transform:translateY(10px);opacity:0;transition:transform .35s ease .12s,opacity .35s ease .12s;
}
.cb-card:hover .cb-hover-btn{transform:translateY(0);opacity:1}

.cb-body{padding:20px 22px 22px}
.cb-body h3{font-size:19px;margin-bottom:8px}
.cb-rules{font-size:13px;color:var(--ink-soft);font-weight:600;margin-bottom:14px}
.cb-price-row{display:flex;align-items:baseline;gap:10px}
.cb-price{font-family:var(--fd);font-weight:700;font-size:22px;color:var(--navy)}
.cb-price-orig{font-size:13px;color:var(--ink-soft);text-decoration:line-through}
.cb-empty{text-align:center;padding:60px 0;color:var(--ink-soft);font-weight:600;grid-column:1/-1}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<section class="cb-head">
  <div class="container">
    <span class="eyebrow" style="color:var(--navy)">Ưu đãi trọn gói</span>
    <h1>Combo tiết kiệm PureNut</h1>
    <p>Bộ sản phẩm được PureNut chọn sẵn — giá tốt hơn mua lẻ.</p>
  </div>
</section>

<div class="container cb-grid">
<c:forEach var="cb" items="${combos}">
  <a class="cb-card" href="${ctx}/combo/${cb.slug}">
    <div class="cb-thumb">
      <img class="cb-main-img" src="${ctx}${cb.imageUrl}" alt="${fn:escapeXml(cb.name)}"
           onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'200\' height=\'150\'%3E%3Crect width=\'100%25\' height=\'100%25\' fill=\'%23EDE6D2\'/%3E%3Ctext x=\'50%25\' y=\'56%25\' font-size=\'56\' text-anchor=\'middle\'%3E%F0%9F%8E%81%3C/text%3E%3C/svg%3E'">
      <div class="cb-hover">
        <div class="cb-hover-mini">
          <c:forEach var="it" items="${cb.items}" varStatus="st" begin="0" end="2">
            <img src="${ctx}${it.productImageUrl}" alt="${fn:escapeXml(it.productName)}" onerror="this.style.visibility='hidden'">
          </c:forEach>
          <c:if test="${fn:length(cb.items) > 3}">
            <div class="cb-hover-more">+${fn:length(cb.items) - 3}</div>
          </c:if>
        </div>
        <span class="cb-hover-btn">Xem chi tiết</span>
      </div>
    </div>
    <div class="cb-body">
      <h3><c:out value="${cb.name}"/></h3>
      <div class="cb-rules">
        <c:forEach var="it" items="${cb.items}" varStatus="st">
          <c:out value="${it.productName}"/> ×${it.quantity}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
      </div>
      <div class="cb-price-row">
        <span class="cb-price">${cb.formattedPrice}₫</span>
        <c:if test="${cb.originalTotalPrice > cb.comboPrice}">
          <span class="cb-price-orig">${cb.formattedOriginalTotalPrice}₫</span>
        </c:if>
      </div>
    </div>
  </a>
</c:forEach>
<c:if test="${empty combos}">
  <div class="cb-empty">Hiện chưa có combo nào, quay lại sau nhé!</div>
</c:if>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
