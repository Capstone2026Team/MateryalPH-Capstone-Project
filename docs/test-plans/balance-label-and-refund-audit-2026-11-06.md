# Balance label and refund audit — 6 November 2026

The visible Finance page and tab now read **Balance**. The metric, calculation heading, chart, loading/accessibility labels and calculation help use Balance wording. The combined Xendit connection and Payment breakdown card, right-column placement, TEST estimate context and selected-date behavior remain intact.

## Screenshot records

A read-only transaction inspected the local development records for the four order references in the supplied screenshot. All four are `COMPLETED`, with refund state `NOT_REQUESTED` and zero completed refunds. The store has six assessed payments: two fully refunded payments are already excluded and four retained payments remain. No order or refund state was changed, and no development database write was performed. Removing one of those four as a refund requires identifying the order and its missing authoritative refund evidence.

The existing retained-payment endpoint excludes completed full principal refunds and subtracts completed partial principal refunds; pending and failed refunds do not count as completed. Posted tax assessments and the crossed-year status remain subject to the existing immutable-history and adjustment workflow. No new commercial or tax policy was introduced.

[BIR RR No. 16-2023](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2016-2023%203.pdf) excludes sales returns/discounts, separately billed delivery/shipping, VAT and qualifying platform-use consideration from its defined gross-remittance basis. Cancellation/refund status still requires the actual recorded transaction and refund evidence; the regulation does not establish that the four screenshot orders were refunded.

## Files and boundaries

- `apps/vendor-web/src/pages/FinancePages.tsx`: visible Finance, summary, chart and accessibility labels.
- `apps/vendor-web/src/components/earnings-calculations.tsx` and `packages/web-ui/src/finance-patterns.tsx`: corresponding calculation/help wording.
- Existing Finance component and responsive browser assertions updated for the renamed labels.
- Vendor workflow and UI/UX planner aligned with Balance terminology.

No API response, OpenAPI schema, generated client, migration, authorization, financial formula or provider behavior changed. Owner-only access and the `portal.earnings` request gate remain. No new setup or secret keys are required.

## Validation

| Check | Result |
| --- | --- |
| Vendor Finance and retained-payment component tests | 58 passed across 2 files |
| Admin Finance and tax component tests | 20 passed across 2 files |
| Isolated API tests matching `test_only_confirmed_refunds`, `test_retained_payment_sources`, `test_a_confirmed_partial_refund` | 3 passed, 340 assertions |
| Finance/Earnings browser suites at 320, 390, 1280 and 1920px | 24 passed |
| Vendor typecheck | Passed |
| Vendor lint | Passed; existing unused `inStore` warning in the Admin Finance browser fixture |
| Vendor production build | Passed; existing bundle-size warning |
| Scoped diff check | Passed |

The existing jsdom navigation warning did not fail the component suite. Browser tests use mocked APIs; the screenshot-record audit used the local database read-only. No live Xendit refund, deployment, BIR filing or remote mutation was performed.

Suggested commit: `fix(vendor): rename finance payout labels to Balance`
