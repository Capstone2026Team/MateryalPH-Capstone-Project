# System audit and Buyer discovery — 2026-10-24

Scope: the owner's implementation handoff, including all twenty named High/Medium finding groups and the 2026-10-24 map decisions. The supplied original audit path contains that same handoff rather than a separate itemized report. Unnamed findings are not invented. Existing unrelated README, Vendor processing-label and messaging participant changes were preserved. No commit, push or deployment is authorized.

## Decisions and boundaries

- Directory Suppliers alone support minimum **Google rating** (3.0, 3.5, 4.0, 4.5) and maximum geodesic distance (1, 3, 5, 10, 20 km, never beyond the selected radius). A minimum excludes unrated places. Verified Vendors and VPS are unaffected. Favorite, supplier-type and category filters continue to hide Directory Suppliers.
- Nearby coverage is supplemented by keyword Text Search, deduplicated by Place ID and cached for seven days. Every provider page consumes the existing daily budget. Cached usable results survive provider failure; supplier coverage is never represented as exhaustive.
- Superseded/failed geographic run metadata is retained for **30 days**, per owner answer. Published runs and runs referenced by facts are preserved. Schedule frequency is unchanged.
- Tier 1 remains informational. Ratings are attributed Google data, never a VPS or ScoreLabel. Private documents, commercial records and immutable decisions retain their existing access rules.

## High/Medium findings

“Fixed” describes implementation; verification evidence and device acceptance are recorded separately below. Original identifiers H1/H2/M9–M12 are preserved where supplied; other identifiers below refer to handoff item numbers.

