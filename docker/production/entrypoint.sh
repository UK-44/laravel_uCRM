#!/bin/bash
set -e

# PHP-FPM をバックグラウンドで起動
php-fpm &

# Nginx をフォアグラウンドで起動（このプロセスが PID 1 となる）
exec nginx -g "daemon off;"
