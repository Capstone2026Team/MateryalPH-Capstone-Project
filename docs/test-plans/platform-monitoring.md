# Platform Monitoring — 7 November 2026

The Admin `/integrations` page is now **Platform Monitoring**. It uses compact white metrics, a local-logo console strip for Hostinger hPanel, Duck DNS, Backblaze, Google Cloud and Xendit, connected-service status, scheduled tasks and recovery activity. Mobile uses two-column console/metric grids. Analytics/reference details are expandable. Configuration and event status remain distinct from provider uptime, and the actual TEST commerce label is preserved.

## Implementation

- Admin presentation: `IntegrationHealthPages.tsx`, navigation in `PhaseThreeAdminPages.tsx`, `AdminPlaceholderPage.tsx`, and the reference in `GeoAnalyticsPage.tsx`.
- Shared components: `packages/web-ui/src/service-consoles.tsx`, its local service marks and provenance README, and the package export. External console links open safely in a new tab; authenticated pages do not fetch logo images from third-party servers.
- Recovery: `AutomaticOperationRecovery`, `JobHealthService`, `OperationsQueueService`, and the minute-based `materyalph:operations-recover` schedule in `routes/console.php`.
- Additive migration: `2026_11_07_170000_automate_operational_recovery.php`. Adds a constrained per-event recovery counter and allows a null retry actor only for SYSTEM outbox recovery records. Existing history and foreign keys are preserved. The migration intentionally does not remove recovery history on rollback.
- Contract: optional `automatic_recovery` metadata on IntegrationOverview, plus `recovery_status`, `recovery_attempts` and `next_retry_at` on OperationFailure. Existing queue measurement shapes, routes and permissions remain intact. Both TypeScript and Dart clients/serializers were regenerated from OpenAPI and built.
- Tests: Admin page/component tests, responsive `admin-integration-health.spec.ts`, API recovery tests, Phase 16 API assertions, and TypeScript/Dart contract checks.

## Recovery rules

The existing idempotent outbox allowlist controls automatic recovery. Three additional cycles use cooldowns of 15 minutes, 1 hour and 6 hours after the latest failure; an active dispatcher lease can defer eligibility. The cycle counter survives scheduler restarts. The processor cache lock and PostgreSQL row lock prevent simultaneous recovery/processing. Reset, correlated failed-job cleanup, retry history and audit history commit together. The normal dispatcher performs subsequent queue delivery, outside the database lock.

Malformed, unrelated, unapproved and protected payment/refund/credential/invitation jobs are not replayed. Imported staging side effects stay quarantined. Exhausted limits remain visible. Recovered document/export work keeps its immutable source snapshot and processing-time authorization checks. Completed canonical work may resolve a stale correlated queue failure without replay, with an audit entry. SYSTEM retry activity is visible without inventing a human actor.

The page displays the scheduler's actual recorded health, including missing, failed and overdue runs. Failure dates and pagination remain available. Manual queue retry buttons are removed; existing reasoned, authorized analytics re-runs and compatible backend endpoints remain available.

## Verification

| Check | Result |
| --- | --- |
| Isolated API: `php artisan test tests/Feature/Operations/AutomaticOperationRecoveryTest.php tests/Feature/Api/PhaseSixteenAdminOperationsTest.php --compact` | 21 passed, 468 assertions |
| Isolated API after quarantine-state assertions: `php artisan test tests/Feature/Operations/AutomaticOperationRecoveryTest.php tests/Feature/Api/OutboxDeliveryTest.php tests/Feature/Api/PhaseFifteenExportsTest.php tests/Feature/Api/OrderDocumentsTest.php --compact` | 35 passed, 506 assertions; five recovery tests overlap the previous run |
| Admin: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed; build retains the existing large-chunk warning |
| Admin: `npm.cmd run test -- --run src/pages/IntegrationHealthPages.test.tsx src/pages/PhaseSixteenPages.test.tsx --maxWorkers=2` | 13 passed |
| Vendor: `npm.cmd run typecheck` | Passed after shared/client changes |
| Playwright: `npx.cmd playwright test e2e/admin-integration-health.spec.ts --workers=2 --reporter=list` | 16 passed at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px; local images loaded, no page overflow, no queue-retry POSTs |
| PHP Pint on the seven affected PHP files | Passed |
| PHPStan with `--memory-limit=512M` on AutomaticOperationRecovery, JobHealthService and OperationsQueueService | No errors |
| OpenAPI: `npm.cmd run validate` | Passed, with eight unused-schema recommendations |
| `npm.cmd run test:platform-monitoring-contract` | Passed, including generated TS dates, status and existing queue counts |
| `npm.cmd run test:admin-operations-contract` | Passed, 32 operations |
| Generated TypeScript: `npm.cmd run build` | Passed |
| Generated Dart: `dart run build_runner build` | Passed; 12 outputs written |
| Dart: `dart --packages=generated/dart/.dart_tool/package_config.json scripts/check-platform-monitoring.dart` from api-contract | Passed |
| `docker compose config --quiet` | Passed |
| `git diff --check` | Passed; repository line-ending warnings remain informational |
| `gitleaks git --staged --redact --no-banner` | Passed, zero staged bytes; not treated as coverage of unstaged work |
| Targeted nine-file source stream to `gitleaks stdin --redact --no-banner` | 82.31 KB scanned; no leaks |

