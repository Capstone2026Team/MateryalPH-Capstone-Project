# Commission statements and platform invoice email

Owner-requested scope: move published commission statements from Transactions into Commission monitoring, compact statement details, and email a downloadable SAMPLE/TEST platform service invoice on issue.

## Behavior and boundaries

- Commission monitoring displays overview, billing/payment totals and the issued statement list together on desktop, with narrow-screen stacking, server pagination, issue-date filters and local retry/empty states.
- Statement list PDF/CSV exports retain the issue-date filters. Compact summary amounts use two columns on narrow screens.
- Legacy `/finance/transactions?tab=STATEMENTS` URLs preserve dates and statement pagination when redirected. Details return to that monitoring context.
- Statement details retain the recorded totals, original rates, signed credits and payment history. Issued positive balances retain partial-payment validation, idempotency, provider attempts/status checking and authorized PDF export. Settled and voided statements have no empty payment rail.
- Issue captures an immutable JSONB snapshot and SHA-256 hash. The existing post-commit outbox schedules one Owner notification/email; drafting does not. The worker stores one immutable `PLATFORM_SERVICE_INVOICE` record and private generated PDF, then verifies file ownership, MIME, CLEAN state, length and both PDF hashes before attaching bytes.
- Duplicate delivery jobs do not resend a completed delivery. A failed/corrupt attachment retries without generating a second invoice. Revoked Owner access prevents delivery. Existing mail activation cutoffs and retry/failure records apply.
- Issued snapshots retain their original billing name, period, due date, rates, fees and reductions after store changes, payments or subsequent adjustments. Database protections reject mutation/deletion of a published snapshot. Original invoices are unique per statement; correction records remain supported by the existing invoice model.
- PDFs and mail remain SAMPLE/TEST. No live charge, registered tax invoice, BIR filing, bank/escrow function or financial formula is introduced.

## Migration and validation

`2026_11_06_230000_capture_issued_platform_fee_invoices.php` adds the frozen statement snapshot/hash, database history protection and a partial unique index for original platform invoices. The paid-history follow-up below adds an optional read filter to the existing list and export contract; response shapes remain unchanged.

Focused coverage lives in `PhaseElevenFinanceFlowsTest`, Vendor `FinancePages.test.tsx` and `commission-monitoring-layout.spec.ts`. Validate empty/current schema creation, immutable snapshots, private PDF attachments, issue-only delivery, retries, authorization, legacy navigation, filtered pagination, paid/unpaid layouts and eight browser widths.

Run the API checks only through the guarded `materyalph_phase1_test` stack. A fake/array mail test does not prove mailbox receipt; perform a controlled Owner mailbox acceptance with the configured mail provider before release. Development migration readiness is separate from isolated test migrations.

## Completed verification — 6 November 2026

