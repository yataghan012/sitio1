// ============================================
// Hero Slider
// ============================================
let currentSlide = 0;
let slideInterval;

function showSlide(index) {
    const slides = document.querySelectorAll('.hero-slide');
    const indicators = document.querySelectorAll('.indicator');

    if (!slides.length) return;

    // Wrap around
    if (index >= slides.length) currentSlide = 0;
    if (index < 0) currentSlide = slides.length - 1;

    // Update slides
    slides.forEach((slide, i) => {
        slide.classList.remove('active');
        if (i === currentSlide) {
            slide.classList.add('active');
        }
    });

    // Update indicators
    indicators.forEach((indicator, i) => {
        indicator.classList.remove('active');
        if (i === currentSlide) {
            indicator.classList.add('active');
        }
    });
}

function changeSlide(direction) {
    currentSlide += direction;
    showSlide(currentSlide);
    resetSlideInterval();
}

function goToSlide(index) {
    currentSlide = index;
    showSlide(currentSlide);
    resetSlideInterval();
}

function nextSlide() {
    currentSlide++;
    showSlide(currentSlide);
}

function resetSlideInterval() {
    clearInterval(slideInterval);
    slideInterval = setInterval(nextSlide, 5000); // Change slide every 5 seconds
}

// Auto-start slider
document.addEventListener('DOMContentLoaded', () => {
    if (document.querySelector('.hero-slider')) {
        showSlide(currentSlide);
        slideInterval = setInterval(nextSlide, 5000);

        // Pause on hover
        const heroSlider = document.querySelector('.hero-slider');
        heroSlider.addEventListener('mouseenter', () => {
            clearInterval(slideInterval);
        });

        heroSlider.addEventListener('mouseleave', () => {
            slideInterval = setInterval(nextSlide, 5000);
        });

        // Event listeners for controls
        const prevBtn = document.querySelector('.slider-btn.prev');
        const nextBtn = document.querySelector('.slider-btn.next');

        if (prevBtn) {
            console.log('Prev button found, attaching listener');
            prevBtn.addEventListener('click', (e) => {
                console.log('Prev button clicked');
                e.preventDefault();
                changeSlide(-1);
            });
        }

        if (nextBtn) {
            console.log('Next button found, attaching listener');
            nextBtn.addEventListener('click', (e) => {
                console.log('Next button clicked');
                e.preventDefault();
                changeSlide(1);
            });
        }

        // Event listeners for indicators
        const indicators = document.querySelectorAll('.indicator');
        indicators.forEach((indicator, index) => {
            indicator.addEventListener('click', () => {
                console.log('Indicator clicked', index);
                goToSlide(index);
            });
        });
    }
});

// ============================================
// Mobile Navigation Toggle
// ============================================
const navToggle = document.getElementById('navToggle');
const navMenu = document.getElementById('navMenu');

if (navToggle) {
    navToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
    });

    // Close menu when clicking outside
    document.addEventListener('click', (e) => {
        if (!navToggle.contains(e.target) && !navMenu.contains(e.target)) {
            navMenu.classList.remove('active');
        }
    });

    // Close menu when clicking on a link
    const navLinks = navMenu.querySelectorAll('a');
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
        });
    });
}

// ============================================
// Product Filter (Products Page)
// ============================================
const filterButtons = document.querySelectorAll('.filter-btn');
const productCards = document.querySelectorAll('.product-card');

if (filterButtons.length > 0) {
    filterButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Update active button
            filterButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');

            const category = button.getAttribute('data-category');

            // Filter products
            productCards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');

                if (category === 'all' || cardCategory === category) {
                    card.style.display = 'block';
                    // Add entrance animation
                    card.style.animation = 'fadeInUp 0.5s ease forwards';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });
}

