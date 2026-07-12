<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Kết quả tìm kiếm cho "${fn:escapeXml(keyword)}" — PureNut</title>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    <style>
        .search-page {
            padding: 120px 20px 80px;
            background: var(--cream);
            min-height: calc(100vh - 200px);
        }
        .search-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .search-header {
            margin-bottom: 40px;
            text-align: center;
        }
        .search-title {
            font-family: var(--font-display);
            font-size: 32px;
            color: var(--navy);
            margin-bottom: 10px;
        }
        .search-subtitle {
            color: var(--ink-soft);
            font-size: 16px;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
        }
        .product-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            text-decoration: none;
            color: var(--ink);
            transition: 0.3s;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.08);
        }
        .product-img-wrap {
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }
        .product-img-wrap img {
            height: 200px;
            object-fit: contain;
            transition: 0.5s ease-out;
        }
        .product-card:hover .product-img-wrap img {
            transform: scale(1.05) rotate(2deg);
        }
        .product-info {
            padding: 24px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .product-name {
            font-family: var(--font-display);
            font-size: 20px;
            color: var(--navy);
            margin-bottom: 10px;
            font-weight: 700;
        }
        .product-price {
            font-weight: 700;
            font-size: 18px;
            color: var(--red);
            margin-top: auto;
        }
        
        .no-results {
            text-align: center;
            padding: 60px 20px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
        }
        .no-results i {
            font-size: 64px;
            color: rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .no-results p {
            color: var(--ink-soft);
            font-size: 18px;
        }
        @media(max-width:860px){
            .search-page{padding:100px 16px 60px}
            .search-title{font-size:26px}
            .search-subtitle{font-size:14px}
            .product-grid{gap:20px}
        }
        @media(max-width:520px){
            .search-page{padding:80px 12px 40px}
            .search-title{font-size:22px}
            .search-subtitle{font-size:13px}
            .product-grid{grid-template-columns:1fr;gap:16px}
            .product-img-wrap{padding:24px 16px}
            .product-img-wrap img{height:150px}
            .product-info{padding:16px}
            .product-name{font-size:17px}
            .product-price{font-size:16px}
            .no-results{padding:40px 16px}
            .no-results p{font-size:15px}
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<main class="search-page">
    <div class="search-container">
        <div class="search-header">
            <h1 class="search-title">Kết quả tìm kiếm</h1>
            <p class="search-subtitle">
                Tìm thấy <strong>${products.size()}</strong> sản phẩm cho từ khoá "<strong>${fn:escapeXml(keyword)}</strong>"
            </p>
        </div>
        
        <c:choose>
            <c:when test="${empty products}">
                <div class="no-results">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <p>Rất tiếc, chúng tôi không tìm thấy sản phẩm nào khớp với yêu cầu của bạn.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary" style="margin-top: 20px;">Xem tất cả sản phẩm</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="p" items="${products}">
                        <a href="${pageContext.request.contextPath}/products/${p.slug}" class="product-card">
                            <div class="product-img-wrap" style="background-color: ${fn:escapeXml(p.bgColorHex)}">
                                <img src="${pageContext.request.contextPath}${p.imageUrl}" alt="${fn:escapeXml(p.name)}" onerror="this.onerror=null;this.src=&quot;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Crect width='100%25' height='100%25' fill='%23EDE6D2'/%3E%3Ctext x='50%25' y='56%25' font-size='52' text-anchor='middle'%3E%F0%9F%A5%9B%3C/text%3E%3C/svg%3E&quot;">
                            </div>
                            <div class="product-info">
                                <h3 class="product-name"><c:out value="${p.name}"/></h3>
                                <p style="color: var(--ink-soft); font-size: 14px; margin-bottom: 15px;">
                                    ${p.volumeMl}ml • ${p.kcalPer100ml} kcal/100ml
                                </p>
                                <div class="product-price">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
        
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

</body>
</html>
