FROM php:8.4-cli-alpine

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        autoconf \
        curl \
        g++ \
        git \
        icu-dev \
        clamav \
        clamav-libunrar \
        ffmpeg \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        libzip-dev \
        linux-headers \
        make \
        postgresql-dev \
        tesseract-ocr \
        tesseract-ocr-data-eng \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install bcmath gd intl opcache pcntl pdo_pgsql zip

COPY infrastructure/docker/install-phpredis.sh /usr/local/bin/install-phpredis
RUN sh /usr/local/bin/install-phpredis \
    && apk del autoconf g++ linux-headers make

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY infrastructure/docker/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

WORKDIR /workspace/services/api
