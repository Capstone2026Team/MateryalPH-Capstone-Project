# Quality gates repair - 9 November 2026

Reviewed [GitHub Actions run 121](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/42546238645) at commit `5a9140afa6903d11bb791b8d4f862ae4407e8f76`.

## Failures and repairs

| Failed gate | Cause | Repair |
| --- | --- | --- |
| Dependency audits | Nine Composer advisories affecting six Symfony packages; one high npm advisory in contract tooling | Update only the affected Symfony patches and `follow-redirects` in their lockfiles. Laravel remains unchanged. |
| Laravel tests | Badge discovery fixture created an active Store without placing it within the search radius | Locate the fixture explicitly and assert the Vendor exists before checking its public badges. |
| Admin component tests | Three tests still expected an enforcement navigation link | Assert the current enabled subject-bound enforcement button. Existing dialog behavior tests continue to run. |
| Flutter format/tests | Unformatted quotation test, off-screen sign-out action, missing golden PNGs, incomplete Work Package map fixture | Format the test, bring Sign Out into view, complete the arrangement-options mock, reject unexpected error content, and add 69 reviewed golden PNGs. |
| Responsive browser tests | Shared card borders lost to CSS layer ordering; wide review tables and long buttons expanded narrow pages | Register the Tailwind layer order before shared card CSS; use shrinkable grid tracks and bound shared buttons to their container. |
| Responsive browser tests | Old labels, default dates, thread routes and fixture fields; measurements before fonts/layout settled; live reCAPTCHA moving the registration form after focus | Align fixtures and accessible selectors with the implemented workflows, fix the notification clock, wait for fonts or the rendered catalog view, account for two metric rows on narrow desktop screens, and render an inert provider fixture in the registration layout test. |

## Changed files and boundaries

- Production changes: `services/api/composer.lock`, `packages/api-contract/package-lock.json`, and shared `button.tsx`, `portal-card.css`, `queue-workspace.css` in `packages/web-ui/src`.
- Regression updates: one API feature test, one Admin component test, three Buyer test files and the affected Vendor/Admin Playwright specs plus their shared card assertions.
- New baselines: 69 PNGs under `docs/design/evidence/{buyer-account-refinement,buyer-messaging,phase-6,phase-7,phase-8,phase-10,phase-14,ranking-influence,ui-refinement}`. These are required test inputs. Incidental browser screenshots are excluded from the change.
- No migrations, API request/response changes, generated-client edits, new environment keys, authorization changes, commercial formulas or deployment changes. No workflow gates were disabled or skipped.

## Local validation

| Check | Result |
| --- | --- |
| `composer audit --locked --no-interaction` | Passed; no advisories |
| `npm audit --audit-level=high` in contract tooling, generated TypeScript, shared UI and both portals | Passed; no high/critical advisories. Three moderate findings remain in contract tooling and two in each portal. |
| API Pint | Passed, 909 files |
| API PHPStan | Passed, no errors |
| API isolated PostgreSQL tests | All 1,232 cases accounted for across two non-overlapping runs: 1,231 passed, one existing warning; 28,036 assertions. The omitted 39 classes contain 333 cases, all passed. |
| Vendor lint / typecheck / build | Passed |
| Vendor `npm run test -- --run --maxWorkers=1` | 99 files, 934 tests passed |
| Admin lint / typecheck / build | Passed |
| Admin `npm run test -- --run --maxWorkers=1` | 53 files, 398 tests passed |
| Buyer `dart format --output=none --set-exit-if-changed lib test` | Passed; 291 files, zero changes |
| Buyer `flutter analyze --no-pub` | Passed; no issues |
| Buyer `flutter test --no-pub --concurrency=2 --reporter=expanded` | 686 passed, one skipped |
| Responsive Playwright, eight viewports (320-1920px) | All 1,168 cases covered across split runs. Final checks: 24 registration repeats and 24 dashboard/onboarding/inventory cases passed with zero retries. |
| `npm run validate` in `packages/api-contract` | Passed; eight existing unused-model recommendations |
| `docker compose config --quiet` | Passed |
| `gitleaks git --staged --redact --no-banner` | Passed; no staged changes |
| Gitleaks scan of all changed source/lockfiles | Passed; no leaks |
| `git diff --check` | Passed |

Backend checks use `compose.test.yaml`, project `materyalph_phase1_test`, after the isolation guard and Passport key checks. Development data is not used. Local Docker directory discovery omitted 39 test classes: an explicit list of all 134 files discovers the expected 1,232 cases. The first run reports 898 passed and one warning (18,878 assertions); the omitted classes report 333 passed (9,158 assertions), with no concurrent database test runs. The second invocation exits 1 solely because Artisan supplies its own `--configuration` before the explicit temporary configuration, triggering a PHPUnit runner warning. None of its 333 cases failed. The corrected direct invocation, `vendor/bin/phpunit --configuration <temporary-config.xml>`, passed its password-recovery smoke check (one case, 20 assertions, exit 0) without that warning. This is separate from the 1,232-case totals above; the full 333-case chunk was not repeated merely to remove the caller warning.

The PDF pagination case that warned in the hosted run also passes on its own locally: `vendor/bin/phpunit tests/Unit/TabularDocumentRendererTest.php --display-warnings --colors=never` reports one passed case, six assertions and exit 0. The broad-run warning is retained in the totals rather than treated as a clean full-suite result.

The browser run was interrupted after its first four viewport groups. Its 320px, 1920px and 1440px groups completed all 438 cases; the later run covers the remaining five viewports. That later run initially reported 725 first-attempt passes, four retry passes and one registration failure. The registration defect was then corrected and all eight registration cases passed three consecutive attempts without retries. A separate 24-case run verifies the corrected summary height checks, onboarding measurements and inventory scrolling at all eight viewports, without retries. The later run's non-registration retries were an Admin dashboard navigation error (`ERR_NO_BUFFER_SPACE`) and two proof-preview timeouts; each passed on retry. These remain recorded as retries. Browser fixtures use synthetic map/provider responses; the registration fixture never issues a challenge response or submits authentication.

Validation logs and incidental screenshots are retained locally in ignored `.tmp/ci-repair/`. These local checks do not establish a successful hosted GitHub run or live provider/device acceptance. No changes have been pushed; the next GitHub Actions run must verify Linux goldens and the complete hosted gates.

Suggested commit: `fix(ci): repair security and regression quality gates`
