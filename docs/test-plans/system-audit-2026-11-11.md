# System audit — 11 November 2026

## Scope and readiness

Audited the current local checkout across the Laravel API, Flutter Buyer app, React Vendor/Admin portals, shared web transport, and OpenAPI route checks. Existing uncommitted product, inventory, fulfillment, map, workflow, and generated-client changes were present before this audit; they were included in verification and were not reverted.

**Verdict: not ready for final release sign-off.** Verified Buyer and shared Vendor/Admin defects were repaired, and the checks below have passing evidence except for one intermittent full-suite API failure whose cause is still unresolved. Device and configured-provider acceptance also remains outstanding. Passing automation does not establish that the system has no bugs or that the deployed environment is accepted. No commit, push, merge, deployment, production-data change, credential rotation, or live payment was performed.

## Confirmed findings and repairs

| Finding | Repair and evidence |
| --- | --- |
| A delayed CSRF response could resolve a waiting action after logout and overwrite a replacement session's cached token. An old request's cleanup could also remove the replacement bootstrap from coordination. | Shared web transport rejects tokens acquired for a cleared session and removes a pending bootstrap only if that exact request still owns the entry. Two deferred-response regressions failed before the repair and pass afterward. |
| Refresh could send after logout while awaiting a cached CSRF token. A late refresh response could also update the replacement session's refresh version. | Check the session generation before sending refresh and before recording its result. Preserve the existing generation check before retrying after CSRF renewal. Regressions cover both portal paths and replacement-session recovery. |
| Account route checking rejected existing Buyer/Vendor tutorial routes as undocumented. | Expand their documented tutorial portal parameter, including inherited path parameters, and resolve shared error response definitions. Continue checking every route's authentication, audience, transport, CSRF and envelope. Negative fixtures still reject missing Buyer authentication, missing Vendor CSRF, and an undocumented Admin account route. |
| The Admin local-server integration test timed out at five seconds despite eventually satisfying all assertions. | Give only the two matching Vendor/Admin Vite server tests a bounded 30-second startup allowance. A diagnostic unchanged test passed in 12.94 seconds. No assertion, application timeout, business deadline, or global test timeout was removed. |
| Six desktop/phone date-filter browser scenarios were blocked by the first-visit Vendor tour. Their generic fixture supplied empty tutorial progress. | Use the existing completed-tutorial fixture for these returning-user date scenarios. Dedicated first-visit and replay tutorial scenarios remain enabled. No product walkthrough behavior was changed. |
| Malformed Buyer error envelopes with non-string code/message fields threw a raw type error before the 401 session-expiry or safe server-error path ran. | Type-check those fields before using them. Reproduced both 401 and 500 cases before repair; both now produce a safe failure, with session expiry still executed for 401. |

## Audit files and boundaries

- `packages/web-ui/src/web-api-session.ts`: shared session lifecycle repair used by Vendor and Admin.
- `apps/vendor-web/src/lib/web-api-session-lifecycle.test.ts`: seven lifecycle regressions.
- `packages/api-contract/scripts/check-account-contract.mjs`: route checker repair.
- `apps/{vendor-web,admin-web}/vite.config.test.ts`: scoped integration-test startup allowance.
- `apps/vendor-web/e2e/portal-standardization.spec.ts`: returning-user tutorial fixture.
- `apps/buyer-mobile/lib/core/api_guard.dart` and `test/api_guard_test.dart`: safe malformed-error handling and two regressions.
- This report.

No audit migration or request/response contract change. No generated client was hand-edited. Existing server authorization, HttpOnly-cookie transport, CSRF checks, idempotency rules, immutable financial/commercial history, financial calculations, and stored deadlines remain authoritative. No new environment keys or manual configuration are required for these repairs.

## Verification

Raw local evidence is ignored under `.tmp/system-audit-2026-11-11/`.

