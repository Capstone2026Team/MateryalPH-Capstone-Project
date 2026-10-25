# Buyer supplier list browsing — 2026-10-24

## Result

The **Suppliers near you** sheet, full list and wide-screen list share one design-system toolbar. It contains store-name search, wrapping Verified/Directory/Favorites tabs and inline Distance/Rating sort controls. Verified opens first; the All section is removed. Search text and sorting remain selected across tab switches, supplier selection/close and automatic discovery refreshes.

Search is case-insensitive and matches words in the public store name within the selected tab, including both Tier 1 and Tier 2 stores through their respective tabs. Sorting offers nearest/farthest and high/low public scores. Directory uses Google rating; Verified and Favorites use published VPS. Unrated/New Vendor entries remain last in either score direction; ties use nearest distance then stable result ID. Source data and server ordering remain unchanged. The list operates on the discovery controller's paginated results and incorporates refreshed suppliers automatically.

The Directory distance control is removed. Opening/applying the filter sheet clears any legacy Directory distance restriction; the existing shared radius remains the geographic membership boundary. Minimum Google rating is retained. The API's optional legacy distance parameter remains compatible with other callers; this change does not alter the API contract or generated clients.

The header separates counts and freshness from search/navigation controls. Store rows retain real provider thumbnails/logos and neutral fallbacks, with consistent spacing, clear tier/source labels, separate Google rating lines and an entry affordance. Controls wrap at narrow widths and large text sizes.

## Changed areas

- `apps/buyer-mobile/lib/features/map_discovery/supplier_browsing.dart`: list views, sort options, public-name matching and deterministic presentation ordering.
- `apps/buyer-mobile/lib/design_system/components/discovery_controls.dart`: reusable search/tab/sort controls.
- `apps/buyer-mobile/lib/features/map_discovery/{map_home_screen,supplier_panels}.dart`: retained browsing state, search focus expansion, filter removal, list header/rows and empty-search recovery.
- `apps/buyer-mobile/test/{supplier_browsing,directory_filters,map_discovery}_test.dart`: browsing behavior, legacy filter removal, layout and affected map interactions.
- Buyer workflow, UI/UX planner and Phase 6 test plan: current owner-requested behavior.

No migration, new key or environment setting is required. Existing server authorization, discoverability, common radius, score publication gates, tier-specific actions, Google attribution and lazy-photo boundaries remain authoritative. There is no new provider request, endpoint or score formula.

## Verification

`flutter analyze --no-pub` reported **No issues found**. From `apps/buyer-mobile`:

```powershell
flutter test --no-pub --concurrency=1 --dart-define=CAPTURE_SUPPLIER_BROWSE=true test/supplier_browsing_test.dart test/directory_filters_test.dart test/map_discovery_test.dart test/discovery_cache_test.dart test/discovery_freshness_test.dart test/supplier_photo_test.dart
```

Result: **61 passed, 0 failed**, with no hit-test warnings. Coverage includes both-tier name search, tab/query retention, both score directions, unrated/New Vendor handling, deterministic ties, distance directions, unmodified source order, automatic result replacement, empty-search recovery, filter cleanup, automatic tab alignment with Directory-only filters, existing discovery/cache/route/photo behavior, and 320/390/844 px layouts at 2x text. The capture option is test-only; it writes a synthetic Directory list preview under `.tmp/supplier-browse-preview/`, which was visually reviewed with the application's local fonts. It does not prove live Google Maps or device behavior.

Final targeted analysis also reported **No issues found** after the filter-alignment regression was added. Scoped Gitleaks scanned the 11 changed/new source, test and documentation files with **no leaks**; the changed-file whitespace check passed. The complete Buyer suite was not repeated for this UI task.

The initial test attempt ran out of C: temporary compilation space. The successful run used the installed Dart executable/Flutter tool snapshot directly, with process-local `TEMP` and `TMP` set to `D:\MateryalPH-buyer-supplier-tests-20261024`. Existing disk caches and user files were preserved.

## Manual acceptance

1. Hot restart the Buyer app or rebuild its APK. Expand Suppliers near you and verify Verified opens first with no All section.
2. Search a real Verified store name, switch to Directory and search a real Google store name. Verify clearing a no-match query restores results and queries remain on tab switches.
3. Select each score and distance direction. Verify Google ratings stay distinct from VPS, and unscored stores remain last for both score directions. Keep the query/sort selected through automatic refresh.
4. Open Filters and verify Directory distance is absent. Apply a minimum Google rating and verify the shared radius still governs discovery.
5. Focus search on the draggable sheet and verify expansion, keyboard scrolling, store selection/close, Favorites, private route/session handling and Google attribution on a physical device.

Suggested commit: `feat(buyer): improve supplier list search and sorting`.

## Reload recovery — 2026-10-24

Moving `SupplierListView` from `supplier_panels.dart` to `supplier_browsing.dart` changes its Dart library identity. A debug app that hot reloads that change can retain an old enum instance in the Map's existing State, producing a same-name type mismatch. A full hot restart clears that retained state.

