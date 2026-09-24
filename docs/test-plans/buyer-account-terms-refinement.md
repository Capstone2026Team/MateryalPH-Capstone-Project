# Buyer account and Terms refinement — 20 September 2026

## Scope and outcome

Buyer Flutter refinement only, with the small shared API compatibility changes needed for authenticated contact data and reviewed registration Terms. No Vendor/Admin portal source was edited for this task. Pre-existing working-tree changes were preserved. No migrations, deployment, commit, push, or merge.

The user explicitly selected **preserve the identity-verification gate**. Edit Account Details shows the complete email returned after recent identity verification; before verification it shows an explanation and Verify identity action rather than a masked email. Email changes continue through the existing secure flow. Profile and Account Setting continue respecting the backend's email masking policy.

## Buyer files changed in this task

- `apps/buyer-mobile/lib/auth/auth_repository.dart`: generated-client agreement retrieval; temporary in-memory Terms review; required reviewed version/hash on registration and Google signup; stale review invalidation.
- `apps/buyer-mobile/lib/main.dart`: Welcome/Login registration entry through Terms; origin-aware back; stale Google signup review recovery.
- `apps/buyer-mobile/lib/screens/terms_screen.dart`: current title/version/effective date and complete maintained content; initially disabled CTA; real scroll-end detection with a 4-pixel tolerance; retry/failure states; system back.
- `apps/buyer-mobile/lib/screens/register_screen.dart`: guarded direct entry, revised hierarchy, confirmation field and visibility controls, required Buyer information retained, accepted Terms version summary, existing Privacy acceptance and Google signup.
- `apps/buyer-mobile/lib/screens/login_screen.dart`, `welcome_screen.dart`: light layout, branding, CTA hierarchy, spacing, purposeful Lucide icons and loading/keyboard behavior.
- `apps/buyer-mobile/lib/screens/buyer_profile_screen.dart`: accessible Search Snackbar; Account Setting Agreements destination; account refresh/back behavior.
- `apps/buyer-mobile/lib/screens/buyer_account_screen.dart`: removed subsection chips; full verified email and registered phone; legal rendering; clearer security grouping; danger session actions; scrollable confirmation dialog.
- `apps/buyer-mobile/lib/widgets/buyer_account_widgets.dart`: shared registered phone display, labelled Search/Notifications, long-name layout and scalable account header.
- `apps/buyer-mobile/lib/widgets/legal_content.dart`: themed selectable Markdown and safe external legal links, using `flutter_markdown_plus`.
- `apps/buyer-mobile/lib/widgets/auth_content.dart`, `phone_number_field.dart`: consistent Lucide feedback/dropdown icons.
- `apps/buyer-mobile/pubspec.yaml`, `pubspec.lock`: Markdown renderer dependency.

Tests: `account_refinement_test.dart`, `terms_flow_test.dart`, `terms_fixtures.dart`, `buyer_account_test.dart`, `buyer_profile_test.dart`, `buyer_app_test.dart`, `auth_presentation_test.dart`, `ui_capture_test.dart`.

## API and security integration

- AccountProfile adds optional `mobile_e164` and `email_masked`; the number is selected by the authenticated user's ID, never a client-provided user ID. Existing authorization and 15-minute email disclosure rule remain intact.
- Public current agreements add hash-verified maintained Markdown and its stored source hash. Text is not fabricated or modified; the existing configured privacy-contact substitution remains available.
- Buyer email registration requires `terms_version_id` and `terms_content_hash`. Buyer Google signup carries these through the existing cached OIDC flow and validates them again before account creation. SIGN_IN behavior remains unchanged.
- `AgreementContent.php` and `BuyerRegistrationTerms.php` implement local content verification and current-version validation. Missing, retired, mismatched or unavailable Terms fail closed.
- `RegisterAccount.php` / `GoogleOidcService.php` retain existing authoritative acceptance inserts (`REGISTRATION` / `GOOGLE_OIDC`) and transactions. No anonymous evidence, acceptance table changes, or modifications to authenticated reacceptance/history behavior.
- Updated `AgreementController.php`, `RegisterRequest.php`, `GoogleOidcController.php`, `AccountProfileResource.php`, and `packages/api-contract/openapi.yaml`. TypeScript/Dart clients and Dart serializers were regenerated, not hand-edited. The agreement list envelope is explicitly typed to avoid the generator inheriting an object-shaped `data` from SuccessEnvelope.
- No changes to Passport, secure token storage, OTP policy, Google identity verification, recent-auth requirements, session revocation, or backend email-change rules.
- The Buyer app and compatible API must be released together: old Buyer registration submissions without Terms evidence are intentionally rejected. No new keys or manual database setup are required.

