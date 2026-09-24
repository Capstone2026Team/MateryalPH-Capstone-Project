# Navigation and account UI refinement — 19 September 2026

## Scope and outcome

Implemented the user's supplied navigation, Profile and Account Setting references in the existing React/Flutter clients. Existing uncommitted backend, profile-photo and dashboard work was retained.

- Limited Vendor dashboard: removed the extra “What happens next” guidance section, including its teammate invitation. Both onboarding workstreams, progress, activation blockers, and Continue actions remain.
- Vendor Settings: `/settings` is the single route used by internal links. Removed the Settings workspace's Dashboard link, centered its bounded content, and organized agreements by document title, version, acceptance status, content and action.
- Both web portals: shared plain sidebar groups, corrected Lucide destination icons, orange-tinted active rows, neutral hover states, and a date/profile top bar. Personal Profile, Settings, Security, Sessions, Agreements and Sign out remain accessible from the avatar menu. Onboarding keeps its standalone layout.
- Buyer: fixed five-item navigation labeled Map, Explore, Projects, Message, Profile; grouped Profile hub; dedicated Account Setting route; attached avatar edit action; existing edit/security/session/agreement screens retained.
- Buyer missing destinations: clickable illustrated pages, with centered assets copied from `materials/Mobile System Componets/Empty States Componets`. Working actions were not replaced by placeholders.
- Light-screen Android status icons use dark foreground; iOS uses light-background status-bar brightness. Existing system information is not hidden. SafeArea remains responsible for system insets.

The user's explicit `Message` label supersedes the older planner's `Messages` label for the bottom bar only.

## Files and boundaries

- `packages/web-ui/src/{portal-shell.tsx,portal-shell.css,portal-account-menu.tsx,account-workspace.tsx,dashboard-patterns.tsx,index.ts}` and package manifests.
- Vendor `src/App.tsx`, `src/pages/PhaseThreeVendorPages.tsx`, navigation tests and account/navigation browser tests.
- Admin `src/pages/PhaseThreeAdminPages.tsx` and account-menu tests.
- Buyer `lib/main.dart`, `lib/design_system/theme.dart`, `lib/screens/buyer_home_screen.dart`, `lib/screens/buyer_account_screen.dart`, new `lib/screens/buyer_profile_screen.dart`, new `lib/widgets/buyer_account_widgets.dart`, test files, assets and dependency manifests.
- `packages/api-contract/scripts/generate-clients.mjs` plus regenerated `vendor_setup_draft.dart` and `vendor_verification_draft.dart`: corrected existing nested-object builder assignments that prevented Buyer test compilation. Generated files were regenerated through the script. Ignored built_value serializers were refreshed using build_runner.
- **No migrations, HTTP contract changes, new API endpoints or backend business-rule changes in this task.** Existing authentication, masked Buyer email, reauthentication, role checks and mutation handlers remain in place.

## Density and accessibility

Both desktop sidebars are 16rem wide. Desktop navigation uses a documented dense-control exception: 30px rows, 13px text and 18px icons. Targets exceed WCAG's 24px minimum. Persistent sidebar mode starts at 1024px width and 800px height; shorter/narrower viewports and equivalent browser zoom use a drawer with 44px rows. The main workspace scrolls independently in desktop mode. The drawer traps Tab, closes with Escape, restores focus, and makes the background inert.

Buyer controls retain mobile tap sizes, scalable text, accessible selected states and fixed bottom-nav positions. Destructive account actions use the error semantic color. Orange action text uses the deeper contrast-safe token.

## Validation

| Command / location | Result |
| --- | --- |
| `npm.cmd run typecheck`, `npm.cmd run lint`, `npm.cmd run test -- --run`, `npm.cmd run build` in Vendor | Passed; 53 tests in 9 files; build has the existing >500kB chunk advisory |
| Same four commands in Admin | Passed; 15 tests in 7 files |
| `flutter analyze` in Buyer | No issues |
| `flutter test --reporter expanded` in Buyer | 41 tests passed, including reviewed font-loaded visual baselines |
| Playwright `e2e/portal-navigation.spec.ts` and `e2e/account-settings.spec.ts` | 32 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920px viewport widths |
| `npm.cmd run test:account-contract` | Passed: 57 protected operations |
| `npm.cmd run test:vendor-contract` | Passed: 26 Vendor/Admin operations |
| `gitleaks dir <source-directory> --redact --no-banner` | No leaks in Buyer lib, Vendor src, Admin src, shared web UI src or API generation scripts |
| `gitleaks git --staged --redact --no-banner` | No staged content and no findings |
| `git diff --check` | Passed |

Browser checks covered sidebar fit, independent scrolling, drawer focus restoration, flat groups, correct account URLs, agreement navigation, reflow and preserved security controls. The final browser run used a temporary config that inherited `playwright.config.ts` with automatic webServer lifecycle disabled against running preview servers; this avoided a Windows preview-server teardown hang. All 32 tests exited successfully. The temporary config was removed.

Rendered evidence is in `docs/design/evidence/ui-refinement/`: Buyer Profile, Account Setting and illustrated unavailable state; Vendor/Admin desktop agreements; compact Vendor agreements. The Buyer visual test loads Inter and Lucide rather than test placeholder fonts.

## Remaining constraints and manual review

- No new API keys, environment variables or manual setup are needed.
- The current Buyer profile response supplies a masked email and no phone number or verification field. The UI preserves masking, displays “Phone number unavailable”, and does not fabricate a verification badge.
- Buyer profile-picture upload, 2FA management, deletion, connected-account management and marketplace modules lack working Buyer destinations in the current client. They explicitly display “Not yet implemented”. Web photo uploads remain functional. These placeholders perform no sensitive mutation.
- Real Android and iOS status-bar rendering still needs device/simulator confirmation; widget tests verify overlay configuration and reflow, not operating-system pixels.
- No deployment, push, merge, database mutation or commit was performed.

Suggested commit: `feat(ui): refine portal navigation and buyer account experience`
