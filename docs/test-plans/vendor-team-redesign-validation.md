# Vendor Team Accounts and Team Tracking redesign — 2026-10-08

## Result

Team Accounts uses compact member rows with initials, fixed role, membership status and permitted account actions. Search and role filters are server-side and paginated. Add new account opens the shared accessible FormDialog; the invitation draft survives closing and reopening. Successful submission closes the form and refreshes invitation history. Editing an employee and confirming access changes also use the shared dialog. Existing invitation delivery, recent authentication, role/version checks, session revocation, Owner notices and immutable history remain authoritative.

Team Tracking follows the reference's sidebar/detail composition. It includes a paginated searchable member selector, historical-role filter, 7/30/90-day windows, summary counts across all matching pages, work-area distribution, activity history and current role responsibilities. Store Manager, Store Staff, Customer Service Staff, Inventory Staff and Fulfillment Staff have workflow-specific responsibility descriptions and work areas. Recorded message and quotation activity joins audit history without returning bodies, attachments, prices or private staff contacts. These are recorded-event counts, not attributed sales, revenue, hours worked or productivity scores. Legacy messages without a recorded Vendor role cannot safely be attributed and are excluded; existing message records do not carry a correlation ID and display Not recorded.

## Changed boundaries

- Shared UI: `packages/web-ui/src/vendor-team-activity.tsx`, `vendor-team-invitations.tsx`, `vendor-team-members.tsx`, `vendor-team-patterns.tsx`, and exports in `index.ts`.
- Vendor integration: `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx` and `src/lib/onboarding-api.ts`.
- API: `AccountAdministrationController` delegates monitoring to `VendorTeamActivityQuery`; membership listing accepts optional `search` and `role`.
- GET `/api/v1/vendors/account/activity` accepts `member_id`, historical `role`, `days` and `category` plus `page`. Its default window is 30 days. Summary counts cover all matching events before category selection; list totals reflect that selection. Rows add work category and nullable correlation reference.
- OpenAPI, TypeScript/Dart clients and Dart serializers were regenerated. The Vendor/account contract checks cover the filters and summary fields.
- `VendorTeamTrackingTest` adds three database feature cases for pagination/totals, role and organization isolation, delegated access, and private-content exclusion. Existing invitation component and E2E fixtures now open the popup before entering fields.
- No migration, development data changes, new credentials, deployment or Git commands.

## Validation

- Vendor lint and production build passed. Build reports the existing large-bundle warning.
- Vendor typecheck reports one error outside this change: `apps/vendor-web/src/pages/OrderPages.tsx:115` passes `htmlFor` and children to the input-only `Field` component. No team-file errors remain.
- Focused PHPStan passed with no errors. Focused Pint and PHP syntax checks passed.
- OpenAPI validation passed with three unused-model recommendations: FinancialSnapshot, FeeAssessment, MaterialPriceObservation.
- Vendor contract passed: 35 operations, plus team filter/summary/privacy assertions. Account contract passed: 61 protected operations.
- TypeScript generated client build passed. Dart serializers regenerated; analysis of the changed models and account/onboarding API files passed with no issues.
- Redacted directory secret scans passed for shared web UI, Vendor source, authorization domain, API controllers and API feature tests.
- The three new backend tests stopped before assertions because `postgres-test` could not resolve; Docker CLI was absent from PATH and both known installation paths. No database test is claimed as passed.
- UI/component/E2E tests and browser inspection were intentionally not run, following the user's standing preference to perform UI testing.

## Remaining checks

