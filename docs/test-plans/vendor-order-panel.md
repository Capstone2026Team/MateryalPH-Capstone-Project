# Vendor order panel — 2026-10-06

The user requested a five-step order tracker and a Message button for Buyer clarification. Vendor messaging entry is scoped to an existing owned order, not arbitrary Buyers.

`POST /api/v1/vendor/orders/{orderId}/conversation` requires the Vendor cookie, CSRF and Idempotency-Key. It reuses the originating quotation conversation or permanent Item-Based store chat. If absent, the latter is created transactionally with the current sales-role caller as handler, audit history and the existing outbox event. Existing handler access stays unchanged. Fulfillment Staff open only an existing assigned fulfillment thread. Opening sends no message; existing messaging moderation, privacy and authorization still apply. No migration is needed. OpenAPI and generated TS/Dart clients were updated.

The tracker represents order progress only; other state families remain separate. Pickup uses pickup labels. Delivered/Picked Up awaits confirmation until Completed. Interrupted states do not imply completion. Small screens scroll the tracker horizontally.

Validation: Vendor lint, typecheck and build passed; Admin typecheck passed. Orders has 24 passing tests. The full Vendor run reported 268 passed and two Fleet failures; a single-worker rerun of Orders plus Fleet passed all 35 tests. The full run is therefore not reported as clean. Three mocked browser cases passed at 320/390/1440px. Focused PHPStan, Pint, Orders and Messaging contract checks, TS client build and generated Dart messaging API analysis passed. The build retains its large-chunk warning.

Database verification is blocked: Docker is unavailable at the known install paths, and native PHP cannot resolve `postgres-test`. Two focused API tests stopped before assertions. Live message delivery is unverified. Run the isolated regression when Docker is available:

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test up -d --wait
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi --filter=PhaseNineMessagingTest
```
