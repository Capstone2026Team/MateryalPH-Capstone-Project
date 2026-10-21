# Railway Hobby + Vercel Hobby staging runbook

Accepted decision: [ADR 0002](../adr/0002-railway-vercel-staging.md).
First read the [cost worksheet](railway-cost-worksheet.md). This runbook is an
implementation, not evidence of a completed deployment. Existing Render resources
stay in place during acceptance. Production launch and app-store release are separate.

## Connections

| Client | API | Realtime |
| --- | --- | --- |
| Buyer Flutter | Railway HTTPS origin + `/api/v1` | Railway Reverb WSS, API-supplied configuration |
| Vendor Vercel project | Same-origin `/api/v1` rewrite to Railway | Direct Railway Reverb WSS |
| Admin Vercel project | Same-origin `/api/v1` rewrite to Railway | Direct Railway Reverb WSS |

All clients share one Laravel API/database. Private channel authorization and
polling recovery stay unchanged. Web cookies remain Secure/HttpOnly, host-only
with SameSite=Lax and existing CSRF checks. Leave `SESSION_DOMAIN` unset; never
set it to the Railway domain. Google sign-in retains the shared Vendor-origin
`/api/v1/auth/google/callback`, then `materyalph://auth/callback` for Buyer and a
one-time exchange directly with Railway. Configure the exact callback in Google's
staging sign-in client; the separate Gmail sender client never signs buyers in.
Payment-return deep links remain hints; the server verifies payments with Xendit TEST.

## Account and cost gate

Connected inventory on 2026-10-21: Railway personal workspace
`7d82ada0-8646-47a9-a5fa-1e90e7e99c7c`; Vercel Hobby scope
`team_QGHyryXdT2jrHm8ke5uJDgig`. Both had no projects. Vercel returned no GitHub
namespaces. Connect the eligible personal GitHub owner and grant access to the
private artifact repository before creating the two Git-linked Vercel projects.
Do not connect the organization monorepo directly to Hobby or spoof commit authors.

Approve the worksheet and configure the agreed Railway notifications/hard limit
before applying metered resources. Confirm Hobby is active. Create one private
`materyalph-staging` project, staging environment, Singapore, one deployment owner.
Use staged configuration to review resources before accepting deployments.

## Railway services and secrets

Create exactly `api`, `worker`, `scheduler`, `reverb`, `postgres`, `redis`.
Each uses repository root `/` and its own
`infrastructure/railway/<role>.json` **config-file path**. That setting must be
selected on each service; Railway does not discover six files automatically.
Use the tested source SHA, disable independent Git auto-deploys, and retain all IDs.
Normal releases upload only the four application roles. Database/image upgrades
and persistent volume changes are separate reviewed operations.

Attach PostgreSQL at `/var/lib/postgresql/data` (PGDATA includes `/pgdata`) and
Redis at `/data`. Measure source sizes before choosing capacity; initial worksheet
sizes are 2 GB and 1 GB, below Hobby's 5 GB per-volume allowance. Do not expose their
TCP ports permanently. New Railway environments support private IPv4 and IPv6;
these images listen on IPv4. PostgreSQL uses `POSTGRES_DB=materyalph_staging`,
`POSTGRES_USER=staging_owner` and a separate generated `POSTGRES_PASSWORD`. Set a
different generated `STAGING_DB_PASSWORD` on PostgreSQL; initialization creates
`materyalph_app`, a non-superuser schema owner used by the API, release and restore.
Wire that password to the applications' `DB_PASSWORD`; never use the cluster-owner
password in an application role. Initialization also installs the three extensions.
The PostgreSQL startup script generates a private, persistent TLS key/certificate.
Set `POSTGRES_TLS_HOST` to the assigned temporary import TCP hostname before first
startup; the certificate also covers the private service hostname. Copy only the
public certificate through authenticated Railway SSH/file transfer for the import
client's trust store. Track its one-year expiry and renew it in a reviewed maintenance
window. Never expose the private key. API traffic requires TLS over the private network.
Redis uses
a separate generated alphanumeric `REDIS_PASSWORD`, at least 32 characters,
AOF/everysec and noeviction. Redis memory exhaustion must fail jobs visibly rather
than evict sessions or queue data. Observe AOF rewrite overhead before reducing limits.

