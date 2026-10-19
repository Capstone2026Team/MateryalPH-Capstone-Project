# Contact Us and Support Requests

Owner-approved enhancement, 2026-10-19. Support is separate from procurement conversations and never changes an order, payment, verification or dispute outcome.

## Entry points

- Vendor public navigation: `/contact`; signed-in Vendor history: `/support/requests` and `/support/{ticketId}`. Portal header includes Support. Public `/support` retains a Contact Us entry.
- Buyer Profile → Help Center → Contact Us / My Support Requests. Support notification targets open the corresponding ticket.
- Admin `/support` and `/support/{ticketId}`. `support.view` and `support.manage` are granted to existing Super Admin and Support Staff roles. No financial, enforcement or verification authority is granted by assignment.

## Contract and limits

`/api/v1/support/{buyers|vendors|admin|guest}` fixes transport and audience server-side. Lists and history use opaque cursors. The newest history page is chronological; Load earlier retrieves older entries. Creation, replies and Admin updates require `Idempotency-Key`. Updates require `lock_version` and a reason. User-supplied references assist investigation and never grant access to the referenced resource.

Statuses: Open, In Progress, Waiting for User, Resolved, Closed. A user follow-up reopens Waiting for User or Resolved to Open. Closed requests require an Admin to reopen before a reply. Every message, status change and assignment preserves the actual actor and role at that time. Assignment reasons are visible to the user.

Attachments: at most three JPG/PNG/PDF files per message, each at most 3 MB (the total stays within existing upload transport limits). Reuse content validation, fail-closed scanning and private storage. File reads require current ticket ownership or support permission and a clean, referenced file. No direct storage URL is returned.

Guest intake uses existing CSRF, a blank honeypot, 30 requests per minute per IP, and submission/access-email limits of 10 per hour per IP and 5 per hour per hashed identity. A receipt has only the opaque ID, ticket number and status. Guest access emails return the same acknowledgement for matching and nonmatching requests.

Guest links have 256 random bits, are hashed in the database, expire after 24 hours, and are single-use. Tokens travel only in the encrypted outbox, email and URL fragment. The frontend removes the fragment before exchange. Exchange creates a 30-minute ticket-scoped Secure HttpOnly SameSite=Strict cookie; requests recheck expiry. No guest list exists. Anyone with an email link has its authority until consumption/expiry, so the email explicitly says not to forward it.

## Runtime setup

Apply the new migration using the normal approved migration procedure: `php artisan migrate --path=database/migrations/2026_10_28_000000_create_support_requests.php` from `services/api`. The new migration was applied independently to the development API after confirming it was the only pending migration. No earlier migration was rerun.

Reuse existing `FRONTEND_VENDOR_URL` (HTTPS for guest email links), `COOKIE_SECURE=true`, private file disk, scanner, mail transport and worker/outbox configuration. No new provider credentials or realtime infrastructure. Restart the existing local worker after updating the code (`docker compose restart horizon`); its long-running PHP process must load the new outbox handler. This restart remains a local runtime step because the automatic approval service could not complete later command reviews. Keep `MAIL_DELIVERY_NOT_BEFORE` activation behavior. Authenticated notifications use current authorization before dispatch. Guest access mail uses the same queued sealed outbox and sanitized mail provider, with bounded retries.

No arbitrary new retention duration is introduced. Support history uses the `SUPPORT_HISTORY` file class and append-only records; the administration must include this data in its established retention and privacy review. The on-form notice explains purpose, access, retention, data minimization and access/correction requests. Privacy design follows the [NPC publication of RA 10173, Section 11](https://privacy.gov.ph/data-privacy-act-/) on purpose, proportionality and retention. This implementation does not constitute a legal compliance certification.

## Automated checks

- API: `php artisan test --compact --filter=SupportRequestsTest` in guarded `api-test`: creation, idempotency, authoritative identity, ownership, role denial, replies, state/version checks, assignment, guest links/cookies, validation, rate limiting, private files/scanner failures and append-only constraints.
- API regression: NotificationInboxTest, PhaseFifteenNotificationsTest and OutboxDeliveryTest in the same isolated stack, serially.
- Contract: `npm run validate` and `npm run test:support-contract` from `packages/api-contract`, after generating/building clients.
- Web component checks: `npm run test -- --run src/pages/SupportPages.test.tsx` from both `apps/vendor-web` and `apps/admin-web`; both portals also run lint/typecheck/build. Admin status tabs preserve applied search/category/user-type/date filters, reset pagination, keep unfinished filter drafts and ignore late responses from a previously selected status. The same shared tabs support keyboard navigation.
- Admin received-date filtering reuses the shared All dates dialog and its Asia/Manila presets/calendar. Dialog Apply updates the current request view immediately and resets pagination; Cancel preserves the applied range, open-ended bounds are supported, and All dates removes both date bounds while retaining other applied filters.
- Buyer: focused support repository/widget checks and affected-file analysis, then the repository Flutter gates.

## Manual acceptance

Submit a guest request from desktop and a narrow screen; verify email receipt, expired/single-use access, follow-up, attachment viewing and a fresh-link request. Confirm a different email/ticket or expired session cannot read anything. With a Vendor and Buyer account, submit, refresh, reply, reopen a resolved case, view notifications and inspect protected attachments. As Support Staff, exercise search/category/type/date/status filters, assignment/unassignment, stale-version conflict, close and reopen. Confirm an unrelated Admin role is denied. Verify keyboard flow, screen-reader labels, mobile text scaling, loading, offline, validation and retry states. Real mailbox delivery, real scanner readiness, browser layouts and physical-device file selection require runtime acceptance.

## Verification record - 2026-10-19

- Isolated support suite: 11 passed, 89 assertions. An additional queued guest-email test was subsequently added; the expanded 12-test rerun was not executed because automatic approval review failed with a model-capacity error. Final timestamp/fingerprint and stricter Admin permission refinements also need that rerun.
- NotificationInboxTest, PhaseFifteenNotificationsTest, OutboxDeliveryTest: 20 passed, 139 assertions.
- New web component tests: 5 passed, including duplicate-click prevention, retry keys, empty/history states and clearing private data after access loss.
- Full Admin suite: 132 passed (24 files). Full Vendor suite: 581 passed, 7 failed (OrderPages.test.tsx and VendorNavigation.test.tsx); unrelated order controls/payload and banner expectations are not changed by this feature.
- Both portal lint/typecheck/build commands completed. Generated TS build, OpenAPI validation (8 unused-model recommendations), and support contract checks completed. Contract verifies 10 operations across 26 routes and both multipart clients.
- Pint and PHPStan passed. Gitleaks scanned the feature source files with no leaks. Scoped diff whitespace check passed; the whole-workspace check still reports existing README, landing CSS and FeeAssessment-generated-file whitespace.
- Dart serializers built successfully. The initial affected-file analysis found two StateMessage parameter errors, nullable-field warnings and four brace notices; these were corrected. Final analysis and Flutter tests remain unverified: SDK analytics/state/cache writes are outside the sandbox, and automatic approval review was unavailable due to model capacity. Syntax formatting completed with telemetry suppressed, with a warning about inaccessible flutter_lints in the global Pub cache.

Remaining commands (normal developer terminal):

```powershell
# Repository root, isolated database only
& 'C:/Users/RJ/AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe' compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --filter=SupportRequestsTest
& 'C:/Users/RJ/AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe' compose restart horizon
cd apps/buyer-mobile
flutter analyze
flutter test test/support_repository_test.dart test/buyer_help_center_test.dart
```

Real mailbox delivery, real scanner readiness, browser/device acceptance and the full API/Flutter suites were not verified.
