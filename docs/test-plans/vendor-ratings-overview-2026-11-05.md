# Vendor Ratings & Reviews overview

The later owner request in `buyer-profile-ratings-2026-11-05.md` supersedes this page's earlier anonymous-review behavior and Your Buyer ratings tab: Buyer-authored reviews now show full identity, and received Buyer ratings live in mobile Profile. The validation below records the original overview slice.

The reference-inspired `/reviews` workspace uses three white summary panels (review statistics, a criterion rating ring and recent feedback), followed by a responsive review-card grid. MateryalPH's orange semantic tokens, review tabs and date picker remain in use. Cards, recent feedback and review details show the Buyer's current profile picture when the review uses a named Buyer identity. Missing, denied, expired or undecodable pictures use a neutral person icon. Anonymous `Verified Buyer` reviews and store-authored Buyer ratings do not expose a Buyer picture.

## Data and behavior

- Total reviews/ratings comes from the paginated response's server total. Written-comment counts explicitly describe this page.
- Product Quality average and star buckets use the server summary before pagination, within the current submitted-date scope.
- Store and Buyer criterion averages/distributions describe the loaded page explicitly. Delivery Speed and Processing Speed remain separate; no new VPS, VCS, MQS or CCS formula is introduced.
- Review details, original purchase snapshots, private review attachments, reporting/idempotency, permission gates, pagination, date filtering and return context remain intact. Product Analytics keeps its existing all-time review scope.

## Files and contract

- Vendor workspace: `apps/vendor-web/src/pages/VendorReviewPages.tsx`.
- Shared presentation: `packages/web-ui/src/review-overview.tsx`, `review-workspace.css`, `review-author-avatar.tsx`, `review-details.tsx`, `review-patterns.tsx` and the shared export.
- Protected photo transport: `packages/web-ui/src/web-api-session.ts`.
- Review API: `ReviewQueries`, `ReviewController` and `services/api/routes/trust.php`.
- OpenAPI adds optional nullable `VendorReviewRow.buyer_avatar_url` and `GET /api/v1/vendor/reviews/{reviewId}/buyer-photo`. TypeScript and Dart clients are regenerated.
- No migration, configuration key, credential, new mutation, audit event or notification is required. Existing uploaded profile photos are sanitized PNGs behind private storage.

The photo endpoint requires a five-minute signed URL, a current authorized Vendor session, `reviews.view`, matching store ownership, a named Buyer-authored received review, and all existing review visibility gates on every request. It returns private, uncached PNG bytes without publishing Buyer IDs, contact information or storage paths. The browser validates the API origin, exact review route and PNG MIME type, uses authenticated blob transport, and releases object URLs on source changes or unmount. Expired photo links fall back locally without logging out a valid session.

## Checks

- Review API suite: 12 tests / 349 assertions passed in the guarded isolated PostgreSQL test environment. Includes photo signature, anonymity, missing photos, foreign store, revoked role, hidden/unrevealed reviews, expiry, and existing dispute/exclusion gates.
- Review page, overview, avatar and private-media component suites: 32 tests passed.
- Full Vendor suite: 86 files / 801 tests passed. Full Admin suite: 42 files / 282 tests passed.
- Browser flow: all 8 configured viewports passed (320, 375, 390, 768, 1024, 1280, 1440 and 1920 CSS pixels). Covers layout/overflow, authenticated PNG decoding, anonymous fallbacks, tabs, date filtering, pagination, keyboard details/back navigation and report submission. Screenshots use synthetic fixtures rather than real Buyer identities.
- PHP Pint (4 affected files), PHPStan, OpenAPI validation and the 42-operation trust contract passed.
- Dart serializer generation, the Vendor review serialization contract (including nullable photo links), and analysis of the three regenerated review client files passed. The installed Dart runtime was used directly after the Flutter batch launcher stalled.
- TypeScript client build, Vendor/Admin typecheck and production builds passed. Existing bundle-size warnings remain; Vendor lint reports an existing unused variable in `e2e/admin-finance-layout.spec.ts`.
- Working-tree diff check and scoped source secret scan passed. The staged secret scan had no staged content.

Live Buyer photo appearance and profile changes should also be checked with a named review belonging to the signed-in store. Keep anonymous reviews anonymous. No deployment is performed. The full backend and Buyer Flutter suites were not run for this focused Vendor review change. Isolated API test containers were stopped after checks, retaining their volumes.

Suggested commit: `feat(vendor): improve review overview and show protected buyer photos`.
