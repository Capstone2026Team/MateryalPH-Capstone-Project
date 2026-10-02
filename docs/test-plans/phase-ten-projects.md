# Phase 10 — Projects, Work Packages, FMS and budgets

Implemented on 1 October 2026. Development activation remains pending; no deployment, commit, Git command, development reset or credential change was performed.

## Delivered behavior

- Buyer Projects retain multiple explicitly selected sites, their saved discovery origins, dates and integer-centavo budgets. Editable planning drafts can be deleted before history exists; archived Projects are read-only. Work Packages use Draft, Active, Quotation Inquiry, Vendor Selected, Awaiting Payment, In Progress, Completed and Cancelled projections. Activation freezes an original; corrections create explicit versions and expire old unassigned inquiries without deleting history.
- BOM/BOQ entry and CSV file/paste preview validate canonical materials, compatible normalized units, quantities, preferred brands and specifications. Version history is paginated. Completing the main order does not complete a package until missing purchases are completed or the Buyer explicitly waives them. Missing-line resolutions have immutable audit evidence; cancelled child purchases can be explicitly replaced while their financial history remains included.
- Compiled estimates scan eligible Bulk Yes Tier 2 organizations and active inventory within the confirmed 5/10/20/30/40/50 km radius. Complete single-Vendor matches precede partial matches, with missing quantities visible. Compatible variants can supply one requirement together. Estimates snapshot public prices, matched availability, source fingerprints, vehicles/rates and advisory delivery calculations, and expire after exactly 48 hours. Private exact inventory is not returned.
- Future awards revalidate organization, Bulk, listing, stock and vehicle/rate eligibility. Later restrictions do not rewrite locked originals, published quotation versions, accepted order terms or confirmed delivery snapshots. Schedule edits do not change estimate validity, ranking or financial arithmetic.
- The shared delivery advisor separates ready-mixed cubic metres from ordinary cargo such as bagged cement. Missing dimensions or fit remain manual review. Intended Project site and separate alternative vehicle drop-off are retained; both endpoint and rate basis are displayed. Route discovery always originates at the saved Project site. Accepted Owner/Manager-confirmed terms create the immutable arrangement.
- FMS is the normalized weighted sum of Material Match 40%, Budget Fit 25%, Distance 20% and VPS 15%. Project preferences are separate from Item-Based preferences, require exactly 100%, show an active indicator and reset to the current defaults with monotonic concurrency versions. Unknown delivery cost remains unknown and requires review. New Vendors retain their public New Vendor label.
- The synchronized Project map reuses the shared SupplierMarker, SupplierCluster, RouteOverlay and extracted SupplierPreviewSheet with a PROJECT_BASED context. It uses the retrieved Figma 1:18108 composition and provides an accessible comparison list, store/VPS labels, completeness, budget components, route distance/ETA, quotation state, message/store actions and selection with an optional informational Note. Client request generations and server version/source checks reject stale route results.
- Project inquiries reuse the Phase 9 engine. Every Vendor receives the locked original and an editable duplicate. Attachments stack below 1024px and use two columns at and above 1024px. Proposed material, quantity, price, specification, fulfillment, payment and delivery changes are summarized before acceptance. Direct selection and accepted quotation awards expire other active quotations while retaining their versions. Database uniqueness and project/package locks enforce one active main Vendor award per version; procurement remains manual, not Project auto-accept.
- FIN-11 uses three disjoint buckets: pending accepted incomplete cost, completed/retained actual cost, and paid cancelled amounts awaiting recovery. Committed is their sum and Remaining is Budget minus Committed once. Materials VAT, delivery and Buyer processing fees enter the cost; NRPC remains inside principal once. Vendor commission/withholding/fee payments do not enter Buyer budgets. Refundable paid cancellation stays committed until successful recovery. The UI shows exact amounts, a 90% warning, and a written override above 100% with an immutable decision snapshot.
- Market-analysis navigation is bound to the clicked saved Project site. The existing discovery surface states that Phase 14 market analytics is pending; historical averages never replace quotes or set budgets. Actual PDF generation remains a disabled Phase 15 placeholder.

