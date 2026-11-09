# Vendor Top products placement

Owner request, 2026-11-05: move Top products into the existing Overview card group, beside Store performance and below Sales by category. On phones it follows Store performance in the same group. Product demand segments and Frequently ordered together remain in their separate group below.

Changed files:

- `apps/vendor-web/src/pages/VendorDashboardInsights.tsx`: extract the existing Top products panel and render it immediately after Store performance, once.
- `packages/web-ui/src/analytics-layout.css`: retain the mobile heading/link wrapping for its new location.
- `apps/vendor-web/src/pages/VendorDashboardInsights.test.tsx`: assert the card's group, order and single occurrence while retaining ranking and permission checks.
- `apps/vendor-web/e2e/dashboard-layout.spec.ts`: verify desktop pairing, equal row height, mobile stacking, populated/empty states and screenshots. Measure paired rectangles in one browser evaluation so focus scrolling cannot skew their positions.
- This report.

Ranking, money calculations, dates, automatic refresh, data access and navigation are unchanged. The Product analytics link still requires its existing grant, peso values still require finance access, and calculation help retains its accessible icon and popup. No API contract, generated client, migration, audit/notification, environment key or manual setup changes are required.

Validation:

```powershell
cd apps/vendor-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run src/pages/VendorDashboardInsights.test.tsx --maxWorkers=2
npm.cmd run build
npm.cmd run test:e2e -- --config ../../.tmp/vendor-top-products.config.ts dashboard-layout.spec.ts --grep "Vendor product insights are compact|Vendor calculation explanations" --project chromium-320 --project chromium-768 --project chromium-1440 --project chromium-1920

cd ../admin-web
npm.cmd run typecheck
npm.cmd run build
```

Vendor lint/typecheck/build, 22 dashboard component tests, 12 browser tests, and Admin typecheck/build passed. Lint retains the existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`; both builds retain bundle-size advisories. Whitespace checks and a redacted Gitleaks scan of the task files passed.

Browser validation uses intercepted synthetic payloads at 320, 768, 1440 and 1920 px. Screenshots are in `.tmp/product-overview/`; desktop, tablet and phone previews were visually inspected. The ignored local Playwright config runs a direct Vite preview on port 4193 with isolated test output. The preview process was stopped after the tests so Windows server teardown could finish; the final runner exit was 0 with 12 passed. Backend, Flutter, providers and live authenticated financial records are outside this placement-only validation. No deployment or database mutation was performed.

Suggested commit: `fix(vendor): place top products beside store performance`

## Follow-up: Store performance shortcut

Owner request, 2026-11-05: add a link from the Store performance dashboard card to its page. The card now uses the existing DashboardPanel header action with **View performance →**, targeting `/performance`. Its calculation icon, scores, eligibility state and layout remain. The existing Top products header-link wrapping style is shared under `mp-analytics-page-link` so both shortcuts fit phones.

Files changed for the follow-up are `VendorDashboardInsights.tsx`, its component tests, `e2e/dashboard-layout.spec.ts`, shared `analytics-layout.css` and this report. The link renders only with the existing authorized performance section; the destination retains its `scores.view_store` gate. There are no API contract, migration, generated client, calculation, audit/notification, key or setup changes.

Follow-up validation: Vendor lint, typecheck and production build passed, with the same existing lint and bundle-size warnings. All 22 dashboard component tests passed, including the shortcut target and its absence for assigned-work roles. Responsive browser checks use the existing isolated command above with `--grep "Vendor product insights are compact.*populated|Vendor calculation explanations"` and projects `chromium-320`, `chromium-768`, `chromium-1440`.

All six follow-up browser tests passed. Desktop and phone screenshots were inspected; the link has a 44 px target, cards retain their paired layout and calculation popups stay within the viewport without resizing cards. A redacted Gitleaks scan and whitespace checks of the task files passed. Browser evidence uses synthetic payloads; full backend, provider and live authenticated journey checks were not repeated for this navigation-only change.

Suggested follow-up commit: `feat(vendor): link dashboard card to store performance`
