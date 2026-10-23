#!/bin/sh
set -eu
: "${MATERYALPH_DB_APP_PASSWORD:?Use the protected PostgreSQL entrypoint}"
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set ON_ERROR_STOP=1 <<'SQL'
\getenv app_password MATERYALPH_DB_APP_PASSWORD
CREATE ROLE materyalph_app LOGIN PASSWORD :'app_password';
GRANT CONNECT ON DATABASE materyalph_staging TO materyalph_app;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
GRANT USAGE, CREATE ON SCHEMA public TO materyalph_app;
SQL
unset MATERYALPH_DB_APP_PASSWORD
