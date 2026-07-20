<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
.pl-stats{display:flex;gap:16px;margin-bottom:26px;flex-wrap:wrap}
.pl-stat{flex:1;min-width:160px;padding:20px 22px;border-radius:18px;background:var(--admin-surface);border:1.5px solid var(--admin-border);transition:transform .3s,box-shadow .3s;position:relative;overflow:hidden}
.pl-stat:hover{transform:translateY(-4px);box-shadow:0 16px 36px -14px rgba(14,46,92,.14)}
.pl-stat-icon{width:42px;height:42px;border-radius:13px;display:flex;align-items:center;justify-content:center;font-size:18px;color:#fff;margin-bottom:12px}
.pl-stat-val{font-family:var(--fd);font-size:28px;font-weight:800;line-height:1}
.pl-stat-label{font-size:12px;font-weight:600;color:var(--admin-text-light);text-transform:uppercase;letter-spacing:.4px;margin-top:4px}

.pl-toolbar{display:flex;gap:14px;align-items:center;margin-bottom:22px;flex-wrap:wrap}
.pl-search{flex:1;min-width:220px;position:relative}
.pl-search input{width:100%;padding:13px 16px 13px 44px;border:1.5px solid var(--admin-border);border-radius:14px;font-size:14.5px;color:var(--admin-text);background:var(--admin-surface);font-family:var(--fb)}
.pl-search input:focus{border-color:var(--admin-primary);outline:none;box-shadow:0 0 0 4px rgba(27,79,158,.08)}
.pl-search i{position:absolute;left:16px;top:50%;transform:translateY(-50%);color:var(--admin-text-light);font-size:15px}

.pl-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:20px}
.pl-product{background:var(--admin-surface);border:1.5px solid var(--admin-border);border-radius:20px;overflow:hidden;transition:transform .35s,box-shadow .35s,border-color .3s;position:relative}
.pl-product:hover{transform:translateY(-6px);box-shadow:0 22px 50px -18px rgba(14,46,92,.16);border-color:rgba(57,101,255,.2)}
.pl-img{height:150px;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;background:#EDE6D2}
.pl-img img{height:110px;object-fit:contain}
.pl-img-badge{position:absolute;top:14px;left:14px;padding:5px 11px;border-radius:8px;font-size:11px;font-weight:800;letter-spacing:.03em}
.pl-img-active{background:rgba(18,183,106,.2);color:#0E8A51}
.pl-img-inactive{background:rgba(160,160,160,.2);color:#666}
.pl-body{padding:18px 20px 8px}
.pl-name{font-size:16px;font-weight:800;color:var(--admin-text);margin-bottom:6px;line-height:1.3}
.pl-specs{font-size:12.5px;color:var(--admin-text-light);font-weight:500;margin-bottom:14px;line-height:1.6}
.pl-bottom{display:flex;align-items:center;justify-content:space-between;padding-top:14px;border-top:1px solid rgba(224,229,242,.6)}
.pl-price{font-family:var(--fd);font-size:20px;font-weight:800;color:var(--admin-primary)}
.pl-actions{display:flex;gap:8px;padding:14px 20px 18px}
.pl-act{flex:1;padding:10px;border-radius:12px;border:none;cursor:pointer;font-size:13px;font-weight:700;display:flex;align-items:center;justify-content:center;gap:6px;transition:transform .2s}
.pl-act:hover{transform:translateY(-2px)}
.pl-act-edit{background:rgba(57,101,255,.08);color:var(--admin-primary)}
.pl-act-del{background:rgba(238,93,80,.06);color:#CE2E2E}

.pl-toast{position:fixed;top:24px;right:24px;z-index:9999;padding:16px 22px;border-radius:14px;background:#0E8A51;color:#fff;font-weight:700;font-size:14px;box-shadow:0 14px 32px -10px rgba(14,138,81,.4);display:flex;align-items:center;gap:10px;animation:plToastIn .4s ease,plToastOut .4s ease 2.6s forwards}
@keyframes plToastIn{from{opacity:0;transform:translateY(-16px)}to{opacity:1;transform:none}}
@keyframes plToastOut{to{opacity:0;transform:translateY(-16px)}}
.pl-empty{text-align:center;padding:60px 20px;color:var(--admin-text-light)}
.pl-empty i{font-size:48px;opacity:.3;margin-bottom:16px;display:block}

.pl-confirm{display:none;position:fixed;inset:0;z-index:9000;background:rgba(14,46,92,.55);backdrop-filter:blur(6px);align-items:center;justify-content:center}
.pl-confirm.open{display:flex}
.pl-confirm-box{background:var(--admin-surface);border-radius:22px;padding:32px 28px;max-width:400px;width:90%;text-align:center;box-shadow:0 28px 64px -20px rgba(14,46,92,.3)}
.pl-confirm-icon{width:64px;height:64px;border-radius:18px;background:rgba(240,68,56,.1);color:#F04438;display:inline-flex;align-items:center;justify-content:center;font-size:28px;margin-bottom:16px}
.pl-confirm-title{font-family:var(--fd);font-size:20px;font-weight:800;margin-bottom:8px}
.pl-confirm-text{font-size:14px;color:var(--admin-text-light);line-height:1.6;margin-bottom:24px}
.pl-confirm-actions{display:flex;gap:12px}
.pl-confirm-actions button{flex:1;padding:13px;border-radius:12px;font-weight:800;font-size:14px;cursor:pointer;border:none}
.pl-confirm-cancel{background:var(--admin-bg);color:var(--admin-text)}
.pl-confirm-delete{background:#F04438;color:#fff}

@media(max-width:768px){.pl-grid{grid-template-columns:1fr}.pl-stats{flex-direction:column}}
</style>

<c:if test="${not empty param.success}">
<div class="pl-toast"><i class="fa-solid fa-circle-check"></i> Thao tác thành công!</div>
</c:if>
<c:if test="${not empty param.error}">
<div class="pl-toast" style="background:#CE2E2E;box-shadow:0 14px 32px -10px rgba(206,46,46,.4)"><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${param.error}"/></div>
</c:if>

<c:set var="totalCombos" value="0"/>
<c:set var="totalActive" value="0"/>
<c:forEach var="cb" items="${combos}">
    <c:set var="totalCombos" value="${totalCombos + 1}"/>
    <c:if test="${cb.active}"><c:set var="totalActive" value="${totalActive + 1}"/></c:if>
</c:forEach>

<div class="pl-stats">
    <div class="pl-stat">
        <div class="pl-stat-icon" style="background:linear-gradient(135deg,#3965FF,#7A5AF8)"><i class="fa-solid fa-boxes-packing"></i></div>
        <div class="pl-stat-val" style="color:#3965FF">${totalCombos}</div>
        <div class="pl-stat-label">Tổng combo</div>
    </div>
    <div class="pl-stat">
        <div class="pl-stat-icon" style="background:linear-gradient(135deg,#12B76A,#0E8A51)"><i class="fa-solid fa-circle-check"></i></div>
        <div class="pl-stat-val" style="color:#12B76A">${totalActive}</div>
        <div class="pl-stat-label">Đang bán</div>
    </div>
</div>

<div class="pl-toolbar">
    <div class="pl-search">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="plSearch" placeholder="Tìm combo...">
    </div>
    <a href="${pageContext.request.contextPath}/admin/combo/them" class="btn btn-primary" style="border-radius:14px;padding:13px 22px;font-size:14px;white-space:nowrap">
        <i class="fa-solid fa-plus"></i> Thêm combo
    </a>
</div>

<div class="pl-grid" id="plGrid">
<c:forEach var="cb" items="${combos}">
    <div class="pl-product" data-name="${fn:escapeXml(cb.name)}">
        <div class="pl-img">
            <img src="${pageContext.request.contextPath}${cb.imageUrl}" alt="${fn:escapeXml(cb.name)}"
                 onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'120\' height=\'120\'%3E%3Crect width=\'100%25\' height=\'100%25\' fill=\'%23EDE6D2\' rx=\'12\'/%3E%3Ctext x=\'50%25\' y=\'56%25\' font-size=\'52\' text-anchor=\'middle\'%3E%F0%9F%8E%81%3C/text%3E%3C/svg%3E'">
            <span class="pl-img-badge ${cb.active ? 'pl-img-active' : 'pl-img-inactive'}">${cb.active ? 'Đang bán' : 'Đã ẩn'}</span>
        </div>
        <div class="pl-body">
            <div class="pl-name"><c:out value="${cb.name}"/></div>
            <div class="pl-specs">
                <c:forEach var="it" items="${cb.items}" varStatus="st">
                    <c:out value="${it.productName}"/> ×${it.quantity}<c:if test="${!st.last}">, </c:if>
                </c:forEach>
            </div>
            <div class="pl-bottom">
                <div class="pl-price">${cb.formattedPrice}₫</div>
            </div>
        </div>
        <div class="pl-actions">
            <a href="${pageContext.request.contextPath}/admin/combo/sua?id=${cb.comboId}" class="pl-act pl-act-edit">
                <i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa
            </a>
            <button type="button" class="pl-act pl-act-del" data-del-id="${cb.comboId}" data-del-name="${fn:escapeXml(cb.name)}">
                <i class="fa-solid fa-trash-can"></i> Xoá
            </button>
        </div>
    </div>
</c:forEach>
</div>

<c:if test="${empty combos}">
<div class="pl-empty">
    <i class="fa-solid fa-boxes-packing"></i>
    <p>Chưa có combo nào. Bấm "Thêm combo" để bắt đầu!</p>
</div>
</c:if>

<div class="pl-confirm" id="delConfirm">
    <div class="pl-confirm-box">
        <div class="pl-confirm-icon"><i class="fa-solid fa-trash-can"></i></div>
        <div class="pl-confirm-title">Xoá combo?</div>
        <div class="pl-confirm-text">Bạn có chắc chắn muốn xoá<br><b id="delName"></b>?<br>Combo sẽ bị ẩn khỏi cửa hàng.</div>
        <div class="pl-confirm-actions">
            <button type="button" class="pl-confirm-cancel" onclick="closeDelete()">Huỷ bỏ</button>
            <form id="delForm" action="${pageContext.request.contextPath}/admin/combo/xoa" method="POST" style="flex:1;display:flex">
                <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
                <input type="hidden" name="id" id="delId">
                <button type="submit" class="pl-confirm-delete" style="width:100%">Xác nhận xoá</button>
            </form>
        </div>
    </div>
</div>

<script>
(function(){
    var searchEl = document.getElementById('plSearch');
    var grid = document.getElementById('plGrid');
    var cards = grid ? grid.querySelectorAll('.pl-product') : [];

    if (searchEl) searchEl.addEventListener('input', function(){
        var q = this.value.toLowerCase().trim();
        cards.forEach(function(c){
            var name = c.getAttribute('data-name').toLowerCase();
            c.style.display = (!q || name.indexOf(q) >= 0) ? '' : 'none';
        });
    });

    document.addEventListener('click', function(e){
        var btn = e.target.closest('[data-del-id]');
        if (!btn) return;
        document.getElementById('delId').value = btn.getAttribute('data-del-id');
        document.getElementById('delName').textContent = btn.getAttribute('data-del-name');
        document.getElementById('delConfirm').classList.add('open');
    });
    window.closeDelete = function(){ document.getElementById('delConfirm').classList.remove('open'); };
    document.getElementById('delConfirm').addEventListener('click', function(e){ if (e.target === this) closeDelete(); });

    var toast = document.querySelector('.pl-toast');
    if (toast) setTimeout(function(){ toast.remove(); }, 3200);
})();
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
