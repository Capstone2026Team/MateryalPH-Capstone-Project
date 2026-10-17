# Buyer account settings and photo upload — 10 October 2026

## Outcome

Account Setting no longer lists Terms & Agreements or Connected Accounts. The Profile support link still opens the existing agreements screen, and registration acceptance remains required.

Upload photo appears below the account picture and opens the gallery directly. The separate Edit Profile Picture placeholder destination was removed. Uploads show progress, safe failure messages and authoritative success; profile refresh renews the signed photo link. Both Profile and Account Setting show authenticated photo bytes.

## Changed files

- `apps/buyer-mobile/lib/screens/buyer_profile_screen.dart`
- `apps/buyer-mobile/lib/widgets/buyer_account_widgets.dart`
- `apps/buyer-mobile/lib/auth/auth_repository.dart`
- `apps/buyer-mobile/ios/Runner/Info.plist` (existing gallery permission description)
- `apps/buyer-mobile/test/buyer_profile_test.dart` (existing upload-control expectation)
- `apps/buyer-mobile/test/profile_photo_repository_test.dart`
- `services/api/routes/account.php`
- `services/api/app/Http/Resources/AccountProfileResource.php`
- `services/api/tests/Feature/Api/PhaseTwoAccountSecurityTest.php`
- `packages/api-contract/openapi.yaml`
- `packages/api-contract/scripts/check-account-contract.mjs`
- Seven regenerated files: Dart/TypeScript `AccountsApi` implementation and documentation, both generated READMEs, and the Dart account API test scaffold.

No migration, dependency, credential or new configuration key is required. No Git commands or deployment were performed.

## API and authorization

Added `POST` and signed `GET /api/v1/buyers/account/photo`, with generated operations `uploadBuyerAccountPhoto` and `getBuyerAccountPhoto`. Buyer profiles can now return their owner-bound five-minute `avatar_url`.

Both routes require the existing MOBILE Passport session, Buyer scope and active-account authorization. The shared upload action retains JPEG/PNG/WebP validation, the 2 MB and 4096-pixel limits, fail-closed malware scanning, 256px PNG sanitization, private storage, `lock_version` concurrency checks and `PROFILE_PHOTO_UPDATED` audit records. Photo reads recheck ownership, session and current profile version and return private/no-store responses. The mobile client uses the configured API host rather than requesting a supplied avatar URL directly.

The web-photo contract's obsolete upload-limit description and 429 response were corrected to match the existing rate-limit policy; runtime throttling was unchanged.

## Verification

- Isolated API account/photo/rate-limit regression: **23 passed, 1701 assertions**. Development database was not changed; scanner behavior uses a fake.
- `flutter test --no-pub test/profile_photo_repository_test.dart`: **7 passed**.
- `flutter analyze --no-pub`: **No issues found**.
- Final `dart analyze lib test`: **No issues found**; formatting check: **five files, zero changes**.
- Pint on the three changed PHP files: **passed**.
- PHPStan `analyse --no-progress --memory-limit=512M`: **No errors**.
- OpenAPI validation: **passed**, eight unused-model recommendations.
- Account contract: **65 protected operations matched**.
- Rate-limit contract: **390 everyday operations checked**.
- Generated TypeScript client build: **passed**.
- Compose configuration, changed-line whitespace/merge-marker check and Gitleaks directory scan of affected source: **passed**, no leaks found.

Physical-device gallery/upload UI and accessibility remain manual. The original API checks used a scanner fake; the follow-up below records the live ClamAV check. UI/E2E tests were not run.

Suggested commit: `feat(buyer): upload profile photos from account settings`

## Device upload follow-up

The API health check succeeded through `127.0.0.1:8080`. The running Docker API has GD and ClamAV available. Connection forwarding was not the cause of the photo failures.

Two request problems were reproduced:

- The generated photo client sent signed fields in a different order from Laravel's signed URL. The running API accepted the original order and rejected the old generated order. OpenAPI now lists the query fields as `expires`, `owner`, `version`, `signature`; clients were regenerated, and that wire order has contract, Dart and API regression coverage. Signature checks remain enforced; modified owner/version fields are rejected.
- The default three-second response timeout expired before the live malware scan finished. Scanning the public repository logo succeeded and took **11.62 seconds**. Buyer photo uploads now allow **45 seconds** for a response and **30 seconds** for sending; photo reads allow **15 seconds**. Other account requests keep their original budget. Upload response timeouts ask the Buyer to refresh and check saved state before retrying; mutations are not automatically retried.

Repair files: `auth_repository.dart`, `profile_photo_repository_test.dart`, OpenAPI, the account contract checker, generated Accounts API implementations/documentation, the existing account-security test and this report. No migration, configuration key, scanner bypass or development database change.

Follow-up verification: **20 isolated API tests / 190 assertions**; **nine Dart repository tests**; Flutter analysis (**No issues found**), PHPStan, Pint, contract validation, generated TypeScript build, formatting, changed-line whitespace and secret scan passed. Flutter analysis is recorded in `services/api/storage/logs/buyer-photo-repair-analyze.log`.

Hot restart the running Buyer app (capital `R` in the Flutter terminal), then use Refresh profile. A hot restart installs the new request interceptor. Device UI and a private-photo upload were left for manual verification.

Suggested repair commit: `fix(buyer): preserve signed photo queries and scan timeout`
