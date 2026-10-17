# Work Package requirement version actions — 2026-10-15

> **Superseded 2026-10-16.** Work Package versioning was removed from the Buyer app and API: edit, reactivate and delete now act directly on the one package. See the Buyer workflow, Work Package Lifecycle. The text below describes the retired behaviour.


## Outcome

Each saved requirement version has visible Reactivate, Edit and Delete actions. Controls wrap at compact widths and large text sizes. Current versions are labelled. Active/quotation-inquiry requirements cannot be reactivated while already current; cancelled current requirements can be copied into a new Active version. Current versions cannot be deleted from history.

Reactivate revalidates the selected version's materials, site and budget, creates a new version, invalidates estimates/active quotation requests and locks the copy atomically. Edit prefills the existing editor from the selected snapshot while submitting the latest package lock version and source version ID. Saving creates a new current Draft. Cancelling the editor changes nothing. Selected work still follows order cancellation rules before revision.

Delete removes an older version from the visible Buyer history after confirmation. Its snapshot, lines and linked messages, quotations and orders remain intact. An immutable deletion record retains the actor and time. The server reports `can_delete_draft` so the existing whole-Draft delete control respects locked or removed history, including history outside the loaded page.

## Files and contract

- Buyer: `lib/design_system/components/work_package_version_history.dart`; Project screen, repository and Work Package editor; history interaction and authoring tests.
- API: `ProjectService`, `BuyerProjectController`, `WorkPackageRequest`, `routes/projects.php`, `WorkPackageAuthoringTest`.
- Migration: `2026_10_20_000000_add_work_package_version_deletions.php`; creates only `work_package_version_deletions` with restrictive foreign keys and append-only mutation protection. Existing locked-version triggers remain unchanged.
- Contract: `openapi.yaml`, `scripts/add-work-package-history-contract.mjs`, `scripts/check-projects-contract.mjs`; regenerated TypeScript/Dart clients and Dart serializers.
- Documentation: Buyer workflow, UI/UX planner, generated ERD/data dictionary, this report.

New operations:

| Method | Path | Request/result |
| --- | --- | --- |
| POST | `/buyers/work-packages/{packageId}/versions/{versionId}/reactivate` | Current package `lock_version` and UUID `Idempotency-Key`; returns authoritative `WorkPackageViewResponse` |
| DELETE | `/buyers/work-packages/{packageId}/versions/{versionId}` | Same concurrency/idempotency requirements; returns updated visible history |

`WorkPackageInput.source_version_id` optionally identifies the visible source version in this same package and is recorded in the audit trail. `WorkPackageView.can_delete_draft` reports whole-Draft deletion eligibility. All operations use the generated mobile Buyer bearer transport, current Buyer ownership, Active Project enforcement, resource-version checks, transaction boundaries, audit and outbox paths. Replays do not create duplicate versions or deletion records.

## Verification

| Check | Result |
| --- | --- |
| Isolated `api-test php artisan test --compact --no-ansi tests/Feature/Api/WorkPackageAuthoringTest.php tests/Feature/Api/PhaseTenProjectsTest.php tests/Feature/Api/WorkPackageSourcingTest.php` | **26 passed, 551 assertions**, 37.21 s. Covers immutable originals, cancelled-current reactivation, hidden history, idempotency, ownership, cross-package source rejection, stale/closed/selected guards, budget rollback and deletion-history protection. |
| Buyer `flutter test test/work_package_version_history_test.dart test/projects_authoring_test.dart test/projects_phase_ten_test.dart --name '^(?!.*(?:Project authoring and ranking reflow\|Project map uses the locked site)).*$' --reporter expanded` | **24 passed**, 5 s. Includes per-version callbacks, current/read-only/selected/busy controls, cancelled-current reactivation, 320 px / 2x text wrapping and selected-version editor payload. The actual regular expression uses a plain `|` alternation; the backslash here escapes the Markdown table separator. |
| Buyer `flutter analyze` | **No issues**, 53.4 s. |
| Pint `--test` on changed PHP files | **Passed**. |
| `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | **No errors**. |
| `npm run validate` in `packages/api-contract` | **Passed**, eight unused-model recommendations. |
| `npm run test:projects-contract` | **Passed**, 27 protected documented operations. |
| Client generation + Dart `build_runner build` | **Completed** from OpenAPI; generated serializers updated. |
| Vendor/Admin `npm run typecheck` | **Both passed**. |
| `docker compose config --quiet` | **Passed**. |
| Isolated `materyalph:schema-document --check` | **Passed**. |
| Changed authored-file `git diff --check` | **Passed**. |
| Gitleaks directory scans: Buyer Project feature, shared Buyer components, API Project domain, contract scripts | **No leaks found**. Staged scan had zero staged bytes. |

The broader three-file Flutter run before the final cancelled-current test reported **25 passed, 3 failed**: saved Project list screenshots at 390/1024 px and the authoring screenshot at 390 px. The desktop list failure also encountered Windows error 1224 while writing an existing mapped diff image. No golden reference images were changed. The final functional run excludes the two screenshot test-name groups (five parameterized cases), rather than claiming those screenshot checks passed.

The repository-wide whitespace check also reports an existing blank line at EOF in `apps/vendor-web/src/lib/auth-api.ts:187`, outside this change. Full application suites, portal UI tests and device acceptance were not run.

## Local readiness and manual acceptance

Development `migrate:status` showed all existing migrations applied and only the new history migration pending. Applied that migration alone via `docker compose exec -T api php artisan migrate --path=database/migrations/2026_10_20_000000_add_work_package_version_deletions.php --no-interaction --no-ansi`; it completed in 303.72 ms. A subsequent `migrate:status --pending` reported **No pending migrations**. This is separate from isolated test schema validation. No credentials or new key names are required.

Hot restart the Buyer app. On the phone, open a Work Package and expand Version history. Check older-version Reactivate, Edit/cancel/save and Delete/confirm behavior; current-version restrictions; then inspect linked procurement records and read-only archived history. Native/device acceptance remains manual.

Suggested commit: `feat(buyer): add work package version history actions`
