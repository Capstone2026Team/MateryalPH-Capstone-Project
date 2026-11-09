# Reviewed product photo and analytics shortcut — 2026-11-05

Vendor `/reviews/:reviewId` now shows the reviewed listing's current catalog photo beside its purchased name and variant, and a **View product analytics** link to `/analytics/products/:listingId`. The link requires the existing `catalog.manage` permission. Reviews opened from Product Analytics retain the product, period and review pagination on return.

## Implementation

- `packages/web-ui/src/review-details.tsx` reuses `MaterialThumbnail` with its missing/failed-image fallback and an optional product action slot. The header stacks on smaller screens.
- `apps/vendor-web/src/pages/{TrustPages,VendorReviewPages}.tsx` supplies the permission-scoped link and supports the current analytics return route.
- `services/api/app/Domain/Reviews/ReviewQueries.php` includes optional, nullable `product.image_url` in Vendor review details only. It selects ready, clean listing images owned by the review's store, using the existing catalog delivery service. It does not add media queries to paginated review lists or alter purchased snapshots.
- `packages/api-contract/openapi.yaml` documents the additive field. TypeScript and Dart clients and Dart serializers were regenerated.
- No migration, new route, new role grant, notification or audit mutation is required for this read-only presentation change.

## Verification

Passed locally:

- Isolated API review/rating suites: **20 tests, 514 assertions** (`PhaseFourteenReviewsScoresTest|PhaseFourteenRulesTest`). Coverage includes missing/unscanned/removed photos, authenticated image delivery, cross-store denial, Customer Service viewing, purchase snapshots and existing review visibility gates.
- Focused Vendor review/media/overview/avatar components: **36 tests across 4 files**. Coverage includes exact product navigation, catalog permission, failed-image fallback, Store review handling and analytics return context.
- Playwright `e2e/reviews-layout.spec.ts`: **8 passed**, at 320/375/390/768/1024/1280/1440/1920px. Mocked browser checks verify image decoding, the exact analytics link and no page overflow. Desktop and mobile screenshots were inspected.
- Vendor lint, typecheck and production build; Admin typecheck for the shared component.
- API Pint on the two changed PHP files and PHPStan across 585 files.
- OpenAPI validation; trust contract across 43 operations; TypeScript client build; Dart serializer generation and Vendor review round-trip contract, including present, null and omitted product photo URLs.
- Compose configuration validation, changed-source and staged Gitleaks scans (no leaks), and `git diff --check`. The isolated test services were stopped afterward; development services were left running.

Existing advisory output: Vendor lint's unrelated unused `inStore` fixture variable, Vite's bundle-size advisory and eight OpenAPI unused-model recommendations.

Manual acceptance: open a published Product Review with a real uploaded listing photo as an authorized Vendor member, confirm the photo and exact product analytics destination, then repeat as Customer Service to confirm the photo remains visible while the analytics shortcut is absent. Browser layout evidence uses mocked media; physical-device and live-storage checks were not performed for this change.

Suggested commit: `feat(reviews): add product photo and analytics shortcut`
