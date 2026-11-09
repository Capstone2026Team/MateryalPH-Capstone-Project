# Annual payment breakdown and portal fee wording

## Outcome

The expandable annual payment-source list sits below the threshold calculation, outside its two-column table. It separates Order amount, E-wallet transaction fee and Payment total into aligned columns and compact mobile records. The total is not repeated when all own-store records fit on one page; pagination and aggregate-only other-store contributions retain the full reconciled total. The summary remains keyboard accessible and lazy-loads the same protected, paginated records.

Current Admin/Vendor financial, order, quotation, messaging, dashboard and invoice presentation calls the Buyer-paid fee **E-wallet transaction fee(s)**. Wire keys and model properties retain `buyer_processing_fees_centavos` / `buyerProcessingFeesCentavos`; no fee rate, payment channel, amount, tax formula, refund rule or API shape changes. Provider charges and platform commission costs remain separate. Existing issued/published documents and financial records retain their original content.

## Refund verification

Read-only queries against the normal local development database verified the screenshot's four assessed payments: `ORD-2026-AZ5YXGDX`, `ORD-2026-WKRIWRHJ`, `ORD-2026-QOJYQLNH`, and `ORD-2026-BCZHVR6Q`. None had a completed ORDER refund. Failed attempts on WKRIWRHJ have no posted assessment and are not counted as additional collections.

This store has two fully refunded collections: `ORD-2026-T8PYSAI4` (₱732.72) and `ORD-2026-WU6IF2CW` (₱2,422.41). Both assessment states are `VOIDED`; neither appears in the four-payment list or increases the ₱1,019.64 annual counter. No normal-development data was changed.

The screenshot reconciles as:

`₱1,611.77 collected − ₱428.25 delivery − ₱122.36 material VAT − ₱41.52 provider charges = ₱1,019.64 counted toward threshold`.

Payment history retains the original successful collection and the separate completed refund for traceability. Earnings/payout calculations deduct completed refunds once. That history view is distinct from the annual threshold's POSTED-only source list. Existing FIN-04A behavior remains: fully refunded collections can be voided before crossing; partial refunds do not rewrite posted threshold amounts; after crossing, relief is not restored by a refund.

## Files and contracts

- Shared UI: `packages/web-ui/src/assessed-payment-breakdown.tsx`, `finance-patterns.tsx`, `finance-overview.css`, and existing order/quotation/messaging/fulfillment/invoice display components.
- Vendor/Admin pages and explanatory copy, with matching component/browser expectations.
- Backend display labels: `FinanceOperationsService`, `VendorDashboardInsights`, `GeoAnalyticsService`.
- Existing refund-reporting regression now explicitly checks exclusion from `threshold-payments` and its totals.
- Planner updated with the requested wording and presentation contract.
- No migration, new API field, client regeneration, credential, permission or setup change.

## Checks

- Vendor focused suites: **185 tests passed** across 7 files.
- Admin Finance/Dashboard focused suites: **23 tests passed** across 2 files.
- Isolated existing refund/annual-threshold regressions: **4 tests passed, 394 assertions**, including source-list exclusion for voided full refunds.
- Vendor and Admin typecheck, lint and build: passed. Existing Vendor unused-variable warning in `e2e/admin-finance-layout.spec.ts:31` and bundle-size warnings remain.
- Pint on affected PHP files and regression test: passed. PHPStan: no errors.
- Responsive browser checks: **20 unique scenarios passed** across 320, 390, 768 and 1440 px (8 annual-threshold scenarios, 4 Admin Finance, 4 transaction-history and 4 order-layout scenarios). Initial expansion-test selectors were corrected to focus the native summary. Screenshot review also caught and fixed a shared compact-table nowrap rule; the final threshold run checks each header for overflow.
- Source scan found no remaining Buyer fee / Buyer processing fee labels in current Admin/Vendor/shared React sources. Wire keys and immutable historical copy are intentionally unchanged.
- Diff whitespace check and secret scan of affected source: passed.

Reviewed synthetic browser evidence: [desktop payment list](../design/evidence/annual-payment-breakdown-2026-11-06/payments-1440.png), [320px payment list](../design/evidence/annual-payment-breakdown-2026-11-06/payments-320.png).

Browser fixtures use synthetic records. No provider payment, refund, tax filing or remote deployment is performed. Broader unrelated API/mobile suites are outside this presentation-only patch.

Suggested commit: `fix(finance): clarify annual payments and e-wallet fee labels`.
