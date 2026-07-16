    </main>

<div class="admin-toast" id="adminToast"></div>

<script>
(function(){
    var CTX = document.querySelector('meta[name="ctx"]');
    var ctx = CTX ? CTX.content : '';
    if (!ctx) {
        var scripts = document.querySelectorAll('script');
        for (var i = 0; i < scripts.length; i++) {
            var m = (scripts[i].textContent || '').match(/window\.CTX\s*=\s*['"]([^'"]*)['"]/);
            if (m) { ctx = m[1]; break; }
        }
    }
    if (!ctx) {
        var p = location.pathname;
        var idx = p.indexOf('/admin');
        if (idx > 0) ctx = p.substring(0, idx);
    }

    var bell = document.getElementById('notiBell');
    var dd = document.getElementById('notiDropdown');
    var badge = document.getElementById('notiBadge');
    var list = document.getElementById('notiList');
    var empty = document.getElementById('notiEmpty');
    var clearBtn = document.getElementById('notiClear');
    var toastBox = document.getElementById('adminToast');
    var count = 0;
    var notifications = [];

    // Toggle dropdown
    bell.addEventListener('click', function(e) {
        e.stopPropagation();
        dd.classList.toggle('open');
        if (dd.classList.contains('open')) {
            count = 0;
            badge.textContent = '0';
            badge.classList.remove('show');
            var items = list.querySelectorAll('.noti-item.unread');
            for (var i = 0; i < items.length; i++) items[i].classList.remove('unread');
        }
    });
    document.addEventListener('click', function(e) {
        if (!dd.contains(e.target) && e.target !== bell) dd.classList.remove('open');
    });

    // Clear all
    clearBtn.addEventListener('click', function() {
        notifications = [];
        list.innerHTML = '';
        list.appendChild(empty);
        empty.style.display = '';
        count = 0;
        badge.textContent = '0';
        badge.classList.remove('show');
    });

    function fmtMoney(n) {
        return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.') + 'đ';
    }

    function timeAgo(ts) {
        var diff = Math.floor((Date.now() - ts) / 1000);
        if (diff < 60) return 'Vừa xong';
        if (diff < 3600) return Math.floor(diff / 60) + ' phút trước';
        if (diff < 86400) return Math.floor(diff / 3600) + ' giờ trước';
        return Math.floor(diff / 86400) + ' ngày trước';
    }

    function addNotification(data) {
        empty.style.display = 'none';
        count++;
        badge.textContent = count > 9 ? '9+' : count;
        badge.classList.add('show');

        var item = document.createElement('a');
        item.className = 'noti-item unread';
        item.href = ctx + '/admin/don-hang/chi-tiet?id=' + data.orderId;
        item.innerHTML =
            '<div class="noti-ic"><i class="fa-solid fa-cart-shopping"></i></div>' +
            '<div class="noti-body">' +
                '<div class="noti-text"><strong>Đơn hàng mới #' + data.orderId + '</strong></div>' +
                '<div class="noti-text" style="font-weight:500;font-size:12.5px">' + data.customer + ' · ' + fmtMoney(data.total) + '</div>' +
                '<div class="noti-time">' + (data.payment === 'COD' ? 'Thanh toán khi nhận' : 'Chuyển khoản') + ' · ' + timeAgo(data.time) + '</div>' +
            '</div>';
        list.insertBefore(item, list.firstChild);

        notifications.unshift(data);
        if (notifications.length > 20) {
            notifications.pop();
            if (list.lastElementChild && list.lastElementChild.classList.contains('noti-item')) {
                list.removeChild(list.lastElementChild);
            }
        }
    }

    function showToast(data) {
        var t = document.createElement('div');
        t.className = 'admin-toast-item';
        t.innerHTML =
            '<div class="toast-ic"><i class="fa-solid fa-cart-shopping"></i></div>' +
            '<div class="toast-body">' +
                '<div class="toast-title">Đơn hàng mới #' + data.orderId + '</div>' +
                '<div class="toast-desc">' + data.customer + ' đã đặt ' + fmtMoney(data.total) + '</div>' +
            '</div>' +
            '<button class="toast-close" onclick="this.parentNode.classList.add(\'out\')">&times;</button>';
        toastBox.appendChild(t);

        t.addEventListener('click', function(e) {
            if (e.target.tagName !== 'BUTTON') {
                location.href = ctx + '/admin/don-hang/chi-tiet?id=' + data.orderId;
            }
        });

        setTimeout(function() {
            t.classList.add('out');
            setTimeout(function() { if (t.parentNode) t.parentNode.removeChild(t); }, 300);
        }, 6000);

        // Play sound
        try {
            var ac = new (window.AudioContext || window.webkitAudioContext)();
            var osc = ac.createOscillator();
            var gain = ac.createGain();
            osc.connect(gain);
            gain.connect(ac.destination);
            osc.frequency.value = 880;
            osc.type = 'sine';
            gain.gain.setValueAtTime(0.15, ac.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ac.currentTime + 0.5);
            osc.start(ac.currentTime);
            osc.stop(ac.currentTime + 0.5);
        } catch(e) {}
    }

    // SSE Connection
    var evtSource;

    function getShipperMsg(data) {
        var action = "";
        var icon = "fa-truck-fast";
        var colorClass = "";
        switch (data.status) {
            case "PICKING_UP":
                action = "đang nhận bàn giao";
                icon = "fa-boxes-stacked";
                colorClass = "orange";
                break;
            case "DELIVERING":
                action = "đang đi giao";
                icon = "fa-truck-ramp-box";
                colorClass = "blue";
                break;
            case "COMPLETED":
                action = "đã giao thành công ✓";
                icon = "fa-circle-check";
                colorClass = "green";
                break;
            case "FAILED":
                action = "báo giao thất bại ✗";
                icon = "fa-circle-xmark";
                colorClass = "red";
                break;
            default:
                action = "cập nhật trạng thái " + data.status;
        }
        return { msg: "Shipper <strong>" + data.shipper + "</strong> " + action + " đơn <strong>#" + data.orderId + "</strong>", icon: icon, color: colorClass };
    }

    function addShipperNotification(data) {
        empty.style.display = 'none';
        count++;
        badge.textContent = count > 9 ? '9+' : count;
        badge.classList.add('show');

        var info = getShipperMsg(data);
        var item = document.createElement('a');
        item.className = 'noti-item unread';
        item.href = ctx + '/admin/don-hang/chi-tiet?id=' + data.orderId;
        item.innerHTML =
            '<div class="noti-ic ' + info.color + '"><i class="fa-solid ' + info.icon + '"></i></div>' +
            '<div class="noti-body">' +
                '<div class="noti-text">' + info.msg + '</div>' +
                '<div class="noti-text" style="font-weight:500;font-size:12.5px">Khách hàng: ' + data.customer + '</div>' +
                '<div class="noti-time">' + timeAgo(data.time) + '</div>' +
            '</div>';
        list.insertBefore(item, list.firstChild);

        notifications.unshift(data);
        if (notifications.length > 20) {
            notifications.pop();
            if (list.lastElementChild && list.lastElementChild.classList.contains('noti-item')) {
                list.removeChild(list.lastElementChild);
            }
        }
    }

    function showShipperToast(data) {
        var info = getShipperMsg(data);
        var t = document.createElement('div');
        t.className = 'admin-toast-item';
        t.innerHTML =
            '<div class="toast-ic ' + info.color + '"><i class="fa-solid ' + info.icon + '"></i></div>' +
            '<div class="toast-body">' +
                '<div class="toast-title">Cập nhật vận chuyển</div>' +
                '<div class="toast-desc">' + info.msg + '</div>' +
            '</div>' +
            '<button class="toast-close" onclick="this.parentNode.classList.add(\'out\')">&times;</button>';
        toastBox.appendChild(t);

        t.addEventListener('click', function(e) {
            if (e.target.tagName !== 'BUTTON') {
                location.href = ctx + '/admin/don-hang/chi-tiet?id=' + data.orderId;
            }
        });

        setTimeout(function() {
            t.classList.add('out');
            setTimeout(function() { if (t.parentNode) t.parentNode.removeChild(t); }, 300);
        }, 6000);

        try {
            var ac = new (window.AudioContext || window.webkitAudioContext)();
            var osc = ac.createOscillator();
            var gain = ac.createGain();
            osc.connect(gain);
            gain.connect(ac.destination);
            osc.frequency.value = 660;
            osc.type = 'sine';
            gain.gain.setValueAtTime(0.15, ac.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ac.currentTime + 0.5);
            osc.start(ac.currentTime);
            osc.stop(ac.currentTime + 0.5);
        } catch(e) {}
    }

    function connectSSE() {
        if (evtSource) { try { evtSource.close(); } catch(e) {} }
        evtSource = new EventSource(ctx + '/admin/notifications/stream');

        evtSource.addEventListener('new-order', function(e) {
            try {
                var data = JSON.parse(e.data);
                addNotification(data);
                showToast(data);
            } catch(err) { console.error('SSE parse error', err); }
        });

        evtSource.addEventListener('shipper-update', function(e) {
            try {
                var data = JSON.parse(e.data);
                addShipperNotification(data);
                showShipperToast(data);
                // Tự động tải lại trang sau 1.5s nếu admin đang ở trang điều phối hoặc quản lý đơn để cập nhật số liệu
                var p = window.location.pathname;
                if (p.indexOf('/admin/dieu-phoi') !== -1 || p.indexOf('/admin/don-hang') !== -1) {
                    setTimeout(function() {
                        window.location.reload();
                    }, 1500);
                }
            } catch(err) { console.error('SSE parse error', err); }
        });

        evtSource.addEventListener('connected', function() {
            console.log('[PureNut] Notification stream connected');
        });

        evtSource.onerror = function() {
            evtSource.close();
            setTimeout(connectSSE, 5000);
        };
    }

    connectSSE();

    // Cleanup on page unload
    window.addEventListener('beforeunload', function() {
        if (evtSource) evtSource.close();
    });
})();
</script>
</body>
</html>
