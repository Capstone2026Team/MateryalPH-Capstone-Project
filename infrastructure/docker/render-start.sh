#!/bin/sh
# Capstone demo entrypoint: one Render Web Service runs the API, the queue worker and the scheduler.
# Phase 19 replaces this with separate worker/cron services.
set -eu

cd /app/services/api

php artisan package:discover --ansi
php artisan migrate --force
php artisan db:seed --force

php artisan queue:work --sleep=1 --tries=3 --timeout=90 &
php artisan schedule:work &

exec php artisan serve --host=0.0.0.0 --port="${PORT:-10000}" --no-reload
