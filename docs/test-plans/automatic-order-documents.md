# Automatically issued order documents

Historical verification record. The later [Purchase Order details update](purchase-order-details.md) supersedes payment-confirmation generation/download and adds party/contact/method details. Counts and test results below describe the earlier implementation.

Owner request, 4 November 2026: prepare the MateryalPH Purchase Order and payment confirmation automatically so an authorized user can download an existing PDF from Admin, Vendor or Buyer. Export reasons and separate generation steps were removed in the preceding direct-file-export change.

## Result

- Final order acceptance queues the Purchase Order from the accepted commercial snapshot.
- Confirmed full-order online payment or fully recorded physical collection/online-balance evidence queues the payment confirmation. Order completion alone is not payment evidence. Physical collections remain identified as Vendor-recorded.
- Each order has at most one issued document of each kind. The source snapshot and issued file reference are immutable commercial history. Downloads reuse the private PDF and do not create a `data_exports` record or renew a report-copy expiry.
- The Vendor E-Invoices document rows show a Download PDF action for each ready document and retain the Not a tax invoice label. Shared Admin/Vendor order actions and Buyer order actions download the same retained documents. Queued documents are polled automatically; missing payment, failure and restricted-access states remain visible.
- Other report exports retain their existing contextual snapshot, recent-authentication requirements where applicable, audit purpose, permissions, 24-hour expiry and direct-download behavior.

## Files and contract

- `services/api/database/migrations/2026_11_04_180000_create_order_documents.php`: new retained-document table, unique order/kind, restrictive foreign keys, state checks and an immutability trigger. No applied migration was edited.
- `services/api/app/Domain/Reporting/OrderDocumentService.php`: automatic preparation, historical sweep, queued rendering, private storage, metadata and authorized downloads. `DocumentSnapshot.php` exposes the existing order projection for reuse.
- `OrderTransitionService`, `PhysicalPaymentService`, `OutboxProcessor`, `ProcessOutboxEvent`, `JobHealthService` and `routes/console.php`: transactional preparation, post-commit work, bounded retries/operator recovery and a five-minute historical sweep.
- `ReportingController`, `routes/notifications.php`, `InvoiceQueries` and `packages/api-contract/openapi.yaml`: retained-document metadata and read/download routes. TypeScript/Dart clients and Dart serializers were regenerated from OpenAPI.
- `packages/web-ui/src/document-export-dialog.tsx`, `packages/web-ui/src/dispute-patterns.tsx`, Vendor `InvoicePages.tsx`, Buyer `notifications_repository.dart` and `document_export_dialog.dart`: shared download behavior. Buyer invoice attachment code also received theme-token and brace corrections needed by analysis.
- Workflow, architecture and UI-planner owner clarifications distinguish retained order documents from expiring ad hoc exports.

New authenticated endpoints, under each existing Admin, Vendor or Buyer API prefix:

| Method | Path | Behavior |
| --- | --- | --- |
| GET | `/orders/{orderId}/documents` | List the two document kinds and their availability, generated timestamp, checksum and authorized download URL. |
| GET | `/orders/{orderId}/documents/{kind}/download` | Return an already generated PDF attachment; no generation side effect. |

Allowed kinds are `PURCHASE_ORDER` and `PAYMENT_CONFIRMATION`. Availability is `AFTER_ACCEPTANCE`, `AFTER_PAYMENT`, `QUEUED`, `READY` or `FAILED`. Optional metadata fields were added to `PlatformDocumentRef`; existing invoice duties and financial rules are unchanged.

## Authorization and integrity

The service reuses current Buyer ownership and Vendor membership/role/assignment checks. Admin access requires the existing invoice-view permission. Each download rechecks access after reading private storage, verifies the stored checksum, and records a download audit. A queued or unavailable file returns a structured error. Client session clearing, order changes and unmount/disposal prevent stale responses from saving a file. Duplicate clicks do not issue parallel downloads.

## Local setup and evidence

The exact new migration was applied to the existing local development container. Its worker and scheduler were reloaded, then `php artisan materyalph:order-documents` queued the historical backfill. A development-only check confirmed:

| Kind | Ready PDFs |
| --- | ---: |
| Purchase Order | 12 |
| Payment confirmation | 7 |

No accepted completed local order lacked a Purchase Order. A sampled private PDF passed its magic-byte and SHA-256 checks. The backfill processes up to 200 eligible orders per invocation; the scheduled sweep continues any remainder. Other environments must apply the migration through their normal release process and keep the existing queue worker and scheduler running. No new credentials or environment keys are required. No hosted deployment was performed.

## Verification recorded on 4 November 2026

- API: `OrderDocumentsTest`, `PhaseFifteenExportsTest`, `PhaseElevenFinanceFlowsTest` and `PhaseThirteenDisputesTest` passed **42 tests / 1,281 assertions** in the guarded isolated Compose environment. Coverage includes automatic issuance, real PDF bytes, idempotency, immutable sources, >24-hour reuse, cross-account denial, membership revocation, checksum failure, failed-worker recovery, Admin access and physical-payment evidence.
- Order/fulfillment regression: `PhaseEightOrdersTest` and `PhaseTwelveFulfillmentTest` initially passed 49 of 51 tests. Two upload-file-count assertions assumed no automatic order files; they now compare the count before/after the attempted upload. Both affected tests passed on rerun, **2 tests / 92 assertions**, preserving rejection, revocation and replay checks.
- PHP: Pint passed all 14 initially affected PHP files and the adjusted fulfillment test; PHPStan completed all 573 files with no errors.
- Admin: lint, typecheck and production build passed. The full suite passed **283 tests in 42 files** with `npm.cmd run test -- --run --maxWorkers=2`.
- Vendor: lint, typecheck and production build passed. Invoice/dispute focused tests passed **23 tests**; the later invoice and Vite asset-access rerun passed **13 tests** with one worker and a 15-second test timeout. The complete suite (`npm.cmd run test -- --run --maxWorkers=1 --testTimeout=15000`) finished with **764 passed and 1 failed in 82 files**. Its only failure was the Vite asset-server test timing out; that test passed in the isolated rerun. The full-suite gate is not reported as clean.
- Buyer: the focused export, notification and dispute tests passed **36 tests**. Full `flutter analyze --no-pub` passed with no issues. The complete suite (`flutter test --no-pub --concurrency=2 --reporter expanded`, through the installed SDK) finished with **602 passed, 1 skipped and 51 failed**; all 51 failures report missing golden-image baseline files.
- Contract: `npm.cmd run validate`, `test:order-documents-contract`, `test:notifications-contract` and `test:disputes-contract` passed. OpenAPI validation reported eight unused-model recommendations. Generated TypeScript build and Dart serializer generation passed.
- `docker compose config --quiet`, the workspace diff whitespace check and Gitleaks diff/new-file scans passed. The staged scan found no staged content and no leaks.

Earlier broad web runs timed out; their affected tests passed when rerun with fewer workers. A later broad Vendor run and Buyer run were interrupted before their final summaries, so those partial runs are not reported as passes. Web builds reported bundle-size warnings; Vendor lint reported the existing unused `inStore` variable, and jsdom emitted a navigation diagnostic.

The full Buyer run encountered missing golden-image baselines under `docs/design/evidence`. Git confirms those tracked evidence files are deleted in the current working tree; this change does not restore or replace that concurrent work. The full Buyer gate cannot be reported as passing while those files are absent. The focused download tests and full analysis pass.

The complete backend suite was not run. Real-browser download/save acceptance and physical-phone save/cancel acceptance remain manual checks. No deployment, commit or push occurred.

Suggested commit: `fix(documents): generate order PDFs automatically`.
