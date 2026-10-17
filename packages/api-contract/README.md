# API contract

`openapi.yaml` is the canonical OpenAPI 3.1 source. Generated TypeScript and Dart clients belong under `generated/` and must never be hand-edited.

- `npm run validate` validates OpenAPI 3.1.
- `npm run generate` regenerates both first-party clients with the generator version pinned in `openapitools.json`.

Handwritten Dart checks in `scripts/` use this package's `pubspec.yaml`, which references the generated Dart client by local path. Run `dart pub get` from `packages/api-contract` after cloning or changing Dart dependencies so both the IDE and command-line checks can resolve the client. After the generated client's `build_runner build` finishes, `npm run test:quotation-discount-contract` verifies percentage discount scopes, legacy fixed-discount drafts and published assessment serialization.

FIN and MAT component schemas establish later-phase terminology without publishing fake operational endpoints. Authentication paths match the Phase 1 Laravel implementation; the temporary product scaffold remains outside the approved public contract.

## Generated-code warning policy

- Validation recommendations for the unused `FinancialSnapshot`, `FeeAssessment`, and `MaterialPriceObservation` schemas are accepted while those approved later-phase response paths remain unpublished.
- The pinned generator's OpenAPI 3.1 beta banner is informational; validation must still exit successfully and generated-client drift remains a failing gate.
- Generated Dart may be analyzed with `--no-fatal-warnings` for generator-owned unused imports. Analyzer errors, warnings in handwritten Buyer code, or any broader analyzer suppression remain failures.
- `build_runner build` must finish successfully. Obsolete or ignored command-line options are not retained in local or CI commands.
- Client generation registers Dart serializers for singleton boolean constants. The pinned generator otherwise treats their wire values as strings; normalization preserves real JSON booleans and rejects values that violate the canonical `const` constraint.
