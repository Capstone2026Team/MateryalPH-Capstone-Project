# Phase 15 verification evidence

All screenshots and rendered documents in this directory use synthetic demonstration fixtures. They contain no private evidence, device tokens, provider payloads or credentials.

## Visual review

- Vendor and Admin preferences/exports: 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. The 16 Playwright checks passed. Requests were mocked; these are layout and interaction checks, not live backend or provider evidence.
- Buyer preferences: 320px at normal and 2x text scaling. Both widget checks passed; the enlarged view scrolls to reach content. Required notices have an explanation rather than disabled switches.
- `purchase-order.pdf` and `tax-package.pdf` were generated using the actual Laravel/Dompdf renderer, rasterized and visually inspected. Mixed column counts initially clipped; the shared template was corrected and rendered again. Both documents fit one page and retain the SAMPLE/DEMO and non-tax-invoice labels. PNGs are matching review previews.
- Reproduce the synthetic PDFs with `php scripts/phase15-render-samples.php` from a PHP runtime with the installed Laravel dependencies. The script does not query business data.

## Recorded checks

| Check | Recorded result |
| --- | --- |
| Focused API notifications/exports/payment/fulfillment/disputes | 39 passed, 1,280 assertions |
| Additional export, Project, tax reminder and FCM adapter checks | 9 passed, 110 assertions |
| Concurrency cleanup regression | 5 passed, 128 assertions |
| Default API discovery run | 198 passed, 2,607 assertions; this did not discover every phase feature file |
| Explicit comprehensive API run | 565 tests, 9,590 assertions; four isolated function-recreation errors and two changed expectations identified; corrected suites are rerun separately below |
| Final export acceptance run | 7 passed, 118 assertions; includes immutable history and the corrected isolated migration hook |
| Final affected API regression run | 124 passed, 1,752 assertions in 3:27; notifications, FCM adapter, inventory/delivery, onboarding, finance, order/threshold/team concurrency and schema checks |
| Vendor full suite | 33 files, 255 tests passed |
| Admin full suite | 15 files, 48 tests passed |
| Shared notification component tests | 3 passed |
| Browser Phase 15 suite | 16 passed across eight viewport sizes |
| Buyer focused transport/account/navigation and Phase 15 screens | 25 passed in the final single-worker run |
| Buyer Phase 15 screen checks | 2 passed |
| Buyer full run | 285 passed, 1 skipped, 6 failed: five Phase 6/7 golden differences and one test-load connection failure; the latter passed in the subsequent single-worker focused run |
| Buyer analysis | No issues found |
| PHPStan | No errors |
| Pint | 631 files passed after correcting three test-file formatting issues |
| Portal lint/typecheck/build | Both passed; existing bundle-size advisories remain |
| OpenAPI | Valid with three unused-model recommendations; Phase 15 contract check passed |
| Composer security audit | No security vulnerability advisories |
| Source secret scans | No leaks in API application/config/migrations/templates, Buyer source, portal source, shared web UI and contract scripts |
| Compose | `docker compose config --quiet` passed |

The five unresolved Buyer visual baselines are the Phase 6 Tier 1 details/about/reviews captures and Phase 7 Explore 390px/320px captures. Their baselines were not overwritten to conceal differences.

The first correction run was stopped after identifying that Laravel suppresses console-command events in unit tests. The isolated cleanup now listens to the actual migration event, removing only detached Phase 15 trigger functions immediately before their migration. Applied migration files remain unchanged; production execution does not use this test hook.

The final corrected runs total 131 passing tests and 1,870 assertions. All six issues reported by the earlier comprehensive API run were covered by these reruns. The full 565-test invocation was not repeated after the corrections; its earlier result is retained above rather than relabeled as passing.

## Commands

API commands run inside the isolated stack:

```powershell
$compose = @('--env-file', 'services/api/.env.testing', '-f', 'compose.test.yaml', '-p', 'materyalph_phase1_test')
docker compose @compose up -d --wait
docker compose @compose exec -T api-test vendor/bin/pint --test
docker compose @compose exec -T api-test vendor/bin/phpstan analyse --memory-limit=512M
$tests = @(Get-ChildItem services/api/tests -Recurse -Filter '*Test.php' | ForEach-Object { [IO.Path]::GetRelativePath((Join-Path (Get-Location) 'services/api'), $_.FullName).Replace('\', '/') })
docker compose @compose exec -T api-test php -d memory_limit=512M vendor/bin/phpunit @tests
```

Final correction commands, inside `api-test`:

```sh
php -d memory_limit=512M vendor/bin/phpunit --stop-on-error tests/Feature/Api/PhaseFifteenExportsTest.php
php -d memory_limit=512M vendor/bin/phpunit --stop-on-error tests/Feature/Api/PhaseFifteenNotificationsTest.php tests/Feature/Api/PhaseFifteenPushAdapterTest.php tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php tests/Feature/Api/PhaseThreeVendorOnboardingTest.php tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Feature/Api/OrderConcurrencyTest.php tests/Feature/Api/PhaseElevenThresholdConcurrencyTest.php tests/Feature/Api/VendorTeamConcurrencyTest.php tests/Feature/OnboardingFoundationSchemaTest.php
```

The explicit file list verifies every suite, including phase files absent from the default discovery output. The default PHP 128 MB limit exhausted memory in the comprehensive image-fixture run; the direct PHPUnit command uses 512 MB.

From each portal: `npm run lint`, `npm run typecheck`, `npm run test -- --run`, `npm run build`.
From Vendor: `npx playwright test e2e/phase-15-notifications.spec.ts`.
From the API contract: `npm run validate` and `npm run test:notifications-contract`.
From Buyer: `flutter analyze`; `flutter test --concurrency=1 test/notifications_api_test.dart test/phase15_notifications_screen_test.dart test/buyer_account_test.dart test/auth_presentation_test.dart test/buyer_profile_test.dart`.

## Runtime boundaries

Development migration status was read without applying changes: the first two Phase 15 migrations were pending; the third history-guard migration was then added and is also unapplied to development. No deployment, commit, credential rotation, development reset or seed was performed. No Git commands were used.

Physical-device FCM/APNs, approved-origin web push, real email, native release packaging and live database/UI integration still require environment setup and runtime verification. See the [setup and acceptance plan](../../../test-plans/phase-fifteen-notifications-exports.md). No artifact is evidence of a real BIR filing or receipt.
