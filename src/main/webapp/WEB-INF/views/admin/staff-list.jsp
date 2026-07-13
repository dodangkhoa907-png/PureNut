<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

<style>
/* ── Stats row ── */
.hr-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:28px}
.hr-stat{background:var(--admin-surface);border-radius:16px;padding:22px;text-align:center;border:1px solid var(--admin-border);box-shadow:0 6px 18px -10px rgba(43,54,116,.15);transition:transform .2s}
.hr-stat:hover{transform:translateY(-2px)}
.hr-stat b{display:block;font-family:var(--fd);font-size:32px;margin-bottom:4px}
.hr-stat span{font-size:12px;color:var(--admin-text-light);font-weight:600}

/* ── Staff grid ── */
.staff-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:18px;margin-bottom:28px}
.staff-card{background:var(--admin-surface);border-radius:18px;padding:22px;border:1.5px solid var(--admin-border);position:relative;overflow:hidden;transition:transform .25s,box-shadow .25s}
.staff-card:hover{transform:translateY(-3px);box-shadow:0 16px 36px -12px rgba(43,54,116,.18)}
.staff-card.revoked{opacity:.55}

/* Status indicator */
.sf-status-dot{position:absolute;top:18px;right:18px;width:12px;height:12px;border-radius:50%;border:2.5px solid var(--admin-surface)}
.sf-status-dot.online{background:var(--status-done);box-shadow:0 0 0 3px rgba(18,183,106,.2)}
.sf-status-dot.offline{background:var(--admin-text-light)}