// ============================================
// Contact Form Handler
// ============================================
function handleContactForm(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);
    const formMessage = document.getElementById('formMessage');

    // Basic form validation
    const nombre = formData.get('nombre');
    const email = formData.get('email');
    const mensaje = formData.get('mensaje');

    if (!nombre || !email || !mensaje) {
        showMessage('Por favor complete todos los campos requeridos.', 'error');
        return false;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showMessage('Por favor ingrese un correo electrónico válido.', 'error');
        return false;
    }

    // Simulate form submission
    // In production, this would send data to a server
    const submitButton = form.querySelector('button[type="submit"]');
    submitButton.disabled = true;
    submitButton.textContent = 'Enviando...';

    setTimeout(() => {
        // Simulate successful submission
        showMessage('¡Mensaje enviado exitosamente! Nos pondremos en contacto a la brevedad.', 'success');
        form.reset();
        submitButton.disabled = false;
        submitButton.textContent = 'Enviar mensaje';

        // Clear file name display
        const fileNameDisplay = document.getElementById('fileName');
        if (fileNameDisplay) {
            fileNameDisplay.textContent = '';
        }

        // In production, you would:
        // 1. Send data to backend API
        // 2. Store in database
        // 3. Send email notification
        // Example:
        /*
        fetch('/api/contact', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            showMessage('¡Mensaje enviado exitosamente!', 'success');
            form.reset();
        })
        .catch(error => {
            showMessage('Error al enviar el mensaje. Por favor intente nuevamente.', 'error');
        })
        .finally(() => {
            submitButton.disabled = false;
            submitButton.textContent = 'Enviar mensaje';
        });
        */
    }, 1500);

    return false;
}

// ============================================
// Show Form Message
// ============================================
function showMessage(message, type) {
    const formMessage = document.getElementById('formMessage');
    if (formMessage) {
        formMessage.textContent = message;
        formMessage.className = `form-message ${type}`;

        // Auto-hide message after 5 seconds
        setTimeout(() => {
            formMessage.className = 'form-message';
        }, 5000);
    }
}

// ============================================
// File Upload Handler
// ============================================
const fileInput = document.getElementById('imagen');
const fileNameDisplay = document.getElementById('fileName');

if (fileInput) {
    fileInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
            fileNameDisplay.textContent = `Archivo seleccionado: ${file.name}`;
        } else {
            fileNameDisplay.textContent = '';
        }
    });
}

// ============================================
// Newsletter Form Handler
// ============================================
function handleNewsletter(event) {
    event.preventDefault();

    const form = event.target;
    const email = form.querySelector('input[type="email"]').value;
    const button = form.querySelector('button');

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert('Por favor ingrese un correo electrónico válido.');
        return false;
    }

    // Simulate submission
    button.disabled = true;
    button.textContent = 'Suscribiendo...';

    setTimeout(() => {
        alert('¡Gracias por suscribirte! Recibirás nuestras novedades en tu correo.');
        form.reset();
        button.disabled = false;
        button.textContent = 'Suscribirse';

        // In production, send to backend
        /*
        fetch('/api/newsletter', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({email})
        });
        */
    }, 1000);

    return false;
}

// ============================================
// Smooth Scroll for Anchor Links
// ============================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');

        // Skip empty hash links
        if (href === '#' || href === '#!') {
            e.preventDefault();
            return;
        }

        const target = document.querySelector(href);
        if (target) {
            e.preventDefault();
            const headerOffset = 100;
            const elementPosition = target.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// ============================================
// Intersection Observer for Animations
// ============================================
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe feature cards
document.querySelectorAll('.feature-card, .product-card, .news-card').forEach(card => {
    observer.observe(card);
});

// ============================================
// Auto-hide Success/Error Messages
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    const messages = document.querySelectorAll('.form-message.success, .form-message.error');
    messages.forEach(message => {
        if (message.style.display !== 'none') {
            setTimeout(() => {
                message.style.display = 'none';
            }, 5000);
        }
    });
});

// ============================================
// Back to Top Button (Optional Enhancement)
// ============================================
// Uncomment to add a back-to-top button
/*
const backToTopBtn = document.createElement('button');
backToTopBtn.innerHTML = '↑';
backToTopBtn.className = 'back-to-top';
backToTopBtn.style.cssText = `
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: var(--primary);
    color: white;
    border: none;
    cursor: pointer;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
    font-size: 24px;
    z-index: 999;
`;

document.body.appendChild(backToTopBtn);

window.addEventListener('scroll', () => {
    if (window.pageYOffset > 300) {
        backToTopBtn.style.opacity = '1';
        backToTopBtn.style.visibility = 'visible';
    } else {
        backToTopBtn.style.opacity = '0';
        backToTopBtn.style.visibility = 'hidden';
    }
});

backToTopBtn.addEventListener('click', () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});
*/

// ============================================
// Console Message for Developers
// ============================================
console.log('%cBioArTec Website', 'color: #00D9A3; font-size: 20px; font-weight: bold;');
console.log('%cSitio desarrollado con HTML, CSS y JavaScript vanilla', 'color: #0A4D68; font-size: 14px;');
console.log('%cPara integración backend, conectar formularios a API REST', 'color: #64748B; font-size: 12px;');

