#!/bin/sh
set -eu
case "${1:-}" in
    vendor-web|admin-web) portal="$1" ;;
    *) echo 'Choose vendor-web or admin-web.' >&2; exit 1 ;;
esac
npm ci --prefix packages/api-contract/generated/typescript
npm run build --prefix packages/api-contract/generated/typescript
npm ci --prefix packages/web-ui
npm ci --prefix "apps/$portal"
npm run build --prefix "apps/$portal"