Use [the backend variable template](../../infrastructure/railway/.env.example) and
`services/api/.env.example`. Enter credentials directly in Railway secret fields:

- Separate staging APP_KEY and Passport signing keys; never copy development keys.
- Private PostgreSQL/Redis hosts and credentials, shared consistently across four roles.
- Reverb app ID/key/secret, HTTPS host/port 443, public host/port/scheme. Keep secrets backend-only.
- Exact generated Vendor/Admin hosts; startup derives CORS, Reverb origins, role-specific
  CAPTCHA host allowlists and the shared Google callback. Set frontend URLs explicitly
  too, since the release command runs before normal runtime derivation.
- Gmail sender authorization below, Xendit TEST, Google OIDC, role-specific CAPTCHA,
  Maps/Firebase and Cloudinary staging settings. Keep `APP_DEBUG=false`,
  `LIVE_COMMERCE_ENABLED=false`, secure cookies and sensitive-log redaction enabled.
- Private encrypted S3 in Singapore. New writes use `s3`; imported `local` and `public`
  disks use private prefixes `imports/local` and `imports/public` when
  `STAGING_LEGACY_FILES_ON_S3=true`. Existing `s3` keys retain their original keys.

Keep `STAGING_RELEASE_APPROVED=false`, `STAGING_DATA_READY=false` and
`STAGING_JOBS_ENABLED=false` during import. Do not start crash-looping app roles;
create/configure them staged and activate PostgreSQL/Redis first. The sole migration
entrypoint is the API's pre-deploy `staging-start release`, explicitly approved only
after restore/recovery. Runtime restarts never migrate or seed. API runs only nginx,
PHP-FPM and freshclam; worker/scheduler are continuously running independent roles.
SIGTERM reaches each role through tini/exec; worker timeout 90 seconds is below Redis
retry_after 150 and shutdown draining 110. Scheduler overlap is zero.

ClamAV definitions update in the API container. A fresh deployment can reject uploads
until definitions are ready, which preserves fail-closed behavior. Confirm freshclam
success and representative upload memory before acceptance. Scanner unavailability,
infected objects and oversized/invalid content must never bypass scanning.

## Gmail HTTPS sender authorization

