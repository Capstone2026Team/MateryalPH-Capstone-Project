Invoice queues and correction resubmission — 9 November 2026

Requests now contains first-copy requests awaiting Send. Sent/uploaded and downloaded requests remain retained history and no longer appear as pending Requests. Private drafts still require an explicit Send. Mismatches contains one latest invoice per affected order: Buyer returns, pending correction requests and unresolved total/VAT differences, including explained differences. Returns appear even when their recorded amounts match.

Prepare corrected invoice opens the existing upload form. Authorized invoice staff can change document details, keep the attachment or upload another PDF/JPG/PNG, review the saved private correction and Send it to the Buyer. The new document number and amendment link identify a new immutable version. Original document fields, attachments, explanations and commercial snapshots remain retained. Accepted Buyer amounts do not change. Applicable pending feedback is fulfilled together; an older mismatch does not remain in the work queue after a newer version replaces it. All sent versions remain in Uploaded/history.

Buyer feedback and the preparation action appear immediately below the invoice heading. Refreshing the same list preserves selection and draft review, while changing filters/orders keeps the existing loading and authorization boundaries. Explain-only controls have been removed from the Vendor page; previously recorded explanations remain visible and the existing explanation API stays compatible.

| Area | Files changed for this request |
| --- | --- |
| Vendor workspace | `apps/vendor-web/src/pages/InvoicePages.tsx`, `InvoicePages.test.tsx`, `apps/vendor-web/e2e/invoices-layout.spec.ts` |
| Shared presentation | `packages/web-ui/src/invoice-workspace.tsx` |
| Invoice rules and queries | `services/api/app/Domain/Invoices/InvoiceService.php`, `InvoiceQueries.php` |
| API regression coverage | `services/api/tests/Feature/Api/PhaseThirteenDisputesTest.php` |
| Contract | `packages/api-contract/openapi.yaml`, `scripts/check-disputes-contract.mjs`; regenerated TypeScript/Dart invoice models, API documentation and client method descriptions |
| Workflow/design | System and Vendor workflows, `docs/design/MateryalPH_UI_UX_Implementation_Planner.md` |

No migration, new route, request field, enum, environment key or manual data repair is required. Existing response fields describe the pending Buyer feedback on Mismatches rows. The contract documents the revised list rules, counts, correction eligibility and optional attachment reuse. Generated clients were regenerated through `npm.cmd run generate`; no generated file was edited manually. Unrelated workspace changes were preserved.

Server authorization still requires the invoice view/upload permissions and same-store order access. Customer Service remains status-only and cannot upload, Send, see drafts or open private invoice files. Metadata-only corrections reuse an attachment belonging to the authorized order. Send rechecks private visibility and CLEAN scan state. New file uploads retain the shared fail-closed validation and scanning path. Upload and Send remain version-checked and idempotent; audit and the existing Buyer notification/email delivery are preserved. Tests use fake providers and private local test files.

| Working directory/environment | Check | Result |
| --- | --- | --- |
| Isolated API test container | `php artisan test tests/Feature/Api/PhaseThirteenDisputesTest.php --filter=invoice --compact` | 6 passed, 434 assertions |
| Isolated API test container, final legacy-fixture update | `php artisan test tests/Feature/Api/PhaseThirteenDisputesTest.php --filter=invoice_amount_and_vat --compact` | 1 passed, 57 assertions; verifies a retained sent copy without a draft row |
| `services/api` | `php vendor/bin/pint --test app/Domain/Invoices/InvoiceService.php app/Domain/Invoices/InvoiceQueries.php tests/Feature/Api/PhaseThirteenDisputesTest.php` | Passed |
| `services/api` | `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress app/Domain/Invoices` | No errors |
| `apps/vendor-web` | `npm.cmd run test -- --run src/pages/InvoicePages.test.tsx src/pages/DisputePages.test.tsx --maxWorkers=2` | 32 passed across 2 files |
| Vendor and Admin portals | `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed; builds report bundle-size warnings |
| `apps/vendor-web` | `npx.cmd playwright test --config ../../.tmp/invoice-correction-playwright.config.ts invoices-layout.spec.ts --project=chromium-1440 --project=chromium-320` | 2 passed; final run 14.5 seconds; screenshots inspected |
| `packages/api-contract` | `npm.cmd run generate`, `npm.cmd run validate` | Completed; spec valid with 8 unused-model recommendations |
| `packages/api-contract` | `node scripts/check-disputes-contract.mjs` | 62 operations passed, including the added invoice queue/correction contract assertions |
| Generated TypeScript package | `npm.cmd run build` | Passed |
| Generated Dart package | `dart --suppress-analytics analyze lib/src/model/invoice_log_row.dart lib/src/model/vendor_order_invoices.dart lib/src/api/vendor_invoices_api.dart` | No issues found |
| Workspace | `docker compose config --quiet`, `git diff --check` | Passed |
| Workspace | `gitleaks git --staged --redact --no-banner` and targeted invoice source/contract scan | No leaks found |

The API tests ran via `docker exec materyalph_phase1_test-api-test-1 ...` against the existing isolated PostgreSQL 16 test environment. A native Windows run could not resolve the container-only `postgres-test` hostname, so its zero-assertion failures were replaced with the successful isolated runs. Dart verification needed access to its normal local analysis cache. The temporary browser preview was closed after validation.

Browser checks use synthetic authorized API fixtures. They verify correction form access, optional attachment reuse, readable desktop/mobile layout and the existing upload/review/Send flow; component/API tests cover replacement files, changed metadata, returns with matching totals, simultaneous feedback, VAT-only differences, failed-save retention, repeated Send, status-only roles and cross-store denial. Physical Buyer devices and live mail/scanning providers were not exercised. Full repository-wide test suites were not run. No deployment, push or merge occurred.

To repeat the browser command, build Vendor first and run `node node_modules/vite/bin/vite.js preview --host 127.0.0.1 --port 4191 --strictPort` from `apps/vendor-web` in a separate terminal; the temporary test config uses that preview.

Suggested conventional commit: `fix(invoices): correct queues and allow invoice resubmission`
