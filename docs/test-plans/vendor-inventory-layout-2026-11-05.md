# Compact Vendor Inventory — 2026-11-05

## Change

Inventory now matches Listings with compact white summary filters, a grouped search/filter toolbar and 16px section spacing. The ledger is one white surface with a current-page variant count and the existing Confirm counts action in its header. Product name, variant and SKU share one column; Stock status, Confirmation, Reorder level and Auto-accept remain distinct. Confirmation states use text/icons beside the exact Asia/Manila timestamp. Existing On/Off/Paused wording and remaining allotments accompany the 44px auto-accept controls.

Desktop retains a sticky header/identifier and scrolling within the ledger. Phone/tablet views use labeled records and dividers. Long product names and SKUs wrap rather than disappear.

## Files

- `apps/vendor-web/src/pages/InventoryPages.tsx`
- `packages/web-ui/src/stock-ledger.tsx` — opt-in compact ledger presentation.
- `packages/web-ui/src/compact-page-patterns.css`
- `apps/vendor-web/src/pages/InventoryPages.test.tsx`
- `apps/vendor-web/e2e/phase-5-inventory.spec.ts`
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This report and refreshed inventory browser evidence.

## Preserved behavior

No migrations, API/OpenAPI/generated-client changes, audit/notification changes, credentials or manual setup are required. Existing authorization, private quantities, public stock labels, filters, pagination, stock-confirmation thresholds, counted-row selection, all-or-nothing confirmation, optimistic concurrency, reminders, detail/edit/history dialogs and auto-accept policies remain in use. A read-only member still cannot confirm counts or operate the disabled configuration switch. Nested controls retain their independent actions without triggering row navigation. No deployment was performed.

## Checks

Run from `apps/vendor-web`:

- `npm.cmd run lint`: passed with the existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:31`.
- `npm.cmd run typecheck`: passed.
- `npm.cmd run build`: passed; existing large-chunk warning remains.
- `npm.cmd run test -- --run src/pages/InventoryPages.test.tsx src/pages/CatalogPages.test.tsx`: 2 files, 32 tests passed.
- `npm.cmd run test:e2e -- e2e/phase-5-inventory.spec.ts --grep "inventory|auto-accept shows"`: 40 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. The filename matches the grep, so the run also includes the existing fleet test.
- `npm.cmd run test -- --run`: 87 files, 811 tests passed. The existing jsdom navigation diagnostic was emitted; the command exited successfully.
- Admin compatibility: `npm.cmd run typecheck` and `npm.cmd run build` passed from `apps/admin-web`, with the existing bundle-size warning. Admin's full test suite was not rerun for these opt-in styles.

`git -c core.safecrlf=false diff --check` passed. The staged Gitleaks gate passed with zero staged bytes. A separate redacted `gitleaks dir` scan of the seven changed source/document files passed with no leaks found.

Browser checks cover contained scrolling, sticky identifiers, five-column grouping, summary height, 44px product targets, long SKUs, inactive listings, confirmed/overdue/no-count states, active/paused/off policies, canceling page confirmation, retained typed values on conflict, and confirmed auto-accept resume. Existing read-only and bulk-confirmation component tests pass. Desktop and phone screenshots were visually reviewed.

The fixtures are synthetic and do not establish live stock, provider or storage acceptance. Live authenticated acceptance with the store's current products remains manual. Backend/Flutter suites are outside this presentation-only change. Compose files are unchanged; Docker was unavailable in this workspace for the preceding catalog task. The full-repository Compose gate requires `docker compose config --quiet` where Docker is available.

## Evidence

The new layout case writes `compact-inventory.png` under each viewport's ignored `apps/vendor-web/test-results/phase-5-inventory-compact-*/` directory. Existing tests refresh `docs/design/evidence/portal-standardization/inventory-*.png`. Screenshot-only overflow styles are removed after each capture so subsequent interactions use the normal layout.

Suggested commit: `style(vendor): compact inventory workspace and ledger`
