# Everyday API rate-limit removal — 2026-10-07

The user requested removal of everyday Buyer, Vendor and Admin request limits and explicitly retained authentication protections. This supersedes the everyday request budgets described in the September portal rate-limit investigation notes.

## Scope

- Removed the shared account limit and feature limits for public browsing, photos/uploads, maps/discovery, payment creation/status, onboarding, fulfillment and Admin business operations.
- Retained login failure, registration, OTP, MFA, password recovery, credential change, invitation, CSRF bootstrap and token-refresh limits. Provider webhook limits and platform-wide billable maps budgets remain.
- Preserved Passport, account/role/organization checks, CSRF, signed-file checks, scanner validation, idempotency and commercial state transitions.
- Updated route middleware, limiter registrations, workflow/architecture documentation, OpenAPI and contract-generation helpers; regenerated TypeScript and Dart clients. No migrations or frontend presentation changes.
- Client 429 handling remains necessary for authentication and external/provider responses.

## Regression coverage

`RateLimitIsolationTest` checks the absence of everyday throttles across all API routes, retained account authorization, removed limiter registrations, and separate authentication/credential budgets. `PhaseThreeVendorOnboardingTest` now checks uploads above the old upload budget across organization members and more than 60 consecutive reads without throttling.

The rate-limit contract check compares the live Laravel route export with OpenAPI, verifies retained credential throttles, and checks that everyday operations no longer advertise application-generated 429 responses.

## Validation

- Targeted Pint: passed.
- PHPStan: passed, no errors.
- OpenAPI validation: passed; three existing unused-model recommendations.
- TypeScript/Dart client generation: passed.
- All 15 contract scripts: passed; rate-limit check covers 342 everyday operations.
- Vendor and Admin TypeScript checks: passed.
- Buyer static analysis: direct Dart SDK `dart analyze` passed with no issues. The `flutter analyze --no-pub` launcher stalled and was cancelled; the direct analyzer completed after granting access to Dart's configuration directory.
- Redacted Gitleaks scans of changed API sources/tests, routes, API contract/generated clients and documentation: passed.
- Database-backed feature tests: blocked before assertions. Native PHPUnit reports that `postgres-test` cannot resolve. Docker CLI is absent from PATH and both standard installation locations. The isolated database guard remains enforced.
- No UI/browser test, deployment, commit or development database mutation.

Once Docker Desktop is available, run from the repository root:

```powershell
./scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning -SkipComposer
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --filter='RateLimitIsolationTest|PhaseThreeVendorOnboardingTest|PhaseTwoAccountSecurityTest|PhaseOneAuthAcceptanceTest|AuthTransportSecurityTest'
```

No keys or environment variables need changing. A deployment that caches Laravel routes must refresh its route cache through its normal deployment process.
