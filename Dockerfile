# Stage 1: フロントエンドビルド
FROM node:16-alpine as build

# 作業ディレクトリを /app にする
WORKDIR /app

# package.json, lockファイルなどを先にコピーしてnpm install
COPY package*.json ./
RUN npm install

# Vite関連ファイルやソースをコピーしてビルド
COPY vite.config.js ./
COPY resources/js resources/js
COPY resources/css resources/css
RUN npm run build

# Stage 2: 本番用PHPイメージ
FROM php:8.1-fpm-alpine

# 必要なPHP拡張インストール
RUN docker-php-ext-install pdo_mysql bcmath

# 作業ディレクトリ
WORKDIR /var/www/html

# ソースコードをコピー
COPY . /var/www/html

# フロントエンドのビルド成果物を Stage1 からコピー (public/buildなど)
COPY --from=build /app/public/build /var/www/html/public/build

# Composerインストール
RUN apk add --no-cache git unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader

# 本番向けphp.iniをコピー (エラー表示などはオフに)
COPY docker/production/php.ini /usr/local/etc/php/php.ini

# キャッシュ等の書き込み権限を整える
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
