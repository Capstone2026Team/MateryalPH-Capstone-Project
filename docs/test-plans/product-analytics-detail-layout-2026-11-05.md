# Compact Product Analytics detail workspace — 2026-11-05

The reviewed product's gallery and saved information now share the left column of `/analytics/products/:listingId`. Analytics and received Product Reviews occupy the right column. Below 1280px the columns stack in reading order.

## Changes

- Shared `packages/web-ui/src/product-workspace.tsx` and `.css`: one white surface, a selectable gallery with 44px-plus thumbnail targets, keyboard selection, image fallback and retry, compact spacing and responsive columns.
- `apps/vendor-web/src/pages/ProductAnalyticsProduct.tsx`: product identity, description, specifications and active variants with current unit prices below the gallery.
- `apps/vendor-web/src/lib/product-analytics-context.ts`: existing catalog details and ready, clean photo links load independently of analytics. Photo-link requests run concurrently. A photo or product-detail failure can be retried without blocking the analytics panel. Period changes retain the selected photo.
- `apps/vendor-web/src/pages/ProductAnalyticsPages.tsx`: existing compact metric summary, main chart and reviews; secondary funnel, basket patterns and suggestions use More product insights.
- `VendorReviewPages.tsx` and shared `review-details.tsx`: compact review cards and a rating distribution that fits the available panel width. Existing review-detail, report, pagination and return actions remain available.
- `packages/web-ui/src/index.ts` exports the shared workspace and gallery. The UI/UX planner records the requested layout.

No API response, generated-client, route, permission or migration changes were required. Catalog unit prices remain readable through their existing catalog permission; analytics sales values remain controlled by the API's existing Owner-only access. Reviews retain blind reveal, publication/moderation/dispute eligibility and `reviews.view` checks.

## Passed verification

- `apps/vendor-web`: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build`.
- Focused Vitest command: `npm.cmd run test -- --run src/pages/ProductAnalyticsPages.test.tsx src/pages/VendorReviewPages.test.tsx src/lib/review-media.test.tsx src/components/ReviewOverview.test.tsx src/components/ReviewAuthorAvatar.test.tsx` — **48 tests, 5 files passed**.
- `npm.cmd run test:e2e -- e2e/product-analytics-layout.spec.ts --workers=2` — **24 scenarios passed** across 320/375/390/768/1024/1280/1440/1920px. Checks cover gallery selection, details below the image, column placement, period changes, preserved photo selection, review pagination, exact detail return context, existing navigation and no horizontal page/panel overflow.
- `apps/admin-web`: `npm.cmd run typecheck` verifies shared-component compatibility.
- Final 1440px and 320px screenshots were inspected. Browser images and records use clearly labelled sample fixtures; they are not live marketplace evidence.
- Changed-source/staged secret scans and `git diff --check` passed.

Existing advisory output remains: the unrelated `inStore` fixture variable in `e2e/admin-finance-layout.spec.ts` and Vite's bundle-size warning. The initial browser run exposed test selectors for collapsed mobile navigation and visually hidden radio inputs; those checks now use the visible controls and the final run passed.

Manual acceptance: open a real published listing with several photos and confirm current storage delivery and actual product content. Provider/device acceptance and the complete API, Admin and Flutter suites were not run for this presentation-only change.

Suggested commit: `feat(analytics): compact product detail gallery and insights layout`
