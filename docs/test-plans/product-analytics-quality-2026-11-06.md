# Product Analytics quality cards — 6 November 2026

Product Analytics now places the shared Material quality (MQS) card beside a Top-rated products list above the trend. Both cards align on desktop and stack on phones. MQS retains the published Store Performance score, eligible count, five-point ring, rating breakdown and rolling 90-day note. Top-rated products shows up to five of the Vendor's published products, their existing all-time product average out of five, rating count and a link to the exact listing's analytics.

## Scope and authorization

- MQS still requires `scores.view_store`, uses `GET /vendor/performance`, and preserves its rolling 90-day/five-eligible-rating publication rule. Its loading, failure and retry are independent of product analytics. Changing the product period does not change or refetch MQS.
- Top-rated products requires `reviews.view` in addition to the existing Product Analytics `catalog.manage` entry gate. Inventory Staff receive no score or review grant. Sales values retain `finance.view`.
- `GET /vendor/product-analytics` adds optional nullable `top_rated`: at most five `{ listing_id, name, category, average, count }` records, or null without review access. An empty array means no rated published products. No request parameter or endpoint changed.
- The domain service reuses `ListingPublicFacts::productRatings` for every own-store published listing before analytics table pagination. It ranks by the existing two-decimal all-time product average descending, rating count descending and listing ID ascending. Unrated and foreign products do not appear. The selected analytics period does not change product averages. MQS is a separate Vendor score.
- The existing eligibility query withholds blind/unrevealed, moderated, actively disputed and score-excluded reviews. No reviewer identity, private file, exact stock or financial data is added to the ranking.
- This is read-only. No migrations, audit/event writes, notifications, credentials, manual setup or deployment are required.

## Files

- Vendor UI: `apps/vendor-web/src/pages/ProductAnalyticsPages.tsx`, `TrustPages.tsx`, `ProductAnalyticsPages.test.tsx` and `apps/vendor-web/e2e/product-analytics-layout.spec.ts`.
- Shared UI: `packages/web-ui/src/store-performance-overview.tsx`, `analytics-layout.css` and `index.ts`. Store Performance reuses the extracted MaterialQualityCard without changing its behavior.
- API and tests: `services/api/app/Domain/Analytics/Products/VendorProductAnalytics.php` and `services/api/tests/Feature/Api/ProductAnalyticsTest.php`.
- Contract: `packages/api-contract/openapi.yaml`, `package.json`, `scripts/check-product-analytics-contract.mjs`, `scripts/check-product-quality.dart`, generated TypeScript/Dart models, indexes, serializers and documentation. Both clients were regenerated with the repository generator; TypeScript was built and Dart built_value outputs regenerated.
- Guidance: the Vendor workflow, UI/UX implementation planner and this record.

## Executed validation

| Check | Exact result |
| --- | --- |
| Isolated stack `scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning -SkipBuild -SkipComposer` | Passed static/live isolation and negative-case checks. |
| Isolated API `php artisan test --compact --no-ansi tests/Feature/Api/ProductAnalyticsTest.php` | 6 tests passed, 250 assertions. First attempt had a duplicate-table migration collision; a retry after checking no concurrent test process passed. |
| Isolated API `php artisan test --compact --no-ansi tests/Feature/Api/PhaseFourteenReviewsScoresTest.php tests/Unit/ProductAnalyticsRankingTest.php` | 15 tests passed, 408 assertions. |
| Isolated Pint on the changed domain service and feature test | Passed, 2 files. |
| Isolated full configured PHPStan `--memory-limit=512M --no-progress` | Passed, no errors. |
| Contract `npm.cmd run validate` | Passed; eight unused-model recommendations. |
| Contract `npm.cmd run test:product-analytics-contract` | Passed, three operations. |
| Contract `npm.cmd run generate` and generated TypeScript `npm.cmd run build` | Passed. |
| Generated Dart offline dependency resolution and `dart run build_runner build` | Passed; 22 outputs. Initial native SDK access and Windows mapped-file errors were resolved through approved SDK access and backing up the generated serializer before rebuilding it. |
| Dart `--packages=generated/dart/.dart_tool/package_config.json scripts/check-product-quality.dart` | Passed: ranked, empty, null and omitted rankings; exact decimal average, count and listing-ID round trip. |
| Dart analysis of both changed model sources and generated model parts | Passed, no issues. |
| Vendor focused ProductAnalyticsPages and TrustPages component suites | 29 tests passed, 2 files. |
| Vendor lint, typecheck and build | Passed; existing unrelated unused `inStore` lint warning and bundle-size warning. |
| Admin lint, typecheck and build | Passed; bundle-size warning. |
| Vendor full `npm.cmd run test -- --run` | 841 passed, 5 failed of 846 tests; failed files were OrderPages, CatalogPages, FulfillmentConversationDialog, VendorNavigation and vite.config. The run also emitted jsdom navigation and worker-shutdown diagnostics. |
| Serial rerun of those five Vendor files with `--maxWorkers=1` | All 186 tests passed, 5 files. No source changes were needed to make the rerun pass. |
| Admin full `npm.cmd run test -- --run` | 281 passed, 1 failed of 282 tests; a date-filter child process timed out. |
| Admin serial `npm.cmd run test -- --run src/lib/date-filter-api.test.ts --maxWorkers=1` | All 4 tests passed. No source changes were needed. |
| Product Analytics Playwright navigation/layout case at 1440, 768, 390 and 320 px | All 4 passed, including both rating cards, accessible MQS calculation help, desktop alignment, product links, empty ranking and no horizontal overflow. |
| Changed source/contract files piped to Gitleaks | Passed, no leaks in approximately 2.23 MB. |
| Final scan including generated rating models, serializers and validation record | Passed, no leaks in approximately 2.60 MB. |
| Staged Gitleaks | Passed; no staged content. |
| Final scoped `git diff --check` and whitespace checks on new validation scripts/docs | Passed. |

API fixtures verify own-store isolation, all-time ratings older than 90 days, ranking before table pagination, review-role access and blind/moderation/dispute/exclusion gates. UI tests verify independent score/review permissions, hidden unpublished values, no period-triggered score refetch and independent MQS retry.

Browser screenshots use sample API data and are saved under `.tmp/analytics-review/products/`, including `1440-product-analytics-overview.png` and `390-product-analytics-overview.png`. Desktop and mobile captures were inspected. Live backend/browser-provider integration was not exercised. The initial broad portal runs were not clean; their failing files passed in serial reruns. No full API or Flutter app suite was run for this addition.

Suggested commit: `feat(vendor): add product quality and top-rated products to analytics`
