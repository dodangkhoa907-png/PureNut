<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="ctx" content="${ctx}">
<title>Điều khoản sử dụng — PureNut</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/resources/css/style.css">
<style>
:root{--navy:#1B4F9E;--navy-dark:#11335E;--red:#CE2E2E;--cream:#FBF6EC;--paper:#FFFDF8;--ink:#241F18;--ink-soft:#6B6357;--line:rgba(36,31,24,.1);--fd:'Fraunces',serif;--fb:'Inter',sans-serif}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:var(--fb);background:var(--cream);color:var(--ink);line-height:1.7;-webkit-font-smoothing:antialiased}

.legal-hero{background:linear-gradient(135deg,#0B2547 0%,#1B4F9E 100%);padding:100px 26px 60px;text-align:center;color:#fff;position:relative;overflow:hidden}
.legal-hero::before{content:'';position:absolute;bottom:-60px;left:-40px;width:260px;height:260px;background:radial-gradient(circle,rgba(255,255,255,.06) 0%,transparent 70%);border-radius:50%}
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
.legal-nav .btn-privacy{background:var(--navy);color:#fff}
.legal-nav .btn-privacy:hover{transform:translateY(-2px)}
.legal-nav .btn-back{border:2px solid var(--line);color:var(--ink)}
.legal-nav .btn-back:hover{background:rgba(27,79,158,.05)}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/navbar.jsp" />

<div class="legal-hero">
  <h1>Điều khoản sử dụng</h1>
  <p>Quy định sử dụng website và dịch vụ của PureNut</p>
</div>

<div class="legal-wrap">
  <div class="legal-card">
    <h2>1. Giới thiệu</h2>
    <p>Chào mừng bạn đến với <strong>PureNut</strong> — nền tảng thương mại điện tử chuyên cung cấp sữa hạt tự nhiên, tốt cho sức khỏe. Bằng việc truy cập và sử dụng website, bạn đồng ý tuân thủ các điều khoản dưới đây.</p>
    <div class="highlight">Vui lòng đọc kỹ trước khi sử dụng. Nếu không đồng ý với bất kỳ điều khoản nào, bạn nên ngừng sử dụng dịch vụ.</div>

    <h2>2. Tài khoản người dùng</h2>
    <ul>
      <li>Bạn phải cung cấp thông tin <strong>chính xác và trung thực</strong> khi đăng ký tài khoản.</li>
      <li>Mỗi người chỉ được sở hữu <strong>một tài khoản</strong>. Tài khoản trùng lặp có thể bị vô hiệu hóa.</li>
      <li>Bạn chịu trách nhiệm bảo mật mật khẩu và mọi hoạt động diễn ra trên tài khoản của mình.</li>
      <li>Thông báo ngay cho chúng tôi nếu phát hiện truy cập trái phép vào tài khoản.</li>
    </ul>

    <h2>3. Đặt hàng & Thanh toán</h2>
    <ul>
      <li>Giá sản phẩm hiển thị trên website đã bao gồm <strong>thuế VAT</strong> (nếu có).</li>
      <li>Đơn hàng chỉ được xác nhận khi chúng tôi gửi <strong>email/SMS xác nhận</strong>.</li>
      <li>PureNut có quyền từ chối hoặc hủy đơn hàng trong các trường hợp: sản phẩm hết hàng, lỗi giá, nghi ngờ gian lận.</li>
      <li>Phương thức thanh toán: <strong>COD (tiền mặt)</strong> và <strong>PayOS (chuyển khoản QR)</strong>.</li>
      <li>Với thanh toán PayOS, đơn hàng sẽ tự động hủy nếu chưa thanh toán sau <strong>15 phút</strong>.</li>
    </ul>

    <h2>4. Giao hàng</h2>
    <ul>
      <li>Thời gian giao hàng dự kiến: <strong>2–5 ngày làm việc</strong> tùy khu vực.</li>
      <li>Phí vận chuyển được tính dựa trên địa chỉ giao hàng và hiển thị trước khi thanh toán.</li>
      <li>Bạn có trách nhiệm cung cấp địa chỉ giao hàng chính xác. PureNut không chịu trách nhiệm nếu giao sai do thông tin sai.</li>
      <li>Khi nhận hàng, vui lòng kiểm tra tình trạng sản phẩm trước khi ký nhận.</li>
    </ul>

    <h2>5. Hủy đơn & Hoàn tiền</h2>
    <ul>
      <li>Bạn có thể <strong>yêu cầu hủy đơn</strong> khi đơn hàng ở trạng thái <em>Chờ xác nhận</em> hoặc <em>Đã xác nhận</em>.</li>
      <li>Đơn hàng đang giao (<em>Đang vận chuyển</em>) <strong>không thể hủy</strong>.</li>
      <li>Yêu cầu hủy cần được <strong>quản trị viên duyệt</strong>. Kết quả sẽ được thông báo qua trang đơn hàng.</li>
      <li>Hoàn tiền (nếu đã thanh toán trực tuyến) sẽ được xử lý trong <strong>3–7 ngày làm việc</strong>.</li>
    </ul>

    <h2>6. Quyền sở hữu trí tuệ</h2>
    <ul>
      <li>Tất cả nội dung trên website (văn bản, hình ảnh, logo, giao diện) thuộc quyền sở hữu của PureNut.</li>
      <li>Bạn không được sao chép, phân phối, hoặc sử dụng nội dung cho mục đích thương mại mà không có sự đồng ý bằng văn bản.</li>
    </ul>

    <h2>7. Hành vi bị cấm</h2>
    <p>Khi sử dụng PureNut, bạn <strong>không được</strong>:</p>
    <ul>
      <li>Sử dụng robot, spider, hoặc công cụ tự động để thu thập dữ liệu từ website.</li>
      <li>Gửi phản hồi spam, nội dung xúc phạm, hoặc quấy rối người dùng khác.</li>
      <li>Cố tình khai thác lỗ hổng bảo mật hoặc phá hoại hệ thống.</li>
      <li>Mạo danh người khác hoặc cung cấp thông tin giả mạo.</li>
      <li>Sử dụng dịch vụ cho mục đích bất hợp pháp.</li>
    </ul>

    <h2>8. Giới hạn trách nhiệm</h2>
    <ul>
      <li>PureNut nỗ lực đảm bảo thông tin sản phẩm chính xác, nhưng không đảm bảo tuyệt đối về hình ảnh, mô tả, hoặc tính khả dụng.</li>
      <li>Chúng tôi không chịu trách nhiệm cho thiệt hại gián tiếp phát sinh từ việc sử dụng website.</li>
      <li>Trong mọi trường hợp, trách nhiệm tối đa của PureNut giới hạn ở giá trị đơn hàng liên quan.</li>
    </ul>

    <h2>9. Thay đổi điều khoản</h2>
    <p>PureNut có quyền cập nhật điều khoản này bất kỳ lúc nào. Thay đổi có hiệu lực ngay khi được đăng trên website. Việc tiếp tục sử dụng dịch vụ sau khi thay đổi đồng nghĩa với việc bạn chấp nhận điều khoản mới.</p>

    <h2>10. Luật áp dụng & Giải quyết tranh chấp</h2>
    <ul>
      <li>Điều khoản này được điều chỉnh bởi <strong>pháp luật Việt Nam</strong>.</li>
      <li>Tranh chấp sẽ được giải quyết thông qua <strong>thương lượng</strong>. Nếu không thành, tranh chấp sẽ được đưa ra <strong>Tòa án nhân dân có thẩm quyền tại TP. Hồ Chí Minh</strong>.</li>
    </ul>

    <h2>11. Liên hệ</h2>
    <p>Nếu bạn có thắc mắc về điều khoản sử dụng, vui lòng liên hệ:</p>
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
    <a href="${ctx}/privacy" class="btn-privacy">Chính sách bảo mật &rarr;</a>
    <a href="${ctx}/" class="btn-back">&larr; Về trang chủ</a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>
