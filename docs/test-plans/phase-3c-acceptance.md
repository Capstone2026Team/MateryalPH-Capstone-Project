# Phase 3C acceptance audit — September 24, 2026

Phase 3C is ready for acceptance review against the automated gates below. Live provider connectivity is not proven by these tests. Apply the new additive migration in the environment used for manual acceptance before submitting verification.

## Scope and preserved behavior

Audited Phase 3C in `docs/plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md`, the current `MateryalPH_Store_Verification_Onboarding_Spec.md` sections 6–8 and 14, the Final Vendor Workflow and UI/UX planner, the existing pending-submission test plan, and the address/PSGC implementation notes. The Phase 3C prompt's missing workflow filename now points to the current specification.

Automatic partial saving on navigation and Finish Later remains in place. There is no manual Save Verification Draft prerequisite. Files remain private pending selections until explicit atomic Admin submission. Inline validation, corrected Business Information geometry, immutable evidence history and authorization remain intact. No Navigation Sidebar, Admin page, Buyer page or Store Setup implementation was changed by this audit; their pre-existing workspace changes were preserved. Store Setup was checked only as the existing destination after verification submission. Phase 3D was not started.

## Completed gaps

| Area | Result and implementation |
| --- | --- |
| Address fallback | `VendorBusinessAddress.tsx` offers explicit Manual Address Entry and Interactive Map Selection. A complete PSGC-selected structured address can be submitted without Google interaction or a resolution token. The backend stores source MANUAL and null coordinates/geography; it does not invent a location or mark it verified. Map-mode edits still require an organization/address-bound token. Geocoding failure retains structured input and offers manual entry and retry. |
| Address layout | Fields beside map at desktop widths and above map below 1024 px; dedicated read-only latitude/longitude fields; four-digit postal code and 2–200-character street validation. The map initializes only while V2 is selected. |
| Stale lookups | Existing sequence guards are retained. Browser coverage exposed the shared transport's duplicate-POST guard rejecting a newer pin while an older lookup was pending. Only the two read-only address lookup endpoints now opt into concurrent POSTs. Other mutations retain duplicate-request protection; CSRF, authentication and rate limiting still apply. |
| Classification | Exactly three Supplier Type radios; all 27 canonical niches with short scope descriptions; multiple Other labels; 2–60-character normalized distinct labels; unchanged classifications avoid unnecessary version increments. Rental, hire, leasing, punctuation and concatenated variants are rejected with the offending label and approved explanation. Custom labels remain separate from taxonomy. |
| Review | New shared `OnboardingReview` groups all requirements by verification step, preserves requirement level/status/reasons and provides jump buttons. It separately lists unsaved edits and private saved progress awaiting submission. Review uses the latest saved address draft. Privacy validation clears when acknowledged. |
| Submission and privacy | Exact missing address, Supplier Type, niches and public store-name keys are returned. A current published notice and acknowledgment are required. New acknowledgment records include processing activity STORE_VERIFICATION and source VENDOR_WEB, separate from commercial agreements. Existing confirmation and Proceed to Store Setup behavior are retained. |

## Files and contract

Primary changes: Vendor `PhaseThreeVendorPages.tsx`, `VendorBusinessAddress.tsx`, `VendorAddressMapSelector.tsx`, `onboarding-api.ts`; shared `onboarding-review.tsx`, `custom-label-input.tsx`, `web-api-session.ts` and exports; API `VendorAddressResolver.php`, `VendorOnboardingService.php`, address/draft Form Requests; related component, transport, API and browser tests.

New migration: `services/api/database/migrations/2026_09_24_000000_add_privacy_acknowledgment_context.php`. It adds nullable processing_activity and source columns, leaving historical immutable acknowledgments unchanged. Existing address tables already support nullable coordinates; no new address table or coordinate migration was needed.

OpenAPI documents MANUAL source behavior, null coordinates, map-token requirements and updated address/custom-label limits. TypeScript and Dart clients were regenerated with the repository generator. Dart serializers were regenerated and analyzed. The contract checker asserts the new label bounds and manual-address description. No new endpoint or permission was introduced.

Security decisions: reject raw client coordinates; validate PSGC ancestry server-side; require bound, unexpired tokens for map mode; preserve address versions and reopened review; retain fail-closed file validation and private pending-file permissions; retain Owner-only submission and commercial-agreement separation. No provider credentials were added or printed.

## Acceptance evidence

