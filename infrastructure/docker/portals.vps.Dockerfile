# Rebuild the current Caddy release with patched Go and HTTP/2 dependencies.
# Keep the standard modules; no additional plugins or provider credentials.
FROM caddy:2.11.7-builder-alpine AS caddy-build
ENV GOTOOLCHAIN=go1.27.3
RUN xcaddy build v2.11.7 \
    --replace golang.org/x/net=golang.org/x/net@v0.60.0 \
    --output /usr/bin/caddy

FROM node:24-alpine AS portals
WORKDIR /build
COPY packages/api-contract/generated/typescript packages/api-contract/generated/typescript
COPY packages/web-ui packages/web-ui
COPY packages/design-tokens packages/design-tokens
COPY packages/shared-config packages/shared-config
COPY apps/vendor-web apps/vendor-web
COPY apps/admin-web apps/admin-web
COPY scripts/deployment/build-portal.sh scripts/deployment/build-portal.sh
ARG VENDOR_RECAPTCHA_SITE_KEY
ARG ADMIN_RECAPTCHA_SITE_KEY
ARG GOOGLE_MAPS_BROWSER_KEY
ENV VITE_API_BASE_URL=/api/v1 VITE_APP_ENV=staging
RUN VITE_RECAPTCHA_SITE_KEY="$VENDOR_RECAPTCHA_SITE_KEY" VITE_GOOGLE_MAPS_BROWSER_KEY="$GOOGLE_MAPS_BROWSER_KEY" sh scripts/deployment/build-portal.sh vendor-web \
    && VITE_RECAPTCHA_SITE_KEY="$ADMIN_RECAPTCHA_SITE_KEY" VITE_GOOGLE_MAPS_BROWSER_KEY="$GOOGLE_MAPS_BROWSER_KEY" sh scripts/deployment/build-portal.sh admin-web

FROM caddy:2.11.7-alpine
# The base tag lags Alpine security fixes (e.g. brotli-libs CVE-2026-111497); apply them before the Trivy gate.
RUN apk upgrade --no-cache
COPY --from=caddy-build /usr/bin/caddy /usr/bin/caddy
COPY infrastructure/vps/Caddyfile /etc/caddy/Caddyfile
COPY --from=portals /build/apps/vendor-web/dist /srv/vendor
COPY --from=portals /build/apps/admin-web/dist /srv/admin
