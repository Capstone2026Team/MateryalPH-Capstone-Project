# Order document PDF layout - 4 November 2026

Historical layout verification. The later [Purchase Order details update](purchase-order-details.md) supersedes the active document kinds and layout version below; it retains the earlier immutable files.

The Purchase Order and payment confirmation now use an A4 portrait template with an order-reference header, record status/date, a material/quantity/unit/unit-price table, aligned accepted totals, and separate payment details. Dates render in Asia/Manila. Recorded payment amounts and accepted order totals remain distinct. Monetary strings are formatted without floating-point conversion or recalculation. Unknown source fields are retained and escaped.

The large notice strip was removed at the owner's request. A compact footer retains sample/not-tax-invoice/BIR-filing labels, the order reference and page numbering. The frozen source hash remains in secondary record-integrity information. Item headings repeat across continuation pages; payment blocks and summary rows avoid splitting.

## Implementation and compatibility

- `OrderDocumentLayout.php` presents existing frozen rows. `reports/order-document.blade.php` supplies the layout; `DocumentRenderer` selects it only for Purchase Orders and payment confirmations. Other reports retain their existing renderer, and CSV output retains its existing behavior.
- Migration `2026_11_04_220000_create_order_document_renditions.php` adds immutable layout/file history, restrictive foreign keys and a unique document/layout-version constraint. Earlier migrations were not edited.
- `OrderDocumentService` issues layout version 2 from the same source snapshot. Its existing background sweep queues missing renditions and does not republish pending or failed jobs. Outbox/operator recovery remains in use. No layout generation occurs during a metadata read or download.
- Downloads and metadata select the current rendition while retaining the original source/file. Private storage, CLEAN-file checks, checksums, current order authorization and download audit remain enforced. API paths, response schemas and client code did not change.
- Workflow, architecture and UI-planner clarifications record the presentation/retention behavior.

## Local verification

- The guarded isolated Compose environment passed static/live isolation, Passport-key and negative-case checks.
- The final focused run covered layout formatting, HTML escaping, Manila dates, payment evidence labels, real PDF pagination, original-file preservation, retry idempotency, immutable rendition history, authorization, downloads and existing CSV/report exports: **26 passed, 1 warning, 398 assertions**. The warning comes from the unchanged `TabularDocumentRendererTest` calling `gzuncompress` on an uncompressed stream; its assertions passed.
- PHPStan completed **574 files with no errors**. Pint formatted/checked the six affected PHP files.
- Both final synthetic previews were rasterized and inspected: Purchase Order **1 page**, payment confirmation **1 page**. A 70-item long-specification fixture rendered **11 pages**, retained all 70 items, and had no text blocks outside page margins. First, continuation and final pages were visually checked.
- The exact new migration was applied only to local development. The local queue worker was reloaded and 19 new layout versions were generated. A before/after fingerprint confirmed all 19 original document records were unchanged; all original and new private files passed their stored checksum checks.
- A second local sweep queued zero additional documents. Changed-file/new-file Gitleaks scans and the diff whitespace check passed.
- Synthetic review copies are `output/pdf/purchase-order-preview.pdf` and `output/pdf/payment-confirmation-preview.pdf`; they contain sample data only.

Other environments need the new migration and a reloaded queue worker, then `php artisan materyalph:order-documents` (or the existing five-minute sweep) to prepare missing layout versions. No new environment keys are required. No hosted deployment occurred. The complete backend suite and live browser/native-save acceptance were not run for this PDF change.

Suggested commit: `fix(documents): redesign order PDFs with retained layout history`.
