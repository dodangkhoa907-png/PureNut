<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet">
<style>
/* ═══════════ 3D Form Container ═══════════ */
.pf-wrap{max-width:920px;margin:0 auto;perspective:1200px}
.pf-card{
    background:var(--admin-surface);border-radius:24px;padding:36px 40px;
    box-shadow:0 20px 60px -20px rgba(14,46,92,.18),0 1px 3px rgba(14,46,92,.06);
    border:1.5px solid var(--admin-border);
    transition:box-shadow .5s;
}
.pf-card:hover{box-shadow:0 32px 80px -24px rgba(14,46,92,.22),0 2px 6px rgba(14,46,92,.08)}

/* ═══════════ Header ═══════════ */
.pf-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:32px;padding-bottom:20px;border-bottom:2px solid var(--admin-border)}
.pf-title{display:flex;align-items:center;gap:14px}
.pf-title-icon{
    width:52px;height:52px;border-radius:16px;display:flex;align-items:center;justify-content:center;
    background:linear-gradient(135deg,#3965FF,#7A5AF8);color:#fff;font-size:22px;
    box-shadow:0 10px 24px -8px rgba(57,101,255,.45);
    transition:transform .4s;
}
.pf-card:hover .pf-title-icon{transform:scale(1.06) rotateY(8deg)}
.pf-title h2{font-family:var(--fd);font-size:24px;font-weight:800;color:var(--admin-text)}
.pf-title small{font-size:13px;color:var(--admin-text-light);font-weight:500;display:block;margin-top:2px}

/* ═══════════ Section Cards ═══════════ */
.pf-section{
    background:linear-gradient(135deg,rgba(57,101,255,.02),rgba(122,90,248,.015));
    border:1.5px solid rgba(224,229,242,.8);border-radius:18px;padding:24px 26px;margin-bottom:24px;
    transition:border-color .3s,box-shadow .3s;
}
.pf-section:hover{border-color:rgba(57,101,255,.2);box-shadow:0 12px 32px -16px rgba(57,101,255,.12)}
.pf-section-title{display:flex;align-items:center;gap:10px;font-size:15px;font-weight:800;color:var(--admin-text);margin-bottom:18px}
.pf-section-title i{width:32px;height:32px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:14px;color:#fff}
.ic-blue{background:linear-gradient(135deg,#3965FF,#1B4F9E)}
.ic-green{background:linear-gradient(135deg,#12B76A,#0E8A51)}
.ic-purple{background:linear-gradient(135deg,#7A5AF8,#5B3FD4)}
.ic-orange{background:linear-gradient(135deg,#F5A524,#D48806)}

/* ═══════════ Form Inputs ═══════════ */
.pf-row{display:grid;gap:20px}
.pf-row-2{grid-template-columns:1fr 1fr}
.pf-row-3{grid-template-columns:1fr 1fr 1fr}

.pf-field{margin-bottom:18px;position:relative}
.pf-field label{display:flex;align-items:center;gap:6px;margin-bottom:8px;font-weight:700;font-size:13px;color:var(--admin-text);letter-spacing:.02em}
.pf-field label .req{color:#F04438;font-size:16px;line-height:1}
.pf-field label i.fa-solid{font-size:12px;color:var(--admin-text-light);opacity:.7}

.pf-input{
    width:100%;padding:13px 16px;
    border:1.5px solid var(--admin-border);border-radius:12px;
    font-size:15px;color:var(--admin-text);background:var(--admin-surface);
    transition:border-color .25s,box-shadow .25s;
    font-family:var(--fb);
}
.pf-input:focus{
    border-color:var(--admin-primary);outline:none;
    box-shadow:0 0 0 4px rgba(27,79,158,.1),0 8px 20px -12px rgba(27,79,158,.15);
}
.pf-input::placeholder{color:var(--admin-text-light);font-weight:400}

select.pf-input{cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23A3AED0' stroke-width='2' fill='none'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 16px center;padding-right:40px}

/* ═══════════ Custom Number Stepper ═══════════ */
.pf-stepper{display:flex;align-items:stretch;border:1.5px solid var(--admin-border);border-radius:12px;overflow:hidden;transition:border-color .25s,box-shadow .25s}
.pf-stepper:focus-within{border-color:var(--admin-primary);box-shadow:0 0 0 4px rgba(27,79,158,.1)}
.pf-stepper input{
    flex:1;border:none;outline:none;padding:13px 14px;font-size:15px;color:var(--admin-text);
    font-family:var(--fb);text-align:center;min-width:0;background:transparent;
    -moz-appearance:textfield;
}
.pf-stepper input::-webkit-inner-spin-button,
.pf-stepper input::-webkit-outer-spin-button{display:none}
.pf-step-btn{
    width:42px;display:flex;align-items:center;justify-content:center;
    background:var(--admin-bg);border:none;cursor:pointer;font-size:16px;font-weight:700;
    color:var(--admin-primary);transition:background .2s,color .15s;user-select:none;
}
.pf-step-btn:hover{background:rgba(57,101,255,.12);color:#1B4F9E}
.pf-step-btn:active{background:rgba(57,101,255,.2);transform:scale(.95)}

/* ═══════════ Image Upload ═══════════ */
.pf-upload-zone{
    position:relative;border:2.5px dashed var(--admin-border);border-radius:18px;
    padding:32px 24px;text-align:center;cursor:pointer;
    background:linear-gradient(135deg,rgba(57,101,255,.02),rgba(122,90,248,.02));
    transition:border-color .3s,background .3s;
    min-height:200px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;
}
.pf-upload-zone:hover,.pf-upload-zone.dragover{border-color:var(--admin-primary);background:rgba(57,101,255,.04)}
.pf-upload-zone input[type=file]{position:absolute;inset:0;opacity:0;cursor:pointer;z-index:2}
.pf-upload-icon{
    width:64px;height:64px;border-radius:18px;
    background:linear-gradient(135deg,#3965FF,#7A5AF8);color:#fff;
    display:flex;align-items:center;justify-content:center;font-size:26px;
    box-shadow:0 12px 28px -8px rgba(57,101,255,.4);
    transition:transform .4s cubic-bezier(.4,0,.2,1);
}
.pf-upload-zone:hover .pf-upload-icon{transform:scale(1.08) rotateY(10deg)}
.pf-upload-text{font-size:14px;font-weight:600;color:var(--admin-text)}
.pf-upload-hint{font-size:12px;color:var(--admin-text-light)}
.pf-upload-preview{display:none;position:relative;z-index:3}
.pf-upload-preview img{max-height:180px;border-radius:14px;box-shadow:0 12px 32px -12px rgba(0,0,0,.18)}
.pf-upload-preview .pf-remove-img{
    position:absolute;top:-8px;right:-8px;width:28px;height:28px;border-radius:50%;
    background:#F04438;color:#fff;border:3px solid var(--admin-surface);
    display:flex;align-items:center;justify-content:center;font-size:12px;cursor:pointer;
    transition:transform .2s;box-shadow:0 4px 12px rgba(240,68,56,.4);z-index:4;
}
.pf-upload-preview .pf-remove-img:hover{transform:scale(1.15)}
.pf-upload-current{margin-bottom:14px;display:flex;align-items:center;gap:12px;padding:10px 14px;background:rgba(18,183,106,.06);border-radius:12px;border:1px solid rgba(18,183,106,.15)}
.pf-upload-current img{height:48px;border-radius:8px}
.pf-upload-current span{font-size:12.5px;color:#0E8A51;font-weight:600}

/* ═══════════ Price Input ═══════════ */
.pf-price-wrap{position:relative}
.pf-price-wrap .pf-input{padding-right:56px}
.pf-price-suffix{position:absolute;right:16px;top:50%;transform:translateY(-50%);font-size:13px;font-weight:800;color:var(--admin-primary);pointer-events:none}

/* ═══════════ Color Picker ═══════════ */
.pf-color-row{display:flex;gap:10px;align-items:center}
.pf-color-swatch{
    width:48px;height:48px;border-radius:12px;border:2px solid var(--admin-border);
    cursor:pointer;transition:transform .2s,box-shadow .2s;flex-shrink:0;
}
.pf-color-swatch:hover{transform:scale(1.08);box-shadow:0 6px 16px -6px rgba(0,0,0,.2)}
input[type=color].pf-color-swatch{padding:0;-webkit-appearance:none;appearance:none}
input[type=color].pf-color-swatch::-webkit-color-swatch-wrapper{padding:0}
input[type=color].pf-color-swatch::-webkit-color-swatch{border:none;border-radius:10px}

/* ═══════════ Toggle Switch ═══════════ */
.pf-toggle{display:flex;align-items:center;gap:14px;padding:14px 18px;background:rgba(57,101,255,.03);border-radius:14px;border:1.5px solid rgba(224,229,242,.6);cursor:pointer;transition:background .2s,border-color .2s}
.pf-toggle:hover{background:rgba(57,101,255,.06);border-color:rgba(57,101,255,.15)}
.pf-toggle input{display:none}
.pf-toggle-track{
    width:44px;height:24px;border-radius:12px;background:#D5DAE8;position:relative;
    transition:background .3s;flex-shrink:0;
}
.pf-toggle-track::after{
    content:'';position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;
    background:#fff;box-shadow:0 2px 6px rgba(0,0,0,.15);transition:transform .3s;
}
.pf-toggle input:checked ~ .pf-toggle-track{background:var(--admin-primary)}
.pf-toggle input:checked ~ .pf-toggle-track::after{transform:translateX(20px)}
.pf-toggle-label{font-size:14px;font-weight:700;color:var(--admin-text)}
.pf-toggle-desc{font-size:12px;color:var(--admin-text-light);margin-top:1px}

/* ═══════════ Quill Editor ═══════════ */
.pf-editor-wrap{border:1.5px solid var(--admin-border);border-radius:14px;overflow:hidden;transition:border-color .25s,box-shadow .25s}
.pf-editor-wrap:focus-within{border-color:var(--admin-primary);box-shadow:0 0 0 4px rgba(27,79,158,.1)}
.pf-editor-wrap .ql-toolbar{border:none!important;border-bottom:1.5px solid var(--admin-border)!important;background:rgba(244,247,254,.5);padding:10px 14px}
.pf-editor-wrap .ql-container{border:none!important;font-family:var(--fb);font-size:15px;min-height:160px}
.pf-editor-wrap .ql-editor{padding:16px 18px;color:var(--admin-text);line-height:1.7}
.pf-editor-wrap .ql-editor.ql-blank::before{color:var(--admin-text-light);font-style:normal}

/* ═══════════ Submit Bar ═══════════ */
.pf-actions{display:flex;justify-content:flex-end;gap:14px;margin-top:8px;padding-top:24px;border-top:2px solid var(--admin-border)}
.pf-btn{
    padding:14px 28px;border-radius:14px;font-weight:800;font-size:15px;cursor:pointer;
    border:none;display:inline-flex;align-items:center;gap:10px;
    transition:transform .25s,box-shadow .25s,background .2s;
}
.pf-btn:hover{transform:translateY(-3px)}
.pf-btn-primary{
    background:linear-gradient(135deg,#1B4F9E,#3965FF);color:#fff;
    box-shadow:0 12px 28px -10px rgba(27,79,158,.5);
}
.pf-btn-primary:hover{box-shadow:0 18px 36px -12px rgba(27,79,158,.6)}
.pf-btn-outline{
    background:transparent;border:2px solid var(--admin-border);color:var(--admin-text);
}
.pf-btn-outline:hover{border-color:var(--admin-primary);color:var(--admin-primary);box-shadow:0 8px 20px -10px rgba(57,101,255,.2)}

/* ═══════════ Duplicate Name Warning ═══════════ */
.pf-dup-banner{
    display:none;margin-top:10px;padding:14px 18px;border-radius:14px;
    background:rgba(245,165,36,.08);border:1.5px solid rgba(245,165,36,.25);
    animation:pfSlideIn .3s ease;
}
@keyframes pfSlideIn{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:none}}
.pf-dup-banner-title{display:flex;align-items:center;gap:8px;font-size:13.5px;font-weight:800;color:#B45309;margin-bottom:10px}
.pf-dup-item{
    display:flex;align-items:center;gap:14px;padding:12px 14px;border-radius:12px;
    background:var(--admin-surface);border:1px solid var(--admin-border);margin-bottom:8px;
    cursor:pointer;transition:border-color .2s,box-shadow .2s;
}
.pf-dup-item:hover{border-color:var(--admin-primary);box-shadow:0 6px 18px -8px rgba(57,101,255,.2)}
.pf-dup-item img{width:44px;height:44px;border-radius:10px;object-fit:cover;background:#f0ebe0}
.pf-dup-item-info{flex:1;min-width:0}
.pf-dup-item-name{font-size:14px;font-weight:700;color:var(--admin-text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pf-dup-item-meta{font-size:12px;color:var(--admin-text-light);margin-top:2px}
.pf-dup-item-action{font-size:12px;font-weight:700;color:var(--admin-primary);white-space:nowrap;display:flex;align-items:center;gap:4px}
.pf-dup-dismiss{margin-top:6px;font-size:12.5px;color:var(--admin-text-light);cursor:pointer;text-align:center;font-weight:600}
.pf-dup-dismiss:hover{color:var(--admin-primary)}

@media(max-width:768px){
    .pf-card{padding:24px 20px}
    .pf-row-2,.pf-row-3{grid-template-columns:1fr}
    .pf-header{flex-direction:column;gap:14px;align-items:flex-start}
}
</style>

<div class="pf-wrap">
<div class="pf-card">

    <!-- Header -->
    <div class="pf-header">
        <div class="pf-title">
            <div class="pf-title-icon"><i class="fa-solid ${empty product ? 'fa-plus' : 'fa-pen-to-square'}"></i></div>
            <div>
                <h2>${empty product ? 'Thêm Sản Phẩm Mới' : 'Sửa Sản Phẩm'}</h2>
                <small>${empty product ? 'Điền thông tin để tạo sản phẩm' : 'Chỉnh sửa thông tin sản phẩm #'}${product.productId}</small>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/san-pham" class="pf-btn pf-btn-outline">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <form id="productForm" action="${pageContext.request.contextPath}/admin/san-pham/${empty product ? 'them' : 'sua'}" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
        <c:if test="${not empty product}">
            <input type="hidden" name="productId" value="${product.productId}">
        </c:if>

        <!-- ══ Section 1: Thông tin cơ bản ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-blue fa-solid fa-tag"></i> Thông tin cơ bản</div>
            <div class="pf-row pf-row-2">
                <div class="pf-field">
                    <label><span class="req">*</span> Tên sản phẩm</label>
                    <input type="text" name="name" id="nameInput" class="pf-input" required placeholder="VD: Sữa Hạt Yến Mạch" value="${fn:escapeXml(product.name)}" oninput="generateSlug(this.value)" autocomplete="off">
                    <div class="pf-dup-banner" id="dupBanner"></div>
                </div>
                <div class="pf-field">
                    <label><i class="fa-solid fa-link"></i> Slug (đường dẫn)</label>
                    <input type="text" name="slug" id="slugInput" class="pf-input" required placeholder="sua-hat-yen-mach" value="${product.slug}">
                </div>
            </div>
            <div class="pf-row pf-row-2">
                <div class="pf-field">
                    <label><span class="req">*</span> Danh mục</label>
                    <select name="categoryId" class="pf-input" required>
                        <option value="" disabled ${empty product ? 'selected' : ''}>Chọn danh mục...</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${product.categoryId == c.categoryId ? 'selected' : ''}><c:out value="${c.name}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="pf-field">
                    <label><span class="req">*</span> Giá bán</label>
                    <div class="pf-price-wrap">
                        <input type="text" name="price" id="priceInput" class="pf-input" required inputmode="numeric" placeholder="21,000" value="${product.price != null ? product.price.toBigInteger() : ''}">
                        <span class="pf-price-suffix">VNĐ</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ══ Section 2: Hình ảnh sản phẩm ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-purple fa-solid fa-image"></i> Hình ảnh sản phẩm</div>

            <c:if test="${not empty product.imageUrl}">
                <div class="pf-upload-current" id="currentImg">
                    <img src="${pageContext.request.contextPath}${product.imageUrl}" alt="Ảnh hiện tại">
                    <span><i class="fa-solid fa-circle-check" style="margin-right:4px"></i>Đang sử dụng: ${product.imageUrl}</span>
                </div>
            </c:if>

            <div class="pf-upload-zone" id="uploadZone">
                <input type="file" name="imageFile" id="imageFile" accept="image/jpeg,image/png,image/webp,image/gif">
                <div class="pf-upload-preview" id="uploadPreview">
                    <img id="previewImg" src="" alt="Preview">
                    <div class="pf-remove-img" onclick="removePreview(event)"><i class="fa-solid fa-xmark"></i></div>
                </div>
                <div id="uploadPlaceholder">
                    <div class="pf-upload-icon"><i class="fa-solid fa-cloud-arrow-up"></i></div>
                    <div class="pf-upload-text">${empty product ? 'Tải ảnh sản phẩm lên' : 'Thay đổi ảnh sản phẩm'}</div>
                    <div class="pf-upload-hint">Kéo thả hoặc click để chọn — JPG, PNG, WebP — Tối đa 5MB</div>
                </div>
            </div>
        </div>

        <!-- ══ Section 3: Thông số ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-green fa-solid fa-sliders"></i> Thông số sản phẩm</div>
            <div class="pf-row pf-row-3">
                <div class="pf-field">
                    <label><i class="fa-solid fa-palette"></i> Màu nền</label>
                    <div class="pf-color-row">
                        <input type="color" id="colorPicker" class="pf-color-swatch" value="${product.bgColorHex != null ? product.bgColorHex : '#E7C9A0'}">
                        <input type="text" name="bgColorHex" id="colorHex" class="pf-input" value="${product.bgColorHex != null ? product.bgColorHex : '#E7C9A0'}" placeholder="#E7C9A0">
                    </div>
                </div>
                <div class="pf-field">
                    <label><i class="fa-solid fa-flask"></i> Thể tích (ml)</label>
                    <div class="pf-stepper">
                        <button type="button" class="pf-step-btn" data-step="-10">−</button>
                        <input type="number" name="volumeMl" min="0" step="10" value="${product.volumeMl != null ? product.volumeMl : 300}" placeholder="300">
                        <button type="button" class="pf-step-btn" data-step="10">+</button>
                    </div>
                </div>
                <div class="pf-field">
                    <label><i class="fa-solid fa-fire"></i> Kcal / 100ml</label>
                    <div class="pf-stepper">
                        <button type="button" class="pf-step-btn" data-step="-1">−</button>
                        <input type="number" name="kcalPer100ml" min="0" step="1" value="${product.kcalPer100ml}" placeholder="45">
                        <button type="button" class="pf-step-btn" data-step="1">+</button>
                    </div>
                </div>
            </div>
            <div class="pf-row pf-row-2">
                <div class="pf-field">
                    <label><i class="fa-solid fa-boxes-stacked"></i> Số lượng tồn kho</label>
                    <div class="pf-stepper">
                        <button type="button" class="pf-step-btn" data-step="-1">−</button>
                        <input type="number" name="stockQuantity" min="0" required value="${product.stockQuantity != null ? product.stockQuantity : 100}" placeholder="100">
                        <button type="button" class="pf-step-btn" data-step="1">+</button>
                    </div>
                </div>
                <div class="pf-field" style="display:flex;align-items:flex-end">
                    <label class="pf-toggle" style="margin-bottom:0;width:100%">
                        <input type="checkbox" name="isFeatured" ${product.featured ? 'checked' : ''}>
                        <div class="pf-toggle-track"></div>
                        <div>
                            <div class="pf-toggle-label">Sản phẩm nổi bật</div>
                            <div class="pf-toggle-desc">Hiển thị ở trang chủ</div>
                        </div>
                    </label>
                </div>
            </div>
        </div>

        <!-- ══ Section 4: Mô tả sản phẩm ══ -->
        <div class="pf-section">
            <div class="pf-section-title"><i class="ic-orange fa-solid fa-align-left"></i> Mô tả sản phẩm</div>
            <div class="pf-editor-wrap">
                <div id="quillEditor"></div>
            </div>
            <input type="hidden" name="description" id="descriptionInput">
            <div id="existingDesc" style="display:none"><c:out value="${product.description}" escapeXml="false"/></div>
        </div>

        <!-- ══ Actions ══ -->
        <div class="pf-actions">
            <a href="${pageContext.request.contextPath}/admin/san-pham" class="pf-btn pf-btn-outline">Hủy</a>
            <button type="submit" class="pf-btn pf-btn-primary">
                <i class="fa-solid fa-save"></i> ${empty product ? 'Thêm Sản Phẩm' : 'Lưu Thay Đổi'}
            </button>
        </div>
    </form>
</div>
</div>

<script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
<script>
(function(){
    var CTX = document.querySelector('meta[name=ctx]').content;
    var editingId = parseInt('${product.productId}') || 0;

    /* ── Quill Editor ── */
    var quill = new Quill('#quillEditor', {
        theme: 'snow',
        placeholder: 'Nhập mô tả sản phẩm... (in đậm, in nghiêng, danh sách...)',
        modules: {
            toolbar: [
                ['bold', 'italic', 'underline', 'strike'],
                [{'header': [2, 3, false]}],
                [{'list': 'ordered'}, {'list': 'bullet'}],
                ['blockquote', 'link'],
                ['clean']
            ]
        }
    });

    var existingEl = document.getElementById('existingDesc');
    if (existingEl && existingEl.innerHTML.trim()) {
        quill.root.innerHTML = existingEl.innerHTML;
    }

    document.getElementById('productForm').addEventListener('submit', function(){
        var html = quill.root.innerHTML;
        if (html === '<p><br></p>') html = '';
        document.getElementById('descriptionInput').value = html;
    });

    /* ── Custom Number Stepper (event delegation) ── */
    document.addEventListener('click', function(e){
        var btn = e.target.closest('.pf-step-btn');
        if (!btn) return;
        e.preventDefault();
        var input = btn.parentElement.querySelector('input');
        if (!input) return;
        var delta = parseInt(btn.getAttribute('data-step')) || 0;
        var cur = parseInt(input.value) || 0;
        var min = parseInt(input.min) || 0;
        var nv = cur + delta;
        if (nv < min) nv = min;
        input.value = nv;
        input.focus();
    });

    /* ── Price Formatting ── */
    var priceEl = document.getElementById('priceInput');
    function formatPrice(v){
        var n = v.replace(/[^\d]/g, '');
        if (!n) return '';
        return n.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
    priceEl.addEventListener('input', function(){
        var pos = this.selectionStart;
        var oldLen = this.value.length;
        this.value = formatPrice(this.value);
        var diff = this.value.length - oldLen;
        this.setSelectionRange(pos + diff, pos + diff);
    });
    if (priceEl.value) priceEl.value = formatPrice(priceEl.value);

    /* ── Image Upload + Preview ── */
    var zone = document.getElementById('uploadZone');
    var fileInput = document.getElementById('imageFile');
    var preview = document.getElementById('uploadPreview');
    var previewImg = document.getElementById('previewImg');
    var placeholder = document.getElementById('uploadPlaceholder');

    fileInput.addEventListener('change', function(){
        if (this.files && this.files[0]) showPreview(this.files[0]);
    });

    zone.addEventListener('dragover', function(e){ e.preventDefault(); zone.classList.add('dragover'); });
    zone.addEventListener('dragleave', function(){ zone.classList.remove('dragover'); });
    zone.addEventListener('drop', function(e){
        e.preventDefault(); zone.classList.remove('dragover');
        if (e.dataTransfer.files[0]) {
            fileInput.files = e.dataTransfer.files;
            showPreview(e.dataTransfer.files[0]);
        }
    });

    function showPreview(file){
        if (!file.type.startsWith('image/')) return;
        if (file.size > 5*1024*1024){ alert('Ảnh quá lớn! Tối đa 5MB.'); fileInput.value=''; return; }
        var reader = new FileReader();
        reader.onload = function(e){
            previewImg.src = e.target.result;
            preview.style.display = 'block';
            placeholder.style.display = 'none';
        };
        reader.readAsDataURL(file);
    }

    window.removePreview = function(e){
        e.stopPropagation(); e.preventDefault();
        fileInput.value = '';
        preview.style.display = 'none';
        placeholder.style.display = '';
    };

    /* ── Duplicate Name Check ── */
    var nameInput = document.getElementById('nameInput');
    var dupBanner = document.getElementById('dupBanner');
    var dupTimer = null;
    window._window._dupDismissed = false;

    nameInput.addEventListener('input', function(){
        window._dupDismissed = false;
        clearTimeout(dupTimer);
        var val = this.value.trim();
        if (val.length < 2) { dupBanner.style.display = 'none'; return; }
        dupTimer = setTimeout(function(){ checkDupName(val); }, 400);
    });

    function checkDupName(name){
        var url = CTX + '/admin/san-pham/check-name?name=' + encodeURIComponent(name);
        if (editingId) url += '&excludeId=' + editingId;
        fetch(url).then(function(r){ return r.json(); }).then(function(d){
            if (window._dupDismissed) return;
            if (!d.matches || d.matches.length === 0) {
                dupBanner.style.display = 'none';
                return;
            }
            var html = '<div class="pf-dup-banner-title"><i class="fa-solid fa-triangle-exclamation"></i> Phát hiện sản phẩm tương tự!</div>';
            d.matches.forEach(function(m){
                var imgSrc = m.imageUrl ? (CTX + m.imageUrl) : "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='44' height='44'%3E%3Crect width='100%25' height='100%25' fill='%23EDE6D2'/%3E%3Ctext x='50%25' y='60%25' font-size='22' text-anchor='middle'%3E%F0%9F%A5%9B%3C/text%3E%3C/svg%3E";
                var price = m.price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
                html += '<div class="pf-dup-item" onclick="window.location.href=\'' + CTX + '/admin/san-pham/sua?id=' + m.id + '\'">'
                    + '<img src="' + imgSrc + '" onerror="this.src=\'data:image/svg+xml,%253Csvg xmlns=%2527http://www.w3.org/2000/svg%2527 width=%252744%2527 height=%252744%2527%253E%253Crect width=%2527100%2525%2527 height=%2527100%2525%2527 fill=%2527%2523EDE6D2%2527/%253E%253Ctext x=%252750%2525%2527 y=%252760%2525%2527 font-size=%252722%2527 text-anchor=%2527middle%2527%253E%25F0%259F%25A5%259B%253C/text%253E%253C/svg%253E\'">'
                    + '<div class="pf-dup-item-info">'
                    + '<div class="pf-dup-item-name">' + m.name + '</div>'
                    + '<div class="pf-dup-item-meta">' + m.categoryName + ' · ' + price + '₫ · Kho: ' + m.stock + '</div>'
                    + '</div>'
                    + '<div class="pf-dup-item-action"><i class="fa-solid fa-pen-to-square"></i> Sửa SP này</div>'
                    + '</div>';
            });
            html += '<div class="pf-dup-dismiss" onclick="event.stopPropagation();document.getElementById(\'dupBanner\').style.display=\'none\';window._dupDismissed=true;">Bỏ qua, tôi muốn tạo sản phẩm mới</div>';
            dupBanner.innerHTML = html;
            dupBanner.style.display = 'block';
        }).catch(function(){});
    }
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

    /* ── Color Picker Sync ── */
    document.getElementById('colorPicker').addEventListener('input', function(){
        document.getElementById('colorHex').value = this.value.toUpperCase();
    });
    document.getElementById('colorHex').addEventListener('input', function(){
        if (/^#[0-9A-Fa-f]{6}$/.test(this.value)) document.getElementById('colorPicker').value = this.value;
    });
})();
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