## Files and schema

| Area | Main changes |
| --- | --- |
| Additive migration | `services/api/database/migrations/2026_10_04_000000_complete_phase_ten_projects.php` |
| Domain | `services/api/app/Domain/Projects/{ProjectService,ProjectEstimateService,ProjectInquiryService,ProjectBudget,FulfillmentMatchScore}.php` |
| Transport | `BuyerProjectController.php`, `Http/Requests/Projects/WorkPackageRequest.php`, `routes/projects.php`, `routes/api.php`, Buyer order decision fields |
| Shared commerce/messaging | Conversation and quotation services/terms/acceptance; order confirmation, Buyer decisions and order queries; shared delivery preview; outbox event classification |
| Contract | `packages/api-contract/openapi.yaml`, Project author/check scripts, package manifest, regenerated TypeScript/Dart clients and serializers; Project contract added to CI |
| Buyer | `lib/features/projects/`; shared WorkPackageAttachment and SupplierPreviewSheet; home navigation, Project-site analysis navigation, chat and Order Details integration; PROJECT_BASED map context |
| Vendor | `src/components/WorkPackageAttachment.tsx`, MessagingPage and OrderPages; component and browser tests |
| Tests/evidence | API PhaseTenProjectsTest and PhaseTenProjectCalculationsTest; PhaseNineMessagingTest fixture alignment; Buyer Project tests, existing repository fakes, reviewed shared-map goldens; `docs/design/evidence/phase-10/` |
| Architecture | Schema-derived `docs/architecture/erd.md` and `data-dictionary.md` regenerated from the isolated PostgreSQL database |

The migration extends the existing Projects, sites, Work Packages, ranking preferences, compiled estimates and order tables. It adds missing-line resolutions and source/snapshot fields rather than parallel commerce modules. Locked originals and their lines, estimate source/expiry, compiled candidates, budget overrides and Project conversation references have database mutation protection. A partial unique index prevents concurrent active main awards for one version. Rollback refuses retained Project history; empty isolated schemas can roll back safely for committed concurrency tests. No previously applied migration was edited.

## API and authorization

Contract version `1.0.0-phase.10` adds 23 operations across 16 Project paths and 36 schemas. Operations cover Project CRUD, Work Package draft/version/activation/closure, CSV preview and material lookup, compilation/candidate routes, inquiries/selection, missing-line resolution and Project ranking preferences. Lists are paginated. Creation, correction, activation, inquiry and selection use idempotency keys where retry-sensitive; mutable resources use lock versions and immutable acceptance uses the existing quotation version/hash boundary.

The routes require an authenticated current mobile Buyer. Every resource rechecks Buyer ownership; cross-account IDs return unavailable. Vendor quotation publication retains the existing fixed Owner/Manager authority and Bulk/new-work gates. Provider calls run outside database locks; award/reservation transactions lock Project, package, organization and stock deterministically. Audits and outbox events follow the existing transaction boundary. Existing private messaging/files, CSRF/cookie/mobile token rules and finance boundaries remain enforced.

## Validation evidence

