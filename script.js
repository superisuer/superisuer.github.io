document.addEventListener('DOMContentLoaded', function() {
    const checkmarkContainer = document.getElementById('checkmarkContainer');
    const emoji = '✅';
    const totalCheckmarks = 80;
    
    function createCheckmarks(count) {
        for (let i = 0; i < count; i++) {
            const checkmark = document.createElement('div');
            checkmark.className = 'checkmark';
            checkmark.textContent = emoji;
            
            const left = Math.random() * 100;
            const startTop = Math.random() * 100;
            const size = 20 + Math.random() * 30;
            const duration = 15 + Math.random() * 25;
            const delay = Math.random() * 15;
            
            checkmark.style.left = `${left}%`;
            checkmark.style.top = `${startTop}%`;
            checkmark.style.fontSize = `${size}px`;
            checkmark.style.animationDuration = `${duration}s`;
            checkmark.style.animationDelay = `-${delay}s`;
            checkmark.style.opacity = `${0.1 + Math.random() * 0.2}`;
            
            if (Math.random() > 0.7) {
                const hue = Math.floor(Math.random() * 60) + 100;
                checkmark.style.color = `hsl(${hue}, 80%, 60%)`;
            }
            
            checkmarkContainer.appendChild(checkmark);
        }
    }
    
    createCheckmarks(totalCheckmarks);
    
    function updateCheckmarks() {
        const checkmarks = document.querySelectorAll('.checkmark');
        const windowHeight = window.innerHeight;
        
        checkmarks.forEach(checkmark => {
            const rect = checkmark.getBoundingClientRect();
            
            if (rect.bottom < -50) {
                checkmark.style.top = `${windowHeight + 50}px`;
                checkmark.style.left = `${Math.random() * 100}%`;
                
                const newDuration = 15 + Math.random() * 25;
                checkmark.style.animationDuration = `${newDuration}s`;
                
                checkmark.style.animation = 'none';
                void checkmark.offsetWidth;
                checkmark.style.animation = `float ${newDuration}s linear infinite`;
            }
        });
        
        requestAnimationFrame(updateCheckmarks);
    }
    
    updateCheckmarks();
    
    document.querySelectorAll('.project-link').forEach(link => {
        link.addEventListener('mouseenter', function() {
            createHoverCheckmarks(this);
        });
    });
    
    document.querySelectorAll('.contact-item').forEach(item => {
        item.addEventListener('mouseenter', function() {
            createHoverCheckmarks(this);
        });
    });
    
    function createHoverCheckmarks(element) {
        for (let i = 0; i < 2; i++) {
            setTimeout(() => {
                const checkmark = document.createElement('div');
                checkmark.className = 'checkmark';
                checkmark.textContent = emoji;
                checkmark.style.position = 'fixed';
                checkmark.style.fontSize = '18px';
                checkmark.style.opacity = '0.6';
                checkmark.style.zIndex = '10';
                checkmark.style.animation = 'none';
                checkmark.style.pointerEvents = 'none';
                
                const rect = element.getBoundingClientRect();
                const x = rect.left + Math.random() * rect.width;
                const y = rect.top + Math.random() * rect.height;
                
                checkmark.style.left = `${x}px`;
                checkmark.style.top = `${y}px`;
                
                document.body.appendChild(checkmark);
                
                let posY = y;
                const fadeInterval = setInterval(() => {
                    posY -= 3;
                    checkmark.style.top = `${posY}px`;
                    checkmark.style.opacity = parseFloat(checkmark.style.opacity) - 0.03;
                    
                    if (parseFloat(checkmark.style.opacity) <= 0) {
                        clearInterval(fadeInterval);
                        if (checkmark.parentNode) {
                            checkmark.parentNode.removeChild(checkmark);
                        }
                    }
                }, 16);
            }, i * 100);
        }
    }
    
    let lastScrollTime = 0;
    window.addEventListener('scroll', function() {
        const currentTime = Date.now();
        if (currentTime - lastScrollTime > 500) {
            lastScrollTime = currentTime;
            
            const newCount = 3 + Math.floor(Math.random() * 4);
            for (let i = 0; i < newCount; i++) {
                setTimeout(() => {
                    const checkmark = document.createElement('div');
                    checkmark.className = 'checkmark';
                    checkmark.textContent = emoji;
                    
                    const left = Math.random() * 100;
                    const size = 15 + Math.random() * 25;
                    const duration = 12 + Math.random() * 20;
                    
                    checkmark.style.left = `${left}%`;
                    checkmark.style.top = `${window.innerHeight + 20}px`;
                    checkmark.style.fontSize = `${size}px`;
                    checkmark.style.animationDuration = `${duration}s`;
                    checkmark.style.opacity = `${0.05 + Math.random() * 0.15}`;
                    
                    checkmarkContainer.appendChild(checkmark);
                }, i * 150);
            }
        }
    });
});