# Store Performance: operational metric clarity and layout

Owner-requested follow-up, 6 November 2026. This supersedes the operational KPI/history arrangement in the earlier Store Performance refinement report.

## Result

Score history sits beside a compact 2-by-2 Operational performance grid on desktop (1280 px and wider), above the VCS/MQS/OHS cards. Narrower layouts stack the metric grid and chart in reading order; small mobile layouts use one metric per row. Retains the existing chart, exact-value readouts, calculation dialogs, empty state and no history table/content dropdowns. KPI cards use consistent spacing, icons, values and a short scope explanation. Store health remains below the score cards as a compact desktop strip with its current server classification, date, reasons and help.

| Previous display label | New display label | Meaning retained |
| --- | --- | --- |
| Fulfillment Reliability Rate (FRR) | On-time fulfillment (FRR) | On or before the confirmed date among eligible fulfilled orders; trailing 90 days. |
| Fulfillment rate | Order completion rate | Completed by period end among confirmed, non-cancelled orders due in the last 30 days. |
| Cancellation rate (all causes) | Cancelled orders | All causes, Buyer and Vendor; not the Vendor-caused NFR scoring measure. |
| Dispute rate | Orders with disputes | Any case status or outcome; not confirmed Order Defect Rate findings. |
| Mean response time | Average order decision time | First human decision on eligible order requests; not inquiry replies or CRR. |

FRR/CRR sample captions now name fulfilled orders and inquiries rather than the ambiguous word "counted". Dates, samples, values, zero/unavailable distinctions and calculation definitions remain from the existing responses.

## Files and boundaries

- `apps/vendor-web/src/pages/TrustPages.tsx`: labels, context, 2-by-2 card/history composition and history extraction into a stable module-level component.
- `packages/web-ui/src/store-performance.css`: responsive grid, KPI spacing and compact health layout.
- `packages/web-ui/src/store-performance-overview.tsx`: optional compact health density; default shared presentation remains available.
- Vendor component tests and `e2e/store-performance-layout.spec.ts` assert the terminology, distinct definitions, placement, responsive geometry and existing controls/states.
- UI/UX planner records the owner's display-name and placement decisions.

No backend, migrations, API contract, generated client, permission, scoring, ranking, financial or provider changes. Retains `scores.view_store` and the server-authorized order section. A failed supplementary request retains the score/history content with independent retry; denied order sections do not expose KPI values. No new setup keys or dependencies, and nothing was deployed.

## Checks

- Vendor `npm.cmd run lint`: passed; retains the existing unrelated unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:31`.
- Vendor `npm.cmd run typecheck` initially passed, and both builds passed (including the final CSS); existing large-chunk recommendation remains. The final whole-portal typecheck then reported `src/pages/FinancePages.tsx(424,194): TS2322: Type 'unknown' is not assignable to type 'ReactNode'`. That Finance file was not edited by this task. The current whole-portal typecheck is blocked by that separate working-tree error; the Store Performance checks below pass.
- Vendor `npm.cmd run test -- --run src/pages/TrustPages.test.tsx src/pages/ProductAnalyticsPages.test.tsx src/pages/VendorDashboardInsights.test.tsx`: **48 passed** in three files.
- Admin `npm.cmd run typecheck` and `npm.cmd run test -- --run src/pages/TrustPages.test.tsx`: passed, **19 tests**.
- `npm.cmd exec -- playwright test e2e/store-performance-layout.spec.ts --reporter=line`: **8 passed**, at 320/375/390/768/1024/1280/1440/1920 px. Checks 2-by-2 desktop geometry, history beside the metrics and above published score cards, no page/card overflow, published/unpublished states, badge graphics, help keyboard/focus behavior, server data windows, no history table and no content dropdowns.
- Final browser rerun after tightening icon/title spacing: **8 passed** (15.0 seconds), including aligned value baselines within each desktop card row. Regional captures were inspected at 1280/1440/1920 px, including empty history and the compact health strip; the 320 px full-page capture was also reviewed. The desktop chart stays alongside the grid and the mobile view keeps all four cards and history readable without horizontal overflow.
- Final scoped source/diff checks and direct redacted secret scan: passed.

The React review retained stable module-level components, existing independent loading/retry effects, semantic definition lists and sections, and keyboard-accessible help. No new effects, state, data fetching, chart libraries or external assets were introduced.

The checks use synthetic browser fixtures, not live store data. Full portal suites and backend/mobile tests were not rerun for this presentation-only change. Live-data/user acceptance is not implied. No credentials or manual configuration are required.

Suggested commit: `feat(vendor): clarify operational metrics and align score history`.