/* Header section */
.sf-header{display:flex;align-items:center;gap:16px;margin-bottom:16px}
.sf-avatar{width:56px;height:56px;border-radius:16px;background:linear-gradient(135deg,var(--admin-primary),var(--status-shipping));color:#fff;display:flex;align-items:center;justify-content:center;font-family:var(--fd);font-size:22px;font-weight:700;flex-shrink:0}
.sf-info{flex:1;min-width:0}
.sf-name{font-weight:800;font-size:16px;color:var(--admin-text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.sf-role{font-size:12px;font-weight:700;margin-top:2px}
.sf-role.shipper{color:var(--status-shipping)}
.sf-role.revoked{color:var(--admin-red)}

/* Contact details */
.sf-contacts{display:flex;flex-direction:column;gap:6px;margin-bottom:14px}
.sf-contact{display:flex;align-items:center;gap:8px;font-size:13px;color:var(--admin-text)}
.sf-contact i{width:16px;text-align:center;font-size:12px;color:var(--admin-text-light)}
.sf-contact span{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}

/* Workload metrics */
.sf-metrics{display:flex;gap:8px;margin-bottom:14px}
.sf-metric{flex:1;text-align:center;padding:10px 6px;background:var(--admin-bg);border-radius:10px}
.sf-metric b{display:block;font-family:var(--fd);font-size:20px;color:var(--admin-text)}
.sf-metric small{font-size:10px;color:var(--admin-text-light);font-weight:600}

/* Vehicle / IP */
.sf-extra{font-size:12px;color:var(--admin-text-light);display:flex;flex-wrap:wrap;gap:10px;margin-bottom:14px}
.sf-extra-item{display:flex;align-items:center;gap:4px}
.sf-extra-item i{font-size:10px}

/* Last login */
.sf-login{font-size:11.5px;color:var(--admin-text-light);margin-bottom:14px;display:flex;align-items:center;gap:6px}
.sf-login i{font-size:10px}

/* Action buttons */
.sf-actions{display:flex;gap:8px;flex-wrap:wrap;padding-top:14px;border-top:1px dashed var(--admin-border)}
.sf-btn{padding:8px 14px;border-radius:10px;font-weight:700;font-size:12px;border:none;cursor:pointer;transition:transform .15s,box-shadow .2s;display:inline-flex;align-items:center;gap:5px}
.sf-btn:active{transform:scale(.95)}
.sf-btn.edit{background:rgba(57,101,255,.1);color:var(--admin-primary)}
.sf-btn.edit:hover{background:rgba(57,101,255,.18)}
.sf-btn.pwd{background:rgba(122,90,248,.1);color:var(--status-shipping)}
.sf-btn.pwd:hover{background:rgba(122,90,248,.18)}
.sf-btn.dispatch{background:rgba(18,183,106,.1);color:var(--status-done)}
.sf-btn.dispatch:hover{background:rgba(18,183,106,.18)}
.sf-btn.revoke{background:rgba(238,93,80,.08);color:var(--admin-red)}
.sf-btn.revoke:hover{background:rgba(238,93,80,.16)}
.sf-btn.restore{background:rgba(18,183,106,.08);color:var(--status-done)}
.sf-btn.restore:hover{background:rgba(18,183,106,.16)}

/* ── Create form card ── */
.create-card{background:var(--admin-surface);border-radius:18px;padding:24px;margin-bottom:28px;border:1.5px dashed var(--admin-primary);box-shadow:0 6px 18px -10px rgba(43,54,116,.12)}
.create-card .card-title{font-family:var(--fd);font-size:17px;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:10px}
.create-card .card-title i{color:var(--admin-primary)}
.create-form{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px;align-items:end}
.create-form label{font-size:12px;font-weight:700;display:block;margin-bottom:5px;color:var(--admin-text)}
.create-form .required::after{content:' *';color:var(--admin-red)}

/* ── Modal ── */
.modal-overlay{position:fixed;inset:0;z-index:200;background:rgba(14,46,92,.55);backdrop-filter:blur(4px);display:none;align-items:center;justify-content:center;padding:18px}
.modal-overlay.open{display:flex}
.modal-panel{background:var(--admin-surface);border-radius:20px;width:100%;max-width:480px;box-shadow:0 30px 70px -16px rgba(14,46,92,.4);animation:modalIn .3s ease}
@keyframes modalIn{from{opacity:0;transform:translateY(20px) scale(.96)}to{opacity:1;transform:none}}
.modal-hd{display:flex;align-items:center;justify-content:space-between;padding:20px 24px;border-bottom:1px solid var(--admin-border)}
.modal-hd b{font-family:var(--fd);font-size:17px}
.modal-close{width:32px;height:32px;border-radius:10px;background:var(--admin-bg);border:none;cursor:pointer;font-size:16px;display:flex;align-items:center;justify-content:center;color:var(--admin-text-light);transition:background .2s}
.modal-close:hover{background:rgba(238,93,80,.1);color:var(--admin-red)}
.modal-body{padding:24px}
.modal-body .form-group{margin-bottom:16px}
.modal-body .form-group label{display:block;font-size:12.5px;font-weight:700;margin-bottom:6px;color:var(--admin-text)}
.modal-footer{padding:16px 24px;border-top:1px solid var(--admin-border);display:flex;gap:10px;justify-content:flex-end}
.modal-btn{padding:10px 20px;border-radius:11px;font-weight:700;font-size:13px;border:none;cursor:pointer;transition:transform .15s}
.modal-btn.cancel{background:var(--admin-bg);color:var(--admin-text-light)}
.modal-btn.save{background:var(--admin-primary);color:#fff;box-shadow:0 6px 14px -6px rgba(27,79,158,.5)}
.modal-btn.save:hover{transform:translateY(-1px)}

/* ── Toast ── */
.staff-toast{position:fixed;top:20px;right:20px;z-index:300;padding:14px 22px;border-radius:14px;background:var(--status-done);color:#fff;font-weight:700;font-size:14px;box-shadow:0 12px 30px -8px rgba(18,183,106,.5);transform:translateX(120%);transition:transform .35s cubic-bezier(.22,1,.36,1);display:flex;align-items:center;gap:8px}
.staff-toast.show{transform:none}
.staff-toast.error{background:var(--admin-red);box-shadow:0 12px 30px -8px rgba(206,46,46,.5)}

/* ── Alerts ── */
.hr-alert{padding:12px 18px;border-radius:12px;margin-bottom:20px;font-size:13.5px;font-weight:600;display:flex;align-items:center;gap:8px}
.hr-alert.ok{background:rgba(18,183,106,.08);color:var(--status-done)}
.hr-alert.err{background:rgba(238,93,80,.08);color:var(--admin-red)}

@media(max-width:900px){
  .hr-stats{grid-template-columns:1fr 1fr;gap:10px}
  .staff-grid{grid-template-columns:1fr}
}
</style>

<c:if test="${not empty param.success}">
  <div class="hr-alert ok"><i class="fa-solid fa-circle-check"></i>
    ${param.success == 'created' ? 'Tạo tài khoản nhân viên thành công!' : 'Cập nhật thành công!'}
  </div>
</c:if>
<c:if test="${not empty param.error}">
  <div class="hr-alert err"><i class="fa-solid fa-triangle-exclamation"></i>
    <c:choose>
      <c:when test="${param.error == 'EmailExists'}">Email đã tồn tại trong hệ thống.</c:when>
      <c:when test="${param.error == 'BadInput'}">Dữ liệu không hợp lệ — kiểm tra email và mật khẩu ≥ 8 ký tự.</c:when>
      <c:otherwise>Không thực hiện được, vui lòng thử lại.</c:otherwise>
    </c:choose>
  </div>
</c:if>

<!-- Stats -->
<c:set var="totalStaff" value="${fn:length(staffList)}"/>
<c:set var="onlineStaff" value="0"/>
<c:set var="totalShipping" value="0"/>
<c:set var="totalDone" value="0"/>
<c:forEach var="u" items="${staffList}">
  <c:set var="sp" value="${profileMap[u.userId]}"/>
  <c:if test="${not empty sp && sp.status == 'ACTIVE'}"><c:set var="onlineStaff" value="${onlineStaff + 1}"/></c:if>
  <c:set var="sc" value="${shippingCount[u.userId]}"/>
  <c:if test="${not empty sc}"><c:set var="totalShipping" value="${totalShipping + sc}"/></c:if>
  <c:set var="dc" value="${doneCount[u.userId]}"/>
  <c:if test="${not empty dc}"><c:set var="totalDone" value="${totalDone + dc}"/></c:if>
</c:forEach>

<div class="hr-stats">
  <div class="hr-stat"><b style="color:var(--admin-primary)">${totalStaff}</b><span>Tổng nhân viên</span></div>
  <div class="hr-stat"><b style="color:var(--status-done)">${onlineStaff}</b><span>Đang online</span></div>
  <div class="hr-stat"><b style="color:var(--status-shipping)">${totalShipping}</b><span>Đơn đang giao</span></div>
  <div class="hr-stat"><b style="color:var(--status-done)">${totalDone}</b><span>Đã hoàn thành</span></div>
</div>

<!-- Create new staff -->
<div class="create-card">
  <div class="card-title"><i class="fa-solid fa-user-plus"></i> Tạo tài khoản nhân viên mới</div>
  <form action="${pageContext.request.contextPath}/admin/nhan-su/tao" method="POST" class="create-form">
    <input type="hidden" name="_csrf" value="${sessionScope._csrf}">
    <div>
      <label class="required">Họ tên</label>
      <input class="form-control" type="text" name="fullName" required maxlength="150" placeholder="Nguyễn Văn B">
    </div>
    <div>
      <label class="required">Email</label>
      <input class="form-control" type="email" name="email" required maxlength="150" placeholder="shipper@purenut.vn">
    </div>
    <div>
      <label>Số điện thoại</label>
      <input class="form-control" type="tel" name="phone" maxlength="11" placeholder="09xx xxx xxx">
    </div>
    <div>
      <label class="required">Mật khẩu (≥ 8 ký tự)</label>
      <input class="form-control" type="text" name="password" required minlength="8" maxlength="72" placeholder="Mật khẩu tạm">
    </div>
    <div>
      <label class="required">Vai trò</label>
      <select class="form-control" name="role" required>
        <option value="SHIPPER">Shipper (giao hàng)</option>
      </select>
    </div>
    <button type="submit" class="btn btn-primary" style="padding:11px 20px;white-space:nowrap">
      <i class="fa-solid fa-plus"></i> Tạo tài khoản
    </button>
  </form>
</div>

<!-- Staff cards -->
<div style="font-family:var(--fd);font-size:18px;font-weight:700;margin-bottom:16px;display:flex;align-items:center;gap:10px">
  <i class="fa-solid fa-users" style="color:var(--admin-primary)"></i> Đội ngũ nhân viên
  <span style="font-size:12px;font-weight:500;color:var(--admin-text-light);margin-left:auto">${totalStaff} người</span>
</div>

<div class="staff-grid">
  <c:forEach var="u" items="${staffList}">
    <c:set var="sp" value="${profileMap[u.userId]}"/>
    <c:set var="isOnline" value="${not empty sp && sp.status == 'ACTIVE'}"/>
    <c:set var="sc" value="${shippingCount[u.userId]}"/>
    <c:set var="dc" value="${doneCount[u.userId]}"/>
    <div class="staff-card" id="staff${u.userId}">
      <div class="sf-status-dot ${isOnline ? 'online' : 'offline'}"></div>
      <div class="sf-header">
        <div class="sf-avatar">${fn:substring(u.fullName, 0, 1)}</div>
        <div class="sf-info">
          <div class="sf-name"><c:out value="${u.fullName}"/></div>
          <div class="sf-role shipper"><i class="fa-solid fa-motorcycle" style="font-size:10px"></i> Shipper · ${isOnline ? 'Online' : 'Offline'}</div>
        </div>
      </div>

      <div class="sf-contacts">
        <div class="sf-contact"><i class="fa-solid fa-envelope"></i><span><c:out value="${u.email}"/></span></div>
        <div class="sf-contact"><i class="fa-solid fa-phone"></i><span><c:out value="${empty u.phone ? 'Chưa cập nhật' : u.phone}"/></span></div>
      </div>

      <div class="sf-metrics">
        <div class="sf-metric"><b style="color:var(--status-shipping)">${empty sc ? 0 : sc}</b><small>Đang giao</small></div>
        <div class="sf-metric"><b style="color:var(--status-done)">${empty dc ? 0 : dc}</b><small>Hoàn thành</small></div>
        <div class="sf-metric">
          <b style="color:var(--admin-primary)">${(empty sc ? 0 : sc) + (empty dc ? 0 : dc)}</b>
          <small>Tổng đơn</small>
        </div>
      </div>

      <c:if test="${not empty sp}">
        <div class="sf-extra">
          <c:if test="${not empty sp.vehiclePlate}">
            <span class="sf-extra-item"><i class="fa-solid fa-motorcycle"></i> <c:out value="${sp.vehiclePlate}"/></span>
          </c:if>
          <c:if test="${not empty sp.allowedIp}">
            <span class="sf-extra-item"><i class="fa-solid fa-shield-halved"></i> IP: <c:out value="${sp.allowedIp}"/></span>
          </c:if>
        </div>
      </c:if>

      <div class="sf-login">
        <i class="fa-solid fa-clock-rotate-left"></i>
        <c:choose>
          <c:when test="${not empty u.lastLoginAt}">Đăng nhập: <fmt:formatDate value="${u.lastLoginAt}" pattern="HH:mm dd/MM/yyyy"/></c:when>
          <c:otherwise>Chưa đăng nhập lần nào</c:otherwise>
        </c:choose>
      </div>

      <div class="sf-actions">
        <button class="sf-btn edit" onclick="openEdit(${u.userId},'${fn:escapeXml(u.fullName)}','${fn:escapeXml(u.phone)}')">
          <i class="fa-solid fa-pen"></i> Sửa
        </button>
        <button class="sf-btn pwd" onclick="openPwd(${u.userId},'${fn:escapeXml(u.fullName)}')">
          <i class="fa-solid fa-key"></i> Đổi MK
        </button>
        <a class="sf-btn dispatch" href="${pageContext.request.contextPath}/admin/dieu-phoi">
          <i class="fa-solid fa-truck-fast"></i> Điều phối
        </a>
        <button class="sf-btn revoke" onclick="toggleRole(${u.userId},'CUSTOMER')">
          <i class="fa-solid fa-user-slash"></i> Thu hồi
        </button>
      </div>
    </div>
  </c:forEach>
</div>

<c:if test="${empty staffList}">
  <div class="card" style="text-align:center;padding:50px 20px;color:var(--admin-text-light)">
    <i class="fa-solid fa-user-plus" style="font-size:36px;opacity:.3;margin-bottom:12px;display:block"></i>
    <p style="font-size:15px;font-weight:600">Chưa có nhân viên nào — tạo tài khoản đầu tiên ở form phía trên.</p>
  </div>
</c:if>

<!-- Edit Profile Modal -->
<div class="modal-overlay" id="editModal">
  <div class="modal-panel">
    <div class="modal-hd">
      <b><i class="fa-solid fa-pen" style="color:var(--admin-primary);margin-right:8px"></i>Chỉnh sửa thông tin</b>
      <button class="modal-close" onclick="closeModal('editModal')">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="editUserId">
      <div class="form-group">
        <label>Họ tên</label>
        <input class="form-control" type="text" id="editName" maxlength="150">
      </div>
      <div class="form-group">
        <label>Số điện thoại</label>
        <input class="form-control" type="tel" id="editPhone" maxlength="11">
      </div>
    </div>
    <div class="modal-footer">
      <button class="modal-btn cancel" onclick="closeModal('editModal')">Hủy</button>
      <button class="modal-btn save" onclick="saveEdit()"><i class="fa-solid fa-check" style="margin-right:4px"></i>Lưu thay đổi</button>
    </div>
  </div>
</div>

<!-- Reset Password Modal -->
<div class="modal-overlay" id="pwdModal">
  <div class="modal-panel">
    <div class="modal-hd">
      <b><i class="fa-solid fa-key" style="color:var(--status-shipping);margin-right:8px"></i>Đổi mật khẩu</b>
      <button class="modal-close" onclick="closeModal('pwdModal')">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="pwdUserId">
      <p style="font-size:13px;color:var(--admin-text-light);margin-bottom:16px">
        Đổi mật khẩu cho: <strong id="pwdUserName" style="color:var(--admin-text)"></strong>
      </p>
      <div class="form-group">
        <label>Mật khẩu mới (≥ 8 ký tự)</label>
        <input class="form-control" type="text" id="newPwd" minlength="8" maxlength="72" placeholder="Nhập mật khẩu mới">
      </div>
    </div>
    <div class="modal-footer">
      <button class="modal-btn cancel" onclick="closeModal('pwdModal')">Hủy</button>
      <button class="modal-btn save" onclick="savePwd()"><i class="fa-solid fa-check" style="margin-right:4px"></i>Đổi mật khẩu</button>
    </div>
  </div>
</div>

<!-- Toast -->
<div class="staff-toast" id="staffToast"><i class="fa-solid fa-circle-check"></i><span id="toastMsg"></span></div>

<script>
var CTX='${pageContext.request.contextPath}',CSRF='${sessionScope._csrf}';

function ajax(url,data,cb){
  var opt={headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded'},method:'POST'};
  var p=new URLSearchParams();p.append('_csrf',CSRF);
  for(var k in data)p.append(k,data[k]);
  opt.body=p;
  fetch(CTX+url,opt).then(function(r){return r.json()}).then(cb).catch(function(){toast('Lỗi kết nối',true)});
}

function toast(msg,isErr){
  var t=document.getElementById('staffToast'),m=document.getElementById('toastMsg');
  m.textContent=msg;
  t.className='staff-toast show'+(isErr?' error':'');
  setTimeout(function(){t.classList.remove('show')},3000);
}

function openModal(id){document.getElementById(id).classList.add('open');document.body.style.overflow='hidden'}
function closeModal(id){document.getElementById(id).classList.remove('open');document.body.style.overflow=''}

window.openEdit=function(uid,name,phone){
  document.getElementById('editUserId').value=uid;
  document.getElementById('editName').value=name;
  document.getElementById('editPhone').value=phone||'';
  openModal('editModal');
};

window.saveEdit=function(){
  var uid=document.getElementById('editUserId').value;
  var name=document.getElementById('editName').value.trim();
  var phone=document.getElementById('editPhone').value.trim();
  if(!name){toast('Họ tên không được trống',true);return}
  ajax('/admin/nhan-su/cap-nhat',{userId:uid,fullName:name,phone:phone},function(d){
    if(d.ok){closeModal('editModal');toast('Cập nhật thành công');setTimeout(function(){location.reload()},800)}
    else toast(d.msg||'Không cập nhật được',true);
  });
};

window.openPwd=function(uid,name){
  document.getElementById('pwdUserId').value=uid;
  document.getElementById('pwdUserName').textContent=name;
  document.getElementById('newPwd').value='';
  openModal('pwdModal');
};

window.savePwd=function(){
  var uid=document.getElementById('pwdUserId').value;
  var pwd=document.getElementById('newPwd').value;
  if(!pwd||pwd.length<8){toast('Mật khẩu phải >= 8 ký tự',true);return}
  ajax('/admin/nhan-su/doi-mat-khau',{userId:uid,newPassword:pwd},function(d){
    if(d.ok){closeModal('pwdModal');toast('Đổi mật khẩu thành công')}
    else toast(d.msg||'Không đổi được',true);
  });
};

window.toggleRole=function(uid,role){
  var msg=role==='CUSTOMER'?'Thu hồi quyền shipper của nhân viên này?':'Khôi phục quyền shipper?';
  if(!confirm(msg))return;
  ajax('/admin/nhan-su/doi-role',{userId:uid,role:role},function(d){
    if(d.ok){toast(role==='CUSTOMER'?'Đã thu hồi quyền':'Đã khôi phục');setTimeout(function(){location.reload()},800)}
    else toast(d.msg||'Không thực hiện được',true);
  });
};

document.querySelectorAll('.modal-overlay').forEach(function(o){
  o.addEventListener('click',function(e){if(e.target===this)closeModal(this.id)});
});
document.addEventListener('keydown',function(e){
  if(e.key==='Escape'){closeModal('editModal');closeModal('pwdModal')}
});
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
