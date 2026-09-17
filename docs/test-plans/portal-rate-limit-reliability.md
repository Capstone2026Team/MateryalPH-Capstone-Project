# Portal request reliability — 2026-09-17

## Findings and changes

- Vendor shell and page independently loaded the same onboarding snapshot. Pages now pass their snapshot to the shell. Background refreshes retain mounted forms and show errors without replacing existing content.
- Settings fetched security data for every section. Security data is now requested only for Security.
- Shared web transport coalesces simultaneous matching GETs, with separate response bodies and no persistent account/permission cache. Concurrent mutations to the same method/endpoint are rejected locally, never merged or automatically replayed.
- Settings has an immediate action lock. Existing pending-button states remain, and Admin queue filter controls are disabled while loading.
- Uploads incorrectly inherited the five-per-15-minute security-action budget. With explicit user approval, documents and media now share 20 requests/minute per user and per organization. The overall 60/minute account cap and security-action limits are unchanged.
- Middleware 429 responses preserve Retry-After and rate-limit headers; CORS exposes these safe headers. OpenAPI documents them and both clients were regenerated.
- Timed 429 responses produce a dismissible countdown, exact Manila retry time, and endpoint-local cooldown. No automatic mutation retries or logout occurs. Security errors without Retry-After retain their original instructions, including exhausted OTP/MFA challenges.

## Verification

- Isolated Laravel suite: 109 tests, 1322 assertions passed.
- Vendor: 48 tests passed. Admin: 14 tests passed.
- Both portal typechecks, lint and builds passed; Vendor retains the existing >500 kB bundle warning.
- PHPStan passed. Formatting checked with Pint.
- OpenAPI validation passed with three existing unused-model recommendations; account contract 53 operations and Vendor contract 26 operations passed.
- Targeted redacted source secret scans and diff whitespace checks passed.

No migrations, credentials, account permissions, or business workflows changed. No deployment or commit. Browser-level multi-tab/load testing has not been performed for this change; automatic tests exercise request sharing, duplicate mutations, cooldown expiry, organization upload isolation, and recovery after the limit window.
