# Product-aware quantity handling

Owner-approved quantity behavior, 26 October 2026. Material compatibility and the explicit selling unit determine quantity rules; product names do not infer a physical classification or conversion.

## Rules and compatibility

- Count/package units use whole quantities. Volume, mass, length and area use the unit's configured precision. Existing `GAL` means whole gallon cans; the new `US_GAL` is measured US gallons with three decimals. No conversion or package-content multiplier is introduced.
- Optional read-only `quantity_policy` exposes mode, dimension, precision and step. New commercial snapshots freeze it. Older records use recorded precision/step and legacy selling-unit identity; unknown historical meanings require review for mutations. No historical transaction is rewritten.
- Existing `Money::lineAmount` multiplies decimal strings by integer-centavo prices with BCMath, rounds each line half-up to centavos, then totals the rounded lines. Existing discount allocation, tax, commission, withholding and financial snapshots remain authoritative. Client previews use integer/BigInt arithmetic.
- Available stock remains physical stock less hard reservations. Soft holds do not reduce it. The existing ledger owns count adjustments, reservations, releases and fulfillment; retries cannot repeat physical deductions. Stock adjustments cannot consume hard reservations.
- Project matches and coverage require the same selling unit. Bags cannot fulfill cubic meters. Vendors propose changed quantities/units through existing versioned quotation review and Buyer acceptance; grouped proposals still require matching authorized allocations. Buyer revisions retain the original locked version.
- Changing the unit of stock or a commercially referenced variant requires a replacement variant. Exact stock remains restricted to authorized Vendor users.

## Automated acceptance

- `QuantityPolicyTest`: measured/count boundaries, trailing zero normalization, malformed input, legacy precision, package tier thresholds and half-cent/large-value money calculations.
- `ProductQuantityPolicyTest`: idempotent migration preserving GAL, direct API rejection of fractional piece stock, replacement-variant requirement, cart/order amount equality, decimal reservation/release/fulfillment retries, legacy snapshot reads, changed-unit reservation rejection and checkout revalidation without rounding.
- `PhaseTenProjectsTest`: bag-only offers do not satisfy a cubic-meter requirement; an explicit Buyer revision changes matching while retaining the original version. Existing quotation/arrangement, order and inventory concurrency suites remain regression gates.
- Buyer `quantity_policy_test.dart` and authoring tests: exact previews, labels, unit changes without rounding, preserved invalid text, explicit unlisted selling basis and decimal persistence.
- Vendor quantity, catalog, quotation and inventory tests; `check-quantity-policy-contract.mjs`; generated TypeScript/Dart decoding with and without optional metadata. The shared allotment editor also preserves typed whole-unit quantities when its initial policy effect runs late; subsequent saved policy changes still refresh its values.

## Implementation entrypoints

- `services/api/app/Domain/Catalog/QuantityPolicy.php` supplies the shared rules. Existing Catalog, Procurement, Projects, Messaging, Inventory and Orders services use them without replacing the finance or ledger architecture.
- `services/api/database/migrations/2026_10_26_000000_add_measured_us_gallon_unit.php` adds US_GAL without changing GAL or historical records. It was applied successfully to the confirmed local development API; other environments use their normal release migrations.
- Flutter's shared quantity presentation/validation and procurement field are reused by Project material entry, product finalization and cart editing. Vendor catalog, inventory and quotation forms reuse `packages/web-ui/src/quantity-field.tsx`.
- OpenAPI and regenerated TypeScript/Dart models add optional read-only metadata. Workflows, targeted tests and legacy-label assertions were updated alongside the implementation.

## Verification results — 26 October 2026

| Check | Result |
| --- | --- |
| Quantity, legacy history, checkout and Project unit compatibility | 11 passed, 156 assertions |
| Orders and real PostgreSQL inventory/order concurrency | 32 passed, 932 assertions |
| Catalog/inventory regression selection | 52 passed, 1,143 assertions |
| Full API regression run | 766 passed; 1 unrelated onboarding failure; 15,521 assertions |
| Pint | 840 files passed |
| PHPStan | No errors |
| Buyer full Flutter suite | 630 passed; 1 skipped |
| Buyer analysis | No issues |
| Vendor full suite | 646 passed across 72 files |
| Admin full suite | 177 passed across 28 files |
| Vendor/Admin TypeScript checks and production builds | Passed |
| Quantity and affected API contract scripts | Passed |
| OpenAPI validation | Passed; eight unused-model recommendations |
| Generated TypeScript build and Dart serializer generation | Passed |
| Generated Dart analyzer | Two warnings in unchanged generated models: unused optional `specifiedType` parameters in `directory_review_ratings_value.dart` and `geo_demand_cell_value.dart` |
| Compose configuration, whitespace and changed-source secret scan | Passed; no leaks found |

Focused suites overlap the full run; their counts are not additive. Additional focused TypeScript and Dart assertions verify optional quantity metadata decoding and legacy responses.

The full API gate remains affected by `PhaseThreeVendorOnboardingTest::test_admin_approves_store_documents_without_owner_tax_attestation_but_requires_matching_vat`: repeated document decisions can collide on `(business_document_version_id, reviewed_at)` with SQLSTATE 23505. The same failure was reproduced using an unchanged-HEAD API snapshot against the isolated test database. Vendor verification behavior was left outside this quantity change.

An initial Buyer run encountered a full C: drive while copying temporary compiler output. The final successful full run used a dedicated D: temporary directory and serial execution; no device/provider acceptance is inferred from it.

## Local setup and manual acceptance

Apply the new forward migration in each intended application environment through its normal migration/release process. Isolated tests do not migrate development or staging. No new keys, dependencies or provider configuration are required.

On a device, check gravel as bags versus m³, liquid as liters versus measured US gallons, gallon cans as whole containers, keyboard behavior, unit switching with invalid preserved text, save/reopen, and the original/proposed unit comparison before Buyer approval. No provider or physical-device acceptance is implied by automated checks.

Suggested commit: `fix: apply product-aware quantity policies across procurement`
