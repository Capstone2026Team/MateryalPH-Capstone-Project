# Phase 4 layout evidence

Screenshots from `apps/vendor-web/e2e/phase-4-catalog.spec.ts` at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px (`<width>-<screen>.png`).

These show **layout only**. Every `/api/v1` response is a synthetic fixture, so the screenshots say nothing about live DTI-BPS register data, storage, malware scanning or mail readiness.

| Screen | Vendor / Admin route |
| --- | --- |
| `products-list`, `products-delete-dialog`, `products-table`, `products-empty` | `/products` (grid, table view, empty state) |
| `wizard-create` | `/products/new` |
| `wizard-material`, `wizard-product-information`, `wizard-compliance-preview`, `wizard-photos-compliance`, `wizard-compliance-submitted`, `wizard-review` | `/products/:listingId?step=0…3` |
| `import-validation`, `import-applied` | `/products/import` |
| `admin-compliance-queue`, `admin-compliance-case`, `admin-compliance-decided` | Admin `/product-compliance`, `/product-compliance/:submissionId` |

At 1024 px and wider the portal normally scrolls inside `.portal-workspace`. For these captures only, the spec releases that inner scroll so each screenshot shows the whole page. Product photos are a neutral SVG placeholder.

Regenerate: build both web apps, then `cd apps/vendor-web && npx playwright test e2e/phase-4-catalog.spec.ts`.
