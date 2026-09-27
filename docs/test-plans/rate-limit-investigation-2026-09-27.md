# Rate-limit investigation — 2026-09-27

## Confirmed defects

- Vendor `VerificationForm.saveProgress` sent an unchanged form PATCH and a snapshot GET when switching steps or leaving the page. It now skips persistence when neither fields nor staged documents changed. Explicit submission still saves; dirty input and failed saves retain the existing navigation guard.
- Shared web transport bypassed endpoint cooldowns for CSRF bootstrap and token refresh. A refresh 429 could therefore be requested again by each later protected request. Both lifecycle calls now use the coordinated transport and honor Retry-After without automatic retries. Persistent CSRF rejection stops after one renewal.
- A delayed 401 from a request started before a successful refresh could trigger a second token rotation after the first refresh promise finished. A per-origin refresh generation now lets that request replay once using the current cookie, without another refresh. This is a coordination counter, not a token or permission cache.
- `auth-public` combined ten requests/minute by IP across authentication, public store browsing, CSRF bootstrap, Xendit webhooks, and authenticated Vendor address operations. Separate named buckets now isolate those traffic categories. Address operations share ten requests/minute by authenticated user; they still consume the overall sixty/minute account allowance. Authentication operations retain their shared ten/minute IP budget. Every numerical limit remains unchanged.

## Scope and security

Shared transport covers Admin and Vendor clients. Buyer public store requests use the isolated browsing bucket; the Buyer repository has one refresh on a session 401 and no recursive or 429 retry. Existing authenticated account requests already use user identity, not IP. Anonymous and refresh routes retain IP abuse protection. Login's account-aware failed-attempt rule, CSRF validation, HttpOnly cookies, token rotation/reuse detection, account authorization, and security/upload limits are preserved. No migrations, API payload/header changes, generated-client changes, credentials, or deployments.

No periodic API polling was found in the reviewed portal code. Countdown intervals update local UI only. Existing simultaneous GET sharing and mutation locks remain. These confirmed defects do not establish which endpoint produced the supplied screenshot; that requires the original network trace or the triggering page/action.

## Regression coverage

- Transport: simultaneous GET and CSRF coalescing, duplicate mutation rejection, refresh cooldown across different protected endpoints, CSRF bootstrap cooldown, one CSRF renewal, delayed 401 reuse, terminal 401, and cooldown expiry/manual retry.
- React: a StrictMode session effect produces one network request, and twenty local clicks do not refetch.
- Vendor: unchanged navigation avoids writes/redundant snapshot reads; changed input is saved; failures prevent leaving; subsequent edits use updated concurrency versions.
- Laravel `RateLimitIsolationTest`: independent traffic buckets, ten allowed auth requests then 429, Retry-After and window recovery, unchanged account budget, and independent authenticated address callers with an eleventh address request throttled.

Backend test execution requires the isolated PostgreSQL test environment. Run `pwsh -File scripts/run-tests-isolated.ps1` with Docker available; never run these tests against the development database. Live browser multi-tab navigation and Buyer device verification remain separate acceptance checks.

## Executed checks

- Vendor full suite: 176 passed, zero failed; additional StrictMode test: one passed. Admin full suite: 25 passed, zero failed.
- Both portals: lint, TypeScript checks, and production builds passed. Vendor retains the existing bundle-size warning.
- PHPStan: no errors across 174 production files. Targeted Pint and PHP syntax checks passed.
- OpenAPI validation passed with three existing unused-model recommendations. Account contract: 61 operations passed; Vendor/Admin onboarding contract: 35 operations passed. Payloads and generated clients are unchanged.
- Laravel focused rate-limit tests now pass inside `api-test`: **2 tests, 51 assertions**. The initial run exposed an incorrect test fixture: the User model uses integer internal IDs, so the two UUID fixtures were cast to the same integer. The fixture now supplies distinct integer IDs; production limiter identity logic is unchanged.
- The Docker blocker is resolved. Docker Desktop was installed under `%LOCALAPPDATA%/Programs/DockerDesktop` and running (engine 29.8.0), but was absent from PATH and initially inaccessible to the sandbox. Host-native PHPUnit could not resolve `postgres-test`, which is a Compose-network hostname. The isolated services have now been started and the positive/negative database isolation guards pass.
- `scripts/run-tests-isolated.ps1` now checks explicit user/system Docker Desktop locations, distinguishes an unreachable engine, and uses Compose health checks with a bounded startup timeout. README instructions run the gate through PowerShell 7 at the repository root, rather than invoking database-backed tests directly on Windows.
- Full isolated API gate completed with `./scripts/run-tests-isolated.ps1 -KeepRunning`: **246 tests passed, 2,787 assertions, zero failures** (PHPUnit duration 193.69 seconds). Fresh migrations, rollback/re-migration, schema documentation generation/check, Passport key checks, positive/negative isolation guards, Pint (277 files), and PHPStan (174 production files) all passed. Test services remain running for follow-up checks; the development services/database were not used by the tests.
- PowerShell syntax, changed-code whitespace, and a redacted Gitleaks scan of the runner, regression test, and README passed. No new manual credential setup is required.
- The original screenshot's failing endpoint was not captured. Subsequent live browser evidence is recorded below; Buyer device and multi-tab acceptance remain unverified.

