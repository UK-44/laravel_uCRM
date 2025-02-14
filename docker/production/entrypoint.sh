#!/bin/bash
set -e

# PHP-FPM をバックグラウンドで起動
php-fpm &

# SSH サービスを起動
service ssh start

# Gunicorn をバックグラウンドで起動
gunicorn -w 4 -b 0.0.0.0:8000 app:app &

# Nginx をフォアグラウンドで起動（このプロセスが PID 1 となる）
exec nginx -g "daemon off;"
