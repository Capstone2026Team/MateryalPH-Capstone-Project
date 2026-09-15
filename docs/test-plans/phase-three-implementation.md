# Phase 3 implementation — acceptance pending

Status: **NOT READY**. Continue this working tree; do not restart implementation or repository recovery.

## Preserved checkpoint

- Branch: `phase-3-vendor-onboarding`.
- HEAD: `2e0a4e1b1bcce62752a3cc0a430fd697a7297326`.
- Recovery stashes: `87959ddf85b678542ae7f0f1f179ed1cbf2b3e66`, `a1ad68f0b7a03658a2960497ce7b73e5add850c1`; untouched.
- No commit, push, merge, branch switch, deployment, development migration/reset, volume deletion or development Passport-key replacement.
- User's 14 September handoff designates Cloudinary for public store media and actual Xendit TEST xenPlatform account creation. It supersedes the earlier simulation-only provider direction. Private documents stay on S3/MinIO.

## Implemented working scope

Vendor business drafts/submission, contacts/address/classification, immutable submission snapshots, private document versions and authorized expiring downloads, scoped Admin evidence/business/tax review, Owner tax attestation and Manager correction drafts, versioned 2% commission agreement integration, store hours/fulfillment and reviewed media, activation/restriction/restoration, expiry reminders, fixed-role team invitations/revocation/role/delegation changes, session revocation, audit and outbox notices are wired through domain services and API routes.

Vendor `/dashboard` is now the authenticated landing surface and presents limited capabilities until Store Activation. Vendor `/onboarding` is explicitly divided into Store Verification and Store Setup; Admin `/vendor-verification` is divided into queue, Store Verification, Store Setup, and Activation. Requirement Level and Status are displayed separately, all five Business Types are supported, Store Email verification and conditional delivery configuration are represented, Finish Later returns to the limited Dashboard, and generated clients carry the revised contract. Optional team accounts do not block activation. Product listing is not an activation prerequisite; listing, inventory, serviceability, and product compliance control the separate Marketplace Discoverability state.

`PublicMediaProvider` binds to `CloudinaryPublicMedia`: backend upload, authenticated delivery for pending media, backend-authorized previews. Private legal/tax files stay S3. Earlier S3 store-media drafts require re-upload. Credential values were not printed; only presence was checked. All four backend Cloudinary/Xendit variables were present.

`XenditTestConnection` uses `/v3/accounts`; `CreateXenditTestAccount` commits an attempt before the external call and prevents duplicate creation. Provider `LIVE` is separate from TEST environment and UI displays `Xendit TEST Connected`. The real TEST adapter preserves and truthfully reports provider entity limitations without mutating a Vendor's legal Business Type; the approved explicit simulated TEST/DEMO adapter supports capstone onboarding fixtures for all five Business Types and never represents simulation as provider or LIVE evidence. Timeout/uncertain outcomes require reconciliation; no automatic creation retry. No split payments, collections, transfers, payouts or Phase 11 orchestration. No real Cloudinary or Xendit mutation was performed by this verification run. Tests use fake adapters/HTTP and block stray requests.

## Migrations

1. `2026_09_13_000000_extend_vendor_onboarding.php`: isolated upgrade, rollback/reapply, fresh/rollback/remigrate and schema-doc consistency passed. Fixed NULL rejection-reason check and reusable immutable function after fresh rebuild.
2. `2026_09_13_000001_add_vendor_public_media_review.php`: isolated apply passed; included in successful fresh/rollback/reapply verification.
3. `2026_09_14_000000_add_vendor_provider_state.php`: isolated apply passed; included in successful fresh/rollback/reapply verification.
4. `2026_09_14_000001_record_vendor_regulatory_applicability.php`: isolated apply passed. Latest regulatory changes passed the focused and full backend suites. Fresh migration, rollback/reapply and regenerated schema-document consistency passed in both isolated environments.
5. `2026_09_15_000000_synchronize_revised_vendor_onboarding.php`: additive corrective migration for separate Store Verification, Store Setup, Store Activation, and Marketplace Discoverability state; requirement level/status metadata; all five Business Types; Store Email verification metadata; contact communication designations; payment/refund configuration; onboarding-document relationships; and conditional delivery vehicle configuration. Final isolated fresh/rollback/reapply verification is pending because Docker/test PostgreSQL is unavailable in the current local tool session.

