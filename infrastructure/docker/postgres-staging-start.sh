#!/bin/sh
set -eu
tls_host="${POSTGRES_TLS_HOST:-postgres.railway.internal}"
case "$tls_host" in ''|*[!a-zA-Z0-9.-]*) echo 'Configure the PostgreSQL TLS hostname.' >&2; exit 1 ;; esac
mkdir -p /var/lib/postgresql/data
if [ ! -s /var/lib/postgresql/data/server.key ] || [ ! -s /var/lib/postgresql/data/server.crt ]; then
    umask 077
    openssl req -x509 -nodes -newkey rsa:3072 -days 365 \
        -subj '/CN=materyalph-staging-postgres' \
        -addext "subjectAltName=DNS:$tls_host,DNS:${RAILWAY_PRIVATE_DOMAIN:-postgres.railway.internal}" \
        -keyout /var/lib/postgresql/data/server.key -out /var/lib/postgresql/data/server.crt >/dev/null 2>&1
fi
chown postgres:postgres /var/lib/postgresql/data/server.key /var/lib/postgresql/data/server.crt
chmod 600 /var/lib/postgresql/data/server.key
exec /usr/local/bin/docker-entrypoint.sh postgres -c ssl=on \
    -c ssl_cert_file=/var/lib/postgresql/data/server.crt \
    -c ssl_key_file=/var/lib/postgresql/data/server.key
