# Admin and Vendor presentation refresh — 2026-09-17

## Scope

Visual refinement of the existing portals; no route, backend permission, authentication, verification workflow, API contract or database migration changes in this refresh. Existing pending changes from earlier work are preserved.

- Shared `PortalShell` uses the MateryalPH text wordmark, compact navigation, current page/date context and a top-right Settings/account center. Personal account links moved out of the primary sidebar. Store Profile remains a separate Vendor destination. Admin account-management actions remain within permission-gated Settings.
- `PortalAccountMenu` obtains the personal identity from the existing account API for both portals, renders initials and exposes profile, security, sessions, agreements and explicit sign-out. Escape and outside click dismiss the disclosure. No token storage or logout-on-navigation was introduced.
- Shared `AccountWorkspace` is titled Settings. Profile editing and account information have separate sections, alongside existing security, device/session, agreement and authorized team/admin controls. Permission details are collapsible. Unsupported preferences, billing, deletion and integrations from reference imagery were not invented.
- Admin Dashboard uses metric cards and embeds the existing paginated audit table for authorized Super Admin. The standalone verification/audit links are removed; `/audit` remains supported. Counts and restrictions are unchanged, and later-phase metrics remain unavailable rather than fabricated.
- Verification removes region and exposed date-boundary controls from its toolbar. A single date-range dialog contains presets, two calendar months, accessible native date inputs and Apply/Cancel. Existing inclusive Asia/Manila date parameters are reused. All dates is the default to avoid hiding old pending reviews. The reference's rolling-hour toggle was not copied: the existing API supports calendar-day boundaries, not rolling-hour semantics.

## Checks

- Admin: lint, TypeScript, production build and 14 component tests passed.
- Vendor: lint, TypeScript, production build and 46 component tests passed.
- `git diff --check` passed.
- Redacted Gitleaks scans of shared UI and Admin sources passed.
- Browser checked: authenticated Admin dashboard/audit activity, Settings, simplified verification toolbar and two-month date dialog; authenticated Vendor Store Profile and shared shell. No account form changes or logout were submitted.
- Existing Vendor bundle-size warning remains. Backend tests were not rerun for this frontend-only refresh; the earlier full backend result was 108 tests / 1297 assertions.

## Limitations and follow-up

The account API has no personal-avatar image URL or upload capability. The shared menu accepts an optional avatar URL and handles image failure, but current live accounts correctly use initials. Store logos are never substituted for personal avatars. No new API keys or manual setup are required for this UI refresh.

Responsive classes retain mobile navigation and calendar reflow; a full device/browser accessibility matrix was not run. Calendar day cells use a dense-control exception (at least 24 by 36 CSS pixels); routine actions remain at least 44 pixels high.

The previous pending PSGC population request is no longer an acceptance gate for this page because the user explicitly removed its regional filter. Backend geographic support was not deleted.

Suggested commit: `feat(ui): refine portal navigation settings and admin dashboard`.
