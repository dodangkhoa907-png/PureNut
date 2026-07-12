<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
/* ═══════════ Stats Row ═══════════ */
.pl-stats{display:flex;gap:16px;margin-bottom:26px;flex-wrap:wrap}
.pl-stat{
    flex:1;min-width:160px;padding:20px 22px;border-radius:18px;
    background:var(--admin-surface);border:1.5px solid var(--admin-border);
    transition:transform .3s,box-shadow .3s,border-color .25s;cursor:default;position:relative;overflow:hidden;
}
.pl-stat::before{content:'';position:absolute;top:-30px;right:-30px;width:80px;height:80px;border-radius:50%;opacity:.06;pointer-events:none}
.pl-stat:hover{transform:translateY(-4px);box-shadow:0 16px 36px -14px rgba(14,46,92,.14)}
.pl-stat-icon{width:42px;height:42px;border-radius:13px;display:flex;align-items:center;justify-content:center;font-size:18px;color:#fff;margin-bottom:12px}
.pl-stat-val{font-family:var(--fd);font-size:28px;font-weight:800;line-height:1}
.pl-stat-label{font-size:12px;font-weight:600;color:var(--admin-text-light);text-transform:uppercase;letter-spacing:.4px;margin-top:4px}

/* ═══════════ Search & Filter Bar ═══════════ */
.pl-toolbar{display:flex;gap:14px;align-items:center;margin-bottom:22px;flex-wrap:wrap}
.pl-search{
    flex:1;min-width:220px;position:relative;
}
.pl-search input{
    width:100%;padding:13px 16px 13px 44px;border:1.5px solid var(--admin-border);border-radius:14px;
    font-size:14.5px;color:var(--admin-text);background:var(--admin-surface);
    transition:border-color .25s,box-shadow .25s;font-family:var(--fb);
}
.pl-search input:focus{border-color:var(--admin-primary);outline:none;box-shadow:0 0 0 4px rgba(27,79,158,.08)}
.pl-search input::placeholder{color:var(--admin-text-light)}
.pl-search i{position:absolute;left:16px;top:50%;transform:translateY(-50%);color:var(--admin-text-light);font-size:15px}
.pl-filter-chips{display:flex;gap:8px;flex-wrap:wrap}
.pl-chip{
    padding:9px 16px;border-radius:10px;font-size:13px;font-weight:700;cursor:pointer;
    background:var(--admin-surface);border:1.5px solid var(--admin-border);color:var(--admin-text-light);
    transition:all .25s;user-select:none;
}
.pl-chip:hover{border-color:rgba(57,101,255,.3);color:var(--admin-primary)}
.pl-chip.active{background:var(--admin-primary);color:#fff;border-color:var(--admin-primary);box-shadow:0 6px 18px -8px rgba(27,79,158,.4)}

/* ═══════════ Product Grid ═══════════ */
.pl-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:20px}

.pl-product{
    background:var(--admin-surface);border:1.5px solid var(--admin-border);border-radius:20px;
    overflow:hidden;transition:transform .35s cubic-bezier(.4,0,.2,1),box-shadow .35s,border-color .3s;
    position:relative;
}
.pl-product:hover{
    transform:translateY(-6px);
    box-shadow:0 22px 50px -18px rgba(14,46,92,.16);
    border-color:rgba(57,101,255,.2);
}

/* Image area */
.pl-img{
    height:180px;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;
    transition:background .3s;
}
.pl-img img{height:130px;object-fit:contain;transition:transform .5s cubic-bezier(.4,0,.2,1);filter:drop-shadow(0 8px 20px rgba(0,0,0,.12))}
.pl-product:hover .pl-img img{transform:scale(1.08) translateY(-4px) rotate(2deg)}
.pl-img-badge{
    position:absolute;top:14px;left:14px;
    padding:5px 11px;border-radius:8px;font-size:11px;font-weight:800;letter-spacing:.03em;
    backdrop-filter:blur(8px);
}
.pl-img-featured{background:rgba(255,181,71,.2);color:#B45309}
.pl-img-lowstock{background:rgba(238,93,80,.15);color:#CE2E2E}

/* Star button overlay */
.pl-star{
    position:absolute;top:14px;right:14px;width:36px;height:36px;border-radius:10px;
    background:rgba(255,255,255,.85);backdrop-filter:blur(6px);border:none;cursor:pointer;
    display:flex;align-items:center;justify-content:center;font-size:17px;
    transition:transform .25s,box-shadow .2s;box-shadow:0 4px 12px -4px rgba(0,0,0,.1);
}
.pl-star:hover{transform:scale(1.12);box-shadow:0 6px 16px -4px rgba(0,0,0,.15)}
.pl-star.on{color:#FFB547}
.pl-star.off{color:#D5DAE8}

/* Content area */
.pl-body{padding:18px 20px 20px}
.pl-cat{font-size:11.5px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--admin-primary);opacity:.7;margin-bottom:6px}
.pl-name{font-size:16px;font-weight:800;color:var(--admin-text);margin-bottom:4px;line-height:1.3}
.pl-specs{font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-bottom:14px}

.pl-bottom{display:flex;align-items:center;justify-content:space-between;padding-top:14px;border-top:1px solid rgba(224,229,242,.6)}
.pl-price{font-family:var(--fd);font-size:20px;font-weight:800;color:var(--admin-primary)}
.pl-stock{display:flex;align-items:center;gap:6px;font-size:12.5px;font-weight:700}
.pl-stock-dot{width:8px;height:8px;border-radius:50%}
.pl-stock-ok .pl-stock-dot{background:#12B76A}
.pl-stock-ok{color:#0E8A51}
.pl-stock-low .pl-stock-dot{background:#F04438;animation:plPulse 1.5s infinite}
.pl-stock-low{color:#CE2E2E}
@keyframes plPulse{0%,100%{opacity:1}50%{opacity:.3}}

/* Action buttons */
.pl-actions{display:flex;gap:8px;padding:0 20px 18px}
.pl-act{
    flex:1;padding:10px;border-radius:12px;border:none;cursor:pointer;
    font-size:13px;font-weight:700;display:flex;align-items:center;justify-content:center;gap:6px;
    transition:background .2s,transform .2s,box-shadow .2s;
}
.pl-act:hover{transform:translateY(-2px)}
.pl-act-edit{background:rgba(57,101,255,.08);color:var(--admin-primary)}
.pl-act-edit:hover{background:rgba(57,101,255,.15);box-shadow:0 6px 16px -6px rgba(57,101,255,.25)}
.pl-act-del{background:rgba(238,93,80,.06);color:#CE2E2E}
.pl-act-del:hover{background:rgba(238,93,80,.14);box-shadow:0 6px 16px -6px rgba(238,93,80,.25)}

/* ═══════════ Toast ═══════════ */
.pl-toast{
    position:fixed;top:24px;right:24px;z-index:9999;
    padding:16px 22px;border-radius:14px;
    background:#0E8A51;color:#fff;font-weight:700;font-size:14px;
    box-shadow:0 14px 32px -10px rgba(14,138,81,.4);
    display:flex;align-items:center;gap:10px;
    animation:plToastIn .4s ease,plToastOut .4s ease 2.6s forwards;
}
@keyframes plToastIn{from{opacity:0;transform:translateY(-16px)}to{opacity:1;transform:none}}
@keyframes plToastOut{to{opacity:0;transform:translateY(-16px)}}

/* ═══════════ Empty State ═══════════ */
.pl-empty{text-align:center;padding:60px 20px;color:var(--admin-text-light)}
.pl-empty i{font-size:48px;opacity:.3;margin-bottom:16px;display:block}
.pl-empty p{font-size:15px;font-weight:600}

/* ═══════════ Delete Confirm Overlay ═══════════ */
.pl-confirm{
    display:none;position:fixed;inset:0;z-index:9000;
    background:rgba(14,46,92,.55);backdrop-filter:blur(6px);
    align-items:center;justify-content:center;
}
.pl-confirm.open{display:flex}
.pl-confirm-box{
    background:var(--admin-surface);border-radius:22px;padding:32px 28px;
    max-width:400px;width:90%;text-align:center;
    box-shadow:0 28px 64px -20px rgba(14,46,92,.3);
    animation:pfSlideIn .3s ease;
}
@keyframes pfSlideIn{from{opacity:0;transform:translateY(-16px) scale(.96)}to{opacity:1;transform:none}}
.pl-confirm-icon{width:64px;height:64px;border-radius:18px;background:rgba(240,68,56,.1);color:#F04438;display:inline-flex;align-items:center;justify-content:center;font-size:28px;margin-bottom:16px}
.pl-confirm-title{font-family:var(--fd);font-size:20px;font-weight:800;margin-bottom:8px}
.pl-confirm-text{font-size:14px;color:var(--admin-text-light);line-height:1.6;margin-bottom:24px}
.pl-confirm-text b{color:var(--admin-text)}
.pl-confirm-actions{display:flex;gap:12px}
.pl-confirm-actions button{
    flex:1;padding:13px;border-radius:12px;font-weight:800;font-size:14px;cursor:pointer;border:none;
    transition:transform .2s,box-shadow .2s;
}
.pl-confirm-actions button:hover{transform:translateY(-2px)}
.pl-confirm-cancel{background:var(--admin-bg);color:var(--admin-text)}
.pl-confirm-delete{background:#F04438;color:#fff;box-shadow:0 8px 20px -8px rgba(240,68,56,.4)}

@media(max-width:768px){
    .pl-grid{grid-template-columns:1fr}
    .pl-stats{flex-direction:column}
}
</style>

<!-- Toast -->
<c:if test="${not empty param.success}">
<div class="pl-toast"><i class="fa-solid fa-circle-check"></i> Thao tác thành công!</div>
</c:if>

<!-- Stats -->
<c:set var="totalProducts" value="0"/>
<c:set var="totalStock" value="0"/>
<c:set var="totalFeatured" value="0"/>
<c:set var="totalLowStock" value="0"/>
<c:forEach var="p" items="${products}">
    <c:set var="totalProducts" value="${totalProducts + 1}"/>
    <c:set var="totalStock" value="${totalStock + p.stockQuantity}"/>
    <c:if test="${p.featured}"><c:set var="totalFeatured" value="${totalFeatured + 1}"/></c:if>
    <c:if test="${p.stockQuantity <= 10}"><c:set var="totalLowStock" value="${totalLowStock + 1}"/></c:if>
</c:forEach>

<div class="pl-stats">
    <div class="pl-stat">
        <div class="pl-stat-icon" style="background:linear-gradient(135deg,#3965FF,#7A5AF8)"><i class="fa-solid fa-box"></i></div>
        <div class="pl-stat-val" style="color:#3965FF">${totalProducts}</div>
        <div class="pl-stat-label">Tổng sản phẩm</div>
        <div style="position:absolute;top:-30px;right:-30px;width:80px;height:80px;border-radius:50%;background:#3965FF;opacity:.06"></div>
    </div>
    <div class="pl-stat">
        <div class="pl-stat-icon" style="background:linear-gradient(135deg,#12B76A,#0E8A51)"><i class="fa-solid fa-warehouse"></i></div>
        <div class="pl-stat-val" style="color:#12B76A">${totalStock}</div>
        <div class="pl-stat-label">Tổng tồn kho</div>
        <div style="position:absolute;top:-30px;right:-30px;width:80px;height:80px;border-radius:50%;background:#12B76A;opacity:.06"></div>
    </div>
    <div class="pl-stat">
        <div class="pl-stat-icon" style="background:linear-gradient(135deg,#FFB547,#D48806)"><i class="fa-solid fa-star"></i></div>
        <div class="pl-stat-val" style="color:#D48806">${totalFeatured}</div>
        <div class="pl-stat-label">Nổi bật</div>
        <div style="position:absolute;top:-30px;right:-30px;width:80px;height:80px;border-radius:50%;background:#FFB547;opacity:.06"></div>
    </div>
    <div class="pl-stat">
        <div class="pl-stat-icon" style="background:linear-gradient(135deg,#F04438,#CE2E2E)"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="pl-stat-val" style="color:#F04438">${totalLowStock}</div>
        <div class="pl-stat-label">Sắp hết hàng</div>
        <div style="position:absolute;top:-30px;right:-30px;width:80px;height:80px;border-radius:50%;background:#F04438;opacity:.06"></div>
    </div>
</div>

<!-- Toolbar -->
<div class="pl-toolbar">
    <div class="pl-search">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="plSearch" placeholder="Tìm sản phẩm...">
    </div>
    <div class="pl-filter-chips" id="plFilters">
        <div class="pl-chip active" data-filter="all">Tất cả</div>
        <div class="pl-chip" data-filter="featured"><i class="fa-solid fa-star" style="margin-right:4px;font-size:11px"></i>Nổi bật</div>
        <div class="pl-chip" data-filter="lowstock"><i class="fa-solid fa-triangle-exclamation" style="margin-right:4px;font-size:11px"></i>Sắp hết</div>
    </div>
    <a href="${pageContext.request.contextPath}/admin/san-pham/them" class="btn btn-primary" style="border-radius:14px;padding:13px 22px;font-size:14px;white-space:nowrap">
        <i class="fa-solid fa-plus"></i> Thêm sản phẩm
    </a>
</div>

<!-- Product Grid -->
<div class="pl-grid" id="plGrid">
<c:forEach var="p" items="${products}">
    <div class="pl-product" data-name="${fn:escapeXml(p.name)}" data-featured="${p.featured}" data-stock="${p.stockQuantity}">
        <div class="pl-img" style="background:${fn:escapeXml(p.bgColorHex != null ? p.bgColorHex : '#EDE6D2')}">
            <img src="${pageContext.request.contextPath}${p.imageUrl}" alt="${fn:escapeXml(p.name)}"
                 onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'120\' height=\'120\'%3E%3Crect width=\'100%25\' height=\'100%25\' fill=\'%23EDE6D2\' rx=\'12\'/%3E%3Ctext x=\'50%25\' y=\'56%25\' font-size=\'52\' text-anchor=\'middle\'%3E%F0%9F%A5%9B%3C/text%3E%3C/svg%3E'">
            <c:if test="${p.featured}">
                <span class="pl-img-badge pl-img-featured"><i class="fa-solid fa-star" style="margin-right:3px"></i>Nổi bật</span>
            </c:if>
            <c:if test="${p.stockQuantity <= 10}">
                <span class="pl-img-badge pl-img-lowstock"><i class="fa-solid fa-triangle-exclamation" style="margin-right:3px"></i>Sắp hết</span>
            </c:if>
            <form action="${pageContext.request.contextPath}/admin/san-pham/noi-bat" method="POST" style="position:absolute;top:14px;right:14px;margin:0">
                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                <input type="hidden" name="id" value="${p.productId}">
                <input type="hidden" name="featured" value="${p.featured}">
                <button type="submit" class="pl-star ${p.featured ? 'on' : 'off'}">
                    <i class="fa-solid fa-star"></i>
                </button>
            </form>
        </div>

        <div class="pl-body">
            <div class="pl-cat"><c:out value="${p.categoryName}"/></div>
            <div class="pl-name"><c:out value="${p.name}"/></div>
            <div class="pl-specs">${p.volumeMl}ml · ${p.kcalPer100ml} kcal/100ml</div>
            <div class="pl-bottom">
                <div class="pl-price">${p.formattedPrice}₫</div>
                <div class="pl-stock ${p.stockQuantity <= 10 ? 'pl-stock-low' : 'pl-stock-ok'}">
                    <span class="pl-stock-dot"></span> ${p.stockQuantity} sp
                </div>
            </div>
        </div>

        <div class="pl-actions">
            <a href="${pageContext.request.contextPath}/admin/san-pham/sua?id=${p.productId}" class="pl-act pl-act-edit">
                <i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa
            </a>
            <button type="button" class="pl-act pl-act-del" data-del-id="${p.productId}" data-del-name="${fn:escapeXml(p.name)}">
                <i class="fa-solid fa-trash-can"></i> Xoá
            </button>
        </div>
    </div>
</c:forEach>
</div>

<c:if test="${empty products}">
<div class="pl-empty">
    <i class="fa-solid fa-box-open"></i>
    <p>Chưa có sản phẩm nào. Bấm "Thêm sản phẩm" để bắt đầu!</p>
</div>
</c:if>

<!-- Delete Confirm Overlay -->
<div class="pl-confirm" id="delConfirm">
    <div class="pl-confirm-box">
        <div class="pl-confirm-icon"><i class="fa-solid fa-trash-can"></i></div>
        <div class="pl-confirm-title">Xoá sản phẩm?</div>
        <div class="pl-confirm-text">Bạn có chắc chắn muốn xoá<br><b id="delName"></b>?<br>Sản phẩm sẽ bị ẩn khỏi cửa hàng.</div>
        <div class="pl-confirm-actions">
            <button type="button" class="pl-confirm-cancel" onclick="closeDelete()">Huỷ bỏ</button>
            <form id="delForm" action="${pageContext.request.contextPath}/admin/san-pham/xoa" method="POST" style="flex:1;display:flex">
                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                <input type="hidden" name="id" id="delId">
                <button type="submit" class="pl-confirm-delete" style="width:100%"><i class="fa-solid fa-trash-can" style="margin-right:6px"></i>Xác nhận xoá</button>
            </form>
        </div>
    </div>
</div>

<script>
(function(){
    /* ── Search ── */
    var searchEl = document.getElementById('plSearch');
    var grid = document.getElementById('plGrid');
    var cards = grid ? grid.querySelectorAll('.pl-product') : [];

    function applyFilters(){
        var q = searchEl.value.toLowerCase().trim();
        var filter = document.querySelector('.pl-chip.active').getAttribute('data-filter');
        cards.forEach(function(c){
            var name = c.getAttribute('data-name').toLowerCase();
            var featured = c.getAttribute('data-featured') === 'true';
            var stock = parseInt(c.getAttribute('data-stock'));
            var matchSearch = !q || name.indexOf(q) >= 0;
            var matchFilter = filter === 'all' || (filter === 'featured' && featured) || (filter === 'lowstock' && stock <= 10);
            c.style.display = (matchSearch && matchFilter) ? '' : 'none';
        });
    }

    if (searchEl) searchEl.addEventListener('input', applyFilters);

    /* ── Filter Chips ── */
    document.querySelectorAll('.pl-chip').forEach(function(chip){
        chip.addEventListener('click', function(){
            document.querySelectorAll('.pl-chip').forEach(function(c){ c.classList.remove('active'); });
            this.classList.add('active');
            applyFilters();
        });
    });

    /* ── Delete Confirm (event delegation) ── */
    document.addEventListener('click', function(e){
        var btn = e.target.closest('[data-del-id]');
        if (!btn) return;
        document.getElementById('delId').value = btn.getAttribute('data-del-id');
        document.getElementById('delName').textContent = btn.getAttribute('data-del-name');
        document.getElementById('delConfirm').classList.add('open');
    });
    window.closeDelete = function(){
        document.getElementById('delConfirm').classList.remove('open');
    };
    document.getElementById('delConfirm').addEventListener('click', function(e){
        if (e.target === this) closeDelete();
    });

    /* ── Toast auto-remove ── */
    var toast = document.querySelector('.pl-toast');
    if (toast) setTimeout(function(){ toast.remove(); }, 3200);
})();
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