Desktop and mobile screenshots were visually inspected. Browser tests use synthetic API responses, so they do not establish live provider uptime or payment acceptance. The full repository API/client suites and real-provider/device acceptance were not run for this scoped change.

## Local activation and release

Confirmed the normal API is in `development`, then successfully applied only the new migration with:

```powershell
docker compose exec -T api php artisan migrate --path=database/migrations/2026_11_07_170000_automate_operational_recovery.php --no-interaction
```

The existing scheduler recorded a successful recovery run at **7 November 2026, 11:50 PM Asia/Manila**. Two SYSTEM recovery cycles were recorded. The subsequent safe status read showed 49 failed jobs and 53 dead letters; the remaining dead-letter types were outside the approved replay allowlist (historical project/work-package events and a guest-support email). These counts are a point-in-time local observation, not a claim that all historical failures are repaired. Such rows stay visible for investigation instead of being silently deleted or replayed.

No new environment keys are required. Hosted environments still require the migration and normal scheduler/worker deployment lifecycle. No hosted deployment, push or merge was performed.

Suggested commit: `feat(admin): add platform monitoring and automatic queue recovery`

## VPS provider catalog and compact layout — 8 November 2026

This iteration supersedes the original separate console strip. The nine connected-provider cards are themselves safe external console links, using one shared catalog for logos, purpose and grouping. The directory uses the full page width with three desktop columns, two intermediate columns and a readable mobile list. Status, queues and recovery sit below it instead of beside a taller sidebar. Analytics stays expandable. There is no duplicate provider/link section or large empty left column.

The catalog covers Hostinger, Duck DNS, Backblaze B2, Brevo, Cloudinary, Bouncer malware scanning (usebouncer.dev), Google Cloud, Firebase and Xendit. Google Cloud combines Maps/Places/Routes, Google sign-in and reCAPTCHA Enterprise. Backblaze covers private storage and offsite backups. The protected prepared VPS `api.env` and `backup.env` were inspected through provider classification/presence checks only: all catalog providers were configured; Sentry was absent. The partial `services/api/.env.staging.providers` separately confirmed Brevo, Backblaze and Bouncer. No secret values were displayed or copied into source.

Hostinger's read-only account API confirmed the intended VPS is running. Read-only SSH then timed out, so current guest/runtime configuration and real provider connectivity remain unverified. The catalog follows the approved deployment configuration; it is not a claim of a successful live provider test. No firewall, hosted runtime, account setting or credential was changed, and no deployment was performed.

`JobHealthService` now returns safe `environment.deployment` metadata. Only `staging` with the approved `materyalph<number>-api/vendor/admin.duckdns.org` hostname pattern is classified as HOSTINGER_VPS. The response adds configuration/event checks for Backblaze B2, Cloudinary, Bouncer and reCAPTCHA on that deployment, and checks Brevo SMTP/Firebase configuration explicitly. Other environments retain their backend diagnostics, while this page displays a VPS-reference catalog without using local or Render statuses. Hostinger/Duck DNS have a neutral manage-in-console state, absent checks remain unknown, and a grouped provider reflects a degraded/unconfigured/simulated member instead of hiding it. Configuration presence is not uptime. Mailpit, MinIO, local ClamAV, self-hosted Reverb/OCR, disabled Sentry and the Render fallback are not external VPS provider cards.

