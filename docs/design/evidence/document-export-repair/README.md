# Contextual PDF export repair — 2026-10-10

Documents & exports was removed from notification navigation in Vendor, Admin and Buyer. The shared popup is opened by Export PDF in the applicable section, with the source record and current report filters supplied by that section.

Vendor entry points: order details, commission statements, Transaction History, Earnings and Materials Analytics. Admin entry points: order refund/cancellation records, commission statements, reviewed tax packages, audit searches, geographic analytics and Materials Analytics. Buyer entry points: order details, Project reports, Project budget overview and Work Package context. Buyer supports native Save PDF and a separate Share action.

The runtime log showed repeated `EXPORT_EXPIRED` responses for a record that the old list still presented as READY. The new list presents expired artifacts as EXPIRED, and both clients remove the download action and explain regeneration. New requests retain their key on an uncertain failure and use a fresh key after a confirmed request. Generation validates PDF bytes before private storage, selects landscape A4 for wide reports, and preserves immutable source snapshots. Download verifies the checksum and current authority, provides attachment length, and returns a recoverable error if the file is absent. Web URLs are revoked after 60 seconds rather than immediately after the download click.

## Authored files

- Shared web UI: `packages/web-ui/src/document-export-dialog.tsx`, `notifications-workspace.tsx`, `index.ts`.
- Vendor: `apps/vendor-web/src/pages/{OrderPages,FinancePages,TrustPages}.tsx`, `src/lib/document-export-download.test.ts`, `e2e/phase-15-notifications.spec.ts`.
- Admin: `apps/admin-web/src/pages/{NotificationPages,OrderOperationsPage,FinancePages,AuditSearchPage,GeoAnalyticsPage,TrustPages}.tsx`.
- Buyer: `apps/buyer-mobile/lib/design_system/date_time.dart`, `lib/features/reporting/document_export_dialog.dart`, notification screen/repository, order details, Projects screen, `test/notifications_api_test.dart`.
- API: `services/api/app/Domain/Reporting/{DocumentExportService,DocumentRenderer,DocumentSnapshot,ExportAccess}.php`, `app/Http/Controllers/Api/ReportingController.php`, `app/Domain/Orders/AdminOrderOperationsService.php`, `resources/views/reports/document.blade.php`, `tests/Feature/Api/PhaseFifteenExportsTest.php`.
- Contract/documentation: `packages/api-contract/openapi.yaml`, `scripts/check-notifications-contract.mjs`, regenerated TypeScript/Dart clients and Dart serializers, `docs/test-plans/phase-fifteen-notifications-exports.md`.

No migration, development data mutation, deployment, credential change or commit was required. No Git commands were used.

## Contract and authorization

Report history adds optional `type`, `resource_id` and `format` filters before pagination. Export responses add optional nullable `resource_id` and report expired downloads accurately. `TRANSACTION_HISTORY` and `EARNINGS` use existing Owner-only finance projections, selected dates, integer-centavo formatting, immutable captured values and the Internal Operational Report notice. Admin cancellation records expose their source order ID for contextual exports. Source authorization, current membership, assignment, independent tax review, Admin recent authentication, private storage, checksums, 24-hour expiry and access audits remain enforced.

## Verification

| Check | Result |
| --- | --- |
| Isolated `tests/Feature/Api/PhaseFifteenExportsTest.php` | 9 passed, 155 assertions |
| `PhaseFifteenDocumentsTest` | 3 passed, 27 assertions |
| Explicit notification, Admin operations, materials analytics and finance regression files | 32 passed, 928 assertions |
| Total isolated backend checks | 44 passed, 1,110 assertions |
| Pint for the 10 selected reporting/controller/test files | Passed |
| Focused PHPStan for the six changed PHP source files | Passed |
| Latest full PHPStan | One finding outside the export changes: `VendorProductAnalytics.php:735`, `arrayValues.list` |
| Vendor and Admin lint/typecheck/build | Passed; existing large-chunk build warnings remain |
| Download attachment unit test | 1 passed |
| Buyer `flutter analyze --no-pub` | No issues found |
| Buyer `flutter test --no-pub --concurrency=1 test/notifications_api_test.dart` | 6 passed |
| OpenAPI validation | Passed with eight unused-model recommendations |
| Notification/export, Admin operations and portal date contract checks | Passed |
| TypeScript client build and Dart build_runner serialization | Passed |
| Compose configuration validation | Passed |
| Secret scans of shared web UI, portal source, Buyer reporting, API reporting and OpenAPI | No leaks |
| Whitespace review of 32 authored implementation/test/contract files | No findings |

The initial simultaneous Buyer analysis/test attempts exhausted Dart memory. After stopping the completed isolated test services and running checks sequentially, analysis and all six transport tests passed. The isolated test database was the only database used for tests, and those test services were stopped afterward.

UI/E2E, native save/share on a physical device, and a real portal session's download were not exercised. The existing queue worker is still required to process asynchronous exports. No new key names or manual schema setup are required.

Suggested commit: `fix(reporting): add contextual PDF export dialogs and reliable downloads`.