`MapHomeScreen.reassemble()` now resets the view/sort to the current canonical enum instances before the reloaded widget tree builds. `supplier_panels.dart` re-exports the canonical view enum so earlier imports remain source-compatible; there is still only one enum definition. Runtime discovery, authorization and the API contract are unchanged.

The targeted Map/browsing run passed **37 tests**, including widget-tree reassembly and subsequent list usability. Analysis reported **No issues found**. The attempted automatic debug attachment did not confirm a restart; use Hot Restart in the existing IDE/debug terminal (capital `R` for `flutter run`) for an already-running app displaying the old-library type error. Recovery does not require sign-out, app-data deletion or a new key.

Suggested fix commit: `fix(buyer): recover supplier view state after hot reload`.


## Compact controls and map performance — 2026-10-24

The owner reference is implemented in the shared toolbar: a rounded orange-outline store-name field with a trailing magnifier, plus Distance/Rating controls with an active underline and direction arrow. The active control toggles direction; switching modes starts nearest distance or highest rating. The toolbar, header and supplier rows use tighter spacing while preserving 44 px touch targets, wrapping, tier labels, real images and Google attribution. No enum was relocated.

The native map now renders only a 192 logical-pixel buffered viewport (plus the selection), while the full discovery set stays available to the list. Panning uses coalesced native viewport reads. Spatial indexes replace exhaustive clustering and label collision scans, preserving the existing greedy membership/order and label priority. Group metadata is cached, unchanged refreshes and unchanged viewport candidates skip marker reconstruction, and overlapping bitmap renders are coalesced with stale-result checks. The existing bitmap LRU, cluster thresholds, selection isolation, Project highlights, lazy photos and foreground freshness behavior remain in place.

Additional regression coverage is in `test/supplier_map_performance_test.dart`: old/new algorithm equivalence for 1,500 mixed-tier stores at seven zooms, both normal/large label scales, buffered viewport panning/selection, and marker-relevant refresh comparisons. The 5,000-store benchmark reports median host CPU time over five warmed runs; it does not measure Android frame rate or native map performance.

No migrations, API contract, generated clients, authorization rules, provider calls, keys or environment settings change. The complete Buyer suite and live-device performance remain separate acceptance gates.

Manual acceptance: hot restart the existing Buyer debug session, load a dense 40/50 km radius, pan and zoom through cluster/individual-pin levels, select and close a store, expand/drag the sheet, test Distance and Rating in both directions, and search real Tier 1/Tier 2 store names through an automatic refresh. Verify Project highlights, co-located pins, provider attribution and route fitting as well.

Suggested commit: `perf(buyer): streamline supplier maps and compact browsing controls`.


Final focused verification for this optimization: **73 passed, 0 failed** across `supplier_map_performance`, `supplier_browsing`, `map_discovery`, `supplier_marker_golden`, `directory_filters`, `discovery_cache`, `discovery_freshness`, `supplier_photo` and `foreground_refresh` tests. The synthetic Directory preview was reviewed again. Initial widget-test failures were caused by an unnecessary extra SemanticsHandle in the test harness; removing it restored clean cleanup and all interaction/layout assertions passed.

The final 5,000-store warmed host benchmark measured clustering **50.70 → 3.57 ms**, label placement **74.19 → 9.08 ms**, and **48/5,000** suppliers inside the example buffered street-level viewport. Timings are diagnostics, not flaky test thresholds or a device FPS claim. The benchmark compares the pre-optimization exhaustive algorithms with the spatial-index implementations on the same complete synthetic set; viewport reduction is reported separately. Log: `.tmp/buyer-map-compact-tests.log`. The complete eligible list is never truncated by this rendering optimization.


Production changes for this optimization are limited to `map_geometry.dart`, `supplier_map.dart`, shared `discovery_controls.dart` and `supplier_panels.dart`. The Buyer workflow and UI planner describe the compact controls and rendering policy. The final controls-only recheck passed **13 tests**, including the sort's screen-reader tap action and 44 px targets. Full Buyer analysis reported **No issues found** after the viewport lifecycle update; the final control changes are also analyzed separately. The nine-file scoped Gitleaks scan and whitespace checks passed.

Reproduce the focused suite from `apps/buyer-mobile`:

```powershell
flutter test --no-pub --concurrency=1 --reporter expanded --dart-define=CAPTURE_SUPPLIER_BROWSE=true test/supplier_map_performance_test.dart test/supplier_browsing_test.dart test/map_discovery_test.dart test/supplier_marker_golden_test.dart test/directory_filters_test.dart test/discovery_cache_test.dart test/discovery_freshness_test.dart test/supplier_photo_test.dart test/foreground_refresh_test.dart
flutter analyze --no-pub
```

As above, the Windows run used the installed Dart executable/Flutter snapshot and process-local D: temporary storage because C: has limited free space. No existing cache or user file was deleted.
