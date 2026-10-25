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
- `.tmp/` — local database exports, Docker image archives, deployment artifacts, and PDF tooling; excluded from Git and Docker builds. Use this folder for local temporary artifacts.

Product behavior is defined by `docs/workflows`, architecture by `docs/architecture/MateryalPH_Technical_System_Design.md`, and interface implementation by `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`.

## Prerequisites

- PHP 8.4 and Composer 2
- Node.js 24 or newer
- Flutter and Dart
- PostgreSQL 16 with PostGIS, `pg_trgm`, and `pgcrypto`
- A Redis-compatible cache and queue service

Do not create local environment files until the repository-root `.gitignore` has been verified. Use only the safe committed examples described in `docs/architecture/MateryalPH_Environment_and_API_Key_Setup.md`; never commit real credentials.

## Staging deployment

The approved primary target is [Hostinger KVM 2](docs/deployment/hostinger-vps.md), with independent runtime roles, free DuckDNS HTTPS, signed Buyer profiles and encrypted recovery sets. See [ADR 0003](docs/adr/0003-hostinger-vps-staging.md). The VPS is prepared; application release and cutover remain gated. Current evidence and outstanding setup are in [the verification record](docs/test-plans/hostinger-vps-verification.md). Render is retained as the manual fallback through 17 November 2026.

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

### Buyer application (local Run)

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

### Buyer application on Render staging

The hosted staging environment uses Render for the API, jobs, Reverb, PostgreSQL,
Key Value and Vendor/Admin portals. See the
[deployment runbook](docs/deployment/render-staging.md).

Buyer connects directly to the Render API. Copy
`apps/buyer-mobile/config/staging.example.json` to the ignored `config/staging.json`
in that app, configure the assigned Render API address and public client settings,
and configure the exact finalized Render entry in ignored `config/deployments.json` from its example,
then run from the repository root:

```powershell
./scripts/deployment/build-buyer-staging.ps1
# To run on a connected device instead:
./scripts/deployment/build-buyer-staging.ps1 -Run -Device 110013341G000422
```

The phone needs internet; no `adb reverse`, tunnel or shared Wi-Fi is required.

### Existing Render preview

https://materyalph-staging-api.onrender.com/api/v1
Check the Render API's current health before using the preview.
From your project root, run:

```powershell
Set-Location apps/buyer-mobile
flutter run -d 110013341G000422 `
  --dart-define-from-file=config/development.json `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://materyalph-staging-api.onrender.com/api/v1
```

This keeps your existing client configuration while connecting to Render. Stop the current Flutter session first, then run that command.
To build an APK using Render:

```powershell
flutter build apk --debug `
  --dart-define-from-file=config/development.json `
  --dart-define=APP_ENV=staging `
  --dart-define=API_BASE_URL=https://materyalph-staging-api.onrender.com/api/v1
```

The APK will be at:

```powershell
apps/buyer-mobile/build/app/outputs/flutter-apk/app-debug.apk
```

Your phone needs internet; adb reverse is unnecessary for Render. Before testing, open the API health page and wait for JSON—Render Free can take about a minute to wake after inactivity. Render documentation

Sign in with a Buyer account from the staging database.

## Demo Seeded Data
Sign-in details were written to /workspace/services/api/storage/app/demo-vendor-credentials.json (git-ignored). Passwords and authenticator secrets are never printed.

```powershell
#docker compose exec api php artisan migrate, 
docker compose exec api php artisan migrate, 

# which downloads photos for the new stores. Files that already exist are skipped.
py tools/demo-assets/fetch_demo_photos.py

# 22 Vendor Seeded 
docker compose exec api php artisan materyalph:demo-vendors-seed
```

## VPS Deploy Commands

To deploy a new commit yourself:

Commit and push to staging as usual.
Open the VS Code terminal (Ctrl + `) in the project folder and run:

```powershell
# Deployement Command (VPS)
./scripts/deployment/release-hostinger.ps1
```

Wait about 45–60 minutes. When it asks, type REOPEN to put the site back online.
What the script does (the same steps I did manually today):


```powershell
# Deployement Command ( Application APK - VPS Connected)
. C:\Users\RJ\materyalph-release-signing\use-signing.ps1
./scripts/deployment/build-buyer-staging.ps1 -Deployment Hostinger -Release -BuildName 1.0.1 -BuildNumber 2
```

## Validation

Run the checks relevant to a change from the owning directory:

```powershell
# services/api
composer validate --strict
vendor/bin/pint --test
vendor/bin/phpstan analyse --memory-limit=1G

# VPS Server
pwsh -NoProfile -File "C:\Users\RJ\AppData\Local\Temp\claude\c--Users-RJ-Downloads-Capstone-Project-System-Capstone-MateryalPH\0209d432-8d74-4258-b4ef-4afad199e892\scratchpad\open-staging.ps1"

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
