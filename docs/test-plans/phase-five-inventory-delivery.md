# Phase 5 — Inventory, Pricing, Delivery and Auto-Accept Configuration: Test Plan and Record

Scope: Vendor inventory ledger, reorder level and the three public stock labels, append-only movements, stock confirmation (Day 7, Day 12, Day 15), quick ordinary-price versions, per-variant Item-Based auto-accept configuration, operational fleet management on the Store Setup vehicle records, the upgraded delivery advisory, the confirmed delivery snapshot, the shared MAT-02 eligible-offer predicate and bounded count invalidation.

Out of scope: order acceptance, reservation and allotment consumption at checkout (Phase 8 calls `InventoryLocks`, `AutoAcceptGate` and `AutoAcceptPolicyService::consume`), fulfillment staff assignment (Phase 12; Fulfillment Staff see an empty assigned-vehicle view until then), push reminders (Phase 15), Buyer surfaces and live route distances.

## Decisions approved by the project owner on 2026-09-28

| Rule | Decision |
| --- | --- |
| Limited Stock | Out of Stock when available ≤ 0; Limited Stock when 0 < available ≤ reorder level; In Stock otherwise or with no reorder level |
| Stale stock with several variants | The least-recently confirmed active variant drives Day 7, Day 12 and Day 15 |
| Confirmed delivery fee | Must equal the formula total for the confirmed vehicles, trips and endpoint distance; mismatch returns 409 `DELIVERY_FEE_CHANGED` |
| Auto-accept safeguards | Allotment above zero is required to enable; unit and amount caps are optional and independent |

## Acceptance checks and where they run

| Check | Test |
| --- | --- |
| Normal, mixer and bagged-cement cargo | `DeliveryRecommendationTest` (bagged cement, mixer volume/weight, mixed groups) |
| Missing measurements and unknown conversions → named manual review | `DeliveryRecommendationTest::test_missing_measurements…`; snapshot manual fallback in `PhaseFiveInventoryDeliveryTest` |
| Insufficient payload/count, multiple trips, unavailable vehicles, range | `DeliveryRecommendationTest::test_insufficient_payload_count…` |
| Alternate drop-off as endpoint and distance basis; site preserved | `DeliveryRecommendationTest::test_alternative_drop_off…`, snapshot test |
| Staff cannot change commercial vehicle configuration | `PhaseFiveInventoryDeliveryTest` fleet and snapshot tests |
| Immutable accepted rate, vehicle and address snapshots | `PhaseFiveInventoryDeliveryTest::test_confirmed_delivery_snapshot…` |
| Inventory never negative, never below hard reservations | ledger test (422 and DB check) |
| Buyers never receive exact stock | ledger test (public store profile, current offers) |
| Multiple variants count once (MAT-02) | ledger test `currentCounts` |
| Auto-accept never for Project-Based or NRPC orders | `InventoryRulesTest` gate cases; DB trigger in consumption test |
| Pause at zero, notification, deliberate confirmed resume | auto-accept feature tests; `InventoryPages.test.tsx` |
| Optimistic conflicts on manual edits | ledger test (409 with current row); `InventoryConcurrencyTest` (two real PostgreSQL sessions) |
| Deterministic acceptance locks | `test_acceptance_locks_every_affected_row_in_deterministic_order` |
| Day 7/12 reminders, Day 15 hide, restore on confirmation | `test_day_7_and_12_reminders…` |
| Bounded count invalidation through the outbox | `test_eligibility_changes_publish_one_bounded_outbox_event…` |
| Ledger layout at eight widths | `apps/vendor-web/e2e/phase-5-inventory.spec.ts` |

## Commands

```bash
docker exec materyalph_phase1_test-api-test-1 vendor/bin/pint --test
docker exec materyalph_phase1_test-api-test-1 vendor/bin/phpstan analyse --memory-limit=512M
docker exec materyalph_phase1_test-api-test-1 php artisan test
cd packages/api-contract && npm run validate && npm run test:inventory-contract -- <route-export.json>
cd apps/vendor-web && npm run lint && npm run typecheck && npm run test -- --run && npm run build && npx playwright test e2e/phase-5-inventory.spec.ts
```
