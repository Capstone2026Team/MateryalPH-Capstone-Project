# Phase 7 enhancement layout evidence

Eight 390 px captures cover Explore, search, catalog, details, finalization, cart, checkout preview and ranking preferences. All use synthetic test fixtures and placeholder media. They demonstrate layout, not live marketplace contents, stock, provider readiness or payment completion.

Generate with `flutter test --no-pub --update-goldens --dart-define=CAPTURE_PHASE7=true test/phase7_enhancement_capture_test.dart` from `apps/buyer-mobile`.

The existing nine Phase 7 goldens in `../phase-7/` were also refreshed and checked. Width coverage in `item_procurement_test.dart` includes 320 px at 2x text, 375, 390, 768, 1024, 1280, 1440, 1920 px, and landscape. The ordinary test suite skips this additional capture-only test unless explicitly enabled.
