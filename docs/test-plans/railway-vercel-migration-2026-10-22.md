# Railway/Vercel staging migration implementation review

Status: reviewable local implementation; **hosted migration and cutover are blocked**.
Decision: [ADR 0002](../adr/0002-railway-vercel-staging.md).
Operations: [runbook](../deployment/railway-vercel-staging.md).
Budget: [worksheet](../deployment/railway-cost-worksheet.md).

## Result and scope

Added six Railway role configurations and three Docker images; independent API,
worker, continuous scheduler and Reverb lifecycles; API-only guarded release;
PostgreSQL TLS and non-superuser application role; persistent authenticated Redis
with noeviction. Existing Render runtime is retained, with only a provider-neutral
release error message adjusted.

Added Gmail HTTPS mail transport and configuration, reusing the existing MailProvider,
Mailables and delivery policies. SMTP security checks remain. Added a protected
snapshot/export/restore/recovery workflow, legacy private S3 disk aliases, compiled
portal packaging/publishing and CI release gating. Added public-only Buyer staging
template and APK/run helper; README/architecture/agent guidance now reference the ADR.

No new business-schema migration or client-facing API contract change. The existing
immutable imported-encryption recovery table is reused. Original commercial/tax/history
records stay unchanged; recovery appends mappings and an audit event, revokes imported
access and invalidates old OTP/recovery codes. Development data was only inventoried
read-only. No actual snapshot import or external object copy has been performed.

## Verification performed

| Check | Exact result |
| --- | --- |
| Native API Pint, from services/api | Passed |
| Production PHPStan, 512 MiB | No errors |
| Gmail API transport unit suite, native and Docker | 16 tests / 40 assertions passed |
| New Gmail API integration + existing Gmail SMTP delivery suite | 36 tests / 129 assertions passed |
| Focused import/password recovery, notifications/realtime, scanning/upload regression | 36 tests / 380 assertions passed with explicit test-file paths |
| Deployment packaging/publishing/target guards | 8 Node tests passed |
| Railway JSON configurations | All six passed the downloaded official JSON schema and local topology guards |
| Final API, PostgreSQL and Redis images | Built successfully |
| Synthetic network-isolated runtime/import test | PostgreSQL TLS, non-superuser role, read-only shared snapshot + PG16 restore, MFA recovery under a separate key, audited access reset, duplicate recovery rejection, file SHA/legacy aliases, unchanged source and Redis AOF/noeviction passed |
| Existing nginx/FPM runtime regression against staging image | Passed ordinary requests, 25 MiB and >32 MiB multipart, file/request limits, 2 concurrent workers, health under load (2.3 ms), HEAD health, FPM failure detection and query redaction |
| Vendor lint/typecheck/test/build | Passed; 65 test files / 609 tests |
| Admin lint/typecheck/test/build | Passed; 26 test files / 155 tests |
| OpenAPI validation | Passed, 8 unused-model recommendations |
| Buyer flutter analyze | No issues |
| Buyer full flutter test | 469 passed, 1 skipped, **66 failed** |
| Full isolated API suite at 512 MiB | 689 tests / 12,945 assertions; **6 errors, 16 failures** |
| Secret scan of changed source files | No leaks in 46 changed files, including untracked implementation files in the final source scan; staged scan was empty |
| Deployment PowerShell parsing, CI YAML parsing | Passed |
| Retained Render configuration validator and Docker Compose configuration | Passed |

The initial full API run hit PHP's 128 MiB test-process memory limit; the complete
run above used `php -d memory_limit=512M vendor/bin/phpunit --colors=never` inside
the verified isolated test stack. No test guard or development database was bypassed.
The full suites are **not green** and deployment gating remains enabled.
Browser E2E, iOS checks, dependency audits and Trivy were not run locally; the
applicable CI gates remain required before release.

API errors are in `VendorEarningsTrendTest` (six cases). Failures span catalog role
access, Phase Ten Projects, dispute invoices, rate-limit expectations and Work Package
authoring/sourcing/specification tests. The focused migration/mail checks passed.
Buyer failures include discovery, procurement, project layouts and golden expectations.
The discovery test expecting `Location Details` at `map_discovery_test.dart:305`
also failed when rerun alone. This migration changes no Buyer Dart implementation.
Generated failure images were retained in ignored review output and the original
tracked fixtures restored. Existing portal bundle-size warnings remain non-blocking.

## Provider status and remaining setup

Railway and Vercel connections were verified. Vercel reports active Hobby with no
projects and no accessible GitHub namespaces. Railway had no projects. An authorized
private staging project creation was rejected with `Deploys have been paused temporarily`.
A subsequent inventory still showed no projects. The [official Railway status page](https://status.railway.com/)
confirmed a major incident affecting the dashboard/API and pausing builds across
regions, latest update October 21 at 13:40 UTC. No hosted resources were created or
started; Render was not changed or deleted.

Before metered provisioning: approve the worksheet and an explicit compute spending
limit, confirm its alerts/limit in Railway, and wait for the provider incident to clear.
The clarified user requirement is seven days a week for the whole month,
07:00-21:00 Asia/Manila, targeting US$5 on Railway. This is 420 operating hours in
30 days, or 434 in 31 days. The worksheet now illustrates a $14.12-$21.95 Railway
bill for a 30-day period before excluded costs, assuming all compute stops nightly.
The earlier 98-hour estimate applied to seven days total and has been superseded.
No daily start/stop automation or spending limit is configured. Correction verified
against Railway's usage CLI docs: the minimum nonzero compute hard limit is $10,
so the earlier $5 hard-limit suggestion was incorrect and has been withdrawn.
A $5 alert does not stop workloads; no higher budget has been approved. Reaching
a hard limit can take workloads offline before the survey ends; external
storage/provider/retained Render costs are separate. The current footprint is not
proven to fit the $5 target.
The earlier $25 alert / $40 hard-limit suggestion was not approved or configured.

Before release: resolve the required API/Buyer gates, make the reviewed source commit
available to CI, connect the eligible personal GitHub owner to Vercel, create/initialize
the private `materyalph-staging-portals` repository, configure protected publishing
credentials and project IDs, then provision the two portal projects and six backend roles.

Backend-only setup still requires verification of separate staging APP_KEY/Passport,
DB/Redis/Reverb, `GMAIL_API_CLIENT_ID`, `GMAIL_API_CLIENT_SECRET`,
`GMAIL_API_REFRESH_TOKEN`, authorized `MAIL_FROM_ADDRESS`, delivery activation cutoff,
private encrypted Singapore S3, and existing staging Google/Firebase/Maps/CAPTCHA/
Cloudinary/Xendit TEST settings. Enter credentials only through ignored files or
protected cloud/CI fields. Mailbox OAuth consent and refresh-token lifetime must be
resolved before unattended mail operation is accepted.

Real Gmail/provider delivery, hosted cookies/CSRF/private files, malware signatures,
largest uploads through Vercel's proxy, realtime reconnects, scheduler/queues, physical
Android journeys, real imported records/files and scheduled-backup restore remain
manual hosted acceptance. A Railway-configured APK cannot be distributed until its
actual API domain and public client settings are assigned. No app-store release is included.

Suggested commit: `feat(deploy): prepare Railway Hobby and Vercel staging migration`.
