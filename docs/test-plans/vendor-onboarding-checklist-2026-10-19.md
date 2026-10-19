# Vendor onboarding checklist repair

Saved verification form details previously stayed outside the submitted records that drove checklist completion. A filled draft could therefore show Not started. The limited dashboard also repeated the same activation blockers in a separate panel.

## Changes

- `services/api/app/Domain/Vendors/VerificationDraftProgress.php` derives saved form/evidence completion with the existing request field validators, conditional requirement resolver, verified-email state, clean pending/current submitted evidence and organization-bound map tokens. It does not write review decisions or activation readiness.
- `VendorOnboardingService.php` returns `progress_status` and the existing required step ID, reports saved verification work as In progress, preserves review `status`, binds saved privacy progress to the current notice version, and rejects setup completion with an unfinished schedule draft.
- `OnboardingRequirementResolver.php` keeps an unfinished preactivation schedule draft In progress while preserving an active store's effective saved hours.
- Shared `verification-checklist.tsx`, `onboarding-flow.tsx` and `onboarding-review.tsx` count saved completion and display Ready to submit separately from Admin decisions. Vendor address, classification, commission and privacy entries no longer hide inside Business information. Admin review grouping is preserved.
- `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx` removes the duplicate activation-requirements panel and repeated checklist counts, uses the existing save operation for debounced verification saves, protects newer edits from delayed saves, restores version-bound privacy progress and retains unfinished setup hours after reopening.
- `VendorBusinessAddress.tsx` notifies the existing save flow when asynchronous map results finish.
- `packages/api-contract/openapi.yaml` adds optional `VendorOnboardingStep.progress_status`; TypeScript/Dart clients and Dart serializers are regenerated. Contract/codec regressions cover independent progress and review states and older snapshots.

No migration, credential or environment-key change is required. Existing authorization, private evidence, explicit submission, immutable review history and activation gates remain authoritative. No development database records were edited for this fix.

## Regression coverage

- Business information and manual address drafts show completion after save and reload without submission or approval.
- Invalid/future dates, malformed TIN/address fields, unverified replacement email and invalid map tokens remain incomplete.
- Conditional identity/declaration evidence follows the current saved choices; removing pending evidence reverses completion.
- Representative details require supplied authority evidence or a current registration-evidence reference.
- A saved privacy checkbox applies only to its notice version and remains associated with the form even when rendered in the review section.
- Setup cannot reuse old complete hours when its current draft schedule is unfinished. The draft survives unrelated saves after reopening.
- Dashboard retains the two checklists and the server-gated activation action without the raw duplicate blocker list.

## Manual acceptance

Refresh the Vendor portal, reopen existing verification/setup drafts and confirm the checklist and step indicators reflect saved details. Check Finish Later/resume, map/manual address editing, pending-file removal, correction/resubmission, and final setup completion. Browser/device/live-provider acceptance was not performed in this change.

The complete Vendor unit/component run reported six failures in unchanged `OrderPages.test.tsx` (order-document navigation and order-confirmation expectations), with 588 tests passing. These are outside this onboarding repair. Focused onboarding/address/progress tests are reported separately.

## Executed checks

| Check | Result |
| --- | --- |
| Isolated `php artisan test --compact --filter=PhaseThreeVendorOnboardingTest --no-ansi` | 95 passed, 1,339 assertions. Test environment isolation guards passed. |
| `php vendor/bin/phpunit tests/Unit/VerificationDraftProgressTest.php tests/Unit/OnboardingRequirementResolverTest.php tests/Unit/StoreOperatingScheduleTest.php --no-progress` | 8 passed, 117 assertions. |
| API `php vendor/bin/pint --test` and `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | Passed; no PHPStan errors. |
| Vendor `npm run test -- --run src/lib/onboarding-progress.test.ts src/pages/VendorNavigation.test.tsx src/components/VendorBusinessAddress.test.tsx --maxWorkers=1` | 102 passed. |
| Vendor full `npm run test -- --run --maxWorkers=1` | 588 passed, 6 failed in unchanged order tests. |
| Admin full `npm run test -- --run --maxWorkers=1` | 135 passed across 25 files. |
| Vendor and Admin `npm run lint`, `npm run typecheck`, `npm run build` | Passed. Vite reports large-bundle advisories. |
| API contract `npm run validate` and `npm run test:vendor-contract` | Passed; 35 route operations checked. OpenAPI reports eight unused-model recommendations. |
| Generated TypeScript `npm run build` | Passed. |
| Generated Dart `dart run build_runner build`; model/serializer `dart analyze` | Passed; no model/serializer analysis issues. |
| API contract `dart run scripts/check-onboarding-progress.dart` | Passed, including the optional-field/older-snapshot case. |
| `docker compose config --quiet`, changed-source whitespace check, scoped `gitleaks stdin --redact --no-banner` | Passed; no leaks found in 2.32 MB of relevant source. |

Dart checks used the installed SDK executable directly with a temporary writable analytics directory and access to its existing package cache. No SDK, credentials or production configuration was changed. No Git commands were used.

Suggested commit: `fix(vendor): synchronize onboarding checklists and validation`.

## Follow-up: completed address and commission acceptance

The saved map address matched every token value but failed because JSON key order differed. Progress now compares sorted fields with strict values, organization binding and expiry intact. The progress calculation no longer requires the internal TEST taxpayer key, which the persistence service derives rather than collecting from the Vendor.

Commission eligibility now recognizes the saved Business Type. Explicit acceptance applies that selection through the existing versioned domain save before recording consent. Owner permission, current agreement version, idempotency, audit and required representative approval remain enforced. No API schema or migration changed.

Read-only diagnosis confirmed the existing address is complete. The existing private TIN fails the required format, so its tax requirement correctly remains In progress. The API now returns a safe explanation through the existing step `reason`, and the Vendor form displays it beside the masked TIN input. No private tax value or saved business data was changed during diagnosis.

Changed files: `VerificationDraftProgress.php`, `VendorOnboardingService.php`, `PhaseThreeVendorPages.tsx`, their three regression-test files and this report. Follow-up checks passed: 7 focused API tests/79 assertions, 7 progress unit tests/27 assertions, 1 focused component regression (90 other cases skipped), Pint, PHPStan, Vendor lint/typecheck/build, scoped secret scan and whitespace checks. Browser acceptance was not run. Suggested follow-up commit: `fix(vendor): validate saved onboarding progress and commission eligibility`.