| Check | Result |
| --- | --- |
| Isolated API guard: `pwsh -NoProfile -File scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning -SkipComposer -SkipBuild` | Static/live isolation and negative guard checks passed. |
| `php artisan test --compact --no-ansi tests/Feature/Api/PhaseElevenFinanceFlowsTest.php` in guarded `api-test` | 15 tests passed, 487 assertions. |
| `php artisan test --compact --no-ansi tests/Feature/Api/PhaseFifteenNotificationsTest.php` in guarded `api-test` | 7 tests passed, 32 assertions. |
| New invoice delivery test rerun after final PDF layout adjustment | 1 test passed, 38 assertions. Included in the Finance suite count above. |
| `vendor/bin/pint --test` on the nine affected PHP files; `vendor/bin/phpstan analyse --memory-limit=512M` | Passed. |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run src/pages/FinancePages.test.tsx`, `npm.cmd run build` | Passed; 45 component tests. |
| Vendor `npm.cmd run test:e2e -- e2e/commission-monitoring-layout.spec.ts` | 40 passed at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. Includes Owner restriction, retry/empty states, combined billing help, legacy navigation, paid/unpaid details and overflow checks. |
| Admin lint, typecheck, Finance component tests and production build | Passed; 12 component tests. Shared styles are scoped to commission/statement surfaces. |
| Contract `npm.cmd run validate`; `docker compose config --quiet` | Passed. No OpenAPI or generated-client changes. |
| Gitleaks on copies of all 16 affected source/test files; `gitleaks git --staged --redact --no-banner`; targeted `git diff --check` | Passed; no leaks. Staged scan had no staged changes. |
| PDF and synthetic HTML email review | Invoice rendered and visually reviewed as one A4 page for the 13-order example with a credit. HTML mail fit at 700, 375 and 320 px. Desktop/mobile monitoring and paid/unpaid detail screenshots reviewed. |

Existing warnings remain: Vendor's unrelated unused `inStore` test variable, large frontend bundles, Vitest's existing transform/jsdom navigation messages and eight unused OpenAPI model recommendations. They did not fail these checks. Unrelated application suites and live provider/mailbox acceptance were not run.

The new migration also ran successfully against the normal local development API (batch 74), and its queue worker was restarted and confirmed running. Isolated tests exercised migration from an empty test schema; the development run exercised the existing schema. No statement was issued and no real email was sent during development readiness checks. Previously issued statements are not retroactively emailed or backfilled by this change. No new environment key is required; delivery uses the configured mail provider and existing activation cutoff.

## Controlled mailbox acceptance still required

With an authorized test Owner mailbox and the existing mail provider configured, issue a new TEST statement through the normal preparer/reviewer flow. Confirm one email arrives with a downloadable PDF, the original period/fees/credits and SAMPLE/TEST notice; open its authenticated statement link and compare the current balance. Confirm the PDF can be saved in the recipient's mail client. Do not treat fake mail assertions or synthetic browser previews as proof of Gmail/Outlook delivery.

## Paid statement history follow-up — 6 November 2026

- The Commission statements panel now has a History button instead of its date control. Fully PAID statements appear in the shared compact FormDialog. Its issue-date filter, PDF/CSV exports, pagination, loading, retry and empty states remain inside the popup.
- The main panel requests other published states. Partially paid bills stay visible; voided records retain their existing accessible status/detail link. No financial state, payment calculation or invoice email behavior changes.
- History opens only on request. Its URL keeps the selected dates and history page when opening a statement and returning. Changing dates resets only history pagination. Escape closes a nested date picker first, then History; background scroll locking and trigger focus restoration are retained.
- The existing Owner-only transaction list and CSV export accept optional `statement_state=PAID|NOT_PAID`. The filter applies before counting, pagination and export bounds; other tabs ignore it and omission retains the previous all-published behavior. Document PDF/CSV exports validate and preserve the same filter. Original statement states are unchanged. OpenAPI and generated TypeScript/Dart clients were updated; no additional migration or environment key is required.
- Changed surfaces: Vendor `FinancePages.tsx`, its tests, finance transport adapter and responsive browser fixture; shared `finance-overview.css`; `VendorFinanceService`, Vendor Finance/Reporting controllers, `DocumentSnapshot` and Finance API tests; OpenAPI/generated clients, portal-date contract checks and workflow/design documentation.
- Validation: Finance API suite **16 passed / 531 assertions**, including the new history test **44 assertions** for multiple pages, inclusive dates, matching CSV/document exports, Manager rejection and cross-store isolation. Vendor Finance component suite **47 passed**. Responsive commission suite **40 passed**; after the compact popup styling, its history/detail scenario passed again at all **eight widths**, including nested date-dialog Escape, body scroll lock, trigger focus, overflow and modal/detail return context. Vendor lint, typecheck and production build, generated TypeScript build, Pint on five affected PHP files, full PHPStan, OpenAPI validation and portal-date/payment contract checks passed. Existing lint, bundle, Vitest and unused-model warnings are unchanged.
- Generated Dart finance client analysis also passed with no issues. Source Gitleaks scan found no leaks; the staged scan had no staged changes. Targeted diff whitespace checks passed. Desktop (1440 px) and narrow (320 px) popup screenshots were reviewed. No additional manual setup or blocked gate remains for this read-only history change; the earlier invoice mailbox acceptance remains separate.