Regulatory approval now requires an Admin applicability decision with its source/basis. Required regulatory evidence becomes a mandatory checklist item; editing business information invalidates that decision. This closes an identified missing conditional-evidence gate without inventing a legal requirement or implementing Phase 4 compliance.

## Exact completed evidence and its limits

- Full isolated backend suite before latest regulatory edits: **105 passed, 1,271 assertions**, 51.44 seconds. Includes 17 onboarding tests and 2 Cloudinary adapter tests.
- Earlier focused onboarding: **15 passed, 154 assertions**. Additional Xendit adapter tests: **2 passed, 16 assertions**. Latest regulatory test is added but unrun.
- Pint: **210 files passed** before latest regulatory edits.
- PHPStan: **No errors** with `--memory-limit=512M`, before latest regulatory edits. Initial 128 MB run exhausted memory; fixed one redundant nullsafe access and reran successfully.
- Vendor: typecheck/lint/build passed; **37 tests passed / 7 files**. Build warns about a 505 kB chunk.
- Admin: typecheck/lint/build passed; **8 tests passed / 3 files**.
- After latest regulatory UI/client changes: Vendor/Admin typecheck passed; focused UI tests **3 Vendor + 1 Admin passed**. Full builds have not been repeated after these edits.
- Buyer: `flutter analyze` no issues; **31 tests passed**, before final regulatory contract regeneration. Existing Android-manifest working changes were not reverted.
- OpenAPI: validation passed (3 pre-existing unused-model recommendations). **37 Phase 3 operations** and **52 Phase 2 account operations** matched Laravel route/guard checks. The latest Phase 3 contract check passed using the earlier route export; route set unchanged.
- Generated TypeScript build passed after latest regeneration.
- Corrected Phase 3 nullable schemas to OpenAPI 3.1 unions. Dart generation/analyze and **2 actual nullable-response deserialization tests passed**. Final regeneration added VendorBusinessReview afterward: build_runner/analyze/deserialization must be rerun for the final output. Do not hand-edit generated files.
- `git -c core.safecrlf=false diff --check`: passed after latest edits (tracked diff only).
- `gitleaks git --staged`: no leaks, but 0 staged bytes. Clean-source snapshot scan: **8.64 MB, no leaks**, before latest regulatory/nullability edits. Final candidate scan remains required.

## Clean-start result

The verifier initially failed because its pre-migration identity check called `postgis_version()` before migrations installed the extension. `scripts/verify-clean-start.ps1` now checks the available extension version before migration. No development schema was changed.

The earlier isolated clean snapshot passed schema, SMTP, static analysis, backend (105 tests) and generated-client drift checks. Its evidence predates the latest changes.

This snapshot **predates the nullable-contract and regulatory changes**. It is not final-candidate acceptance. Do not use ResumeClone against changed candidate files or claim this as a final PASS. Clean project was left running with `-KeepRunning`; no volumes deleted.

## Latest verification — 14 September

Execution is available again. Focused onboarding: **18 passed / 177 assertions**. Final isolated clean-snapshot backend: **106 passed / 1,278 assertions**, 48.53 seconds. Pint: **211 files passed**. PHPStan: **No errors**. All four migrations passed fresh, rollback/reapply and schema-doc consistency.

Final Dart serializers were regenerated; analysis found no issues and both nullable deserialization tests passed. Both portal builds passed after the latest changes (Vendor bundle warning: 507.43 kB). Buyer analysis found no issues and all **31 tests passed**. Contract checks passed for **37 Phase 3** and **52 account** operations. Existing Vendor 37/Admin 8 test evidence and latest focused 3/1 UI checks remain applicable.

