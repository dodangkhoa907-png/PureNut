<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
    .kpi-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:22px;margin-bottom:24px}
    .kpi{background:var(--admin-surface);padding:22px;border-radius:18px;box-shadow:0 8px 22px -16px rgba(43,54,116,.25);position:relative;overflow:hidden;transition:transform .25s,box-shadow .25s}
    .kpi:hover{transform:translateY(-4px);box-shadow:0 18px 34px -18px rgba(43,54,116,.4)}
    .kpi .top{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
    .kpi .ic{width:52px;height:52px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:22px}
    .kpi .trend{font-size:12.5px;font-weight:700;padding:4px 9px;border-radius:20px}
    .trend.up{background:rgba(18,183,106,.12);color:var(--status-done)}
    .trend.down{background:rgba(238,93,80,.12);color:var(--status-cancelled)}
    .trend.flat{background:var(--admin-bg);color:var(--admin-text-light)}
    .kpi p{color:var(--admin-text-light);font-size:13.5px;font-weight:600;margin-bottom:5px}
    .kpi h3{font-family:var(--fd);font-size:26px;font-weight:700;line-height:1.1}
    .kpi h3 small{font-size:14px;color:var(--admin-text-light);font-weight:600}
    .ic-blue{background:rgba(57,101,255,.12);color:#3965FF}
    .ic-green{background:rgba(18,183,106,.12);color:#12B76A}
    .ic-orange{background:rgba(245,165,36,.12);color:#F5A524}
    .ic-purple{background:rgba(122,90,248,.12);color:#7A5AF8}
    .ic-red{background:rgba(238,93,80,.12);color:#EE5D50}

    .grid-2{display:grid;grid-template-columns:1.6fr 1fr;gap:24px;margin-bottom:24px}
    .card-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
    .card-title{font-family:var(--fd);font-size:19px;font-weight:700}
    .card-title small{display:block;font-family:var(--fb);font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-top:2px}
    .view-all{color:var(--admin-primary);font-weight:700;font-size:13.5px}

    /* Chart cột 7 ngày */
    .chart{display:flex;align-items:flex-end;gap:14px;height:210px;padding-top:10px}
    .chart .col{flex:1;display:flex;flex-direction:column;align-items:center;gap:9px;height:100%;justify-content:flex-end}
    .chart .bar{width:100%;max-width:42px;border-radius:10px 10px 4px 4px;background:linear-gradient(180deg,#4C82D6,#1B4F9E);position:relative;transition:height 1s cubic-bezier(.2,.8,.25,1);min-height:4px}
    .chart .bar:hover{filter:brightness(1.08)}
    .chart .bar .tip{position:absolute;top:-30px;left:50%;transform:translateX(-50%);background:var(--admin-sidebar);color:#fff;font-size:11px;font-weight:700;padding:4px 8px;border-radius:7px;white-space:nowrap;opacity:0;transition:opacity .2s;pointer-events:none}
    .chart .col:hover .tip{opacity:1}
    .chart .lb{font-size:12px;color:var(--admin-text-light);font-weight:600}

    /* Cảnh báo & phân bổ */
    .alert-item{display:flex;gap:13px;align-items:flex-start;padding:13px;border-radius:12px;margin-bottom:10px;background:var(--admin-bg)}
    .alert-item .a-ic{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:15px;flex:none}
    .alert-item h4{font-size:14px;font-weight:700;margin-bottom:2px}
    .alert-item p{font-size:12.5px;color:var(--admin-text-light);line-height:1.45}
    .dist{margin-top:6px}
    .dist-row{margin-bottom:14px}
    .dist-row .lbl{display:flex;justify-content:space-between;font-size:13px;font-weight:600;margin-bottom:6px}
    .dist-row .track{height:9px;border-radius:9px;background:var(--admin-bg);overflow:hidden}
    .dist-row .fill{height:100%;border-radius:9px;transition:width 1s cubic-bezier(.2,.8,.25,1)}

    .qa{display:flex;flex-direction:column;gap:12px}
    @media(max-width:1100px){.kpi-grid{grid-template-columns:repeat(2,1fr)}.grid-2{grid-template-columns:1fr}}
    @media(max-width:560px){.kpi-grid{grid-template-columns:1fr}}
</style>

<!-- ===== KPI ===== -->
<div class="kpi-grid">
    <div class="kpi">
        <div class="top"><div class="ic ic-green"><i class="fa-solid fa-sack-dollar"></i></div>
            <span class="trend ${todayRevenue > 0 ? 'up' : 'flat'}"><i class="fa-solid fa-arrow-trend-up"></i> Hôm nay</span></div>
        <p>Tổng doanh thu</p>
        <h3><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/><small> đ</small></h3>
    </div>
    <div class="kpi">
        <div class="top"><div class="ic ic-blue"><i class="fa-solid fa-cart-shopping"></i></div>
            <span class="trend flat">${todayOrders} hôm nay</span></div>
        <p>Tổng đơn hàng</p>
        <h3>${totalOrders}</h3>
    </div>
    <div class="kpi">
        <div class="top"><div class="ic ic-purple"><i class="fa-solid fa-receipt"></i></div>
            <span class="trend flat">AOV</span></div>
        <p>Giá trị TB / đơn</p>
        <h3><fmt:formatNumber value="${aov}" type="number" maxFractionDigits="0"/><small> đ</small></h3>
    </div>
    <div class="kpi">
        <div class="top"><div class="ic ic-orange"><i class="fa-solid fa-box-open"></i></div>
            <span class="trend flat">Đang bán</span></div>
        <p>Sản phẩm</p>
        <h3>${totalProducts}</h3>
    </div>
</div>

<!-- ===== KPI phụ ===== -->
<div class="kpi-grid">
    <div class="kpi">
        <div class="top"><div class="ic ic-orange"><i class="fa-solid fa-hourglass-half"></i></div></div>
        <p>Chờ xử lý</p><h3>${pendingOrders}</h3>
    </div>
    <div class="kpi">
        <div class="top"><div class="ic ic-purple"><i class="fa-solid fa-truck-fast"></i></div></div>
        <p>Đang giao</p><h3>${shippingOrders}</h3>
    </div>
    <div class="kpi">
        <div class="top"><div class="ic ic-green"><i class="fa-solid fa-circle-check"></i></div>
            <span class="trend up">${successRate}%</span></div>
        <p>Hoàn thành</p><h3>${doneOrders}</h3>
    </div>
    <div class="kpi">
        <div class="top"><div class="ic ic-red"><i class="fa-solid fa-circle-xmark"></i></div>
            <span class="trend down">${cancelRate}%</span></div>
        <p>Đã huỷ</p><h3>${cancelledOrders}</h3>
    </div>
</div>

<!-- ===== Chart + Cảnh báo ===== -->
<div class="grid-2">
    <div class="card">
        <div class="card-header">
            <div class="card-title">Doanh thu 7 ngày qua<small>Chỉ tính đơn đã hoàn thành</small></div>
            <a href="${ctx}/admin/don-hang" class="view-all">Chi tiết →</a>
        </div>
        <div class="chart" id="revChart"></div>
    </div>

    <div class="card">
        <div class="card-header"><div class="card-title">Cảnh báo</div></div>
        <div class="alert-item">
            <div class="a-ic ic-orange"><i class="fa-solid fa-hourglass-half"></i></div>
            <div><h4>${pendingOrders} đơn chờ xử lý</h4><p>Có đơn hàng mới đang chờ xác nhận và chuẩn bị.</p></div>
        </div>
        <div class="alert-item">
            <div class="a-ic ic-purple"><i class="fa-solid fa-truck-fast"></i></div>
            <div><h4>${shippingOrders} đơn đang giao</h4><p>Theo dõi tiến độ giao vận để cập nhật khách hàng.</p></div>
        </div>
        <div class="alert-item">
            <div class="a-ic ic-red"><i class="fa-solid fa-triangle-exclamation"></i></div>
            <div><h4>Tỷ lệ huỷ ${cancelRate}%</h4><p>Rà soát nguyên nhân huỷ đơn để cải thiện trải nghiệm.</p></div>
        </div>
    </div>
</div>

<!-- ===== Đơn gần đây + phân bổ + quick action ===== -->
<div class="grid-2">
    <div class="card">
        <div class="card-header">
            <div class="card-title">Đơn hàng gần đây</div>
            <a href="${ctx}/admin/don-hang" class="view-all">Xem tất cả →</a>
        </div>
        <div class="table-responsive">
            <table class="admin-table">
                <thead><tr><th>Mã ĐH</th><th>Khách hàng</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày đặt</th></tr></thead>
                <tbody>
                    <c:forEach var="order" items="${recentOrders}">
                        <tr>
                            <td><strong>#${order.orderId}</strong></td>
                            <td><strong>${order.fullName}</strong><br><span style="font-size:12.5px;color:var(--admin-text-light)">${order.phone}</span></td>
                            <td><strong style="color:var(--admin-primary)"><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</strong></td>
                            <td><span class="badge badge-${order.status}">${order.status}</span></td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentOrders}"><tr><td colspan="5" style="text-align:center;padding:30px;color:var(--admin-text-light)">Chưa có đơn hàng nào</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div>
        <div class="card">
            <div class="card-header"><div class="card-title">Phân bổ trạng thái</div></div>
            <div class="dist">
                <div class="dist-row"><div class="lbl"><span>Hoàn thành</span><span>${doneOrders}</span></div><div class="track"><div class="fill" data-total="${totalOrders}" data-val="${doneOrders}" style="background:#12B76A;width:0"></div></div></div>
                <div class="dist-row"><div class="lbl"><span>Chờ xử lý</span><span>${pendingOrders}</span></div><div class="track"><div class="fill" data-total="${totalOrders}" data-val="${pendingOrders}" style="background:#F5A524;width:0"></div></div></div>
                <div class="dist-row"><div class="lbl"><span>Đang giao</span><span>${shippingOrders}</span></div><div class="track"><div class="fill" data-total="${totalOrders}" data-val="${shippingOrders}" style="background:#7A5AF8;width:0"></div></div></div>
                <div class="dist-row"><div class="lbl"><span>Đã huỷ</span><span>${cancelledOrders}</span></div><div class="track"><div class="fill" data-total="${totalOrders}" data-val="${cancelledOrders}" style="background:#EE5D50;width:0"></div></div></div>
            </div>
        </div>
        <div class="card">
            <div class="card-header"><div class="card-title">Hành động nhanh</div></div>
            <div class="qa">
                <a href="${ctx}/admin/san-pham/them" class="btn btn-primary" style="justify-content:center"><i class="fa-solid fa-plus"></i> Thêm sản phẩm mới</a>
                <a href="${ctx}/admin/don-hang" class="btn btn-outline" style="justify-content:center"><i class="fa-solid fa-truck-fast"></i> Xử lý đơn hàng</a>
                <a href="${ctx}/admin/dai-ly" class="btn btn-outline" style="justify-content:center"><i class="fa-solid fa-handshake"></i> Xem đăng ký đại lý</a>
            </div>
        </div>
    </div>
</div>

<script>
(function(){
    // Chart cột
    var vals = "${chartValues}".split(",").map(function(x){return parseInt(x,10)||0;});
    var labels = [<c:forEach var="l" items="${chartLabels}" varStatus="s">"${l}"<c:if test="${!s.last}">,</c:if></c:forEach>];
    var max = ${chartMax} || 1;
    var host = document.getElementById('revChart');
    if(host){
        vals.forEach(function(v,i){
            var col=document.createElement('div');col.className='col';
            var h=Math.max(4, Math.round(v/max*170));
            var money = v.toLocaleString('vi-VN')+' đ';
            col.innerHTML='<div class="bar" style="height:0"><span class="tip">'+money+'</span></div><span class="lb">'+labels[i]+'</span>';
            host.appendChild(col);
            var bar=col.querySelector('.bar');
            setTimeout(function(){bar.style.height=h+'px';}, 60+i*70);
        });
    }
    // Thanh phân bổ
    setTimeout(function(){
        document.querySelectorAll('.dist .fill').forEach(function(f){
            var t=parseInt(f.dataset.total,10)||0, v=parseInt(f.dataset.val,10)||0;
            f.style.width=(t>0?Math.round(v/t*100):0)+'%';
        });
    },150);
})();
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
