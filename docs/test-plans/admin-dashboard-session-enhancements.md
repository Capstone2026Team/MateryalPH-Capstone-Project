# Admin dashboard, MFA and portal isolation — 2026-09-17

## Delivered changes

- Admin MFA enrollment renders its provisioning URI locally as a QR code; recovery codes can be downloaded as a text file. Neither operation sends credentials to a QR service.
- Browser access, refresh, MFA challenge, CSRF and bot-proof cookies are namespaced per configured Vendor/Admin origin. Membership, Passport audience, MFA and CSRF checks remain mandatory. Legacy browser sessions require a fresh login once.
- `/dashboard` is the successful Admin login/MFA destination and the default overview navigation item. Later-phase metrics display unavailable dashes, not fabricated zeroes.
- Dashboard Buyer counts use ACTIVE account status. Only Super Admin receives Buyer counts, audit totals and the paginated read-only audit endpoint. Vendor verification staff receive Vendor/review metrics. Audit responses exclude private before/after payloads and personal contact information.
- Verification queue supports submission-date ordering, inclusive Asia/Manila date filters, region filtering and region/province/city ordering. Pagination remains server-side with 20 records per page.
- Regions resolve through the latest effective imported PSGC hierarchy. Future versions are excluded. Unknown address codes stay Unassigned.

## Files and API

Primary changes: Admin `App.tsx`, `AuthSupportPages.tsx`, `PhaseThreeAdminPages.tsx`, new `AdminDashboardPage.tsx` and recovery download helper; Laravel `IsolatePortalCookies`, `AdminDashboardService`, `AdminDashboardController`, `PhilippineRegionDirectory`, verification service/controller, middleware registration and Admin routes. Regression tests cover MFA download, cookie isolation, KPI permissions, filter validation and region-version hierarchy.

OpenAPI adds GET `/admin/dashboard`, GET `/admin/dashboard/audit`, verification queue filters and location fields. TypeScript and Dart sources were regenerated; Buyer application source is unchanged. No database migrations or credentials were changed for this enhancement.

Non-active Vendor count includes registered, not-yet-activated stores; the UI intentionally does not label unverified onboarding stores as Tier 2. Pending document count counts documents, not organizations.

## Verification evidence

- Isolated Docker `php artisan test --compact`: **108 passed, 1297 assertions**.
- `vendor/bin/phpstan analyse --memory-limit=512M`: **147 files, no errors**.
- Admin `npm run test -- --run`: **11 passed**; lint, TypeScript check and production build passed.
- Vendor `npm run test -- --run`: **46 passed**; lint and production build passed. Existing >500 kB bundle warning remains.
- OpenAPI validation passed (three existing unused-model recommendations); account contract **53 operations**, Phase 3 contract **26 operations** passed.
- Generated TypeScript build passed.
- `git diff --check` passed.
- Separate redacted Gitleaks scans of `apps/admin-web/src` and `services/api/app`: no leaks. Staged scan had no staged files and is not full-repository evidence. An initial incorrectly scoped multi-path scan traversed dependencies and reported findings; it is not a clean repository-wide scan.
- Browser: authenticated Admin verification queue and KPI dashboard loaded successfully; real metric response returned HTTP 200. No MFA secrets or recovery codes were captured during verification.

## Remaining acceptance/setup

- Current local PSGC directory is empty. Populate from an official PSA publication and match Vendor address codes before claiming regional classification is complete. The official download could not be retrieved by this environment. Source: https://psa.gov.ph/classification/psgc/regions . The PSA API requires an access token; none was requested or configured.
- Simultaneous live Vendor/Admin login/logout/refresh remains a manual acceptance check. The Vendor tab was at Login during inspection. Automated cookie-isolation tests passed, but do not substitute for this complete browser journey.
- Confirm `VENDOR_FRONTEND_URL` and `ADMIN_FRONTEND_URL` exactly match distinct browser origins. No new API key is required for QR rendering or downloads.
- User must replace the MFA setup secret/recovery codes exposed in earlier screenshots using the existing security flow. No credentials were rotated by the agent.
- No deployment or commit performed. Suggested commit: `feat(admin): add scoped dashboard and isolate portal sessions`.