Final clean-start **passed**, including OpenAPI regeneration, Dart generation/analysis and schema/client drift checks, in isolated project `materyalph_clean_e647a236a549`. Only this evidence document changed after that snapshot. Candidate-source secret scan passed after removing an obsolete snapshot hash from this document which produced a false positive; scan rules were unchanged.

## Remaining acceptance work

Do not repeat the completed checks above without new relevant changes. Real Xendit reconciliation/Admin safe-retry flow is not yet exposed; never clear attempt markers blindly. Approved Cloudinary media currently has authenticated previews only; public delivery and uncertain-upload orphan cleanup remain outstanding. Tax correction notification/history visibility and final legal/privacy presentation still require acceptance review. No real provider smoke test was performed or authorized.

Working-tree summary: 556 modified and 305 untracked status entries; 810 generated-client entries and 51 other entries (including directory groups). Only 116 tracked files have textual diffs; many generated status entries are line-ending-only. Source changes cover Vendor domain/API, four migrations, portal workspace/tests, contracts, configuration examples and schema/setup documentation. Existing Buyer Android-manifest edits are preserved. Build/dependency/cache directories and actual environment files remain ignored; none appears among non-ignored untracked candidates. Both recovery stash identities and branch/HEAD are unchanged. Development database, volumes and existing Passport keys were preserved. No commit was created.

Approved runtime legal copy remains a manual content input; no invented Terms were seeded. TEST agreement fixtures are explicitly labeled and deleted from isolated test storage after tests. Impeccable remains **BLOCKED by Windows Security/tooling**; no bypass permitted.

Suggested eventual commit (do not commit): `feat(vendors): implement phase three onboarding verification and team accounts`.

## Final recovery acceptance — 14 September

Phase 3 code acceptance is complete. Release activation remains content-gated by approved legal copy and the Impeccable tooling limitation recorded below.

The Xendit TEST crash window is closed. Creation intent is committed before `POST /v3/accounts`; an unknown response, confirmed-provider/local-persistence conflict, or stale `TEST_CONNECTING` state enters controlled reconciliation. Reconciliation is Owner-only, requires recent privileged authentication and the current organization version, and uses a read-only provider lookup. One exact match restores the stored provider reference and status while retaining `environment=TEST`; an authoritative zero-match result alone clears the attempt and enables one controlled retry. Ambiguous, incomplete, mismatched and unavailable results remain blocked. Attempt, reconciliation, matched, blocked and retry decisions are audited. Database uniqueness continues to enforce one payment-account row per Vendor organization. Automated tests used mocks/fakes and made no real Xendit account.

The Cloudinary crash window is closed. Every public Store Profile upload gets a durable recovery row before the provider call. An uncertain upload remains `UPLOAD_UNCONFIRMED` and blocks another orphan-producing upload until the scheduled backend delete is confirmed. Provider-confirmed upload plus database failure enters compensating cleanup; failed deletes remain `CLEANUP_REQUIRED` and retryable. Cleanup becomes `CLEANED` only after Cloudinary confirms deletion. Pending/rejected media is never public, an approved logo/banner stays current while a replacement is pending, and approval atomically replaces the old version. Replaced and manually removed objects enter scheduled cleanup. The anonymous media route serves only unreplaced, scan-cleared, approved Cloudinary media for an ACTIVE Vendor. Legal, tax and verification documents remain on private S3/MinIO paths.

Final focused backend recovery suite: **22 passed / 245 assertions**, 17.02 seconds before the formatting-only pass. Directly affected Vendor portal: **4 tests passed**, TypeScript typecheck passed, production build passed; the existing 512.00 kB bundle-size warning remains advisory. Final isolated backend regression: **110 passed / 1,346 assertions**, 51.18 seconds. Pint: **215 files passed**. PHPStan: **No errors**.

