# Portal section workspaces

## Implemented scope

- Vendor Welcome, Store Verification and Store Setup now use a standalone header, not the dashboard sidebar. Existing API operations and validation remain intact. Finish Later saves successfully before returning to the Limited Dashboard.
- Limited Dashboard retains independent checklists, combined progress, blockers and activation action. Store Profile and operational placeholders are disabled before activation. Existing Team Accounts permissions and setup-completion gate remain unchanged, per confirmation to preserve working functionality.
- Active Vendor dashboard and Admin dashboard use shared `SectionWorkspace`, with Overview selected initially and only one section's content rendered. The existing shared DateFilter is reused. Date selections are explicitly labelled UI previews: no fake backend filtering or changes to current live counts.
- Admin current metrics remain permission-scoped. Audit tracking remains available at `/audit` and in Platform Health. Vendor Management uses the existing verification routes. Buyer Management has its own authenticated placeholder, never the verification queue.
- Shared sidebar uses collapsible groups and scroll fallback for constrained screens. Existing shell branding, top bar and personal settings remain.
- Owner Store Profile sections retain profile editing, private logo/banner previews, document workflow, business location/status and setup links. Vehicles show the existing snapshot count/list. Operating Hours explicitly remains unimplemented; no unsupported storage or schedule API was created.
- Future modules show unavailable data rather than fabricated live values. No chart analytics or unsupported operational actions were added.

## Validation and limits

Vendor: 52 tests pass. Admin: 15 tests pass. Both TypeScript checks, lint and builds pass. Targeted secret scans and whitespace checks pass. Existing Vendor bundle warning remains. Live browser visual/responsive QA has not been performed; backend tests were not rerun because backend/schema/contracts did not change.

No migrations, API changes, new keys, deployments, commits or Buyer mobile changes. Preview routes expose no new protected datasets. All existing server authorization remains authoritative.
