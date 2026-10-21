# Render backup profile-photo repair — 22 October 2026

Render remains available alongside the pending Railway/Vercel deployment work.
The API configuration repair is live in deployment `dep-dbcf84ektt5c73f8of40`,
finished at `2026-10-21T17:19:46Z`, using the existing successful build of commit
`14d5c98a339a333d18309cbb60f794f26312300d`. No source was pushed or merged.

## Findings and repairs

- The configured `TRUSTED_PROXIES=*` was parsed into an array. Laravel recognizes
  its wildcard as a string; the array caused forwarded HTTPS to be ignored and
  could generate HTTP avatar links rejected by the shared web photo loader.
  Bootstrap now preserves wildcard strings while retaining explicit proxy lists
  and the default of trusting no proxy. Six database-free regression cases cover
  HTTPS signed-photo URLs, signature tampering and untrusted forwarded headers.
- The running Render release uses the compatible `TRUSTED_PROXIES=REMOTE_ADDR`
  setting. Nginx still sets HTTPS and uses the configured portal-host allowlist.
  Only this API setting changed; scanner, private storage, cookie protections,
  provider credentials, plans and other services retain their configuration.
  A future Blueprint sync can restore `*`; deploy the bootstrap repair before
  doing that. The older running source still mishandles the wildcard.
- The local-to-Render database snapshot retained 36 account-photo references to
  local files: 34 Vendor, one Buyer and one Admin. Those files were absent from
  Render. With explicit owner approval, their existing sanitized 256px PNGs were
  copied to the configured private `materyalph-staging-private-2026` bucket.
  Every copy was read back and its SHA256 compared with the local original.
  One transaction updated only their photo disk, profile version and update time,
  and appended 36 `PROFILE_PHOTO_STORAGE_RECOVERED` audit records. Existing keys
  and local originals were preserved; no history was deleted or rewritten.
- A later read-only audit confirmed all 37 current photo references have private
  objects: 35 Vendor, one Buyer and one Admin. This includes the newly uploaded
  Vendor photo that was already stored correctly. Each database inspection used
  a temporary operator-only `/32` rule; read-back confirmed the allowlist was
  empty again afterward. No image bytes, object keys, signatures or credentials
  were printed.
- Buyer account reads inherited a three-second timeout. Render logs included a
  profile request abandoned at 2.960 seconds. Buyer account GETs now allow a
  30-second connection and 60-second response; photo reads retain their separate
  15-second response budget. Shared upload budgets and mutation retry behavior
  are unchanged. A rebuilt Android debug APK targets the Render API directly.

## Deployment handling

The Render connector automatically triggered a newer branch build when saving
the setting. That build was canceled. A subsequent build pinned to the existing
release failed because PECL returned HTTP 504 while downloading Redis. Render's
documented `deploy_only` mode then activated the last successful build with the
new configuration. Its exact commit and final `live` status were verified.
This does not publish the local bootstrap or Buyer source changes.

## Changed source and contract

- `services/api/bootstrap/app.php`
- `services/api/tests/Unit/TrustedProxyConfigurationTest.php`
- `apps/buyer-mobile/lib/auth/auth_repository.dart`
- `apps/buyer-mobile/test/profile_photo_repository_test.dart`
- This evidence document and the dated follow-up in the earlier upload report.

No schema migration, API request/response change, generated-client change or new
credential is required. Existing owner-bound signed URLs, Passport/session
authorization, profile versions and private/no-store photo responses remain.

## Validation

| Check | Result |
| --- | --- |
| Proxy regression before repair | Two wildcard cases failed as expected |
| Isolated proxy + account security + auth transport suite | 38 passed / 275 assertions |
| Buyer photo repository suite | 9 passed |
| Broader Buyer profile + photo run | 17 passed / 1 failed: notification page expected `Inbox` at `buyer_profile_test.dart:121`; the changed source does not alter that route |
| Flutter analysis | No issues |
| Dart formatting | Two files, zero changes |
| Pint, changed PHP files | Passed |
| Production PHPStan, 512 MiB | No errors |
| OpenAPI validation | Passed, eight existing unused-model recommendations |
| Buyer Android debug APK for Render | Built successfully |
| APK archive integrity and compiled Render API URL | Passed; SHA256 `e559ccf649ce64c0b6a8e16f38cdec2a5a4cd215668690cfc440b09e11de9558` |
| Live API health, portal routes, secure cookies, CORS and CSRF guards | Passed |
| Recovered private-object checks and closed database allowlist | Passed |
| Source secret scan and changed-file whitespace | Passed; six changed source/documentation files, no leaks |

No application errors appeared in the short post-deployment log check. This is
not a sustained-load or provider-availability guarantee. The first metadata
recheck hit a transient storage-provider error; the retry with bounded SDK
retries completed and confirmed all 37 objects.

The user elected to perform visual acceptance. Reload Vendor/Admin Settings and
use Refresh profile in the Buyer app; install the rebuilt APK to receive the
timeout change. No authenticated browser or physical-device visual acceptance is
claimed. The full application suites were not rerun. Existing Android build-tool
deprecation warnings remain; dependency versions were not changed.

Suggested commit: `fix(identity): restore Render profile photos and hosted account reads`