Final clean-start passed in a new isolated snapshot. It included candidate-source secret scanning (**9.10 MB, no leaks**), isolated identity guard, temporary Passport-key preparation, all five Phase 3 migrations fresh/rollback/reapply, schema-document consistency, SMTP connectivity, Pint, PHPStan, backend **110 / 1,346**, OpenAPI validation, fresh TypeScript/Dart generation, Dart analysis and generated/schema drift checks. Three pre-existing unused OpenAPI model recommendations remain non-failing. The clean project was left running under its isolated generated project name; development data, volumes and existing Passport keys were untouched.

There are no remaining Phase 3 code blockers. Approved runtime Terms, Privacy and 2% commission agreement wording remains an external content dependency; no production legal copy was invented or seeded. Activation correctly stays blocked until an approved version is supplied and accepted.

IMPECCABLE — BLOCKED — Windows Security limitation; no bypass attempted.

Final working-tree review: **556 modified and 319 untracked entries**. Of 875 status entries, 822 are generated TypeScript/Dart client files; the other 53 cover API/domain/migrations/tests, shared and Vendor/Admin UI, OpenAPI/scripts/tests, documentation/configuration, and preserved Buyer generated/Android changes. Ignored environment, dependency, cache and build outputs are not intended source candidates. Branch, HEAD and both recovery stash identities remain unchanged. No commit, push, merge, deployment, development database/volume operation, or development Passport-key replacement occurred.

## Capstone agreement and manual-test finalization — 14 September

The canonical foundation seeder now publishes integrity-checked CAPSTONE/TEST content for MateryalPH Terms of Service v2, Privacy Notice v2, the existing Vendor Code of Conduct v2, and Vendor 2% Commission Terms v1. The first three use the ordinary account agreement flow; the commission version remains the dedicated Owner-only, recent-authenticated Phase 3 acceptance. Versions have fixed effective metadata, content hashes derived from the checked-in Markdown, and fail closed if an existing version conflicts. Earlier version rows and acceptance evidence are preserved. The Privacy Notice resolves `{{PRIVACY_CONTACT}}` from `PRIVACY_CONTACT_EMAIL` only after the stored source hash is verified. No production legal, government, regulator, or provider approval is claimed.

Focused agreement/onboarding verification passed: **24 tests / 309 assertions**. The added coverage proves seeded version/state/content integrity, configurable privacy presentation, missing/unaccepted readiness blockers, forged-version rejection, Store Manager denial, Owner-scoped acceptance, actor/version audit evidence, activation recognition, idempotent reseeding, historical acceptance preservation, and the existing immutable/versioned paths. The directly affected Admin fixture suite passed: **7 tests / 45 assertions**. Final isolated backend regression passed: **111 tests / 1,399 assertions**. Targeted Pint passed for **5 files** and PHPStan reported **no errors**.

The nullable deserialization test now lives at the Dart package's canonical `generated/dart/test/` location. Its former location was outside the package containing `pubspec.yaml`, so the VS Code analyzer had no package configuration for `materyalph_api_client` or `package:test`. The canonical generator preserves this repository-owned contract test and records it in `.openapi-generator/FILES`. Offline dependency resolution succeeded, `dart analyze` reported **no issues**, and the focused Dart test passed **2 tests**. A second canonical generation produced no TypeScript/Dart drift across **827 candidate generated files**.

Manual Phase 3 Vendor Web, Admin Web, Buyer Mobile regression, provider/storage, and agreement checks are ready at `docs/test-plans/phase-three-manual-smoke-test.md`. Production/live legal review and replacement copy remain outside this CAPSTONE/TEST seed and must use new agreement versions. IMPECCABLE remains **BLOCKED — Windows Security/local tooling limitation; no bypass attempted**.

