FROM php:8.4-cli-alpine

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        autoconf \
        g++ \
        git \
        icu-dev \
        clamav \
        clamav-libunrar \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        libzip-dev \
        linux-headers \
        make \
        postgresql-dev \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install bcmath gd intl opcache pcntl pdo_pgsql zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del autoconf g++ linux-headers make

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /workspace/services/api
