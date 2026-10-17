# Vendor fulfillment message badges

The order's **Message** control shows unread received messages for its existing authorized fulfillment conversation. The **Fulfillment conversations** control inside an inquiry shows the total for that Buyer/store pair across all linked orders and pages, including unread read-only history. Sales messages and the viewer's own messages do not enter these counts. Reading messages removes them according to the existing per-user read receipts; retries do not multiply counts.

Both controls and the fulfillment list use the shared `CountBadge` component: zero is hidden, values above 99 show `99+`, and accessible descriptions retain the full count. The order control reads the existing conversation endpoint without marking anything read or refreshing order form data. Its count uses the session-scoped portal resource store and queued synchronization. The inquiry and list listen to the existing navigation invalidations, with automatic REST recovery on reconnect, foreground/online changes and the existing safety interval. Inquiry drafts and popup navigation remain intact.

## Source and contract

- `apps/vendor-web/src/lib/use-fulfillment-unread-count.ts`: the order badge's authorized REST read and resource synchronization.
- `apps/vendor-web/src/pages/OrderPages.tsx`, `ConversationThread.tsx` and `FulfillmentConversationDialog.tsx`: existing controls and list rows.
- `services/api/app/Domain/Messaging/ConversationService.php`: additive `fulfillment_unread_count` in conversation headers. The aggregate is zero unless the viewer has the existing Owner/Store Manager fulfillment-list capability and is limited to the authorized source inquiry's Buyer and Vendor organization.
- `packages/api-contract/openapi.yaml` and generated TS/Dart `ConversationView` models: optional nonnegative integer field; older clients remain compatible. No new endpoint, migration, dependency or setup key.

## Validation

Automated coverage checks second-page counts, Buyer/store isolation, restricted roles, duplicate sends, own/sales message exclusion, read-only history, repeat reads, realtime increases/decreases/clearing, `99+`, accessible full counts, popup list updates and preservation of open order data/inquiry drafts. Actual logged-in browser/device acceptance is separate from these automated checks.

Results (2026-10-12):

- Isolated API: `PhaseNineMessagingTest`, `PhaseTwelveFulfillmentTest` and `NavigationUpdatesTest`: **42 passed, 1270 assertions**.
- Final focused Vendor badge checks: **4 passed, 42 skipped**. The two related full component files previously ran **42 passed, 4 failed**; the four failures are the previously verified assertions expecting the superseded Order documents link.
- Vendor lint, type check and production build; generated TypeScript builds; OpenAPI validation and messaging/fulfillment route contracts; PHPStan and changed-file Pint: passed. Production build retains the existing chunk advisory.
- Dart client generation and serializer generation: passed. Generated-client `dart analyze` exits 2 with one `unused_element_parameter` warning in `geo_demand_cell_value.dart:40`, outside the changed ConversationView model.
- Scoped changed-source secret scan and whitespace/conflict review: passed. Actual logged-in browser/device journeys remain manual.

Manual acceptance:

1. Open an order in the Vendor full page and order drawer; send a Buyer fulfillment message. Message should update without opening the popup or refreshing.
2. Open the authorized Buyer inquiry; send messages on two of its orders, including one beyond the first fulfillment-list page. Fulfillment conversations should show the full total; each list row should show its own count.
3. Read one thread in the popup. Its Message/row badge should clear and the inquiry total should decrease. Repeat in a second Vendor session to verify cross-session read synchronization.
4. Disconnect/reconnect Reverb and return from a background tab. Verify recovery, zero hiding and no count from another Buyer/store/account.

Suggested commit, when authorized: `fix(vendor): show live fulfillment message badges`.

## Vendor sidebar and Buyer mobile extension — 2026-10-12

The Vendor **Messages** sidebar count now includes received unread fulfillment messages as well as sales messages. Owner/Store Manager counts cover their organization; sales staff retain their current assigned sales scope, and Fulfillment Staff retain their current order assignment scope. The sales inbox contents remain unchanged. Completed-order history can still contain unread messages.

Buyer My Orders **Fulfillment Messages** icons and the Order Details entry use the shared Flutter `CountBadge`. They count unread received Vendor messages for that order. Sending a message creates unread work for its recipients; it does not count as unread for its sender. Reading a thread clears its count using existing receipts. The detail icon reserves spacing for the badge, and tooltips/semantics preserve full counts above `99+`.

