# Vendor vehicle overview — 2026-10-03

## Outcome

The Vendor `/vehicles` page opens on an overview with vehicle photos, category/type, availability, payload capacity, configured count, maximum distance and delivery rates. Add vehicle opens a new configuration; Edit opens one existing configuration. Back to vehicles preserves draft input and pending image retry state. Save/Discard appears only after a change. Successful save or discard returns to the overview. Validation opens the affected vehicle. Removing a saved vehicle retains the existing confirmation and future-use removal API.

## Files

- `packages/web-ui/src/delivery-vehicles.tsx`: shared operational overview, image thumbnails, single visible editor, keyboard focus and validation navigation; prevent completed uploads from updating a discarded/unmounted editor.
- `apps/vendor-web/src/pages/FleetPages.tsx`: reset the editor after save/discard, show pending eligibility for edited drafts, conditional save bar and shorter introductory text.
- `apps/vendor-web/src/pages/FleetPages.test.tsx`: overview, Add/Edit/Back, draft retention, discard, validation, versioned saves and existing authorization coverage.
- `apps/vendor-web/e2e/phase-5-inventory.spec.ts`: responsive overview/editor, mixer fields, validation, add and discard checks.

No migrations, API contract changes, generated-client changes or new setup/key requirements. Existing Owner/Store Manager permissions and server authorization remain authoritative. Vehicle images use the existing authorized image resolver. Accepted-order snapshots and delivery calculations are unchanged. The Store Setup and Store Profile forms retain their existing presentation.

## Verification

- Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build`: passed.
- Vendor `npm.cmd run test -- --run --no-file-parallelism`: **30 files, 235 tests passed**.
- An earlier parallel Vendor run had **234 passes and one failure** in the unrelated Inventory auto-accept test (`enabled` false versus expected true). The complete serial rerun passed without changing Inventory code or tests. The parallel run is not reported as a pass.
- Vendor `npm.cmd run test:e2e -- e2e/phase-5-inventory.spec.ts -g "vehicles open"`: **8 passed**, at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 pixels. Includes page overflow checks. Reviewed generated overview/editor screenshots.
- Admin `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run`, `npm.cmd run build`: passed; **13 files, 39 tests passed**.
- `gitleaks dir packages/web-ui/src --redact --no-banner`, `gitleaks dir apps/vendor-web/src/pages --redact --no-banner`, `gitleaks dir apps/vendor-web/e2e --redact --no-banner`: no leaks found.
- Direct checks of the four changed source/test files found no trailing whitespace or conflict markers. No Git commands were used, honoring the standing checkout restriction.

## Limits

Browser/API responses were fixtures; live vehicle persistence and provider uploads were not exercised. Backend, mobile and database checks were not run for this UI-only change. Both portal builds retain bundle-size warnings. No deployment or database mutation was performed.

Suggested conventional commit: `feat(vendor): open vehicle management with a fleet overview`