| Gate | Result |
| --- | --- |
| API full suite, Docker Compose api-test/PostgreSQL | **174 passed, 2,076 assertions** |
| Vendor components and transport | **109 passed, 12 files** |
| Admin regression suite after shared transport change | **16 passed, 8 files** |
| Responsive browser tests | **64 passed**, eight scenarios at each of **320, 375, 390, 768, 1024, 1280, 1440, 1920 px** |
| Vendor and Admin lint/typecheck/build | Passed; Vendor retains its existing bundle-size advisory |
| Pint / PHPStan | Passed / no errors |
| OpenAPI validation | Passed; three existing unused-model recommendations |
| Vendor and account contract checkers | Passed; 32 and 57 operations respectively |
| Generated TypeScript build | Passed |
| Dart build_runner / generated-client analysis | Passed / no issues |
| Normal and isolated Compose config | Passed |
| Gitleaks | No findings in the empty staged set or 174 changed/new source-text files scanned |
| git diff --check | Passed |

API additions prove manual final submission without any geocoder call; null coordinate/geography storage; preserved old address and reopened current review; rejected malformed/manual address inputs; privacy source/activity and separation from commercial acceptance; missing/current notice handling; exact incomplete requirement keys; and normalized rental rejection even alongside Tools and Equipment.

Browser scenarios cover manual completion and submission with zero address-lookup requests, pin coordinates, incomplete reverse-geocode completion, stale pin responses, provider failure fallback, 27 niches and multiple custom labels, inline offending-label errors, acknowledgment refusal, grouped checklist jumps, confirmation and pending Store Setup access, and page/stepper overflow. The five existing Business Information scenarios also pass at every width, covering email lifecycle, inline validation, version conflicts, corrected tax/contact geometry and pending evidence selection/replacement/removal.

Screenshots: `docs/design/evidence/phase-3c/{width}-{address,classification,review,confirmation,resolved-pin}.png`. Desktop and mobile screenshots were visually inspected. Fixtures are synthetic; resolved-pin screenshots intentionally contain a mock map control. Existing Business Information screenshot evidence is refreshed by its regression suite.

Logs: `.tmp-phase3c-api-tests.txt`, `.tmp-phase3c-web-tests.txt`, `.tmp-phase3c-admin-tests.txt`, `.tmp-phase3c-browser-tests.txt`, `.tmp-phase3c-generation.txt`, `.tmp-phase3c-dart-generation.txt`, `.tmp-phase3c-dart-analyze.txt`.

## Reproduction

From the repository root (use the installed Docker CLI path if docker is not on PATH):

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml up -d --wait api-test
docker compose --env-file services/api/.env.testing -f compose.test.yaml exec -T api-test php artisan test --compact
```

The existing test-only environment and Compose project isolate PostgreSQL from development data. No host-side PostgreSQL test run was used.

```powershell
cd apps/vendor-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run
npm.cmd run build
npm.cmd run test:e2e -- e2e/phase-3c.spec.ts e2e/onboarding-steps.spec.ts --grep-invert 'setup previews' --reporter=list
```

Admin uses the same lint/typecheck/test/build commands in `apps/admin-web`. API checks are `php vendor/bin/pint --test` and `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` in `services/api`. Contracts use `npm.cmd run validate`, `npm.cmd run test:vendor-contract`, `npm.cmd run test:account-contract`, `npm.cmd run generate` and `npm.cmd run build --prefix generated/typescript` in `packages/api-contract`. Generated Dart uses `dart run build_runner build --delete-conflicting-outputs` and `dart analyze` in `packages/api-contract/generated/dart`.

## Manual setup and limits

- Apply the new migration to the intended development/acceptance environment: `cd services/api; php artisan migrate`. It was exercised by the isolated Docker suite; this audit did not migrate a live or development database.
- No new secret key is required. Existing restricted VITE_GOOGLE_MAPS_BROWSER_KEY and separate backend GOOGLE_MAPS_SERVER_API_KEY remain necessary for live map functionality. Existing email, private storage and scanner configuration remains necessary.
- Live Google Maps/Geocoding, email delivery, malware scanner, object storage and a live Vendor-to-Admin session were not exercised. Tests use provider fakes and browser interception.
- Manual entry removes the Google dependency, while official PSGC suggestions and ancestry validation still use the existing cached PSGC provider. A total uncached PSGC outage requires retry; arbitrary fabricated codes are not accepted.
- This is Phase 3C acceptance evidence, not full-repository or Phase 3D acceptance. Buyer UI tests were not rerun because no Buyer implementation changed; generated Dart compatibility was analyzed. Historical unrelated Buyer test failures in the pending-submission report are not represented as resolved.
- No deployment, push, commit, new credentials or unrelated functionality changes were made.

Suggested commit: `feat(vendor): complete phase 3c verification acceptance`
