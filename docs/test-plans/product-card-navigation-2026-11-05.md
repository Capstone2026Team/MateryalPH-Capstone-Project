# Product card navigation and Return — 2026-11-05

Product Analytics details now show a single **Return** control. My Products grid cards open that exact product's analytics and details from the image, content, measures and stock area, while Edit and Delete stay independent. The separate Analytics link was removed from the 30-day measures; all measures remain visible.

## Files and behavior

- `apps/vendor-web/src/pages/CatalogPages.tsx`: a semantic product-name link covers the card. Current `catalog.manage` controls its analytics destination; view-only members retain the existing catalog-detail destination. Catalog origin state includes the full search string.
- `apps/vendor-web/src/pages/ProductAnalyticsPages.tsx`: Return restores the allowed catalog origin, otherwise returns through internal browser history when available, with the product overview as a direct-entry fallback. External return destinations are rejected. The product measures contain no separate link.
- `packages/web-ui/src/portal-card.css`: shared stretched-card link, full-card focus indicator and independent action layer. There are no nested interactive controls or card-level click handlers that intercept Edit/Delete.
- Component and browser tests were updated in `CatalogPages.test.tsx`, `ProductAnalyticsPages.test.tsx`, `e2e/product-analytics-layout.spec.ts` and `e2e/phase-4-catalog.spec.ts`.

No API, generated-client, permission, migration, audit/notification or setup changes were needed.

## Verification

- Vendor lint, typecheck and production build passed. Existing unrelated output remains: unused `inStore` in `e2e/admin-finance-layout.spec.ts` and Vite's bundle-size advisory.
- `npm.cmd run test -- --run src/pages/CatalogPages.test.tsx src/pages/ProductAnalyticsPages.test.tsx`: **35 tests across 2 files passed**.
- `npm.cmd run test:e2e -- e2e/product-analytics-layout.spec.ts e2e/phase-4-catalog.spec.ts --grep 'full surface|keeps Delete' --workers=2`: **16 scenarios passed**, across 320/375/390/768/1024/1280/1440/1920px. Real pointer/touch clicks cover the card image, measures and stock area; checks also cover Enter activation, exact product destination, filtered catalog return, Edit navigation and Delete confirmation/cancellation.
- Changed-source and staged Gitleaks scans found no leaks; `git diff --check` passed.

Separate existing failure: the broader `phase-4-catalog.spec.ts` My Products layout scenario passes at seven widths but fails at 320px before reaching its Delete check. The summary tile's About button extends to x=324px. The same failure was reproduced with the saved pre-change CatalogPages, ProductAnalyticsPages and shared card CSS, then the final implementation was restored and rebuilt successfully. It is outside this navigation change. The focused 320px card and Delete scenarios pass.

Browser evidence uses synthetic records and does not establish live API/provider readiness. No deployment or manual setup was performed.

Suggested commit: `feat(catalog): make product cards open analytics with return navigation`
