FROM php:8.2.12-fpm

# COPY php.ini
# COPY ./docker/local/php.ini /usr/local/etc/php/php.ini
COPY ./docker/local/php.ini /usr/local/etc/php/php.ini

# Composer install
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

# install Node.js
COPY --from=node:22.12.0 /usr/local/bin /usr/local/bin
COPY --from=node:22.12.0 /usr/local/lib /usr/local/lib

RUN apt-get update && \
    apt-get -y install \
    git \
    zip \
    unzip \
    vim \
    && docker-php-ext-install pdo_mysql bcmath

WORKDIR /var/www/html
