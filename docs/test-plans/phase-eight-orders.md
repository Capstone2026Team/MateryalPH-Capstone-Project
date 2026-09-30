# Phase 8 — Orders, NRPC, FIN-02, Auto-Accept and Expiry

Verified on 2026-09-30. Surfaces: API, contract, Vendor web and Buyer Flutter. This continuation completed the existing implementation without replacing its domain services or migration. The initial gate run did not migrate the development database; the live Orders repair below subsequently applied the pending migrations. No deployment, commit or credentials change was performed.

## Live Orders repair — 2026-09-30

The running Vendor Orders page initially displayed “The request could not be completed.” The development API was still on the Phase 6 schema: Phase 7 and Phase 8 migrations were pending. The server reported PostgreSQL `42703`, missing `orders.closed_at`; the scheduled expiry command failed for the same reason. The isolated test passes above did not verify development-schema readiness.

The first normal `php artisan migrate --force` attempt rolled back Phase 7 because `carts_one_active_per_buyer` could not be created. One Buyer had 35 legacy active carts, all with zero items. Under a database transaction and table locks, the newest cart was retained and the other 34 empty carts were marked `ABANDONED`. The repair refused to proceed if any duplicate cart contained items. All records were preserved; no data reset, cart-item deletion or order-state mutation was performed.

The unchanged Phase 7 and Phase 8 migrations then applied successfully as batch 21 in the development API. `migrate:status` confirms both ran. `php artisan materyalph:orders-expire` completed successfully with zero expired orders. Retrying the existing signed-in browser page returned **HTTP 200** from `/api/v1/vendor/orders?group=NEW&page=1` and displayed **No new requests** with zero filter counts. This verifies the live list and expiry command, not a populated end-to-end order/payment journey. No broad foundation reseed was run as part of this repair.

## Outcome and affected files

- API: the existing `2026_10_02_000000_create_phase_eight_orders.php` extends the established order, snapshot, confirmation, NRPC, reservation, financial and delivery tables. Domain code is in `services/api/app/Domain/Orders/` and `Finance/`; it creates one parent checkout and one child order per Vendor, confirms/revises/declines, records Buyer decisions and NRPC objections separately, reserves atomically, auto-accepts eligible Self-Pickup orders and expires unpaid/unanswered orders. This continuation changed API tests only; no migration or domain behavior was rewritten.
- Contract: `packages/api-contract/openapi.yaml` remains `1.0.0-phase.8` with the existing 15 order/checkout paths, five independent state families, versioned money/NRPC/delivery schemas and generated TS/Dart clients. No contract change during this continuation; LF preserved. `test:orders-contract` is now included alongside the earlier route checks in `.github/workflows/ci.yml`.
- Vendor: the inherited `OrderPages.tsx`, `orders-api.ts`, Inventory lead-time field and shared `packages/web-ui/src/order-patterns.tsx` were verified through the full portal gate.
- Buyer: `lib/features/orders/`, `lib/design_system/components/order_components.dart`, checkout submission and Profile Orders navigation complete the order journey. Fixed the NRPC Material ancestor, consistent full Manila timestamps, and large-text money layout. `orders_test.dart` and `orders_fakes.dart` now exercise the intended failures and exact version decisions correctly.
- Regression repairs: welcome/login Google button labels now wrap; the welcome test matches the maintained title. `item_procurement_test.dart` now checks the real submission boundary and surviving invoice preview instead of the retired confirmation preview. Missing baseline files and Material icon fonts were restored in `ui_capture_test.dart`; checkout captures reflect the Phase 8 controls.
- Evidence: `test/phase8_capture_test.dart` adds 12 deterministic captures under `docs/design/evidence/phase-8/`. The System, Buyer and Vendor workflows now record the approved decisions and release defaults. Schema ERD/data dictionary are generated from the isolated schema.

## Final owner decisions and release defaults

Approved by the project owner on **2026-09-29**; these are not new interpretations:

| Decision | Behavior |
| --- | --- |
| Buyer revision/NRPC window | 24 hours from Vendor revision/proposal; expiry sets `EXPIRED` and releases the hard reservation |
| Online payment window | 45 minutes whenever the order enters `AWAITING_PAYMENT`, manually or automatically |
| Auto-accept pickup date | Optional Inventory lead time in days, editable by Owner/Store Manager only; unset means whole-order manual review with `FULFILLMENT_DATE_NOT_CONFIGURED` |

Preserved defaults: only Online at submission; COD/In-Store await Phase 11 but remain in FIN-02 matrix tests. Site Delivery never auto-accepts and needs Buyer approval of the confirmed drop-off, vehicles, trips and fee. Revisions may only reduce quantities or add an order-level Vendor discount. Rejecting revision/NRPC sets `CANCELLED` and releases stock. The processing fee remains pending until a payment channel is chosen in Phase 11.

## Acceptance checks and evidence

