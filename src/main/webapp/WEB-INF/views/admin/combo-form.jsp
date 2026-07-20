<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
.pf-wrap{max-width:920px;margin:0 auto}
.pf-card{background:var(--admin-surface);border-radius:24px;padding:36px 40px;box-shadow:0 20px 60px -20px rgba(14,46,92,.18),0 1px 3px rgba(14,46,92,.06);border:1.5px solid var(--admin-border)}
.pf-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:32px;padding-bottom:20px;border-bottom:2px solid var(--admin-border)}
.pf-title{display:flex;align-items:center;gap:14px}
.pf-title-icon{width:52px;height:52px;border-radius:16px;display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg,#3965FF,#7A5AF8);color:#fff;font-size:22px}
.pf-title h2{font-family:var(--fd);font-size:24px;font-weight:800;color:var(--admin-text)}
.pf-title small{font-size:13px;color:var(--admin-text-light);font-weight:500;display:block;margin-top:2px}
.pf-section{background:linear-gradient(135deg,rgba(57,101,255,.02),rgba(122,90,248,.015));border:1.5px solid rgba(224,229,242,.8);border-radius:18px;padding:24px 26px;margin-bottom:24px}
.pf-section-title{display:flex;align-items:center;gap:10px;font-size:15px;font-weight:800;color:var(--admin-text);margin-bottom:18px}
.pf-section-title i{width:32px;height:32px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:14px;color:#fff}
.ic-blue{background:linear-gradient(135deg,#3965FF,#1B4F9E)}
.ic-green{background:linear-gradient(135deg,#12B76A,#0E8A51)}
.ic-purple{background:linear-gradient(135deg,#7A5AF8,#5B3FD4)}
.pf-row{display:grid;gap:20px}
.pf-row-2{grid-template-columns:1fr 1fr}
.pf-field{margin-bottom:18px}
.pf-field label{display:flex;align-items:center;gap:6px;margin-bottom:8px;font-weight:700;font-size:13px;color:var(--admin-text)}
.pf-field label .req{color:#F04438;font-size:16px;line-height:1}
.pf-input{width:100%;padding:13px 16px;border:1.5px solid var(--admin-border);border-radius:12px;font-size:15px;color:var(--admin-text);background:var(--admin-surface);font-family:var(--fb)}
.pf-input:focus{border-color:var(--admin-primary);outline:none;box-shadow:0 0 0 4px rgba(27,79,158,.1)}
select.pf-input{cursor:pointer}
.pf-price-wrap{position:relative}
.pf-price-wrap .pf-input{padding-right:56px}
.pf-price-suffix{position:absolute;right:16px;top:50%;transform:translateY(-50%);font-size:13px;font-weight:800;color:var(--admin-primary);pointer-events:none}
.pf-upload-zone{position:relative;border:2.5px dashed var(--admin-border);border-radius:18px;padding:24px;text-align:center;cursor:pointer;min-height:140px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px}
.pf-upload-zone input[type=file]{position:absolute;inset:0;opacity:0;cursor:pointer;z-index:2}
.pf-upload-icon{width:54px;height:54px;border-radius:16px;background:linear-gradient(135deg,#3965FF,#7A5AF8);color:#fff;display:flex;align-items:center;justify-content:center;font-size:22px}
.pf-upload-text{font-size:14px;font-weight:600;color:var(--admin-text)}
.pf-upload-hint{font-size:12px;color:var(--admin-text-light)}
.pf-upload-preview{display:none}
.pf-upload-preview img{max-height:140px;border-radius:14px}
.pf-upload-current{margin-bottom:14px;display:flex;align-items:center;gap:12px;padding:10px 14px;background:rgba(18,183,106,.06);border-radius:12px;border:1px solid rgba(18,183,106,.15)}
.pf-upload-current img{height:44px;border-radius:8px}
.pf-upload-current span{font-size:12.5px;color:#0E8A51;font-weight:600}
.pf-toggle{display:flex;align-items:center;gap:14px;padding:14px 18px;background:rgba(57,101,255,.03);border-radius:14px;border:1.5px solid rgba(224,229,242,.6);cursor:pointer}
.pf-toggle input{display:none}
.pf-toggle-track{width:44px;height:24px;border-radius:12px;background:#D5DAE8;position:relative;flex-shrink:0;transition:background .3s}
.pf-toggle-track::after{content:'';position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;background:#fff;transition:transform .3s}
.pf-toggle input:checked ~ .pf-toggle-track{background:var(--admin-primary)}
.pf-toggle input:checked ~ .pf-toggle-track::after{transform:translateX(20px)}
.pf-toggle-label{font-size:14px;font-weight:700;color:var(--admin-text)}

/* ═══════════ Item Picker (fixed-bundle) ═══════════ */
.rule-row{display:grid;grid-template-columns:2fr 1fr auto;gap:12px;align-items:center;margin-bottom:12px}
.rule-remove{width:42px;height:42px;border-radius:12px;border:none;background:rgba(238,93,80,.08);color:#CE2E2E;cursor:pointer;font-size:16px}
.rule-remove:hover{background:rgba(238,93,80,.16)}
.rule-add{margin-top:6px;padding:11px 18px;border-radius:12px;border:1.5px dashed var(--admin-border);background:transparent;color:var(--admin-primary);font-weight:700;font-size:13.5px;cursor:pointer;width:100%}
.rule-add:hover{border-color:var(--admin-primary);background:rgba(57,101,255,.04)}
.combo-sum{margin-top:16px;padding:14px 18px;border-radius:14px;background:rgba(18,183,106,.06);border:1px solid rgba(18,183,106,.15);display:flex;align-items:center;justify-content:space-between;font-size:14px;font-weight:700;color:#0E8A51}
.combo-sum b{font-family:var(--fd);font-size:18px}

.pf-actions{display:flex;justify-content:flex-end;gap:14px;margin-top:8px;padding-top:24px;border-top:2px solid var(--admin-border)}
.pf-btn{padding:14px 28px;border-radius:14px;font-weight:800;font-size:15px;cursor:pointer;border:none;display:inline-flex;align-items:center;gap:10px}
.pf-btn-primary{background:linear-gradient(135deg,#1B4F9E,#3965FF);color:#fff;box-shadow:0 12px 28px -10px rgba(27,79,158,.5)}
.pf-btn-outline{background:transparent;border:2px solid var(--admin-border);color:var(--admin-text)}

@media(max-width:768px){
    .pf-card{padding:24px 20px}
    .pf-row-2{grid-template-columns:1fr}
    .rule-row{grid-template-columns:1fr 1fr;grid-template-areas:"cat cat" "qty rm"}
}
</style>

<div class="pf-wrap">
<div class="pf-card">

    <div class="pf-header">
        <div class="pf-title">
            <div class="pf-title-icon"><i class="fa-solid ${empty combo ? 'fa-plus' : 'fa-pen-to-square'}"></i></div>
            <div>
                <h2>${empty combo ? 'Thêm Combo Mới' : 'Sửa Combo'}</h2>
                <small>${empty combo ? 'Điền thông tin để tạo combo' : 'Chỉnh sửa combo #'}${combo.comboId}</small>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/combo" class="pf-btn pf-btn-outline">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <form id="comboForm" action="${pageContext.request.contextPath}/admin/combo/${empty combo ? 'them' : 'sua'}" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
        <c:if test="${not empty combo}">
            <input type="hidden" name="comboId" value="${combo.comboId}">
        </c:if>

        <!-- ══ Thông tin cơ bản ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-blue fa-solid fa-tag"></i> Thông tin cơ bản</div>
            <div class="pf-row pf-row-2">
                <div class="pf-field">
                    <label><span class="req">*</span> Tên combo</label>
                    <input type="text" name="name" id="nameInput" class="pf-input" required placeholder="VD: Combo Sữa Hạt Gia Đình" value="${fn:escapeXml(combo.name)}" oninput="generateSlug(this.value)" autocomplete="off">
                </div>
                <div class="pf-field">
                    <label><i class="fa-solid fa-link"></i> Slug (đường dẫn)</label>
                    <input type="text" name="slug" id="slugInput" class="pf-input" required placeholder="combo-sua-hat-gia-dinh" value="${fn:escapeXml(combo.slug)}">
                </div>
            </div>
            <div class="pf-row pf-row-2">
                <div class="pf-field">
                    <label><span class="req">*</span> Giá combo</label>
                    <div class="pf-price-wrap">
                        <input type="text" name="comboPrice" id="priceInput" class="pf-input" required inputmode="numeric" placeholder="199,000" value="${combo.comboPrice != null ? combo.comboPrice.toBigInteger() : ''}">
                        <span class="pf-price-suffix">VNĐ</span>
                    </div>
                </div>
                <div class="pf-field" style="display:flex;align-items:flex-end">
                    <label class="pf-toggle" style="margin-bottom:0;width:100%">
                        <input type="checkbox" name="isActive" ${empty combo || combo.active ? 'checked' : ''}>
                        <div class="pf-toggle-track"></div>
                        <div>
                            <div class="pf-toggle-label">Đang bán</div>
                        </div>
                    </label>
                </div>
            </div>
            <div class="pf-field">
                <label>Mô tả ngắn</label>
                <textarea name="description" class="pf-input" rows="3" placeholder="Mô tả combo hiển thị cho khách"><c:out value="${combo.description}"/></textarea>
            </div>
        </div>

        <!-- ══ Hình ảnh ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-purple fa-solid fa-image"></i> Hình ảnh combo</div>
            <c:if test="${not empty combo.imageUrl}">
                <div class="pf-upload-current">
                    <img src="${pageContext.request.contextPath}${combo.imageUrl}" alt="Ảnh hiện tại">
                    <span>Đang sử dụng: <c:out value="${combo.imageUrl}"/></span>
                </div>
            </c:if>
            <div class="pf-upload-zone" id="uploadZone">
                <input type="file" name="imageFile" id="imageFile" accept="image/jpeg,image/png,image/webp,image/gif">
                <div class="pf-upload-preview" id="uploadPreview"><img id="previewImg" src="" alt="Preview"></div>
                <div id="uploadPlaceholder">
                    <div class="pf-upload-icon"><i class="fa-solid fa-cloud-arrow-up"></i></div>
                    <div class="pf-upload-text">${empty combo ? 'Tải ảnh combo lên' : 'Thay đổi ảnh combo'}</div>
                    <div class="pf-upload-hint">JPG, PNG, WebP — Tối đa 5MB</div>
                </div>
            </div>
        </div>

        <!-- ══ Sản phẩm trong combo (fixed-bundle) ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-green fa-solid fa-list-check"></i> Chọn sản phẩm cho combo</div>
            <div id="ruleRows">
                <c:choose>
                    <c:when test="${not empty combo.items}">
                        <c:forEach var="it" items="${combo.items}">
                            <div class="rule-row">
                                <select name="itemProductId" class="pf-input item-product-select" required>
                                    <option value="" disabled>Chọn sản phẩm...</option>
                                    <c:forEach var="p" items="${products}">
                                        <option value="${p.productId}" data-price="${p.price}" ${it.productId == p.productId ? 'selected' : ''}><c:out value="${p.name}"/> — ${p.formattedPrice}đ</option>
                                    </c:forEach>
                                </select>
                                <input type="number" name="itemQuantity" class="pf-input item-qty" min="1" required value="${it.quantity}" placeholder="Số lượng">
                                <button type="button" class="rule-remove" onclick="removeRuleRow(this)"><i class="fa-solid fa-xmark"></i></button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="rule-row">
                            <select name="itemProductId" class="pf-input item-product-select" required>
                                <option value="" disabled selected>Chọn sản phẩm...</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.productId}" data-price="${p.price}"><c:out value="${p.name}"/> — ${p.formattedPrice}đ</option>
                                </c:forEach>
                            </select>
                            <input type="number" name="itemQuantity" class="pf-input item-qty" min="1" required placeholder="Số lượng">
                            <button type="button" class="rule-remove" onclick="removeRuleRow(this)"><i class="fa-solid fa-xmark"></i></button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="rule-add" id="addRuleBtn"><i class="fa-solid fa-plus"></i> Thêm sản phẩm</button>

            <div class="combo-sum">
                <span>Tổng giá gốc (tham khảo):</span>
                <b id="originalSum">0đ</b>
            </div>
        </div>

        <div class="pf-actions">
            <a href="${pageContext.request.contextPath}/admin/combo" class="pf-btn pf-btn-outline">Hủy</a>
            <button type="submit" class="pf-btn pf-btn-primary">
                <i class="fa-solid fa-save"></i> ${empty combo ? 'Thêm Combo' : 'Lưu Thay Đổi'}
            </button>
        </div>
    </form>
</div>
</div>

<script>
(function(){
    var PRODUCT_OPTIONS = document.querySelector('#ruleRows select').innerHTML;

    function formatVnd(n){
        return Math.round(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') + 'đ';
    }

    function recalcSum(){
        var total = 0;
        document.querySelectorAll('#ruleRows .rule-row').forEach(function(row){
            var select = row.querySelector('.item-product-select');
            var qtyEl = row.querySelector('.item-qty');
            var opt = select.options[select.selectedIndex];
            var price = opt ? parseFloat(opt.getAttribute('data-price')) || 0 : 0;
            var qty = parseInt(qtyEl.value) || 0;
            total += price * qty;
        });
        document.getElementById('originalSum').textContent = formatVnd(total);
    }

    document.getElementById('addRuleBtn').addEventListener('click', function(){
        var row = document.createElement('div');
        row.className = 'rule-row';
        row.innerHTML = '<select name="itemProductId" class="pf-input item-product-select" required>' + PRODUCT_OPTIONS + '</select>'
            + '<input type="number" name="itemQuantity" class="pf-input item-qty" min="1" required placeholder="Số lượng">'
            + '<button type="button" class="rule-remove" onclick="removeRuleRow(this)"><i class="fa-solid fa-xmark"></i></button>';
        document.getElementById('ruleRows').appendChild(row);
        recalcSum();
    });

    window.removeRuleRow = function(btn){
        var rows = document.getElementById('ruleRows');
        if (rows.children.length <= 1) return; // luôn giữ tối thiểu 1 sản phẩm
        btn.closest('.rule-row').remove();
        recalcSum();
    };

    document.getElementById('ruleRows').addEventListener('input', recalcSum);
    document.getElementById('ruleRows').addEventListener('change', recalcSum);
    recalcSum();

    /* ── Price Formatting ── */
    var priceEl = document.getElementById('priceInput');
    function formatPrice(v){
        var n = v.replace(/[^\d]/g, '');
        if (!n) return '';
        return n.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
    priceEl.addEventListener('input', function(){ this.value = formatPrice(this.value); });
    if (priceEl.value) priceEl.value = formatPrice(priceEl.value);

    /* ── Image Preview ── */
    var fileInput = document.getElementById('imageFile');
    var preview = document.getElementById('uploadPreview');
    var previewImg = document.getElementById('previewImg');
    var placeholder = document.getElementById('uploadPlaceholder');
    fileInput.addEventListener('change', function(){
        if (!this.files || !this.files[0]) return;
        var file = this.files[0];
        if (!file.type.startsWith('image/')) return;
        if (file.size > 5*1024*1024){ alert('Ảnh quá lớn! Tối đa 5MB.'); fileInput.value=''; return; }
        var reader = new FileReader();
        reader.onload = function(e){
            previewImg.src = e.target.result;
            preview.style.display = 'block';
            placeholder.style.display = 'none';
        };
        reader.readAsDataURL(file);
    });

    /* ── Slug Generator ── */
    window.generateSlug = function(text){
        var slug = text.toLowerCase();
        slug = slug.replace(/á|à|ả|ạ|ã|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ/gi, 'a');
        slug = slug.replace(/é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ/gi, 'e');
        slug = slug.replace(/i|í|ì|ỉ|ĩ|ị/gi, 'i');
        slug = slug.replace(/ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ/gi, 'o');
        slug = slug.replace(/ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự/gi, 'u');
        slug = slug.replace(/ý|ỳ|ỷ|ỹ|ỵ/gi, 'y');
        slug = slug.replace(/đ/gi, 'd');
        slug = slug.replace(/[^a-z0-9 -]/g, '');
        slug = slug.replace(/\s+/g, '-').replace(/-+/g, '-');
        var slugEl = document.getElementById('slugInput');
        if (!slugEl.dataset.manual) slugEl.value = slug;
    };
    document.getElementById('slugInput').addEventListener('input', function(){ this.dataset.manual = '1'; });
})();
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
