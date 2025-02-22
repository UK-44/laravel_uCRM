# === Composer で PHP 依存関係をインストールするビルドステージ ===
FROM composer:2.5 AS composer_build
WORKDIR /app
COPY . /app/

# 環境変数設定した後にcomposer install しないとエラーになる
RUN export APP_LOCALE=ja && \
    export APP_FALLBACK_LOCALE=en && \
    export APP_FAKER_LOCALE=ja_JP && \
    composer install --prefer-dist --no-dev --optimize-autoloader --no-interaction

# === Node を利用してフロントエンド資産をビルドするステージ ===
FROM node:22 AS node_build
WORKDIR /app
# Composer ビルドステージで取得したソースコードをコピー
COPY --from=composer_build /app /app
RUN npm install && npm run prod

# === 本番環境用イメージ ===
FROM php:8.2.12-fpm
# 本番用環境変数
ENV APP_ENV=production
ENV APP_DEBUG=false

# 必要なパッケージのインストール（本番では最小限にする）
RUN apt-get update && \
    apt-get install -y nginx && \
    docker-php-ext-install pdo_mysql bcmath && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# PHP・Nginx の設定ファイルをコピー（プロダクション用）
COPY docker/production/php.ini /usr/local/etc/php/php.ini
COPY docker/production/nginx.conf /etc/nginx/nginx.conf

# Composer でインストールしたコードと、Node でビルドした資産をコピー
# ※ node_build ステージで npm run prod により、public/ などのアセットが生成されている前提
COPY --from=node_build /app /var/www/html

# .env ファイルをコピー（秘匿したい値はapp service側で管理）
COPY .env.example /var/www/html/.env

# Laravel のキャッシュ生成とパーミッションの設定
RUN php artisan config:cache && \
    php artisan route:cache && \
    chmod -R 755 /var/www/html/storage/ && \
    chown -R www-data:www-data /var/www/html
    
# プロダクション用 entrypoint スクリプトのコピー
COPY docker/production/entrypoint.sh /entrypoint.sh

# Start and enable SSH
RUN apt-get update \
&& apt-get install -y --no-install-recommends dialog \
&& apt-get install -y --no-install-recommends openssh-server \
&& echo "root:Docker!" | chpasswd

RUN chmod +x /entrypoint.sh
COPY sshd_config /etc/ssh/

# コンテナがリッスンするポート（Nginx：80）
EXPOSE 80 2222

ENTRYPOINT ["/entrypoint.sh"]
