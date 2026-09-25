# Phase 3A domain foundation

Implemented and verified on 22 September 2026. Scope: `services/api` and `packages/api-contract`. Existing unrelated working-tree changes were preserved. No application files were edited by this task. No deployment, commit, or non-test database migration was performed.

## Domain and schema

The new migration is `database/migrations/2026_09_21_010000_complete_onboarding_domain_foundation.php`. It builds on the existing Phase 3 schema and the pre-existing `2026_09_21_000000_enhance_store_verification.php`; neither earlier migration was rewritten by this task.

- Canonical requirement, document, document-version, and encrypted verification-history tables retain existing IDs and foreign keys. Writable compatibility views preserve the former table names.
- Requirements keep level and status independent. PostgreSQL rejects `NOT_APPLICABLE` for required or optional items and rejects missing or blank applicability reasons. `OnboardingRequirementResolver` derives applicability and dependency fingerprints from Business Type, representative, supplier classification, fulfillment, and declaration inputs. Changed dependencies reopen affected requirements.
- `OnboardingDrafts` stores encrypted, merged workstream drafts with optimistic versions. Legacy clients retain their required organization-version guard; clients can additionally supply `draft_lock_version` (zero on first save).
- Evidence versions retain checksum, MIME, size, validation and scan state, and immutable predecessor links. `vendor_document_supersessions` derives the forward chain. Database triggers reject mutation, cross-document pointers, and invalid predecessors or file ownership.
- Representative and authority histories remain immutable. Authority scopes are limited to `TAX_DECLARATIONS`, `COMMISSION_AGREEMENT`, and `PAYMENT_CONFIGURATION`; account membership alone grants no signatory authority.
- Tax profiles retain separate declared and verified VAT, encrypted TIN, encrypted branch code, declaration claim/year, and representative references. A declaration does not confer permanent withholding relief or implement the later FIN-04A assessment engine.
- Structured Philippine addresses have immutable versions and a separate `geography(Point,4326)` column with a GiST index. Existing addresses are backfilled without changing their IDs.
- Privacy acknowledgments are stored independently of commercial acceptances. Activation history includes the rule version; historical rows retain the earlier rule label.

`StoreActivationGate` is the sole activation eligibility evaluator. It returns numbered blockers for the ten Final Vendor Workflow conditions, checks real submission evidence, current notice/agreements, approved mandatory requirements, current validated and clean evidence, authority, reviewed tax, setup/delivery, Xendit capability, and restrictions. Product listings, inventory and optional Team Accounts do not gate activation. Activation requests that fail retain audit and activation-history records even though the response is HTTP 409. Successful activation and existing correction/restriction flows use the transactional notification outbox.

## API and security

`GET /api/v1/vendor/onboarding` returns the authoritative snapshot. The existing plural route remains available. The snapshot includes both workstreams, the requirement registry and reasons, four verification/six setup step completion indicators, readiness and numbered blockers, the current Privacy Notice, masked private identifiers, current document versions, draft versions, and organization `lock_version`.

Changed implementation files are the new resolver, draft service, activation gate, content validator, and `Policies/VendorEvidencePolicy.php`; integration changes are in `VendorOnboardingService`, `VendorAuthorityService`, `AdminVendorVerificationService`, the two Vendor draft requests, `routes/vendor-onboarding.php`, `config/materyalph.php`, and `.env.example`. Tests are in `PhaseThreeVendorOnboardingTest`, `OnboardingFoundationSchemaTest`, and `OnboardingRequirementResolverTest`.

Private evidence uses the configured private disk. Public disks and public local directories are rejected. Uploads validate bytes, MIME and size, then scan before taking organization locks. Scanner errors reject uploads. Evidence reads require authentication, current account/membership authorization, clean validated evidence, and a five-minute signed URL; responses disable caching and MIME sniffing. The policy denies other Vendors, unauthorized Vendor staff, and unauthorized Admin roles. Cloudinary remains a separate adapter for public Store media only. Provider/storage calls occur outside organization mutation locks.

OpenAPI and its contract checker were updated. TypeScript and Dart clients were regenerated. Fixes for Dart generator warnings live in `scripts/generate-clients.mjs`, not hand-edited generated files.

## Validation

Cloudinary public-media uploads explicitly send `asset_folder` from `CLOUDINARY_ASSET_FOLDER` (default `marketplace`). In dynamic folder mode the public ID path does not select the asset folder. Grant the application key Contributor access to that destination using `cld::role::folder::contributor`; administrator credentials are only for provisioning and are not used by the upload adapter. Keep private verification evidence on its private disk. A successful standalone provider probe must be followed by a test of the actual application adapter.

Commands below were run from their relevant package, or from the repository root for Docker/Git. All final commands exited 0.

| Command | Final result |
| --- | --- |
| `php vendor/bin/pint --test` | Passed |
| `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | No errors |
| `docker exec materyalph_phase1_test-api-test-1 php artisan test --no-ansi` | 142 tests, 1,727 assertions passed; 70.92 seconds |
| `node node_modules/@openapitools/openapi-generator-cli/main.js validate -i openapi.yaml` | Valid; three existing unused-model recommendations |
| `node scripts/check-vendor-onboarding-contract.mjs` | 27 operations passed |
| `node scripts/check-account-contract.mjs` | 57 operations passed |
| `node scripts/generate-clients.mjs` | TypeScript and Dart generation succeeded |
| `npm.cmd run build` in `generated/typescript` | Both TypeScript builds passed |
| `dart run build_runner build` in `generated/dart` | Serializer generation succeeded |
| `dart analyze` in `generated/dart` | No issues |
| `docker compose config --quiet` | Passed |
| `docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test config --quiet` | Passed |
| `gitleaks git --staged --redact --no-banner` | No leaks; no staged changes |
| `gitleaks stdin --redact --no-banner` on the API/contract diff and non-ignored new source files | No leaks |
| `git diff --check` | Passed |

Migration coverage runs on the guarded, dedicated PostgreSQL 16/PostGIS test database: empty-schema installation, full rollback/reinstall, and populated-schema upgrade/rollback preserving IDs, encrypted tax values and address versions. The suite also covers all five Business Types, invalid applicability, individual activation conditions and mandatory requirements, pending/failed evidence, immutable versions, stale drafts, public-disk rejection, cross-Vendor/staff access, signed-URL expiry, and scanner/provider failures.

## Setup and limits

- Apply the new migration through the normal reviewed deployment process. Only the isolated test database was migrated here.
- `VENDOR_PRIVATE_DISK` defaults to `local`; choose a configured private disk for the target environment. `VENDOR_DOCUMENT_MAX_KB` and `VENDOR_MEDIA_MAX_KB` retain their existing limits.
- The runtime needs `clamscan` with current signatures. Missing scanning or signatures older than seven days fail closed. Automated API tests use scanner/provider fakes and failure injection; they do not certify live provider credentials.
- Public Cloudinary media uses `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, and `CLOUDINARY_API_SECRET` in ignored server configuration. No credential values were introduced.
- Retained legacy document versions are marked content `UNVERIFIED`; they cannot silently inherit content validation from an older approval. Replacement uploads create validated immutable versions and reopen review.
- UI changes, the FIN-04A remittance accumulator, and live payment capability remain outside Phase 3A. Xendit eligibility remains TEST/DEMO only.

Suggested conventional commit: `feat(api): establish vendor onboarding domain foundation`