| Finding | Status and resulting behavior | Source and regression reference |
| --- | --- | --- |
| A1: obsolete scheduled evidence/media commands | Fixed. Inspected deletion commit 5fa93a93c: the old onboarding commands were retired; current expiry work already has its own service/scan. Removed only the two obsolete entries. Every scheduled command must exist in Artisan. | services/api/routes/console.php; tests/Feature/SystemAuditRegistrationTest.php |
| A2: unregistered Project outbox events | Fixed. Registered the four requested draft/supplement events. The registration test found five more legitimate arrangement/inquiry/procurement record events; these are recorded too. | services/api/app/Domain/Operations/OutboxProcessor.php; tests/Feature/SystemAuditRegistrationTest.php |
| A3: expected 4xx stack-trace flood | Fixed. Authentication, validation and domain/HTTP 4xx exceptions are not reported; unexpected 5xx still are. Example logging uses daily rotation, 14 days. PHPUnit forces the null channel. | services/api/bootstrap/app.php; .env.example; phpunit.xml; SystemAuditRegistrationTest.php |
| A4: geographic revision race and run retention | Fixed. Revision allocation follows the PostgreSQL advisory lock; failed run metadata remains available and eligible old unreferenced metadata is pruned after 30 days. | services/api/app/Domain/Analytics/Geo/GeoFactsBuilder.php; tests/Feature/Api/GeoRunRetentionTest.php |
| A5: messaging inbox/header/message N+1 | Fixed. Request scope is reused; batched headers, unread counts, attachments, receipts and product availability use bounded queries. Query-count assertions compare one/six conversations and one/twenty messages. | services/api/app/Domain/Messaging/ConversationHeaders.php; ConversationService.php; ConversationAccess.php; ConversationProducts.php; tests/Feature/Api/PhaseNineMessagingTest.php |
| A6: duplicate queued outbox dispatch | Fixed. Immediate publication and scheduled dispatch both claim an expiring lease. Dispatch occurs outside the database transaction; failed enqueue releases the lease. Expired leases can be reclaimed. | services/api/app/Console/Commands/DispatchOutbox.php; app/Domain/Operations/OutboxPublisher.php; tests/Feature/Api/OutboxDeliveryTest.php |
| A7: missing inactive-other-staff coverage | Fixed. An inactive other participant does not deny the authorized active caller access; their recorded identity/role remains readable and inactive handlers are not offered. | services/api/app/Domain/Messaging/ConversationAccess.php; tests/Feature/Api/PhaseNineMessagingTest.php |
| A8: Admin assignment unhandled failure/double click | Fixed. Busy control prevents repeats; a caught failure displays a recoverable error while retaining the case. | apps/admin-web/src/pages/DisputePages.tsx; DisputePages.test.tsx |
| A9: empty later page hides navigation | Fixed. An empty page after page one retains Previous navigation. | apps/admin-web/src/components/OperationsKit.tsx; OperationsKit.test.tsx |
| A10: date-only Manila shifts and duplicate today logic | Fixed. Date-only display no longer forces UTC; form date values use local midnight; Manila today comes from the shared calendar helper. | apps/vendor-web/src/pages/OrderPages.tsx; InvoicePages.tsx; components/SiteInspectionPanel.tsx; src/lib/system-audit.test.ts |
| A11: payment/mutation idempotency key lifecycle | Fixed. A new terminal/expired payment attempt gets a new key. Confirmation, fulfillment/cancellation, dispute and invoice requests retain their key after uncertain transport, timeout or server failures; definitive 4xx except timeout rotates it through one shared helper. | packages/web-ui/src/idempotency.ts; apps/vendor-web/src/pages/{FinancePages,OrderPages,OrderFulfillmentPanels,DisputePages,InvoicePages}.tsx; src/lib/system-audit.test.ts |
| A12: analytics export ignores search/category | Fixed. Export passes q and category_id; both are declared in OpenAPI and regenerated clients. | apps/vendor-web/src/lib/trust-api.ts; packages/api-contract/openapi.yaml |
| A13: unused server field errors and past delivery date | Fixed. Shared orderFieldErrors is wired into confirmation, milestones and invoices. Delivery dates before Manila today are blocked. | apps/vendor-web/src/lib/orders-api.ts; src/pages/OrderPages.tsx; OrderFulfillmentPanels.tsx; InvoicePages.tsx |
| A14: blocked evidence/payment popup | Fixed. A window is opened synchronously in the click and navigated after the request; evidence object URLs are revoked on replacement/disposal. Visible fallback links are available. | packages/web-ui/src/pending-window.ts; apps/vendor-web/src/pages/OrderFulfillmentPanels.tsx; FinancePages.tsx |
| A15 / H1: access-token expiry signs out Buyer | Fixed. A shared QueuedInterceptor coordinates one refresh and retries each protected request once. Concurrent old-token 401s reuse the replacement token. Refresh rejection ends the session; transient refresh failures retain it. Token storage writes/clears are serialized and guarded against sign-out races. A resource 401 after a successful refresh does not clear valid tokens. | apps/buyer-mobile/lib/auth/auth_repository.dart; core/api_guard.dart; test/session_recovery_test.dart |
| A16 / H2: splash hangs on storage/bootstrap failure | Fixed. Token restoration and bootstrap handle storage errors, clear local tokens best effort and show Welcome. Storage failure on a fresh install also skips onboarding. | apps/buyer-mobile/lib/main.dart; auth/auth_repository.dart; test/buyer_app_test.dart; session_recovery_test.dart |
| A17 / M11: offline cold start loses session | Fixed. Cached encrypted tokens open the shell with an offline notice after transient revalidation failure. While offline the shell retries revalidation every 15 seconds and removes the notice when verification succeeds. | apps/buyer-mobile/lib/main.dart; auth/auth_repository.dart; test/session_recovery_test.dart; buyer_app_test.dart |
| A18 / M9: deletion/support sign-out leaves caches/drafts | Fixed. Shell session expiry, successful sign-out, deletion and support callbacks share cleanup of result cache, inbox/navigation and chat drafts. Draft writes are invalidated/awaited so disposal cannot recreate a signed-out draft. Cleanup tolerates unavailable storage. Failed sign-out remains retryable on the current page. | apps/buyer-mobile/lib/screens/buyer_home_screen.dart; features/messaging/chat_drafts.dart; auth/auth_repository.dart; test/auth_presentation_test.dart |
| A19 / M10: review dialog controller disposed too early | Fixed. showBuyerFormDialog owns controller disposal after the dialog route completes. | apps/buyer-mobile/lib/features/trust/order_reviews_screen.dart |
| A20 / M12: project models serialized back into maps | Fixed. Repository methods return generated types. Project, Work Package, arrangement, comparison, quotation, checkout, material and ranking screens consume typed fields. The checkout project picker and order budget boundary are adapted too. UI projections carry only needed fields; request drafts and contract-declared freeform JSON remain maps. | apps/buyer-mobile/lib/features/projects/; features/item_procurement/checkout_project_screen.dart; features/orders/order_details_screen.dart; test/typed_project_fixtures.dart and existing Project regressions |

## Directory coverage and map implementation

