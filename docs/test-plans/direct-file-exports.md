# Direct file exports

Owner request: 4 November 2026. Buyer, Vendor and Admin export controls start generation and download the requested document when ready, without asking for a reason or requiring another Generate/Download click.

The shared web component covers Admin audit PDF/CSV, analytics, fee statements and tax packages, plus Vendor orders, transactions, statements and Earnings. The shared Buyer component covers order/payment documents and project/budget reports. Existing direct CSV and attachment downloads keep their current behavior.

Each available document type has its own action. Requests keep the current record, format and filters, supply an automatic audit purpose and retain their idempotency key on an uncertain request failure. Queued work polls its exact export ID through paginated history. A manual retry can resume a known snapshot after a failed transfer or cancelled native save. Failed, revoked, expired, missing and invalid files do not save. Context/session changes and unmounting suppress stale delivery.

No migrations, API behavior changes, generated-client changes or new configuration keys are required. Server authorization, Admin recent authentication, immutable snapshots, private storage, 24-hour expiry, checksum validation and access auditing remain in force. The native save-location picker is controlled by the operating system.

Automated coverage:

- `apps/admin-web/src/lib/audit-export-workspace.test.tsx`: direct Admin/Vendor PDF/CSV, document choices, filters, duplicate clicks, pagination, terminal states, transfer retry, stale work, PDF validation and history access.
- `apps/admin-web/src/lib/document-export-verification.test.ts`: required verification and the single authorized retry.
- `apps/admin-web/src/pages/GeoExportButton.test.tsx`: geographic PDF/CSV use the shared direct download and preserve every applied geographic/transaction filter.
- `apps/vendor-web/src/lib/document-export-download.test.ts`: browser blob URL lifetime.
- `apps/vendor-web/src/pages/OrderPages.test.tsx`: document actions remain in Order information alongside messaging.
- `apps/buyer-mobile/test/document_export_button_test.dart`: direct save handoff, queued generation, 320px header, terminal states, invalid PDF, cancelled save, idempotency and stale work.

Manual acceptance remains required in a real browser and on a phone: export each available document/format, wait for a queued export, complete required Admin verification, inspect the resulting file, cancel/retry a native save, and check expiry/access-revocation failures. Confirm private storage and a running export worker in the target environment. No deployment is part of this change.

## Validation recorded on 4 November 2026

- Admin: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` passed; `npm.cmd run test -- --run` passed 276 tests in 41 files.
- Vendor: the same lint/typecheck/build commands passed; `npm.cmd run test -- --run` passed 761 tests in 82 files. Lint reported an unused `inStore` variable in the existing `e2e/admin-finance-layout.spec.ts`. The suite emitted a jsdom navigation diagnostic and exited successfully.
- Buyer: `analyze --no-pub` reported no issues; `test --no-pub --reporter expanded` passed 650 tests with 1 skipped. These ran through the installed `dart.exe` and `flutter_tools.snapshot` because the restricted environment's Flutter batch wrappers stalled. The 11 focused export tests also passed.
- Contract: `npm.cmd run validate`, `npm.cmd run test:notifications-contract` and `npm.cmd run test:admin-operations-contract` passed; validation reported 8 unused-model recommendations and the Admin check covered 31 operations.
- Both web builds reported bundle-size warnings. These did not fail the builds.
- Gitleaks found no leaks in the changed diff and new files; the staged scan had no staged content. `git diff --check` passed.
- Backend PHP tests and infrastructure checks were not run for this client-only change. No credentials, new environment keys, migrations or API changes are required. Browser/device acceptance remains pending; no deployment occurred.

Suggested commit: `fix(exports): download directly without reason prompts`.
