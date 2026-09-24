# Phase 3B — Business Information

Implemented Store Verification step 1 in Vendor web, with API and contract extensions over the Phase 3A requirement registry, drafts, evidence pipeline and authority model. The field and layout authority is `docs/workflows/MateryalPH_Store_Verification_Onboarding_Spec.md` (the repository copy of the requested Vendor Onboarding, Store Verification and Store Setup specification).

## Changes

- `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx` renders B1–B9, all five Business Types including distinct OPC, applicable identity and representative fields, independent legal and public Store names, Store contact information, tax fields and private evidence. Type changes refresh the server requirement preview before saving.
- `packages/web-ui/src/onboarding-flow.tsx`, `email-verification-panel.tsx` and `onboarding-fields.tsx` provide the reused flow, single-field email lifecycle, field rows, authority scopes and upload control. Email verification uses the existing request/confirm endpoints and refreshes the authoritative snapshot. Pending replacements never inherit verification; edits clear challenges and failures remain recoverable.
- `services/api/database/migrations/2026_09_22_000000_add_vendor_legal_business_name.php` adds and backfills `vendor_organizations.legal_business_name` without changing `store_name`, and adds `vendor_documents.superseded_at`. Its rollback removes only these additions. Applied migrations were not edited.
- `VendorOnboardingService`, `OnboardingRequirementResolver`, `VendorAuthorityService`, `StoreActivationGate` and `AdminVendorVerificationService` extend existing domain behavior. Business Type changes supersede affected evidence and reopen review; superseded evidence cannot satisfy submission, authority approval or activation. Previous document and representative versions remain available. The snapshot includes up to five recent versions per evidence item and the current representative's authority review.
- `VendorVerificationDraftRequest`, `VendorOnboardingController` and `routes/vendor-onboarding.php` add transport validation and the authenticated requirement preview. Existing draft and upload URLs remain unchanged.
- Component and browser tests are in `VendorNavigation.test.tsx` and `e2e/onboarding-steps.spec.ts`; API and migration coverage is in `PhaseThreeVendorOnboardingTest.php` and `OnboardingFoundationSchemaTest.php`.

## API and concurrency

OpenAPI adds `GET /api/v1/vendors/onboarding/requirements` for read-only applicability previews. The existing verification draft accepts `legal_business_name` and representative authority source, selected evidence version, document details and requested scopes. The canonical onboarding snapshot remains `GET /api/v1/vendor/onboarding`. TypeScript and Dart clients and Dart serializers were regenerated.

Every Vendor verification draft PATCH sends `lock_version` from the organization and `draft_lock_version` from the Store Verification draft, defaulting to zero before the first draft. Store Setup uses `organization_lock_version` plus its own `draft_lock_version`. Successful saves replace the snapshot and refresh both guards. `RESOURCE_VERSION_CONFLICT` and `STALE_VERSION` share one recoverable conflict state with a reload action. Legacy organization-only requests remain accepted by the backend; this client always supplies both guards.

## Security and domain decisions

Evidence continues through the existing private storage, content validation, size limit, fail-closed scan and authorized URL pipeline. Other Vendors and unauthorized staff cannot read it. Cloudinary remains limited to public media. No additional provider credentials or public evidence route were introduced.

Accepted registration evidence may support an officer's authority only when it is current, clean and owned by that Vendor. Employees, accountants and unestablished representatives need separate evidence; a sole proprietor acting personally resolves to Not Applicable with a reason. Source selection does not approve authority. Final attestation still requires the current Owner-linked representative and explicit Admin approval for the applicable scope. Immutable versions and executed agreement bindings are preserved. Existing transactions, encrypted change history, audit records and outbox notifications remain in use.

Core TIN accepts exactly nine numeric digits; Branch Code accepts three or five. Head Office prefills zeros; selecting Branch requires a code. Saved identifiers remain encrypted and masked on read. Declared VAT and verified VAT remain separate. A BIR COR upload does not verify the Tax Profile and may use Expiration: Not Applicable. A Sworn Declaration requires the explicit claim, taxable year and BIR-received PDF; the FIN-04A notice explains the PHP 500,000.01 threshold. This phase adds no remittance counter or automatic tax relief.

## Validation

Final results below were obtained on 22 September 2026. Package commands run from the corresponding directory. Laravel ran against the isolated PostgreSQL/PostGIS test container, including schema, migration rollback, authorization and failure-path tests.

| Command | Final result |
| --- | --- |
| Vendor `npm.cmd run lint` | Passed |
| Vendor `npm.cmd run typecheck` | Passed |
| Vendor `npm.cmd run test -- --run` | 9 files, 83 tests passed |
| Vendor `npm.cmd run build` | Passed; existing large-chunk advisory |
| Vendor `npm.cmd run test:e2e -- e2e/onboarding-steps.spec.ts` | 24 passed, 1.4 minutes |
| API `php vendor/bin/pint --test` | Passed |
| API `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | No errors |
| `docker exec materyalph_phase1_test-api-test-1 php artisan test --no-ansi` | 147 passed, 1,794 assertions, 89.37 seconds |
| Contract OpenAPI generator `validate -i openapi.yaml` | Valid; three existing unused-model recommendations |
| Contract `node scripts/check-vendor-onboarding-contract.mjs` | 28 operations passed |
| Contract `node scripts/check-account-contract.mjs` | 57 operations passed |
| Contract `node scripts/generate-clients.mjs` | TypeScript and Dart generation succeeded |
| Generated TypeScript `npm.cmd run build` | Passed |
| Generated Dart `dart run build_runner build` | Serializer generation succeeded |
| Generated Dart `dart analyze` | No issues |
| `docker compose config --quiet` | Passed |
| `gitleaks git --staged --redact --no-banner` | No leaks; no staged changes |
| `gitleaks stdin --redact --no-banner` on changed and new text files | No leaks |
| `git diff --check` | Passed |

The Windows Dart wrapper stalled; serializer generation and analysis succeeded using `C:/Users/RJ/Documents/flutter/bin/cache/dart-sdk/bin/dart.exe` directly. Docker commands used `C:/Users/RJ/AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe` because Docker was not on the shell PATH.

Browser checks cover 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px, conditional fields, email replacement and failures, tax validation, both draft guards and conflict states, evidence denial presentation, field geometry, stable email action widths and overflow. See [screenshot evidence](../../../docs/design/evidence/phase-3b-business-information/README.md).

## Setup and limits

Apply the additive migration through the normal local/release migration process (`php artisan migrate` in `services/api`) before using this code against an existing non-test database. No new environment keys are required; the existing private storage, scanner and mail configuration still applies. The working development database was not migrated by this task.

Browser evidence uses synthetic accounts and intercepted API responses. API tests exercise real application authorization with fake provider adapters. These checks do not establish live email delivery, live malware scanner connectivity or live object-storage connectivity. No deployment, commit, Admin web edit or Buyer mobile edit was performed. The pre-existing implementation-plan edit was preserved.

Suggested conventional commit: `feat(vendor): implement phase 3b business information`