| Command/check | Exact result |
| --- | --- |
| Isolated `api-test php artisan test` | **409 passed, 6,645 assertions**, 441.20 seconds |
| Final isolated `php artisan test --filter=PhaseTenProjectsTest` | **13 passed, 263 assertions**, 18.88 seconds; includes final archived guard changes |
| `php vendor/bin/phpunit tests/Unit/PhaseTenProjectCalculationsTest.php` | **6 passed, 29 assertions**; also included in full API suite |
| `php vendor/bin/phpstan analyse --memory-limit=512M` | **No errors**, 316 source files |
| Pint on all changed PHP paths, then final controller/test rerun | **Passed** |
| Vendor `npm run lint`, `npm run typecheck`, `npm run build` | **Passed**; existing large bundle advisory remains |
| Vendor `npm run test -- --run --maxWorkers=2` | **218 passed, 28 files**, 36.99 seconds |
| Vendor `npx playwright test e2e/project-quotation.spec.ts` | **8 passed**, 7.7 seconds, widths 320/375/390/768/1024/1280/1440/1920 |
| Admin `npm run typecheck` | **Passed**; shared generated-client consumer only, no Admin UI edits |
| Buyer `flutter analyze` | **No issues** |
| Buyer full `flutter test` | **209 passed, 1 existing opt-in capture skipped**, zero failures; final empty-map presentation subsequently verified by the focused Project suite |
| Final Buyer `flutter test test/projects_phase_ten_test.dart --update-goldens` | **7 passed**, mobile/desktop archived controls, selected-site navigation, locked map origin, transport, money, responsive attachments and FIN buckets |
| Final Buyer `flutter test test/projects_phase_ten_test.dart test/messaging_test.dart test/orders_test.dart` | **20 passed**, including golden comparison without baseline updates and shared chat/order interactions |
| OpenAPI `npm run validate` | **Passed** with three existing unused-model recommendations: FinancialSnapshot, FeeAssessment, MaterialPriceObservation |
| Contract checks | **Project 23 operations passed** using native and exported route input; **Messaging 25 operations passed**; existing Orders check passed |
| Generated TypeScript `npm run build` and Dart `dart run build_runner build --delete-conflicting-outputs` | **Passed**, generated serializers rebuilt |
| `php artisan materyalph:schema-document` and `--check` in isolated API | **Generated; matches migrated database** |
| Development and isolated `docker compose … config --quiet` | **Passed**, no expanded environment output |
| Gitleaks directory scans with `--redact --no-banner` | **Zero findings** across 14 source/generated/migration/test/CI/report targets |
| Explicit source whitespace/conflict review | **18 Phase 10 files reviewed; zero issues**; formatting/static checks also cover the shared changed paths |

One concurrent Vendor rerun encountered existing inventory timing failures and a catalogue mock race; the complete two-worker rerun above passed. The initial complete API run exposed an empty-schema rollback problem in the new migration, which was corrected and verified by the successful final full suite. The shared map-sheet extraction briefly changed existing shadows/spacing; those were corrected, reviewed and the affected goldens refreshed. No failing gate is described as passed.

Acceptance coverage includes Bulk changes/history retention, mixer versus bagged cargo, fixed-radius boundary and complete-first ranking, missing quantities and completion waiver, immutable originals, explicit corrections, 48-hour expiry, schedule independence, stale vehicle/rate sources, alternate endpoint without Project mutation, confirmed delivery retention, multiple inquiries and one award/replay, preference isolation/reset/100% validation, canonical CSV units, written over-budget override, and paid cancellation/retention/recovery/Buyer fee arithmetic without double counting. Existing API regression coverage includes committed two-session order concurrency and shared advisor/manual-review tests. These are fixture/provider-fake checks, not a live load or provider acceptance benchmark.

## Local activation and remaining gates

The actual development `api` migration status was checked: the new Phase 10 migration is **pending**; Phase 9 is applied. Applying this migration was rejected by automatic approval review because it mutates the development database outside current authorization. It was not applied, retried or bypassed.

After explicit approval, run the following from the repository root, using the existing Docker CLI:

```powershell
docker compose exec -T api php artisan migrate --path=database/migrations/2026_10_04_000000_complete_phase_ten_projects.php
docker compose exec -T api php artisan migrate:status
```

No new credential names are required for Phase 10. Reuse the already configured Maps/Places/Routes providers, current Tier 2/Bulk setup, reconciled ONLINE payment capability, private file scanner/storage, authenticated Reverb, queue/outbox processing and quotation expiry scheduler. Payment-channel fee initiation is Phase 11; pending fees are explicitly labelled.

