# Vendor commission payment periods

The Owner-requested Commission monitoring update replaces the all-time charge headline with Annual total commission payment and the mixed billing/payment panel with Monthly commission payment. Both show confirmed statement allocations less completed fee refunds in the current Asia/Manila calendar period. The amount is paid commission, not accrued charges or a wallet balance.

Annual history retains completed years with payment/refund activity using original financial records. No destructive reset, scheduled reset job, migration or additional setup is required. A refund counts in its completion period, even for an earlier-year payment. Outstanding debt carries forward in Current commission balances. Existing all-time API summary fields and paid-statement history retain their meaning.

API: `GET /api/v1/vendor/finance/commissions` adds `annual_payments`, `monthly_payments`, and independently paginated `payment_history` (`history_page`, ten years per page). The existing assessment `page` remains independent. The response is private/no-store and every projection uses the current Owner's organization. TypeScript and Dart clients are regenerated from OpenAPI.

Validation commands:

- Isolated API: `php artisan test tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Unit/PhaseElevenFinanceRulesTest.php --compact`.
- Vendor: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run src/pages/FinancePages.test.tsx`, `npm.cmd run build`.
- Browser: `npm.cmd run test:e2e -- e2e/commission-monitoring-layout.spec.ts` (eight configured widths).
- Contract: `npm.cmd run validate`, `npm.cmd run test:commission-periods-contract`.

The rollover feature test covers Manila month/year midnight boundaries, pending-payment exclusion, retained history, late-year allocations, refund-only negative totals, existing Buyer-payment exclusion, organization isolation, input validation and unchanged debt. Component and browser tests cover separate period values, saved order rates, history pagination/retry/empty states, dialog focus, statement navigation and responsive layout.

Manual acceptance: as the Owner, compare the payment breakdowns with confirmed TEST statement allocations and completed fee refunds. Check each period/reset date, open Annual history and paid-statement History separately, and confirm unpaid earlier bills remain visible. No live provider payment, push or deployment is part of this change.

Verified locally on 11 November 2026:

- Isolated Finance flow/rule regression: 58 passed, 965 assertions; added multi-page annual-history test: 1 passed, 50 assertions.
- Vendor Finance components: 80 passed. Admin Finance components: 30 passed.
- Final responsive browser run: 48 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. Separate Playwright output resolved two missing-trace artifact failures from the initial shared-output run. Screenshots: `.tmp/commission-monitoring-review/`.
- Vendor/Admin lint, typecheck and production builds passed. Builds retain large-chunk warnings. PHPStan, changed-file Pint, OpenAPI validation, generated TypeScript build, TypeScript/Dart period serialization, and analysis of the four affected Dart files passed. OpenAPI retains eight unused-model recommendations.
- Compose configuration, scoped whitespace checks, staged secret scan and changed production/contract diff secret scan passed.
- Full API/portal/Buyer suites and live-provider acceptance were not run; checks above are focused on the changed finance surface and generated-client compatibility.
