# Vendor Earnings remittance breakdown — 2026-10-15

Vendor Earnings now shows a visible Item/Amount table below its summary cards. It lists collected online payments including Buyer processing fees, confirmed refunds, provider charges and simulated CWT, with signed deductions and the API's estimated remittance cash highlighted as the total. The existing explanation of differences from the Xendit balance remains available.

Every row uses POSTED remittance assessments and confirmed fully refunded VOIDED assessments, with the same Asia/Manila assessment-date filter as the estimate. Fully refunded payments appear in both original collections and confirmed refunds, cancelling out; their provider charge, CWT and net cash remain zero. Confirmed partial refunds are deducted once; pending/failed refunds do not reduce cash. Physical receipts and separately billed commission remain separate. The frontend displays the total returned by the API, without introducing a second financial calculation.

Changed files:

- `apps/vendor-web/src/pages/FinancePages.tsx` and its tests.
- Shared `packages/web-ui/src/finance-patterns.tsx` and `src/index.ts`: reusable accessible `FinanceCalculationBreakdown` table.
- `services/api/app/Domain/Finance/VendorFinanceService.php` and `tests/Feature/Api/VendorEarningsTrendTest.php`.
- `packages/api-contract/openapi.yaml`, the earnings contract checker, and regenerated TypeScript/Dart clients and serializers.

`GET /api/v1/vendor/finance/earnings` adds two required integer-centavo fields: `remittance_collections_centavos` and `remittance_refunds_centavos`. They are summed from the existing remittance source query, so payment-date collection cards cannot accidentally replace assessment-date calculation inputs. Owner-only authorization is unchanged. This change requires no migration, configuration key or credential.

Verification:

- Vendor Finance component tests: **24 passed**. Includes the supplied example's amounts, signed deductions, zero-refund formatting, full-refund visibility without changing net cash, and distinct payment/assessment-date scopes.
- Isolated Vendor Earnings API tests: **5 passed, 272 assertions**. The components reconcile to the authoritative total for every response, including full/partial refunds, pending/failed states, duplicate refund events and date boundaries.
- Related isolated finance/Admin operation API regressions: **22 passed, 732 assertions**. The earlier commission repair migration/test cases are now verified in the isolated database; its development migration is still pending.
- Vendor lint/typecheck/build, shared-component lint and Admin typecheck passed.
- Focused Pint and full PHPStan passed.
- OpenAPI validation passed with eight existing unused-model recommendations. Earnings and portal-date contract checks passed.
- TypeScript client build and Dart serializer generation passed; focused Dart model/serializer analysis found no issues.
- Changed-source secret scan and targeted whitespace checks passed. The web build retains the existing large-chunk warning.
- Browser/device and live-provider behavior were not tested. No development database records were changed.

Suggested commit: `feat(vendor): show remittance calculation breakdown`.

## Refund visibility correction

The original breakdown reused the rule that excluded fully refunded payments from earnings. This also removed their original collection and refund amounts from the explanation table, and ignored the now-VOIDED assessment. A new isolated regression reproduced the bug before the fix: the collection component returned 0 instead of 1,026,441 centavos after full refund success. The query now retains these records in both gross components while continuing to exclude them from provider charges, CWT and net cash. The regression and the complete Earnings suite pass. No financial records, statuses, schema or authorization were changed.

Suggested fix commit: `fix(finance): show full refunds in earnings breakdown`.
