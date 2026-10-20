# Dispute detail decision-list repair — 2026-10-20

Vendor and Admin case pages failed with `json.decisions.map is not a function`. `DisputeQueries::summary()` returns `decisions` as an integer count. The detail presenter combined that summary with a decision list using PHP's left-preserving array union (`+`), which kept the count instead of the list. It affected Buyer detail responses and assigned Fulfillment Staff's limited view as well.

## Changes and contract

- `services/api/app/Domain/Disputes/DisputeQueries.php`: replace the union with `array_replace` when adding full or limited detail fields. Detail responses now contain `decisions: []` or a list of immutable decisions. Queue/list summaries retain their integer count.
- `services/api/tests/Feature/Api/PhaseThirteenDisputesTest.php`: add a regression covering filing, zero and one recorded Admin decision, Buyer/Vendor/Admin details and summaries, and assigned Fulfillment Staff's redacted view.
- No migration, OpenAPI schema, generated client, portal UI, credential, or configuration changes. The existing `DisputeDetail.decisions` array and `DisputeSummary.decisions` integer schemas already describe the correct behavior.

Authorization, current-assignment checks, restricted Fulfillment visibility, private evidence access, immutable decision history, dispute timing, and refund rules remain unchanged. Limited details return an empty decision list even when a decision exists.

## Validation

Commands below ran against the existing isolated `materyalph_phase1_test` Compose project (`compose.test.yaml`, `api-test`, `postgres-test`, `redis-test`).

| Check | Result |
| --- | --- |
| New feature test before the fix | Reproduced the defect: `data.decisions` was `0`, expected `[]`. |
| `php artisan test --compact --no-ansi --filter=test_detail_decisions_are_lists_while_summaries_keep_counts_for_every_audience` | 1 passed, 57 assertions. |
| `php artisan test --compact --no-ansi --filter='(PhaseThirteenDisputesTest::(?!test_invoice)\|PhaseThirteenRulesTest)'` | 12 passed, 410 assertions. Covers seven dispute feature tests and five rule tests; the separate invoice feature test was excluded. |
| `vendor/bin/pint --test app/Domain/Disputes/DisputeQueries.php tests/Feature/Api/PhaseThirteenDisputesTest.php` | Passed, 2 files. |
| `vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | Passed, no errors, using the repository configuration. |
| Vendor `npm run test -- --run src/pages/DisputePages.test.tsx --maxWorkers=1` | 9 passed. |
| Admin `npm run test -- --run src/pages/DisputePages.test.tsx --maxWorkers=1` | 6 passed. |
| `node packages/api-contract/scripts/check-disputes-contract.mjs <isolated-route-export.json>` | Passed, 58 operations. Fresh routes exported with `php artisan route:list --json -v` in isolated `api-test`. |
| Pre-edit snapshot diff and added-line whitespace review | Passed; changes confined to the presenter and new regression test. No Git commands used. |

## Manual acceptance and scope

Refresh the Vendor and Admin dispute case pages. A newly filed case should open with its timeline and available actions; a decided case should show its decision history. Assigned Fulfillment Staff must retain only their limited evidence view.

Browser/device acceptance, full application suites, and live provider calls were not run. No setup keys, data repair, database migration, or client rebuild is required for this API-only repair.

Suggested commit: `fix(disputes): return decision arrays in case details`
