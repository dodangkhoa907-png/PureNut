document.addEventListener('DOMContentLoaded', () => {
    // 1. Reveal Animation on Scroll
    const revealElements = document.querySelectorAll('[data-reveal]');
    const revealObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if(entry.isIntersecting){
                entry.target.classList.add('in-view');
                observer.unobserve(entry.target); // only reveal once
            }
        });
    }, {
        root: null,
        threshold: 0.1,
        rootMargin: "0px 0px -50px 0px"
    });

    revealElements.forEach(el => revealObserver.observe(el));

    // 2. Navbar Scroll Effect & Mobile Menu
    const navbar = document.getElementById('navbar');
    const navToggle = document.getElementById('navToggle');
    const navLinks = document.getElementById('navLinks');

    window.addEventListener('scroll', () => {
        if(window.scrollY > 50){
            navbar.classList.add('is-scrolled');
        } else {
            navbar.classList.remove('is-scrolled');
        }
    });

    if (navToggle) {
        navToggle.addEventListener('click', () => {
            const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
            navToggle.setAttribute('aria-expanded', !isExpanded);
            navLinks.classList.toggle('is-open');
        });
    }

    // Close mobile menu when clicking a link
    const links = document.querySelectorAll('[data-nav]');
    links.forEach(link => {
        link.addEventListener('click', () => {
            if(navLinks.classList.contains('is-open')){
                navToggle.setAttribute('aria-expanded', 'false');
                navLinks.classList.remove('is-open');
            }
        });
    });

    // 3. Countdown Timer (for Promo section)
    const cdHours = document.getElementById('cd-hours');
    const cdMins = document.getElementById('cd-mins');
    const cdSecs = document.getElementById('cd-secs');

    if (cdHours && cdMins && cdSecs) {
        let time = 8 * 3600 + 45 * 60 + 12; // 08:45:12 in seconds
        setInterval(() => {
            if(time > 0) time--;
            
            const h = Math.floor(time / 3600);
            const m = Math.floor((time % 3600) / 60);
            const s = time % 60;
            
            cdHours.textContent = h.toString().padStart(2, '0');
            cdMins.textContent = m.toString().padStart(2, '0');
            cdSecs.textContent = s.toString().padStart(2, '0');
        }, 1000);
    }
    
    // 4. Ticket Copy Code
    const btnCopy = document.getElementById('btnCopy');
    if (btnCopy) {
        btnCopy.addEventListener('click', () => {
            navigator.clipboard.writeText('PURENUT20').then(() => {
                const originalSvg = btnCopy.innerHTML;
                btnCopy.innerHTML = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M20 6L9 17l-5-5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
                setTimeout(() => {
                    btnCopy.innerHTML = originalSvg;
                }, 2000);
            });
        });
    }
});

/* ============================================================
   THÊM VÀO GIỎ (AJAX) — dùng chung mọi trang có .add-cart-btn
   Nút cần: data-product-id, (tuỳ chọn) data-quantity
   ============================================================ */
(function () {
  const CTX = window.CTX || '';

  function showToast(msg) {
    let t = document.querySelector('.pn-toast');
    if (!t) {
      t = document.createElement('div');
      t.className = 'pn-toast';
      document.body.appendChild(t);
    }
    t.textContent = msg;
    t.classList.add('show');
    clearTimeout(t._timer);
    t._timer = setTimeout(() => t.classList.remove('show'), 2200);
  }

  function updateCartBadge(count) {
    const badge = document.getElementById('siteCartBadge') || document.getElementById('cartBadge');
    if (badge) badge.textContent = count > 0 ? count : '';
  }

  async function addToCart(productId, quantity) {
    const res = await fetch(CTX + '/cart/add', {
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: 'productId=' + encodeURIComponent(productId) + '&quantity=' + encodeURIComponent(quantity)
    });
    // Chưa đăng nhập → AuthFilter redirect sang /login
    if (res.redirected) { window.location = res.url; return null; }
    return res.json();
  }

  document.querySelectorAll('.add-cart-btn').forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      const productId = btn.getAttribute('data-product-id');
      let quantity = btn.getAttribute('data-quantity') || 1;
      // Nếu nút nằm trong form có ô số lượng (trang chi tiết) → lấy số lượng đó
      const form = btn.closest('form');
      if (form) {
        const qi = form.querySelector('input[name="quantity"]');
        if (qi && qi.value) quantity = qi.value;
      }
      if (!productId) return;

      const original = btn.textContent;
      btn.disabled = true;
      btn.textContent = 'Đang thêm...';
      try {
        const data = await addToCart(productId, quantity);
        if (data && data.success) {
          updateCartBadge(data.cartCount);
          showToast('Đã thêm vào giỏ hàng ✓');
          btn.textContent = '✓ Đã thêm';
          setTimeout(() => { btn.textContent = original; btn.disabled = false; }, 1200);
        } else if (data) {
          btn.textContent = original; btn.disabled = false;
        }
      } catch (err) {
        window.location = CTX + '/login';
      }
    });
  });
})();
