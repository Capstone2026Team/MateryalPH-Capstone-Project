#!/bin/sh
set -eu
case "${REDIS_PASSWORD:-}" in ''|*[!a-zA-Z0-9_-]*) echo 'Use a generated alphanumeric Redis password.' >&2; exit 1 ;; esac
[ "${#REDIS_PASSWORD}" -ge 32 ] || exit 1
umask 077
printf 'bind 0.0.0.0\nport 6379\ndir /data\nappendonly yes\nappendfsync everysec\nmaxmemory 192mb\nmaxmemory-policy noeviction\nrequirepass %s\n' "$REDIS_PASSWORD" > /tmp/staging-redis.conf
chown redis:redis /tmp/staging-redis.conf
exec /usr/local/bin/docker-entrypoint.sh redis-server /tmp/staging-redis.conf
