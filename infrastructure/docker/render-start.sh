#!/bin/sh
# Free preview: the API supervises HTTP, queue and scheduler; Reverb runs separately.
set -eu

cd /app/services/api

# Render's generateValue produces a base64-encoded 256-bit key. Laravel needs its prefix.
if [ -n "${APP_KEY:-}" ]; then
    case "$APP_KEY" in
        base64:*) ;;
        ???????????????????????????????????????????=) export APP_KEY="base64:$APP_KEY" ;;
    esac
fi

# Only public deployment addresses are derived here; provider credentials stay in Render secrets.
if [ -n "${RENDER_EXTERNAL_URL:-}" ] && [ -z "${APP_URL:-}" ]; then
    export APP_URL="$RENDER_EXTERNAL_URL"
fi
if [ -n "${FRONTEND_VENDOR_HOST:-}" ] && [ -n "${FRONTEND_ADMIN_HOST:-}" ]; then
    case "$FRONTEND_VENDOR_HOST$FRONTEND_ADMIN_HOST" in
        *[!a-zA-Z0-9.-]*) echo 'Invalid portal hostname.' >&2; exit 1 ;;
    esac
    export FRONTEND_VENDOR_URL="https://$FRONTEND_VENDOR_HOST"
    export FRONTEND_ADMIN_URL="https://$FRONTEND_ADMIN_HOST"
    export CORS_ALLOWED_ORIGINS="$FRONTEND_VENDOR_URL,$FRONTEND_ADMIN_URL"
    export REVERB_ALLOWED_ORIGINS="$FRONTEND_VENDOR_HOST,$FRONTEND_ADMIN_HOST"
    export RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES="$FRONTEND_VENDOR_HOST"
    export RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES="$FRONTEND_ADMIN_HOST"
    export GOOGLE_OIDC_REDIRECT_URI="$FRONTEND_VENDOR_URL/api/v1/auth/google/callback"
fi

role="${MATERYALPH_SERVICE_ROLE:-${1:-api}}"
if [ "$#" -gt 0 ]; then
    shift
fi

if [ "$role" = api ] && [ "${FREE_STAGING_PREVIEW:-false}" = true ]; then
    # Free compute has no pre-deploy command. Only this role releases before supervised jobs start.
    php /app/infrastructure/staging-release.php
fi

case "$role" in
    release)
        exec php /app/infrastructure/staging-release.php
        ;;
    api|worker|reverb|scheduler)
        echo 'Render startup: caching configuration.'
        php artisan config:cache
        echo 'Render startup: caching routes.'
        php artisan route:cache
        echo 'Render startup: caching events.'
        php artisan event:cache
        ;;
    *)
        exec "$role" "$@"
        ;;
esac

case "$role" in
    api)
        case "${PORT:-10000}" in
            ''|*[!0-9]*) echo 'PORT must be a numeric TCP port.' >&2; exit 1 ;;
        esac
        mkdir -p /tmp/nginx
        php /app/infrastructure/prepare-nginx.php
        sed "s/listen 10000;/listen ${PORT:-10000};/" /app/infrastructure/nginx.conf > /tmp/nginx/nginx.conf
        exec supervisord -c /app/infrastructure/supervisord.conf
        ;;
    worker)
        # Finish within Free compute's default shutdown window; Redis retries after 120 seconds.
        exec php artisan queue:work redis --queue=default --sleep=2 --tries=3 --timeout=20 --memory=128 --no-interaction
        ;;
    reverb)
        exec php artisan reverb:start --host=0.0.0.0 --port="${PORT:-10000}" --no-interaction
        ;;
    scheduler)
        exec php artisan schedule:run --no-interaction
        ;;
esac
