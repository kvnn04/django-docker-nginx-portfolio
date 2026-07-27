AOS.init({ duration: 600, once: true, offset: 100 });

(function() {
    var html = document.documentElement;
    var toggle = document.getElementById('theme-toggle');
    var saved = localStorage.getItem('theme');
    if (saved) { html.setAttribute('data-bs-theme', saved); updateIcon(saved); }

    if (toggle) {
        toggle.addEventListener('click', function() {
            var cur = html.getAttribute('data-bs-theme');
            var next = cur === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-bs-theme', next);
            localStorage.setItem('theme', next);
            updateIcon(next);
        });
    }

    function updateIcon(t) {
        if (toggle) toggle.innerHTML = t === 'dark' ? '<i class="bi bi-sun-fill"></i>' : '<i class="bi bi-moon-fill"></i>';
    }
})();

(function() {
    var btn = document.getElementById('back-to-top');
    if (btn) {
        window.addEventListener('scroll', function() {
            btn.classList.toggle('visible', window.scrollY > 400);
        });
        btn.addEventListener('click', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }
})();

(function() {
    var sections = document.querySelectorAll('section[id]');
    var navLinks = document.querySelectorAll('.navbar-nav .nav-link');
    var sectionMap = { inicio:'/', zonaproyectos:'#zonaproyectos', experiencia:'#experiencia', educacion:'#sobre-mi', certificaciones:'#sobre-mi', 'sobre-mi':'#sobre-mi' };
    window.addEventListener('scroll', function() {
        var current = '';
        sections.forEach(function(s) {
            if (window.scrollY >= s.offsetTop - 150) { current = s.id; }
        });
        navLinks.forEach(function(l) {
            l.classList.remove('active');
            var href = l.getAttribute('href');
            if (current && href && href.includes(sectionMap[current] || '')) { l.classList.add('active'); }
            if (!current && href === '/') { l.classList.add('active'); }
        });
    });
})();