| Change | Status and references |
| --- | --- |
| Broader allowed construction-material searches | Fixed: hardware_store, home_improvement_store and building_materials_store. Nearby grid cap defaults to 121; six text queries use coarse 20 km rectangles and at most three 20-result pages. services/api/config/services.php; .env.example; app/Infrastructure/Geography/GooglePlacesProvider.php. |
| Text pagination, filtering, budget | Fixed: PH region and rectangle restriction; every page charged before sending; closed/non-PH/disallowed-type places excluded; rating/count parsed. Adapter fakes cover paging, masks, filtering and budget exhaustion. tests/Unit/GeographyProviderAdapterTest.php. |
| Cache and per-cell count | Fixed: text v1/query/rectangle keys; Nearby cell v4 keys; per-cell result_count uses each place's originating cell keys, including duplicate IDs across cells/pages. app/Domain/Geography/DirectorySupplierService.php. |
| Tier 1 rating/distance validation and filtering | Fixed: allowlisted values, distance <= radius, unrated exclusion with minimum, unchanged Tier 2 rows, correctly attributed rating summary. app/Domain/Geography/SupplierDiscoveryService.php; app/Http/Controllers/Api/BuyerDiscoveryController.php; tests/Feature/Api/PhaseSixBuyerDiscoveryTest.php. |
| Buyer filter sheet/cards/cache | Fixed: Directory section with rating/distance chips and disabled explanation for Tier 2-only filters; values included in activeCount and requests; ratings retained in cached cards. apps/buyer-mobile/lib/features/map_discovery/{discovery_models,discovery_repository,discovery_result_cache,map_home_screen,supplier_panels}.dart; test/directory_filters_test.dart. |
| Teardrop/glyph/favorite/selected/cluster markers | Fixed: orange check, white/steel-gray building, gold ring/path star, charcoal selected outline and raised order, segmented cluster ring and favorite count. Semantic map colors regenerated from design tokens. supplier_map.dart; packages/design-tokens/tokens.json; test/supplier_marker_golden_test.dart; test/goldens/supplier-markers.png. |
| Clustering and render work | Fixed: deterministic greedy screen-distance clusters, 64 px through zoom 11 sliding to 36 px at 13, individuals from 13.5; half-zoom-band pinch updates throttled at 60 ms, idle 60 ms, result-page coalescing 100 ms, parallel icon rendering, common-icon prewarm, LRU about 600, separate cached label bitmaps. Stable member IDs feed cluster IDs. Cluster tap fits bounds; co-located/max-zoom results fan out. map_geometry.dart; supplier_map.dart; test/map_discovery_test.dart. |

