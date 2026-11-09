# Product Analytics overview layout — 6 November 2026

The Vendor overview at `/analytics/products` now uses compact summary metrics, a trend chart with Suggestions beside it on wide screens, a full-width ranking row and product comparison, and an always-visible Product demand patterns section. Visible sort choices replace the dropdown. Category views have their own labelled panel. Suggestions scroll within the trend row on wide screens; the page stacks naturally on phones. Product-detail disclosures retain their existing behavior.

## Changed files

- `apps/vendor-web/src/pages/ProductAnalyticsPages.tsx`
- `packages/web-ui/src/analytics-layout.css`
- `packages/web-ui/src/chart-patterns.tsx`: shared native-radio SegmentedControl; PeriodSelector reuses it.
- `packages/web-ui/src/insight-patterns.tsx`: forwards the existing shared scrollBody option.
- `packages/web-ui/src/index.ts`: exports SegmentedControl.
- `apps/vendor-web/src/pages/ProductAnalyticsPages.test.tsx`
- `apps/vendor-web/e2e/product-analytics-layout.spec.ts`
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This validation record.

No migration, API contract, generated client, calculation, role or authorization change. `catalog.manage` remains required; sales values and their sort choice remain Owner-only through the existing `finance.view` contract. Period/sort links, page resets, pagination, calculation help, retry, product navigation and legacy redirects remain available. No keys or manual setup are required. Nothing was deployed.

## Executed checks

| Check | Result |
| --- | --- |
| Vendor `npm.cmd run lint` | Passed; existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:31`. |
| Vendor `npm.cmd run typecheck` | Passed. |
| Vendor `npm.cmd run test -- --run` | 90 files, 842 tests passed. |
| Vendor `npm.cmd run build` | Passed; bundle-size warning. |
| Admin `npm.cmd run lint` | Passed. |
| Admin `npm.cmd run typecheck` | Passed. |
| Admin `npm.cmd run test -- --run` | 42 files, 282 tests passed. |
| Admin `npm.cmd run build` | Passed; bundle-size warning. |
| Vendor `npm.cmd exec playwright test e2e/product-analytics-layout.spec.ts -- --grep "Product Analytics has its own navigation"` | 8 tests passed at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. |
| Final screenshot refresh at 1440 and 390 px | 2 tests passed after resetting the tested Suggestions scroll position for the captures. |
| `git diff --check` restricted to the changed tracked files | Passed. |
| `gitleaks git --staged --redact --no-banner` | Passed; index contained no staged content. |
| Changed tracked UI/document diff piped to `gitleaks stdin --redact --no-banner` | Passed; no leaks in approximately 175 KB scanned, including existing working-tree changes. |
| All nine changed files, including untracked CSS and this record, piped to `gitleaks stdin --redact --no-banner` | Passed; no leaks in approximately 263 KB scanned. |

Component checks cover always-visible demand panels, retained calculation help, non-Owner financial restrictions, native radio selection, URL filters and pagination reset, authorization denial and retry. Browser checks cover keyboard sorting, full-width comparison, constrained and keyboard-scrollable Suggestions, published-product links, legacy redirects, shared card appearance, empty analytics and no horizontal page overflow.

Screenshots are in `.tmp/analytics-review/products/{width}-product-analytics-overview.png` and `{width}-product-analytics-empty.png`. Desktop and phone captures were inspected. Browser data is mocked sample data; these checks do not verify a live backend or provider. A preview-server retry logged that Admin port 4174 was occupied; the final browser run completed with all eight tests passing. The full Vendor suite emitted a jsdom navigation diagnostic and still passed all 842 tests.

API, Flutter and deployment checks were outside this presentation-only change. Docker is unavailable in this shell; no Compose configuration changed. If running the general repository gate in a Docker-enabled shell, use `docker compose config --quiet`.

Suggested commit: `style(vendor): simplify product analytics overview layout`