Post-finalization candidate-source gitleaks scan passed (**8.84 MB reported by gitleaks, no leaks**). `git -c core.safecrlf=false diff --check` and the separate untracked-source whitespace check passed. Canonical regeneration preserved the relocated Dart test and added exactly one generated status entry, bringing the generated-client status total to **823**. Final expanded working-tree status is **562 modified and 344 untracked files**; normal status groups the untracked tree as 324 entries. The user-approved README and nine Buyer changes remain intentionally preserved and are not blockers. Branch `phase-3-vendor-onboarding`, HEAD `2e0a4e1b1bcce62752a3cc0a430fd697a7297326`, and both recorded recovery stash identities remain unchanged. No commit, push, merge, deployment, development database/volume operation, real Xendit account creation, or development Passport-key replacement occurred.

## Revised-onboarding corrective checkpoint — 15 September 2026

Status: **NOT READY**. The implementation and every runnable non-database gate are green, but the final database-backed Laravel regression, PostgreSQL migration cycle, and generated schema-document check cannot run in this session. Docker CLI is unavailable, and `.env.testing` intentionally targets the isolated `postgres-test` PostgreSQL host. The development database was not substituted or changed.

### Manual-test defect resolution

The HTTP 429/CSRF defect came from portal and shared workspace callers constructing bootstrap clients that requested `/auth/csrf` before each operation, including ordinary load/navigation paths. The replacement shared web transport does not acquire CSRF for `GET`, `HEAD`, or `OPTIONS`; caches a valid token per API base; deduplicates concurrent CSRF acquisition; retries a non-safe request once after one `419` token renewal; and never retries without a bound. Protected `401` responses use one shared refresh request and retry each original request once. Refresh `429` remains a distinct response and does not clear a valid browser session or enter a refresh loop. Logout still revokes through the canonical Passport session endpoint and clears only the transport cache after success.

Successful Vendor authentication and required MFA now route to `/dashboard`. Account/Profile remains under `/account`. The Dashboard uses separate Store Verification, Store Setup, Store Activation, and Marketplace Discoverability states and limits marketplace-management destinations until activation.

### Revised Vendor onboarding and Admin review

The Vendor flow now follows Account/Email Verification and agreement acceptance into an active portal account, then separates Store Verification from Store Setup. Store Verification contains the five approved Business Types, legal identity, Store Email OTP, contacts and communication designations, address/map pin, supplier classification/niches, private business/permit/tax/regulatory evidence, the single versioned Vendor Tax Profile, privacy acknowledgment, submission confirmation, `PENDING_VERIFICATION`, **Proceed to Store Setup**, correction/replacement cycles, and manual Admin approval. Upload never means approval.

Store Setup contains the public Store Profile and reviewed media, Bulk Order Capability, fulfillment, conditionally required delivery vehicles/rates, mandatory Xendit xenPlatform TEST/DEMO onboarding for every activation-seeking Vendor, the Vendor Tax Profile reference, versioned 2% Vendor-paid monthly Commission Terms, payment methods, physical-payment configuration, and refund capability. **Finish Later** returns to the limited Dashboard. Store media preview/removal controls and fixed-role Team Account invitation, member access/role, Owner-only delegation, and invitation-revocation controls are exposed without expanding delegated Manager authority. Team Accounts remain optional.

Activation readiness now requires applicable Store Verification approval and mandatory Store Setup completion, with Xendit and Commission Terms gates and no pending/correction/rejected/expired/hold/suspension blocker. Product listing, inventory, and product-level compliance are not Store Activation prerequisites. Marketplace Discoverability remains separate and still requires eligible listing/publication, inventory, serviceability, and applicable PS Mark/ICC Sticker compliance.

Admin review is grouped into Queue, Store Verification, Store Setup, and Activation. Reviewers receive completeness, dependency, scan/file, DTI/SEC/CDA/LGU/BIR/TIN source, document number, issue/expiry-or-not-applicable, remarks, reason, reviewer/timestamp, and immutable audit/history requirements, with Approve, Return for Correction, and Reject decisions. The isolated manual setup command remains `php artisan materyalph:bootstrap-admin admin@example.test`; it creates an invitation workflow and does not seed a password.

