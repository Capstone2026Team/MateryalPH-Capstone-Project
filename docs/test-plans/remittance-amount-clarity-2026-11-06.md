# Remittance amount and tax-basis clarity — 6 November 2026

## Outcome

The Payments remittance cell now has aligned label/value rows for Order after refunds, Withholding tax, Net remittance and Tax basis. Removed the redundant Recorded assessment heading from current payment rows. Tax basis has its own accessible explanation; Net remittance retains the recorded assessment/history popup. Both reuse shared CalculationHelp controls with keyboard opening, Escape dismissal and focus restoration.

Buyer-paid fees are excluded from the Payments calculations, not merely hidden. Gross and collected amounts use order principal; Refunded uses completed principal refunds; Net collected uses retained principal. The fee subline and repeated heading hint are removed. The remittance popup's main calculation contains only order payment, completed order refunds and withholding. Original fee-inclusive provider reconciliation is separate historical detail. Underlying provider collection/refund execution and posted tax records are unchanged.

Order after refunds uses the same linked assessment principal less completed principal refunds as the annual retained-payment list. Buyer-paid fees remain separate. Net remittance subtracts recorded withholding from that retained order amount. For example, ₱713.75 before withholding less ₱1.27 withholding is ₱712.48 net; the two amounts are labelled distinctly.

Tax basis explains the recorded qualifying payment amount used for withholding, excluding separately billed delivery, included material VAT, qualifying provider charges and refunds allocated before assessment. Discounts are already reflected. It states the project's standard 0.5% calculation and half-up centavo rounding. Later refunds update retained order money without rewriting the posted tax basis, withholding or an already-crossed annual threshold.

Original assessment cash remains in history. Fully refunded payments and standalone historical assessments do not claim a current remittance or active deduction. Review/unavailable states remain explicit.

## Implementation

- Shared presentation: `packages/web-ui/src/finance-patterns.tsx` and `finance-overview.css`.
- Vendor mapping and coverage: `apps/vendor-web/src/pages/FinancePages.tsx`, its component tests, and `e2e/finance-transactions-layout.spec.ts`.
- Read-only projection: `services/api/app/Domain/Finance/VendorFinanceService.php` and `tests/Feature/Api/VendorEarningsTrendTest.php`.
- API: documented nullable `order_after_refunds_centavos` and `net_remittance_centavos`, and corrected Payments gross/refund/collection fields to exclude Buyer fees; updated the Payments contract check and regenerated TypeScript/Dart clients with `npm.cmd run generate`.
- Updated the UI/UX planner and this verification record. No migration, stored money/tax mutation, new permission, provider call, secret, or manual setup is required. Finance remains Owner-only. Existing unrelated workspace changes were preserved.

The projection uses integer centavos and existing confirmed principal-refund totals. It adds no browser financial calculation. The CSV keeps the established adjacent refund-state/refund/net-collection fields and one consistent column order across mixed records. No posted assessment or threshold event is rewritten.

## Validation

- Vendor Finance components: **63 passed**, using `npm.cmd run test -- --run src/pages/FinancePages.test.tsx --maxWorkers=2`.
- Admin Finance/Tax components: **20 passed**, using `npm.cmd run test -- --run src/pages/FinancePages.test.tsx src/pages/FinanceTaxPages.test.tsx --maxWorkers=2`.
- Responsive Payments layout suite: **6 passed**, at 320, 390, 768, 1024, 1440 and 1920px. After the fee-calculation correction, the final suite **passed all 3 checks at 320, 390 and 1440px**, including principal-only gross/refunds/collections and the fee-exclusive order calculation. Checked matching pre-withholding amount, signed tax, net amount, tax-basis explanation, popup bounds, keyboard/focus behavior, history and no page overflow. Inspected final desktop and mobile screenshots in `.tmp/finance-transactions-review/`.
- Vendor lint/typecheck/build and Admin typecheck/build: **passed**. Existing Vendor lint unused-variable and build chunk-size advisories remain. JSDOM's existing download-link navigation diagnostic does not fail the final component suite.
- PHP Pint and full PHPStan: **passed**.
- OpenAPI validation and Payments contract: **passed**; validation retains eight unused-schema recommendations.
- TypeScript and Dart client generation: **completed**; generated artifacts were not edited by hand.

The isolated PostgreSQL refund/earnings suite verifies that Payments and annual retained-payment amounts match before tax, completed partial refunds reduce them once, pending/failed refunds do not, and posted tax stays immutable. It also verifies principal-only gross, principal-only refunds/net collections and unchanged fee-inclusive provider history. Its first run found a stale CSV field-order incompatibility, which was corrected before the final rerun. Final result: **12 passed, 924 assertions** with `php artisan test --compact --filter=VendorEarningsTrendTest` inside the isolated `api-test` container. Gitleaks on all affected current sources: **no leaks in 2.19 MB**. Changed-file `git diff --check`: **passed**.

No full API/portal/Flutter run or live-provider/BIR acceptance is claimed. Suggested commit: `fix(finance): exclude buyer fees from order payment totals`.
