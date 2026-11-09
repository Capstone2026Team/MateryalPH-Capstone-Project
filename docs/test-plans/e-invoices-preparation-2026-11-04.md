E-invoices preparation and Send — local verification, 4 November 2026

The Vendor workspace now supports private invoice preparation, reusable business presets, review and explicit Send. New invoice dates default to today in Asia/Manila. Sending creates a separate immutable invoice record; a Buyer return or correction request permits a linked correction version. Buyer mobile displays the attachment above its invoice details and hides Request a copy once a sales invoice has been sent. Missing-copy sidebar tasks remain pending until Send.

Changed source files for this slice:

| Domain | Files |
| --- | --- |
| Vendor | `apps/vendor-web/src/pages/InvoicePages.tsx`, `src/lib/disputes-api.ts` |
| Shared web UI | `packages/web-ui/src/invoice-workspace.tsx`, `invoice-workspace.css`, `invoice-preset-fields.tsx`, `web-api-session.ts`, `index.ts` |
| Buyer mobile | `apps/buyer-mobile/lib/features/disputes/dispute_screens.dart`, `dispute_models.dart`, `disputes_repository.dart`, `lib/design_system/components/dispute_components.dart` |
| API | `services/api/app/Domain/Invoices/InvoiceService.php`, `InvoiceQueries.php`, `InvoiceOrderSummary.php`, `app/Http/Controllers/Api/InvoiceController.php`, `routes/disputes.php` |
| Migration | `services/api/database/migrations/2026_11_04_210000_add_invoice_preparation_workspace.php` |
| Contract | `packages/api-contract/openapi.yaml`, regenerated TypeScript/Dart invoice models and client methods, `scripts/add-invoice-workspace-contract.mjs`, `scripts/check-disputes-contract.mjs` |
| Tests | Vendor `InvoicePages.test.tsx`, `DisputePages.test.tsx`, `web-api-session-recovery.test.ts`, `e2e/invoices-layout.spec.ts`; Buyer `test/disputes_test.dart`, `test/disputes_fakes.dart`; API `tests/Feature/Api/PhaseThirteenDisputesTest.php` |
| Workflow/design | System, Vendor and Buyer workflows; `docs/design/MateryalPH_UI_UX_Implementation_Planner.md` |

Other existing workspace changes were preserved. This table identifies the invoice slice, rather than claiming ownership of every change in shared files or generated clients.

The additive migration creates `vendor_invoice_presets` and `invoice_drafts`, and adds `invoice_records.commercial_snapshot`. It was applied to the local development API with `php artisan migrate --path=database/migrations/2026_11_04_210000_add_invoice_preparation_workspace.php --no-interaction`. It also ran successfully from an empty isolated test database. Existing invoice records remain already-sent history. No deployment, push or merge occurred. No new environment keys are required.

The API contract adds:

- `GET /api/v1/vendor/invoices/preset` and `PUT /api/v1/vendor/invoices/preset`.
- `POST /api/v1/vendor/orders/{orderId}/invoices/send`.
- `GET /api/v1/vendor/invoice-drafts/{draftId}/files/{fileId}` with an expiring signature.
- Upload now saves a private draft, requires `lock_version`, and can omit the file when retaining an existing uploaded copy. Responses expose draft readiness, current version, presets, attachment metadata and accepted-order context. Buyer responses never contain drafts.

Draft, preset and Send mutations use the existing invoice-upload permission, store authorization, idempotency and optimistic concurrency checks. Files remain private and must pass content/scanning checks. Signed preview requests reauthorize the caller and are not automatically replayed on transient failures. Customer Service cannot open drafts or upload/send a copy. Sent document fields/files and their commercial snapshots remain immutable; corrections create new records. Accepted Buyer totals, included VAT arithmetic and protected-finance boundaries are preserved. Image previews use authorized bytes; PDFs use the secure Open action. TEST/sample labels remain visible.

Completed checks:

| Working directory | Command/check | Exact result |
| --- | --- | --- |
| `services/api` in isolated Compose project | `php artisan test tests/Feature/Api/PhaseThirteenDisputesTest.php --filter=invoice --compact` | 2 passed, 165 assertions |
| `services/api` | `vendor/bin/pint --test app/Domain/Invoices app/Http/Controllers/Api/InvoiceController.php database/migrations/2026_11_04_210000_add_invoice_preparation_workspace.php tests/Feature/Api/PhaseThirteenDisputesTest.php routes/disputes.php` | 8 files passed |
| `services/api` | `vendor/bin/phpstan analyse --memory-limit=512M --no-progress app/Domain/Invoices app/Http/Controllers/Api/InvoiceController.php` | No errors |
| `apps/vendor-web` | `npm.cmd run test -- --run src/pages/InvoicePages.test.tsx src/pages/DisputePages.test.tsx src/lib/web-api-session-recovery.test.ts --maxWorkers=2` | 53 passed across 3 files |
| `apps/admin-web` | `npm.cmd run test -- --run src/pages/DisputePages.test.tsx src/lib/session-recovery.test.tsx --maxWorkers=2` | 20 passed across 2 files |
| Both web portals | `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed; Vendor lint retains an unrelated unused-variable warning in `e2e/admin-finance-layout.spec.ts`; builds retain bundle-size warnings |
| `apps/vendor-web` | Playwright `invoices-layout.spec.ts`, Chromium projects `chromium-1440` and `chromium-320`, using `.tmp/invoices-playwright.config.ts` | 2 passed; screenshots inspected; popup and detail stay within viewport width; save/review/Send verified with synthetic API fixtures |
| `apps/buyer-mobile` | `flutter test --no-pub test/disputes_test.dart --reporter expanded` | 20 passed, including attachment ordering, 320px layout, MIME/filename preservation and a reason-bearing return with keyed offline retry |
| `apps/buyer-mobile` | `flutter analyze --no-pub` | No issues found |
| `packages/api-contract` | `npm.cmd run generate`, generated TypeScript build, Dart `build_runner build --delete-conflicting-outputs` | Completed; Dart reported the obsolete flag was ignored |
| `packages/api-contract` | `npm.cmd run validate` | Valid; 8 unused-model recommendations |
| `packages/api-contract` | `node scripts/check-disputes-contract.mjs ../../.tmp/invoice-routes.json` | 62 operations passed, including transport, signed links, idempotency and draft isolation assertions |
| Workspace | `docker compose config --quiet`, `git diff --check` | Passed |
| Workspace | Targeted Gitleaks scan of invoice source/generated files and workflow documents | No leaks found, 3.62 MB scanned |
| Workspace | `gitleaks git --staged --redact --no-banner` | No leaks; no staged bytes |

The PHP checks used the separate `materyalph_invoice_workspace_test` Compose project to avoid collisions with other test runs. Flutter/Dart commands used the installed SDK at `C:/Users/RJ/Documents/flutter`; the direct SDK entry point avoided the batch-wrapper startup stall. No SDK source changes were made.

Known limits and other results:

- A broader Vendor navigation run failed two onboarding tests. A focused rerun passed `pending selection survives a failed upload and Finish Later succeeds on retry`, but `Back to dashboard automatically preserves incomplete form progress` still failed because the expected `/Welcome back/` heading was absent. This was not classified as a pre-existing failure without an unchanged-baseline reproduction.
- Full repository-wide API, portal and Flutter suites were not completed for this slice. Earlier full-suite logs are not evidence for these final edits.
- Browser checks used synthetic fixtures. A physical Buyer device, live malware/provider integrations and deployment were not exercised.

Suggested conventional commit: `feat(invoices): add presets and private draft-send workflow`
