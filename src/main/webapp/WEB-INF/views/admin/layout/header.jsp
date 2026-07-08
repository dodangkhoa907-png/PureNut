<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="uri" value="${requestScope['jakarta.servlet.forward.servlet_path']}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PureNut Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{
            --admin-bg:#F4F7FE;--admin-surface:#FFFFFF;
            --admin-sidebar:#0E2E5C;--admin-sidebar-2:#123A73;
            --admin-primary:#1B4F9E;--admin-primary-hover:#11335E;
            --admin-red:#CE2E2E;--admin-text:#2B3674;--admin-text-light:#A3AED0;
            --admin-border:#E0E5F2;
            --status-pending:#F5A524;--status-confirmed:#3965FF;--status-shipping:#7A5AF8;
            --status-done:#12B76A;--status-cancelled:#EE5D50;
            --fd:'Fraunces',serif;--fb:'Inter',sans-serif;
        }
        *{margin:0;padding:0;box-sizing:border-box;font-family:var(--fb)}
        body{background:var(--admin-bg);color:var(--admin-text);display:flex;min-height:100vh;-webkit-font-smoothing:antialiased}
        a{text-decoration:none}
        ::-webkit-scrollbar{width:8px;height:8px}::-webkit-scrollbar-thumb{background:#c9d3ec;border-radius:8px}

        /* ── Sidebar ── */
        .sidebar{width:264px;background:linear-gradient(180deg,var(--admin-sidebar) 0%,var(--admin-sidebar-2) 100%);color:#fff;display:flex;flex-direction:column;position:fixed;height:100vh;left:0;top:0;z-index:100;box-shadow:6px 0 24px -12px rgba(14,46,92,.4)}
        .sidebar-brand{padding:26px 26px 22px;font-family:var(--fd);font-size:22px;font-weight:700;display:flex;align-items:center;gap:12px;border-bottom:1px solid rgba(255,255,255,.1)}
        .sidebar-brand .logo-dot{width:38px;height:38px;border-radius:50%;background:var(--admin-red);display:flex;align-items:center;justify-content:center;flex:none;box-shadow:0 8px 18px -6px rgba(206,46,46,.6)}
        .sidebar-brand span{color:#fff}.sidebar-brand b{color:#FFD27A}
        .side-scroll{flex:1;overflow-y:auto;padding:16px 0}
        .menu-label{padding:14px 26px 8px;font-size:11px;font-weight:700;letter-spacing:.12em;text-transform:uppercase;color:rgba(255,255,255,.4)}
        .sidebar-menu{list-style:none}
        .sidebar-menu li{padding:0 14px;margin-bottom:3px}
        .sidebar-menu a{display:flex;align-items:center;padding:12px 16px;color:rgba(255,255,255,.72);font-weight:600;font-size:14.5px;gap:13px;border-radius:12px;transition:background .2s,color .2s}
        .sidebar-menu a i{width:20px;text-align:center;font-size:16px}
        .sidebar-menu a:hover{background:rgba(255,255,255,.08);color:#fff}
        .sidebar-menu a.active{background:#fff;color:var(--admin-primary);box-shadow:0 10px 22px -10px rgba(0,0,0,.4)}
        .sidebar-menu a.active i{color:var(--admin-primary)}
        .side-foot{padding:16px 20px;border-top:1px solid rgba(255,255,255,.1)}
        .side-foot a{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:12px;font-weight:600;font-size:14px;transition:background .2s}
        .side-foot a.store{color:#FFD27A}.side-foot a.store:hover{background:rgba(255,210,122,.14)}
        .side-foot a.logout{color:#FF9B93}.side-foot a.logout:hover{background:rgba(238,93,80,.16)}

        /* ── Main ── */
        .main-content{flex:1;margin-left:264px;padding:26px 30px 40px;display:flex;flex-direction:column;width:calc(100% - 264px);min-width:0}
        .admin-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:26px;background:var(--admin-surface);padding:16px 26px;border-radius:18px;box-shadow:0 8px 22px -14px rgba(43,54,116,.22)}
        .admin-header-title{font-family:var(--fd);font-size:22px;font-weight:700}
        .admin-header-title small{display:block;font-family:var(--fb);font-size:12.5px;font-weight:500;color:var(--admin-text-light);margin-top:2px}
        .admin-header-right{display:flex;align-items:center;gap:16px}
        .hdr-ic{width:44px;height:44px;border-radius:12px;background:var(--admin-bg);display:flex;align-items:center;justify-content:center;color:var(--admin-primary);font-size:17px;position:relative;transition:background .2s}
        .hdr-ic:hover{background:#E7EDFB}
        .hdr-ic .dot{position:absolute;top:9px;right:10px;width:8px;height:8px;border-radius:50%;background:var(--admin-red);border:2px solid var(--admin-surface)}
        .admin-user{display:flex;align-items:center;gap:12px;padding:6px 8px 6px 14px;background:var(--admin-bg);border-radius:14px}
        .admin-user .u-name{font-weight:700;font-size:14px;line-height:1.2}
        .admin-user .u-role{font-size:12px;color:var(--admin-text-light);font-weight:600}
        .admin-user img{width:40px;height:40px;border-radius:11px;object-fit:cover}

        /* ── Components (giữ nguyên tên class cho các trang khác) ── */
        .card{background:var(--admin-surface);border-radius:18px;padding:24px;box-shadow:0 8px 22px -16px rgba(43,54,116,.25);margin-bottom:24px}
        .btn{padding:11px 20px;border-radius:11px;font-weight:700;font-size:14px;cursor:pointer;border:none;transition:.2s;text-decoration:none;display:inline-flex;align-items:center;gap:8px}
        .btn-primary{background:var(--admin-primary);color:#fff;box-shadow:0 10px 22px -12px rgba(27,79,158,.7)}.btn-primary:hover{background:var(--admin-primary-hover);transform:translateY(-1px)}
        .btn-danger{background:var(--admin-red);color:#fff}
        .btn-outline{background:transparent;border:1.5px solid var(--admin-primary);color:var(--admin-primary)}.btn-outline:hover{background:var(--admin-primary);color:#fff}
        .table-responsive{overflow-x:auto}
        .admin-table{width:100%;border-collapse:collapse}
        .admin-table th,.admin-table td{padding:15px 16px;text-align:left;border-bottom:1px solid var(--admin-border)}
        .admin-table th{color:var(--admin-text-light);font-weight:600;font-size:12.5px;text-transform:uppercase;letter-spacing:.04em}
        .admin-table td{font-weight:500;font-size:14.5px}
        .admin-table tbody tr{transition:background .15s}.admin-table tbody tr:hover{background:#FaFbFF}
        .badge{padding:6px 13px;border-radius:30px;font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:.03em;display:inline-block}
        .badge-PENDING{background:rgba(245,165,36,.12);color:var(--status-pending)}
        .badge-CONFIRMED{background:rgba(57,101,255,.12);color:var(--status-confirmed)}
        .badge-SHIPPING{background:rgba(122,90,248,.12);color:var(--status-shipping)}
        .badge-DONE{background:rgba(18,183,106,.12);color:var(--status-done)}
        .badge-CANCELLED{background:rgba(238,93,80,.12);color:var(--status-cancelled)}
        .badge-NEW{background:rgba(245,165,36,.12);color:var(--status-pending)}
        .badge-CONTACTED{background:rgba(57,101,255,.12);color:var(--status-confirmed)}
        .form-group{margin-bottom:20px}
        .form-group label{display:block;margin-bottom:8px;font-weight:700;font-size:13.5px}
        .form-control{width:100%;padding:12px 16px;border:1.5px solid var(--admin-border);border-radius:11px;font-size:15px;color:var(--admin-text);transition:.2s}
        .form-control:focus{border-color:var(--admin-primary);outline:none;box-shadow:0 0 0 4px rgba(27,79,158,.1)}

        @media(max-width:900px){
            .sidebar{transform:translateX(-100%);transition:transform .3s}
            .sidebar.open{transform:none}
            .main-content{margin-left:0;width:100%}
        }
    </style>
</head>
<body>
    <aside class="sidebar" id="adminSidebar">
        <div class="sidebar-brand">
            <span class="logo-dot"><svg width="20" height="20" viewBox="0 0 34 34"><path d="M10 19c0-4 3-7.5 7-7.5s7 3.5 7 7.5-3 6.5-7 6.5-7-2.5-7-6.5z" fill="none" stroke="#fff" stroke-width="1.8"/></svg></span>
            <span>Pure<b>Nut</b> · Admin</span>
        </div>
        <div class="side-scroll">
            <div class="menu-label">Tổng quan</div>
            <ul class="sidebar-menu">
                <li><a href="${ctx}/admin" class="${uri.endsWith('/admin') or uri.contains('dashboard') ? 'active' : ''}"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
            </ul>
            <div class="menu-label">Vận hành</div>
            <ul class="sidebar-menu">
                <li><a href="${ctx}/admin/don-hang" class="${uri.contains('/don-hang') ? 'active' : ''}"><i class="fa-solid fa-cart-shopping"></i> Quản lý Đơn hàng</a></li>
                <li><a href="${ctx}/admin/san-pham" class="${uri.contains('/san-pham') ? 'active' : ''}"><i class="fa-solid fa-box"></i> Quản lý Sản phẩm</a></li>
            </ul>
            <div class="menu-label">Hệ thống</div>
            <ul class="sidebar-menu">
                <li><a href="${ctx}/admin/nhat-ky" class="${uri.contains('/nhat-ky') ? 'active' : ''}"><i class="fa-solid fa-clock-rotate-left"></i> Nhật ký hoạt động</a></li>
                <li><a href="${ctx}/admin/settings" class="${uri.contains('/settings') ? 'active' : ''}"><i class="fa-solid fa-gear"></i> Cài đặt &amp; Bảo mật</a></li>
            </ul>
        </div>
        <div class="side-foot">
            <a href="${ctx}/" class="store"><i class="fa-solid fa-store"></i> Xem cửa hàng</a>
            <a href="${ctx}/admin/logout" class="logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="admin-header">
            <div class="admin-header-title">
                ${pageTitle != null ? pageTitle : 'Dashboard'}
                <small>Chào mừng trở lại, ${sessionScope.user.fullName}!</small>
            </div>
            <div class="admin-header-right">
                <a href="${ctx}/admin/dai-ly" class="hdr-ic" title="Thông báo"><i class="fa-regular fa-bell"></i><span class="dot"></span></a>
                <a href="${ctx}/admin/settings" class="hdr-ic" title="Cài đặt"><i class="fa-solid fa-gear"></i></a>
                <div class="admin-user">
                    <div>
                        <div class="u-name">${sessionScope.user.fullName}</div>
                        <div class="u-role">Quản trị viên</div>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=1B4F9E&color=fff&bold=true" alt="Avatar">
                </div>
            </div>
        </header>
