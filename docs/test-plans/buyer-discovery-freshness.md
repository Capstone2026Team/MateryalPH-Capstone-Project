# Buyer discovery freshness — 2026-10-24

Saved Map results previously suppressed server requests for ten minutes, and retained Map/Explore tabs did not refresh automatically. A radius could therefore show an older snapshot than another radius.

## Behavior

- A saved location/radius snapshot is a labelled preview. Opening or revisiting it always revalidates against `/api/v1`; no fresh-cache window suppresses the request.
- Map, Explore and catalog search revalidate on entry, return and app resume, and five seconds after each completed refresh while visible. This is automatic polling, not a guarantee of instantaneous push delivery. Request time is additional.
- Hidden tabs, covered routes and background apps pause refresh timers. Requests never overlap another refresh for the same controller. Failures back off to 10, 20, 40 and at most 60 seconds; returning or resuming resets the delay.
- Map refreshes replace the complete paginated set together, preserving current content while pending. New Tier 1 and eligible Tier 2 results are added and absent results removed. A removed selected supplier clears its preview and route. An unchanged selected route is not requested again on each poll.
- Catalog search refreshes retain query, filters, sort, scroll position and the number of loaded pages. Existing content stays visible during refresh; failed reads retain the existing failure/retry presentation. Unauthorized refreshes clear the relevant retained results.
- Registration alone does not grant discoverability. Existing server activation, listing, inventory, compliance, serviceability and restriction rules still decide Tier 2 visibility.
- Tier 1 remains informational Google directory data. The app receives new directory records on its next successful refresh once available from the API. Google indexing, search coverage, the server's provider cache and provider availability still govern newly listed Google businesses. Mobile polling does not bypass those caches or force paid Google searches every five seconds.

## Automated checks

Run from `apps/buyer-mobile`:

```powershell
flutter analyze --no-pub
flutter test --no-pub test/discovery_cache_test.dart test/discovery_freshness_test.dart test/explore_freshness_test.dart test/foreground_refresh_test.dart test/map_discovery_test.dart test/item_procurement_test.dart
```

The focused run passed **73 tests**. Coverage includes recent cached snapshots, both-tier additions, atomic multi-page replacement, lost eligibility, unauthorized cache removal, failed refreshes, old-radius response rejection, retained catalog pagination, refresh timing, hidden tabs, covered routes, background/resume and retry backoff.

Final verification: `flutter analyze --no-pub` reported **No issues found**. The complete `flutter test --no-pub --reporter expanded` run finished with **573 passed, 1 skipped, 0 failed**. Scoped Gitleaks scanned the 13 changed/new source, test and documentation files with **no leaks**; the tracked changed-file whitespace check passed. In this Windows session the commands used the installed Dart executable and Flutter tool snapshot directly because the batch launcher stalled and the SDK required its normal AppData cache access.

## Manual acceptance

1. Keep Buyer Map open. Make a Vendor satisfy all existing discoverability requirements within the selected radius. After a successful automatic refresh, verify its marker, synchronized list row and counts appear without changing radius or restarting.
2. Remove that Vendor's eligibility and verify it disappears; if selected, verify its preview and route clear.
3. Populate a new permitted directory record through the normal API/provider path. Verify it appears on the next successful refresh and retains Directory attribution and informational actions only.
4. Switch between previously visited radii and confirm each revalidates, then background/resume the app and confirm an immediate refresh. Review Google directory source times separately from the current marketplace response time.
5. Keep a selected supplier and a multi-page catalog search open through refreshes. Verify selection, route, filters, sort and scrolling remain usable. Disconnect the API, verify stale/retry states, then restore access and verify recovery.

No migration, API schema/client regeneration, new key or environment setting is required. Use a hot restart or rebuilt Buyer application to load the change. Physical-device, live-provider and deployed-release acceptance are separate from these automated checks.
