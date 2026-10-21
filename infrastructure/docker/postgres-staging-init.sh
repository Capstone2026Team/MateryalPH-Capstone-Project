#!/bin/sh
set -eu
case "${STAGING_DB_PASSWORD:-}" in ''|*[!a-zA-Z0-9_-]*) echo 'Configure a separate generated application database password.' >&2; exit 1 ;; esac
[ "${#STAGING_DB_PASSWORD}" -ge 32 ] || exit 1
# The application/migration role owns its schema, but is never a cluster superuser.
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set=ON_ERROR_STOP=1 <<'SQL'
\getenv application_password STAGING_DB_PASSWORD
CREATE ROLE materyalph_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE PASSWORD :'application_password';
ALTER SCHEMA public OWNER TO materyalph_app;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
GRANT SELECT, INSERT ON spatial_ref_sys TO materyalph_app;
SQL
