# Vendor threshold and remittance cash reconciliation — 2026-10-15

The reported figures are different valid measures under FIN-04A/FIN-05. A read-only aggregate of the three recorded POSTED assessments matching the supplied taxable-year total confirmed:

| Component | Amount |
| --- | ---: |
| Assessed collections, including Buyer fees | ₱1,318.72 |
| Refunds allocated before assessment | ₱0.00 |
| Separately billed delivery | ₱428.25 |
| Included material VAT | ₱91.77 |
| Provider charges | ₱33.97 |
| Gross basis toward the threshold | ₱764.73 |
| Assessed withholding | ₱3.81 |
| Estimated cash at assessment | ₱1,280.94 |

Gross basis is collections less allocated refunds, delivery, material VAT and provider charges. Cash is collections less allocated refunds, provider charges and withholding. Equivalently, cash is gross basis plus delivery and material VAT less withholding. Commission remains separately billed. No formula, threshold, historical assessment or development record was changed.

## Changes

- `VendorFinanceService.php` adds a read-only `calculation_breakdown` to `GET /api/v1/vendor/finance` → `threshold`. It sums POSTED MERCHANT_CWT assessment components for the existing TEST taxpayer-year accumulator, including the taxpayer's other stores. Voided, prior-year and other-taxpayer assessments cannot enter this total. If the saved components do not reconcile to the authoritative accumulator and assessed cash, the breakdown is null rather than reconstructing historical amounts.
- `packages/web-ui/src/finance-patterns.tsx` reuses `FinanceCalculationBreakdown` for adjacent threshold and cash tables. It explains annual scope, outside-platform totals and overlap, the Earnings date filter, later refunds, and irreversible threshold crossing. Admin retains the same shared panel without requiring breakdown data.
- `apps/vendor-web/src/lib/finance-api.ts` maps the generated response into the shared panel. Existing layout, status badges and financial authorization remain intact.
- `packages/api-contract/openapi.yaml` documents the nullable calculation object and integer-centavo components. TypeScript/Dart clients and Dart serializers were regenerated; generated files were not edited manually. The earnings contract checker verifies the schema and generated TypeScript decoding, including null.
- API and component regressions cover the supplied amounts and full/partial/pending/failed refunds. Historical unmatched counters return null without changing the cumulative total.

Owner-only access is unchanged. The new object exposes aggregate money components only, with no taxpayer keys, private store identities or provider details. No migration, environment key or manual setup is required for this change.

## Validation

- Focused isolated `VendorEarningsTrendTest.php`: **6 passed, 318 assertions**.
- Isolated `PhaseElevenFinanceFlowsTest.php`, `PhaseSixteenAdminOperationsTest.php` and `PhaseElevenFinanceRulesTest.php`: **51 passed, 825 assertions**.
- Isolated `PhaseElevenWithholdingThresholdTest.php`: **11 passed, 176 assertions**, including crossings, rollover, external declarations, overlap and immutable posted assessments.
- Vendor Finance component tests: **25 passed**. Admin Finance component tests: **6 passed**.
- Focused Pint, full PHPStan, shared-component lint, Vendor lint/typecheck/build and Admin typecheck passed.
- OpenAPI validation passed with eight existing unused-model recommendations; earnings contract checks and TypeScript client build passed.
- Dart serializer generation passed on retry after a temporary Windows mapped-file lock. Focused analysis of both threshold models, their generated builders, and the serializer registry passed with no issues.
- Gitleaks found no leaks in changed source (131,345 bytes scanned); the staged scan contained zero commits/bytes. Targeted whitespace and Compose configuration checks passed.
- The Vendor build retains its existing chunk-size warning. Browser/device and live-provider acceptance were not tested. Tests used the isolated database; the development check was read-only.

Suggested commit: `fix(finance): explain threshold basis versus remittance cash`.
