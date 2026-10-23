#!/bin/sh
set -eu
# Read a root-owned 0600 Compose secret before the official entrypoint drops to postgres.
# File-backed Compose secrets do not remap host ownership/mode on Linux.
export MATERYALPH_DB_APP_PASSWORD="$(cat /run/secrets/db_app_password)"
[ "${#MATERYALPH_DB_APP_PASSWORD}" -ge 32 ] || { echo 'Configure the protected app database password file.' >&2; exit 1; }
exec /usr/local/bin/docker-entrypoint.sh "$@"