| Check | Exact result |
| --- | --- |
| API Pint | Passed, 923 files. |
| API PHPStan | Passed, no errors; 1 GiB memory limit. |
| API full suite | 936 passed, one warning, one failed; 19,734 assertions, 1,883.50 seconds. The failure is `PhaseFourteenAnalyticsTest::test_capture_retry_midnight_failure_immutability_and_reviewed_correction`, line 377: one observation captured instead of two. The unchanged isolated case then passed: one test, 30 assertions. The full analytics class then passed: 13 tests, 468 assertions. The subsequent ordered catalog/analytics check passed: 43 tests, 1,195 assertions. The original aggregate run remains non-green; the intermittent cause is unresolved. |
| Vendor lint, typecheck, build | Passed after the shared transport repair. |
| Vendor full tests | 105 files, 1,017 tests passed. |
| Admin lint, typecheck, build | Passed after the shared transport repair. |
| Admin full tests | 53 files, 398 tests passed. |
| Shared authentication/recovery checks | 59 tests passed across four files; final expanded lifecycle file separately passed all seven tests. |
| Buyer analysis | Final analysis after the error-mapper repair: no issues found. |
| Buyer full tests | 744 passed, one skipped, no failures before the final error-mapper repair. The skip is the opt-in `CAPTURE_PHASE7` screenshot capture. After the repair, 48 focused guard, session, account, error-notice, order-contract and payment tests passed; the full suite was not repeated for the two type checks. |
| Desktop/phone browser suite | Initial run: 322 passed, six date-scenario fixture failures. After repair, all 12 Vendor/Admin date scenarios passed at both widths. All 328 scenarios have passing evidence across the broad run and focused rerun; no second aggregate run was performed. Chromium at 1440px and 390px. |
| OpenAPI validation | Passed; eight unused-model recommendations. |
| Generated TypeScript build | Passed. |
| Node route contract checkers | Final aggregate run: 35/35 passed, covering authentication, role/transport guards, CSRF, idempotency and schemas. Account checker covers 78 protected account operations. |
| Account checker negative fixtures | 3/3 rejected as required. |
| Development and isolated-test Compose configuration | Passed without restarting services. |
| Gitleaks changed-source scan | Passed, no leaks in approximately 3.97 MB of current tracked diffs and untracked source/docs. Staged scan also passed but scanned zero bytes because nothing was staged. A final refresh includes the Buyer repair. |
| Whitespace | Passed. |

The API runs only in the guarded `materyalph_phase1_test` database; development data was not reset. Browser journeys use synthetic API fixtures, and provider adapter tests use fakes. These results are local evidence, not a fresh hosted GitHub Actions result.

The audit produced 76 additional screenshot artifacts. They were retained under the ignored audit directory, with initially clean tracked images restored and new evidence images removed from the source tree. Artifact paths already changed before the audit were excluded from this cleanup.

Known non-failing tool warnings include production bundle-size notices, the existing Vitest esbuild/oxc configuration notice, and jsdom's unsupported real-navigation diagnostic. Laravel's full-suite reporter also recorded a warning on `TabularDocumentRendererTest`; a detailed direct PHPUnit rerun passed its one test and six assertions without reported issues. Dependency-update availability alone is not a verified defect and was not used to change the fixed stack.

## Unresolved automated gate

The analytics observation-count mismatch was observed once in the broad run. Neither the unchanged focused case nor the complete class reproduced it. The preceding catalog class was included in a further ordered check. No production analytics rule, eligibility predicate, assertion, or expected count was changed to hide the failure. A clean aggregate API run and a cause-backed resolution of the intermittent excluded-offer condition remain required before declaring the API gate green. Diagnostics and JUnit evidence are retained in `api-tests.log`, `api-junit.xml`, `api-analytics-before.log`, `api-analytics-class.log` and `api-analytics-ordered.log` in the ignored audit directory.

## Remaining acceptance

Before accepting the deployed capstone, run one persisted cross-role journey with actual test accounts: Buyer procurement, Vendor confirmation/revision, Buyer acceptance and TEST payment or recorded physical-payment path, fulfillment, invoice/correction, review/dispute, and Admin authorized audit. Confirm retries preserve one commercial result and that permanent sales chat remains separate from fulfillment history.

On the Buyer device, verify Google Maps/Places/routing, location permission denial and list fallback, offline recovery, session refresh, realtime messages, and push notifications. On the configured deployment, verify private uploads and malware rejection across all three roles, queue/scheduler health, provider callbacks and replay handling, email delivery, and authorized private downloads. TEST success does not authorize LIVE commerce or demonstrate real money movement or BIR filing.

Suggested conventional commit after review: `fix: harden buyer and portal error recovery`.
