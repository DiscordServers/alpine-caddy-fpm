# Alpine-Caddy-FPM

A specialized box containing:

* Alpine: 3.6
* PHP:    7.2-rc-pfm-alpine
* Caddy:  v0.10.10


## Requirements

* Symfony 4.0 app (using public dir)
* Mounted to /app
* Either running 
    * PHP FPM app pointing at /app/public/index.php on :9000 <-> :9000
    * Swoole command line app running on port :3000 <-> :3000 (assets still in /app/public)
    