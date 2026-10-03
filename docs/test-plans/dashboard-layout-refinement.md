# Vendor and Admin dashboard layout refinement

Verified September 30, 2026.

## Scope

Dashboard panels use compact metric cards, clear section headings, button-based section switching, and responsive two-column section controls on narrow screens. Only the selected report section renders. Vendor overview separates store workspace links from marketplace readiness; Admin overview pairs permission-scoped counts with review priorities and a platform snapshot.

Sidebar, topbar, routing, authentication, server authorization, onboarding and activation rules are unchanged. The shared dashboard header also improves the limited-access and staff dashboard presentation. Their existing actions and requirements remain intact.

No migrations, API contract changes, generated-client changes, credentials, or manual setup are required. Dashboard reporting that is unavailable remains explicitly unavailable; no sample metrics or fabricated chart series were added. The dashboards show current snapshots and no longer present the former non-functional date-preview filter. The shared date picker remains available to other workspaces.

## Files

- `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx`
- `apps/admin-web/src/pages/AdminDashboardPage.tsx`
- `packages/web-ui/src/dashboard-patterns.tsx`
- `packages/web-ui/src/section-workspace.tsx`
- `packages/web-ui/src/index.ts`
- `apps/vendor-web/e2e/dashboard-layout.spec.ts`
- This report and screenshots in `docs/design/evidence/dashboard-layout/`.

## Validation

| Check | Result |
| --- | --- |
| Both portals: `npm.cmd run lint` | Passed |
| Both portals: `npm.cmd run typecheck` | Passed |
| Vendor: `npm.cmd run test -- --run` | 27 files, 216 tests passed |
| Admin: `npm.cmd run test -- --run` | 10 files, 30 tests passed |
| Both portals: `npm.cmd run build` | Passed; bundle-size warnings remain |
| Admin: `npm.cmd run test -- --run src/components/SectionWorkspace.test.tsx` after final responsive adjustment | 1 test passed |
| Vendor: `npm.cmd run test:e2e -- dashboard-layout.spec.ts` after rebuilding both portals | 24 tests passed |
| `gitleaks dir <path> --redact --no-banner` for shared UI source, both portal page directories, and Vendor E2E directory | No leaks found |
| Direct changed-source whitespace and conflict-marker inspection | Passed |

Browser checks cover widths 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. They verify section isolation, keyboard activation, correct navigation targets, restricted Admin metrics and audit visibility, and no document-level horizontal overflow. Desktop and mobile screenshots were visually inspected. Screenshot counts and identities are synthetic test fixtures; browser tests do not prove live backend or provider behavior.

No Git commands were used. Backend, Buyer mobile, and provider gates were not rerun for this presentation-only change.

Suggested commit: `style(portals): refine vendor and admin dashboard layouts`

## Automatic dashboard updates

The follow-up removes the Vendor and Admin dashboard refresh buttons, including the limited Vendor dashboard button. A shared `packages/web-ui/src/use-automatic-refresh.ts` hook checks every 30 seconds after the preceding request completes. It skips hidden/offline pages, resumes overdue checks on visibility/focus/reconnection, prevents overlapping checks and focus bursts, and cleans up on unmount. Failed requests use a 120-second retry interval. Existing error-only retry controls remain available.

Admin summaries remain mounted during background requests so selected sections and previous counts remain visible. Transient failures label the previous snapshot; 401/403 responses clear it. Embedded audit tracking also updates automatically. The Vendor dashboard pauses checks during activation. Existing permission enforcement, endpoints, and rate limits are unchanged; no migration, API contract change, or setup is required.

Additional files: `packages/web-ui/src/use-automatic-refresh.ts` and `apps/admin-web/src/components/AutomaticRefresh.test.tsx`. Both dashboard pages, the shared export, and dashboard browser checks were updated.

Follow-up validation:

- Vendor navigation suite: 78 tests passed.
- Automatic-refresh and section-workspace suites: 5 tests passed.
- Both portals: lint, typecheck and production builds passed; bundle-size warnings remain.
- Dashboard browser suite: 24 tests passed across all eight widths, including automatic data changes, absence of refresh buttons, and preservation of the selected section. The first run exposed a test locator selecting the hidden mobile sidebar; the locator now checks the dashboard content.
- Gitleaks directory scans: shared UI, Admin source, Vendor pages and Vendor E2E files passed with no leaks.
- Direct source whitespace and conflict-marker check passed. No Git commands used.

Browser checks use synthetic API responses and a controlled clock. This is periodic automatic refresh, not server-pushed realtime reporting; unavailable analytics remain unavailable.

Suggested follow-up commit: `feat(portals): update dashboards automatically`
