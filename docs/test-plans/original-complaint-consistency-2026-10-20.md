# Original complaint consistency — 2026-10-20

The description was already saved and returned to authorized viewers, but Vendor and Admin displayed it as an unlabeled paragraph. Buyer called every filing “Your complaint,” including cases originally filed by a Vendor.

All three surfaces now use **Original complaint** and show the same labeled fields: **Issue**, **Requested remedy** (including a requested amount when present), and **Buyer's description of the problem** or **Vendor's description of the problem**, according to the original `filed_by_party`. The saved text and line breaks are preserved. Blank or absent descriptions show “No problem description was recorded.”

## Files changed

- `packages/web-ui/src/dispute-patterns.tsx` and `index.ts`: add/export the shared `DisputeComplaintDetails` display and align issue wording with Buyer.
- `apps/vendor-web/src/pages/DisputePages.tsx` and `apps/admin-web/src/pages/DisputePages.tsx`: use the shared display inside their existing Original complaint sections.
- `apps/buyer-mobile/lib/design_system/components/dispute_components.dart`: matching reusable Flutter complaint fields.
- `apps/buyer-mobile/lib/features/disputes/dispute_screens.dart` and `dispute_models.dart`: use the component, correct the section title for either filer, and align issue/requested-remedy labels with web.
- Vendor/Admin `DisputePages.test.tsx` and Buyer `disputes_test.dart`/`disputes_fakes.dart`: cover both filing parties, multiline description preservation, absent descriptions, and existing dispute behavior.

No API behavior, OpenAPI schemas, generated clients, migrations, credentials, or environment configuration changed. Existing saved complaint and timeline records remain unchanged. The read-only display uses server-provided description, issue, remedy, amount, and filing-party fields. Authorization and Fulfillment Staff's limited view are preserved; the Vendor limited-view regression still verifies that the original complaint is hidden. Description text is rendered as text rather than HTML.

## Validation

| Area | Command/check | Result |
| --- | --- | --- |
| Vendor | `npm run lint` | Passed. |
| Vendor | `npm run typecheck` | Passed. |
| Vendor | `npm run test -- --run src/pages/DisputePages.test.tsx --maxWorkers=1` | 12 passed. |
| Vendor | `npm run build` | Passed. |
| Admin | `npm run lint` | Passed. |
| Admin | `npm run typecheck` | Passed. |
| Admin | `npm run test -- --run src/pages/DisputePages.test.tsx --maxWorkers=1` | 9 passed. |
| Admin | `npm run build` | Passed. |
| Buyer | `flutter analyze --no-pub` | Passed, no issues. |
| Buyer | `flutter test --no-pub test/disputes_test.dart test/disputes_repository_test.dart --name '^(?!invoices show\|a mismatched invoice)' --reporter expanded` | 19 passed. The two invoice scenarios are outside this complaint-display change and were excluded. |
| Buyer | `dart format lib/design_system/components/dispute_components.dart lib/features/disputes/dispute_models.dart lib/features/disputes/dispute_screens.dart test/disputes_fakes.dart test/disputes_test.dart` | Passed. |
| Cross-client copy | Compare all 13 issue labels and all 8 requested-remedy labels between shared web UI and Flutter | No mismatches. |
| Change review | Compare 11 edited source/test files against pre-edit snapshots; check added-line whitespace | Passed, no whitespace issues. No Git commands used. |

Both production web builds retain the existing advisory about chunks larger than 500 kB and a plugin-timing advisory; neither blocked the build. Checks are focused regressions, not full application-suite or browser/device acceptance. No API tests were needed for this presentation-only change.

## Manual acceptance

Refresh the Vendor and Admin case pages. Hot restart Buyer (`R` in its `flutter run` terminal), then reopen a case. Verify a Buyer-filed case and a Vendor-filed case: each should show the original filing party's description under the correct label on all three surfaces, including paragraph breaks, with the same issue and requested-remedy wording. Confirm that assigned Fulfillment Staff retain their limited view.

No setup keys, data repair, or database migration is required.

Suggested commit: `fix(disputes): show consistent original complaint details`
