const snowflakes = ['linux', 'huker', '.'];
const body = document.body;
    
function createSnowflake() {
    const snowflake = document.createElement('div');
    snowflake.innerHTML = snowflakes[Math.floor(Math.random() * snowflakes.length)];
    snowflake.style.position = 'fixed';
    snowflake.style.top = '-20px';
    snowflake.style.left = Math.random() * window.innerWidth + 'px';
    snowflake.style.fontSize = (Math.random() * 20) + 'px';
    snowflake.style.color = '#000000';
    snowflake.style.opacity = Math.random() * 0.3 + 0.3;
    snowflake.style.zIndex = '9999';
    snowflake.style.transformOrigin = 'center';
    
    body.appendChild(snowflake);
    
    const duration = Math.random() * 5 + 3;
    const endLeft = Math.random() * window.innerWidth;
    
    const animation = snowflake.animate([
        { top: '-20px', left: snowflake.style.left, transform: 'rotate(0deg)' }, 
        { top: window.innerHeight + 'px', left: endLeft + 'px', transform: 'rotate(720deg)' }
    ], {
        duration: duration * 2000,
        easing: 'linear'
    });
    
    animation.onfinish = function() {
        body.removeChild(snowflake);
    };
}

setInterval(createSnowflake, 350);