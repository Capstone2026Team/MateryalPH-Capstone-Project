# Admin and Vendor sidebar refinement

Verified 2026-09-20 against the supplied sidebar reference, `DESIGN.md`, and the UI/UX implementation planner.

## Result

Both portals use the same shared sidebar: fixed branding header, independently scrolling flat navigation, and fixed account footer. This implements the latest requirement for menu-only scrolling and supersedes the earlier non-scrollable desktop sidebar constraint.

- Expanded width: 256px at the default root font size; collapsed width: 72px. Desktop starts at 1024px. Smaller screens retain the full-width navigation drawer.
- Inter, semantic surface/text/action tokens, restrained orange active treatment, consistent 18px Lucide icons, and uppercase group labels.
- Desktop navigation rows are 36px under the dense-navigation exception; mobile drawer rows and controls retain 44px minimum touch targets. Collapsed group headings take no space: groups are separated by a 1px inset divider within a 9px gap. Each icon retains its own destination and accessible name.
- Width changes take 180ms; text visibility takes 140ms. Reduced-motion preferences disable these transitions. Workspace sizing follows the sidebar.
- Named links, hover/focus tooltips, visible focus outlines, Escape dismissal, mobile focus containment, and disabled navigation semantics remain available.
- Collapse preference survives navigation and reloads within the browser session, separately for each portal. Session storage contains only a boolean UI preference and is optional if storage is unavailable.
- Footer uses the existing authenticated profile response: Vendor owners use organization name when available; Admin uses personal name and role. Initials serve as the compact avatar. No verification status is fabricated.
- Footer Profile links preserve native same-page hash navigation to the existing account workspace.

Existing role-specific navigation groups, destinations, disabled states, Vendor onboarding restrictions, and API authorization are unchanged. No Buyer files, backend code, migrations, API contracts, or generated clients changed. No new setup or API keys are required.

## Files

- `packages/web-ui/src/portal-shell.tsx`: shared layout, accessible collapse state, tooltip and footer behavior.
- `packages/web-ui/src/portal-shell.css`: shared dimensions, fixed regions, internal scrolling, responsive layout, and motion.
- `packages/web-ui/src/portal-account-menu.tsx`: forwards its existing profile result to the shell without a duplicate request.
- `apps/admin-web/src/PortalShell.test.tsx`: direct navigation, active/disabled links, collapse controls, tooltips, and authenticated identity.
- `apps/vendor-web/e2e/portal-navigation.spec.ts`: both portals at eight viewport sizes, fixed region geometry, menu scrolling, collapse/reload persistence, focus behavior, reduced motion, footer/account navigation, unchanged destination counts, 36px collapsed rows, compact group gaps, and visible dividers.
- This report and four reference screenshots under `docs/design/evidence/portal-sidebar/`.

## Verification

| Command | Result |
| --- | --- |
| Admin: `npm run lint` | Exit 0 |
| Admin: `npm run typecheck` | Exit 0 |
| Admin: `npm run test -- --run` | 16 tests passed; exit 0 |
| Admin: `npm run build` | Exit 0 |
| Vendor: `npm run lint` | Exit 0 |
| Vendor: `npm run typecheck` | Exit 0 |
| Vendor: `npm run test -- --run` | 53 tests passed; exit 0 |
| Vendor: `npm run build` | Exit 0; non-blocking bundle-size warning above 500 kB |
| Vendor: `npx playwright test e2e/portal-navigation.spec.ts --reporter=list` | 16 passed in 20.5s; exit 0 |
| `git diff --check` | Exit 0 |
| `gitleaks git --staged --redact --no-banner` | Exit 0; no staged changes |
| Changed source diff and new test piped to `gitleaks stdin --redact --no-banner` | Exit 0; no leaks found |

Browser matrix: 320×568, 375×812, 390×844, 768×1024, 1024×768, 1280×900, 1440×1000, and 1920×1080. Both portals passed each viewport. Screenshots were visually reviewed for expanded desktop, collapsed desktop, and mobile drawer composition.

Browser tests use synthetic API fixtures; they do not prove a live backend account session. Existing Vendor navigation/role unit tests also pass. An initial browser run completed its assertions but stalled during Windows preview-server teardown; it was stopped and the final run above completed successfully using separately managed preview servers. No database tests or mutations were performed.

## Visual evidence

- [Vendor expanded](evidence/portal-sidebar/vendor-expanded.png)
- [Admin expanded](evidence/portal-sidebar/admin-expanded.png)
- [Admin collapsed at 1024px](evidence/portal-sidebar/admin-collapsed.png)
- [Vendor drawer at 320px, scrolled to lower navigation](evidence/portal-sidebar/vendor-mobile.png)

Suggested commit: `feat(web): unify collapsible admin and vendor sidebars`

No commit, push, merge, or deployment performed.
