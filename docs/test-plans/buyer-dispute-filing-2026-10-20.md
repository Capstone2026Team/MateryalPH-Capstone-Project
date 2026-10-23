# Buyer dispute filing repair — 2026-10-20

The generated multipart clients sent selected line IDs under an unbracketed key (CSV in TypeScript, repeated scalar parts in Dart). Laravel requires `affected_line_ids[]` to receive an array. Evidence uploads had the same `files` versus `files[]` mismatch. The Buyer screen also discarded the API's field details and displayed only “Review the highlighted fields and try again.”

## Changes

- `packages/api-contract/scripts/generate-clients.mjs`: normalize Buyer and Vendor dispute multipart line IDs and evidence to PHP array parts. Regenerated both clients through `npm run generate`; no generated files were edited manually.
- `packages/api-contract/openapi.yaml`: document the wire encoding and the existing requirement for Buyers to select affected lines for every remedy. No endpoint, domain rule, response shape or migration changed.
- `packages/api-contract/scripts/check-disputes-contract.mjs`: prevent array encoding regressions in both clients.
- `apps/buyer-mobile/lib/design_system/components/form_validation.dart`: shared field-error extraction, including indexed array errors, and accessible error text for checklists and attachments.
- `apps/buyer-mobile/lib/features/disputes/dispute_screens.dart`: require an affected item for every remedy; display local and server validation beside the corresponding controls; retain the complaint and selection after rejection; include context errors without an editable control in the summary.
- `apps/buyer-mobile/lib/features/disputes/disputes_repository.dart`: correct the multipart documentation.
- `apps/buyer-mobile/test/disputes_repository_test.dart`, `disputes_test.dart`, `disputes_fakes.dart`: real generated-client transport checks for one/two selected lines, with/without evidence; return-and-refund selection validation; inline indexed API errors and preserved input; retain offline retry coverage.

Pre-edit file snapshots were compared without Git commands. Regeneration changed exactly six existing files: the Buyer/Vendor dispute API implementations in Dart and TypeScript, plus the two Dart API documentation files. The screen diff is confined to filing and its validation import.

## Validation

| Check | Exact result |
| --- | --- |
| New transport tests before regeneration | Both original cases failed: no `affected_line_ids[]` values were sent, reproducing the defect. |
| `npm run generate` in `packages/api-contract` | Passed for TypeScript and Dart. |
| `flutter test --no-pub test/disputes_test.dart test/disputes_repository_test.dart --name '^(?!invoices show\|a mismatched invoice)' --reporter expanded` in `apps/buyer-mobile` | 16 passed: 12 dispute behavior tests and 4 generated-client transport cases. |
| `flutter analyze --no-pub` in `apps/buyer-mobile` | Passed, no issues. |
| `npm run build` in `packages/api-contract/generated/typescript` | Passed, CommonJS and ESM outputs. |
| `npm run validate` in `packages/api-contract` | Passed; 8 unused-model recommendations. |
| `node packages/api-contract/scripts/check-disputes-contract.mjs <isolated-route-export.json>` from repository root | Passed, 58 operations including transport, authorization, signed links, idempotency and refund-destination checks. Routes were exported with `php artisan route:list --json -v` inside isolated `api-test`; native PHP route export timed out. |
| Isolated API `php artisan test --compact --no-ansi --filter=test_filing_creates_a_case_and_dispute_state_only_refuses_refund_destinations_and_links_duplicates` | 1 passed, 62 assertions. |
| Broader isolated API `php artisan test --compact --no-ansi --filter=PhaseThirteenDisputesTest` | 6 passed, 1 failed, 345 assertions. The unchanged invoice upload permission test expected 403 and received 422 at `PhaseThirteenDisputesTest.php:499`. |
| Broader Flutter `flutter test --no-pub test/disputes_test.dart test/disputes_repository_test.dart --reporter expanded` | 17 passed, 1 failed. The unchanged invoice copy request scenario did not reach `requestInvoice:COPY`; running that scenario alone reproduced the failure. |
| Redacted Gitleaks directory scan of changed source/client files | Passed, no leaks. |

The API tests ran only in the existing `materyalph_phase1_test` Compose project using `compose.test.yaml`, `api-test`, `postgres-test` and `redis-test`. No development database migration or data repair was performed. The first Flutter compile hit a full C: drive; validation completed after setting `TEMP` and `TMP` to a task-specific directory on D:.

## Security and manual acceptance

Authorization, server-owned eligibility and refund amounts, original-payment destination restrictions, private/scanned evidence, and idempotency are preserved. No credentials, environment values or new setup keys are required.

Hot restart the running Buyer app (`R` in the `flutter run` terminal), reopen **File a dispute**, and submit **Return and refund** with an affected item and a description of at least 20 characters. Repeat with an optional supported attachment. Physical-device submission, live storage/scanner delivery and provider refunds were not exercised in this task. The separate invoice failures above remain outside this repair; the broad suites are not fully green.

Suggested commit: `fix(disputes): encode multipart arrays and show field errors`