Files changed in this iteration: the shared `service-consoles.tsx`/exports and Brevo, Cloudinary and Bouncer assets; Admin `IntegrationHealthPages` and its two component test files; responsive `admin-integration-health.spec.ts`; `JobHealthService` and `PhaseSixteenAdminOperationsTest`; OpenAPI descriptions and regenerated TypeScript/Dart clients; handwritten monitoring contract checks; workflow/planner/provenance/evidence documentation. No migration, credential change, new environment key, role change or automatic-recovery policy change is required.

| Final check | Result |
| --- | --- |
| `php artisan test tests/Feature/Api/PhaseSixteenAdminOperationsTest.php --compact` in the isolated Compose test environment | 18 passed, 459 assertions. An earlier run encountered transient missing-table/transaction failures; the isolated rerun passed all cases. |
| Admin `npm.cmd run lint` and `npm.cmd run typecheck` | Passed |
| Admin `npm.cmd run test -- --run src/pages/IntegrationHealthPages.test.tsx src/pages/PhaseSixteenPages.test.tsx --maxWorkers=2` | 15 passed |
| Admin `npm.cmd run build` | Passed, with the existing large-chunk warning |
| Vendor `npm.cmd run typecheck` | Passed |
| `npx.cmd playwright test e2e/admin-integration-health.spec.ts --workers=2 --reporter=list` | 16 passed across all eight 320–1920px viewports; all nine logos loaded, links/cards present, no page overflow and no manual retry POSTs |
| Pint on JobHealthService and PhaseSixteenAdminOperationsTest | Passed |
| PHPStan on JobHealthService with `--memory-limit=512M` | No errors |
| OpenAPI `npm.cmd run validate` | Passed, eight unused-schema recommendations |
| `npm.cmd run test:platform-monitoring-contract` and `npm.cmd run test:admin-operations-contract` | Passed; monitoring metadata retained and 32 Admin operations verified |
| Generated TypeScript build | Passed |
| Generated Dart `build_runner build` | Passed, six outputs written |
| Dart monitoring contract check | Passed |

Desktop and mobile screenshots were visually inspected after the compact-layout change. Full-repository suites and hosted/browser/device/provider acceptance remain outside this focused validation. Suggested commit: `feat(admin): show VPS providers in compact monitoring directory`.

### Owner correction: retain the original Integrations panel

The compact catalog initially replaced the original detailed integration list. This was corrected before completion: Overview now begins with the complete **Integrations** panel and keeps the VPS console cards below it. Every server-reported entry is rendered, without filtering/grouping away the original ten checks or any newer VPS checks. Separate Xendit payments/onboarding, Maps/sign-in, email/push, storage/scanning, Reverb, OCR and DTI-BPS entries retain full details, statuses, environment/provider labels and last-event times. Provider marks are local assets; backend/reference checks have meaningful icons. Compact marks, tighter spacing and responsive columns reduce whitespace without hiding fields. The shared ServiceLogo supports a compact size and fallback icon.

Admin component checks now pass **16 tests**, including a regression that requires all ten original entries, all diagnostics/provider labels, timestamp text and eight applicable provider logos. The responsive fixture includes all fourteen VPS/backend checks and explicitly requires Reverb, OCR and DTI-BPS to remain present. This correction changes presentation only; API, authorization, migrations and automatic recovery remain as validated above.

### Owner follow-up: combine integrations and providers

The latest layout replaces the two panels with one **Services & integrations** directory. Every reported integration keeps its own complete diagnostic text, status, environment and last-event time. Provider-backed entries now include their local logo and console link directly in the row; backend/reference checks retain meaningful icons. Missing catalog checks plus Hostinger/Duck DNS are added without inventing health. All nine provider consoles remain available, including Brevo email, Cloudinary media, Bouncer scanning, Google reCAPTCHA and Backblaze storage/backups. Local diagnostic details remain visible with clearly marked VPS-reference links. There is no second provider-card panel.

