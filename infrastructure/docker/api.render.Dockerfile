FROM php:8.4-cli-alpine

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        autoconf \
        g++ \
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
    && docker-php-ext-install bcmath gd intl opcache pcntl pdo_pgsql zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del autoconf g++ linux-headers make

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY infrastructure/docker/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

WORKDIR /app/services/api

COPY services/api/composer.json services/api/composer.lock ./
RUN composer install --no-dev --no-interaction --no-progress --prefer-dist --no-scripts --no-autoloader

COPY services/api ./
COPY infrastructure/docker/render-start.sh /usr/local/bin/render-start

RUN composer dump-autoload --no-dev --optimize --no-scripts \
    && adduser -D -u 10001 app \
    && chmod +x /usr/local/bin/render-start \
    && mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
    && chown -R app:app storage bootstrap/cache

USER app

ENV PHP_CLI_SERVER_WORKERS=4

CMD ["render-start"]