Backend tests added/updated: `BuyerRegistrationTermsTest.php`, `GoogleOidcValidationTest.php`, `PhaseTwoAccountSecurityTest.php`, `BotProtectionTest.php` (existing registration fixture now includes required review evidence).

## Verification results

| Check | Exact result |
| --- | --- |
| `dart format --output=none --set-exit-if-changed lib test` | 35 files, 0 changed; exit 0 |
| `flutter analyze --no-pub` | No issues found; exit 0 |
| `flutter test --no-pub test/terms_flow_test.dart test/account_refinement_test.dart test/buyer_account_test.dart test/buyer_profile_test.dart test/auth_presentation_test.dart test/buyer_app_test.dart` | 51 passed; exit 0 |
| `flutter test --no-pub` | 55 passed; exit 0 |
| `flutter test --no-pub --update-goldens test/ui_capture_test.dart` | 2 passed; screenshots inspected |
| `flutter build apk --debug` | Successful; `build/app/outputs/flutter-apk/app-debug.apk`; assembleDebug 103.4 seconds |
| Isolated API test filter `BuyerRegistrationTermsTest\|PhaseTwoAccountSecurityTest\|PhaseTwoAgreementsTest\|BotProtectionTest\|GoogleOidcValidationTest\|AuthTransportSecurityTest` | 46 passed, 312 assertions; 23.80 seconds |
| PHPStan `analyse --no-progress --memory-limit=512M` | No errors; exit 0 (default 128 MB was insufficient) |
| Pint `--test` on 12 affected PHP files | Passed |
| `npm.cmd run validate` in `packages/api-contract` | Passed; three existing unused-model recommendations |
| Account contract checker against isolated Laravel route export | 57 protected operations matched routes, audiences, transport and envelopes |
| `git diff --check` | Passed |
| Gitleaks scans of Buyer lib/test and API app, plus staged scan | No leaks; staged scan had no staged content |

All database tests ran only after `scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning` proved the dedicated `materyalph_phase1_test` / `materyalph_test` environment. Development database was not tested or reset.

## Coverage and review evidence

- Registered phone on Profile/Settings; full verified email/phone on details; missing-phone state; cross-user phone isolation and email gate expiry.
- Labelled Search, live-region `Not yet implemented.` feedback, preserved Notifications destination.
- No subsection chips or replacement tabs on all four account screens; retained security/session/agreement content and destructive confirmation.
- Welcome and Login entry through Terms; disabled semantics initially and before the end; elapsed time cannot enable acceptance; end tolerance enables registration; direct widget entry and cleared flow cannot bypass review; repository rejects submission without review; generated request carries version/hash.
- Backend missing/stale/unavailable content rejection, no pre-account acceptance rows, correct registration evidence, Google reviewed-version preservation and changed-version rejection during callback.
- 320-pixel narrow screens, normal phone widths, landscape, text scaling up to 2x, keyboard inset 240, long name/email, and long legal content. Fixed the large-text session confirmation overflow found by tests.
- Visual baselines: `docs/design/evidence/buyer-account-refinement/` (Welcome, Login, Registration, Terms and four account screens), plus updated Buyer Profile/Settings baselines in `docs/design/evidence/ui-refinement/`. Fixture content is used only in tests/screenshots, never as application legal text.

## Remaining verification limits

No unresolved implementation/test failure. Physical-device TalkBack/VoiceOver, iOS build/device verification and live Google-provider/account registration were not exercised here; tests use isolated fixtures and provider fakes. The Android build reports existing upcoming AGP/Kotlin support warnings; toolchain versions were not changed by this UI task.

Suggested commit: `feat(buyer): refine account screens and require reviewed registration terms`
