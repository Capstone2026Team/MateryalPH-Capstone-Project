# Xendit TEST correction validation — 25 September 2026

## Outcome and root cause

The former adapter intentionally threw PROVIDER_ONBOARDING_UNSUPPORTED before creating an account because it required a hosted invitation URL. That prerequisite was incorrect for the requested TEST flow and has been removed.

MateryalPH provisions a Xendit TEST sub-account directly through the official Accounts API. TEST mode does not provide Vendor Dashboard login or invitation-based onboarding; therefore MateryalPH manages the TEST connection through its backend.

The Owner clicks Connect Xendit; the authenticated backend calls POST https://api.xendit.co/v3/accounts with trusted store name/Owner email and PH/CORPORATION identity. A successful, matching provider response with a valid account ID and LIVE status, followed by successful association persistence, yields CONNECTED_TEST. The UI updates inline, shows TEST and a masked suffix, and allows the next step. Actual business type is untouched. TEST does not establish production KYC or live payment capability.

## Files changed for this correction

Existing unrelated working-tree edits were preserved. The focused correction changes these source files:

- services/api/app/Infrastructure/Payments/ConfiguredXenditAccountVerificationGateway.php
- services/api/app/Domain/Vendors/XenditAccountVerificationGateway.php
- services/api/app/Domain/Vendors/XenditProviderUnavailable.php
- services/api/app/Domain/Vendors/VendorOnboardingService.php
- services/api/app/Domain/Vendors/StoreActivationGate.php
- services/api/config/services.php
- services/api/database/migrations/2026_09_25_000002_support_xendit_test_provisioning.php (new)
- services/api/tests/Feature/Api/PhaseThreeVendorOnboardingTest.php
- services/api/tests/Unit/XenditTestProvisioningTest.php (new)
- packages/web-ui/src/xendit-connection.tsx
- apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx
- apps/vendor-web/src/pages/XenditConnection.test.tsx
- apps/vendor-web/e2e/onboarding-steps.spec.ts
- packages/api-contract/openapi.yaml
- packages/api-contract/scripts/check-vendor-onboarding-contract.mjs
- services/api/docs/xendit-onboarding.md
- docs/workflows/MateryalPH_Store_Verification_Onboarding_Spec.md
- docs/architecture/data-dictionary.md and docs/architecture/erd.md (regenerated from PostgreSQL)
- docs/test-plans/xendit-onboarding-validation.md

The obsolete, previously untracked services/api/app/Domain/Vendors/XenditOnboardingUnsupported.php was removed. Applied provenance migration 2026_09_25_000001 is unchanged. The new additive migration extends the existing status constraint and adds provider_created_at; deprecated invitation columns remain for historical compatibility. It was applied to the verified local development database. No development rollback or destructive database operation was performed.

Generated TS/Dart clients were regenerated through npm run generate, not edited manually. Semantic outputs include generated/typescript/src/models/VendorPaymentOnboarding.ts, generated/typescript/src/apis/VendorOnboardingApi.ts, generated/typescript/docs/VendorPaymentOnboarding.md, generated/typescript/docs/VendorOnboardingApi.md, generated/dart/lib/src/model/vendor_payment_onboarding.dart and its .g.dart serializer, generated/dart/lib/src/api/vendor_onboarding_api.dart, generated/dart/doc/VendorPaymentOnboarding.md and generated/dart/doc/VendorOnboardingApi.md under packages/api-contract. Generator manifests/README and serializer registrations were refreshed by tooling. Connect returns status/environment and no invitation URL. The existing no-body connect route and generated client call are reused.

## Security and duplicate prevention

Owner permission, current organizational authority, session authentication, CSRF, route throttles and Idempotency-Key requirements remain. Credentials stay backend-only, TEST mode/key/origin checks fail closed, and .env remains ignored. No browser-supplied provider association or manual success override exists.

Creation reservation is committed under an organization row lock before the network call. No lock spans the network. Repeated connected requests reuse the association; concurrent in-flight requests cannot create again. Unique organization and provider-association indexes remain. Explicit provider rejection allows retry; ambiguous outcomes retain the reservation for investigation. Audit metadata contains only allowlisted error codes/status, never provider bodies or credentials. The in-flight concurrency regression interleaves a second request during a fake gateway call; it is not a multi-process load test.

