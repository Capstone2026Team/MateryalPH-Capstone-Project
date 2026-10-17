# Navigation responsiveness — 2026-10-07

## Changes

- Vendor routes reuse a recent onboarding display snapshot while revalidating. Page work can begin without waiting for the repeated onboarding request to finish. Concurrent consumers share one load; a saved snapshot supersedes older pending replies.
- Admin Dashboard and Vendor Verification queue reuse recent display snapshots. Queue keys include all applied filters and the page. Background dashboard refresh keeps existing content visible.
- Shared dashboard sections retain visited component state through React Activity, which stops hidden effects and restarts them when shown. Unvisited sections remain unmounted. Onboarding forms retain their existing before-leave/save behavior.
- Buyer Explore, Messages and Profile mount once after first visit. Messages stops hidden-tab polling/subscriptions, resumes with an authorized read, and rejects late subscription setup from an older activation. Profile revalidates when shown. Orders keeps the current list during same-filter refresh and clears it when changing filters or losing access.
- Routine API session activity writes are coalesced to once per minute using a conditional update. Authentication, expiry, session revocation, MFA, role and organization checks still run on every request. No credential or authorization cache was introduced.
- OpenAPI describes the session activity timestamp precision; TypeScript/Dart clients were regenerated. No migration, credentials, deployment or development-data change is required.

## State and privacy boundaries

The shared web store belongs to the mounted signed-in portal, has a 20-entry target bound, and uses a 30-second navigation reuse window. Display snapshots are memory-only. Fresh requests run on mount; active background refreshes can retain displayed data. Session transport reset or an access-denied response clears private snapshots and invalidates pending replies. Snapshot state never authorizes an operation; existing server policies and optimistic concurrency versions remain authoritative.

## Evidence and limitations

- Local unauthenticated health samples: 235, 151, 152 and 54 ms. Public store samples: 157, 95 and 61 ms. These are observations before the changes, not authenticated navigation benchmarks.
- Source inspection identified the Vendor onboarding/page request waterfall, repeated Buyer tab mounts, and a session-row UPDATE on every protected request.
- Focused Vendor snapshot/transport tests: 19 passed. Admin transport tests: 3 passed.
- Vendor/Admin lint and TypeScript checks: passed.
- Vendor/Admin production builds: passed; existing >500 kB chunk warnings remain.
- Buyer Dart formatting and static analysis: passed, no issues found.
- PHP Pint and PHPStan: passed.
- OpenAPI validation: passed with three existing unused-model recommendations. Account contract: 61 protected operations passed. Client generation: passed.
- Redacted Gitleaks scans of shared UI, both portal sources, Buyer sources and changed backend sources/tests: no leaks.
- Backend regression test could not start: `postgres-test` does not resolve and the isolated database guard stops before assertions. Native development DB probing also cannot resolve `postgres`; it is not a substitute for the running HTTP server's environment.
- UI/browser/device tests were not run. First visits, uncached data, provider calls and server work still require network time. Existing large production JavaScript bundle warnings remain; no blanket instant-response claim is made.

When Docker is available, run the backend security regression from the repository root:

```powershell
./scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning -SkipComposer
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --filter=PhaseTwoAccountSecurityTest
```

Manual acceptance: sign in separately to each portal; switch between Dashboard, the verification queue, Orders and other permitted sections; verify quick return navigation and fresh server updates. In Buyer, visit Explore, Messages and Profile, then return to each; verify retained position and fresh data, no hidden Messages polling, and immediate removal of retained content after session expiry or denied access. Verify mutations, changed permissions and different accounts cannot reuse an old authorized state.