The shared `ServiceDirectory` replaces the separate page-local integration list and shared console-card list. The original ten-check fixture now requires sixteen combined entries; the fourteen-check VPS browser fixture also requires sixteen entries, with every original detail retained. Workflow/planner amendments reflect this latest combination request. No API contract, migration, credential, authorization, automatic-recovery or deployment change was made in this follow-up; no manual setup is required.

| Check after combination | Result |
| --- | --- |
| Admin `npm.cmd run lint` | Passed |
| Shared component `npx.cmd oxlint` with the absolute `service-consoles.tsx` path | No errors; two Fast Refresh export warnings for the existing catalog/helper exports. An initial relative-path invocation was rejected by the lint tool and rerun with the absolute path. |
| Admin and Vendor `npm.cmd run typecheck` | Both passed |
| Admin focused component tests for IntegrationHealthPages and PhaseSixteenPages, `--maxWorkers=2` | 16 passed |
| Admin `npm.cmd run build` | Passed; existing large-chunk warning |
| Responsive `admin-integration-health.spec.ts`, two workers | 16 passed across eight widths from 320 to 1920px; one combined section, all original details, nine linked providers, loaded logos, no page overflow and no manual queue mutations |
| Gitleaks on the eight changed source/test/documentation files | Passed; no leaks found |
| Scoped `git diff --check` | Passed |

The 1440px desktop and 390px mobile screenshots were visually inspected. Browser responses are synthetic fixtures, not live VPS/provider verification. Suggested commit: `refactor(admin): combine monitoring services and integrations`.

### Service and responsibility grouping — 8 November 2026

The combined directory now groups services under six functional roles: Infrastructure; Payments & onboarding; Storage & media; Maps & identity; Communication; and Verification & reference. Each service has one logo/icon, purpose and visible console link, with all its diagnostic checks below. Xendit's two checks and Google Cloud's three checks retain their independent states and complete details. Backblaze includes both provider configuration and file-processing diagnostics. The full VPS fixture has twelve service headers and sixteen checks, with exactly nine console links; Reverb, OCR and DTI-BPS remain present. Additional server-reported adapters appear under Other platform services instead of being discarded. Functional roles do not add user roles or permissions.

The layout uses dividers within the existing white panel, natural-height sections and balanced responsive columns: one on smaller screens, two on desktop and three on wide screens. Required diagnostics remain expanded. Console targets are at least 44px high and retain safe new-tab attributes; logos remain local assets. Local/runtime measurements remain distinct from deployed provider health, and missing measurements retain reference/unknown states.

Files changed for this refinement: shared `service-consoles.tsx`; Admin `IntegrationHealthPages.tsx` and its component tests; responsive `admin-integration-health.spec.ts`; Admin workflow, UI/UX planner and this evidence file. No API contract, migration, credential, permission, automatic-recovery or hosted deployment changes; no manual setup is required.

| Grouping validation | Result |
| --- | --- |
| Admin `npm.cmd run lint` | Passed |
| Shared component absolute-path `npx.cmd oxlint` | No errors; existing two Fast Refresh export warnings |
| Admin and Vendor `npm.cmd run typecheck` | Both passed |
| `npm.cmd run test -- --run src/pages/IntegrationHealthPages.test.tsx src/pages/PhaseSixteenPages.test.tsx --maxWorkers=2` | 17 passed, including role membership, individual diagnostic states, one console per provider, complete original metadata and retention of an additional adapter |
| Admin `npm.cmd run build` | Passed; existing large-chunk warning |
| `npx.cmd playwright test e2e/admin-integration-health.spec.ts --workers=2 --reporter=list` | 16 passed across eight widths from 320 to 1920px; six role sections, all sixteen checks, nine unique console controls with 44px targets, loaded logos, no page overflow and no manual queue mutation |

Screenshots at 320px, 1440px and 1920px were visually inspected. Browser checks use synthetic API responses and do not verify hosted provider availability. Suggested commit: `refactor(admin): group monitoring services by responsibility`.

### Compact group cards — 8 November 2026

Each functional group now has a separate white card under the Services & integrations heading, without a large outer card. Cards use 12px padding/gutters and their content height, with one column on small screens, two from the large breakpoint and three from the extra-large breakpoint. Service and diagnostic spacing is tighter; all nine provider links, twelve service headers and sixteen checks in the full fixture remain visible with full diagnostics, independent statuses, environment labels and last-event times. Console controls retain 44px targets, local logos and safe new-tab attributes. No diagnostics are collapsed, truncated or removed.

