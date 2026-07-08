<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="footer">
  <div class="container footer-grid">
    <div class="footer-brand">
      <a href="${pageContext.request.contextPath}/" class="logo logo-footer">
        <svg width="34" height="34" viewBox="0 0 34 34" aria-hidden="true">
          <circle cx="17" cy="17" r="17" fill="#CE2E2E"/>
          <path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.6"/>
          <path d="M11 14.5c1.5-1.8 3.6-2.8 6-2.8" fill="none" stroke="#fff" stroke-width="1.6" stroke-linecap="round"/>
        </svg>
        <span class="logo-text">Pure<b>Nut</b></span>
      </a>
      <p>Sữa hạt thực vật 100% tự nhiên, ngon khỏe mỗi ngày. Sản xuất tại Việt Nam.</p>
      <div class="footer-social">
        <a href="#" aria-label="Facebook">F</a>
        <a href="#" aria-label="Instagram">I</a>
        <a href="#" aria-label="Tiktok">T</a>
      </div>
    </div>
    <div class="footer-col">
      <h4>Khám phá</h4>
      <a href="${pageContext.request.contextPath}/products">Cửa hàng</a>
      <a href="${pageContext.request.contextPath}/about#vi-sao">Câu chuyện PureNut</a>
      <a href="${pageContext.request.contextPath}/about#bao-bi">Bao bì bền vững</a>
    </div>
    <div class="footer-col">
      <h4>Hỗ trợ</h4>
      <a href="#">Chính sách giao hàng</a>
      <a href="#">Đổi trả & Hoàn tiền</a>
      <a href="#">FAQ</a>
    </div>
    <div class="footer-col">
      <h4>Liên hệ</h4>
      <p>Hotline: 1900 8888</p>
      <p>Email: hello@purenut.vn</p>
      <p>Địa chỉ: 123 Đường Sữa Hạt, Q.1, TP.HCM</p>
    </div>
  </div>
  <div class="footer-bottom">
    <p>&copy; 2026 PureNut Vietnam. All rights reserved.</p>
  </div>
</footer>

<a href="https://zalo.me" class="zalo-float" target="_blank" rel="noopener" aria-label="Chat Zalo">
  <svg width="26" height="26" viewBox="0 0 24 24" fill="none" aria-hidden="true">
    <path d="M12 2C6.48 2 2 6.02 2 11c0 2.9 1.6 5.47 4.1 7.13L5.5 22l4.3-2.16c.7.12 1.43.18 2.2.18 5.52 0 10-4.02 10-9S17.52 2 12 2z" fill="#fff"/>
  </svg>
</a>

<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>

<c:if test="${not empty param.success}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const Toast = Swal.mixin({
              toast: true,
              position: 'bottom-end',
              showConfirmButton: false,
              timer: 3000,
              timerProgressBar: true,
              didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer)
                toast.addEventListener('mouseleave', Swal.resumeTimer)
              }
            });
            
            let msg = "Thao tác thành công!";
            let type = "success";
            
            <c:if test="${param.success == 'added'}">
                msg = "Đã thêm vào giỏ hàng!";
            </c:if>
            <c:if test="${param.success == 'login'}">
                msg = "Đăng nhập thành công!";
            </c:if>
            <c:if test="${param.success == 'register'}">
                msg = "Đăng ký thành công!";
            </c:if>

            Toast.fire({
              icon: type,
              title: msg
            });
        });
    </script>
</c:if>
