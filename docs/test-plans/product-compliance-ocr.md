# My Products PS Mark / ICC sticker OCR

Photo/camera evidence is scanned and stored privately before local Tesseract reads it. Its English model is installed in the API Docker image. No cloud credentials, external photo uploads or database migrations are needed. Tesseract TSV word confidence follows the [official CLI documentation](https://tesseract-ocr.github.io/tessdoc/Command-Line-Usage.html).

The photo path returns editable suggestions for marking type and labelled licence/certificate number, manufacturer/importer names and addresses, country, brand and batch/lot. Unlabelled values, conflicting numbers and PNS standards are not guessed as certificate identifiers. Extraction never establishes authenticity or changes compliance/publication state. Vendor confirmation and the existing official-register comparison or Admin decision remain separate.

**Updated 2026-10-17 (register lookup, `product-compliance-register-lookup.md`).** OCR now reads the marking number by its printed shape, because Tesseract rarely reproduces the label exactly. That number is the PS License No. (`Q-1234`) or the ICC sticker serial (`A500000001`), which is now the ICC identifier. Two passes run (sparse text, then a higher-contrast block), and look-alike readings (`AS000000G1` → `A500000001`) become candidates that the active register confirms.

## Development runtime

The defaults enable local OCR; existing environment files do not need new values. Optional API-only settings, documented in `services/api/.env.example`:

- `COMPLIANCE_OCR_DRIVER=tesseract` (`none` disables assistance).
- `COMPLIANCE_OCR_BINARY=tesseract` (trusted executable name or absolute server path).
- `COMPLIANCE_OCR_TIMEOUT_SECONDS=15` (bounded to 1–30 seconds).

After pulling the code into an existing local Docker installation, run `docker compose build api` then `docker compose up -d --no-deps api`. If configuration is cached, run `docker compose exec -T api php artisan config:clear`. These commands do not run migrations. A host PHP runtime needs Tesseract, English trained data, GD and enabled process execution.

The Admin integration card shows `HEALTHY` only when Tesseract successfully lists the English model. A selected but unavailable engine is `DEGRADED`; disabled assistance is `NOT_CONFIGURED`. The card describes product-marking assistance rather than implying Store Verification document OCR.

## Automated coverage

- `MarkingTextParserTest`: PS/ICC fields, multiline labels, conflicting values, absent values, standard/serial exclusion.
- `TesseractComplianceTextExtractorTest`: TSV parsing, recognition confidence, process bounds, temporary-image cleanup, missing model, engine failure and output limit; real local OCR of synthetic PS and ICC images when the engine is installed.
- `PhaseFourCatalogComplianceTest`: private provenance, corrected declarations separated from extraction, confirmation required, no automatic OCR approval, manual ICC fallback, scan-before-OCR, role/account/organization changes during OCR and discarded orphan evidence. Existing fixed-role and cross-organization tests still apply.
- `PhaseSixteenAdminOperationsTest`: disabled/missing/usable engine health and safe configuration output.
- Vendor `CatalogPages.test.tsx`: every suggested field remains editable, corrections clear confirmation, failure leaves manual review available.
- `test:catalog-contract`: provenance and confidence schema, generated TypeScript/Dart fields, existing route/security guards.

## Manual acceptance

In My Products, choose a regulated product, Photos and compliance, then Photo or camera capture. Upload clear physical PS/ICC marking photos, inspect suggestions, correct a number, and confirm before submitting. Also try a blurred photo and a sticker containing only its serial/QR code. Missing values must remain manual; an uncertain/unavailable official match must remain pending Admin review. Test camera rotation and glare on real packaging. Browser/camera acceptance and accuracy on real-world photos require manual testing.

## Changed files

- API: `ComplianceTextExtractor`, `MarkingTextParser`, `TesseractComplianceTextExtractor`, `UnavailableComplianceTextExtractor`, `ProductComplianceService`, `CatalogAccess`, `JobHealthService`, `AppServiceProvider`, `config/materyalph.php` and `.env.example`.
- Runtime: `infrastructure/docker/api.Dockerfile`; local development API rebuilt/recreated and configuration cache cleared. No migrations or cloud keys.
- Vendor: `CatalogListingSteps.tsx` and `CatalogPages.test.tsx`.
- Contract: `openapi.yaml`, `check-catalog-contract.mjs`, regenerated TypeScript/Dart clients and Dart serializers.
- Tests: `MarkingTextParserTest`, `TesseractComplianceTextExtractorTest`, `PhaseFourCatalogComplianceTest`, `PhaseSixteenAdminOperationsTest`, two synthetic PNG fixtures; documentation here and `README.md`.

## Executed checks — 2026-10-14

| Check | Result |
| --- | --- |
| Isolated database guard and negative guard cases | Passed |
| Default-discovered API suite, PHP memory limit 512 MB | 448 passed, 9,124 assertions. Default discovery in this runtime omitted the catalog file, so it was also run explicitly. The initial 128 MB run exhausted memory in an onboarding fixture. |
| Explicit final catalog API file | 22 passed, 1 failed, 546 assertions. All five new OCR feature cases pass. The unchanged Fulfillment-role test expects an assigned catalog response but receives 403. |
| Final OCR unit files | 10 passed, 30 assertions, including actual Tesseract recognition of both fixtures and memory fallback |
| Vendor catalog components | 14 passed |
| Full Vendor suite | 461 passed, 7 failed: six unchanged `OrderPages.test.tsx` expectations and one unchanged Inventory auto-accept expectation |
| Full Admin suite | 105 passed |
| Vendor/Admin lint, typecheck and production builds | Passed; non-blocking chunk-size warnings |
| PHPStan and formatting for changed PHP files | Passed. The initial whole-repository Pint check found the new import order; it was corrected. |
| OpenAPI validation | Passed with 8 unused-model recommendations |
| Catalog / Admin operations contracts | 29 / 34 operations passed |
| TypeScript client build; Dart generation and OCR model/serializer analysis | Passed |
| Compose configuration; Gitleaks scan of changed text and contract; whitespace check | Passed; no leaks or trailing whitespace |
| Development API adapter/model availability | `TESSERACT`, available; English model present |

To rerun the explicit catalog API gate after starting the isolated services, use:

```powershell
$ocrDocker = Join-Path $env:LOCALAPPDATA 'Programs/DockerDesktop/resources/bin/docker.exe'
& $ocrDocker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php -d memory_limit=512M vendor/bin/phpunit tests/Feature/Api/PhaseFourCatalogComplianceTest.php
```

The full unrelated failing expectations remain outside this OCR change. Buyer UI, live packaging-photo accuracy and browser/camera acceptance were not tested. Suggested commit: `feat(compliance): add local PS and ICC photo OCR`.
