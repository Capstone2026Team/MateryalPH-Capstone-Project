FROM php:8.4-fpm-alpine

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        autoconf \
        curl \
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
        nginx \
        oniguruma-dev \
        libpq-dev \
        supervisor \
        tesseract-ocr \
        tesseract-ocr-data-eng \
        tini \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install bcmath gd intl mbstring opcache pcntl pdo_pgsql zip

COPY infrastructure/docker/install-phpredis.sh /usr/local/bin/install-phpredis
RUN sh /usr/local/bin/install-phpredis \
    && apk del autoconf g++ linux-headers make

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY infrastructure/docker/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

WORKDIR /app/services/api

COPY services/api/composer.json services/api/composer.lock ./
RUN composer install --no-dev --no-interaction --no-progress --prefer-dist --no-scripts --no-autoloader

COPY services/api ./
COPY infrastructure/docker/render-start.sh /usr/local/bin/render-start
COPY infrastructure/docker/staging-release.php /app/infrastructure/staging-release.php
COPY infrastructure/docker/prepare-render-nginx.php /app/infrastructure/prepare-nginx.php
COPY infrastructure/docker/render-nginx.conf /app/infrastructure/nginx.conf
COPY infrastructure/docker/render-supervisord.conf /app/infrastructure/supervisord.conf
COPY infrastructure/docker/render-freshclam.conf /app/infrastructure/freshclam.conf
COPY infrastructure/docker/render-php-fpm.conf /usr/local/etc/php-fpm.d/zz-render.conf

RUN mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache /var/lib/clamav /tmp/nginx \
    && composer dump-autoload --no-dev --optimize --no-scripts \
    && php artisan package:discover --ansi \
    && adduser -D -u 10001 app \
    && chmod +x /usr/local/bin/render-start \
    && chown -R app:app storage bootstrap/cache /var/lib/clamav /tmp/nginx /app/infrastructure/nginx.conf

USER app

ENV PORT=10000
ENV RUN_FRESHCLAM=false

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/render-start", "api"]
