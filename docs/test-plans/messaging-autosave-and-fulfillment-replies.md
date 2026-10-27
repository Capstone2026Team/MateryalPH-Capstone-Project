# Quotation autosave and fulfillment replies

Affected surfaces: Vendor Messages, Buyer conversation and quotation details, and the existing quotation draft API. No migration or new configuration is needed.

## Behavior

- Vendor quotation cards use the outgoing side of the Vendor thread. Received quotations remain on the left in the Buyer app.
- An optional plain-text message is part of the immutable published quotation content. It is visible on the compact card and in full quotation details in both clients.
- Draft edits save after 800 ms of inactivity. Writes are serialized with the quotation lock version; edits made during a save are retained and saved next.
- Close flushes pending changes. Publish flushes pending changes, publishes once with its existing idempotency key, and closes on success. Save or publish failures preserve the editor and allow retry.
- Empty materials and an unset fulfillment date can be saved in a private draft. Publication still applies the existing full commercial, date, delivery, tax, role and inventory checks. Customer Service remains draft-only.
- Handler transfer uses the shared accessible modal and preserves the conversation composer. Existing role checks, reason, lock version and history remain authoritative.
- Buyer send failures show the safely mapped server error, retain the pending reply and reuse its client message ID on retry.
- Order Details opened from an accepted quotation now retains the fulfillment-chat opener. Checkout passes the same opener through its confirmation to both child Order Details and View my orders; these routes no longer disable the fulfillment entry by dropping the callback.

## Automated coverage

`QuotationDraftEditor.test.tsx` covers autosave, publication, edits during a save, save failure/retry and Customer Service. The existing fulfillment dialog tests cover transfer modal submission and composer retention. Shared presentation tests cover attached quotation messages.

Buyer messaging tests cover an open fulfillment thread reply, received quotation placement, and existing send/retry behavior. `PhaseNineMessagingTest` also covers Buyer reply idempotency and Vendor visibility, plus incomplete draft save/publication validation and immutable published messages.

## Manual acceptance

1. In Vendor Messages, prepare a quotation, add a message and materials, and observe saved status. Close and reopen it. Confirm the saved inputs remain.
2. Type during a delayed save and then publish. Confirm the latest edit is published, the modal closes, and exactly one new quotation version appears.
3. On the Buyer device, confirm the quotation is on the left and the message appears both on its card and in its details.
4. Test offline save/publish and recovery. Confirm errors remain visible, the inputs survive, and retry does not publish twice.
5. Open Order Details from an accepted quotation, then Fulfillment Messages. Confirm the Buyer reply box and Send button appear, and reply to the Vendor. Repeat from checkout confirmation, both through a child order and View my orders. Reply as the Owner or currently assigned Fulfillment Staff and verify both sides see each message once.
6. Confirm closed-order fulfillment history remains readable and its composer stays unavailable. Unauthorized Buyers, other stores and former assignees must retain no access.
7. Transfer a sales handler through the modal. Verify cancellation preserves the composer and successful transfer retains earlier attribution.

The initial direct-thread test did not reproduce the missing composer. After the Buyer clarified that the reply controls were missing, the quotation-to-order regression reproduced a disabled fulfillment entry: `OrderDetailsScreen.openConversation` was null. The callback was also missing through checkout confirmation. Restoring those callbacks makes the accepted-quotation test open the fulfillment thread and send to its conversation ID. Database feature execution still requires the isolated `postgres-test` service, and physical-device/API acceptance remains manual.

## Verification on 27 October 2026

- Vendor: lint and typecheck passed; production build passed with its large-chunk warning. Full suite: 651 tests passed. After the final transfer/presentation additions, the affected three files passed 50 tests.
- Admin: lint, typecheck and build passed; 193 tests passed. The build reported its large-chunk warning.
- Buyer: `flutter analyze --no-pub` reported no issues; 45 focused messaging tests passed. Dart formatting and full generated-client builder generation completed.
- Follow-up for missing Buyer controls: the accepted-quotation navigation test failed before the fix because the fulfillment entry had a null callback. It passed after restoring the callback and sent the reply to `fulfillment-one`. The messaging, orders, fulfillment and Item-Based procurement suites then passed 91 tests. Checkout confirmation coverage verifies both child Order Details and View my orders retain messaging.
- Final follow-up analysis reported no issues. Formatting checked six changed Buyer files with zero changes; whitespace and secret checks passed.
- API: Pint passed; PHPStan reported no errors; quotation discount unit tests passed (6 tests, 13 assertions).
- OpenAPI validation and the 40-operation messaging contract check passed. Validation reported eight unused-model recommendations.
- Dart quotation payment, details and discount codec checks passed.
- Whitespace checks passed. Gitleaks found no leaks in the working diff or the new Vendor test. The staged scan had no staged bytes.
- API feature execution stopped before any assertions: `postgres-test` could not resolve. The Docker CLI is unavailable in this shell. Once the isolated services are available, run `cd services/api; php artisan test --filter=PhaseNineMessagingTest` and, from the repository root, `docker compose config --quiet`.
