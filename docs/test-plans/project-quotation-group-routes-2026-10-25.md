# Project quotation groups: collection crash and Vendor routes

Date: 25 October 2026

## Behavior

- Quotation options render generated `BuiltList<String>` issue collections directly. The related quotation-detail and budget-estimate paths use the same correction. Arrangement alternatives convert generated fulfillment enums to their canonical names before choosing a supported method.
- Selecting an option, including **Routes**, shows its Vendors on the map and requests one independent road route for each member through the existing authenticated Project route endpoint.
- All successful member paths remain visible. Selecting a Vendor pin, secondary path or accessible route row emphasizes that Vendor's path and keeps the group selected. Repeated selection within the group reuses the current results.
- Each Vendor has its own loading, driving distance, estimated driving time, Manila computation timestamp, unavailable state and Retry route action. One failure leaves other results usable. No travel time is guessed from proximity.
- Routes start at the saved Project site and end at the Vendor. These are procurement decision routes, not a delivery promise or live tracking. Alternate delivery endpoints and commercial delivery fees retain their existing behavior.
- Candidate, Work Package version and origin are checked before displaying a route. Late responses for an earlier group, cleared selection or replaced results are discarded. Incomplete paths, invalid computation timestamps and negative distance/time are rejected.
- **All options** clears the group paths and restores all option pins with a radius recenter. The map's bottom inset follows the draggable sheet. Selection brings the route list into view and reduces an expanded sheet to make room for the map; reduced motion uses immediate changes.
- The header presents Work Package, site and allocated budget without the previous large nested summary. Filters wrap rather than disappearing beyond the screen edge. The route heading stacks its actions when space or text size requires it.

## Files changed for this task

- `apps/buyer-mobile/lib/design_system/components/supplier_route_tile.dart`: shared accessible route row.
- `apps/buyer-mobile/lib/features/map_discovery/supplier_map.dart`: optional group paths, selected-path emphasis, bounds and Project-origin labeling.
- `apps/buyer-mobile/lib/features/projects/vendor_selection_screen.dart`: per-member route state, selection synchronization, stale-result rejection and compact layout.
- `apps/buyer-mobile/lib/features/projects/project_arrangement_screen.dart`: generated collection fixes, supported method names and explicit route action.
- `apps/buyer-mobile/lib/features/projects/vendor_selection_widgets.dart`: wrapping filters.
- `apps/buyer-mobile/lib/features/projects/vendor_quotation_screen.dart`: iterate typed supplier issues directly.
- `apps/buyer-mobile/lib/features/projects/work_package_estimate_widgets.dart`: iterate typed delivery issues directly.
- `apps/buyer-mobile/test/project_group_routes_test.dart`: six generated-contract, interaction, failure, stale-result and responsive regressions.

This checkout already contained extensive changes. Existing edits were preserved. No API/OpenAPI, generated client, migration, authorization, pricing, reservation, payment or procurement submission rule was changed. Route requests continue to use the server-authorized, Buyer-owned Work Package/candidate endpoint; no provider credential enters the client.

## Automated verification

The installed SDK was invoked directly because its batch launcher did not progress in the restricted shell. The following PowerShell variables describe the exact runtime used, from `apps/buyer-mobile`:

```powershell
$taskDart = 'C:\Users\RJ\Documents\flutter\bin\cache\dart-sdk\bin\dart.exe'
$taskFlutter = 'C:\Users\RJ\Documents\flutter\bin\cache\flutter_tools.snapshot'

& $taskDart format --output=none --set-exit-if-changed lib/design_system/components/supplier_route_tile.dart lib/features/map_discovery/supplier_map.dart lib/features/projects/project_arrangement_screen.dart lib/features/projects/vendor_selection_screen.dart lib/features/projects/vendor_selection_widgets.dart lib/features/projects/vendor_quotation_screen.dart lib/features/projects/work_package_estimate_widgets.dart test/project_group_routes_test.dart

& $taskDart $taskFlutter test --no-pub test/project_group_routes_test.dart test/vendor_selection_test.dart test/project_transport_test.dart test/map_discovery_test.dart test/supplier_map_performance_test.dart test/work_package_materials_test.dart test/work_package_compact_layout_test.dart

& $taskDart $taskFlutter analyze --no-pub lib/design_system/components/supplier_route_tile.dart lib/features/map_discovery/supplier_map.dart lib/features/projects/project_arrangement_screen.dart lib/features/projects/vendor_selection_screen.dart lib/features/projects/vendor_selection_widgets.dart lib/features/projects/vendor_quotation_screen.dart lib/features/projects/work_package_estimate_widgets.dart test/project_group_routes_test.dart
```

- Format: 8 files checked, 0 changes required; exit 0.
- Focused tests: 69 passed, 0 failed; exit 0. This includes six new group-route tests and the existing map, transport, quotation, material and compact-layout checks.
- Analysis: full `analyze --no-pub` completed with no issues; the final eight-file analysis also completed with no issues (50.0 seconds), exit 0.
- After the final guard against selection during result replacement, the six group-route tests were rerun: 6 passed, 0 failed; exit 0.
- `git diff --check -- <the changed Dart paths above>`: passed. Git emitted only its existing LF/CRLF conversion notices.
- `Get-Content -LiteralPath <the changed Dart paths above> | gitleaks stdin --redact --no-banner`: no leaks found; exit 0. This scans current file contents, including untracked files, without staging anything.

## Manual acceptance remaining

1. Restart the Buyer app, open a Work Package with a multi-Vendor option, and tap **Routes**. Confirm every member pin and successful road path is visible above the sheet.
2. Tap each Vendor pin, secondary path and route row. Confirm the emphasized path, Vendor selection, driving distance and estimated time agree. Inspect route bounds and overlapping pins on Android's native Google map.
3. Expand the sheet, choose a route, and confirm it returns to a useful map/list balance. Test **All options**, another quotation group, landscape and large accessibility text.
4. With the existing Maps SDK and server Routes configuration, confirm real provider results. Simulate an unavailable route and retry it while another member route remains usable.

No new key names or manual database setup are required by this patch. Physical-device/native-map rendering, live Google provider acceptance, an APK build/install and the full Flutter suite were not run. No deployment was performed.

Suggested commit: `fix(buyer): repair quotation groups and show per-vendor routes`
