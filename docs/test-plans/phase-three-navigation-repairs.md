# Phase 3 navigation and session repairs

## Scope and outcome

Laravel, Vendor web, Admin web, and shared web UI only. No new migration, Buyer mobile change, deployment, or commit. Existing account/security tools and the Admin verification queue/detail implementation are retained.

- Login now resolves a server-backed destination: Welcome until acknowledged, then the appropriate onboarding workstream or dashboard. Welcome completion is stored on the organization, not browser storage.
- Continue Later saves the current workstream before advancing: verification to setup, setup to the limited dashboard. Failed saves retain the form.
- Store Profile has its own route and public-profile editor, separate from personal account settings. Public-only edits preserve completed setup and activation; stale versions are rejected.
- Vendor and Admin accounts use the common portal shell. Authenticated logo links stay inside the portal; ordinary navigation does not revoke sessions. Network failures remain retryable and page-level permission failures do not trigger logout.
- Store media previews use authenticated, short-lived URLs. Ownership, permission and clean scan state are rechecked at download; other organizations cannot reuse the URL.
- First-time onboarding initialization is serialized on the organization row. Setup drafts increment the organization concurrency version.
- Impeccable was removed from current instructions, test gates and Codex hooks. Historical artifacts remain; no blocked executable was run.

## Changed areas

- Vendor routing, entry resolution and public-page session recovery: `apps/vendor-web/src/App.tsx`, `lib/vendor-destination.ts`, `pages/VendorEntryPage.tsx`, `pages/AuthenticatedPublicPage.tsx`, `pages/AuthSupportPages.tsx`.
- Onboarding, dashboard, Store Profile, Account and shell: `pages/PhaseThreeVendorPages.tsx`; shared `packages/web-ui/src/portal-shell.tsx` and `account-workspace.tsx`.
- Admin layout: `apps/admin-web/src/App.tsx` and `pages/PhaseThreeAdminPages.tsx`.
- Backend rules: `services/api/app/Domain/Vendors/VendorOnboardingService.php`; backend and Vendor navigation/transport regression tests.
- OpenAPI clarifies persisted Welcome, draft concurrency/public-profile editing, and private media URLs. The existing snapshot media entries now include `file_id`. TypeScript was regenerated; no endpoint was added and Dart was not changed.
- Repository/design instructions and phase evidence were updated. The isolated schema workflow regenerated the ERD and data dictionary from the existing migrations.

## Automated evidence

Checks run on 2026-09-16:

| Check | Command / location | Result |
| --- | --- | --- |
| Isolated Laravel regression | `php artisan test` in `materyalph_phase1_test-api-test-1` | 102 tests, 1,247 assertions passed; includes the existing 86-test baseline and 16 Phase 3 tests |
| PHP formatting | `vendor/bin/pint --test` | 214 files passed |
| PHP static analysis | `vendor/bin/phpstan analyse --memory-limit=512M` | No errors across 143 files; the default 128 MB worker limit was insufficient |
| Vendor | `npm run lint`, `npm run typecheck`, `npm run test -- --run`, `npm run build` | Passed; 46 tests across 8 files |
| Admin | Same four commands in `apps/admin-web` | Passed; 7 tests across 2 files |
| OpenAPI | `npm run validate` in `packages/api-contract` | Passed with three unused later-domain model recommendations |
| Account contract | `npm run test:account-contract` | 53 protected operations matched |
| Phase 3 contract | `npm run test:vendor-contract` | 24 operations matched |
| Generated TypeScript | `npm run build` in `packages/api-contract/generated/typescript` | Passed |
| Isolated schema workflow | `scripts/run-tests-isolated.ps1 -KeepRunning` | Empty migration, rollback/reapply, seed and schema checks passed earlier in this repair session |
| Compose | `docker compose config --quiet` | Passed without printing environment values |
| Source secrets | `gitleaks dir --redact --no-banner` on a temporary tracked/unignored source snapshot | No leaks; ignored local credentials were excluded |
| Staged secrets | `gitleaks git --staged --redact --no-banner` | No staged files; source scan provides candidate coverage |
| Whitespace | `git -c core.safecrlf=false -c core.autocrlf=false diff --check` | Passed |

Docker was installed and running; access required the approved elevated tool boundary. The previous Docker-unavailable gate is resolved.

## Admin access and remaining manual validation

The existing bootstrap command queued an invitation for the user-confirmed email. Delivery to local Mailpit was confirmed without displaying the invitation token. Open `http://localhost:8025`, accept that invitation, choose a password, and complete TOTP enrollment. No password was seeded or exposed. No new API keys are required for these repairs.

The browser tool reported no available browser, so the user's already-authenticated dashboard could not be inspected live. This is not a completed visual or browser-session acceptance run. Manually verify:

1. New Owner login, Welcome Continue, reload, logout/login, and no repeat Welcome after completion.
2. Continue Later in each workstream, failed-save retry, dashboard resume, pending review and activated states.
3. Store Profile versus Account, logo/sidebar/settings navigation, direct authorized URLs and refresh without unintended sign-out.
4. Store logo/banner preview, profile edits, Admin invitation/MFA, review queue and detail.
5. Keyboard focus, narrow-screen navigation/reflow and visible error states on both portals.

The Vendor build retains a non-blocking bundle-size warning (approximately 530 kB minified). Live provider behavior and later-phase marketplace modules are outside this repair; disabled navigation does not imply those modules are implemented. Impeccable is not a pending gate.

Suggested commit: `fix: align vendor onboarding navigation and portal sessions`.
