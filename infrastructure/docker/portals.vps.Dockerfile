# Rebuild the current Caddy release with patched Go, HTTP/2, HTML and JOSE dependencies.
# Keep the standard modules; no additional plugins or provider credentials.
FROM caddy:2.11.7-builder-alpine AS caddy-build
ENV GOTOOLCHAIN=go1.27.3
COPY infrastructure/docker/patches/go-jose-v3-rsa-bounds.patch /opt/go-jose-v3-rsa-bounds.patch
COPY infrastructure/docker/patches/go-jose-v3-rsa-bounds_test.go /opt/go-jose-v3-rsa-bounds_test.go
# Smallstep still imports v3, for which upstream has no fixed release.
# Backport the upstream RSA bounds and test the actual replacement before linking.
RUN go mod download github.com/go-jose/go-jose/v3@v3.0.5 \
    && cp -R "$(go env GOMODCACHE)/github.com/go-jose/go-jose/v3@v3.0.5" /opt/go-jose-v3 \
    && chmod -R u+w /opt/go-jose-v3 \
    && cd /opt/go-jose-v3 \
    && git apply --check /opt/go-jose-v3-rsa-bounds.patch \
    && git apply /opt/go-jose-v3-rsa-bounds.patch \
    && cp /opt/go-jose-v3-rsa-bounds_test.go rsa_bounds_test.go \
    && go test -timeout 120s -run '^TestMateryal' .
RUN xcaddy build v2.11.7 \
    --replace golang.org/x/net=golang.org/x/net@v0.62.0 \
    --replace github.com/go-jose/go-jose/v3=/opt/go-jose-v3 \
    --replace github.com/go-jose/go-jose/v4=github.com/go-jose/go-jose/v4@v4.1.6 \
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

FROM caddy:2.11.7-alpine AS edge-runtime
# Refresh this stage on every release; --pull alone can reuse a stale apk layer.
# Fail the build if the repository cannot supply the CVE-2026-92392 fix.
RUN apk upgrade --no-cache \
    && apk add --no-cache 'curl>=8.23.0-r0' 'libcurl>=8.23.0-r0'
COPY --from=caddy-build /usr/bin/caddy /usr/bin/caddy
COPY infrastructure/vps/Caddyfile /etc/caddy/Caddyfile
COPY --from=portals /build/apps/vendor-web/dist /srv/vendor
COPY --from=portals /build/apps/admin-web/dist /srv/admin