| Requirement | Automated evidence |
| --- | --- |
| Revision and NRPC expire exactly at 24 hours from Vendor action, not checkout | Four `test_buyer_window_is_24_hours_from_vendor_revision_and_releases_on_read_or_sweep` cases; delayed Vendor action, one second before deadline, exact boundary, release and repeated sweep |
| Manual and auto-accepted online orders get 45 minutes | Manual confirmation test's exact UTC timestamp and 44:59/45:00 boundary; auto-accept test's exact deadline assertion and release/allotment restoration |
| Missing lead time falls back, only Owner/Manager may edit | Existing whole-order fallback test; new six-role lead-time settings test, including denied writes retaining lock version |
| Site Delivery needs manual confirmation and Buyer approval | Delivery confirmation/snapshot test, alternate versus intended endpoint, Owner/Manager authority, private coordinates and frozen commercial evidence |
| Submission cannot offer cash or accept price overrides | New malicious COD/In-Store and unit-price-input test: only Online is persisted, submitted prices remain authoritative, negative discount rejected |
| Buyer rejection cancels and releases | Separate revision and NRPC rejection tests |
| NRPC is manual, part of materials and separately accepted/flagged | Required amount/reason/lines/Terms, exact version, integrity bound, flag independence and post-acceptance mutation denial |
| Money and immutable snapshots | FinancialCalculator tests for centavo half-up rounding, largest remainder, VAT inclusion, direct cash/mixed NRPC, allocation integrity; accepted snapshot and fee-estimation tests |
| Atomic reservations and current authority | Real two-session PostgreSQL races in `OrderConcurrencyTest`, plus all-or-none and restriction/media revalidation tests |
| Five state families, exact Manila deadlines, disabled undisclosed NRPC acceptance | Buyer interaction tests, 12 Phase 8 captures and Vendor tests |

Six API cases were added, increasing the suite from 368 to 374. Existing state writes still go through `OrderTransitionService`; inventory writes still use the established balance writer. Buyer/Vendor scope, delivery-confirmation authority, private coordinates, server-calculated money and retry-sensitive `Idempotency-Key` behavior remain intact. No payment success is inferred from confirmation or navigation.

## Gate results

| Gate | Result |
| --- | --- |
| API Pint | Passed, 431 files |
| API PHPStan | Passed, `--memory-limit=1G --no-progress` |
| Full isolated API suite | **374 passed, 6,073 assertions** |
| Route contracts | Account 61, Vendor/Admin 35, catalog 29, inventory 17, geography 18, procurement 13 operations passed; orders contract passed |
| OpenAPI validation | Passed; three existing unused-model recommendations: FinancialSnapshot, FeeAssessment, MaterialPriceObservation |
| Generated TS client | Build passed |
| Generated Dart client | `dart analyze lib`: no issues |
| Vendor web | Lint, typecheck, **212 tests**, production build passed |
| Shared web-ui consumers | Vendor and Admin typechecks passed |
| Buyer Flutter | `flutter analyze`: **No issues found**; full suite **182 passed, 1 skipped, 0 failed** |
| New Buyer visual evidence | **12 captures passed** and visually reviewed; money includes 320px with 2x text |
| CI wiring | YAML parses; orders route-contract step present; hosted CI was not run |
| Schema and infrastructure | ERD/data dictionary regenerated; `materyalph:schema-document --check` and isolated `docker compose config --quiet` passed |
| Secret scan | Gitleaks source-directory scans passed, redacted output; no Git commands used |

The single Flutter skip is the existing opt-in `CAPTURE_PHASE7` enhancement capture. The full run includes existing Phase 5–7 tests. The prior 12 welcome/onboarding/missing-golden failures and four obsolete checkout integration expectations now pass. Vendor build retains its non-blocking large-chunk and esbuild/oxc configuration warnings.

## Migration limitation and remaining boundaries

`OrderConcurrencyTest` needs committed fixtures visible to two PostgreSQL sessions, so it cannot use a wrapping test transaction. It uses `migrate:fresh` only in the guarded isolated test database before/after each race because an older onboarding migration's `down()` cannot unwind populated activation history. Earlier applied migrations were not edited. Passing empty-schema migration/rollback tests does not establish that populated historical rollback is safe. No development or production data was reset.

Phase 11 still owns COD/In-Store enablement, channel fee quoting, verified provider payment, reconciliation and collection. Later phases own fulfillment milestones, completion/earned commission and refund processing. The E-Invoice request remains an explicitly disabled design preview. No live-device, live-provider or shared live Buyer/Vendor order journey was performed; fixture captures and isolated tests are not that evidence.

No new key names or secrets are required. The initial gate run validated migrations only in the isolated stack; the live repair above subsequently applied them to development. Before a populated NRPC acceptance journey, verify required reference Terms/seed data separately. Runtime scheduling invokes the existing order expiry sweep every minute.

The requested memory update was saved as a small completion note under the Codex `memories/extensions/ad_hoc/notes/` folder, pointing future continuation work to this report. Existing memory files were not overwritten.

## Reproduction

From the repository root, with Docker Desktop available:

```powershell
docker exec materyalph_phase1_test-api-test-1 sh -c 'vendor/bin/pint --test && vendor/bin/phpstan analyse --memory-limit=1G --no-progress && php artisan test'
docker exec materyalph_phase1_test-api-test-1 php artisan route:list --json --path=api/v1 > packages/api-contract/routes.json
```

From `packages/api-contract`, run every `test:*-contract` script with `-- routes.json`, then `npm.cmd run validate`; remove the temporary route export afterwards. Build TS from `generated/typescript` with `npm.cmd run build`; analyze Dart from `generated/dart` with `dart analyze lib`.

From `apps/vendor-web`: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run`, `npm.cmd run build`. From `apps/admin-web`: `npm.cmd run typecheck`. From `apps/buyer-mobile`: `flutter analyze`, then `flutter test`.

Suggested conventional commit: `feat(orders): complete phase eight order journeys and acceptance gates`.
