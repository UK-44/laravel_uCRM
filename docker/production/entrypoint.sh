#!/bin/bash
# キャッシュのクリア
php artisan config:clear

# 最新の環境変数でキャッシュを再生成
php artisan config:cache

# 証明書ダウンロード
mkdir -p /home/site/wwwroot/ssl
curl -o /home/site/wwwroot/ssl/DigiCertGlobalRootCA.crt.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem

set -e

# PHP-FPM をバックグラウンドで起動
php-fpm &

# SSH サービスを起動
service ssh start

# Gunicorn をバックグラウンドで起動
gunicorn -w 4 -b 0.0.0.0:8000 app:app &

# Nginx をフォアグラウンドで起動（このプロセスが PID 1 となる）
exec nginx -g "daemon off;"
