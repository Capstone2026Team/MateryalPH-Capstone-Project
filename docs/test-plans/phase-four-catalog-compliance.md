# Phase 4 — Catalog and PS/ICC product compliance

Scope: taxonomy and canonical materials, Vendor listings (seven listing statuses), variants, versioned prices, listing media, bulk CSV import, publication snapshots, Marketplace Discoverability, DTI-BPS PS Mark / ICC sticker evidence, register snapshot import, the exact-match auto-verify rule `compliance.register-exact.v1`, and Admin Product Compliance review.

Out of scope: full inventory and Limited Stock, and setting `TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED` (Phase 5 owns both). Also out of scope: Buyer catalog browsing, an OCR engine, and an Admin UI for comparable groups.

## Risks and where each is covered

| Risk | Rule | Coverage |
| --- | --- | --- |
| Regulated material published without verified evidence | Regulated listings reach `ACTIVE` only once compliance is `VERIFIED`. A DB CHECK backs this. | API `test_regulated_publication_gate_admin_review_and_compliance_sensitive_reverification`; e2e wizard review step |
| Register partial match treated as proof or accusation | Only an exact match against the ACTIVE snapshot auto-verifies: same normalized number, manufacturer (PS) or importer (ICC), PNS standard, and not expired. Anything less goes to `PENDING_ADMIN_REVIEW`. | API `test_exact_register_match_auto_verifies_and_partial_match_routes_to_admin_review`; unit `test_register_values_normalize_deterministically` |
| Edited regulated listing keeps a stale verification | Changing material, brand, model, manufacturer, address or country withdraws `VERIFIED`. | API reverification test (same as row 1) |
| Admin decides on a stale submission, or without a reason | The decision names version and lock. Return or reject requires a reason. A stale lock returns 409. | Admin component tests (4); e2e admin case (required reason, target line, read-only after decision) |
| Private evidence leaks into public media | Evidence files stay in the private `PRODUCT_COMPLIANCE_EVIDENCE` bucket, enforced by a DB trigger. Listing media accepts only `LISTING_MEDIA` files. | API `test_private_verification_and_compliance_evidence_never_become_public_listing_media` |
| Malicious or oversized upload | Content validation, and uploads fail closed when scanning is unavailable. | API `test_listing_uploads_reject_file_abuse_and_fail_closed_when_scanning_is_unavailable` |
| Floating-point money or wrong VAT | Integer centavos. Included VAT is `money(L×12/112)`, rounded half-up, and applies to `VAT_12` only. | Unit VAT, peso-to-centavos and normalized-price tests |
| Price history rewritten | Price versions and publication snapshots are immutable. | API `test_price_versions_and_publication_snapshots_preserve_history_for_later_orders` |
| Partial import reported as success | Rows are validated first, and nothing is saved before apply. Apply writes only the valid rows, in one transaction. `APPLIED_WITH_REJECTIONS` is shown as a problem. | API `test_bulk_import_reports_row_errors_and_applies_validated_rows_in_one_transaction`; Vendor component test; e2e import |
| Store discoverable with nothing buyable, or hidden when eligible | Activation needs no product. Discoverability follows eligible listings. | API `test_product_free_activation_keeps_the_store_not_discoverable`, `test_an_eligible_listing_makes_the_store_discoverable_and_later_loss_of_eligibility_hides_it`; Vendor component and e2e empty state |
| Other labels pollute shared taxonomy | An Other label is listing text only. It stays Not Yet Comparable. | API `test_other_labels_stay_listing_text_and_never_write_shared_taxonomy` |
| Rental services slip in | Vehicle and equipment rental is rejected. Equipment sold as a product is allowed. | API and unit rental tests |
| Wrong role can write | Each fixed role gets its documented catalog and PS/ICC permissions. Fulfillment sees assigned listings only; Customer Service is read-only. | API `test_each_fixed_role_has_the_documented_ps_icc_and_catalog_access` |
| Writes before Store Activation | Catalog writes return 409 `STORE_NOT_ACTIVE` until activation. | API `test_variant_rows_are_validated_together_and_catalog_writes_require_store_activation`; Vendor component test |
| Analytics comparability drift | MAT-03 exact comparable keys, using ordinary VAT-inclusive prices. | API `test_mat03_comparable_groups_use_exact_keys_and_ordinary_vat_inclusive_prices` |
| Material search misses typos or aliases | Aliases are ranked first; pg_trgm similarity ≥ 0.3 catches typos. | API `test_material_search_prefers_aliases_and_uses_pg_trgm_for_typos` |
| Untrusted QR or OCR values accepted as fact | Extraction only suggests values. The Vendor confirms every value. | Unit `test_qr_payloads_are_untrusted_suggestions`; Vendor component test (all three paths converge on one review step) |
| Implementation and contract drift | All 28 catalog and compliance operations match Laravel routes and guards. | `check-catalog-contract.mjs` |
| Reflow and target-size regressions | No horizontal overflow at 320–1920 px, and status is shown as text plus icon. | Playwright `e2e/phase-4-catalog.spec.ts` at 8 widths |

## Test inventory