Current Google references checked on 2026-10-24: [Places types](https://developers.google.com/maps/documentation/places/web-service/place-types), [Text Search request/pagination](https://developers.google.com/maps/documentation/places/web-service/text-search), and [Nearby field masks and billing tiers](https://developers.google.com/maps/documentation/places/web-service/nearby-search). Rating fields increase the search SKU tier; the page budget bounds call volume, not a fixed currency bill. Defaults retain 2,000 Places calls/day and a seven-day cache. Confirm actual provider billing and Integration Health on the configured environment.

## Migrations, contract and documentation

New forward-only migrations, applied in the isolated test schema and local development API:

1. services/api/database/migrations/2026_10_24_000001_add_dispatch_lease_to_outbox_events.php: nullable indexed dispatched_until.
2. services/api/database/migrations/2026_10_24_000002_add_google_rating_to_directory_suppliers.php: nullable NUMERIC(2,1) rating checked 1–5; nullable integer count checked >=0.

No applied migration was edited. Published/current/referenced analytics runs and commercial history were retained.

OpenAPI version: 1.0.1-audit.2026-10-24. DiscoverySearchRequest remains closed and adds the two Directory-only numeric enums. DirectorySupplierSummary.google_rating reuses GoogleRating. Vendor analytics export declares q/category_id. WorkPackageView now declares existing procurement resume fields; ProjectSeparatePurchase declares its existing public load classification so typed clients retain these server fields. TypeScript and Dart clients were regenerated, including Dart serializers, rather than hand-edited. Contract regressions cover geography filters/attribution and retained Project fields.

Updated Buyer/System workflows, UI/UX planner (Google labeling, pins and cluster tuning), and phase-six-buyer-discovery.md. DESIGN.md remains valid and unchanged. Memory changes are submitted as an authorized memory update note, superseding the 2026-09-28 no-rating-filter decision.

## Low backlog

| Item | Status and reference |
| --- | --- |
| Duplicated peso parsers | Backlog. apps/vendor-web/src/lib/orders-api.ts (pesoInputToCentavos), packages/web-ui/src/money-input.ts and apps/buyer-mobile/lib/design_system/components/peso_amount_field.dart; consolidate only with equivalent rounding/input tests. |
| Chat money formatting consistency | Backlog. apps/buyer-mobile/lib/features/messaging/messaging_screen.dart and its chat/quotation presentation components; reported in the handoff and retained for a focused consistency review. |
| Admin loading flicker | Backlog. apps/admin-web/src/lib/operations-hooks.ts and page loading states; retain authorization and filter reset behavior. |
| Reported README truncation | Backlog verification. README.md; preserve existing owner edits. A truncated tool display is not evidence that the file itself is truncated. |
| Remaining unnamed Low findings | Backlog pending an itemized source report. The supplied plan names no additional concrete Low findings or file references. |

## Verification

| Gate | Exact result and evidence |
| --- | --- |
| Isolated API full suite | **733 passed, 15,141 assertions**, 661.32 s. .tmp/audit-api-full.log. Focused audit/provider/discovery/messaging suite: **83 passed, 2,742 assertions**. .tmp/audit-api-focused.log. |
| API static/style | Pint --test: **824 files passed** (.tmp/audit-pint-test.log). PHPStan analyse --memory-limit=512M: **no errors** (.tmp/audit-phpstan.log). |
| Vendor lint/typecheck/build | Passed. One existing unused inStore warning in e2e/admin-finance-layout.spec.ts; production bundle-size warning remains. .tmp/audit-vendor-{lint,typecheck,build}-final.log. |
| Vendor full tests | **69 files, 632 tests passed**, with two workers. .tmp/audit-vendor-tests-final.log. The compact order date fix was subsequently checked in both timezones, followed by lint/typecheck/build. |
| Calendar-date regressions | **47 tests passed in Asia/Manila and 47 in UTC**, including compact/full order displays and local-midnight behavior. .tmp/audit-dates-manila-verified.log; .tmp/audit-dates-utc-final.log. |
| Admin lint/typecheck/build | Passed; production bundle-size warning remains. .tmp/audit-admin-{lint,typecheck,build}-final.log. |
| Admin full tests | **27 files, 162 tests passed**, two workers. .tmp/audit-admin-tests-verified.log. |
| Buyer analyzer | **No issues found** after the final auth change. .tmp/audit-buyer-analyze-final-complete.log. |
| Buyer tests | **560 passed, one skipped, zero failures**, after the final sign-out/write race fix. .tmp/audit-buyer-tests-final-complete.log. The seven focused session-recovery tests also pass (.tmp/audit-auth-race-test.log). **+12 passing tests** versus the measured baseline; skip count unchanged. |
| Marker golden | Passed and visually inspected: checks, building, gold path star/ring, selected outline, segmented cluster and numeric favorite count. .tmp/audit-marker-golden-4.log; apps/buyer-mobile/test/goldens/supplier-markers.png. |
| Contract/client generation | OpenAPI validation passed with eight existing unused-model recommendations. TS client build and Dart build_runner completed. Geography **18**, Projects **35**, Payments **44**, Fulfillment **31**, Disputes **58**, Trust/analytics **39**, Product analytics **3** operations passed their contract checks; portal-date contract passed **32** dated reads plus notification bulk read. |
| Configuration/tokens/whitespace | docker compose config --quiet, design-tokens check and git diff --check passed. Local migrate:status confirms both new migrations ran in batch 61. |
| Secret scan | gitleaks git --staged --redact --no-banner passed (**zero staged bytes**). Additional redacted scan of changed source/docs/generated files passed (**more than 11 MB**); real ignored environment/credential files were excluded. A final scan refresh covers the completed report and auth changes. |

Baseline comparison: the measured pre-change Buyer run had **548 passed, one skipped, zero failures** (.tmp/audit-buyer-baseline-elevated.log). The older memory's twelve pre-existing failures are historical and were not used to excuse regressions. Earlier interim runs exposed the logout ordering, retry-error mapping and golden-font issues, which were corrected. A concurrent Admin test/client-build run hit a transient generated-file import and two timeouts; its stable rerun passed all 162 tests. One Manila delivery component test timed out under cross-stack load; the one-worker rerun passed all 47 tests without changing its timeout or assertion.

The existing development services/api/storage/logs/laravel.log was observed at **1,530,865,571 bytes** and was **not deleted or truncated**. Set LOG_STACK=daily and LOG_DAILY_DAYS=14 in the environment's ignored configuration and refresh its config cache when ready; example defaults alone do not rewrite existing environment values.

## Manual acceptance and setup

Use the existing configured Google Places key; no credential values belong in source or this report. New safe settings are GOOGLE_PLACES_TEXT_QUERIES, GOOGLE_PLACES_TEXT_CELL_KM and GOOGLE_PLACES_TEXT_MAX_PAGES; the example Nearby cell cap is GOOGLE_PLACES_MAX_SEARCH_CELLS=121. Existing environment overrides must be reviewed locally to adopt these values. No remote migration or deploy was performed.

On a Buyer device with Places enabled, zoom 10 to 15 over Metro Manila and confirm clusters separate during the pinch. Tap co-located clusters/pins to check fan-out and tap dispersed clusters to check bounds zoom. Confirm minimum Google rating/distance chips affect Directory pins only, and Tier 2-only filters hide the Directory section/results. Check real map labels, selected/favorite rings, attribution and the rating card. Check Integration Health for cache reuse and page-by-page budget burn. Validate real popup/download behavior and a 15-minute access-token expiry with a valid refresh token. These device/provider/browser checks have not been claimed as passed.

Suggested conventional commit after owner review: fix: resolve system audit defects and improve buyer discovery
