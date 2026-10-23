# Phase 16 — Admin operations and Philippine geographic analytics

## Implemented boundary

**Operations home.** `OperationsQueueService` returns only the queues the Admin's permissions allow (Vendor documents and activation, document expiry, product compliance, disputes, appeals, remedies, referred and active sanctions, flagged reviews, overdue invoice requests, failed and pending refunds, cash reimbursements, finance work items, failed jobs). Each count links to its filtered queue and reports the oldest pending item.

**Phase 3E extension.** The existing verification queue and case gain filters for setup, activation, discovery, blocker category, waiting age and document expiry. The case shows Verification, Setup, TEST provider readiness, Activation (with hold code) and Discovery separately. Every activation blocker carries its source and revision from `StoreActivationGate`. Teams and products never block activation. `override_available` is always `false`, and no route marks a provider ready. Grouped Business Information decisions stay separate from document decisions.

**Enforcement.** Warning, Temporary Restriction (1–365 days, auto-lift by `materyalph:enforcement-sweep`), Suspension and Permanent Ban apply to Buyers and Vendor organizations.
- Dispute referrals keep their case identity. Order & Dispute recommends; User Management applies or declines.
- Permanent Ban needs `enforcement.ban` and recent re-authentication.
- Applying a sanction needs a continuation plan that matches the subject's open orders. Refunds always proceed.
- A Buyer restriction blocks new orders, quotation decisions, Work Package inquiries and new conversations (`BUYER_COMMERCE_RESTRICTED`). A Buyer suspension revokes every session.
- Lifting a Vendor sanction returns the store to READY or NOT_READY, never ACTIVE.
- Every decision records the reason, before and after states, actor, role and correlation ID, and sends a notification. Enforcement rows and events are guarded against update and delete.

**Audit search.** Keyset-paged search covers actor, role, action, resource, result, correlation ID, reason text and Manila dates.
- Before and after detail needs `audit.view_sensitive`, is redacted, and opening it is audited.
- CSV export needs `audit.export`, caps at 5,000 rows and never includes payloads.
- No route edits, deletes or annotates an audit entry.

**Platform Settings.** Versioned, non-secret defaults are wired to their consuming rules and apply to new records only.
- Each change needs `platform_settings.manage`, recent re-authentication, the expected version (409 `SETTING_VERSION_CONFLICT`) and a reason.
- Each change appends a version row with the previous value and correlation ID, writes an audit entry and notifies the other Super Admins.
- SRS and FMS weights must total 100.
- VPS weights, radius values, LIVE commerce, statutory rates and an NRPC cap are fixed references with no control.

**Integration and Job Health.** The page shows configuration presence and masked labels only: never a credential, payload, recipient or exception message. It covers queues, the outbox backlog, dead letters, scheduled task runs (recorded by `ScheduledTaskRecorder`), the geographic aggregation, the Materials Analytics snapshot and PSGC or boundary health. A reasoned, idempotent retry is allowed only for allowlisted outbox events and jobs and for the two daily analytics runs.

**FIN-10.** The finance pages cover:
- KPIs that keep gross and net GMV apart from assessed CWT, provider-reported deductions, commission, credits, platform revenue, fee VAT, billed amounts, collected cash, receivables and overdue amounts.
- The remittance reconciliation queue, with FIN-05 components and threshold status before and after.
- The tax evidence queue, which links to the Vendor case.
- Tax adjustments, prepared and reviewed by two different named finance users (409 `PREPARER_CANNOT_REVIEW`), which post a compensating DEMO entry.
- The FIN-04A threshold-review and overlap queues, fee approval and payment status, overdue debt, and report readiness.
- The Owner-only Vendor finance review status, without reviewer notes or taxpayer identifiers.

Everything is labelled DEMO. There is no LIVE bypass.

**Geographic analytics.**
- **Facts.** `analytics:aggregate-marketplace` (daily at 01:00 Asia/Manila) rebuilds order, line, activity, response and presence facts for TEST under an advisory lock. Facts hold PSGC codes and a geo-resolution flag, never coordinates. Points are placed with `ST_Covers` against imported boundaries only when an address lacks a resolved code.
- **Filtering.** The dashboard drills Philippines → Region → Province or independent/HUC city → City or Municipality. The selected area filters every panel, including Materials Analytics. Transaction filters are marked not applicable to counts, active users, response time and price panels. There is no radius filter.
- **Metrics.** Vendor and Buyer counts; gross and net GMV; order volume trends; fulfillment, cancellation and dispute rates with numerator and denominator; mean, median and p90 Vendor response time from human actions only (auto-accept excluded); category and material demand; DAU, WAU and MAU.
- **Disclosure.** k = 5 distinct persons (a setting from 3 to 50). A suppressed cell rolls up to its parent and carries its reason. Complementary suppression applies when exactly one sibling would be suppressed. Vendor storefront counts are not suppressed. Unresolved geography is reported separately.
- **DEMO data.** `materyalph:geo-analytics-demo` writes an isolated, labelled DEMO dataset and refuses to run in production.
- **Export.** CSV export needs `analytics.view_aggregates` and `analytics.export` and applies the same suppression.

