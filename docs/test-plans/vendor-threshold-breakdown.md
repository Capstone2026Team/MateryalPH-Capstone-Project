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

## Annual online payment sources — 2026-11-06

The supplied ₱1,611.77 is four POSTED online-payment assessments for the taxable year: ₱293.05 + ₱293.05 + ₱732.62 + ₱293.05. Their order amounts total ₱1,570.25 and Buyer fees total ₱41.52. This is distinct from the selected 30-day Net sales of ₱30,051.75: that total includes ₱29,052.50 COD and ₱999.25 online sales, excludes Buyer fees, and excludes the two earlier online orders totalling ₱571.00. Reconciliation: ₱30,051.75 - ₱29,052.50 + ₱571.00 + ₱41.52 = ₱1,611.77. These are TEST records verified with a read-only development query.

The shared threshold table labels the starting amount **Assessed online payments (4)** and shows order amounts plus Buyer fees. **View payment breakdown** expands directly below that row. Each source displays its order reference, assessment date, order amount, Buyer fee, and payment total. The annual subtotal remains separate from the delivery, material VAT and provider-charge deductions. Full-year remittance-history links convert the exclusive tax-year end into the last included Manila date.

`GET /api/v1/vendor/finance/threshold-payments?page=1` uses the existing Owner finance authorization and matching TEST taxpayer-year accumulator, checks that its assessment basis reconciles, and returns at most 20 own-store records per page. Other stores sharing the taxpayer appear as combined totals only, without order references, store identities, taxpayer hashes, provider identifiers or Buyer details. Voided assessments, other taxpayers and other years are excluded. Historical counters without a matching reconstruction return `THRESHOLD_BREAKDOWN_UNAVAILABLE`; retries never change financial records.

No migration, accounting formula, permission, notification or financial-write behavior changes. OpenAPI and both generated clients document the additive source response. No manual environment setup is required.

Automated acceptance includes source equations and totals, page boundaries without duplicate records, aggregate-only other-store contributions, invalid pages, Owner-only denial, unavailable historical breakdowns, lazy expansion, retry/empty states, and responsive keyboard access.

Validation for this update:

- Isolated `VendorEarningsTrendTest.php`: **10 passed, 788 assertions**.
- Vendor Finance, shared patterns and payment-breakdown components: **69 passed**; Admin Finance components: **12 passed**.
- Threshold browser acceptance: **16 passed** across 320, 375, 390, 768, 1024, 1280, 1440 and 1920px, including keyboard expansion, payment sources, annual-history dates, mobile cards and page-overflow checks. Desktop and narrow-mobile source screenshots were visually reviewed. An isolated preview build avoided concurrent portal builds changing test assets.
- Vendor lint/typecheck/build and Admin typecheck/build passed. One existing unrelated `inStore` lint warning and the existing build chunk-size warnings remain.
- OpenAPI validation passed with its eight existing unused-model recommendations. Earnings/source contract checks and the generated TypeScript build passed.
- Dart builders/serializers regenerated; both the annual source JSON contract check and the threshold calculation JSON check passed. Scoped Dart analysis: **no issues**.
- Scoped Pint (four files), full PHPStan, Compose configuration and `git diff --check` passed. Gitleaks scanned **2.07 MB** of relevant source with **no leaks**; the staged scan had no content.

Browser checks used mocked TEST responses; no live payment provider, production tax filing or deployment was involved. Suggested commit: `fix(finance): show assessed payment source breakdown`.
