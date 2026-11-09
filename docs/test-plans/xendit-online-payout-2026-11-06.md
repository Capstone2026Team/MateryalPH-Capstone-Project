# Xendit online payout cleanup — 6 November 2026

The Xendit connection, Xendit cash revenue summary and Payment breakdown live in the Xendit cash revenue & remittance tab. Finance overview retains sales, collections, payment channels and reporting. The selected-date payout and recorded taxpayer-year tax details have distinct scopes. Annual tax details occupy the main left column. Following the owner's latest correction, the 320px right column contains one combined connection card: the white revenue summary with its date filter, the accent connection details and account action, then the attached white Payment breakdown. The page header no longer repeats this tab's date filter. Narrow screens use one content column. The summary's date control stays mounted during loading, failure and retry; changing dates retains the selected tab and reloads only Earnings.

## Refund and fee treatment

- The user confirmed: omit fully refunded payments and subtract completed partial refunds. Pending and failed refunds do not reduce retained amounts.
- Current payout uses the existing authoritative assessment-date estimate. Its breakdown starts with the reconciled retained order amount, followed by Creditable withholding tax and payout. Buyer-paid transaction fees and their provider reconciliation are excluded from Vendor deduction rows; they are not deducted again from principal. Commission remains separately billed.
- `GET /api/v1/vendor/finance/threshold-payments` now returns current retained amounts: a completed full principal refund removes the payment; completed partial principal/fee refunds reduce their respective fields once. Wire keys and pagination remain unchanged. The retained list shows order amounts without Buyer-fee or fee-inclusive total columns.
- Recorded tax assessments, the annual accumulator and crossed-threshold status are preserved. The recorded threshold calculation is labeled accordingly, and help explains why current retained payments can differ after refunds. Historical tax corrections continue through the existing review process.
- The recorded tax basis excludes returns allocated before assessment, discounts already reflected in order amounts, separately billed delivery, material VAT and the reconciled fee flow. Delivery and VAT remain payable to the Vendor in the current payout. Reference: [BIR RR No. 16-2023](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2016-2023%203.pdf).

## Files and contract

- Vendor page, calculation help, component tests and responsive Finance browser tests.
- Shared finance patterns, retained-payment list and Finance CSS.
- `VendorFinanceService.php` and `VendorEarningsTrendTest.php`.
- OpenAPI retained-payment descriptions, generated TypeScript/Dart clients and Earnings contract checks.
- Vendor workflow and UI/UX planner.
- Shared web-session optional boolean normalized with `Boolean(options.localForbidden)` to satisfy strict optional-property typing; session recovery/loading tests cover the existing behavior.

No migrations, new permissions, financial assessment formulas or live provider configuration were introduced. Access remains Owner-only, with `portal.earnings` required before loading the payout estimate. Other stores under a taxpayer expose only aggregate amounts. Browser credentials and private identifiers remain behind the existing API boundary.

## Validation

| Check | Result |
| --- | --- |
| Isolated `php artisan test --compact --no-ansi --filter=VendorEarningsTrendTest` | 11 passed, 832 assertions; full/partial, pending/failed refunds, refund after crossing, pagination, privacy and authorization |
| Scoped `php vendor/bin/pint --test app/Domain/Finance/VendorFinanceService.php tests/Feature/Api/VendorEarningsTrendTest.php` | 2 files passed |
| API `php vendor/bin/phpstan analyse --memory-limit=512M` | 592 files, no errors |
| Vendor Finance, retained-payment and web-session recovery/loading component tests | 4 files, 94 tests passed |
| Admin Finance and tax component tests | 2 files, 20 tests passed |
| Vendor and Admin `npm.cmd run typecheck` | Passed |
| Vendor `npm.cmd run lint` | Passed; existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts` |
| Vendor `npm.cmd run build` | Passed; bundle-size warning |
| Finance/Earnings Playwright suites at 320, 390, 1280 and 1920 px | 24 passed; relocation, date preservation, no overflow, compact tax details, source lists and keyboard help |
| Payout layout follow-up with explicit text color checks at those four widths | 4 passed; desktop/mobile screenshots inspected |
| `npm.cmd run generate` in `packages/api-contract` | TypeScript and Dart clients regenerated |
| `npm.cmd run validate` and `npm.cmd run test:earnings-contract` | Passed; OpenAPI reports 8 unused-model recommendations |
| `npm.cmd run test:threshold-payments-dart` with installed Pub-cache access | Passed; initial sandbox run could not read protected dependencies |
| Gitleaks directory scan of the changed source, contract, generated models and documentation | No leaks; 2.42 MB scanned |
| Scoped `git diff --check` | Passed |

Vitest also emitted the existing jsdom navigation warning without test failures. Browser tests use mocked API responses; no live Xendit payout, tax filing, provider settlement, deployment or remote mutation was performed. No new manual setup or secret key names are required.

Suggested commit: `fix(finance): consolidate online payout and exclude refunded payments`

## Right-column layout follow-up

Changed the grouping in `FinancePages.tsx`, removed the wide-screen split in `finance-overview.css`, and updated the UI/UX planner and existing Finance browser checks. Payment breakdown sits directly above Xendit connection with the shared 12px gap, matching the supplied attachments. Calculations, refund treatment, APIs, migrations and authorization are unchanged; no setup is required.

Validation: 55 Finance component tests passed; 12 responsive browser scenarios passed at 320, 390, 1280 and 1920px, including card order, alignment, right-column placement, narrow-screen flow, tax states and keyboard help. Vendor typecheck, lint, build, scoped diff check and the changed-source secret scan passed. Lint retains the existing unused-variable warning; build retains the bundle-size warning. Initial browser runs encountered shared artifact-file errors; the isolated-output rerun passed. The tax-card height assertion now follows its actual two-column content breakpoint because the right rail narrows its workspace. Desktop and mobile screenshots were inspected.

Suggested follow-up commit: `fix(vendor): stack payout cards in the right column`

## Corrected-image follow-up

The corrected reference supersedes the separate-card order above. `FinancePages.tsx` now passes the embedded Payment breakdown into the existing shared `FinanceProviderCard` through `XenditConnection`. The accent connection section and white breakdown share one border with no gap. The connection remains available while payout data loads or fails, and existing permission gating remains in place. The standalone Payout summary stays above the combined card in the right column.

Updated the existing browser geometry assertions and UI/UX planner. No API, migration, financial calculation, refund treatment or setup change. Validation: 55 Finance component tests and 4 browser scenarios at 320, 390, 1280 and 1920px passed; typecheck, lint, build, scoped diff check and changed-source secret scan passed. The known lint, bundle-size and jsdom warnings remain non-blocking. The rendered mobile image was inspected against the supplied reference.

Suggested commit: `fix(vendor): combine Xendit connection and payout breakdown`