- **API feature**: `services/api/tests/Feature/Api/PhaseFourCatalogComplianceTest.php`, 14 tests.
- **Unit**: `services/api/tests/Unit/CatalogComplianceRulesTest.php`, 11 tests including data-provider cases.
- **Contract**: `packages/api-contract/scripts/check-catalog-contract.mjs` checks 28 operations against `php artisan route:list --json --path=api/v1`.
- **Vendor components**: `apps/vendor-web/src/pages/CatalogPages.test.tsx`, 7 tests.
- **Admin components**: `apps/admin-web/src/pages/ProductCompliancePages.test.tsx`, 4 tests. The reason field is asserted `required`, because native validation blocks submit before the page can show its own message.
- **End-to-end (layout)**: `apps/vendor-web/e2e/phase-4-catalog.spec.ts`, 4 tests × 8 widths. Every `/api/v1` call uses a synthetic fixture. The spec covers:
  - My Products list and empty state
  - the six-step listing wizard: create, per-row variant validation, photo upload, manual PS/ICC path through Review and confirm to submission, and the review step
  - bulk import validation and partial apply
  - the Admin queue and case, from required reason to decision

  Screenshots are in `docs/design/evidence/phase-4/`. They show layout only, not live provider readiness.

## Executed results (2026-09-28)

| Gate | Result |
| --- | --- |
| `pint --test`, `phpstan analyse`, `php artisan test` (in `materyalph_phase1_test-api-test-1`) | Pint clean, PHPStan clean, **271 passed** (3,174 assertions) |
| Vendor `lint`, `typecheck`, `test --run`, `build` | Clean; **185 passed** (23 files); build OK (existing bundle-size warning) |
| Admin `lint`, `typecheck`, `test --run`, `build` | Clean; **29 passed, 1 failed**. `PortalShell.test.tsx` also fails at `HEAD` (see below). |
| Playwright `phase-4-catalog.spec.ts`, 8 widths | **32 passed** |
| `npm run validate` + account / Phase 3 / catalog contract checks | Valid (3 existing recommendations); 61 / 35 / 28 operations passed |
| `flutter analyze` / `flutter test` | No issues; **44 passed, 12 failed**, identical to `HEAD` (see below) |
| `docker compose config --quiet`, `git diff --check`, `git diff --cached --check` | Pass |
| `gitleaks git --staged` and `gitleaks dir` over every modified and untracked file | No leaks |

### Defects found and fixed during this pass

- **Reflow at 320–375 px.** Three forms overflowed their cards by 16–45 px: the My Products filter, the PS/ICC marking-photo input, and the CSV inputs on Vendor import and the Admin register import. The cause was grid items and native file inputs sizing to their intrinsic minimum width. The fix gives these forms explicit `grid-cols-1` columns and makes the inputs `w-full min-w-0`.
- **Admin reason label.** The required asterisk wrapped onto its own grid row.
- **Generated Dart client.** The `.g.dart` part files were missing for the 60 Phase 4 models, so `flutter test` could not compile. The fix was running `dart run build_runner build --delete-conflicting-outputs` in `packages/api-contract/generated/dart`. `scripts/generate-clients.mjs` does not run build_runner, so this step must follow every regen.

### Failures that also occur at `HEAD`

Each was confirmed by stashing the working tree (tracked changes) and running the same suite at `HEAD`.

- **Admin `PortalShell.test.tsx`.** The test expects the collapsed-sidebar tooltip to appear on focus and close on Escape. `portal-shell.tsx` shows it only on mouse enter. Neither file changed in Phase 4. This is a real WCAG 1.4.13 gap for keyboard users and needs its own fix.
- **Buyer mobile.** 12 widget tests fail with `RenderFlex overflowed` (for example, 96 px and 352 px at 320 px width) in onboarding, profile and account reflow tests. `apps/buyer-mobile` has no Phase 4 changes, and the counts are identical at `HEAD`.

## Manual acceptance still required

- **Live register import.** Import a real DTI-BPS PS licensee or ICC certificate CSV export, activate it, and confirm an exact match auto-verifies. Confirm that a near-miss routes to review.
- **Live upload scanning.** Upload images against the real scanner and object storage, including the fail-closed path with the scanner stopped.
- **QR decoding in real browsers.** Decoding uses `BarcodeDetector`, which Chromium supports and Safari and Firefox do not (manual entry is the fallback).
- **Product Compliance notice email.** Check it in Mailpit after an Admin decision.
- **Dev database migration.** The Phase 4 migrations have so far been applied only to the isolated test database.

## Update: My Products redesign and CAT-PRICE-01 volume tiers (2026-09-28)

**Scope.** My Products now has summary tiles, status filter chips with counts, product cards (photo, category, price per unit, status, Vendor-only available stock) and a Grid/Table switch. The listing wizard is four steps in a vertical step rail with a Publication gate panel:
1. Material selection
2. Product information
3. Photos and compliance
4. Review and publish

The server still tracks the same six completion requirements. The project owner approved volume tier pricing (CAT-PRICE-01), now recorded in the System Workflow, Vendor Workflow and Technical System Design.