## Acceptance coverage

| Suite | Coverage |
| --- | --- |
| `PhaseSixteenAdminOperationsTest` | Settings: versioned, validated, conflict, re-authentication, Super Admin only, new records only. Dispute-referred suspension: preserved case and history identity, exact decision target, stale version, continuation plan by open orders, UM-only apply and lift, return to readiness, Vendor and OD notifications. Buyer restriction: blocks new commerce, auto-expires. Suspension: revokes sessions. Privacy: handler scope, identity verification, final once closed, idempotency replay and conflict. Audit: append-only, sensitive detail audited. Job health: safe status, allowlisted reasoned retry. Phase 3E: separate workstreams, source-revision blockers, no provider override. Tax adjustments: two named users, linked entry, Owner-only Vendor review status. Operations home: role-scoped queues |
| `PhaseSixteenGeoAnalyticsTest` | Drill-down, small-cell and complementary suppression, no coordinate keys in any response or export. Human-only activity and responses (auto-accept never counts). DEMO isolation and labelling. Separate aggregate and export authorization. Versioned, idempotent boundary import that needs `--replace` |
| `PhaseSixteenRulesTest` | Disclosure arithmetic; registry totals, ranges, cross-setting rules and unknown keys |
| `check-admin-operations-contract.mjs` | Phase 16 operations, schemas, idempotency headers, no audit-edit or provider-ready route, generated client operations |
| `GeoAnalyticsPatterns.test.tsx` (admin-web) | Equal-count bins. Tile fallback with keyboard selection and exact focused value. Legend states. Sortable table with `aria-sort`. Breadcrumbs. Keyboard trend crosshair and empty state. Heatmap text values and suppression. Reasoned decision target, version, reason and conflict. Health icon plus word |
| `PhaseSixteenPages.test.tsx` (admin-web) | Settings: version, previous value and rule; fixed rules without controls; weights total; stale conflict. Enforcement: exact target, plan options by open orders, conflict. Audit: no edit or delete, detail and export hidden without permission. Integration health: masked status, reasoned retry, no secret text. Geo dashboard: gross and net separate, suppression reasons, unresolved geography, not-applicable filters, keyboard drill-down updates the area, no coordinates. Finance: GMV separate from finance amounts; preparer-review conflict with correlation ID |
| `FinancePages.test.tsx` (vendor-web) | Owner finance review status without taxpayer identifiers |

## Manual checks

1. Run `docker compose exec api php artisan migrate` on the development database. The migration is additive and forward-only.
2. Optional map: set `VITE_GOOGLE_MAPS_BROWSER_KEY` in `apps/admin-web/.env` (a referrer-restricted browser key) and import boundaries with `materyalph:psgc-boundaries-import --file=… --reference=…` (see `docs/architecture/psgc-import.md`). Without either, the tile view and the table remain fully usable.
3. Optional DEMO data: `docker compose exec api php artisan materyalph:geo-analytics-demo --days=90`, then choose **DEMO dataset** on Marketplace Analytics.
4. The full-width geographic map/tiles sit above the area comparison table. Tiles adapt to the available container width. At 320px there is no horizontal page scroll; the table scrolls inside its own region, keeping area names and column headers visible. Headers and numeric values remain readable without splitting words or amounts.
5. Keyboard only: tab to a tile or table row, read the exact value in the status line, press Enter to drill, and use the breadcrumbs to return.
6. Windows High Contrast: suppressed tiles keep their hatch and the word "Suppressed".

## Migration

`2026_10_12_000000_create_phase_sixteen_admin_operations.php` adds:
- `platform_setting_versions`, seeded with the approved defaults
- enforcement application and continuation columns, a one-applied-sanction-per-subject index and `enforcement_events`
- legacy privacy request lifecycle columns and `privacy_request_events` (retained history only; feature retired 2026-10-23)
- `scheduled_task_runs` and `operation_retries`
- audit search indexes, including a trigram index on reason
- boundary geometry with a GiST index and `psgc_boundary_imports`
- `analytics_geo_runs` and five fact tables
- the Phase 16 permission grants

