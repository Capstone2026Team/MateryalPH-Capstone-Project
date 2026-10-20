# Render: free staging preview

This deploys the API backend, Vendor portal and Admin portal using Free Render resources in the confirmed **capstone's workspace** (`tea-db8ouuc9v7es73dc3u7g`). It adds the CI/CD and deployment configuration requested for staging. It does not mark Phase 19 complete or create a production environment.

## Resources and limits

| Resource | Render type | Plan | Purpose |
| --- | --- | --- | --- |
| materyalph-staging-api | Docker web service | Free | Nginx + PHP-FPM, queue worker and scheduler |
| materyalph-staging-reverb | Docker web service | Free | Public WSS endpoint |
| materyalph-staging-vendor | Static site | Free hosting | Vendor React application |
| materyalph-staging-admin | Static site | Free hosting | Admin React application |
| materyalph-staging-db | Postgres 16 | Free | Separate staging data; PostGIS, pg_trgm and pgcrypto enabled by migrations |
| materyalph-staging-redis | Key Value | Free | Cache, sessions, queue and scheduler locks |

## Live Free staging preview

These resources are already provisioned in the confirmed workspace. Do not apply `render.yaml` as a new empty Blueprint in this workspace.

| Service | Plan | Generated URL | Live deploy |
| --- | --- | --- | --- |
| API (`srv-dbb2uafbtjjs7395h1r0`) | Free | [materyalph-staging-api.onrender.com](https://materyalph-staging-api.onrender.com) | `dep-dbb3hufavr4c738ju250` |
| Reverb (`srv-dbb2u93rjlhs73b7huo0`) | Free | [materyalph-staging-reverb.onrender.com](https://materyalph-staging-reverb.onrender.com) | `dep-dbb3jsbrjlhs73b9i3rg` |
| Vendor (`srv-dbb2teuq1p3s73dl011g`) | Static | [materyalph-staging-vendor.onrender.com](https://materyalph-staging-vendor.onrender.com) | `dep-dbb3keifngtc739jvu4g` |
| Admin (`srv-dbb2tg3rjlhs73b7epsg`) | Static | [materyalph-staging-admin.onrender.com](https://materyalph-staging-admin.onrender.com) | `dep-dbb3l8jl550s73870veg` |

All four services are live on source commit `3ef276d230d1c5ed37fb5933ea6015848fe49ad6`; each has automatic deployment turned off. The Free Postgres instance (`dpg-dbb2t561egvs73clqop0-a`) expires on **2026-11-18 14:52 UTC** (22:52 Asia/Manila). Free Key Value (`red-dbb2t68n74is73c2juvg`) is volatile on restart.

The `render.yaml` passed Render's current schema and Free-plan checks. The resources were created with Render's authenticated public API fallback; no Render Blueprint object is linked to them yet. Before a future Blueprint sync, adopt the existing resources in the Dashboard rather than creating duplicates. This one-time preview was approved while the documented CI failures remain; the automatic GitHub deployment gate is unchanged.

For this API-provisioned preview, `FRONTEND_VENDOR_HOST` and `FRONTEND_ADMIN_HOST` are set to the assigned generated hostnames. `render.yaml` declares the equivalent `fromService` references for a future Blueprint adoption. If an assigned hostname changes before adoption, update and redeploy the API host variables and both portal API rewrite destinations.

All regional resources use Singapore. Portals use Render's CDN. No paid workers, cron jobs, disks or paid workspace upgrades are declared. No production resources are declared.

Free means **preview limitations**, not a continuously available installation:

- The two web services share the workspace's **750 free instance hours/month**. They sleep after 15 minutes without inbound traffic and may take about a minute to wake.
- Queue processing and scheduled tasks stop while the API sleeps. Missed scheduled times are not automatically replayed. A second service does not double the free hours allowance.
- Free Key Value loses all state on restart, including queued jobs and sessions. PostgreSQL outbox records remain, but do not assume exactly-once delivery or automatic recovery of every interrupted job.
- Free Postgres has 1 GB capacity, expires after **30 days**, and has no managed backups. Export disposable staging data before expiry; this setup does not upgrade or recreate the database automatically.
- Render Free blocks outbound SMTP ports 25, 465 and 587. Configure a separate staging mail provider that supports TLS on **2525**, or deliberately configure another supported HTTPS mail transport with its required dependency. Ordinary Gmail SMTP will not work.
- ClamAV requires more memory than the Free web plan provides. `RUN_FRESHCLAM=false` prevents an update process from exhausting memory. The application's existing scanner remains **fail-closed**: without current definitions, uploads return the existing unavailable response. Document onboarding, profile/media uploads and other scan-dependent journeys cannot be accepted on this preview. No scanner bypass is added.
- Local files disappear on restart. Private storage must use a separate private staging S3-compatible bucket; public catalog media uses the configured staging Cloudinary account. Provider accounts, quotas and credentials are separate from Render's free hosting.
- Set the workspace's spend limit/overage controls to zero where available and review Render's Billing page. Free hosting does not guarantee zero bandwidth or pipeline overages when a payment method is present. Do not enable paid compute.

Sources: [Render Free limits](https://render.com/docs/free), [ClamAV memory requirements](https://docs.clamav.net/manual/Installing/Docker.html), [Key Value persistence](https://render.com/docs/key-value).

## 1. Source and CI

Repository: [Capstone2026Team/MateryalPH-Capstone-Project](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project). Render must build the **staging** branch containing these files; local uncommitted files cannot be deployed by Render.

The workflow at `.github/workflows/ci.yml` provides:

- Path-aware pull-request checks; staging pushes and manual runs select the full suite.
- Existing PHP/PostgreSQL, OpenAPI/client drift, portal and Flutter gates.
- Secret and dependency audits, Blueprint schema/budget checks, container build/configuration and vulnerability scan.
- One aggregate required status: **All required checks passed**.
- A serialized deployment job that deploys the exact passing SHA, validates workspace/repository/branch/Free plans, waits for live deploys, then checks HTTP, proxy routing, secure host-only CSRF cookies and CSRF rejection.

Keep automatic Render service deployments off. They would bypass the ordered GitHub deployment job. Keep Blueprint automatic sync off after initial creation; review infrastructure edits separately.

The deployment change adds the required S3 Flysystem adapter and patches Symfony HTTP Foundation. The OpenAPI tooling lockfile also takes compatible security updates and pins get-uri's basic-ftp dependency to 6.2.3, because upstream still requests vulnerable 5.x. The Java generator remains pinned to 7.25.0. The FTP override rejects separate transfer hosts by default; the repository's generator downloads use HTTPS. See [the upstream advisory](https://github.com/advisories/GHSA-c475-qrg2-pj4r) and [v6 behavior](https://github.com/patrickjuchli/basic-ftp/releases/tag/v6.0.0).

A repository administrator must configure:

1. GitHub environments **staging** and **production**, with deployment branch rules limited to their intended branches. Production has no deploy job in this change.
2. A reviewer and no self-approval for production; configure staging approval according to the team's policy. Restrict who can change environment secrets.
3. Branch protection/rulesets requiring pull-request review and **All required checks passed**. Do not bypass a failed gate.
4. Environment secrets/variables below. A collaborator with push access might not have permission to configure protections.

Do not set the repository variable `RENDER_STAGING_CONFIGURED=true` until the resources, protected environment, secrets and initial checks are ready.

## 2. Validate and create the Blueprint

The Render connector lists resources, but does not apply Blueprints. The Render CLI validates a Blueprint; normal Blueprint creation uses the Dashboard. The live preview above was provisioned through the authenticated public API because the Dashboard automation was unavailable. The steps below are for a fresh environment or a deliberate adoption of the existing resources; do not apply them as a new Blueprint in the current staging environment.

From the repository root (PowerShell 7):

```powershell
python -m venv .tmp/staging-deployment/venv
& .tmp/staging-deployment/venv/Scripts/python.exe -m pip install -r tools/deployment/requirements.txt
& .tmp/staging-deployment/venv/Scripts/python.exe tools/deployment/validate_configuration.py
# With Render CLI installed:
render login
render blueprints validate render.yaml --workspace tea-db8ouuc9v7es73dc3u7g --output json
```

The schema check also rejects paid plans. Render's authenticated validation is still needed to check workspace conflicts and platform constraints.

For a fresh environment, after the staging branch passes CI, open:

[Create the staging Blueprint](https://dashboard.render.com/blueprint/new?repo=https%3A%2F%2Fgithub.com%2FCapstone2026Team%2FMateryalPH-Capstone-Project)

Select **capstone's workspace**, branch **staging**, Blueprint path **render.yaml**, and review that every compute/datastore plan is **Free**. Complete GitHub OAuth if prompted. Review the resource list before applying.

Render will prompt for `sync: false` values during initial creation. Enter secrets only in Render's Environment fields. Leave optional integrations blank when unavailable; the associated journeys remain unavailable. Do not paste secrets into chat, issues, actions logs or tracked configuration.

### Staging credentials

Generate a new Passport pair, separate from development:

```powershell
pwsh -File scripts/deployment/new-passport-keys.ps1
```

Import the ignored `.tmp/staging-deployment/passport.env` into the API's Render Environment page. The script never prints keys or overwrites an existing pair. Keep this pair across redeploys.

| Keys on API | Required setup |
| --- | --- |
| APP_KEY; REVERB_APP_KEY; REVERB_APP_SECRET | Generated once by the staging environment group; retain across deploys. Laravel's key prefix is handled by the entrypoint. Never copy development values. |
| PASSPORT_PRIVATE_KEY_BASE64; PASSPORT_PUBLIC_KEY_BASE64 | Import the separate staging pair. |
| AWS_ACCESS_KEY_ID; AWS_SECRET_ACCESS_KEY; AWS_DEFAULT_REGION; AWS_BUCKET; AWS_ENDPOINT | Private staging bucket, least-privilege bucket credentials, HTTPS endpoint. No public bucket or storage symlink. |
| CLOUDINARY_CLOUD_NAME; CLOUDINARY_API_KEY; CLOUDINARY_API_SECRET | Separate staging public-media account/folder. |
| MAIL_HOST; MAIL_USERNAME; MAIL_PASSWORD; MAIL_FROM_ADDRESS | Staging mail on TLS port 2525; verify sender and delivery. Change MAIL_PORT only to another allowed supported port. |
| RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID; RECAPTCHA_ENTERPRISE_API_KEY; RECAPTCHA_VENDOR_WEB_SITE_KEY; RECAPTCHA_ADMIN_WEB_SITE_KEY | Separate staging keys, exact generated portal hostnames, existing authentication controls retained. |
| GOOGLE_OIDC_CLIENT_ID; GOOGLE_OIDC_CLIENT_SECRET | Separate staging OAuth application. Callback below. Optional if Google sign-in is not used. |
| FRONTEND_BUYER_REDIRECT_URI | Set to `materyalph://auth/callback` so the Buyer app receives the short-lived Google sign-in exchange code. This is the app deep link, not Google's OAuth redirect URI. |
| GOOGLE_MAPS_SERVER_API_KEY | Backend-restricted key, separate from browser/mobile keys. |
| XENDIT_SECRET_KEY; XENDIT_WEBHOOK_VERIFICATION_TOKEN | **TEST credentials only**. Keep XENDIT_MODE=TEST and LIVE_COMMERCE_ENABLED=false. |
| FIREBASE_PROJECT_ID; FIREBASE_SERVICE_ACCOUNT_JSON_BASE64 | Separate staging Firebase project for native push, if used. Web push remains off. |
| SENTRY_LARAVEL_DSN | Optional staging monitoring; no provider payloads or credentials in logs. |
| STAGING_BOOTSTRAP_ADMIN_EMAIL | Optional operator action: enter the intended initial admin address to queue the existing one-time audited invitation. Configure working mail first. Remove after successful bootstrap; no default admin/password is created. |

Set `PRIVACY_CONTACT_EMAIL` to the project's approved contact before accepting legal documents in staging. Leave development demo credentials and production accounts out of this deployment.

For both static sites:

- `VITE_API_BASE_URL=/api/v1` and `VITE_APP_ENV=staging` are already declared.
- Set `VITE_RECAPTCHA_SITE_KEY` to that portal's staging public site key, matching the API settings.
- Set `VITE_GOOGLE_MAPS_BROWSER_KEY` to a browser-restricted key for that portal's exact hostname.
- Never put APP_KEY, Passport private keys, provider secrets or service-account JSON in any `VITE_` variable.
- Public Firebase web settings can be added later only after the existing web-push approval requirement is satisfied.

### Google sign-in and reCAPTCHA for staging

The screenshots show missing provider configuration, not a missing sign-in button implementation. The Vendor button calls the Laravel OAuth flow. The Admin portal intentionally has no Google sign-up: Admin accounts remain invitation-only and use password plus mandatory authenticator TOTP. reCAPTCHA protects Vendor and Admin web auth. Buyer mobile has no reCAPTCHA integration; risky Buyer email/password or recovery requests can use the backend email step-up proof.

In Google Cloud, use a separate staging project:

1. In **Google Auth Platform → Branding**, set the staging app name and support/developer contact. Set **Audience** to **External**, keep publishing status **Testing**, and add the Google accounts that will test sign-in. The current flow requests only `openid`, `email`, and `profile`.
2. In **Google Auth Platform → Clients**, create one **Web application** OAuth client for the Laravel server-side Authorization Code with PKCE flow used by Vendor web and Buyer mobile.
3. Add this exact **Authorized redirect URI** (no trailing slash):
   `https://materyalph-staging-vendor.onrender.com/api/v1/auth/google/callback`
   The API entrypoint derives it from the assigned Vendor hostname. If Render assigned a different hostname, use that hostname in both Google Cloud and Render's actual URL settings. This server-side flow does not need a JavaScript origin or separate Android/iOS OAuth clients.
4. In the existing API service's Render Environment, set `GOOGLE_OIDC_CLIENT_ID` and `GOOGLE_OIDC_CLIENT_SECRET` from that Web client. Keep the secret only on the API. Also set `FRONTEND_BUYER_REDIRECT_URI=materyalph://auth/callback`. The current API service was provisioned directly and is not linked to a Blueprint, so enter this value in Render; `render.yaml` now declares it for a future Blueprint adoption. Restart/redeploy the API after changing these values. The Buyer app build must use the public staging API URL.
5. For web CAPTCHA, enable **reCAPTCHA Enterprise API** in the same staging project. Create two separate **Web → Checkbox** keys and leave **Disable domain verification** turned off:
   - Vendor key: `materyalph-staging-vendor.onrender.com`
   - Admin key: `materyalph-staging-admin.onrender.com`
   Enter only the hostname, without scheme, path, port, or wildcard. Separate keys keep each portal restricted to its own generated domain.
6. Create a dedicated API key restricted to **reCAPTCHA Enterprise API**. In the API's Render Environment set `RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID`, `RECAPTCHA_ENTERPRISE_API_KEY`, `RECAPTCHA_VENDOR_WEB_SITE_KEY`, and `RECAPTCHA_ADMIN_WEB_SITE_KEY`. The API entrypoint derives the exact allowed hostnames from the Render portal services. Keep the API key on the API only.
7. On the Vendor and Admin static services, set each `VITE_RECAPTCHA_SITE_KEY` to its matching public site key. These are build-time values, so redeploy/rebuild both static sites after saving them. `RECAPTCHA_ENABLED=true` is already declared in the staging environment; leave it enabled so bot protection stays enforced.

Google allows development/testing/staging OAuth apps to remain unverified, but Testing mode limits access to added test users and applies a 100-user cap. Render's shared `onrender.com` domain is not yours to verify; use a custom domain you control before publishing OAuth for production. Google currently lists up to 10,000 reCAPTCHA Essentials assessments per month per organization at no charge; check the project's current quota and billing tier before wider use.

## 3. Generated URLs and cookie authentication

The generated API, Vendor, Admin and Reverb URLs are listed in the live preview table above. A name collision in another workspace may append a suffix; the YAML's names are not proof of an assigned URL.

Both portals proxy `/api/v1/*` to the API before their `/* -> /index.html` SPA fallback. This keeps browser auth cookies on each portal's own hostname. Confirm the API destination in `render.yaml` matches the actual generated API URL, then sync that correction.

The API derives the two portal URLs from Render service references and configures exact CORS/reCAPTCHA/Reverb host allowlists. Its Nginx host mapping uses only those known Origin/Referer hosts so signed private-file URLs retain the portal's origin. Secure host-only cookies, HttpOnly authentication cookies, CSRF, signature expiry and authorization checks remain in force. Authenticated private-file behavior still needs acceptance after deployment.

Configure external dashboards with the actual URLs:

- Google web OAuth callback: `https://<vendor-host>/api/v1/auth/google/callback`.
- Reverb: `wss://<reverb-host>:443`. Free services cannot accept private-network traffic, so the API broadcasts to Reverb's public HTTPS host.
- Xendit TEST webhook destinations: use the existing API webhook routes listed in `services/api/routes`; set the corresponding TEST verification secret. Do not invent a single replacement webhook path.
- Browser maps, reCAPTCHA and optional Firebase: exact portal host allowlists, no wildcards.

No custom domain is required.

### Imported accounts and authenticator decryption

A database copied from development carries encrypted authenticator secrets and key-bound hashes. A different staging `APP_KEY` cannot decrypt those secrets; the API logs `DecryptException: The MAC is invalid` and MFA returns the generic internal-error response. Keep the staging key stable. Do not copy the development key into Render or disable MFA.

For an authorized import repair, decrypt only the affected authenticator records locally with their original key and re-encrypt the same plaintext with the existing staging key. Validate every record first, use one transaction with deterministic row locks and conditional updates, preserve enrollment/revocation/replay state, and append audit records containing no secrets or ciphertext. Verify staging decryption before committing. If external database access is necessary, temporarily allow only the operator's IP and restore the original allowlist afterward. Never print keys, setup secrets, recovery codes, connection strings or password hashes.

On 2026-10-20, all **39 active imported authenticator records** were repaired this way and verified readable with the staging key. Their original secrets and replay state were preserved; 39 `MFA_IMPORTED_SECRET_REENCRYPTED` audit records were added. External database access was disabled again. Fresh authenticated browser sign-in still requires manual acceptance. Cancel any expired MFA attempt and sign in again using a fresh authenticator code.

The imported database also has **45 Argon2i password hashes**. The login implementation accepts a correct legacy Argon2i password and upgrades its hash to the configured Argon2id format only after bot protection and current-account checks. Wrong passwords, pending bot challenges and concurrent password resets cannot trigger an upgrade. MFA remains required. This code must be deployed before password sign-in for these imported accounts works on an API still running the old verifier; new passwords continue to use Argon2id.

Validation for this repair: 117 synthetic encryption assertions; 4 password unit tests with 14 assertions; 80 related isolated PostgreSQL API tests with 858 assertions, covering login, bot protection, MFA, recovery, invitations, account security and transport isolation. PHPStan, scoped Pint, OpenAPI validation, Compose configuration, the changed-file secret scan and whitespace checks passed. OpenAPI retained its eight unused-model recommendations. No schema migration, API payload or generated-client change was needed. Authenticated browser/device acceptance remains pending.

Imported recovery codes and existing sessions are bound to the original application's key and cannot be migrated from their hashes. After signing in, regenerate recovery codes through **Settings → Security**, complete the required recent authentication, and save the newly issued set offline. Use a fresh sign-in instead of relying on imported sessions.

## 4. First startup and later deployments

Free compute has no supported paid pre-deploy release step or shell. On **API startup only**, the entrypoint invokes the staging release script before starting the server/worker/scheduler. It:

1. Refuses any environment except staging, Xendit TEST and live commerce disabled.
2. Applies pending migrations with `migrate --force`; never drops or fresh-migrates data.
3. Seeds only required reference records on a database with no users or agreement records. Existing reference versions are preserved on later restarts.
4. Optionally invokes the existing one-time admin invitation command when the operator sets STAGING_BOOTSTRAP_ADMIN_EMAIL.

The worker uses `queue:work`, matching the current repository. Horizon is not installed by this deployment. The scheduler uses `schedule:work` while the API container is running. No paid worker/cron is provisioned.

Free compute does not support a custom shutdown delay. The worker has a 20-second timeout, supervisor allows 25 seconds to stop, and Redis retries only after 120 seconds. Long jobs can fail/retry under these preview limits; do not use the preview for durable commercial processing.

Initial Blueprint creation can start independent builds together. Later GitHub releases deploy API first (including startup migration), then Reverb, then the two static sites. For future schema changes use additive, backward-compatible migrations; a code rollback does not reverse database changes.

### Enable subsequent GitHub deployments

In GitHub's protected **staging** environment, add secret:

- `RENDER_STAGING_API_KEY`: staging-scoped automation credential, entered through GitHub's secret UI.

Add environment variables:

- `RENDER_STAGING_WORKSPACE_ID=tea-db8ouuc9v7es73dc3u7g`
- `RENDER_STAGING_SERVICE_IDS`: JSON mapping `api`, `reverb`, `vendor`, `admin` to their actual Render service IDs.
- `STAGING_API_URL`, `STAGING_VENDOR_URL`, `STAGING_ADMIN_URL`: actual plain HTTPS origins, with no path or query.

Example structure only (replace every ID):

```json
{"api":"srv-REPLACE","reverb":"srv-REPLACE","vendor":"srv-REPLACE","admin":"srv-REPLACE"}
```

Finally set repository variable `RENDER_STAGING_CONFIGURED=true`. It is a repository variable because the deployment job's condition is evaluated before environment variables are loaded.

Merge approved changes into staging, or dispatch **quality gates** on staging. Keep Render auto-deploys off. Never send a deploy-hook URL or automation key through chat.

## 5. Acceptance and rollback

CI HTTP smoke checks cover health, unauthenticated-session denial, SPA login routing, same-origin proxy responses, secure host-only CSRF cookies, preserved POST requests and missing-CSRF rejection. They do not sign in, test payments or prove private storage, mail or device behavior.

Before calling staging functional, manually verify:

- Vendor registration/email verification/login/refresh/logout and Admin invitation/MFA.
- Cross-portal session isolation, denied role access, signed private-file expiry and authorization.
- Mail/outbox delivery and scheduled actions while awake; behavior after API sleep/Redis restart.
- Reverb delivery with polling fallback after sleep.
- Provider TEST webhooks, callback signature validation and replay handling using sandbox credentials.
- Actual S3/Cloudinary access controls and provider failures.
- Scan-dependent upload workflows remain blocked on this Free topology; do not bypass this gate.

For a bad code release, redeploy the previous known passing SHA for all four services after reviewing migration compatibility. Do not run `migrate:rollback`, `migrate:fresh` or restore an old database automatically. A database export/restore requires a separate reviewed procedure.

Buyer remains a native Flutter app, not a Render-hosted service. For a manually distributed internal Android preview, use only public staging settings in an ignored config and build with the actual API URL:

```powershell
Set-Location apps/buyer-mobile
flutter build apk --debug --dart-define=API_BASE_URL=https://<actual-api-host>/api/v1
```

This is a debug preview, not a signed store release. Verify maps, Firebase, device sign-in and provider callbacks separately.

## Checks and outstanding gates

See the [deployment readiness record](staging-readiness.md) for the actual check results and blockers from this setup.

The [deployment readiness record](staging-readiness.md) records the checks and live smoke results actually observed. The CI gate has not passed, no Render Blueprint object is linked, authenticated user/provider acceptance remains pending, and scan-dependent uploads remain unavailable on this Free topology. This preview does not complete Phase 19 or represent production readiness.
