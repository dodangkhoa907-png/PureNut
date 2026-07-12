<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="ctx" content="${ctx}">
<title>Chính sách bảo mật — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/resources/css/style.css">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--red:#CE2E2E;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.7;-webkit-font-smoothing:antialiased}

.legal-hero{background:linear-gradient(135deg,#1B4F9E 0%,#0B2547 100%);padding:100px 26px 60px;text-align:center;color:#fff;position:relative;overflow:hidden}
.legal-hero::before{content:'';position:absolute;top:-80px;right:-60px;width:300px;height:300px;background:radial-gradient(circle,rgba(255,255,255,.06) 0%,transparent 70%);border-radius:50%}
.legal-hero h1{font-family:var(--fd);font-size:clamp(28px,5vw,42px);font-weight:700;margin-bottom:10px;letter-spacing:-.02em}
.legal-hero p{font-size:15px;opacity:.7;max-width:500px;margin:0 auto}

.legal-wrap{max-width:800px;margin:-40px auto 0;padding:0 26px 80px;position:relative;z-index:2}
.legal-card{background:var(--paper);border-radius:20px;padding:clamp(30px,5vw,56px);box-shadow:0 20px 60px -20px rgba(20,30,20,.12)}

.legal-card h2{font-family:var(--fd);font-size:20px;font-weight:600;color:var(--navy);margin:36px 0 14px;padding-bottom:10px;border-bottom:2px solid rgba(27,79,158,.1)}
.legal-card h2:first-child{margin-top:0}
.legal-card p{margin-bottom:14px;color:var(--ink);font-size:15px}
.legal-card ul{margin:0 0 14px 20px;list-style:none}
.legal-card ul li{position:relative;padding-left:22px;margin-bottom:8px;font-size:15px;color:var(--ink)}
.legal-card ul li::before{content:'';position:absolute;left:0;top:8px;width:8px;height:8px;border-radius:2px;background:var(--navy);opacity:.3}
.legal-card strong{color:var(--navy-dark);font-weight:700}
.legal-card .highlight{background:rgba(27,79,158,.05);border-left:4px solid var(--navy);padding:16px 20px;border-radius:0 12px 12px 0;margin:18px 0;font-size:14px}

.legal-meta{display:flex;gap:20px;flex-wrap:wrap;margin-top:36px;padding-top:24px;border-top:2px solid var(--line)}
.legal-meta-item{font-size:13px;color:var(--ink-soft)}
.legal-meta-item strong{color:var(--ink);font-weight:600}

.legal-nav{display:flex;gap:12px;justify-content:center;margin-top:30px}
.legal-nav a{display:inline-flex;align-items:center;gap:8px;padding:12px 24px;border-radius:99px;font-weight:600;font-size:14px;text-decoration:none;transition:transform .2s,background .2s}
.legal-nav .btn-terms{background:var(--navy);color:#fff}
.legal-nav .btn-terms:hover{transform:translateY(-2px)}
.legal-nav .btn-back{border:2px solid var(--line);color:var(--ink)}
.legal-nav .btn-back:hover{background:rgba(27,79,158,.05)}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<div class="legal-hero">
  <h1>Chính sách bảo mật</h1>
  <p>Cách PureNut thu thập, sử dụng và bảo vệ thông tin cá nhân của bạn</p>
</div>

<div class="legal-wrap">
  <div class="legal-card">
    <h2>1. Thông tin chúng tôi thu thập</h2>
    <p>Khi bạn sử dụng dịch vụ PureNut, chúng tôi có thể thu thập các loại thông tin sau:</p>
    <ul>
      <li><strong>Thông tin tài khoản:</strong> Họ tên, email, số điện thoại khi đăng ký tài khoản.</li>
      <li><strong>Thông tin đơn hàng:</strong> Địa chỉ giao hàng, lịch sử mua hàng, phương thức thanh toán.</li>
      <li><strong>Thông tin kỹ thuật:</strong> Địa chỉ IP, thời gian đăng nhập — phục vụ bảo mật tài khoản.</li>
      <li><strong>Phản hồi & hỗ trợ:</strong> Tên, số điện thoại/email, nội dung phản hồi, địa chỉ IP khi gửi form hỗ trợ.</li>
      <li><strong>Vị trí:</strong> Tọa độ GPS (chỉ khi bạn cho phép trình duyệt) để tự động điền địa chỉ giao hàng.</li>
    </ul>

    <h2>2. Mục đích sử dụng</h2>
    <p>Chúng tôi sử dụng thông tin của bạn cho các mục đích sau:</p>
    <ul>
      <li>Xử lý và giao hàng đơn đặt hàng.</li>
      <li>Bảo vệ tài khoản: phát hiện đăng nhập bất thường qua IP.</li>
      <li>Chống spam và lạm dụng: giới hạn tần suất gửi phản hồi theo IP.</li>
      <li>Cải thiện trải nghiệm mua sắm và chất lượng dịch vụ.</li>
      <li>Gửi thông báo về đơn hàng, khuyến mãi (nếu bạn đồng ý nhận).</li>
      <li>Tuân thủ yêu cầu pháp luật và giải quyết tranh chấp.</li>
    </ul>

    <h2>3. Cơ sở pháp lý thu thập dữ liệu</h2>
    <p>Việc thu thập và xử lý dữ liệu cá nhân tuân thủ <strong>Nghị định 13/2023/NĐ-CP</strong> về bảo vệ dữ liệu cá nhân, dựa trên:</p>
    <ul>
      <li><strong>Sự đồng ý:</strong> Bạn đồng ý khi đăng ký tài khoản (tick checkbox Điều khoản & Chính sách).</li>
      <li><strong>Thực hiện hợp đồng:</strong> Xử lý đơn hàng theo yêu cầu của bạn.</li>
      <li><strong>Lợi ích hợp pháp:</strong> Bảo mật hệ thống, chống gian lận.</li>
    </ul>

    <h2>4. Bảo mật dữ liệu</h2>
    <div class="highlight">Mật khẩu được mã hóa bằng BCrypt — không ai có thể đọc được, kể cả quản trị viên hệ thống.</div>
    <ul>
      <li>Dữ liệu truyền qua kênh mã hóa HTTPS khi deploy production.</li>
      <li>Chỉ nhân viên được ủy quyền mới truy cập dữ liệu khách hàng.</li>
      <li>Hệ thống ghi nhật ký (Audit Log) mọi thao tác quản trị để truy vết.</li>
      <li>Session cookie được thiết lập HttpOnly, chống đánh cắp qua JavaScript.</li>
    </ul>

    <h2>5. Chia sẻ thông tin</h2>
    <p>Chúng tôi <strong>không bán</strong> hoặc cho thuê thông tin cá nhân của bạn. Thông tin chỉ được chia sẻ trong các trường hợp:</p>
    <ul>
      <li><strong>Đơn vị vận chuyển:</strong> Tên, số điện thoại, địa chỉ giao hàng để hoàn tất giao hàng.</li>
      <li><strong>Cổng thanh toán:</strong> Thông tin giao dịch khi bạn chọn thanh toán trực tuyến (PayOS).</li>
      <li><strong>Yêu cầu pháp luật:</strong> Khi có yêu cầu hợp pháp từ cơ quan chức năng.</li>
    </ul>

    <h2>6. Thời gian lưu trữ</h2>
    <ul>
      <li><strong>Tài khoản:</strong> Lưu trữ cho đến khi bạn yêu cầu xóa.</li>
      <li><strong>Đơn hàng:</strong> Lưu trữ tối thiểu 5 năm theo quy định kế toán.</li>
      <li><strong>Nhật ký đăng nhập (IP):</strong> Chỉ giữ lần đăng nhập gần nhất.</li>
      <li><strong>Phản hồi hỗ trợ:</strong> Lưu trữ 2 năm kể từ ngày gửi.</li>
    </ul>

    <h2>7. Quyền của bạn</h2>
    <p>Theo Nghị định 13/2023/NĐ-CP, bạn có các quyền sau:</p>
    <ul>
      <li><strong>Quyền truy cập:</strong> Xem thông tin cá nhân trong trang Tài khoản.</li>
      <li><strong>Quyền chỉnh sửa:</strong> Cập nhật họ tên, số điện thoại, địa chỉ bất kỳ lúc nào.</li>
      <li><strong>Quyền xóa:</strong> Yêu cầu xóa tài khoản bằng cách liên hệ chúng tôi.</li>
      <li><strong>Quyền rút lại đồng ý:</strong> Bạn có thể rút lại đồng ý xử lý dữ liệu bất kỳ lúc nào.</li>
      <li><strong>Quyền khiếu nại:</strong> Liên hệ chúng tôi hoặc gửi khiếu nại tới cơ quan bảo vệ dữ liệu cá nhân.</li>
    </ul>

    <h2>8. Cookie và công nghệ theo dõi</h2>
    <p>Website sử dụng cookie phiên (Session Cookie) để duy trì đăng nhập. Cookie này:</p>
    <ul>
      <li>Là cookie <strong>kỹ thuật bắt buộc</strong>, chỉ phục vụ đăng nhập — không theo dõi hành vi.</li>
      <li>Tự động xóa sau khi bạn đóng trình duyệt hoặc sau 2 giờ không hoạt động.</li>
      <li>Được thiết lập HttpOnly — không thể truy cập bằng JavaScript.</li>
    </ul>
    <p>Chúng tôi <strong>không sử dụng</strong> cookie quảng cáo hoặc cookie theo dõi bên thứ ba.</p>

    <h2>9. Liên hệ</h2>
    <p>Nếu bạn có bất kỳ câu hỏi nào về chính sách bảo mật, vui lòng liên hệ:</p>
    <ul>
      <li><strong>Email:</strong> hello@purenut.vn</li>
      <li><strong>Hotline:</strong> 1900 8888</li>
      <li><strong>Địa chỉ:</strong> 123 Đường Sữa Hạt, Quận 1, TP. Hồ Chí Minh</li>
    </ul>

    <div class="legal-meta">
      <div class="legal-meta-item"><strong>Phiên bản:</strong> 1.0</div>
      <div class="legal-meta-item"><strong>Ngày hiệu lực:</strong> 01/07/2026</div>
      <div class="legal-meta-item"><strong>Cập nhật lần cuối:</strong> 12/07/2026</div>
    </div>
  </div>

  <div class="legal-nav">
    <a href="${ctx}/terms" class="btn-terms">Điều khoản sử dụng &rarr;</a>
    <a href="${ctx}/" class="btn-back">&larr; Về trang chủ</a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