`NavigationRefreshBinding` shares the existing account subscription and recovery polling with mounted order read models. Successful navigation synchronization refreshes order data even when its main-inbox totals do not change. It preserves every loaded list page, coalesces concurrent events, ignores local cart publications, defers updates during order mutations, and rejects responses from prior accounts or foreground lifecycles. Background requests retain the visible page, scroll and form controllers; private data is cleared when the account scope ends.

Changed sources are `ConversationService`, `VendorNavigationUpdates`, `FulfillmentView` and `OrderQueries`; Buyer `navigation_counts_controller.dart`, the new `navigation_refresh_binding.dart`, order list/detail screens, the fulfillment entry, its view model and repository mapper; and the relevant tests/workflows. OpenAPI adds optional nonnegative `FulfillmentThreadRef.unread_count`, calculated only for a currently authorized conversation viewer, and clarifies the Vendor total. TS/Dart clients and Dart serializers were regenerated. No endpoint, migration, dependency or setup key was added.

Validation:

- Isolated API navigation/messaging/fulfillment suites: **44 passed, 1310 assertions**.
- Final focused Buyer badge and navigation synchronization checks: **14 passed**, including **7 new badge/lifecycle checks**. The earlier related Buyer suites: **28 passed, 4 failed**. All four failures also occur in an isolated pre-change source copy: the delivered receipt-to-review fixture, problem/cancellation validation-message assertions, and the superseded money-breakdown label. Source copies and logs are under ignored `.tmp/realtime-counts/fulfillment-sidebar-buyer/`.
- Flutter analysis: no issues. PHPStan and changed-file Pint; Vendor lint/typecheck/build; generated TypeScript builds; OpenAPI validation and fulfillment/messaging/notification contracts: passed. A temporary compiler disk-space limit and JVM allocation failure were resolved by cleaning only generated compiler caches in test artifacts and limiting the validator JVM resources; no source or credential files were deleted.
- Actual logged-in browser/device and cross-device acceptance remains manual.

For manual acceptance, send a Buyer fulfillment message while Vendor stays on another page: Messages should increase, and reading it should decrease the count across Vendor sessions. Send a Vendor reply while Buyer stays on My Orders or Order Details: the relevant Fulfillment Messages badge should increase and clear after reading. Verify a loaded second order page, background/resume, reconnect and account switching. Rebuild or hot restart Buyer once to load the changed native code.

Suggested commit, when authorized: `fix(notifications): include fulfillment messages in navigation badges`.

## Vendor Buyer inbox row badges — 2026-10-12

Each Buyer row in Messages now uses the shared `CountBadge` for its unread received messages. Inquiry rows combine their own sales count with the server-provided fulfillment aggregate when `canListFulfillmentConversations` allows it. Assigned Fulfillment Staff rows retain their own thread count; restricted sales roles do not display the organization aggregate. Reading an inquiry clears its sales count while linked fulfillment messages remain unread until their actual thread is read. The backend's existing per-user receipts, Buyer/store scope and authorization remain authoritative.

`packages/web-ui/src/messaging-patterns.tsx` and its CSS provide compact `99+` badges, accessible full counts, zero hiding and visibility at compact inbox widths. `apps/vendor-web/src/pages/MessagingPage.tsx` connects the inbox to existing account invalidations and REST recovery without remounting the inbox or clearing search, selection, scroll or conversation drafts. Concurrent requests remain serialized with a pending refresh; ending the session clears inbox data and prevents late responses from restoring it. No new backend behavior, API contract, migration, dependency or setup key is required.

Validation: `FulfillmentConversationDialog.test.tsx` **11 passed**, including four added checks for the correct Buyer, sales/fulfillment totals, live increases/decreases/clearing, search/draft preservation, restricted roles and late responses after session end. Vendor lint, typecheck and production build passed; explicit lint of the shared inbox component passed. The build retains its chunk-size advisory. Logged-in browser/device acceptance remains manual.

Manual acceptance: keep Vendor Messages open with two Buyers visible; send an inquiry message and a fulfillment message from different Buyers. Each corresponding row should gain its own badge without navigation or refresh. Read the inquiry, then its fulfillment thread: only the applicable count should decrease each time. Verify compact widths, an active search, reconnect/foreground recovery and account switching.

Suggested commit, when authorized: `fix(vendor): show live unread badges per buyer in inbox`.
