<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập Quản trị — PureNut Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
<div class="admin-login-wrap">
    <div class="admin-login-card">
        <div class="admin-login-brand">
            <svg viewBox="0 0 34 34" aria-hidden="true">
                <circle cx="17" cy="17" r="17" fill="#CE2E2E"/>
                <path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.6"/>
            </svg>
            <b>PureNut</b>
        </div>
        <span class="admin-login-tag">Bảng điều khiển quản trị</span>

        <h1>Đăng nhập hệ thống</h1>
        <p class="sub">Khu vực dành riêng cho quản trị viên PureNut.</p>

        <c:if test="${not empty errorMessage}">
            <div class="admin-alert">${errorMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/login" method="POST">
            <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
            <div class="admin-field">
                <label for="email">Email quản trị</label>
                <input type="email" id="email" name="email" placeholder="khoaddty00210@gmail.com" required autofocus>
            </div>
            <div class="admin-field">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="admin-btn">Đăng nhập quản trị</button>
        </form>

        <div class="admin-login-foot">
            Bạn là khách hàng?
            <a href="${pageContext.request.contextPath}/login">Đăng nhập tại đây</a>
        </div>
    </div>
</div>
</body>
</html>
