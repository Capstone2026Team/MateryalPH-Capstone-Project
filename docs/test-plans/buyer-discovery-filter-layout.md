# Buyer discovery filter organization — 2026-10-25

The filter sheet groups controls by the supplier tier they affect:

1. Show Verified Vendors → Favorite Suppliers only → Supplier type → Material category.
2. Show Directory Suppliers → Minimum Google rating, with Google source/context copy.

> Superseded later the same day: Favorite Suppliers only is now its own first section and applies to both tiers. See [buyer-favorite-directory-suppliers.md](buyer-favorite-directory-suppliers.md).

The shared `SupplierFilterSection` component provides a bold tier toggle and consistent child indentation. A flat divider separates the two sections. The title and Reset/Apply footer stay visible while options scroll. Existing theme tokens, switch actions, dropdown options, minimum-rating values, attribution and disabled-rating explanations remain in place. Long dropdown text uses ellipsis without changing its semantic label or stored value.

## Changed files

- `apps/buyer-mobile/lib/design_system/components/discovery_controls.dart`: shared tier section presentation.
- `apps/buyer-mobile/lib/features/map_discovery/map_home_screen.dart`: grouped filter order, scrolling content, fixed actions and concise tier copy.
- `apps/buyer-mobile/test/directory_filters_test.dart`: group membership/order, Reset/Apply, accurate window metrics, pinned actions, large text and optional synthetic capture.
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`: filter grouping and scrolling/footer layout.

This is a UI change. There are no migrations, API contract/generated-client changes, authorization changes, new keys or manual setup. Favorite/type/category filters retain their Verified-only scope and Directory exclusion behavior. Google minimum ratings remain inclusive and Directory-only. Legacy Directory distance restrictions still clear on opening/applying this sheet.

## Verification

From `apps/buyer-mobile`:

```powershell
flutter test --no-pub --concurrency=1 --reporter expanded --dart-define=CAPTURE_DISCOVERY_FILTERS=true test/directory_filters_test.dart test/map_discovery_test.dart test/directory_rating_transport_test.dart test/supplier_browsing_test.dart
flutter analyze --no-pub
```

- Focused suite: **48 passed, 0 failed**, without hit-test warnings.
- Final filter-only rerun after correcting the test window metrics: **8 passed, 0 failed**. Layouts cover 320×568, 390×844 and 844×390 at 2× text, with reachable actions and no overflow.
- Flutter analysis: **No issues found**.
- Synthetic filter preview at `.tmp/supplier-browse-preview/filters.png` was visually reviewed using local application fonts. The capture uses the real shared bottom-sheet shell; its white background and window metrics are represented explicitly.
- Scoped secret and whitespace checks cover the changed source, tests and documentation.

The Windows checks used the installed Dart executable/Flutter tool snapshot and process-local D: temporary storage. Logs: `.tmp/buyer-filter-layout-tests.log`, `.tmp/buyer-filter-layout-final-tests.log`, `.tmp/buyer-filter-layout-analyze.log`.

The full Buyer suite and physical-device interaction were not repeated for this layout task. Hot reload the app and reopen Filters to verify the grouping, dropdown menus and sheet scrolling on the phone. Existing filter selections and API behavior remain authoritative.

Suggested commit: `fix(buyer): organize discovery filters by supplier tier`.
