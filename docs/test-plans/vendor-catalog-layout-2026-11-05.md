# My Products compact layout — 2026-11-05

## Outcome and scope

The Vendor Listings page uses compact white summary filters, a grouped search/status/category toolbar, a paired Grid/Table switch, and more consistent product presentation. Grid cards show a short photo with listing status, a two-line name, category/SKU, unit price and variant count, PS/ICC state, private availability, independent actions, and aligned 30-day measures. Missing and failed photos have neutral fallbacks. Full names and SKUs remain in accessible text and title hints; table records show them without truncation.

The table groups the former eleven columns into Product, Status & compliance, Price, Stock (private), Last 30 days, and Actions. Product rows include thumbnails. Under 1024px, shared labeled records replace the table, using two columns from 360px and one column below that. Wide desktop tables scroll within their own container.

## Files changed

- `apps/vendor-web/src/pages/CatalogPages.tsx`
- `apps/vendor-web/src/pages/ProductAnalyticsPages.tsx` — presentation of the existing summary strip only.
- `apps/vendor-web/src/components/ProductListingCard.test.tsx`
- `apps/vendor-web/e2e/phase-4-catalog.spec.ts` — richer layout coverage and temporary screenshot-only styles.
- `packages/web-ui/src/product-listing.tsx`
- `packages/web-ui/src/product-listing.css`
- `packages/web-ui/src/compact-page-patterns.css`
- `packages/web-ui/src/page-patterns.tsx` — opt-in compact metrics and toolbar.
- `packages/web-ui/src/catalog-patterns.tsx` — opt-in compact table and mobile records.
- `packages/web-ui/src/index.ts`
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This test plan; refreshed catalog product screenshots in `docs/design/evidence/portal-standardization/`.

No migration, API/OpenAPI/generated-client change, audit/notification change, or configuration/key setup is required. Existing list requests, counts, filters, pagination, catalog permissions, authorized photo URLs, private stock values, analytics grants, return context and draft-deletion confirmation remain in use. No deployment was performed.

## Verification

Commands run from `apps/vendor-web`:

| Command | Result |
| --- | --- |
| `npm.cmd run lint` | Passed; existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:31`. |
| `npm.cmd run typecheck` | Passed. |
| `npm.cmd run test -- --run` | 87 files, 811 tests passed. |
| `npm.cmd run test -- --run src/pages/CatalogPages.test.tsx src/pages/ProductAnalyticsPages.test.tsx src/components/PortalCards.test.tsx src/components/ProductListingCard.test.tsx` | 4 files, 37 tests passed after the card/summary refinements. |
| `npm.cmd run build` | Passed; bundle-size warning remains. |
| `npm.cmd run test:e2e -- e2e/phase-4-catalog.spec.ts --grep "My Products\|clickable product card\|compact catalog"` | 24 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. |

Browser coverage checks both views, empty state, long names/SKUs/statuses, price ranges, large amounts, absent prices/quantities, zero activity, clean photo fallbacks, product-photo navigation through the stretched link, separate Edit/Delete controls, deletion confirmation, 44px Edit targets and absence of horizontal page overflow. All requests use synthetic fixtures; they do not establish live API/storage/provider acceptance. Desktop grid/table and phone table screenshots were visually reviewed.

Admin compatibility: `npm.cmd run typecheck` and `npm.cmd run build` passed from `apps/admin-web`; the bundle-size warning remains. The compact presentation is opt-in. Backend, Flutter and unrelated Admin test suites were not run for this presentation-only change.

`git -c core.safecrlf=false diff --check` passed. The staged Gitleaks gate passed with zero staged bytes. A separate `gitleaks dir <temporary-scan-directory> --redact --no-banner` scan of all 12 changed source/document files passed: 258.35 KB scanned, no leaks found.

Docker is unavailable on PATH. Compose files are unchanged; the full-repository Compose gate would require `docker compose config --quiet` in an environment with Docker.

## Evidence and remaining acceptance

The richer six-product fixture writes `catalog-grid.png` and `catalog-table.png` under each viewport's ignored `apps/vendor-web/test-results/phase-4-catalog-compact-*/` directory. The existing catalog tests refresh the product-list, table, deletion-dialog and empty-state evidence under `docs/design/evidence/portal-standardization/`.

No required application setup remains. Live authenticated acceptance with the store's current products and photos remains a manual check.

Suggested commit: `style(vendor): compact product catalog grid and table`
