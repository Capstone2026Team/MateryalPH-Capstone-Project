# Vendor staff dashboards and fulfillment presentation

The Owner retains the full dashboard. Store Manager, Store Staff, Customer Service and Inventory Staff receive current operational counts, priority actions and shortcuts within their existing permissions. Fulfillment Staff receive only current assigned work: assignment totals, pending fulfillment, Out for Delivery, completed handover, delivery issues and assignment previews. No financial, traffic, performance or unavailable-data tabs are added to staff dashboards.

Counts come from authoritative REST responses, including full pagination totals for each fulfillment filter. The fulfillment summary reuses five bounded first-page requests to the existing assignment API and refreshes every 60 seconds, on private invalidations and on eligible reconnect/resume events. Failed reads remove the preview; retries use the same authorized endpoints. Existing assignment closure, deactivation, reassignment, private contact/proof, idempotency and concurrency rules remain authoritative.

Handover complete means Delivered or Picked up within current assignments. Buyer receipt confirmation is separate. Closed-order assignment access is revoked by the existing workflow, so these counts do not claim lifetime completed-order history.

The dashboard and Fulfillment list use the same shared assignment card. Search, sorting, status filters, removable active filters and pagination use shared portal controls. Assignment navigation preserves the filter query. Assignment details place Buyer coordination and confirmed item quantities beside fulfillment actions; directions follow the proof workspace. No schema, OpenAPI, generated client, commercial transition, audit or notification change is required.

Automated regressions cover role-scoped content, totals larger than a page, status links, permission revocation after private invalidation, failed-load retry, search/status/sort requests, unchanged-search resubmission, filter-preserving navigation and the existing acknowledgement/messages/proof actions. Owner analytics and navigation tests remain applicable.

Manual acceptance: inspect phone, tablet and desktop layouts with long references, Buyer names, addresses and vehicle names; empty queues; no matches; pending/active/delivered/pickup/issue states; many assignments; keyboard search/filter controls; current and removed item quantities; acknowledgement; authorized Buyer contact; messages; proof validation/submission; route fallback; and reassignment/closure revocation. Verify each fixed role and Owner separately. Browser/device and live-provider acceptance are separate from component and static checks.

## Changed files

- Dashboard routing and views: `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx`, `apps/vendor-web/src/pages/VendorStaffDashboard.tsx`, `apps/vendor-web/src/pages/VendorDashboardInsights.tsx`, `apps/vendor-web/src/lib/staff-dashboard.ts`.
- Fulfillment list and assignment layout: `apps/vendor-web/src/pages/FulfillmentPages.tsx`.
- Shared presentation and refresh configuration: `packages/web-ui/src/fulfillment-assignment-card.tsx`, `packages/web-ui/src/use-navigation-refresh.ts`, `packages/web-ui/src/index.ts`.
- Regression coverage: `apps/vendor-web/src/pages/VendorStaffDashboard.test.tsx`, `apps/vendor-web/src/pages/FulfillmentPages.test.tsx`, `apps/vendor-web/src/pages/VendorNavigation.test.tsx`.
- Manual acceptance and verification record: `docs/test-plans/vendor-staff-dashboard.md`.

## Verification — 2026-10-13

| Check | Result |
| --- | --- |
| Relevant dashboard/navigation/fulfillment/messaging/route tests in the full Vendor run | 138 passed, zero failed across seven files |
| Full Vendor `npm.cmd run test -- --run --maxWorkers=2 --reporter=json` | 460 passed, 6 failed, 466 total |
| Vendor `npm.cmd run lint` and `npm.cmd run typecheck` | Passed |
| Shared changed-source Oxlint | Passed |
| Vendor and Admin `npm.cmd run build` | Passed; existing >500 kB bundle warnings remain |
| Admin `npm.cmd run typecheck` | Passed |
| Scoped `gitleaks dir --redact --no-banner` | No leaks found |
| Source trailing-whitespace and conflict-marker check | Passed for the 12 changed files |

The six full-suite failures remain in the unchanged `OrderPages.test.tsx`: four older Order documents navigation expectations, one Customer Service pickup-date expectation and one NRPC checkbox expectation. The relevant new and existing regressions pass. Browser/E2E/device tests were not run. Backend, Buyer and API contract checks were outside this presentation change; no migration, API contract, generated client, audit/notification rule or new credential/setup change was required. No Git command was used.

Suggested commit: `refactor(vendor): focus staff dashboards and fulfillment workspace`.
