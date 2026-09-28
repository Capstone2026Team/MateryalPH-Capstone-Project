# Phase 5 layout evidence

Screenshots from `apps/vendor-web/e2e/phase-5-inventory.spec.ts` at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px:

- `*-inventory-ledger.png`: the ledger with a sticky header, frozen product column, table-only horizontal scroll, stale-stock band and “Buyers see” labels.
- `*-inventory-conflict.png`: an inline edit after another person saved the row. The typed value is kept and the saved values are shown.
- `*-auto-accept-paused.png` and `*-auto-accept-resume-confirmation.png`: the single auto-accept surface, the text-plus-icon pause state, and the resume confirmation naming the allotment.
- `*-vehicles-validation.png`: repeatable vehicle row sets with a per-vehicle validation error.

Every API response comes from a synthetic fixture. The screenshots illustrate layout only. They show nothing about live stock, route distances, provider readiness or real Vendor data.
