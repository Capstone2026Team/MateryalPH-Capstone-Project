# Enforcement dialog, proof and notifications

Implemented 8 November 2026.

## Behavior

- Buyer and Vendor profile **Open Enforcement** buttons open a centered dialog for the exact profile, without another search. The generic Enforcement queue retains subject search.
- The compact dialog shows account facts, the action and its effects, a mandatory reason, applicable restoration/continuation fields, and optional proof. Its action footer stays visible while the fields scroll.
- Attach up to five JPG/PNG/PDF files (10 MB each) or MP4/MOV videos (25 MB each), within configured limits. Review/remove selections before submission. Failed decisions retain selections and reuse successful uploads and the original idempotency key on an unchanged retry.
- **Record warning & notify** / **Apply sanction & notify** records the existing decision and queues the affected Buyer or active Vendor Owner's mandatory email and in-app notice. The profile confirms the recorded/queued result. Foreground Buyer and Vendor clients display unread enforcement notices with acknowledgement and retry.
- Proof remains private for authorized enforcement review. Recorded attachments cannot be edited, deleted or reused for another decision. Email and push contain the notice, without attaching private proof.

## Files and contract

- Admin: `apps/admin-web/src/pages/EnforcementPages.tsx`, `UserDirectoryPages.tsx`, and `src/lib/operations-api.ts`; dialog/profile component tests.
- Shared: `packages/web-ui/src/evidence-files-picker.tsx`, `enforcement-notice-popup.tsx`, `operations-patterns.tsx`, `file-selection-review.tsx`, `private-evidence-gallery.tsx`, `web-api-session.ts`, and exports.
- Buyer: `apps/buyer-mobile/lib/features/notifications/notification_scope.dart`, `lib/main.dart`, and `test/enforcement_notice_test.dart`.
- Vendor: `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx`, popup tests, and a date-independent read-state fixture in `notification-inbox-state.test.ts`.
- API: `EnforcementFiles`, `EnforcementService`, `AdminOperationsController`, `routes/admin-operations.php`, and feature tests.
- Migration: `2026_11_08_120000_create_enforcement_evidence.php` adds immutable evidence links with restrictive foreign keys. Applied successfully to the running **development** API; isolated tests also ran the migration from an empty test schema.
- `packages/api-contract/openapi.yaml` adds subject-scoped proof upload, record-scoped signed-link/content operations, record `evidence_file_ids`, detail `evidence`, and subject `recordable_actions`. TypeScript and Dart clients and Dart serializers were regenerated; the TypeScript package was rebuilt. The new transport check is `npm run test:enforcement-evidence-contract`.
- Admin workflow and UI planner document the requested entry, layout, evidence and notice behavior.

## Authorization and delivery

Upload and record require `enforcement.view` plus `enforcement.apply`; the server returns only recordable actions, including Permanent Ban only with `enforcement.ban`. Existing recent-authentication and sanction rules remain intact. Attachments must belong to the same subject and recording Admin, pass content validation and fail-closed malware scanning, and be unreferenced before attachment. Downloads require `enforcement.view`, a valid five-minute signature and an exact record/file relationship; opening proof is audited. No client calls private storage or a provider directly.

Existing notification records, post-commit outbox, mail delivery/retry and recipient policy are reused. Suspensions retain mandatory Buyer session revocation; an authenticated in-app popup cannot outlive access revocation. Email and configured device push remain the delivery paths when the recipient is signed out.

## Verification

Passed:

- API Admin operations, notification and realtime suites: **34 tests, 742 assertions**, including real MP4/PDF validation, cross-subject/uploader denial, scanner failure, immutable links, signed access, replay protection and one mocked email send.
- Admin dialog, directory and Phase 16 component suites: **28 tests**.
- Vendor popup, notification workspace and inbox-state suites: **16 tests**, including an old session's delayed acknowledgement being unable to dismiss a newer account notice. The read-state fixture now tests all dates explicitly, so its fixed October timestamps do not age out of today's default date filter.
- Buyer popup, inbox controller and notification-screen suites: **10 tests**, including new notices while idle, acknowledgement and removal when access ends.
- Full Buyer `flutter analyze --no-pub`: clean. The final popup/test-specific analyzer rerun is also clean.
- Admin and Vendor lint, TypeScript checks and production builds; generated TypeScript build; Dart serializer generation.
- The running Admin development server returned the updated source and optimized generated client, including both new evidence methods; no stale client module was served.
- OpenAPI validation, Admin operations/user directory/platform monitoring contract checks, and the new enforcement transport check.
- API PHPStan: no errors. Pint on the six affected PHP files: passed. Compose configuration: passed. Diff whitespace check: passed. Scoped current-source secret scan: no leaks in 63.97 KB; the separate staged scan had no staged content.

Representative commands (run from the relevant app/package, or through the isolated API container):

```text
php artisan test tests/Feature/Api/PhaseSixteenAdminOperationsTest.php tests/Feature/Api/PhaseFifteenNotificationsTest.php tests/Feature/Api/NotificationRealtimeTest.php
php vendor/bin/phpstan analyse --memory-limit=512M
npm run test -- --run src/pages/EnforcementDialog.test.tsx src/pages/UserDirectoryPages.test.tsx src/pages/PhaseSixteenPages.test.tsx --maxWorkers=2
npm run test -- --run src/lib/enforcement-notice-popup.test.tsx src/lib/notifications-workspace.test.tsx src/lib/notification-inbox-state.test.ts --maxWorkers=2
flutter test --no-pub --timeout 45s test/enforcement_notice_test.dart test/notification_inbox_controller_test.dart test/phase15_notifications_screen_test.dart
flutter analyze --no-pub
npm run validate
npm run test:enforcement-evidence-contract
```

## Acceptance still required

The browser automation host was unavailable, so desktop/mobile browser visual acceptance remains manual. Real mailbox receipt and physical-device push were not tested; email assertions used a fake mail transport. Existing configured mail, queue/outbox workers, private storage, malware scanner and video validator must remain operational. No new credential names are introduced. Production bundles retain existing large-chunk warnings. Full monorepo suites were not run.

For another environment, apply the new migration through its normal release process:

```text
php artisan migrate --path=database/migrations/2026_11_08_120000_create_enforcement_evidence.php
```

Suggested commit: `feat(enforcement): add proof dialog and user notices`
