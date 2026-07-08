<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Không tìm thấy trang — PureNut</title>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    <style>
        .err-wrap{min-height:80vh;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:60px 20px}
        .err-code{font-family:var(--font-display);font-size:96px;color:var(--navy);line-height:1;margin-bottom:10px}
        .err-msg{font-size:20px;color:var(--ink-soft);margin-bottom:28px}
    </style>
</head>
<body>
<div class="grain-overlay" aria-hidden="true"></div>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />
<main class="err-wrap">
    <div class="err-code">404</div>
    <p class="err-msg">Rất tiếc, trang bạn tìm không tồn tại hoặc đã được chuyển đi.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
</main>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