Platform Monitoring now uses the shared compact page header directly, tighter page/environment/summary spacing and compact supporting monitoring panels. `OperationsKit.Panel` has an opt-in compact treatment; other Admin panels keep their existing default. Analytics spacing is also tighter. Changed files in this refinement: shared `service-consoles.tsx`; Admin `OperationsKit.tsx` and `IntegrationHealthPages.tsx`; responsive `admin-integration-health.spec.ts`; workflow, planner and this report. There are no API contract, migration, environment-key, credential, authorization, automatic-recovery or deployment changes, and no manual setup is required.

| Compact-card validation | Result |
| --- | --- |
| Admin `npm.cmd run lint` | Passed |
| Shared component absolute-path `npx.cmd oxlint` | No errors; existing two Fast Refresh export warnings |
| Admin and Vendor `npm.cmd run typecheck` | Both passed |
| Admin focused IntegrationHealthPages/PhaseSixteenPages tests, `--maxWorkers=2` | 17 passed |
| Admin `npm.cmd run build` | Passed; existing large-chunk warning |
| Responsive `admin-integration-health.spec.ts`, two workers | 16 passed at eight widths from 320 to 1920px, including visible card surfaces, no stretched empty card bottoms, all sixteen checks/nine consoles, 44px links, loaded logos, no page overflow and no manual queue mutations |

The 1440px group-card screenshot and 320px full-page screenshot were visually inspected. Browser fixtures verify presentation, not live VPS/provider connectivity. Suggested commit: `style(admin): compact monitoring group cards`.

### Combined services card, left column and category colors — 8 November 2026

All service groups now sit inside one compact **Services & integrations** card. From the extra-large breakpoint, integration status, queues/outbox, automatic recovery and analytics/reference data occupy an 18rem left column, with the services card alongside. On smaller screens, services stay first and supporting panels stack below. Analytics/reference retains its existing expandable behavior and authorized re-run actions; no service diagnostics are collapsed. The directory's inner columns respond to its own available width: one below 600px, two from 600px and three from 1000px.

Each functional group has a distinct pale header tint and border accent using existing palette tokens: blue infrastructure, orange payments, teal storage, purple maps/identity, pink communication and brown verification. White diagnostic surfaces, dark labels and original health badges remain unchanged. Category color never claims health or modifies a server status. All original details, metadata, logos and nine provider console links remain available.

Changed files for this refinement: shared `service-consoles.tsx` and new `service-consoles.css`; Admin `IntegrationHealthPages.tsx`; responsive `admin-integration-health.spec.ts`; Admin workflow, UI/UX planner and this report. No migration, API contract, credential, environment key, permission or automatic-recovery changes. No deployment or manual setup is required.

| Combined-card validation | Result |
| --- | --- |
| Admin `npm.cmd run lint` | Passed |
| Shared component absolute-path `npx.cmd oxlint` | No errors; existing two Fast Refresh export warnings |
| Admin and Vendor `npm.cmd run typecheck` | Both passed |
| Admin focused IntegrationHealthPages/PhaseSixteenPages tests, `--maxWorkers=2` | 17 passed |
| Admin `npm.cmd run build` | Passed; existing large-chunk warning |
| `npx.cmd playwright test e2e/admin-integration-health.spec.ts --workers=2 --reporter=list` | 16 passed across all eight widths from 320 to 1920px; desktop left-column positioning, stacked smaller-screen order, one services card, six distinct category tints, sixteen checks, nine console links, expanded reference contents, 44px controls, loaded logos, no page overflow and no manual queue mutations |
| Final screenshot-capture check after removing sticky-header artifacts at 320px, 1440px and 1920px | 3 passed |
| Gitleaks on the seven changed source/style/test/documentation files | Passed; no leaks found |
| Scoped `git diff --check` | Passed |

The 1440px/1920px workspace and mobile screenshots were visually reviewed. Screenshot artifacts temporarily release the shell's scroll clipping/sticky header for capture; layout and overflow assertions run against the actual shell before that stylesheet applies. Browser responses are synthetic fixtures, not live VPS/provider acceptance. Suggested commit: `style(admin): combine monitoring workspace and color service groups`.
