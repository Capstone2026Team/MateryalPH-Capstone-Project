# Vendor onboarding review and usability fixes — 9 November 2026

## Scope and decisions

Reviewed the existing journey from Owner registration and email verification through welcome, Store Verification, Store Setup, Admin decisions, activation and dashboard access. The Vendor/System/Admin workflows, architecture, UI planner, migrations, route middleware, OpenAPI, persistence services and existing tests were inspected before implementation.

The existing two-workstream architecture remains. Registration collects the Owner account once; legal identity, business contacts, tax information and evidence retain their separate purposes. The required Business Types, conditional representative authority, consent, manual review, delivery eligibility and TEST payment connection remain mandatory where applicable. There is no new role, status, payment rule or activation requirement.

## Findings and changes

| Area | Finding | Applied change |
| --- | --- | --- |
| Welcome | A failed Continue request opened a blocking browser alert; the setup description placed Commission Terms in the wrong workstream. | Inline retryable error, correct setup description, retained welcome acknowledgement. |
| Verification continuation | An unfinished draft could exit only to the dashboard; the workflow permits continuing directly to Setup. | Continue later to Store Setup saves first. Finish Later still returns to the limited dashboard. Neither action submits evidence. |
| Navigation | Page-local click interception missed browser Back/Forward and programmatic navigation, and reconstructed destinations without their URL fragments. | Use the existing React Router data-router support and a shared save-before-leave hook. Links and history navigation wait for the same in-flight draft save. Failures retain inputs and cancel navigation. Hash destinations remain intact. |
| Session recovery | Saving while redirecting after expired authentication could trap a Vendor on protected onboarding. | Login/session-expiry navigation clears the protected form without trying another authenticated write. |
| Draft feedback | Verification saving had no clear saved confirmation; failed uploads could automatically retry as the dirty form remained mounted. | Clear saved-draft feedback and explicit Retry save. Failed uploads stop automatic retries and retain their local selection. |
| Resume | Both workstreams normally restarted at their first screen. | Open an actionable correction first, then the first unfinished saved requirement. Saved completion remains independent from Admin approval. Explicit requirement links retain priority. |
| Setup sequence | A separate optional Team Accounts screen repeated the existing fulfillment staff guidance. | Five visible screens; conditional staff guidance and the existing Team module link remain in Fulfillment Configuration. Legacy S4 links open that section; S5/S6 retain their original destinations. |
| Incomplete profile drafts | Clearing a public name returned a string validation error and blocked saving other fields. A blank persisted name could then be repopulated from an older name. | Empty/null names save as blank in the draft, preserve other fields and resume blank. A profile that does not exist still prefills the saved business name. Completion and activation still require a nonblank name. |
| Submission concurrency | Two submission events could enter the final action while awaiting the same autosave. | Synchronous submission/completion guards prevent duplicate final requests. Existing server idempotency, organization locks and version checks remain authoritative. |
| Submission replay | Replaying an already successful request revalidated its temporary map token and failed after token expiry. | Check the completed idempotency record before address-token validation. Keep the second check inside the transaction for concurrent first submissions. Changed requests still conflict. |
| Review status | Pending review required a page reload to see a later Admin decision. | Revalidate the pending confirmation while it is being viewed; correction/approval copy explains the next action. Editing is not background-refreshed. |
| Validation consistency | Several client length constraints did not mirror the existing request limits. | Align public/legal names and store description with the API limits while retaining permissive draft saving. |

The two backend defects above were reproduced by failing feature tests before their fixes: expired map replay returned 422 instead of 202, and clearing an unfinished name returned 422 instead of saving the draft.

## Final journey

1. Register the individual Vendor Owner account, accept the required registration agreements and verify the account email; sign in using the existing authentication controls.
2. Read Welcome once and Continue to Store Verification.
3. Supply Business Information and applicable evidence, Registered Business Address, Supplier Classification, and Privacy/Review/Submit. Incomplete drafts may continue directly to Setup or Finish Later to the limited dashboard.
4. Submit the complete verification package for manual Admin review. Pending review is explicit; it does not activate the store. Corrections retain the reasons and historical evidence.
5. Complete Store Setup: Public Store Profile → Fulfillment Configuration → Xendit TEST Connection → Store Operation → Review and Complete. Conditional delivery requirements remain beside their configuration; Self-Pickup does not require staff or vehicles.
6. While review is pending, use the limited dashboard and resume either workstream. After approval and setup completion, review the server-reported remaining agreements or blockers and request Store Activation when ready.
7. Successful activation opens the existing role-authorized dashboard. Marketplace discoverability remains a separate listing/inventory/compliance/serviceability gate.

## Persistence, authorization and contract

