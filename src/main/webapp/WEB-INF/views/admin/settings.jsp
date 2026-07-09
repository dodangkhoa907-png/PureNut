<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
    .set-grid{display:grid;grid-template-columns:.85fr 1.15fr;gap:24px;align-items:start}
    .profile{text-align:center}
    .profile .ava{width:96px;height:96px;border-radius:24px;margin:0 auto 16px;box-shadow:0 16px 30px -14px rgba(27,79,158,.5)}
    .profile h3{font-family:var(--fd);font-size:22px;font-weight:700}
    .profile .role{display:inline-flex;align-items:center;gap:7px;margin:8px 0 20px;background:rgba(27,79,158,.1);color:var(--admin-primary);font-weight:700;font-size:12.5px;padding:6px 14px;border-radius:20px}
    .info-row{display:flex;align-items:center;gap:13px;text-align:left;padding:13px 0;border-top:1px solid var(--admin-border)}
    .info-row .ic{width:40px;height:40px;border-radius:11px;background:var(--admin-bg);display:flex;align-items:center;justify-content:center;color:var(--admin-primary);flex:none}
    .info-row .lb{font-size:12px;color:var(--admin-text-light);font-weight:600}
    .info-row .vl{font-size:14.5px;font-weight:700;word-break:break-all}
    .alert{border-radius:12px;padding:13px 16px;font-size:13.5px;font-weight:600;margin-bottom:18px;display:flex;gap:9px;align-items:flex-start}
    .alert.ok{background:rgba(18,183,106,.1);color:#0E8A50;border:1px solid rgba(18,183,106,.3)}
    .alert.err{background:rgba(238,93,80,.1);color:#C0392B;border:1px solid rgba(238,93,80,.3)}
    .alert.info{background:rgba(57,101,255,.1);color:#2B4ECC;border:1px solid rgba(57,101,255,.28)}
    .steps{display:flex;gap:10px;margin-bottom:22px}
    .step{flex:1;display:flex;gap:11px;align-items:center;background:var(--admin-bg);border-radius:12px;padding:12px 14px}
    .step .n{width:28px;height:28px;border-radius:50%;background:#fff;color:var(--admin-primary);font-weight:800;display:flex;align-items:center;justify-content:center;font-size:13px;flex:none;border:2px solid var(--admin-primary)}
    .step.done .n{background:var(--admin-primary);color:#fff}
    .step p{font-size:12.5px;font-weight:700;line-height:1.25}
    .step p small{display:block;font-weight:500;color:var(--admin-text-light)}
    .otp-row{display:flex;gap:12px;align-items:flex-end;margin-bottom:20px}
    .otp-row .form-group{flex:1;margin:0}
    .pw-hint{font-size:12px;color:var(--admin-text-light);margin-top:6px}
    .grid2{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    .pw-box{position:relative}
    .pw-box .eye{position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--admin-text-light);cursor:pointer;padding:4px;font-size:15px}
    @media(max-width:900px){.set-grid{grid-template-columns:1fr}.grid2{grid-template-columns:1fr}}
</style>

<div class="set-grid">
    <!-- Hồ sơ -->
    <div class="card profile">
        <img class="ava" src="https://ui-avatars.com/api/?name=${sessionScope.adminUser.fullName}&background=1B4F9E&color=fff&bold=true&size=128" alt="Avatar">
        <h3>${sessionScope.adminUser.fullName}</h3>
        <div class="role"><i class="fa-solid fa-shield-halved"></i> Quản trị viên</div>
        <div class="info-row"><div class="ic"><i class="fa-solid fa-envelope"></i></div><div><div class="lb">Email nhận mã</div><div class="vl">${sessionScope.adminUser.email}</div></div></div>
        <div class="info-row"><div class="ic"><i class="fa-solid fa-phone"></i></div><div><div class="lb">Số điện thoại</div><div class="vl">${sessionScope.adminUser.phone}</div></div></div>
        <div class="info-row"><div class="ic"><i class="fa-solid fa-fingerprint"></i></div><div><div class="lb">Mã tài khoản</div><div class="vl">#${sessionScope.adminUser.userId}</div></div></div>
    </div>

    <!-- Đổi mật khẩu -->
    <div class="card">
        <div class="card-header" style="margin-bottom:18px"><div class="card-title" style="font-family:var(--fd);font-size:19px;font-weight:700">Đổi mật khẩu<small style="display:block;font-family:var(--fb);font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-top:2px">Xác thực 2 lớp qua mã gửi về email của bạn</small></div></div>

        <c:if test="${not empty successMessage}"><div class="alert ok"><i class="fa-solid fa-circle-check"></i> ${successMessage}</div></c:if>
        <c:if test="${not empty infoMessage}"><div class="alert info"><i class="fa-solid fa-envelope-circle-check"></i> ${infoMessage}</div></c:if>
        <c:if test="${not empty errorMessage}"><div class="alert err"><i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}</div></c:if>

        <div class="steps">
            <div class="step ${codeSent ? 'done' : ''}"><span class="n"><c:choose><c:when test="${codeSent}"><i class="fa-solid fa-check"></i></c:when><c:otherwise>1</c:otherwise></c:choose></span><p>Gửi mã<small>về email admin</small></p></div>
            <div class="step"><span class="n">2</span><p>Nhập mã &amp; mật khẩu<small>hoàn tất đổi</small></p></div>
        </div>

        <!-- Bước 1: gửi mã -->
        <form method="post" action="${pageContext.request.contextPath}/admin/settings" style="margin-bottom:18px">
            <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
            <input type="hidden" name="action" value="send-code">
            <button type="submit" class="btn btn-outline" style="width:100%;justify-content:center">
                <i class="fa-solid fa-paper-plane"></i> ${codeSent ? 'Gửi lại mã xác nhận' : 'Gửi mã xác nhận về email'}
            </button>
        </form>

        <!-- Bước 2: đổi mật khẩu -->
        <form method="post" action="${pageContext.request.contextPath}/admin/settings">
            <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
            <input type="hidden" name="action" value="change-password">
            <div class="otp-row">
                <div class="form-group">
                    <label>Mã xác nhận (OTP)</label>
                    <input type="text" name="code" class="form-control" placeholder="6 chữ số" maxlength="6" inputmode="numeric" style="letter-spacing:6px;font-weight:700" required>
                </div>
            </div>
            <div class="form-group">
                <label>Mật khẩu hiện tại</label>
                <div class="pw-box"><input type="password" id="cur" name="currentPassword" class="form-control" placeholder="••••••••" required><button type="button" class="eye" onclick="tp('cur')"><i class="fa-regular fa-eye"></i></button></div>
            </div>
            <div class="grid2">
                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <div class="pw-box"><input type="password" id="np" name="newPassword" class="form-control" placeholder="••••••••" required><button type="button" class="eye" onclick="tp('np')"><i class="fa-regular fa-eye"></i></button></div>
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <div class="pw-box"><input type="password" id="cp" name="confirmPassword" class="form-control" placeholder="••••••••" required><button type="button" class="eye" onclick="tp('cp')"><i class="fa-regular fa-eye"></i></button></div>
                </div>
            </div>
            <p class="pw-hint">Tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số &amp; ký tự đặc biệt.</p>
            <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;margin-top:8px"><i class="fa-solid fa-lock"></i> Đổi mật khẩu</button>
        </form>
    </div>
</div>

<script>function tp(id){var i=document.getElementById(id);i.type=i.type==='password'?'text':'password';}</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
