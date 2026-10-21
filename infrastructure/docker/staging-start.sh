#!/bin/sh
set -eu
cd /app/services/api

if [ "${APP_ENV:-}" != staging ] || [ "${XENDIT_MODE:-}" != TEST ] || [ "${LIVE_COMMERCE_ENABLED:-true}" != false ]; then
    echo 'Staging runtime requires staging, Xendit TEST and live commerce disabled.' >&2; exit 1
fi
role="${1:-api}"
case "$role" in
    release)
        [ "${STAGING_RELEASE_APPROVED:-false}" = true ] || { echo 'Approve the staging release before migrating.' >&2; exit 1; }
        exec php /app/infrastructure/staging-release.php ;;
    api|worker|scheduler|reverb) ;;
    *) echo 'Unknown staging role.' >&2; exit 1 ;;
esac
[ "${STAGING_DATA_READY:-false}" = true ] || { echo 'Complete and verify the staging import first.' >&2; exit 1; }
if [ "$role" = worker ] || [ "$role" = scheduler ]; then
    [ "${STAGING_JOBS_ENABLED:-false}" = true ] || { echo 'Review imported outbox work before enabling jobs.' >&2; exit 1; }
fi
# Use exact public portal hosts for cookies, signed URLs and the existing shared OAuth callback.
case "${FRONTEND_VENDOR_HOST:-}${FRONTEND_ADMIN_HOST:-}" in
    ''|*[!a-zA-Z0-9.-]*) echo 'Configure valid portal hosts.' >&2; exit 1 ;;
esac
[ -n "${FRONTEND_VENDOR_HOST:-}" ] && [ -n "${FRONTEND_ADMIN_HOST:-}" ] && [ "$FRONTEND_VENDOR_HOST" != "$FRONTEND_ADMIN_HOST" ]
export FRONTEND_VENDOR_URL="https://$FRONTEND_VENDOR_HOST"
export FRONTEND_ADMIN_URL="https://$FRONTEND_ADMIN_HOST"
export CORS_ALLOWED_ORIGINS="$FRONTEND_VENDOR_URL,$FRONTEND_ADMIN_URL"
export REVERB_ALLOWED_ORIGINS="$FRONTEND_VENDOR_HOST,$FRONTEND_ADMIN_HOST"
export RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES="$FRONTEND_VENDOR_HOST"
export RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES="$FRONTEND_ADMIN_HOST"
export GOOGLE_OIDC_REDIRECT_URI="$FRONTEND_VENDOR_URL/api/v1/auth/google/callback"
php artisan config:cache
php artisan route:cache
php artisan event:cache
case "$role" in
    api)
        case "${PORT:-8080}" in ''|*[!0-9]*) echo 'Invalid PORT.' >&2; exit 1 ;; esac
        mkdir -p /tmp/nginx
        php /app/infrastructure/prepare-nginx.php
        sed "s/listen 10000;/listen ${PORT:-8080};/" /app/infrastructure/nginx.conf > /tmp/nginx/nginx.conf
        exec supervisord -c /app/infrastructure/staging-supervisord.conf ;;
    worker) exec php artisan queue:work redis --queue=default --sleep=2 --tries=3 --timeout=90 --memory=256 --no-interaction ;;
    scheduler) exec php artisan schedule:work --no-interaction ;;
    reverb) exec php artisan reverb:start --host=0.0.0.0 --port="${PORT:-8080}" --no-interaction ;;
esac
