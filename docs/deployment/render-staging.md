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

The Render connector lists resources, but does not apply Blueprints. The Render CLI validates a Blueprint; initial application uses the Dashboard.

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

After the staging branch passes CI, open:

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

## 3. Generated URLs and cookie authentication

Record the **actual** API, Vendor, Admin and Reverb URLs from Render. A name collision may append a suffix; the YAML's names are not proof of the assigned URLs.

Both portals proxy `/api/v1/*` to the API before their `/* -> /index.html` SPA fallback. This keeps browser auth cookies on each portal's own hostname. Confirm the API destination in `render.yaml` matches the actual generated API URL, then sync that correction.

The API derives the two portal URLs from Render service references and configures exact CORS/reCAPTCHA/Reverb host allowlists. Its Nginx host mapping uses only those known Origin/Referer hosts so signed private-file URLs retain the portal's origin. Secure host-only cookies, HttpOnly authentication cookies, CSRF, signature expiry and authorization checks remain in force. Authenticated private-file behavior still needs acceptance after deployment.

Configure external dashboards with the actual URLs:

- Google web OAuth callback: `https://<vendor-host>/api/v1/auth/google/callback`.
- Reverb: `wss://<reverb-host>:443`. Free services cannot accept private-network traffic, so the API broadcasts to Reverb's public HTTPS host.
- Xendit TEST webhook destinations: use the existing API webhook routes listed in `services/api/routes`; set the corresponding TEST verification secret. Do not invent a single replacement webhook path.
- Browser maps, reCAPTCHA and optional Firebase: exact portal host allowlists, no wildcards.

No custom domain is required.

## 4. First startup and later deployments

Free compute has no supported paid pre-deploy release step or shell. On **API startup only**, the entrypoint invokes the staging release script before starting the server/worker/scheduler. It:

1. Refuses any environment except staging, Xendit TEST and live commerce disabled.
2. Applies pending migrations with `migrate --force`; never drops or fresh-migrates data.
3. Seeds only required reference records on a database with no users or agreement records. Existing reference versions are preserved on later restarts.
4. Optionally invokes the existing one-time admin invitation command when the operator sets STAGING_BOOTSTRAP_ADMIN_EMAIL.

The worker uses `queue:work`, matching the current repository. Horizon is not installed by this deployment. The scheduler uses `schedule:work` while the API container is running. No paid worker/cron is provisioned.

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

The implementation report records which checks actually ran. Do not infer a passing remote CI run, authenticated Render validation, successful Blueprint sync or live deployment from this document. Provider secrets, repository protections and the upload limitation remain explicit gates.