## Verification

- Vendor lint/typecheck/build passed; Vitest **137 tests in 18 files passed**. Existing large-bundle advisory remains.
- Admin lint/typecheck/build passed; Vitest **16 tests in 8 files passed**. No Admin source was changed.
- Browser: **16/16 passed** at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. Checks cover inline success, no popup, next-step navigation, reload, failure, retry and horizontal overflow. 320/1440 screenshots were visually inspected. Browser APIs are intercepted fixtures, not provider proof.
- OpenAPI validation passed with three existing unused-model recommendations. Vendor contract: **33 operations**; account contract: **57 protected operations**. TypeScript generated-client build passed.
- Dart build_runner generation passed and generated Dart analysis reported **no issues**. The SDK required standard user-cache access outside the workspace.
- Isolated PostgreSQL empty migration/seed, rollback, replay and generated schema consistency checks passed via scripts/verify-test-schema.php. Existing development data was retained.
- Final isolated backend: Pint **265 files passed**, PHPStan **no errors** (512 MB), and full php artisan test --compact **215 tests passed / 2,283 assertions**, 147.34 seconds.
- Compose validation passed. Gitleaks tracked-diff, staged and new Xendit source/test/migration scans found **no leaks**. Staged scan had no staged changes. git diff --check passed. No accidental untracked .txt, screenshot, log, zip or temporary files were added; Playwright artifacts remain ignored.

The first focused backend run exposed a missing business-type test fixture; it was fixed. The first full backend run exposed missing checklist initialization when connecting before any snapshot, and a legacy activation test that removed KYC capability instead of TEST connection state; both were corrected. Initial browser failures were caused by Windows encoding in expected text and passed after UTF-8 correction. These are not remaining open failures.

## Actual provider verification and remaining blocker

The existing authenticated local Vendor Owner clicked Connect Xendit against the real configured TEST API. The provider returned **HTTP 403 DISALLOWED_OPERATION**. A diagnostic retry after this explicit rejection returned the same code. No real TEST sub-account was successfully created or linked during verification, and the UI correctly remained Not Connected. Check **Account Write permission and xenPlatform enablement** with the Xendit account administrator before retrying. No credential was printed, changed or rotated.

Success mapping is covered by mocked real-shape provider responses. No TEST webhook delivery, production KYC or live payments were exercised. v2 account retrieval compatibility with v3-created accounts was not established in the official sources, so the configured adapter does not use it; uncertain attempts require investigation and cannot be silently retried.

See [provider implementation and official sources](../../services/api/docs/xendit-onboarding.md).

## Unrelated pre-existing Buyer failures

Buyer analysis passed with no issues. Buyer tests reproduced **43 passed / 12 failed**, involving welcome/onboarding RenderFlex overflow/interaction failures and missing golden evidence including docs/design/evidence/buyer-account-refinement/welcome.png. This matches the prior validation note. Buyer source is unchanged; the complete repository gate is therefore not green.

## Reproduction

Run npm.cmd run lint, npm.cmd run typecheck, npm.cmd run test -- --run and npm.cmd run build in each portal directory. In apps/vendor-web run npm.cmd run test:e2e -- --grep 'Xendit panel'. In packages/api-contract run npm.cmd run validate, npm.cmd run test:vendor-contract, npm.cmd run test:account-contract and npm.cmd --prefix generated/typescript run build. In generated/dart run dart run build_runner build and dart analyze --no-fatal-warnings.

The backend command is docker exec materyalph_phase1_test-api-test-1 sh -lc 'vendor/bin/pint --test && vendor/bin/phpstan analyse --memory-limit=512M --no-progress && php artisan test --compact'. Migration verification uses docker exec materyalph_phase1_test-api-test-1 php /workspace/scripts/verify-test-schema.php. Buyer equivalents are flutter analyze and flutter test; on this Windows machine the installed Dart executable invoked flutter_tools.snapshot directly.

Suggested commit: fix(vendor): provision Xendit TEST accounts directly

No push, merge, deployment, production access or credential rotation occurred.
