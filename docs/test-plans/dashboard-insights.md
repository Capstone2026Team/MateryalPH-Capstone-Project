# Dashboard insights — test plan

Scope: `GET /api/v1/vendor/dashboard/insights`, `GET /api/v1/admin/dashboard/insights`, the mining library in `services/api/app/Domain/Analytics/Mining`, the shared chart components in `packages/web-ui/src/chart-patterns.tsx` (and the extended `TrendLineChart`), and both portal dashboards.

| Layer | Test | What it proves |
| --- | --- | --- |
| Unit | `tests/Unit/DashboardMiningTest.php` | Trend, weekday seasonality, prediction band, anomaly and gap handling; flat-noise label; non-negative forecasts; deterministic K-Means with silhouette choice; DBSCAN noise only for isolated points; Apriori support/confidence/lift and the distinct-owner floor; risk tree uses only workflow thresholds (strictly-below edges, band mapping). |
| Feature | `tests/Feature/Api/DashboardInsightsTest.php` | Owner sees only own confirmed orders with values; role matrix per section (Manager no peso values, Inventory/Fulfillment no store-wide orders, Fulfillment only assigned work); disabled staff disputes removes the case section; strict filters (422); Buyer refused; Admin sections gated by `analytics.view_aggregates` / `scores.view`; geo flag off is explained; at k = 50 the series equals the read model cell for cell and no suppressed area enters a segment. |
| Contract | `packages/api-contract/scripts/check-dashboard-insights-contract.mjs` (`npm run test:dashboard-contract`) | Routes documented, read-only, cookie + CSRF transport, audience middleware, no point/radius/identity filter, role-gated sections nullable, no coordinates or identity fields. |
| Component | `apps/vendor-web/src/pages/VendorDashboardInsights.test.tsx`, `apps/admin-web/src/pages/AdminDashboardInsights.test.tsx` | KPIs, keyboard-readable charts with forecast text, table view, period change, mining panels, no peso values without `finance.view`, assigned-work view, honest funnel ratios, no invented visits, error + retry, suppressed values stated as text. |
| End-to-end | `apps/vendor-web/e2e/dashboard-layout.spec.ts` (8 viewports, 320–1920 px) | Sections switch without stacking, every tab renders its panels, no horizontal page scroll, restricted Admin sees reasons not charts. Evidence: `docs/design/evidence/dashboard-layout`. |

Manual review: chart palette validated with the dataviz validator (slots 1–6 on white: adjacent CVD ΔE ≥ 9.1, normal-vision ΔE ≥ 19.6; three slots below 3:1, so values are printed or offered as a table and scatter groups also differ by marker shape).
