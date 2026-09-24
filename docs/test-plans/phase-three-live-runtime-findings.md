# Phase 3 live runtime findings — 2026-09-17

## Browser-confirmed failures

The connected Chrome Vendor tab at `http://localhost:5173/entry` was inspected. Clicking Retry issued `GET /api/v1/vendors/onboarding` and returned HTTP 500. This was not a failed login or a frontend redirect failure.

The connected Admin tab at `http://localhost:5174/` was also inspected. The existing form submission first recovered from HTTP 419 by obtaining a new CSRF token, then received HTTP 401 with `INVALID_CREDENTIALS` and the safe message `The email or password is incorrect.` The frontend wrongly replaced that message with session-expiry wording. Passwords, cookie values and invitation tokens were not read or exposed.

## Development database mismatch

The development database has six Vendor organizations. Its migration history includes deleted Phase 3 migrations dated September 13–15, while all five current September 16 Phase 3 migrations are pending. For example:

- `vendor_organizations.business_type` already exists, but current Phase 3 columns are missing.
- `vendor_onboarding_steps` uses legacy `step_code` and `requirement_level`, instead of the current `requirement_key` and `level` schema.
- `store_profiles` lacks current public-store-name and fulfillment fields.

An ordinary `php artisan migrate --no-interaction` in the local development API container failed on the first duplicate column and rolled back. No schema reset, table deletion, migration-history falsification or revival of deleted code was performed. Counts in the inspected onboarding steps, store profiles, document versions and activation-history tables were zero; this is not proof that all legacy business data is empty.

The earlier isolated test results remain valid for the clean current schema, but do not establish compatibility with this legacy development database. The user subsequently authorized a separate clean development database, as recorded below.

## Admin diagnosis and correction

The confirmed email has a live pending invitation, no Admin user, and no Admin membership. Login cannot succeed before invitation acceptance and password/TOTP setup. The user must open the existing invitation in local Mailpit at `http://localhost:8025`; no replacement password or authentication bypass is appropriate.

`apps/admin-web/src/lib/auth-api.ts` now preserves the backend's generic `INVALID_CREDENTIALS` message. Tests in `auth-api.test.ts` cover invalid credentials, the safe unknown-401 fallback, and MFA errors. There is no API contract, migration or authorization change. Existing cookie/CSRF/refresh safeguards remain intact.

## Authorized clean development database

The user selected a separate clean development database with account recreation. Created `materyalph_dev_phase3_20260917` under the existing local PostgreSQL role. The old `materyalph_dev` database remains intact; its six Vendor organizations were verified after the switch. No legacy approval states or account records were copied.

Updated only `DB_DATABASE` in the ignored root and API environment files, and added a distinct `REDIS_PREFIX` in the API environment. This keeps old cache/queued-job state separate without flushing Redis. Recreated local API, queue worker and scheduler containers so they load the new settings. Existing keys and provider credentials were retained, not rotated or displayed.

`docker compose run --rm --no-deps api php artisan migrate --seed --no-interaction` passed all 22 current migrations and `SystemFoundationSeeder`. The active runtime has the current onboarding schema and a foundation Passport client. A fresh bootstrap invitation for the confirmed Admin email was issued through the existing outbox; use the newest Mailpit invitation, not the one from the old database.

The Vendor browser Retry now redirects the obsolete session to `/login`, rather than leaving it on an HTTP 500 entry screen. This is expected because the old account is not in the new database. Full live Welcome/onboarding verification requires the user to register a new Vendor account and finish verification/MFA. Admin login requires accepting the newest invitation, setting a password and enrolling TOTP. Do not paste passwords, OTPs or recovery codes into chat.

Admin lint, typecheck, build and all 10 tests across three files passed. The isolated Laravel rerun passed 102 tests / 1,247 assertions in 53.00 seconds, preserving the Phase 2 baseline. Compose validation, the focused source secret scan and whitespace check passed. Delivery of the new Admin invitation to Mailpit was confirmed. No new migration file, API contract change, deployment, commit or Buyer edit was made.

Suggested commit: `fix(admin): distinguish invalid credentials from expired sessions`.
