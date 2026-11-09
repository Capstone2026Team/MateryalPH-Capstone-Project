# Admin order audit and dispute context — 7 November 2026

## Outcome

Audit Log now contains Audit events and Orders & refunds tabs. The transaction tab has paginated all-history orders, online refunds and cash reimbursements. Order search supports reference, Buyer or public Vendor name, status, payment method and submitted dates. Refunds support status, trigger and requested dates. Cash reimbursements use recorded dates. Opening an order and returning preserves the transaction filters and page.

Every dispute detail links its own order through “View full order · read only,” retaining its case and queue context. The shared order presentation includes recorded items and quantities, commercial version, calculation breakdown, project context where applicable, delivery/pickup terms, NRPC, online payment attempts, cash payment records, fulfillment milestones/evidence, open cancellation requests, cancellation decisions, refunds/reimbursements and state history. There are no commercial mutation controls in this view.

## Files changed for this task

- API domain: added `services/api/app/Domain/Orders/AdminOrderAudit.php`; extended `OrderQueries.php` with passive Admin list/detail projections and `AdminOrderOperationsService.php` with cash reimbursement pagination and linked order IDs.
- Transport: added `services/api/app/Http/Controllers/Api/AdminOrderAuditController.php`; updated `AdminOrderOperationsController.php` and `services/api/routes/fulfillment.php`.
- Shared UI: added `packages/web-ui/src/order-audit-details.tsx`; updated its `index.ts` export and the strict order-evidence path allowlist in `web-api-session.ts`.
- Admin: added `src/pages/OrderAuditPages.tsx`, `src/lib/order-audit-api.ts`, related tests and `src/test/order-audit-fixture.ts`; updated `App.tsx`, `AuditSearchPage.tsx`, `DisputePages.tsx`, `DisputePages.test.tsx` and `lib/order-operations-api.ts`.
- API coverage: extended `PhaseTwelveFulfillmentTest.php` and `PhaseThirteenDisputesTest.php`.
- Browser coverage: added `apps/vendor-web/e2e/admin-order-audit.spec.ts` using the existing shared portal Playwright setup.
- Contract: updated `packages/api-contract/openapi.yaml`, regenerated TypeScript/Dart outputs, and added `scripts/check-order-audit-contract.mjs`.
- Workflow/design: recorded the requested behavior in `MateryalPH_Final_Admin_Workflow.md` and `MateryalPH_UI_UX_Implementation_Planner.md`.

No database migration, role grant, configuration key or new secret is required. Existing unrelated workspace changes were retained.

## API and authorization

All paths are under `/api/v1`:

| Method and path | Authorization and behavior |
| --- | --- |
| `GET /admin/order-operations/orders` | Existing `orders.operations.view`; paginated safe list. |
| `GET /admin/order-operations/orders/{orderId}` | Existing `orders.operations.view`, or `disputes.view` plus a matching `case_id`; audited passive detail. |
| `GET /admin/order-operations/orders/{orderId}/files/{fileId}` | Rechecks the same access and case/order relationship for every request; streams only authorized referenced evidence; audited and private/no-store. |
| `GET /admin/order-operations/reimbursements` | Retains `orders.operations.view`; adds `page`, `order_id` and pagination metadata, replacing the previous fixed first-100 bound. |

Existing audit-event permissions remain separate. The case-scoped path does not grant access to unrelated orders. Order reads do not run expiry, reconciliation, refund retry or state transitions. Provider identifiers and hosted checkout URLs are withheld; action arrays are empty and payment/fulfillment actions unavailable. Existing commercial commands retain their own permissions and behavior. Exact inventory and private staff contact projections are not added.

## Verification

| Check | Exact result |
| --- | --- |
| API: `php artisan test --compact tests/Feature/Api/PhaseTwelveFulfillmentTest.php tests/Feature/Api/PhaseThirteenDisputesTest.php` | **43 passed, 2,164 assertions.** |
| API: mixed-payment cancellation test after adding cash reimbursement pagination assertions | **1 passed, 54 assertions.** |
| PHP Pint `--test` on the eight affected PHP files | **8 files passed.** |
| `vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | **No errors.** |
| Admin `npm.cmd run lint`, `typecheck`, `build` | **Passed.** Build retains the large-chunk advisory. |
| Admin full `npm.cmd run test -- --run --maxWorkers=2` | **372 passed; one Vite configuration test timed out at 5 seconds.** |
| Isolated Vite configuration rerun: `npm.cmd run test -- --run vite.config.test.ts --maxWorkers=1 --testTimeout=30000` | **1 passed.** |
| Final focused Admin audit/dispute/evidence tests | **21 passed in 3 files.** |
| Playwright order-audit browser at 320, 390 and 1440 CSS px | **3 passed.** Opens/returns from orders, browses refunds/cash records, checks no mutation controls or requests and no page overflow. Screenshots inspected. |
| Retired Tracking route/navigation browser checks at the same widths | **6 passed.** Standalone Orders & Refunds/Invoice pages remain retired. |
| `npm.cmd run validate` in API contract | **Passed**, with eight unused-model recommendations. |
| Order audit, fulfillment and dispute contract scripts | **Passed.** Existing fulfillment/dispute checks cover 34 and 62 operations respectively. |
| Generated TypeScript `npm.cmd run build` | **Passed.** |
| Generated Dart `build_runner build` | **Passed.** The CLI reports the legacy `--delete-conflicting-outputs` option is ignored. |
| Dart analyze of affected Admin API and reimbursement model/generated serializer | **No issues found.** |
| Docker Compose configuration | **Passed.** |
| `git -c core.autocrlf=false diff --check` | **Passed.** |
| Gitleaks directory scans of affected Admin/shared UI, order domain, API controller and API test directories | **No leaks found.** Staged scan also ran but contained zero staged bytes. |
| Running local Admin client and API route | Optimized client contains `listAdminAuditOrders`; unauthenticated order-list request returns **401**. |

API tests used a separate task-specific PostgreSQL container after the first attempt collided with another suite on the shared test database and deadlocked during migrations before assertions. The separate-database runs above passed; the development database was not migrated or reset.

Browser checks use synthetic API responses. They establish rendering/navigation behavior, not authenticated production-data or live-provider acceptance. The full API suite, full Vendor suite and full Flutter suite were not run for this Admin-focused task. Nothing was deployed, pushed or merged.

Suggested commit: `feat(admin): add read-only order audit and dispute order context`