**Rule changes guarded by tests.**
- **Volume tiers.** Up to five per variant. The minimum quantity must be greater than 1 and strictly increasing, each price strictly decreasing and below the ordinary price. The highest tier reached applies.
- **Tier versions.** Tiers are immutable `VOLUME_TIER` price versions. A change retires the old ones and inserts new ones, and publication snapshots include them. Migration `2026_09_28_000002` adds one current tier per variant and minimum quantity, and a check that the minimum is greater than 1.
- **Omitted tiers.** Leaving `volume_tiers` out keeps the current tiers, but they must still undercut a changed ordinary price.
- **List summaries.** The list returns `status_counts` and `active_out_of_stock` for the search and category scope, ignoring the status filter. It also returns `unit_code` and `available_quantity` only when every active variant shares one unit, and a short-lived signed `primary_image_url` so cards need no request per image.
- **UI never claims verification.** PS/ICC status in the UI comes only from the server. A regulated listing that isn't verified yet shows "Request publication" and is never described as active.

**Added tests.**
- API feature:
  - `test_volume_tiers_are_validated_versioned_and_snapshotted`
  - `test_listing_list_reports_status_counts_units_stock_and_signed_thumbnails`
- API unit:
  - `test_the_highest_reached_volume_tier_sets_the_unit_price`
  - `test_volume_tiers_must_start_above_one_unit_and_step_down_below_the_ordinary_price`
- Vendor component:
  - tiles, chips, cards and the table switch
  - tier validation, and saving the details before the variants
  - the four-step indices and the gate panel
- Playwright: the 8-width wizard now also covers tiers, photo slots and the review preview. Screens are regenerated in `docs/design/evidence/phase-4/`.

**Executed results.**

| Gate | Result |
| --- | --- |
| Pint, PHPStan, full API suite | Clean, clean, **275 passed** (3,239 assertions) |
| Vendor lint, typecheck, tests | Clean, **186 passed** |
| Admin lint, typecheck, tests | Clean; **29 passed, 1 failed**. `PortalShell` also fails at `HEAD`. |
| Playwright `phase-4-catalog.spec.ts` | **32 passed** at 8 widths |
| Full vendor Playwright suite | **374 passed, 2 failed**. `signup-layout.spec.ts` fails at 320 and 375 px, and fails identically at `HEAD` (checked by stash). |
| OpenAPI validate and contract checks | Valid; 61, 35 and 28 operations passed |
| `flutter analyze` / `flutter test` | No issues / **44 passed, 12 failed**, the same as `HEAD` |
| Compose config, diff check, gitleaks | Pass, pass, no leaks |

**Generator note.** dart-dio assigns the new list meta object directly to a builder field. `scripts/generate-clients.mjs` now converts it with `toBuilder()`, as it already did for four onboarding models. Run `dart run build_runner build --delete-conflicting-outputs` in `generated/dart` after every regeneration.

**Not yet built.** Checkout, quotations and order snapshots don't exist yet. When they are built, they must call `VolumePricing::unitPriceCentavos` and record the applied tier's price version. Buyer-facing tier display belongs to the Buyer product details work. Bulk CSV import doesn't carry tiers.

## Update: draft deletion, display-name suggestion, compliance photo check (2026-09-28)

- **Delete.** Only listings that were never published can be deleted. That means publication version 0, never published, and not Active; the server and a DB check constraint both enforce it. The row, versions and audit log are kept (`removed_at`, `removed_by_user_id`), and the listing is hidden from every catalog query. Its Vendor SKU is reusable through a partial unique index. A pending PS/ICC submission is superseded. A listing that was ever published returns 409 `LISTING_HAS_PUBLICATION_HISTORY`. The endpoint is `DELETE /vendor/catalog/listings/{id}?lock_version=`, and the migration is `2026_09_28_000003_add_draft_listing_removal`. The Vendor workflow records the rule.
- **Display name suggestion.** Add product asks for the material name first. The chosen match (or the typed text) becomes the display-name placeholder: Tab or "Use suggestion" fills it, and an empty field uses it. A chosen material is saved with the new draft. Step 2 offers the same suggestion when the display name is cleared.
- **Compliance photo check.** A chosen marking photo is previewed locally and uploaded only after "Upload this photo". Uploaded photos show as thumbnails in Review and confirm and can be removed from the submission.

**Tests.**
- API: `test_only_never_published_listings_can_be_deleted_and_their_history_is_kept` covers stale lock, SKU reuse, superseded submission, published and deactivated refusal, the DB constraint, and the read-only role.
- Vendor components: card delete with confirm and cancel, editor delete, material-to-display-name suggestion, and upload only after confirmation.
- Playwright: delete dialog focus, create-form suggestion, and photo preview before upload, at all 8 widths.

**Results.**

| Gate | Result |
| --- | --- |
| Vendor tests | **189 passed** |
| Admin tests | **29 passed, 1 failed**. `PortalShell` also fails at `HEAD`. |
| Phase 4 Playwright | **32 passed** |
| Contract checks | 61, 35 and 29 operations passed |
| `flutter test` | 44 passed, 12 failed, the same as `HEAD` |
| Gitleaks | No leaks |
