# Store Verification: pending files and explicit Admin submission

Implemented September 23–24, 2026. This refinement follows the user's current acceptance requirements while retaining the approved four verification steps, separate Store Setup, private evidence permissions and explicit Authority-to-Act approval.

## Behavior and changed areas

- `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx`: automatic partial progress saving on section changes, Finish Later and internal dashboard navigation; inline field errors; controlled pending selections; explicit package submission; sole-proprietor conditional fields; tax layout; correction reasons inside each document section.
- `packages/web-ui/src/onboarding-fields.tsx`, `field.tsx`, `email-verification-panel.tsx`, and `onboarding-flow.tsx`: shared selection/preview/remove component, field error context, restored unverified email drafts, and automatic-save guidance.
- `services/api/app/Domain/Vendors/VendorOnboardingService.php`: separate pending storage, removal, private reads, encrypted incomplete form state, atomic final form update/document promotion, version/audit preservation, and applicable completeness rules.
- `AdminVendorVerificationService.php`: Admin sees formally submitted documents and cannot decide an unsubmitted requirement.
- The upload/draft/submit Form Requests and `EvidenceContentValidator.php` align multipart parsing, conditional validation, supported extensions, detected content, declared MIME, size limits and fail-closed security scanning.
- Additive migration `2026_09_23_000004_add_pending_vendor_documents.php` adds `vendor_pending_documents` and `vendor_documents.review_submitted`. It recovers previously unsubmitted files into private pending state while retaining existing immutable historical rows. The development migration status was verified as **Ran**, batch 8. Empty-schema and database-backed tests also pass in the isolated Docker database.
- OpenAPI adds pending-file removal, encrypted form progress and an optional nested final draft on submit; upload responses use `PENDING_SUBMISSION` and version 0. TypeScript/Dart clients and Dart serializers were regenerated. The generator fixes nested Dart builders and avoids rewriting unchanged files on Windows.
- `infrastructure/docker/uploads.ini`, the API Dockerfile and README align the advertised 10 MB file limit with PHP: `upload_max_filesize=10M`, `post_max_size=12M`. The local image was rebuilt and its limits verified.

A local selection creates no review record. Automatic saving may technically upload it to private pending storage, still inaccessible to Admin. Removing an unsaved selection is local; removing a saved pending selection deletes its pending association and unreferenced private file. Submitted historical versions are retained. Final submission commits the latest validated form information and document versions together; failure rolls back official changes while keeping pending progress.

The existing organizational attestation rule remains: current Owner-linked Authority to Act must be approved for TAX_DECLARATIONS. The pending-review screen exposes **Confirm tax declaration** when eligible, allowing the existing final attestation without editing or resubmitting approved evidence.

## Root-cause checks

The generated multipart client retains the actual File under `file` and lets the browser set the multipart boundary. JSON metadata blobs are normalized without losing Laravel's converted file state. Pending selections live in the parent form, surviving document panel changes and failed requests. Upload requirement identifiers include all identity sides and evidence types, including selections made before a new Business Type has been canonically submitted. The configured native PHP limit was also smaller than the advertised limit; that independent runtime mismatch is corrected. These findings do not imply that a 0.33 MB screenshot file exceeded a size limit.

Tax comparison now uses stored business values rather than serialized JSON key order; PostgreSQL JSONB reordering no longer causes unchanged tax data to reopen evidence review.

Errors are returned as field details/blockers and mapped beside the affected field or document. Local and backend validation do not inspect names, ID authenticity, expiry, ownership, or document meaning. Admin makes those decisions. File signatures, decodability, active PDF content and malware checks are technical security validation.

## Regression coverage

| Requested cases | Evidence |
| --- | --- |
| 1–10: missing file, JPG/JPEG/PNG/PDF, extension/MIME/signature mismatch, size, scanner failure | `EvidenceContentValidatorTest`, `VendorDocumentUploadRequestTest`, API document transport/scanner tests; real file bytes with fake scanner/provider adapters |
| 11–13: selected/replaced/removed before submission | pending-file API test, controlled upload component tests, responsive browser selection/replacement/removal test |
| 14–17: Finish Later, dashboard, reopening, no manual save prerequisite | Vendor navigation tests for incomplete progress, draft email restoration, both exit actions and direct final submission |
| 18–22: successful/failed/multiple-file submission, inline errors, in-review transition | API multi-file promotion and rollback tests; frontend final submission and multiple inline error tests; generated multipart transport test |
| 23–28: approval, correction reason, replacement, resubmission, history | API per-requirement decision/replacement tests preserve approved BIR and previous LGU versions; frontend correction reason and locked approved document test |
| 29–35: conditional applicability, NOT_APPLICABLE, Sole Proprietorship and type changes | requirement resolver/API tests, five Business Type component cases, browser conditional identity checks; backend sole-proprietor hidden-name validation test |
| 36–40: long filenames, image/PDF representation, desktop/tablet/mobile layout | browser tests at 320, 768 and 1440 px; bounded image preview, long-name wrapping, no horizontal overflow and stable desktop tax columns |
| 41–43: navigation/reopening, naming/transport alignment, failed upload preserves progress | saved-draft restoration and API tests, contract route checks, generated multipart test, failed-upload/retry component test |

Unsaved local selections warn on a browser refresh; persisted drafts and pending files are returned when reopening. A user who deliberately discards unsaved changes can still lose a local-only selection. Browser checks use synthetic accounts and intercepted API responses; they are not a live Vendor-to-Admin/provider integration session.

## Validation results

- API full suite via isolated Docker `api` service: **169 passed, 1,997 assertions**. The attestation regression verifies no new tax/document version or review transition is created for unchanged values.
- Vendor component suite: **104 passed**.
- Admin component suite: **16 passed**.
- Responsive Playwright checks: **18 passed** at 320, 768 and 1440 px.
- Vendor/Admin lint, TypeScript checks and production builds passed. Vendor build retains the existing large-chunk advisory.
- Pint passed; PHPStan reports no errors.
- OpenAPI validation passed with three unused-model recommendations; Vendor contract checks cover **32 operations**, account checks **57 operations**.
- TypeScript client build, Dart serialization generation and generated Dart analysis passed. Flutter analysis passed.
- Buyer mobile tests: **43 passed, 12 failed** in Buyer welcome/onboarding/layout/app expectations outside Store Verification. No Buyer UI changes were made for this refinement. See `.tmp-verification-flutter-tests.txt`.
- Compose configuration and `git diff --check` passed. Gitleaks found no leaks in the staged set (empty) or changed/new source text scan.

Database tests use PostgreSQL in Docker, not host-side resolution of `postgres-test`. The test command used `docker compose --env-file services/api/.env.testing -f compose.test.yaml -f .tmp-verification-compose.yaml -p materyalph_phase1_test run --rm api php artisan test --compact`; the temporary override aliases the existing isolated `api-test` service as `api`.

No new secret/environment key is required. Existing private storage, scanner, map and email configuration remains necessary. Live malware scanner, email, map and object-storage connectivity were not proven by fake-adapter tests. No deployment, push or commit was performed; unrelated existing workspace edits and the Navigation Sidebar were preserved.

## Research references

- [GOV.UK file upload component](https://design-system.service.gov.uk/components/file-upload/): clear upload controls, file guidance and field-associated errors.
- [GOV.UK error message component](https://design-system.service.gov.uk/components/error-message/): concise errors next to the field requiring correction.
- [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html): extension/content checks, size limits, private storage and malware scanning.

Suggested commit: `fix(vendor): simplify verification submission and pending evidence`
