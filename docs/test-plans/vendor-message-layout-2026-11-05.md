# Vendor message Work Package layout and robot control

Implemented locally on 5 November 2026.

## Outcome and scope

The Work Package popup follows the owner's final simplification: one Items table, one available Payment summary, and one Delivery & payment section. Separate Materials for your store and Your quotation proposal sections are removed. The single list uses the current quotation items when present, otherwise the assigned materials. Order attachments always use their saved order snapshot, even if an obsolete proposal is supplied. An explicitly empty quotation stays empty. The attachment summary count follows the displayed list.

The popup uses a compact white layout with shaded table headers, Material/Qty columns, and Unit price/Total columns when prices are present. Specifications remain under each item. Project site, contact, instructions, fulfillment and payment appear once in compact label/value rows. The four price columns fit the tested 320px and 390px viewports. Extra source-version and comparison explanations are removed from this summary; immutable source data remains retained.

Line amounts and materials subtotals reuse the existing integer-centavo, half-up calculation. Missing prices remain unquoted and cannot create a partial subtotal. Authoritative commercial amounts, recorded discounts, included VAT and totals are used when supplied by the existing reference. The attachment projection does not supply every order charge, so no processing fee, missing VAT or final order total is invented. Existing order/quotation details retain the complete financial breakdown.

The Inbox settings control uses a 20px robot icon inside a target at least 44px wide. Hover or keyboard focus shows exactly `Automated Response Settings`. The tooltip remains available while hovered, stays within the viewport, dismisses with Escape and closes when the settings dialog opens.

No API contract, generated client, migration, business rule, authorization or secret/key setup changed. Existing store-scoped materials, accepted-order snapshots, quotation actions, composer state and Owner/Manager settings permissions remain in place. No push, merge or deployment occurred. Other pre-existing workspace edits were preserved.

## Files changed for this request

- `apps/vendor-web/src/pages/MessagingPage.tsx`: robot control using the shared tooltip button.
- `packages/web-ui/src/work-package-attachment.tsx` and `.css`: shared Work Package presentation.
- `packages/web-ui/src/tooltip-button.tsx` and `.css`: accessible reusable icon action and label.
- `packages/web-ui/src/index.ts`: shared component export.
- `apps/vendor-web/e2e/project-quotation.spec.ts` and `buyer-thread.spec.ts`: one table and one set of details, responsive fit, composer preservation, quotation access, icon size, tooltip hover/focus/Escape and settings-dialog checks.
- `apps/vendor-web/src/components/WorkPackageAttachment.test.tsx`: table semantics, fractional totals, missing prices and recorded commercial summary checks.
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md` and Vendor workflow: final one-list presentation decision; retained original/snapshot and authorization rules.
- This verification record and screenshots under `docs/design/evidence/vendor-message-layout/`.

## Executed verification

| Check | Result |
| --- | --- |
| Focused attachment, fulfillment and shared messaging components | 3 files, 55 tests passed |
| Final Vendor complete component suite | 84 files, 788 tests passed |
| Admin complete component suite | 42 files, 282 tests passed |
| Vendor and Admin lint, TypeScript checks and builds | Passed |
| Final Chromium attachment/settings and combined-chat journeys at widths 320, 390, 1024 and 1440 | 8 passed |
| Desktop/mobile popup, scrolled mobile proposal and robot tooltip screenshots | Visually reviewed |
| Working-tree whitespace check | Passed |
| Scoped Gitleaks scan of changed source files | No leaks detected |
| Staged Gitleaks scan | No leaks detected; zero staged bytes |

Both complete component suites and portal lint/typecheck/build checks include the single-list correction. The final CSS-only mobile price-column spacing was covered by a fresh Vendor build and browser rerun. Browser checks verify exactly one table, one payment summary and one delivery/payment section; current item precedence; retained composer and quotation access; the priced row total; phone-width fit; keyboard access; robot label and settings dialog. Existing Vendor lint warning: unused `inStore` in `e2e/admin-finance-layout.spec.ts:31`. Both builds retain their bundle-size advisories. The passing Vendor suite also emits a jsdom navigation-not-implemented diagnostic.

Docker is unavailable in this shell, including the usual Docker Desktop CLI path, so Compose validation could not run. Run `docker compose config --quiet` from the repository root when Docker is available. Backend and Flutter gates were not rerun for this web presentation change. Browser checks use synthetic fixtures; authenticated live account and physical-device acceptance were not performed.

## Reproduction

From `apps/vendor-web`, run `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run`, `npm.cmd run build`, and:

```powershell
npm.cmd run test:e2e -- e2e/project-quotation.spec.ts e2e/buyer-thread.spec.ts --project=chromium-320 --project=chromium-390 --project=chromium-1024 --project=chromium-1440
```

From `apps/admin-web`, run `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run` and `npm.cmd run build`.

Suggested commit: `fix(vendor): simplify work package details to one item list`.
