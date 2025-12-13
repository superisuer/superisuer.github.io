const snowflakes = ['*', '+', '.'];
const body = document.body;
    
function createSnowflake() {
    const snowflake = document.createElement('div');
    snowflake.innerHTML = snowflakes[Math.floor(Math.random() * snowflakes.length)];
    snowflake.style.position = 'fixed';
    snowflake.style.top = '-20px';
    snowflake.style.left = Math.random() * window.innerWidth + 'px';
    snowflake.style.fontSize = (Math.random() * 20 + 10) + 'px';
    snowflake.style.color = '#FFFFFF';
    snowflake.style.opacity = Math.random() * 0.5 + 0.3;
    snowflake.style.zIndex = '9999';
    
    body.appendChild(snowflake);
    
    const duration = Math.random() * 5 + 3;
    const endLeft = Math.random() * window.innerWidth;
    
    const animation = snowflake.animate([
        { top: '-20px', left: snowflake.style.left }, 
        { top: window.innerHeight + 'px', left: endLeft + 'px' }
    ], {
        duration: duration * 1000,
        easing: 'linear'
    });
    
    animation.onfinish = function() {
        body.removeChild(snowflake);
    };
}

setInterval(createSnowflake, 100);