# PS Mark / ICC sticker register lookup

Approved by the project owner on 2026-10-17 and recorded in the Vendor and Admin workflows. The Vendor supplies only the marking number: the **PS License No.** (`Q-1234`) or the **ICC sticker serial** (`A500000001`). The active DTI-BPS register snapshot confirms the number and pre-fills the manufacturer or importer, product, brand, model or type and standard. If the register cannot confirm the number, nothing is submitted. The Vendor edits the number, retries, or explicitly selects **Request manual review**.

## Rule `compliance.register-number.v2`

| Result | Condition | Vendor sees | Submission |
| --- | --- | --- | --- |
| `MATCHED` | PS: the licence number is listed (`Q-894`, `q 0894` and `0894` all match `Q-0894`). ICC: the serial falls inside a listed sticker serial range. The record's product or PNS standard covers the listing's regulated product, and the record has not expired. | The register record, then **Submit for automatic verification** | `VERIFIED` system decision (`reviewer_user_id` null) |
| `UNCERTAIN` | Listed, but for another product (`PRODUCT_NOT_COVERED`) or on an expired record | Reason, the listed record, Edit / Try again / Request manual review | None, unless review is requested |
| `UNMATCHED` | Not listed (`NUMBER_NOT_FOUND`), wrong shape (`NUMBER_FORMAT`), or an ICC certificate number typed instead of the serial (`CERTIFICATE_NUMBER_GIVEN`) | Reason, Edit / Try again / Request manual review | None, unless review is requested |
| `UNAVAILABLE` | No active snapshot of that register | Reason, Request manual review | None, unless review is requested |

A marking photo or QR image is still mandatory evidence. PNS designations compare without their edition year or adopted-standard body (`PNS ISO 13006:2019` = `PNS 13006`).

## Register access

The official Google Sheets disable download, print and copy for viewers. The CSV export returns 401 and the Drive API returns 403. The platform does not scrape the sheets.

- **Admin import (default).** Product Compliance › Registers accepts the file DTI-BPS provides as `.xlsx` or `.csv` in the official layout. Title and note rows are skipped. In the ICC list, the sticker range comes from separate **ICC Sticker Serial No. (From)** / **(To)** columns (the CSV export layout) or from the merged **ICC Sticker Serial No.** heading (the spreadsheet layout). Placeholder cells such as `N/A`, `Not Applicable` and `Not indicated` are dropped. An ICC file without serial ranges is rejected. Import creates a DRAFT that an Admin activates.
- **Authorized feed (optional, off by default).** Set `COMPLIANCE_REGISTER_PS_FEED_URL` / `COMPLIANCE_REGISTER_ICC_FEED_URL` and allow-list the host in `COMPLIANCE_REGISTER_FEED_HOSTS`. `materyalph:compliance-registers-sync` runs daily at 03:15 Asia/Manila and skips unchanged files. It creates a DRAFT, or activates it when `COMPLIANCE_REGISTER_FEED_AUTO_ACTIVATE=true` and the new file has at least 90% of the active snapshot's rows. A failed download keeps the active snapshot.
- An active snapshot older than 45 days is flagged **stale** on the register list and on the Integration Health card **DTI-BPS PS and ICC registers**.

## OCR and QR

- **QR.** The browser decodes the image with the native `BarcodeDetector` where one exists, otherwise with jsQR. jsQR covers Chrome, Edge and Firefox on Windows, where `BarcodeDetector` is absent. An ICC sticker photo on the photo path is also scanned for its QR code. The serial is found anywhere in the payload, including a verification URL.
- **OCR.** Server-side Tesseract reads the full image, then enlarges the lower marking area as a text block and a single line. This targets the small licence/serial below the PS logo or ICC QR code. Four passes share one configured time budget; a failed pass keeps earlier readings. It tolerates spaces (`Q - 6 3 7 8`, `A 500 000 001`) and misread labels. Look-alike characters fan out to bounded candidate readings (`AS000000G1` → `A500000001`). The register picks the listed reading, and the upload reports `register_listed`. Placeholder artwork (`Q-XXXX`) supplies no number.

