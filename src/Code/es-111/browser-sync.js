var browserSync = require('browser-sync').create();
var proxy = require('http-proxy-middleware');

// TODO: Get hosts and ports from args/environment, ala webpack in selfserve
browserSync.init({
    files: "es-site/es/es/**/*.+(css|js|html)",
    middleware: [
        proxy('/solar-planner', {
            target: 'http://localhost:8080',
            changeOrigin: true,
            logLevel: 'debug'
        }),
    ],
    open: false,
    port: 8000,
    proxy: 'localhost:8001',
    // TODO: reloadDelay/Debounce/Throttle
});
