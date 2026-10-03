# Phase 8 Buyer visual evidence

Synthetic fixtures rendered by `apps/buyer-mobile/test/phase8_capture_test.dart`, using Inter, Material and Lucide fonts. These captures demonstrate layout and decision states, not live marketplace, payment-provider or delivery evidence.

Twelve deterministic captures cover the seven Phase 8 order states (awaiting Vendor, awaiting Buyer revision approval, awaiting NRPC acceptance, awaiting payment, declined, cancelled and expired), the order hub, full NRPC disclosure, submitted confirmation, and the money breakdown at 390px/1x and 320px/2x text. Later fulfillment states remain outside Phase 8.

Deadlines use a fixed UTC instant rendered in Asia/Manila with year and PHT. Five independent state rows retain text and icons. NRPC remains part of materials; the processing fee remains pending. At enlarged text, money rows stack their labels and values for readability. Long content scrolls rather than shrinking text.

The captures were visually reviewed. Checkout baselines in `../phase-7/` were updated for the real submission controls and retirement of the order-placement preview. Missing authentication/account baselines in `../buyer-account-refinement/` and `../ui-refinement/` were generated; their Material icon font is explicitly loaded.

Reproduce from `apps/buyer-mobile`:

```powershell
flutter test test/phase8_capture_test.dart
```

Use `--update-goldens` only for an intentional, visually reviewed layout change. Fixture screenshots contain synthetic identities only.