## Product information

The compact DTI-BPS panel sits immediately above Core details in Product information. Standard requirements and submission history expand on demand. Product photos remain a separate step, with compliance blockers linking to Product information.

After confirmation and a matched submission, register brand/model values populate the product; PS records also supply manufacturer/address and `PH` when explicitly Local. Empty or oversized fields preserve existing values, and ICC importers never become manufacturers. Registered product, standard and importer details remain available in the submission summary after reload. The transaction audits the applied values and captures the verified fingerprint after applying them. The editor saves pending changes before submitting and refreshes the form from the response.

## Automated coverage

- `CatalogComplianceRulesTest`: normalization of licences, serials and standards; product relevance; QR payloads (URL, labelled fields, type hint).
- `MarkingTextParserTest`: real Tesseract misreads, ambiguous readings kept as candidates, and the ICC certificate kept apart from the serial.
- `TesseractComplianceTextExtractorTest`: two-pass process bounds; real engine recognition of synthetic PS Mark and ICC sticker fixtures (when Tesseract is installed).
- `PhaseFourCatalogComplianceTest`: number-only auto-verification with register prefill; product mismatch, unlisted number and draft snapshot (nothing submitted); explicit manual review; ICC range matching and the certificate-number hint; OCR/QR candidate resolution; lookup authorization (role, ownership, regulated only); XLSX import; feed sync (not configured, host not allow-listed, draft, unchanged, guarded activation, failed download).
- Vendor `CatalogPages.test.tsx` and `qr-decode.test.ts`: browser QR to automatic verification, debounced lookup, Edit / Try again / Request manual review, mandatory photo, register change at submission, and the decoder fallback order.
- Admin `ProductCompliancePages.test.tsx`: manual-review flag, `.xlsx` upload and stale snapshot warning.
- `test:catalog-contract`: lookup operation, `review_mode`, `register_listed` and `source_channel`.

## Manual acceptance

1. Admin: import the current PS and ICC lists from DTI-BPS, then activate both.
2. Vendor, Windows Chrome: in Product information above Core details, choose ICC sticker › QR code, upload a real sticker photo, and confirm the serial and importer appear and automatic verification succeeds. Confirm brand/model populate the listing, importer is labelled separately, and the registered details remain after reload.
3. Photograph a real PS Mark: confirm the licence number is read, or type it, and that the manufacturer is pre-filled.
4. Type an unlisted number: confirm nothing reaches the Admin queue until **Request manual review** is sent.

Accuracy on real packaging photos (glare, curvature, holograms) needs manual testing on devices.

## Verification — 2026-10-27

| Gate | Result |
| --- | --- |
| Isolated PostgreSQL configuration/live guards and negative cases | Passed |
| Compliance parser, Tesseract, catalog rules and catalog API files | 57 tests passed, 838 assertions; includes actual Tesseract on synthetic PS/ICC artwork, private evidence, authorization, register prefill, fingerprint, missing-field preservation and retirement of comparison assignments for the old brand |
| Vendor catalog, form and QR components | 30 tests passed |
| Admin product compliance components | 5 tests passed |
| Chromium compact panel at 320, 390 and 1440 px, fixture API | 3 tests passed; no horizontal overflow; desktop/mobile screenshots reviewed |
| Whole API Pint and PHPStan (512 MB) | Passed |
| Vendor/Admin lint, typecheck and builds | Passed; existing Vendor finance-fixture unused-variable warning and bundle-size warnings remain |
| OpenAPI validation / catalog contract | Passed; 8 existing unused-model recommendations / 30 operations |
| TS client build; generated Dart model/serializer analysis | Passed |
| Compose configuration, staged/diff secret scans, whitespace | Passed |

No migration, new environment key or provider credential is required. Active PS/ICC register snapshots are still required for automatic verification. This scoped run does not establish whole-system, real-provider or physical-camera acceptance. No deployment was performed.

Suggested commit: `fix(catalog): improve marking OCR and apply verified register details`