Create a separate Google Cloud project, enable Gmail API, and configure a separate
OAuth client for the staging sending mailbox. Follow Google's
[web-server OAuth flow](https://developers.google.com/identity/protocols/oauth2/web-server)
with offline access and only `https://www.googleapis.com/auth/gmail.send`.
Authorize the selected sender mailbox securely in Google's consent UI; end users
never authorize mailbox access. Capture the refresh token directly into an ignored
local credential file or Railway secret field, never chat, logs, source or screenshots.
Use a redirect URI you control and registered on that OAuth client.

Set backend-only `GMAIL_API_CLIENT_ID`, `GMAIL_API_CLIENT_SECRET`,
`GMAIL_API_REFRESH_TOKEN`, `MAIL_MAILER=gmail_api`, and `MAIL_FROM_ADDRESS` matching
the authorized mailbox. Configure `MAIL_DELIVERY_NOT_BEFORE` as the approved UTC
activation instant (`YYYY-MM-DDTHH:MM:SSZ`) before enabling delivery. The transport
requires the cutoff; old outbox requests remain suppressed by existing policies.
SMTP development TLS/sender validation stays unchanged.

Resolve consent/publishing requirements before unattended delivery: external OAuth
apps in Testing normally get seven-day refresh tokens for this scope. See
[token expiry](https://developers.google.com/identity/protocols/oauth2#expiration)
and [Gmail scopes](https://developers.google.com/workspace/gmail/api/auth/scopes).
For revoked authorization, pause delivery and reauthorize the same mailbox using
the same send-only flow, replace the refresh token securely, then retry only current
policy-eligible work. Do not repeatedly replay ambiguous send timeouts; Gmail
acceptance is not confirmed inbox delivery. Access tokens are refreshed server-side;
network deadlines are bounded and provider errors have no sensitive exception chain.

## Snapshot, private files and recovery

Stop local writers and background jobs for a coherent database-and-file snapshot;
leave the source data and its keys unchanged. Confirm its schema matches the tested
source commit. Exported database rows share one read-only PostgreSQL snapshot with
pg_dump, so counts and encrypted recovery entries match the archive.

On Windows PowerShell 7 with Docker Desktop, from the repository root:

```powershell
./scripts/deployment/export-staging.ps1
```

This creates a new ignored `.tmp/staging-import-<batch>` directory containing a
PG16 custom archive, checksums, row counts, referenced-file manifest and object bytes,
encrypted recovery entries and a **new staging APP_KEY** in a separate protected file.
Never publish this directory as CI artifacts or include it in a Docker build.
Copy the new key securely into Railway; the source key never leaves the source host.
Existing import maps are excluded from the dump and regenerated directly under the
new key, avoiding unsupported fallback chains. No immutable business record changes.
Taxpayer canonical grouping hashes are retained; TOTP values remain usable.

Create a new empty Railway database, keep all app roles stopped, and enable a
temporary TLS database connection only for this import. Store PGHOST/PGPORT/PGUSER/
PGPASSWORD/PGDATABASE/PGSSLMODE in an ignored `.tmp/railway-pg.env`, with
`PGDATABASE=materyalph_staging`, `PGSSLMODE=verify-full` and
`PGSSLROOTCERT=/backup/postgres-ca.crt`. Put the authenticated copy of the public
server certificate in the batch directory as `postgres-ca.crt`; confirm its SHA256
fingerprint through the authenticated Railway session. Do not paste a connection URL
into a command line. Run with the exact assigned host and batch path:

```powershell
./scripts/deployment/restore-staging.ps1 -BatchDirectory .tmp/<batch> `
  -TargetEnvFile .tmp/railway-pg.env -ExpectedHost <assigned-tcp-host> `
  -ExpectedDatabase materyalph_staging
```

The restore aborts on unexpected destination objects, verifies artifact checksums
and uses PG16 pg_restore with a single transaction and explicit database. It never
drops a target schema. Close temporary public database access immediately afterward.
An existing destination requires a separately reviewed backup/reconciliation plan.

Configure a dedicated private encrypted AWS S3 staging bucket in `ap-southeast-1`
with public access blocked and least-privilege object credentials. Use an existing
approved staging bucket if available; otherwise approve its budget and provision
it before file copy. A protected `.tmp/staging-s3.json` contains Laravel's S3 disk
fields (`driver`, `key`, `secret`, `region`, `bucket`); use a different bucket from
the local MinIO/source bucket. From the source API container:

```powershell
docker compose exec -T api php /workspace/scripts/deployment/staging-transfer.php `
  copy-files /workspace/.tmp/<batch> /workspace/.tmp/staging-s3.json
```

Each file is verified against its recorded SHA/size, uploaded privately with AES256
encryption and downloaded to verify its SHA. Existing destination objects are checked
and never overwritten. Cloudinary references/assets remain unchanged. Unsupported
legacy disks, missing objects or checksum failures stop the import.

Securely copy only `ready.json`, `recovery.jsonl`, `counts.json` to an ignored
`/app/.tmp/<batch>` directory on a one-off staging image/container connected to the
Railway private database; use authenticated SSH/file transfer, never public URLs.
Run `php /app/scripts/deployment/staging-transfer.php recover /app/.tmp/<batch>`.
It validates the target key, all restored counts and every ciphertext fingerprint,
then appends recovery entries in one transaction. It requires an empty recovery table
and never updates commercial, financial, tax, dispute or audit history.

Recovery also revokes imported sessions/refresh tokens/trusted devices, invalidates
old OTPs and marks imported unused recovery codes consumed, with an append-only
staging audit entry. Require recovery-code regeneration through the existing
authenticated MFA flow. Confirmed TOTP factors remain available. No imported user
keeps an active session.
Review pending outbox, mail, push, payment/provider jobs before enabling processing;
an email cutoff alone does not suppress every non-email provider action. Do not import
the development Redis queue. Set activation cutoffs for existing providers as required.

After counts/recovery/file validation, approve the API release, run migrations once,
and check PostGIS/pg_trgm/pgcrypto and `/up` plus `/api/v1/health`. Enable
`STAGING_DATA_READY=true`. Enable jobs only after the pending-work review and current
provider configuration. Enable supported scheduled volume backups in Railway,
record retention and capacity, and prove an isolated PG16 restore before cutover.
Keep encrypted off-platform logical snapshots where required by the approved budget.

## Tested builds and Vercel publishing

Create private personal repository `<personal-owner>/materyalph-staging-portals`,
initialized with a README on `main` before its first artifact publication.
The protected GitHub `staging` environment holds secrets `RAILWAY_STAGING_TOKEN`
(scoped to this Railway project/environment) and `PORTAL_PUBLISH_TOKEN` (fine-grained
personal-owner token, contents read/write to this artifact repository only).
Use repository variables `RAILWAY_PROJECT_ID`, `RAILWAY_ENVIRONMENT_ID`,
`RAILWAY_STAGING_SERVICE_IDS` (JSON object with api/worker/scheduler/reverb IDs),
`RAILWAY_API_ORIGIN`, `PORTAL_DEPLOY_OWNER`, and reviewed exact `RAILWAY_CLI_VERSION`.
Keep `RAILWAY_STAGING_CONFIGURED` unset until the import, secrets and budget controls
are verified. Restrict the environment to the protected `staging` branch.

After all required CI checks pass, the enabled release job builds both portals with
`VITE_API_BASE_URL=/api/v1`, rejects source maps/hidden/unexpected artifacts, uploads
the exact clean source checkout to the four Railway app roles, waits for healthy
deployments, then publishes compiled Vendor/Admin directories and source SHA metadata.
The publisher verifies the token belongs to the personal repository owner and uses
that owner's legitimate GitHub noreply identity; never a forged identity.

Create two Vercel projects on that repository's `main` branch, root directories
`vendor` and `admin`, framework Other, no install/build command, output `.`.
Only generated HTTPS staging domains are needed. First use the compiled package
produced from the passing SHA to create the Git-linked projects; future owner-authored
artifact commits trigger Vercel. Verify both deployed `release.json` files match the
backend's recorded tested SHA. API-first rewrites precede SPA fallback and disable
API caching. Do not upload backend code, env files, private files or source maps.
Ensure Vercel deployment protection permits intended staging testers and Google
callbacks; review that setting explicitly, since protected previews may reject them.

## Buyer preview and acceptance

Copy `apps/buyer-mobile/config/staging.example.json` to ignored `config/staging.json`,
set the assigned Railway `/api/v1` URL and required **public** Firebase/Maps values.
From `apps/buyer-mobile`: `flutter build apk --debug --dart-define-from-file=config/staging.json`,
or use `./scripts/deployment/build-buyer-staging.ps1` from the repository root.
The APK is `apps/buyer-mobile/build/app/outputs/flutter-apk/app-debug.apk`.
No computer, adb reverse, tunnel or shared Wi-Fi is needed after installation.

Accept only after all repository gates and affected adapter/deployment tests pass,
then test portal cookies/CSRF/isolation, private signed files, clean/infected/unavailable
scanning, the largest supported upload through Vercel (120-second external proxy
limit), Gmail OTP/recovery/invitations with a designated test mailbox, queue/scheduler,
realtime disconnect/reconnect plus polling, and an actual Android Buyer sign-in,
discovery/order/message reaching the correct Vendor and authorized Admin views.
Physical-device/provider/hosted acceptance is separate from automated fake-based tests.

After Railway receives writes, roll back application code against its database.
Returning to Render's older dataset requires reconciliation. Retain Render until
acceptance; do not delete it or publish app-store builds as part of this migration.
Upgrade this same Railway project to Pro later to preserve data and client endpoints.
