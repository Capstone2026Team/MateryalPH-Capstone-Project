# Vendor withholding and visible annual payment breakdown

Implemented the Owner's 2026-11-09 request in the Vendor Xendit cash revenue & remittance view.

## Result and scope

- Restored the reference's two-column status layout: Tax is withheld and Why tax is withheld stay in the left column; Withholding status and its explanation stay on the right. Narrow screens stack these sections in that order. Approved relief keeps threshold progress; crossed-year history remains visible.
- Replaced the annual list's short summary rows with always-visible payment records. Each shows the order reference, Manila assessment time, current order amount after completed refunds, original online payment at assessment, delivery and material VAT deductions, saved tax basis, recorded rate and saved withholding.
- Basis and withholding sections align side by side in wide containers and stack on narrow screens. Shared calculation tables and the extracted `FinanceWithholdingCalculation` are reused by the annual records and transaction tax dialog.
- Retained payment totals, pagination, retry, empty states, taxable-year scope, TEST disclosures and the existing annual Payments link remain available.

Changed shared UI: `packages/web-ui/src/assessed-payment-breakdown.tsx`, `finance-patterns.tsx`, `finance-overview.css`. Updated Vendor component/browser tests, `VendorFinanceService.php`, `VendorEarningsTrendTest.php`, the OpenAPI contract, generated TypeScript/Dart clients, focused client contract scripts and the Vendor workflow/UI planner. No migration, new dependency, credential or manual setup is required.

## API and authorization

`GET /api/v1/vendor/finance/threshold-payments` adds three required integer-centavo properties to each own-store `AssessedOnlinePayment`:

| Property | Recorded source |
| --- | --- |
| `assessed_payment_centavos` | Original assessment collection minus its pre-assessment refunds and provider charge, matching the existing annual Online payments calculation |
| `delivery_centavos` | Delivery exclusion from the original assessment |
| `material_vat_centavos` | Material VAT exclusion from the original assessment |

Existing retained principal and collection fields still reflect completed refunds. New breakdown fields, tax basis, rate and withholding come from the original posted assessment. No tax is recalculated from current retained principal. No stored assessment, threshold engine, refund rule, audit event or notification behavior changes.

Owner-only authorization and taxpayer-year filtering remain in place. Other stores contribute aggregate totals only; their references, identities and deduction records are never returned. This remains TEST reporting, without a live Xendit or BIR action.

## Validation

- Vendor Finance, assessed-payment and shared-pattern suites: **93 tests passed** across three files; the **82 focused Finance and assessed-payment tests passed again** after restoring the requested left-column explanation.
- Admin Finance regression suite: **30 tests passed**.
- Isolated `VendorEarningsTrendTest`: **13 tests passed / 1,004 assertions**, after the database isolation and Passport guards passed. Covers authorization, taxpayer scope, pagination, per-payment rounding, full/partial/pending/failed refunds and original assessment components.
- Responsive Playwright: **16 tests passed** at 320, 375, 390, 768, 1024, 1280, 1440 and 1920px, including the final restored layout. Checks the left explanation/right status arrangement, narrow-screen stacking, inline deductions, totals, annual scope, relief/crossing/review states, overflow, calculation-dialog keyboard access, Escape and focus restoration.
- Vendor lint, typecheck and production build passed; Admin typecheck passed. The build retains its existing bundle-size warning; passing jsdom tests retain their navigation limitation output.
- Scoped Pint and full PHPStan passed.
- OpenAPI validation, generation, the generated TypeScript build and Dart serializer generation passed. Focused TypeScript and Dart serialization checks preserve original deductions, current retained principal and recorded 0% relief. The new handwritten Dart check analyzes with no issues.
- Docker Compose configuration, scoped diff checks and Gitleaks passed. The staged scan had no staged files; a separate scan covered the actual changed source, contract, generated model and documentation files.

Desktop and mobile screenshots were visually reviewed. Local browser evidence is in `.tmp/finance-threshold-review/`; final Playwright output is in `.tmp/vendor-withholding-left-layout-playwright/`.

## Existing blocked gate and limits

`npm.cmd run test:payments-contract` fails because `POST /admin/finance/commission-policies/{policyId}/resend-failed` lacks the authentication/authorization error-response documentation required by that broad test. The identical failure was reproduced using the pre-edit OpenAPI snapshot. The new annual-payment contract and client round-trip checks pass independently.

Full monorepo suites and live provider/BIR acceptance were not run. Suggested commit: `feat(vendor-finance): display annual payment tax breakdowns`.