ADB currently reports no connected device. A live Buyer-to-Vendor journey against development, actual Android CSV selection, real Google map/route behavior and provider/realtime delivery remain unverified. After migration, verify a single same-Project journey: save and lock, compile, inspect alternate endpoint, message two Vendors, compare revised terms, accept one, inspect expired competitor history and order snapshots, then check warning/override and recovery projections. Native map screenshots deliberately use a labelled synthetic surface. No live providers or secrets were captured.

Suggested conventional commit: `feat(projects): implement versioned project procurement and budgets`.

## Buyer Projects authentication correction — 1 October 2026

Opening Projects could end a valid Buyer session because the Project contract authoring script referenced undefined `bearerAuth` instead of the configured `passportBearer` scheme. The generated Dart client consequently omitted the Authorization header, and the API's legitimate 401 response triggered session expiry.

Corrected all 23 Project operations and their authoring source, then regenerated TypeScript and Dart clients. The Project contract check now requires `passportBearer` for every operation. A Buyer regression test retains the default authentication interceptors and rejects requests without the configured test token; it reproduced session expiry before regeneration and passes afterward. Server authentication and genuine session-expiry handling remain enforced. No migration or credential change was required; the actual development database was checked and the Phase 10 migration is already applied (batch 23), superseding the earlier pending-migration snapshot above.

Validation: Projects and authentication presentation tests **17 passed**; `flutter analyze` **no issues**; Project contract **23 operations passed**; OpenAPI validation **passed** with the same three unused-model recommendations; generated TypeScript build **passed**; redacted Gitleaks directory scans of the API contract and Buyer tests **zero findings**. Reviewed the corrected contract, generated authentication metadata and regression test; five edited source/report files have zero whitespace/conflict issues.

Android debug build **passed** using the existing development configuration and USB-forwarded local API. Installed the APK on the connected device with `adb install -r` (**Success**, existing app data preserved), and launched Buyer. The device still showed Android System UI, so a signed-in Projects tap could not be verified. Unlock the device, sign in if needed, and open Projects. Existing Gradle/AGP/Kotlin future-support warnings did not fail the build.

Suggested conventional commit: `fix(projects): send Buyer authentication on Project requests`.

## Buyer Projects audit and usability repair — 1 October 2026

The earlier Phase 10 test totals did not cover focused text fields during Project creation, dialog teardown, or the narrow-screen failure state. The Buyer authoring UI needed repair even though the core domain acceptance tests passed. This review used the approved Buyer/System workflows, the Phase 10 plan and UI planner, the existing Item-Based ranking screen, the contract/migration, and the actual development schema. It did not change Project state rules, scoring factors, financial calculations, ownership checks or provider adapters.

### Repairs

- Replaced the Project create/edit dialog with a dedicated `ProjectEditor` route. Controllers now belong to the route state and survive its exit transition. Date ordering is validated before submission; the save action prevents duplicate requests and retains form input on API failure. Existing saved-site selection is reused, and editing can retain the current sites without resubmitting a missing location ID.
- Added shared `showBuyerFormDialog`, which waits for `DialogRoute.completed` before callers dispose field controllers. Applied it to material entry, CSV import, optional selection notes and missing-material resolution. CSV callbacks check mounted state; import and resolution content scroll with the keyboard and large text. Material entry rejects invalid/over-precision quantities and malformed specification rows instead of silently doing nothing. Delivery drafts validate the existing required contact, instructions and alternative drop-off fields.
- Extracted the existing Item-Based ranking editor and largest-remainder balancing into the Flutter design system. Project preferences use the same sliders, 1% buttons, exact 100% total, save/reset controls, status band and version-conflict handling. Project factors remain Material Match, Budget Fit, Distance and VPS; the approved defaults remain 40/25/20/15. Item-Based endpoints, factors and persisted preferences remain separate. Saved Project preferences apply to subsequently compiled estimates, preserving existing estimate snapshots.
- Organized Project details into Overview, Work Packages and Sites with the existing shared tabs. Work Package authoring has Details and Materials sections and a persistent Save Draft action. Project cards show persisted status, schedule and budget values; the budget panel separates the three authoritative buckets. Archived Projects retain their read-only history. Android back returns through the Project hierarchy.
- Fixed the initial Projects error view overflowing at small widths, landscape and 2x text. Preserved genuine retry handling and existing automatic refresh. Removed hash/phase implementation wording from relevant user controls; PDF remains a disabled coming-soon action. Editable originals are correctly labelled as drafts; locked attachment copies remain labelled locked.