### Integrations and contracts

Private legal, business, identity, tax, and regulatory evidence remains on private S3/MinIO with authorized short-lived delivery. Public Store Profile media uses Cloudinary through the existing recovery/audit boundary. Xendit remains TEST/DEMO-only and does not prove live processing, withholding responsibility, or tax remittance. No real Cloudinary or Xendit mutation was performed.

OpenAPI validation passed with three existing non-failing unused-model recommendations. The canonical generator completed for TypeScript and Dart. The TypeScript client build passed. Dart built-value generation then wrote zero additional outputs; Dart analysis and the two focused nullable/deserialization tests passed. Route parity passed for **41 Vendor Onboarding operations** and **52 protected account operations**, including Passport, CSRF, portal guards, public-route boundaries, and response envelopes.

### Final runnable evidence

- Laravel Pint: passed. PHPStan with 512 MB: no errors. The corrective migration passes `php -l`.
- Vendor Web: lint, typecheck, and production build passed; **41 tests / 7 files passed**. The 537.59 kB JavaScript chunk warning is advisory.
- Admin Web: lint, typecheck, and production build passed; **8 tests / 3 files passed**.
- Buyer Mobile: `flutter analyze` found no issues; **31 tests passed**.
- Generated TypeScript: build passed. Generated Dart: analysis found no issues; **2 focused tests passed**.
- Contract checks: **41 Vendor Onboarding** and **52 account** operations passed.
- Candidate-source Gitleaks scan: **9.35 MB, no leaks**. A whole-workspace scan that included ignored dependency/build trees was discarded as non-candidate evidence; the established tracked-and-non-ignored source snapshot is authoritative.
- Final `git -c core.safecrlf=false diff --check`: passed after the evidence append.
- Impeccable: **BLOCKED — Windows Security/local tooling limitation; no bypass attempted.** The skill's hierarchy, interaction-state, accessibility, and permission-boundary guidance informed the restored media and Team Account controls, but its executable engine was unavailable.

### Remaining gates and ownership

- **CODE:** no failure remains in the runnable static, contract, web, mobile, or generated-client gates. Database-dependent behavior is not certified until the blocked tests run.
- **CONTENT:** no CAPSTONE/TEST onboarding-content blocker was identified. Any future LIVE legal/provider approval remains outside this corrective run.
- **EXTERNAL PROVIDER:** manual TEST credential smoke checks for S3/MinIO, Cloudinary, and Xendit remain for the user; no automated result is represented as a real-provider result.
- **TOOLING:** Docker/isolated PostgreSQL is unavailable, so `PhaseThreeOnboardingTest.php`, the full Laravel suite, fresh migration, rollback/reapply, and `materyalph:schema-document --check` are unrun. The generator-owned `data-dictionary.md` therefore still reflects the pre-15-September three-value Business Type constraint and must not be hand-edited.
- **MANUAL RETEST:** not performed or claimed. Use `docs/test-plans/phase-three-manual-smoke-test.md` after the database/tooling gates pass.

Working tree at the pre-report checkpoint contained **954 status entries**: 570 tracked-status entries and 384 untracked files, including 859 generated-client entries; **0 files were staged**. Branch `phase-3-vendor-onboarding`, HEAD `2e0a4e1b1bcce62752a3cc0a430fd697a7297326`, and recovery stashes `87959ddf85b678542ae7f0f1f179ed1cbf2b3e66` and `a1ad68f0b7a03658a2960497ce7b73e5add850c1` remain unchanged. No commit, push, merge, deployment, development database/volume operation, real provider mutation, or Passport-key replacement occurred.

Suggested eventual commit (do not commit): `feat(vendors): synchronize revised onboarding and corrective session flow`.
