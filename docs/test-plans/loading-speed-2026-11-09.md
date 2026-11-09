# Loading speed improvements — 9 November 2026

Admin and Vendor now download feature pages when opened. Buyer Map Home starts its authoritative search alongside the saved-results read, and Buyer Settings fetches its security summary and signed photo concurrently. Existing routes, permissions, financial rules, API requests and mutations retain their behavior.

Production builds were compared against copies of the working tree taken before this task, including the user's existing changes. These are JavaScript size measurements, not claims about live page-load times.

| Initial JavaScript, including static imports | Before | After | Reduction |
| --- | ---: | ---: | ---: |
| Admin, uncompressed | 1,823,320 bytes | 1,185,876 bytes | 35.0% |
| Admin, gzip estimate | 471,426 bytes | 331,897 bytes | 29.6% |
| Vendor, uncompressed | 2,414,120 bytes | 1,262,914 bytes | 47.7% |
| Vendor, gzip estimate | 606,425 bytes | 328,259 bytes | 45.9% |

Measurement walks each Vite manifest's entry and recursive static `imports`, counting each emitted JavaScript file once. Dynamic imports are excluded until selected. Gzip estimates compress each initial chunk separately; they do not establish server compression. Admin has 18 deferred page modules and Vendor has 11. Multiple pages exported by the same module share one download. Existing shared dependencies still load at startup, and both builds retain a >500 kB chunk warning.

Changed files:

- `apps/admin-web/src/App.tsx`: defer feature modules; retain the route-level loading boundary across navigation.
- `apps/admin-web/src/pages/AdminWorkspacePages.tsx`: move existing account-workspace and not-found composition out of startup, preserving the QR renderer and destinations.
- `apps/vendor-web/src/App.tsx`: defer signed-in feature modules.
- `packages/web-ui/src/lazy-portal-page.tsx` and `index.ts`: shared loading, page-download retry, and a persistent Suspense boundary. The initial lazy component is created once so a suspended first render does not repeatedly restart the download. Successful retries remain reusable on later visits. Transition tests retain current navigation and entered values while the next page loads.
- Both portal `vite.config.ts` files, `packages/shared-config/vite-api-client.mjs`, its `.d.mts` declarations, package file list and README: prebundle Vendor's linked generated client, and reuse Admin's generation-refresh behavior through one watcher. Debounce bulk writes, ignore unrelated paths, and detach/cancel on server close.
- `apps/buyer-mobile/lib/features/map_discovery/discovery_controller.dart`: overlap disk and network reads. Late previews cannot overwrite fresh results, a new scope, or denied access. An offline response still permits a matching late disk preview with its stale/error labels. Cache read failure does not block network results.
- `apps/buyer-mobile/lib/screens/buyer_profile_screen.dart`: load security status and the signed photo concurrently after validating the current Buyer profile.
- Vendor `src/lib/lazy-portal-page.test.tsx` and `vite-api-client.test.ts`; Buyer `test/discovery_cache_test.dart` and `buyer_settings_loading_test.dart`: navigation, download retry, generated-client refresh, cache race, offline fallback, authorization clearing and concurrent-settings regressions.

No migrations, OpenAPI changes, generated-client regeneration, dependency installation, credential setup or provider changes are required. The API and database were not changed. Frontend module loading and display previews do not grant access. Protected reads still use the existing authenticated clients; stale/denied results cannot authorize procurement, and no mutation is automatically replayed. A signed-photo 403 remains local to the photo.

Validation:

| Check | Exact result |
| --- | --- |
| Both portals: `npm.cmd run typecheck` and `npm.cmd run lint` | Passed |
| Both portals: `npm.cmd run build` | Passed; large-chunk warnings remain |
| Admin: `npm.cmd run test -- --run src/App.test.tsx vite.config.test.ts --maxWorkers=1 --testTimeout=30000` | 13 passed |
| Vendor: `npm.cmd run test -- --run src/App.test.tsx src/lib/lazy-portal-page.test.tsx src/lib/vite-api-client.test.ts vite.config.test.ts --maxWorkers=1 --testTimeout=30000` | 27 passed |
| Admin full suite: `npm.cmd run test -- --run --maxWorkers=2` | 399 passed, 5 failed: Vite and geography timeouts plus 3 UserDirectoryMedia assertions |
| Admin isolation: `npm.cmd run test -- --run vite.config.test.ts src/components/GeoAnalyticsPatterns.test.tsx src/pages/UserDirectoryMedia.test.tsx --maxWorkers=1 --testTimeout=30000` | 22 passed, 3 failed. Both timeouts passed; media assertions still expect an `Open Enforcement` link while the current profile uses a button. This task does not change those profiles/tests. The full suite is not green. |
| Vendor full suite: `npm.cmd run test -- --run --maxWorkers=2` | 929 passed, 1 failed: five-second Vite startup timeout. That test passed in isolation and in the final focused run with a 30-second timeout. |
| Buyer analysis | No issues found; final analysis ran in 120.9 seconds |
| Buyer focused tests | 64 passed |
| Production browser smoke, synthetic unauthenticated API | Admin and Vendor sign-in visible; zero page errors; no Finance/Orders/Messaging/Disputes/Trust feature downloads on login. Initial application JS requests: Admin 1, Vendor 3; excludes third-party scripts. |
| Route inventory comparison against pre-task copies | Admin 45 and Vendor 59 paths unchanged, including order |
| `cd packages/api-contract; npm.cmd run validate` | Passed with 8 recommendations |
| Redacted Gitleaks directory scans | No leaks in both portal sources, shared UI/config and Buyer source |
| `git diff --check` | Passed; Git emitted line-ending normalization warnings |

Buyer tooling needed access to the installed SDK's cache/analytics directory outside the workspace. Final equivalent commands below were executed through `C:/Users/RJ/Documents/flutter/bin/cache/dart-sdk/bin/dart.exe` and `C:/Users/RJ/Documents/flutter/bin/cache/flutter_tools.snapshot`:

```powershell
cd apps/buyer-mobile
flutter analyze --no-pub
flutter test --no-pub test/discovery_cache_test.dart test/discovery_freshness_test.dart test/map_discovery_test.dart test/buyer_profile_test.dart test/profile_photo_repository_test.dart test/buyer_settings_loading_test.dart
```

Local measurement builds, pre-task App copies and command logs are under ignored `.tmp/loading-speed/`. Run `node .tmp/loading-speed/measure.mjs` to compare the baseline manifests with the current normal production builds, and `node .tmp/loading-speed/browser-smoke.mjs` for the browser check. Normal portal production builds were also refreshed with `--manifest`. Browser smoke uses synthetic responses and does not prove signed-in production journeys, provider latency, server throughput or device startup time. Backend/database tests were not run because this slice changes no backend behavior. No deployment, push or commit was performed.

Manual acceptance: restart the Vendor development server to apply prebundling; visit permitted pages in each portal, return to previously opened pages, and verify real updates and authorization changes. On a Buyer device, check Map Home from a saved location online/offline and Settings with a slow connection. Production and Buyer release artifacts need the usual deployment/build process before these changes reach deployed installations.

Suggested commit: `perf: reduce portal startup bundles and buyer loading waterfalls`
