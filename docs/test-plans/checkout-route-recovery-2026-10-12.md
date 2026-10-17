# Checkout route recovery — 2026-10-12

## Outcome

The Buyer checkout's blocked Vendor panel now provides **Retry delivery route** when the API returns `ROUTE_UNAVAILABLE`. It reloads the existing authoritative checkout preview and disables repeated taps while loading. Submission is unavailable while the cart changes, the preview loads, or a preview request fails. The submit handler also checks that it still holds the current preview, including after split confirmation.

Delivery route, coverage, destination ownership, price, stock, payment eligibility and split-confirmation safeguards remain server-authoritative. An unavailable route remains blocked with no invented fee or distance. Missing measurements can proceed to Vendor manual review once the route is available. No backend domain rule, migration, OpenAPI schema, generated client or commercial data was changed.

Files changed: `apps/buyer-mobile/lib/features/item_procurement/checkout_preview_screen.dart`, `services/api/tests/Feature/Api/PhaseEightOrdersTest.php`, and this verification note.

## Runtime findings and remaining blocker

A redacted local read-only diagnostic found the screenshot store's active cart, an available store/destination record, an answered access question, valid coordinate ranges and no cart-line issue codes. The backend route provider is configured and its daily call budget is not exhausted. No cached route exists for the current store/destination pair.

A Google Routes check using fixed synthetic coordinates from the adapter tests returned HTTP 200 with an available route. It did not read or send Buyer or Vendor location data. This confirms provider connectivity for that test route, not the affected checkout route.

Automatic approval review rejected a live diagnostic using the checkout's stored store and delivery coordinates because it would disclose those coordinates to Google without specific user approval. Explicit approval was requested and remains pending. The cause of the screenshot's actual route failure and successful submission from the connected phone remain unverified.

## Verification

- Focused delivery checkout/confirmation tests: **2 passed, 75 assertions**. The new regression covers a failed route preserving the cart and lock version, no orders/reservations on failure, recovery into manual delivery review, successful submission and idempotent replay creating exactly one checkout.
- Related isolated provider, procurement and orders regression: **45 passed, 1 failed, 1,838 assertions**. The failure expects a missing `fee_assessments` row in `test_unchanged_manual_confirmation_reserves_freezes_the_snapshot_and_the_24_hour_window_expires_cleanly`. Running that test against the saved pre-edit file reproduced the failure (**1 failed, 18 assertions**); it predates this change.
- Buyer `flutter analyze --no-pub`: passed with no issues.
- PHP Pint for the changed order test: passed.
- Procurement and orders route-contract checks: passed.
- Development and isolated-test Compose configuration: passed.
- Changed-source Gitleaks scan: passed, no leaks found.
- Changed-file whitespace review: passed without Git commands.
- No UI/device tests, deployment, commit or development migration was performed.

## Manual acceptance

After reloading the Buyer application, open the existing checkout and choose **Retry delivery route**. Confirm the button shows its loading state and cannot be tapped repeatedly. If the route becomes available, the Vendor group becomes ready and Submit order request becomes available. A route that remains unavailable must retain the cart and explain the blocker; Self-Pickup remains available only when the Vendor offers it.

Suggested conventional commit: `fix(buyer): add delivery route recovery to checkout`.
