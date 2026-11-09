# Buyer Profile ratings and full review identity

## Outcome

- Vendor Ratings & Reviews has Store ratings and Product reviews. Your Buyer ratings is removed; old `?tab=BUYER` links fall back to store feedback. Authorized completed-order Buyer rating actions and stored ratings remain available.
- Buyer mobile Profile shows Your Buyer rating with read-only fractional stars and an expandable, paginated Ratings from stores history. My Reviews continues to open the Buyer's submitted feedback.
- CCS remains `(Inquiry Seriousness + Communication Quality + Payment Reliability) / 3`, using all eligible ratings over 90 days before pagination and server-side decimal half-up rounding. Below five eligible completed transactions the UI shows Building your rating and the eligible count, with no numeric score. Hidden, unrevealed, dispute-withheld and investigation-excluded ratings do not contribute.
- Buyer-authored store and product reviews show the full profile name and available photo. The anonymous selector is removed. Older anonymous submissions resolve the current actual profile name at read time; original stored choices, review revisions and audit history are retained. Vendor-authored ratings identify the submitting store. No account IDs or private contact details are added to public reviews.

## Files and contract

- Vendor: `apps/vendor-web/src/pages/VendorReviewPages.tsx` and its component/browser tests; shared review name fallbacks and avatar handling in `packages/web-ui/src/review-details.tsx`, `review-overview.tsx` and `review-author-avatar.tsx`.
- Buyer: `screens/buyer_profile_screen.dart`, `screens/buyer_home_screen.dart`, `features/trust/buyer_ratings_section.dart`, `reviews_repository.dart`, `trust_models.dart` and `order_reviews_screen.dart`. Shared `design_system/components/star_rating.dart` supports fractional scores and wraps read-only criterion rows for large text.
- API: Review controller, access-scoped queries, presenter, rules and submission service; `ScoreRules::MIN_BUYER_RATINGS`; review routes and focused API/unit tests.
- OpenAPI adds `GET /api/v1/buyers/ratings`, the received-rating envelope/summary/row models, and the sole current `FULL_NAME` display option. The deprecated submission field accepts older choices only for compatibility; the server always stores `FULL_NAME` for new Buyer submissions. Both generated clients and Dart serializers are regenerated, and the TypeScript client is built.
- The System, Buyer and Vendor workflows and UI/UX planner record the 2026-11-05 owner decision. PostgreSQL schema documentation is regenerated.

Migration `2026_11_05_130000_use_full_buyer_review_identity.php` allows the new choice, changes the default to `FULL_NAME`, widens stored display names to 160 characters and adds a partial index for received Buyer ratings. It does not rewrite existing reviews. Rollback is deliberately forward-only to retain review identity history.

The migration passed an empty isolated database build and a no-op migration rerun. Only this migration was then applied to the running local development API; no unrelated pending migration was applied. The new Buyer route was verified locally. No credential/configuration key, new write action, audit event or notification is required. Existing review mutations retain their audits and idempotency.

## Verification

- API/rule suites: **20 tests, 498 assertions passed**. Covers Buyer-only scope, Vendor denial, CCS sample eligibility, 90-day exclusion, pagination, reveal/moderation rules, full-name legacy projection, retained original names, protected photos and existing review operations.
- Buyer focused suites: **36 tests passed** across Profile, ratings, API decoding, review submission and fulfillment. Includes published/unpublished scores, empty/error/retry states, full-name submission, Manila dates, and expanded ratings at 320 px with 2x text.
- Full Vendor suite: **86 files, 802 tests passed**. Focused review suites: 33 tests passed.
- Full Admin suite: **42 files, 282 tests passed**.
- Vendor browser flow: **8 configured viewports passed**, including removal of Your Buyer ratings, full reviewer names, photos, filters, keyboard details/back navigation and reporting.
- Flutter analysis: **no issues found**. PHPStan: **no errors**. Pint: **13 affected files passed**. OpenAPI validation passed with existing unused-model recommendations. The trust contract passed **43 operations** using the isolated environment's route export after the host PHP export timed out.
- Vendor/Admin lint, typecheck and builds passed; existing Vendor unused-variable and bundle-size warnings remain. Generated TypeScript build and Dart serializer generation passed. Schema documentation check passed.
- The Dart review serialization contract and analysis of the new generated Buyer API/models passed. Final shared star/Profile files passed targeted analysis with fatal infos enabled. Scoped source secret scanning and the final diff whitespace check passed; the staged scan contained no staged content.

Physical-phone appearance and rebuilding/hot-restarting an already installed Buyer app remain manual. The full backend and full Flutter suites were not run for this focused slice. Browser checks use synthetic fixtures. Isolated test containers were stopped after checks, retaining their volumes and leaving development services running. No remote deployment, push or merge is performed.

Suggested commit: `feat(reviews): show buyer ratings in profile and require full identity`.