## Live follow-up: repeated portal navigation

The earlier fixes missed request amplification from routed shell remounts. In the running Vendor portal, one Settings-to-Dashboard navigation requested account profile, onboarding, personal photo, and private store logo. All four successful responses consumed the same authenticated 60/minute account allowance. Settings section changes also fetched account profile again even when only displaying already-loaded form data. No duplicate click handler, idle polling, or refresh loop was observed in this trace; these were redundant lifecycle reads plus required page reads.

### Changes

- Added `packages/web-ui/src/portal-identity.tsx`, exported through `index.ts`, and mounted it around protected route groups in both portal `App.tsx` files. The routed account menu and shell reuse only display name, role label, organization name, and avatar URL across page remounts. Profile-update events refresh the identity; later navigation/focus renews it after four minutes for the five-minute signed avatar URL. There is no polling. Leaving the protected route group discards this state.
- Updated shared `portal-account-menu.tsx` and `portal-shell.tsx` to consume that display identity. The standalone menu fallback remains available. Callback identity changes no longer trigger profile fetches.
- Updated shared `account-workspace.tsx` to reuse its mounted profile when switching sections. Initial loading, explicit Refresh, and mutation reloads still fetch current profile data; section-specific reads still reach the API. A terminal 401 clears the mounted profile.
- Added Vendor `portal-identity.test.tsx` and Admin `AccountWorkspace.test.tsx` regression coverage. StrictMode plus twenty menu remounts produce one profile request; update events and a new portal mount each fetch again. Ten Profile/Account round trips reuse the profile; manual Refresh fetches again.

The shared identity never supplies authorization or permissions. Server authorization, route guards, token/CSRF behavior, and every rate-limit value remain unchanged by this follow-up. No migrations or API contract/generated-client changes are needed.

### Verification

- Live Chrome Vendor trace before the change: one Dashboard visit produced four account-budget requests. After the change, a subsequent Dashboard visit produced two: onboarding and the private store logo. Required protected data is still loaded.
- Twelve live Settings/Dashboard navigations completed in approximately 42 seconds without a 429. Thirty-five completed API responses were captured, all 200; the final logo request was still in flight when the trace was read. The limiter window reset during this run, so this is not proof that all those requests fit in one window.
- A live Account-to-Profile section round trip produced zero API responses/requests in the observed trace. An extended section-click run timed out and the browser connection subsequently became unavailable; that extended live run is not counted as passed.
- Latest Vendor full suite: **178 passed** across 22 files. Latest Admin full suite: **26 passed** across 9 files. Both portals passed lint, TypeScript checks, and production builds. The existing Vendor bundle-size warning remains.
- Backend code was unchanged in this follow-up. The earlier isolated **246 tests / 2,787 assertions** and focused limiter **2 tests / 51 assertions** remain the backend evidence, including actual abuse throttling and independent buckets; they were not rerun for these frontend-only changes.

These traces confirm and reduce normal-navigation request amplification. They do not identify the exact endpoint that returned the historical screenshot's 429 or establish unlimited navigation capacity: remaining authorized page reads still consume the unchanged account budget.
