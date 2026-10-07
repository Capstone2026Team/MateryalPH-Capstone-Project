# Phase 15 — Notifications, reminders and private exports

## Implemented boundary

The Laravel notification row is authoritative. Domain notices enqueue channel work after commit; channel destinations are deduplicated, device tokens and exceptional email recipients are encrypted, and attempts contain safe result codes only. Five attempts use bounded backoff. Provider failure leaves the original business transaction and in-app notice intact. Admin operational exceptions include failed deliveries, document generation and other exhausted outbox jobs.

Every notice resolution and queued delivery checks current account, membership, role, organization, delegation, dispute permissions and assignment as applicable. Finance notices and Vendor finance exports are Owner-only. Existing stock, onboarding, order and dispute event sources remain authoritative. Invitation delivery rechecks identity, expiry, consumption, revocation and the inviter's current authority.

Shared Vendor/Admin notification and export workspaces preserve the portal shells. Buyer has inbox, explained mandatory preferences, contextual device permission, authorized navigation and private document download/share. Web push remains disabled unless explicitly approved in backend configuration. No SMS is implemented.

Exports capture source data before queueing, render privately, record checksums and access, expire after 24 hours and recheck current authorization for generation and download. Purchase Orders, online/physical payment confirmations, Project summaries, budgets, operational orders, fee statements and authorized MAT aggregates support PDF/CSV. Physical confirmations identify Vendor-recorded payments; they do not imply provider settlement. Export sources and access history have database immutability guards. CSV cells neutralize leading formula characters, including whitespace-prefixed formulas.

Tax support covers 2307, 0619-E, 1601-EQ/QAP and 1604-E/annual alphalist. Packages preserve issuer, payee, calendar month, quarter, effective ATC, profile/rule versions, assessments and adjustments, including zero/exempt rows. Monthly totals remain separate from taxable-year threshold accumulators. Independent review with cited actual dates and reconciliation is required before export. Historical sources without a supported version require review; they are never guessed. Sample packages cannot become real government filing or payment evidence.

The demo ATC rule uses the synchronized FIN-08 mapping and the May 20, 2025 issuance boundary from [BIR RMO 26-2025](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%2026-2025%20Digest.pdf). The [BIR RMO 33-2025 clarification](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%2033-2025%20Digest.pdf) confirms the gross-remittance description. These references do not authorize real filing: the versioned non-eFPS demo calendar and independent deadline review remain required. Vendor goods invoices, platform fee invoices and processor documents are distinct. Uploaded PDFs do not establish structured e-invoicing compliance.

## Acceptance coverage

| Suite | Coverage |
| --- | --- |
| `PhaseFifteenDocumentsTest` | Calendar quarters/months/years, ATCs, mandatory classes, CSV injection |
| `PhaseFifteenNotificationsTest` | Deduplication, current deep-link authorization, optional and mandatory channels, encrypted/revoked devices, five attempts, sanitized failures, exact Owner recipients, expired/reused invitation, onboarding resume targets and redaction |
| `PhaseFifteenExportsTest` | Immutable PDF/CSV sources, checksum/private storage, idempotency, foreign/expired downloads, revoked queued and ready jobs, independent tax review, simulated evidence, payment sources, Project budgets, monthly totals, 15/7/1/overdue legal reminders, database history guards |
| `PhaseFifteenPushAdapterTest` | Fake OAuth/FCM HTTP, opaque push payloads, same-origin web worker, unregistered-device revocation, exception redaction |
| Existing payment/fulfillment/dispute suites | Closed hours do not extend payment expiry, refund/cancellation, receipt, clarification or appeal timing; dispute flag and assignment revocations remain enforced |
| Existing finance/MAT suites | Physical confirmation, Owner finance restrictions, FIN-04A, aggregate suppression and authorized export scope |
| `check-notifications-contract.mjs` | OpenAPI routes, generated operations, authorization/idempotency boundary |
| `notifications-workspace.test.tsx` | Explained mandatory classes, optional controls, offline retry and authorized resolution |
| `phase-15-notifications.spec.ts` | Both portals at 320, 375, 390, 768, 1024, 1280, 1440 and 1920px; revoked links/downloads, preferences, horizontal overflow |
| Buyer notification transport/screen tests | Generated decoding, binary download, revoked/expired response messages, preferences and 320px enlarged text |

## Migrations and contract

- `2026_10_11_000000_complete_phase_fifteen_notifications_exports.php`: notice/device/delivery attempts, source snapshots, private export access, tax package/calendar support.
- `2026_10_11_010000_add_phase_fifteen_job_access_and_tax_request_keys.php`: tax request idempotency and Superadmin operational-job permission.
- `2026_10_11_020000_protect_phase_fifteen_snapshot_history.php`: append-only attempts/access/tax lines and immutable export/tax source fields.

All are additive and forward-only. Tests rebuilding databases use the guarded isolated PostgreSQL test database; development data is not reset or seeded.

New `/api/v1/{buyers|vendor|admin}/notifications` operations cover listing, read, resolution, preferences and device registration/revocation. `/reports` covers request/list/download. Admin adds tax preparation/detail/review/simulation and delivery exceptions. OpenAPI and TS/Dart clients are regenerated from source; clients contain no backend credential.

## Setup and remaining runtime verification

1. Review and apply the three pending migrations to the intended development environment, and install the updated Composer lockfile. No development migration was applied during this task.
2. Keep Horizon/queue workers and the Laravel scheduler running. `materyalph:tax-reminders` uses Asia/Manila; public operating hours do not gate it. Configure `QUEUE_CONNECTION=redis` for asynchronous runtime delivery. Local email uses Mailpit; non-local SMTP settings stay in ignored environment configuration.
3. Backend only: `FIREBASE_PROJECT_ID` plus `FIREBASE_SERVICE_ACCOUNT_JSON_BASE64` or a mounted file referenced by `GOOGLE_APPLICATION_CREDENTIALS`. Keep each environment separate. `NOTIFICATION_PUSH_DRIVER=fake` is for non-production testing only.
4. Buyer public Dart defines: `FIREBASE_PUSH_ENABLED`, `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_IOS_BUNDLE_ID`. Configure the matching native Firebase/APNs application and signing capabilities. Request permission from Preferences, then verify foreground/background/terminated-app delivery on a physical device.
5. Web push requires backend `WEB_PUSH_APPROVED=true` only after approval, secure origin, and public `VITE_FIREBASE_PUSH_ENABLED`, `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_APP_ID`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_MESSAGING_SENDER_ID`, `VITE_FIREBASE_VAPID_KEY`. Verify permission, logout/revocation and service-worker clicks in each approved portal origin. Firebase service credentials must never appear in these values.
6. Live FCM/APNs, external email delivery, native release packaging and physical-device behavior are separate runtime gates. Fake-provider and mocked-browser evidence does not establish them.

Validation results and screenshots: [Phase 15 evidence](../design/evidence/phase-15/README.md).

Suggested commit, when authorized: `feat(notifications): add authoritative delivery and private reviewed exports`.
