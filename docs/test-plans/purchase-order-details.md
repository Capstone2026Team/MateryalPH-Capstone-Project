# Purchase Order details and Buyer contacts - 4 November 2026

The private Purchase Order now includes payment and fulfillment methods; Vendor store/legal name, business address and public contacts; and Buyer name, supplied billing name/address, account email and saved mobile number. Site Delivery includes the frozen delivery destination address. Missing values say not provided. The PDF uses two party columns above methods, accepted items and amounts. The large notice strip remains removed; compact sample/not-tax-invoice/BIR footer labels remain.

Separate payment-confirmation generation and download actions are retired across Admin, Vendor and Buyer. The API returns only `PURCHASE_ORDER` metadata. Retired download URLs return 404 and retired export requests return 422. Existing payment/refund records and previously issued confirmation files remain retained.

## Implementation and integrity

- `PurchaseOrderDetails.php` captures the explicit commercial party/method projection. Buyer contacts come from `users.email` and `user_profiles.mobile_e164`. No TIN, staff private contact, credentials, provider payload or coordinates are included.
- `DocumentSnapshot.php` includes these details in new immutable Purchase Order sources. `OrderDocumentService.php` prepares only Purchase Orders and preserves the existing post-commit outbox, scheduled sweep, private storage and idempotent processing.
- `OrderDocumentLayout.php` and `reports/order-document.blade.php` present layout version 5. Migration `2026_11_04_230000_add_order_document_context_snapshots.php` adds nullable JSONB context and SHA-256 columns, with paired-field and required-context checks for new renditions. The existing rendition immutability trigger protects both columns. No applied migration was edited.
- For legacy files, missing party details are captured once with their capture date in a new immutable rendition. Adding Buyer contacts preserves previously frozen names, addresses and methods, and records a separate contact capture date. Canonical recursive key sorting makes context hashes stable after PostgreSQL JSONB serialization. Earlier source snapshots, hashes, file references and financial values never change. Previously generated development renditions are retained; the final version supersedes their earlier hashing implementation.
- `DocumentExportService.php`, `ExportAccess.php`, the dedicated download route, console command and OpenAPI remove the retired document kind from public generation/download. The renderer retains legacy presentation support for historical fixtures.
- Shared web controls, Admin/Vendor order pages, Buyer order/export controls and Buyer help/invoice copy now offer only the Purchase Order. Current files download directly without an export-reason prompt or a fresh generation request.
- System/Buyer/Vendor/Admin workflows, architecture and UI planner record the owner decision. Earlier automatic-document and PDF-layout reports are marked as historical.

The existing Buyer ownership, current Vendor membership/role/assignment and Admin invoice-view checks apply. Download reauthorization, private CLEAN-file checks, SHA-256 verification and access audits remain enforced. Buyer email/mobile are included only in the authorized document; public/list/analytics projections are unchanged. A recorded payment method never proves payment, and Vendor tax-invoice duties are unchanged.

## API and generated clients

`packages/api-contract/openapi.yaml` permits only `PURCHASE_ORDER` for order-document kinds and removes `PAYMENT_CONFIRMATION` from export types. The read/download description documents the added methods, parties and Buyer contacts. TypeScript/Dart clients were regenerated using `npm.cmd run generate`; generated files were not manually edited. No new endpoint or environment key is required.

## Verification

- Guarded isolated Compose checks passed static/live isolation, negative cases and protected Passport-key setup.
- Final API/unit command: `php artisan test --compact --no-ansi tests/Feature/Api/OrderDocumentsTest.php tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Feature/Api/PhaseFifteenExportsTest.php tests/Unit/OrderDocumentLayoutTest.php` in `materyalph_phase1_test-api-test-1`: **39 passed, 850 assertions**. Coverage includes automatic private PDFs, contact capture/supplements, frozen values, JSONB hash stability, escaping, pagination, authorization/revocation, retries, checksums, historical preservation, retired requests and physical/online payment regressions.
- Pint passed all **13 affected PHP files**. `vendor/bin/phpstan analyse --memory-limit=512M` checked **575 files with no errors**.
- Admin: lint, typecheck and build passed; focused tests passed **28 tests in 3 files**. Vendor: lint, typecheck and build passed; focused tests passed **59 tests in 2 files**. Web builds retain bundle-size warnings; Vendor lint retains the existing unused `inStore` warning.
- Buyer: full `flutter analyze --no-pub` passed with **no issues**. Focused document-export, notification and dispute tests passed **38 tests**. The subsequent help/invoice wording edits are string-only.
- `npm.cmd run validate`, `test:order-documents-contract`, `test:notifications-contract` and the regenerated TypeScript build passed. OpenAPI validation retains **8 unused-model recommendations**. Dart `build_runner build --delete-conflicting-outputs` passed in **85 seconds** with zero required output changes; the tool reported the deprecated flag as ignored.
- The final synthetic PDF was rasterized and visually inspected: **1 page**, both Buyer contact fields present, readable parties/methods/items/totals, no clipped content. It contains sample data only at `output/pdf/purchase-order-preview.pdf`.
- `docker compose config --quiet` and `git diff --check` passed. Gitleaks found no leaks in the affected tracked-source diff (**195.48 KB**) or new sources/tests/report (**85.60 KB**); the staged scan found no staged content. A broader binary-diff scan was stopped and is not reported as complete.

## Local readiness and remaining checks

The exact context migration was applied to local development, the local queue worker was reloaded, and `php artisan materyalph:order-documents` prepared the updated renditions. All **12 local Purchase Orders** have ready version-5 private PDFs, Buyer email/mobile and valid canonical context hashes. Original-record fingerprints for **all 19 issued documents** remain unchanged. All original and current private PDFs pass their stored checksums. Metadata exposes only one Purchase Order per order. A second sweep queued **0** documents.

Other environments must apply the new migration through their normal release process, reload queue workers and run `php artisan materyalph:order-documents` or allow the existing five-minute sweep. No new keys or credentials are required. No hosted deployment, commit or push occurred.

The complete backend/mobile/web suites were not rerun for this update. Earlier broad Buyer verification encountered missing golden baselines from concurrently deleted evidence files, and an earlier Vendor full run had a Vite asset-server timeout; those broad gates are not reported as clean. Real-browser download/save acceptance and physical-phone save/cancel acceptance remain manual checks.

Suggested commit: `fix(documents): consolidate order details in purchase orders`.
