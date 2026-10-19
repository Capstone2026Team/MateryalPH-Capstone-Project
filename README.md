# MateryalPH

MateryalPH is a geolocation-based construction-material marketplace with separate Buyer, Vendor, and Admin connected by one backed by versioned API.

## Repository layout

- `apps/buyer-mobile` — Flutter/Dart Buyer application.
- `apps/vendor-web` — React 19, strict TypeScript, Vite 8, and Tailwind CSS Vendor portal.
- `apps/admin-web` — React 19, strict TypeScript, Vite 8, and Tailwind CSS Admin portal.
- `services/api` — Laravel 13 API; PHP 8.4 is the reference runtime.
- `packages/api-contract` — OpenAPI 3.1 contract foundation and generated-client boundary.
- `packages/design-tokens` — canonical semantic design tokens and generated platform outputs.
- `packages/web-ui` — shared accessible React primitives.
- `packages/shared-config` — shared strict TypeScript configuration.

Product behavior is defined by `docs/workflows`, architecture by `docs/architecture/MateryalPH_Technical_System_Design.md`, and interface implementation by `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`.

## Prerequisites

- PHP 8.4 and Composer 2
- Node.js 24 or newer
- Flutter and Dart
- PostgreSQL 16 with PostGIS, `pg_trgm`, and `pgcrypto`
- A Redis-compatible cache and queue service

Do not create local environment files until the repository-root `.gitignore` has been verified. Use only the safe committed examples described in `docs/architecture/MateryalPH_Environment_and_API_Key_Setup.md`; never commit real credentials.

## Render staging deployment

The [free Render staging runbook](docs/deployment/render-staging.md) covers the API, Vendor and Admin deployment, CI/CD setup, required staging credentials, generated URLs and free-plan limits. Infrastructure is declared in [render.yaml](render.yaml).

## Local development

Start the approved PostgreSQL/PostGIS, Redis, API, queue worker, scheduler,
Mailpit, and MinIO services from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-local.ps1
docker compose up -d --build
docker compose ps
```

Mailpit is available at `http://localhost:8025`. OTP and invitation mail is
queued: the API, queue worker, and scheduler must all remain running.

### API

```powershell
Set-Location services/api
composer install
php -d upload_max_filesize=10M -d post_max_size=12M -S 127.0.0.1:8080 -t public vendor/laravel/framework/src/Illuminate/Foundation/resources/server.php
```

The scaffold API is exposed under `http://127.0.0.1:8080/api/v1`.

### Vendor portal — port 5173

```powershell
Set-Location apps/vendor-web
npm install
npm run dev
```

### Admin portal — port 5174

```powershell
Set-Location apps/admin-web
npm install
npm run dev
```

### Buyer application

```powershell
Set-Location apps/buyer-mobile
flutter pub get
flutter run --dart-define-from-file=config/development.json
flutter run -d 110013341G000422 --dart-define-from-file=config/development.json
```

For a USB-connected Android device, forward the API and realtime ports. Port 8081 carries instant notification and message updates.

```powershell
adb -s 110013341G000422 reverse tcp:8080 tcp:8080
adb -s 110013341G000422 reverse tcp:8081 tcp:8081
adb -s 110013341G000422 reverse --list
```

### Temporary public demo with Cloudflare Quick Tunnel

This demo keeps the existing API and database local. The script checks that the API health route responds, builds the Admin and Vendor portals with same-origin `/api/v1` proxies, starts production previews on loopback ports 5183/5184, and opens one free Quick Tunnel for each portal. It does not start migrations, seed data, or expose PostgreSQL, Redis, MinIO, or Mailpit.

```powershell
pwsh -ExecutionPolicy Bypass -File scripts/start-cloudflare-demo.ps1
```

Use the Vendor and Admin HTTPS URLs printed by the script. To build an Android Buyer demo package for the current Vendor URL, run the printed command with the Vendor root URL. If the C: drive is low on space, pass an empty scratch path on a drive with free space:

```powershell
pwsh -ExecutionPolicy Bypass -File scripts/build-buyer-cloudflare-apk.ps1 `
  -VendorTunnelUrl 'https://<vendor-name>.trycloudflare.com' `
  -BuildWorkspace 'D:\MateryalPH-Buyer-Demo-Build'
```

The script publishes `buyer-demo.apk` on the Vendor tunnel. Open `https://<vendor-name>.trycloudflare.com/buyer-demo.apk` on an Android phone, download and install it, then sign in. The APK uses the Vendor tunnel’s `/api/v1` proxy, so no separate public API tunnel or CORS change is needed. The temporary APK is a debug build and the download URL is public to anyone who has it.

Quick Tunnel hostnames change when restarted. Keep the PC and both tunnel processes online for the demo; rebuild the Buyer APK if the Vendor hostname changes. The tunnel scripts bind only to loopback and can be stopped with:

```powershell
pwsh -ExecutionPolicy Bypass -File scripts/stop-cloudflare-demo.ps1
```

The local reCAPTCHA allowlist does not include temporary `trycloudflare.com` hostnames. If the login page rejects its reCAPTCHA token, use the existing accessible email verification option and retrieve its code from Mailpit on the desktop before taking the remote devices to the demo. Mailpit itself stays local. Reverb is not exposed by this two-tunnel setup, so messaging and notification updates use their existing polling fallback instead of live WebSockets.

## Validation

Run the checks relevant to a change from the owning directory:

```powershell
# services/api
composer validate --strict
vendor/bin/pint --test
vendor/bin/phpstan analyse --memory-limit=1G

# repository root: isolated PostgreSQL 16/PostGIS API test gate (PowerShell 7)
pwsh -File scripts/run-tests-isolated.ps1
# Keep the isolated services available for follow-up test runs:
# pwsh -File scripts/run-tests-isolated.ps1 -KeepRunning

# each React portal
npm run typecheck
npm run lint
npm run build

# apps/buyer-mobile
flutter analyze
flutter test
```

## Demo Seeded Data
Sign-in details were written to /workspace/services/api/storage/app/demo-vendor-credentials.json (git-ignored). Passwords and authenticator secrets are never printed.

```powershell
# For new machine run this
py tools/demo-assets/fetch_demo_photos.py

# 12 Vendor Seeded 
docker compose exec api php artisan materyalph:demo-vendors-seed
```

## Other Information
The API test runner finds Docker Desktop on PATH or in its standard user/system
installation folder, waits for the test services to be healthy, and runs Laravel
checks inside `api-test`. Do not run `php artisan test` directly from Windows:
`postgres-test` resolves inside the isolated Compose network. The runner validates
the test database before migrations and leaves the development database separate.

Real provider credentials belong only n ignored local files. See
`docs/architecture/MateryalPH_Environment_and_API_Key_Setup.md` for Google OIDC
and Vendor reCAPTCHA Enterprise setup. Buyer iOS acceptance requires macOS with Xcode.

The approved authentication target is Laravel Passport. See `docs/adr/0001-api-authentication-passport.md` for the controlled transition from the scaffold's Sanctum dependency.

