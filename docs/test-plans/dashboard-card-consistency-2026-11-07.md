# Dashboard card consistency

Request: match the Vendor dashboard rail to the Admin reference, simplify Admin activity charts, and reuse the donut/count/percentage/share-bar design for suitable comparison cards.

## Delivered behavior

- Shared `DashboardQueueList` and `DashboardActivityList` now render both portal rails. Vendor queues keep all entries, urgency ordering, zero counts, status text, original destinations, keyboard focus and 44px targets. Recent activity keeps latest-five filtering, safe fields, Manila dates, existing refresh/error/session clearing and `staff.manage` access; its View all link uses the existing Team Tracking route. The rail uses natural content height.
- Admin meaningful activity has one chart with Daily activity and 30-day activity tabs. Existing window summaries, suppression, dates, help and daily table remain. Confirmed order activity uses bars and integer axis ticks; the optional table retains its seven-day average.
- Admin participant records and visible category matches use donuts. Participant shares require both groups to be visible; a denied count stays unavailable. The center counts records rather than claiming a unique-person total. Category percentages use the sum of the shown category matches; the same order may match several categories, and suppressed categories remain excluded.
- Vendor category sales, stock groups, procurement/fulfillment/payment mixes, issue types and open-case statuses use the same donut treatment. Money lists and accessible totals remain exact, with a compact center label. Top-product rankings, demand funnels and demand scatter plots retain their appropriate semantics.

## Files

Admin: `src/pages/AdminDashboardPage.tsx`, `AdminDashboardInsights.tsx` and its tests. Vendor: `src/pages/VendorDashboardInsights.tsx` and its tests; `src/components/{VendorRecentActivity,AnalyticalCharts}.test.tsx`; `e2e/dashboard-layout.spec.ts`. Shared: new `packages/web-ui/src/dashboard-lists.tsx`, plus `vendor-recent-activity.tsx`, `chart-patterns.tsx`, `analytics-layout.css` and `index.ts`. Updated the UI/UX implementation planner and this report.

No API contract, generated client, migration, permission, financial formula, audit/notification rule, environment key or manual setup change is required. Browser responses are synthetic and establish presentation/interaction, not live provider or authenticated production acceptance.

## Validation

- Admin: `npm.cmd run test -- --run src/pages/AdminDashboardInsights.test.tsx src/components/SectionWorkspace.test.tsx` — 21 passed.
- Vendor: `npm.cmd run test -- --run src/pages/VendorDashboardInsights.test.tsx src/components/VendorRecentActivity.test.tsx src/components/AnalyticalCharts.test.tsx` — 50 passed. Coverage includes safe activity fields, failed events, session clearing, role-gated history, compact-center exact money values and zero-count queues.
- Both portals: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` — passed. Vendor lint retains the unrelated unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`; both builds retain bundle-size warnings.
- Browser: 48 dashboard/queue/distribution checks passed at 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. Eight additional 320/1440 checks passed for product-card alignment and scrolling, calculation popovers, final donuts and screenshots. Existing ignored local Playwright configuration and separate previews avoided managed web-server teardown. Initial new-fixture checks were corrected to use the authoritative singular `/vendor/onboarding` route; the application API was unchanged.
- Visual review: mobile and desktop category donuts, participant donuts, recent activity and final marketplace columns inspected. Compact monetary totals fit inside the ring while list and accessible values remain exact. Vendor stock shows its count once in the donut.
- Workspace `git diff --check` — passed. Gitleaks scanned the changed/new files — no leaks. The staged scan passed with no staged content.
- No backend, Buyer-device or live-provider tests were run for this presentation-only change. No manual setup or additional key is needed.

Suggested commit: `style(dashboard): unify activity lists and distribution cards`
