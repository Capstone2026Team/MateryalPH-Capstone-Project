# Buyer project archives and cancelled-order rescanning

## Behavior

- Cancelled project-order details offer **Rescan Suppliers**. The server verifies Buyer ownership, the actual `CANCELLED` state, current order version, unchanged Work Package original, active Project/package and replacement eligibility. The Buyer shell opens the existing matching/selection screen; grouped orders reopen their existing arrangement and source uncovered quantities without disturbing peers.
- The existing selection transaction, idempotency records and active-order unique indexes create one new replacement order. No cancelled order, accepted snapshot, saved requirements or supplier ranking formula is rewritten.
- Projects and Work Packages can be archived only if every associated order is `COMPLETED`, `CANCELLED`, `DECLINED` or `EXPIRED`. Every other order state blocks the action. Checks include direct, missing-line and tagged purchases across all saved originals, including hidden packages. The legacy Project `PATCH` archive path uses the same service.
- Archived Projects leave the active Projects list. Independently archived Work Packages leave the active package list. Archived Items has two tabs and remains inside the existing Buyer shell and bottom navigation.
- Archive cards show the saved budget, archive timestamp, deletion timestamp, remaining days, Restore and Delete Permanently. Confirmations, loading, disabled explanations, explicit retry and success/error feedback reuse Buyer components. Timestamps display in Asia/Manila.
- Archived package budget allocations remain reserved until permanent removal; restoration preserves the budget without introducing an allocation conflict. FIN-11 continues to exclude unpaid cancelled obligations from pending spend while retaining actual cancellation costs and paid amounts awaiting recovery in their existing buckets.

## Database and retention

Migration: `services/api/database/migrations/2026_11_09_180000_add_project_procurement_archives.php`.

| Table | Added columns |
| --- | --- |
| `projects` | `archived_at`, indexed `delete_after`, `archived_from_status`, `deleted_at` |
| `work_packages` | `archived_at`, indexed `delete_after` |

Both archive timestamps are nullable `TIMESTAMPTZ`. Database checks require both together and enforce `delete_after = archived_at + interval '720 hours'`. Project status/archive fields must agree. Existing legacy Archived Projects receive a full new 30-day restoration period during migration. Work Package and order status vocabularies are unchanged.

`materyalph:procurement-archives-prune` runs every minute through Laravel's existing scheduler with `withoutOverlapping()`. It scans indexed expired deadlines in bounded chunks, locks the parent Project and relevant packages, re-reads current archive/deletion fields and terminal-order eligibility, and removes only still-eligible expired workspace items. A restore clears both timestamps under the same parent lock. A newer archive window is also rechecked, so an old scan cannot delete a restored or recently re-archived item.

**Permanent removal is an irreversible Buyer-workspace deletion using retained tombstones.** Immutable saved originals, materials, quotations, messages, orders, payments, refunds, financial and audit records remain in the database with their references intact. Project removal tombstones only its own packages. It does not physically purge commercial history or shared saved addresses, catalog materials, Vendors or other Projects. This follows the existing MateryalPH retention policy and database immutability triggers.

Restore is available strictly before the deadline. A Project returns to its saved Active or Completed state. Work Package restoration requires restoring an Archived parent first; independently archived children retain their own retention window. Cancelled orders remain cancelled. Manual deletion and scheduled removal repeat terminal-order checks and record audit/outbox events.

## API

All paths are under `/api/v1`, authenticated with native Buyer bearer transport and Buyer ownership.

| Method/path | Purpose |
| --- | --- |
| `GET /buyers/archived-items?type=PROJECT\|WORK_PACKAGE&page=1` | Paginated owned archive tab |
| `POST /buyers/projects/{itemId}/archive` | Archive eligible Project |
| `POST /buyers/projects/{itemId}/restore` | Restore Project before expiry |
| `POST /buyers/projects/{itemId}/permanent-deletion` | Remove archived Project and its packages from workspace |
| `POST /buyers/work-packages/{itemId}/archive` | Archive eligible Work Package |
| `POST /buyers/work-packages/{itemId}/restore` | Restore Work Package before expiry |
| `POST /buyers/work-packages/{itemId}/permanent-deletion` | Remove archived Work Package from workspace |
| `POST /buyers/orders/{orderId}/rescan-suppliers` | Authorize rescan and return the same Work Package for existing sourcing |

