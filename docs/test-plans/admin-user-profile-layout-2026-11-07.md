# Admin Buyer and Vendor profile layout — 7 November 2026

## Delivered layout

The supplied fourth attachment guides the profile composition. Wide layouts use a compact identity/contact card on the left with two lanes of account information alongside it. Identity, account status and authorized queue actions remain present while switching sections. Narrow layouts stack identity above content.

- Buyer Profile groups account overview, order activity, Buyer information and the existing CCS summary.
- Vendor Store profile groups business information, active Owner contact, marketplace availability, verification state and a smaller store-banner/about card.
- Usage and activity uses neutral white metric groups with smaller values, clear headings and the existing calculation hints. Last login uses body-sized text rather than an oversized numeric treatment.
- Product status filters and search share one compact toolbar. Product thumbnails and table rows use less space; public stock labels, filters, search submission, pagination and product prices are preserved.
- Content container queries adapt score and badge columns to the remaining space beside the identity card. Text wraps, controls retain 44 px targets and tables retain their labelled horizontal scrolling.

## Files

- `apps/admin-web/src/pages/UserDirectoryPages.tsx`
- `packages/web-ui/src/profile-details.tsx`, `profile-details.css` and shared exports in `index.ts`
- `apps/admin-web/src/pages/UserDirectoryPages.test.tsx` and `UserDirectoryMedia.test.tsx`
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`

No migrations, API or generated-client changes. No new data, account mutations, role grants or commercial behavior. Private Buyer photos keep their authorized loader and Blob URL cleanup; deleted accounts keep masked contact/photo behavior. Verification and enforcement actions retain their existing permission gates and destinations. No new setup or key names.

## Checks

- Final full Admin suite: **332 passed across 48 files** using `npm.cmd run test -- --run --maxWorkers=2`. Admin lint, typecheck and build also passed in that run. The final body-sized Last login adjustment separately passed all 14 directory tests and the Admin production build.
- Focused Admin directory, media and trust tests: **43 passed across 3 files**. Coverage includes identity persistence across sections, image loading/failure/navigation cleanup, deleted-account privacy, calculation-hint dismissal, product filters, monitoring access and existing investigation behavior.
- Vendor shared-pattern and Store Performance regression tests: **23 passed across 2 files**.
- Admin and Vendor lint, typecheck and production builds passed. Vendor lint retains the unrelated unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`; builds retain their large-chunk warning.
- Task-file `git diff --check` passed. Redacted direct secret scan of changed source/tests/styles found no leaks in 101,620 bytes.

The first full Admin run exposed stale media fixtures missing the required CCS summary and a test selector matching multiple calculation hints. The fixtures now use the existing response shape and the selector is scoped to its metric; all affected tests pass. No application bypass or fallback score was introduced.

## Visual acceptance still required

The browser access host and native Computer Use pipe are unavailable; browser availability was retried. No desktop/mobile screenshots or live-session visual acceptance is claimed. When available, check both profiles at 1440, 1280, 768 and 390 px, long names/email/address values, all tabs, white activity surfaces, keyboard hints, absent/failed media, and table scrolling without page overflow.

Suggested commit: `refactor(admin): organize buyer and vendor profiles`
