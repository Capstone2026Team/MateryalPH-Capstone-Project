# Buyer minimum Google rating filter — 2026-10-24

The minimum is inclusive. Selecting 3.0+ keeps Directory Suppliers rated 3.0 through 5.0 and hides lower-rated and unrated suppliers. The same boundary applies to 3.5+, 4.0+ and 4.5+. Verified Vendor eligibility, public data and VPS remain unchanged. Clearing the minimum restores all otherwise eligible Directory Suppliers inside the selected radius.

## Cause and change

The generated Dart decimal enum serialized the selected rating as a JSON string, for example `"3.0"`. Laravel's numeric allowlist stringifies the numeric 3.0 choice as `"3"`, so the app's `"3.0"` request failed validation. The Directory query already uses `google_rating >= minimum`.

`packages/api-contract/scripts/generate-clients.mjs` now registers a numeric enum serializer for this request field. Its members and numeric values are derived from the generated request model. Both API clients were regenerated through the repository script, then Dart's built-value output was regenerated. No generated file was edited by hand. The public Dart enum API stays compatible, and the actual HTTP body now contains numeric values for every supported option.

`packages/api-contract/openapi.yaml` clarifies the inclusive numeric boundary. The field's type, allowed values and response shape are unchanged. The geography contract check asserts that it remains numeric and inclusive. The Buyer workflow now states the exact boundary explicitly.

Regression tests:

- `apps/buyer-mobile/test/directory_rating_transport_test.dart` uses the real API repository, generated client and Dio request stream. It checks numeric JSON for all four choices, successful response decoding, clearing/Verified-only omission, enum round trips and unsupported wire rejection.
- `services/api/tests/Feature/Api/PhaseSixBuyerDiscoveryTest.php` checks all four inclusive boundaries with real PostGIS-backed filtering, an eligible in-radius Verified Vendor, lower-rated/unrated Directory stores and a 5.0 store. Global row numbers may close up after filtering; all other Verified Vendor data remains identical. Clearing restores the original Directory count, and filtering reuses provider cache entries.

There is no migration, backend authorization or query change, new provider call, new setting or key. Google attribution and the shared radius remain authoritative.

## Verification

- Buyer focused suite: **31 passed, 0 failed**. Command from `apps/buyer-mobile`:
  `flutter test --no-pub --concurrency=1 --reporter expanded test/directory_rating_transport_test.dart test/directory_filters_test.dart test/discovery_freshness_test.dart test/discovery_cache_test.dart test/supplier_browsing_test.dart`.
- `flutter analyze --no-pub`: **No issues found**.
- Regenerated Dart request/serializer analysis: **No issues found**.
- Client regeneration and `dart run build_runner build`: passed.
- Generated TypeScript `npm run build`: passed.
- OpenAPI `npm run validate`: passed, with eight unused-model recommendations.
- Geography contract: **18 operations** match the isolated Laravel routes and authorization middleware.
- Isolated API rating regressions: **2 passed, 46 assertions**. Filter:
  `--filter=directory_google_rating_and_distance_filters_leave_verified_vendors_unchanged|directory_minimum_google_rating_is_inclusive_for_every_supported_value`.
- Pint checks the changed API test file. Scoped secret and whitespace checks cover the changed source, tests, contract and generated rating artifacts.

The initial wider discovery-class run passed 20 existing tests; its new regression exposed fixture/assertion issues (a missing test-store location, global row numbering and preserved PHP array keys). Those were corrected and both rating regressions passed afterward. The entire discovery class was not rerun after the test-only corrections. The complete API/Buyer suites and live Google/phone checks were not run for this fix.

Windows runs used the installed Dart executable/Flutter tool snapshot and process-local D: temporary storage. API tests ran only in the guarded `materyalph_phase1_test` stack. Logs are under `.tmp/rating-filter-*`.

## Device acceptance

Hot restart the existing Buyer Flutter session with capital `R`, then retry or reapply the filter. Verify stores rated exactly 3.0 and above remain visible, lower-rated/unrated Directory stores disappear, the same behavior holds at each other minimum, clearing restores results, and Verified Vendors stay available. No sign-out, app-data deletion or database setup is needed.

Suggested commit: `fix(buyer): serialize minimum Google ratings as numbers`.