Archive lifecycle POSTs require a UUID `Idempotency-Key` and `{ "lock_version": currentItemVersion }`. Rescan accepts the current **order** lock version; it creates no order. Matching and selection continue through existing endpoints. Project/package summaries expose `archived_at`, `delete_after`, `can_archive` and `archive_blocker`; Buyer order project context exposes rescan eligibility. Existing detail/order-history reads remain available until workspace removal, and retained order history remains readable afterward.

New ordering, tagged checkout, matching, inquiries and quotation acceptance all recheck active procurement. Checkout locks every referenced tagged package before locking the cart, even when the Buyer has not explicitly linked the eventual Item-Based order to a package. No client-only eligibility check grants authority.

## Files

Created:

- `services/api/app/Domain/Projects/ProjectArchives.php`
- `services/api/app/Http/Controllers/Api/BuyerProjectArchiveController.php`
- The archive migration above
- `apps/buyer-mobile/lib/design_system/components/archive_item_action.dart`
- `apps/buyer-mobile/lib/features/projects/project_archives_screen.dart`
- `apps/buyer-mobile/test/project_archives_test.dart`
- This report

Updated:

- API Project domain: `ProjectService`, `ProjectBudget`, `ProjectEstimateService`, `ProjectArrangements`, `WorkPackageAlternatives`, `WorkPackageOrderRecovery`.
- API order/commerce integration: `OrderQueries`, `OrderSubmissionService`, `CartService`, `QuotationService`, `OutboxProcessor`; `routes/projects.php`, `routes/console.php`.
- API tests: `PhaseTenProjectsTest`, `WorkPackageAuthoringTest`, `CheckoutOptionsTest`.
- Added `ProjectArchiveMigrationTest` for legacy-archive migration coverage.
- Buyer Projects: repository, main/details screen and supplier-selection eligibility.
- Buyer navigation: order details/list/submission, checkout, procurement navigation, messaging and Buyer home; order-test fixtures.
- `packages/api-contract/openapi.yaml`, generated TypeScript/Dart clients and serializers, and `scripts/check-projects-contract.mjs`.
- Buyer workflow and UI/UX planner owner-request notes.

Existing unrelated local edits are preserved. Generated outputs also reflect the contract changes that were already present in the workspace.

## Validation and setup

Validation completed:

- Isolated PostgreSQL 16 guard passed.
- Explicit API regression files: **99 passed, 2,542 assertions** (202.04 s): `PhaseEightOrdersTest`, `OrderConcurrencyTest`, `CheckoutOptionsTest`, `WorkPackageSourcingTest`, `WorkPackageAuthoringTest`, `WorkPackageSpecificationTest`, `PhaseTenProjectsTest`, `PhaseTenProjectCalculationsTest`.
- Legacy archive forward-migration test: **1 passed, 6 assertions** (7.71 s). Total backend coverage: **100 passed, 2,548 assertions**. Fresh-database migration was also exercised by the isolated feature suites.
- Buyer tests: **57 passed** with `--concurrency=1` (41 s) across archives, transport, orders, authoring, budgets, group routes and inquiries. An earlier concurrent run had one countdown assertion report three refresh calls instead of two; the same tests passed sequentially. No countdown implementation was changed.
- After the final archived arrangement/checkout controls, the affected archive, group-route and inquiry subset passed again: **17 passed** (39 s).
- Buyer Dart analysis: **No issues found**. Generated Dart build runner completed successfully.
- PHPStan: **No errors**. Focused Pint: **27 files passed**, plus the new migration test and package-lock recheck passed their formatting check.
- OpenAPI validation passed with eight unused-model recommendations; Project contract checks passed for **43 protected operations**, including the new archive metadata and mutation contracts.
- Generated TypeScript client build passed.
- Compose configuration, `git diff --check`, staged Gitleaks, and Gitleaks directory scans of the API and Buyer source passed. The staged scan contained no staged files; directory scans covered the working source.

The additive migration was applied to the verified local **development** API as batch **83**. The local scheduler is running, and `schedule:list` confirms the cleanup command runs every minute. The local queue service was gracefully reloaded for the new archive event registrations. No new credentials or environment keys are required.

Other environments still need `php artisan migrate` through their normal API/release process, a queue-worker reload and the existing scheduler running (`schedule:work` in local Compose, the supervised scheduler service in the VPS setup, or cron invoking `php artisan schedule:run` every minute). The cleanup command can also be invoked manually with `php artisan materyalph:procurement-archives-prune`.

No deployment or manual permanent deletion of development procurement records was performed. Live device/native-map/provider acceptance and the complete monorepo test suite remain separate acceptance gates.

Suggested commit: `feat(buyer): add procurement archives and cancelled-order rescanning`
