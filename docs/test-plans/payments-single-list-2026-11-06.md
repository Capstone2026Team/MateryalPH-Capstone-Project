# One Payments list — 6 November 2026

## Result

Vendor Finance → Transactions now combines payments with their recorded remittance and withholding tax in one Payments list. Removed the separate Remittances and withholding tax tab. When there are no tax documents, the redundant single Payments filter chip is also omitted; issued Tax documents remain accessible.

Each payment retains its order link, payment method, status, original gross, confirmed refunds and net collections. The added Remittance & tax column shows recorded withholding, expected remittance and tax basis. Dates are grouped under the order with Asia/Manila stated explicitly, keeping the desktop list compact. The shared details popup preserves the assessment calculation, tax status, deduction evidence, reconciliation and timestamp, including original voided figures as history. Direct physical payments are explicitly not applicable; missing online assessments are explicitly not assessed.

Old `tab=REMITTANCES` UI links open Payments with dates and pagination preserved. The annual threshold's records link now targets Payments directly. The legacy REMITTANCES API stays available.

## Backend and contract

- Added recorded merchant-assessment fields to the existing Payments projection, matched by payment ID and checked against order and environment within the authorized Vendor scope.
- Linked assessments do not add a duplicate payment row. Historical assessments without a linked payment remain identified standalone records; current collections are not inferred for them.
- Pagination and ordering happen in the database before hydration. Payment-status filters exclude standalone assessment-only records. Current refunds and immutable assessment values remain distinct.
- CSV and PDF snapshots use the same projection. Mixed record types share one column order, preventing misaligned export values.
- Updated OpenAPI descriptions and regenerated TypeScript and Dart clients through `npm.cmd run generate`. The existing flexible transaction-row envelope is retained; clients were not edited by hand.
- No migration, financial formula, threshold rule, payment mutation, new permission, live-provider behavior or private-evidence exposure. Owner-only Finance authorization and TEST disclosures remain in place. No new key or manual setup is required.

## Files

- `apps/vendor-web/src/pages/FinancePages.tsx` and its component tests.
- `apps/vendor-web/e2e/finance-transactions-layout.spec.ts` and the annual-threshold link assertion in `finance-threshold-layout.spec.ts`.
- `packages/web-ui/src/finance-patterns.tsx`, `finance-overview.css` and `index.ts` for the shared assessment treatment and responsive styling.
- `services/api/app/Domain/Finance/VendorFinanceService.php` and `tests/Feature/Api/VendorEarningsTrendTest.php`.
- `packages/api-contract/openapi.yaml`, its Payments contract check and regenerated client documentation/comments.
- The UI/UX planner's single Payments-list instruction and this verification record.

## Verification

| Check | Exact result |
| --- | --- |
| Vendor Finance components: `npm.cmd run test -- --run src/pages/FinancePages.test.tsx --maxWorkers=2` | 62 passed |
| Admin Finance/Tax components: `npm.cmd run test -- --run src/pages/FinancePages.test.tsx src/pages/FinanceTaxPages.test.tsx --maxWorkers=2` | 20 passed |
| Isolated API: `php artisan test --compact --filter='VendorEarningsTrendTest\|test_finance_is_owner_only_across_routes_exports_and_dashboard_fields'` | 12 passed, 898 assertions |
| Final isolated Payments regression: `php artisan test --compact --filter=test_payments_include_their_recorded_assessment_once_and_keep_unlinked_history_scoped_and_filtered` | 1 passed, 59 assertions, including scoped list, original assessment values, CSV and PDF snapshot column alignment |
| Playwright transaction and annual-threshold suites at 320, 390, 768, 1024 and 1440px | 15 passed |
| Final transaction layout after grouping the date under the order, at 320, 390, 1440 and 1920px | 4 passed; final desktop/mobile screenshots inspected |
| Vendor and Admin lint, typecheck and production build | Passed; existing unused-variable warning in `admin-finance-layout.spec.ts` and bundle-size advisories remain |
| Changed PHP files: Pint; full PHPStan with `--memory-limit=512M --no-progress` | Passed; no PHPStan errors |
| OpenAPI validation; Payments and Admin Finance contract checks | Passed; eight existing unused-schema recommendations |
| Changed-file whitespace review and Gitleaks scan of the current affected sources | Passed; no leaks in 2.20 MB |

The final Finance component run emits JSDOM's existing navigation-not-implemented diagnostic for a download interaction and exits successfully. Two intermediate assertions were corrected during verification: the PDF uses the existing `Creditable withholding tax PHP` header, and the component check now identifies the final remittance cell after the separate date column was removed. Both final reruns pass.

Browser checks cover signed amounts, preserved order identifiers, no horizontal page overflow, desktop scrolling where needed, labeled mobile records, old-link redirects, voided-history handling and keyboard popup/focus restoration. Evidence is in `.tmp/finance-transactions-review/`.

Full API/portal suites and live Xendit/BIR acceptance were not rerun for this scoped change. No deployment or commit was performed.

Suggested commit: `feat(finance): combine payments and remittance tax records`
