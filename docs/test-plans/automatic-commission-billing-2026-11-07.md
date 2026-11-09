# Automatic commission billing and combined Admin workspace

Owner request: remove routine per-Vendor approval, automate commission credits, and combine Commission management with Vendor commission payment transactions.

## Result

- The monthly scheduler creates and issues a bill for each Vendor with billable completed orders. The five-minute recovery command also creates missing monthly bills, issues existing drafts, and recovers executed dispute credits. Both commands are idempotent. Disputed assessments remain held, and no fee is earned for cancelled estimates.
- Issuance records `issuance_origin=SYSTEM`, freezes the existing invoice snapshot/hash, and schedules one mandatory Owner notification and invoice email. Due dates remain the fifteenth, or twelve days after late issue. This automates billing; it does not debit a Vendor account.
- Executed dispute awards automatically credit the saved commission rate and cumulative returned materials value excluding VAT. Credits use the existing balanced reversal, original statement allocation, and original fee-capture refund path. A unique remedy reference and append-only execution record prevent duplication, including zero-delta recoveries. Legacy source-linked proposals are resolved by recovery. Manual corrections and tax adjustments keep their independent approval rules.
- Admin Commission management contains a compact rate summary, read-only Vendor bills, and the shared online-payment ledger. Routine draft editing/approval controls and the credit approvals panel are removed. Old Transactions/Payments URLs still open the combined workspace.
- Commission payments retain successful platform-account captures only, including their confirmed refunds. Payment dates, refund-outcome filters, pagination, and matching private PDF/CSV reports use the same server query. Buyer order payments remain outside this ledger. Exports require `finance.view`, `finance.export`, and the existing recent-authentication gate; Vendor finance remains Owner-only.

## Files and contract

Migration: `services/api/database/migrations/2026_11_07_140000_automate_dispute_commission_credits.php`. Adds system issuance provenance, conditional human/system adjustment constraints, a unique dispute-remedy adjustment reference, and append-only `commission_credit_executions`. Rollback refuses to discard automation history.

Backend: `StatementService`, `CommissionService`, `DisputeFeeCredits`, receipt integration, scheduler commands, Admin finance query/controller, `ExportAccess`, and `DocumentSnapshot`. UI: Admin `FinancePages.tsx`, `CommissionFinancePanels.tsx`, finance transport, component tests, and the existing responsive browser fixture. System/Admin/Vendor workflows, architecture, and the UI/UX planner record the owner decision.

OpenAPI adds optional commission-payment `status` and documents Admin commission transaction exports and automatic billing. Generated TypeScript/Dart clients were regenerated; no response shape changed.

## Verification

| Check | Result |
| --- | --- |
| Guarded isolated Docker setup, including negative isolation checks | Passed. API tests used only `materyalph_phase1_test`. |
| `php artisan test --compact --no-ansi tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Feature/Api/PhaseThirteenDisputesTest.php tests/Unit/PhaseElevenFinanceRulesTest.php` | **63 passed, 1,529 assertions.** Includes automatic bills for two Vendors, duplicate runs/Owner notices, immutable snapshots, legacy credit recovery, provider-confirmed refund completion, status/date filtering, report parity, and authorization. |
| Pint on 13 affected PHP files; full PHPStan with 512 MB limit | Passed; PHPStan checked 595 files with no errors. |
| Admin lint, typecheck, and production build | Passed. Existing large-bundle warning remains. |
| Focused Admin Finance and transport tests | **21 passed.** |
| Full Admin component suite | **356 passed, 1 timed out** in the unchanged Vite configuration test at its five-second limit. That test passed separately with `--testTimeout=30000` in 7.87 seconds. No timeout setting was changed. |
| Responsive combined-finance scenario | **8 passed** at 320, 375, 390, 768, 1024, 1280, 1440, and 1920 px. Checks combined navigation, read-only bills, detail-dialog focus restoration, payment ledger, exports, live status query serialization, and overflow. Desktop/mobile screenshots were visually reviewed. The final run with `--reporter=line` exited successfully in 44.3 seconds; the preceding HTML-reporter run passed all assertions but stalled during cleanup. |
| OpenAPI validation, generated TypeScript build, Admin Finance transport contract | Passed; eight existing unused-model recommendations remain. |
| Generated Dart Admin Finance and Reporting API analysis | Passed, no issues. |
| Compose validation, targeted diff whitespace checks, source and staged Gitleaks scans | Passed; no leaks. The staged scan had no staged commits. |

## Local readiness and remaining acceptance

The new migration ran successfully against the existing local development schema; isolated tests exercised creation from an empty schema. The local scheduler is running and lists both monthly billing and five-minute recovery. A read-only aggregate check after recovery found **one automatically issued local bill and zero remaining drafts**. The running Admin Vite server returns the updated generated commission method with status-filter serialization.

No new environment keys are required. Nothing was deployed, pushed, or merged. Invoice mail uses the existing notification/outbox/mail setup. Fake-provider tests and local notification records do not prove external mailbox receipt or live payment settlement; that acceptance remains separate. No production throughput benchmark was run. Buyer/Vendor application suites were not rerun because their runtime source was unchanged; affected generated Dart compatibility was checked.

Suggested commit: `feat(finance): automate commission billing and unify admin payments`
