# Vendor fleet editor and ready-mix setup — 2026-11-05

## Outcome

- Compact white fleet summary with accessible metric explanations and divided vehicle rows. Mixer rows show both kg and m³.
- Add/Edit uses the shared wide dialog: vehicle details and image, capacity/access, then rates. Fields scroll independently of the header/footer. The optional calculator is collapsed in operational fleet editing.
- Stable saved-vehicle keys prevent background updates from remounting thumbnails, requesting fresh image URLs, closing the editor or replacing dirty inputs.
- Editor resets use the saved fleet revision, so a delayed reset cannot close a newly opened dialog; save feedback remains on the overview after closing.
- Ready-mix variants disclose the existing mixer/Site Delivery publication requirement and link to listing-based mixer setup. Returning to the listing rechecks the fleet; errors have a retry action.
- The selected saved variant's available batch volume prefills a proposed mixer volume. Supply volume is explicitly distinguished from actual drum capacity. The Vendor confirms the actual capacity or types it.
- Suggested payload is `ceil(entered mixer m³ × saved listing kg/m³)`. Applying payload or heavy classification requires a separate explicit action. Missing density remains manual entry; no fixed truck rating is invented.

## Files

- `packages/web-ui/src/delivery-vehicles.tsx`: shared list, dialog, grouped fields and capacity guidance.
- `packages/web-ui/src/form-dialog.tsx`: opt-in title focus for long vehicle forms; default dialog behavior retained.
- `packages/web-ui/src/index.ts`: exports the capacity-source type.
- `apps/vendor-web/src/pages/FleetPages.tsx`: fleet synchronization, source loading, listing setup and save/discard feedback.
- `apps/vendor-web/src/lib/delivery-vehicles.ts`: stable saved keys and prefill-review validation.
- `apps/vendor-web/src/lib/fleet-capacity.ts`: authorized paginated catalog reads and source normalization.
- `apps/vendor-web/src/pages/CatalogListingSteps.tsx`: ready-mix setup action, eligibility reminder and return/retry checks.
- Tests: `FleetPages.test.tsx`, `CatalogPages.test.tsx`, `fleet-capacity.test.ts`, and `e2e/phase-5-inventory.spec.ts`.
- Relevant Vendor workflow and UI/UX planner paragraphs document the requested behavior.

## Contract, authorization and history

No migration, API shape or generated-client change. Existing fleet/catalog APIs authorize every read/write. Catalog suggestions are requested only for callers with catalog management permission; fleet management does not grant catalog access. Source listing reads remain restricted to the caller's organization. Vehicle images retain their private authorized URLs. Exact listing quantities remain on the Vendor surface.

Existing server-side mixer publication/discovery checks, vehicle validation, optimistic versions, rate history, audit/outbox and accepted delivery snapshots remain authoritative. The confirmation checkbox is editor guidance, not a new server authorization mechanism or a site-specific access guarantee. The Vendor still confirms access for each delivery.

## Validation

Passed:

- Focused Vendor fleet, capacity, catalog and onboarding tests: 137 tests across 5 files.
- `npm.cmd run test:e2e -- --grep 'vehicles open|ready-mix listing'`: 16/16, Chromium at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. Covers overview, wide-dialog size, focus, per-vehicle validation, new vehicle, discard, listing prefill, explicit payload/access actions and return link. No horizontal overflow.
- Vendor typecheck and production build. Vendor lint exits successfully with an existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`.
- Admin lint, typecheck, 282/282 tests across 42 files, and production build.
- OpenAPI validation: valid, with 8 unused-model recommendations.
- Inventory contract: all 17 inventory/auto-accept/fleet operations match routes and guards.
- Gitleaks over the changed source/test files: no leaks. Staged scan: no leaks, 0 staged commits/bytes.
- Task-scoped `git diff --check`.

Global gates are separate from the scoped results:

- First full Vendor run: 815 passed, 1 Finance date-button assertion failed.
- A later full Vendor run during separate date-filter edits: 790 passed, 27 failed across date-filter-dependent Finance, orders, inventory, dashboards, notifications, reviews, invoices, disputes and shared date-picker tests. The fleet/capacity/catalog/onboarding tests passed in that run. These results do not establish a clean whole-project gate or attribute those failures to this patch.
- An intermediate Vendor typecheck reported `FinancePages.tsx(481,18): TS6133`, unused `changeDates`, outside this patch. The final typecheck passed after the separate file changed again.
- Repository-wide whitespace check reported an extra blank line in `apps/vendor-web/src/lib/date-filters.ts`, outside this patch. Re-run `git diff --check` after that work settles.
- Backend and Buyer Flutter suites were not run; neither implementation changed. Browser automation uses synthetic API fixtures and does not prove live routing/provider behavior. The connected live-browser host was unavailable, so visual inspection used the generated browser-test screenshots.

## Evidence and manual checks

Synthetic screenshots were inspected and saved under `docs/design/evidence/fleet-2026-11-05/`:

- `vehicles-overview-1440.png`
- `mixer-dialog-1440.png`
- `ready-mix-prefill-1440.png`

No new setup or keys are required. On the actual account, confirm a ready-mix listing's saved volume and kg/m³, open its Configure mixer truck action, verify/edit the actual drum capacity and rated payload, upload a truck image, complete rates and save. Verify return-to-listing eligibility after the server accepts the configuration. Actual road/site access remains the Vendor's delivery-specific confirmation.

Suggested commit: `fix(vendor): compact fleet editor and stabilize refresh`