With Docker Desktop available, run from the repository root:

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test up -d --wait
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi --filter=VendorTeamTrackingTest
```

After resolving the existing order-filter type error, run `npm.cmd run typecheck` from `apps/vendor-web`.

Manual acceptance: invite and edit an employee; close/reopen the draft; check validation and expired security verification; confirm suspension/reactivation and Owner-only Manager delegation; inspect every role's tracking panel, date/category filters and multi-page totals; verify an unauthorized employee and undelegated Manager cannot enter tracking. Check narrow/mobile layouts and keyboard focus/Escape behavior. Use seeded or isolated data for these checks.

Suggested commit: `feat(vendor): redesign team accounts and role-based tracking`.

## Follow-up reference correction

The Owner requested the third/fourth reference compositions and team management exclusively within Team Accounts / Team Tracking. Team Accounts now separates member rows and invitation history into views, places Add new account at the upper left, and uses aligned row actions and status. Team Tracking defaults to Statistics with three summary tiles, role work-area tiles and an orange distribution chart; raw records appear only in Activity history.

Removed the Staff access tab, membership requests and staff mutation forms from shared AccountWorkspace. Onboarding retains its optional team step but links to Team Accounts instead of embedding another editor. Added a shared AccountVerificationDialog used by Settings and Team Accounts, preserving password/email/TOTP verification. Team invitations, account edits, delegation and dispute settings no longer link to Settings for verification. No API contract, backend authorization or migration changed in this follow-up.

The running Vendor Vite server on localhost:5173 was checked through its served JavaScript modules: Statistics and the distribution chart are present; legacy Refresh activity and Settings Staff access are absent. This is a source-serving check, not browser/UI acceptance. The precise cause of the user's previously open stale view was not established; reload that tab to load the current modules.

Follow-up checks: Vendor lint/build passed; Vendor typecheck still reports only the existing OrderPages.tsx:115 Field/htmlFor error. Admin typecheck/lint/build passed for the shared Settings change. Existing verification tests now wait for the shared dialog to load authentication options. Redacted source secret scans passed. UI tests remain intentionally unrun.

## Authentication for every submitted team change

Removed the standalone Verify identity button and reusable-verification success message. The shared useAccountVerification gate now opens a fresh authentication popup before sending or resending an invitation, saving employee details, changing membership status, changing Manager delegation, or toggling staff dispute access. It never skips the popup based on a previously verified session. Cancel resolves only the pending request as not authorized; failed authentication keeps the popup open without sending the mutation. Invitation/edit drafts remain available. Pending verification is canceled when the page unmounts or loses team permission. Concurrent verification requests cannot overwrite each other.

The existing backend recent-authentication, authorization, concurrency and audit controls remain unchanged; this is a per-submission portal interaction, not a new single-use backend authorization protocol. No API contract or migration changes. The existing component/E2E fixtures were updated for verification and a cancellation/retry case was added; UI tests remain unrun per the user's standing preference.

Verification for this follow-up: Vendor lint and production build passed; Admin typecheck passed. Vendor typecheck remains blocked only by the unrelated `OrderPages.tsx:115` Field/htmlFor error. Redacted secret scans of shared web UI and Vendor source found no leaks; edited-source whitespace/conflict-marker checks passed. Read-only checks of the running Vite modules confirmed the standalone verification button is absent and invitation/member submissions await verification. This does not constitute browser interaction testing.

## Tracking layout correction

Team Tracking now opts into a full-width PortalShell content layout, removing the outer width cap and gutters for this page. Its title, sidebar and activity sections fill the panel. Shared TeamMemberFilters now explicitly constrain grid items, input wrappers and selects to their available width; the desktop team column is 256 px. Tracking tabs wrap and filters stack on narrow screens. Header, statistics and chart padding use tighter, consistent spacing. Changed files: `portal-shell.tsx`, `vendor-team-activity.tsx`, `vendor-team-members.tsx`, `vendor-team-patterns.tsx` and Vendor `PhaseThreeVendorPages.tsx`.

Vendor lint/build and Admin typecheck passed. Vendor typecheck still reports the existing `OrderPages.tsx:115` Field/htmlFor error; build retains the large-bundle warning. Shared UI secret scan found no leaks; edited-source whitespace/conflict-marker checks passed. UI/browser tests were not run per user preference; manual responsive acceptance remains unverified. No API, authorization or migration changes, and no setup required. Suggested commit: `fix(vendor): fit team tracking to the panel and contain filters`.

Continuation check: `npm.cmd run typecheck` in `apps/vendor-web` now passes (exit 0). The current checkout already uses a semantic label/select for the closed-order filter, so the previously reported Field/htmlFor blocker is resolved; no additional OrderPages edit was needed in this continuation. Reviewed the tracking width, sidebar filter constraints and wrapping rules in source. Visual acceptance remains unverified.
