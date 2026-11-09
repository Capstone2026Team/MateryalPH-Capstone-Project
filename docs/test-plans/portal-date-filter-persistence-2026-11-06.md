# Shared portal date-filter persistence — 2026-11-06

Changing a shared date picker and pressing Apply updates the other date pickers and their existing query callbacks. The applied Manila calendar boundaries remain selected across page navigation, reloads and browser tabs on the same portal origin until another selection or explicit date reset is applied. Vendor and Admin origins retain separate browser preferences. Cancel discards only the draft.

The shared implementation is in `packages/web-ui/src/date-filter.tsx` and `date-filter-preference.ts`. Storage contains only `label`, `from` and `to` under the versioned `materyalph:date-filter:v1` key. Invalid stored JSON, impossible dates and reversed ranges are ignored. If storage is unavailable, the current page's pickers still synchronize in memory; persistence across reloads requires available browser storage.

Regression coverage changes: `apps/vendor-web/src/components/DateFilter.test.tsx` and `apps/vendor-web/e2e/portal-standardization.spec.ts`. Both portals' `src/test/setup.ts` files remove only the date preference after each browser-environment test to keep cases independent.

Existing bounded analytics retain their required endpoints, minimum/maximum interval and allowed dates. An incompatible shared selection does not bypass those limits or replace the saved preference with that page's fallback. Applying a compatible range synchronizes it again. Backend date meanings, authorization, financial rules, API contracts and schemas are unchanged. No migration, credentials or manual setup are required.

## Automated verification

- Component tests cover live query-state synchronization, navigation/remount restoration, stale page dates, Cancel, All dates, open-ended ranges, constrained analytics, explicit resets, cross-tab events without echo writes, malformed preferences and unavailable storage. URL-backed state retains unrelated filters and resets pagination through its existing change callback.
- Chromium tests use synthetic API responses and inspect the resulting Vendor order and Admin verification request dates after navigation and reload. They also check cancelled drafts remain cancelled after reload, at 390 px and 1440 px.
- Portal lint, type checks, builds, complete test suites, the existing date contract checker, source secret scanning and whitespace checks are recorded below after execution.

## Results

- Vendor: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` and `npm.cmd run test -- --run --maxWorkers=2` passed; **93 files, 902 tests**. Lint retains an unused `inStore` warning in the unrelated `e2e/admin-finance-layout.spec.ts` file.
- Admin: the same lint/typecheck/build/test commands passed; **44 files, 293 tests**.
- Browser: from `apps/vendor-web`, `npm.cmd run test:e2e -- e2e/portal-standardization.spec.ts --grep "shares applied dates" --project chromium-390 --project chromium-1440` passed **4/4** checks across both portals. Fixtures start with the existing Last 30 days default.
- `node scripts/check-portal-date-contract.mjs` from `packages/api-contract` passed for **32 dated GET operations** and filtered notification bulk read.
- `npm.cmd run validate` from `packages/api-contract` passed; the existing spec reports eight unused-model recommendations.
- Changed-source Gitleaks scan and targeted `git diff --check` passed. The staged scan passed with zero staged bytes; it does not substitute for the changed-source scan.
- The first unrestricted full-suite run exhausted system memory, as did the concurrent Vendor build. Both builds and complete suites passed after restricting Vitest to two workers. Initial callback-duplication and Node-environment test-cleanup errors were fixed before the successful complete runs.
- Non-blocking output: build chunk-size warnings, Vitest's existing esbuild/oxc option warning and jsdom's unsupported full navigation message. Synthetic browser checks passed; live authenticated/provider acceptance remains manual. API/PHP, Flutter and deployment gates were not run because this change is confined to shared web UI and its tests.

## Manual acceptance

On an authenticated Vendor or Admin portal, apply a range on Notifications, open a different dated list, reload it and open a second tab on the same origin. The button and request dates should match. Apply another range and verify all compatible date pickers update. Cancelling an edited range must retain the prior selection. Live authenticated/provider behavior is separate from the synthetic browser checks.

Suggested commit: `fix(web-ui): persist and synchronize portal date filters`