### Changed files and contract

Buyer feature files: `lib/features/projects/{projects_screen,project_editor,project_ranking_preferences_screen,projects_repository}.dart` and `lib/features/item_procurement/{ranking_preferences_screen,procurement_models}.dart`. Shared components: `lib/design_system/components/{form_dialog,ranking_preferences_editor,work_package_attachment}.dart` and `lib/design_system/ranking_weights.dart`. Tests: `test/projects_authoring_test.dart`, updated `test/projects_phase_ten_test.dart`, and reviewed/updated screenshots under `docs/design/evidence/phase-10/`.

No new migration, API response/request change or generated-client change was needed for this repair. The previous authentication-contract correction remains in place. The development Phase 10 migration was checked and is applied in batch 23. No new key names or manual setup are required. Server-side Buyer ownership, immutable originals, commercial history and financial authorization remain authoritative. No Git commands, deployment, credential changes or development database reset were performed.

### Current evidence

| Check | Result |
| --- | --- |
| Isolated `api-test php artisan test --filter=PhaseTen --compact --no-ansi` | **19 passed, 292 assertions**, 21.85 seconds |
| `flutter analyze` | **No issues** |
| Full Buyer `flutter test` | **221 passed, 1 existing opt-in capture skipped**, zero failures, 56 seconds; followed by the focused shared-attachment checks below after the final Draft label correction |
| Final `flutter test test/projects_authoring_test.dart test/projects_phase_ten_test.dart test/messaging_test.dart test/orders_test.dart` | **33 passed**, including golden comparisons without baseline updates |
| Final authoring rerun after ranking title polish: `flutter test test/projects_authoring_test.dart` | **12 passed**, including comparison with the reviewed goldens; latest APK installed and ranking title verified on the connected phone |
| Projects, Item-Based and profile/navigation regression run | **53 passed**, including the previously failing small-screen navigation cases |
| Authoring layout checks | **320 px at 2x text**, 390 px and 1024 px; CSV dialog also checked at 320×568 with 2x text and an open keyboard |
| Project API contract check | **23 operations passed** |
| Gitleaks redacted directory scans | Buyer source and tests: **zero findings** |
| Android debug build | **Passed** using existing development configuration and USB-forwarded API |
| Connected Android device | Updated app installed preserving data; Projects opened signed in; created a temporary Project with dates, an existing saved site and ₱1,000 budget; overview loaded successfully; canonical material search and adding a material succeeded; a Work Package draft saved and reopened successfully. No filtered Flutter assertion/controller-disposal errors appeared during these checks. |

The full suite initially exposed four small-screen navigation overflows in the new error view; those were corrected, and the complete rerun above passed. Provider-fake API assertions are not a fresh live provider acceptance journey. Live multi-Vendor inquiry/quotation/award, real route estimates, payment recovery and native CSV file selection were not re-exercised in this repair. Phase 14 analytics and Phase 15 PDF generation remain their existing later-phase limitations. The temporary planning records created for device verification had no procurement history; cleanup was separately authorized by the user after automatic review required explicit approval. Both temporary records were removed through the app, and the empty Project list was verified afterward.

Suggested conventional commit: `fix(buyer): stabilize Project authoring and unify ranking preferences`.