- Existing organization/workstream draft records are reused; their unique organization/workstream constraint and optimistic versions are retained. Verification drafts remain encrypted, private identifiers remain masked on read, and no draft or token is stored in browser localStorage.
- Pending files remain private and replaceable before submission. Final promotion, completeness checks, privacy acknowledgement, review status, idempotency claim, audit and notification records remain transactional. Existing submitted evidence and decision history are retained.
- Cookie authentication, CSRF, organization scope, Owner-only submission/completion, staff permissions, scanner/content checks, signed private-file access and current representative-authority checks are unchanged.
- No new migration, table, endpoint, environment key, provider account, secret or manual database operation is needed.
- `VendorSetupDraft.public_store_name` now explicitly accepts empty/null draft values. The verification-submit operation documents completed-request replay before transient map-token validation. TypeScript and Dart clients were regenerated from OpenAPI; generated files were not edited by hand.

## Main files

- Vendor flow and navigation: `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx`, `src/lib/onboarding-steps.ts`, `src/components/OnboardingNavigationGuard.tsx`, `src/App.tsx`, `src/main.tsx`.
- Shared behavior: `packages/web-ui/src/draft-navigation.ts`, `src/onboarding-flow.tsx`, `src/index.ts`.
- Backend: `services/api/app/Domain/Vendors/VendorOnboardingService.php`, `app/Http/Requests/Vendor/VendorSetupDraftRequest.php`.
- Contract: `packages/api-contract/openapi.yaml`, generated Vendor onboarding APIs / VendorSetupDraft models and documentation, `scripts/check-vendor-onboarding-contract.mjs`.
- Regression coverage: Vendor navigation/auth/codec tests, `apps/vendor-web/e2e/onboarding-steps.spec.ts`, `services/api/tests/Feature/Api/PhaseThreeVendorOnboardingTest.php`.
- The Vendor workflow and UI planner record the simplified presentation. Unrelated pre-existing workspace edits were preserved.

## Validation

| Check | Result |
| --- | --- |
| Guarded isolated Docker test setup | Static/live isolation checks passed. Development data was not used. |
| `php artisan test --compact --filter='PhaseThreeVendorOnboardingTest\|PhaseOneAuthAcceptanceTest\|AuthTransportSecurityTest\|OnboardingFoundationSchemaTest\|VerificationDraftProgressTest\|OnboardingRequirementResolverTest'` in `api-test` | 122 passed, 1,662 assertions. Covers registration, drafts, validation, replay, permissions, reviews/corrections, immutable evidence and activation. |
| Focused Vendor tests: navigation, App, auth support, progress codecs and upload transport | 149 passed across 5 files. |
| Full Vendor component suite: `npm.cmd run test -- --run --maxWorkers=2 --testTimeout=30000` | 953 passed across 99 files. |
| Full Admin component suite: `npm.cmd run test -- --run --maxWorkers=2 --testTimeout=30000` | 398 passed across 53 files. |
| Playwright onboarding at 320, 768 and 1440 px | All 33 cases passed, including real browser Back/Forward, failed-save recovery and reload/resume with synthetic API fixtures. The initial run passed all cases but stalled during preview teardown and was interrupted. A second run finished with 32 passed and one 30-second mobile timeout; that case passed in isolation with `--timeout=60000` (15.4 seconds for the test, command exit 0). |
| Vendor/Admin lint, typecheck and production builds | Passed. Builds retain the existing large-chunk advisory. |
| `vendor/bin/pint --test` | 914 files passed. |
| `vendor/bin/phpstan analyse --memory-limit=512M` | 609 files; no errors. |
| OpenAPI validation and `test:vendor-contract` | Passed; 35 Vendor/Admin operations match Laravel routes. Validation reports 8 unused-model recommendations. |
| Generated TypeScript client build | Passed. |
| Generated Dart serialization / analysis | Serialization generation passed (4 outputs); the onboarding progress codec contract passed. Focused analysis of the changed API/model/serializer found no issues. Full `dart analyze lib` exited 1 with 2 `unused_element_parameter` warnings in `directory_review_ratings_value.dart` and `geo_demand_cell_value.dart`; both warning sources were verified unchanged from HEAD. |
| Whitespace and secret checks | `git diff --check` passed. Gitleaks found no leaks in changed source, the new shared/navigation files and this review documentation; the staged scan was empty/clean. Docker Compose configuration validation also passed without printing environment values. |

The first unrestricted full portal runs encountered Vite-startup timeouts and a Catalog readiness assertion under concurrent load. Each affected check passed in isolation. One existing onboarding expectation was updated to distinguish a profile that does not exist from a deliberately saved blank name. The final focused onboarding run and both full portal reruns passed. The JSDOM external-navigation diagnostic and existing Vite transform advisories remain non-failing test output.

Browser fixtures prove presentation and browser behavior; Laravel tests prove database/domain behavior with fake provider adapters. No live end-to-end email, Google Maps, private storage/scanner or Xendit provider acceptance session was performed. A deliberately discarded unsaved browser refresh can still lose local-only input; before-unload protection warns while changes are unsaved.

Buyer UI and Buyer-specific test suites were outside this change; regenerated Dart onboarding files and codecs were checked as described above. The full generated Dart analysis is not a clean gate because of the two unchanged warnings. No live provider acceptance or deployment was performed.

No deployment, push, merge or commit was performed. Suggested commit: `fix(vendor): simplify onboarding and preserve draft navigation`.
