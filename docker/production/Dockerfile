# ビルドステージ：Composerを使用してPHP依存関係をインストール
FROM composer:2.5 AS build
WORKDIR /app
COPY . /app/
RUN composer install --prefer-dist --no-dev --optimize-autoloader --no-interaction

# 本番ステージ：PHP-FPMとNode.jsを設定
FROM php:8.2.12-fpm AS production

ENV APP_ENV=production
ENV APP_DEBUG=false

# 必要なシステムパッケージおよびPHP拡張モジュールのインストール
RUN apt-get update && \
    apt-get -y install \
      git \
      zip \
      unzip \
      vim \
      nodejs \
      npm && \
    docker-php-ext-install pdo_mysql bcmath && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定
WORKDIR /var/www/html

# PHP設定ファイルのコピー
COPY docker/production/php.ini /usr/local/etc/php/php.ini

# ビルドステージからアプリケーションコードをコピー
COPY --from=build /app /var/www/html

# .envファイルのコピー
COPY .env /var/www/html/.env

# Node.jsの依存関係をインストールし、フロントエンド資産をビルド
RUN npm install && npm run prod

# Laravelのキャッシュを生成し、適切な権限を設定
RUN php artisan config:cache && \
    php artisan route:cache && \
    chmod -R 755 /var/www/html/storage/ && \
    chown -R www-data:www-data /var/www/html

# PHP-FPMがポート9000で待機
EXPOSE 9000

# コンテナ起動時にPHP-FPMを実行
CMD ["php-fpm"]
