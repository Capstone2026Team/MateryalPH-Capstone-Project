# Admin user performance monitoring — 7 November 2026

## Outcome

- Remove Score & Badge Monitoring from the Admin sidebar and replace its old directory route with a redirect to Vendor Users.
- Vendor Users shows published VPS; Buyer Users shows the canonical CCS. Unpublished states retain New Vendor and Building your rating without a fabricated score.
- Each authorized user detail includes Performance Monitoring. Vendor monitoring reuses the Store Performance score cards, automatic badges, CRR/FRR and interactive score history. Source events, investigations and badge history are grouped into separate tabs.
- Buyer monitoring shows CCS, its three criteria, rolling eligibility count and separate account activity context.
- Existing score-detail URLs remain usable by score-only Admin roles and return to Dashboard without loading directory contact data.

## Changed implementation

- Admin `UserDirectoryPages.tsx`, `TrustPages.tsx`, `PhaseThreeAdminPages.tsx` and their directory/trust component tests.
- Shared `store-performance-summary.tsx`, `store-performance-overview.tsx` and exports in `packages/web-ui/src/index.ts`. The Vendor `TrustPages.tsx` uses the same score presentation while retaining its supplemental operational-metric and store-health requests and permissions.
- `BuyerRatingSummary.php` batches the existing CCS query for a bounded directory page. `ReviewQueries.php` and `UserDirectoryService.php` reuse it; the directory service also batches the existing public Vendor score projection.
- `AdminUserDirectoryTest.php`, the directory contract checker, OpenAPI and generated TypeScript/Dart clients/serializers.
- The Admin workflow and UI/UX planner record this placement decision.

No migrations, changed scoring formulas, new role grants or manual setup/key names.

## API and authorization

Existing GET endpoints gain additive fields: Buyer directory rows/profiles include `rating` (`BuyerRatingSummary`); Vendor directory rows include nullable `vps`; Vendor profiles include `can_view_scores`. Admin score detail documents already-returned rating components, completed-order counts and OHS calculation dates.

Directory access remains `user_directory.view`. Full Vendor monitoring calls the existing `scores.view` endpoint only when its authorized section opens. Support directory access does not grant that endpoint. All exclusion/suppression/reversal mutations retain server-enforced `scores.investigate`, recorded reasons, idempotency, append-only history and their existing API routes. No private coordinates, exact inventory or new financial data is introduced.

## Verification

- Admin focused directory/trust component tests: **34 passed**.
- Final full Admin suite with `npm.cmd run test -- --run --maxWorkers=2`: **329 passed across 48 files**; lint, typecheck and build also passed in the same final run.
- Vendor full component suite: **904 passed across 93 files**. The existing jsdom navigation diagnostic was nonfatal.
- Admin and Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build`: passed. Vendor lint retains an unrelated unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`; builds retain large-chunk warnings.
- Isolated API: `php artisan test --compact tests/Feature/Api/AdminUserDirectoryTest.php tests/Feature/Api/PhaseFourteenReviewsScoresTest.php`: **29 passed, 748 assertions**. Includes publication gates, the CCS time window, hidden/ineligible ratings, consistency with Buyer Profile, published VPS, access denial and existing investigation flows.
- `php vendor/bin/pint --test` on the four changed PHP files: passed. Full `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress`: no errors.
- `npm.cmd run validate`: passed with eight existing unused-schema recommendations. Directory contract: **8 operations passed**; trust contract: **43 operations passed**.
- TypeScript client generation/build and Dart client/serializer regeneration: passed. Dart analysis of the five changed directory/score model files: no issues.
- Development and isolated-test `docker compose ... config --quiet`: passed.
- `git diff --check`: passed. Staged gitleaks scan found no leaks, with no staged content; a direct redacted scan of the changed source/test files also found no leaks (213,021 bytes).

The first full Admin run had 328 passing tests and one Vite server-start test exceeding its 5-second timeout; that test passed independently. The final full run with `--maxWorkers=2` passed all 329 tests.

The host API run could not resolve the Compose-only `postgres-test` hostname and completed no assertions. The results above are from the guarded isolated PostgreSQL test service. Explicit test-file paths were used because this environment's class-name filter returned no tests.

## Remaining visual acceptance

The browser access host and native Computer Use pipe were unavailable; a retry confirmed browser unavailability. Desktop/mobile screenshots and live user-session interaction were therefore not verified in this task. No live exclusion, badge suppression or reversal was submitted.

When the browser is available, check Vendor/Buyer lists and each Performance Monitoring section at 1440 px and 390 px (including unpublished ratings), source pagination, calculation-dialog keyboard focus and read-only/investigation roles. Confirm that same-row VCS/MQS/OHS cards align and the page has no horizontal overflow beyond its labelled scrollable tables.

Suggested commit: `feat(admin): move performance monitoring into user management`
