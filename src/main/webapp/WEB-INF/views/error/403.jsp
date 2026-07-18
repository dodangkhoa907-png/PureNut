<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Phiên làm việc đã hết hạn — PureNut</title>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    <style>
        .err-wrap{min-height:80vh;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:60px 20px}
        .err-code{font-family:var(--font-display);font-size:96px;color:var(--navy);line-height:1;margin-bottom:10px}
        .err-msg{font-size:20px;color:var(--ink-soft);margin-bottom:8px;max-width:480px}
        .err-sub{font-size:14.5px;color:var(--ink-soft);opacity:.75;margin-bottom:28px}
        .err-actions{display:flex;gap:12px;flex-wrap:wrap;justify-content:center}
        .btn-plain{padding:12px 24px;border-radius:99px;border:1.5px solid var(--line, rgba(36,31,24,.15));color:inherit;font-weight:600;background:transparent}
    </style>
</head>
<body>
<div class="grain-overlay" aria-hidden="true"></div>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />
<main class="err-wrap">
    <div class="err-code">403</div>
    <p class="err-msg">Phiên làm việc hoặc thao tác này đã hết hạn.</p>
    <p class="err-sub">Trang bạn gửi có thể đã mở quá lâu hoặc được tải lại từ bộ nhớ đệm. Vui lòng thử lại.</p>
    <div class="err-actions">
        <button type="button" class="btn btn-primary" onclick="history.back()">Quay lại &amp; thử lại</button>
        <a href="${pageContext.request.contextPath}/" class="btn btn-plain">Về trang chủ</a>
    </div>
</main>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