History tables are append-only through triggers. Nothing cascades from commercial, financial, compliance, dispute or audit history.

## Owner correction — 2026-10-23

Privacy Requests is removed from Admin navigation, pages, dashboard queues, API routes, domain handling, notifications and generated clients. Buyer account deletion keeps its blockers, recent authentication, revocation, security email and audit history, and records an `AD-` account-deletion reference without creating a privacy case. The response shape remains unchanged. Migration `2026_10_29_000000_retire_privacy_request_permissions.php` removes `privacy.manage` and `privacy.handle` grants, including custom roles, while retaining existing request/event tables and history protections. Privacy inquiries continue through existing Support Requests or DPO contact channels.

Regression gates: retired endpoints return 404; no privacy queue or permission is exposed; legacy privacy notifications cannot open a removed destination; account deletion creates no request/event and retains its reference in the audit trail.

### Retirement verification — 2026-10-23

- Isolated PostgreSQL guard and negative isolation checks passed. The Admin operations and Vendor navigation run passed 23 tests / 453 assertions. Explicit Buyer deletion, Phase 15 notifications, Admin navigation, notification inbox and realtime files passed 32 tests / 465 assertions: 55 focused API tests / 918 assertions overall.
- Retirement regressions verify every former endpoint returns 404 even for Super Admin; every role omits the privacy queue; old privacy notifications are denied; permission removal is repeatable, removes all role grants and leaves unrelated grants and historical requests/events unchanged. Buyer deletion verifies no new privacy request/event, its audit reference, revocation, retained history and fresh registration after deletion.
- Full PHP Pint and PHPStan (`--memory-limit=512M`) passed. Admin lint/typecheck/build and 156 component tests passed. Vendor lint/typecheck/build and 609 component tests passed.
- Flutter analysis (`flutter analyze --no-pub`) found no issues; 22 focused tests passed across `buyer_security_test.dart`, `buyer_account_test.dart`, `account_refinement_test.dart` and `buyer_help_center_test.dart`. The final Admin operations/navigation recheck passed another 22 tests / 468 assertions after the internal queue signature cleanup.
- The OpenAPI contract validates; Admin operations (30 operations), account (72 protected operations), team deletion/acceptance and portal date (32 reads) contract checks passed. TypeScript and Dart clients were regenerated from the source contract; generated models were not edited by hand.
- Standalone generated-client `dart analyze lib` returned exit 1 with two `unused_element_parameter` warnings at `directory_review_ratings_value.dart:40` and `geo_demand_cell_value.dart:40` (`specifiedType`). Both files are unchanged from HEAD (`git diff --exit-code` returned 0); no generated files were patched to suppress the warnings. Flutter application analysis remains clean.
- Development and isolated-test Compose configurations passed `config --quiet`. Gitleaks scanned the changed source/contract/generated diff plus the new migration with no leaks. `git diff --check` passed.
- The permission cleanup migration was exercised only in the isolated test database. It is not applied to development or hosted environments. Apply it through the normal approved migration/deployment process; no new settings or secret keys are required.
- Browser/device acceptance and the full API test suite were not run for this focused removal. Existing retained request/event tables, their triggers, historical notifications and audit records remain stored. No deployment was performed.

Suggested commit: `refactor(admin): retire privacy request management`.

### Files affected by the retirement

- Admin: `src/App.tsx`, `src/lib/operations-api.ts`, `src/pages/PhaseThreeAdminPages.tsx`, `AdminDashboardPage.tsx` and `AdminPlaceholderPage.tsx`; deleted `PrivacyPages.tsx`.
- API: `routes/admin-operations.php`, `AdminOperationsController`, `OperationsQueueService`, `AdminDashboardService`, `NavigationUpdates`, `NavigationBroadcast`, `NotificationPolicy` and `DeleteBuyerAccount`; deleted `PrivacyRequestService`. Added the permission retirement migration and updated `BuyerAccountDeletionTest` / `PhaseSixteenAdminOperationsTest`.
- Contract: `openapi.yaml`, the Admin operations contract builder/checker and portal-date checker, plus regenerated TypeScript/Dart APIs, models, serializers, manifests and documentation. Four operations across three Admin privacy paths and eight privacy schemas are removed. Buyer deletion keeps its response fields and uses an audited account-deletion reference.
- Buyer: updated the account-deletion reference fixture in `buyer_security_test.dart`.
- Guidance: `PRODUCT.md`, all four workflows, the technical system design, UI/UX planner, implementation plan, demo script/features guide, Phase 16 evidence index and this test plan.
