# Vendor landing visual refresh — 26 October 2026

The public Vendor landing hero now uses a locally served, Higgsfield-generated materials-store photograph, a tonal overlay for readable white copy, larger typography, and a compact materials → storefront → Buyers strip. Existing navigation, registration destinations, FAQ controls, fee disclosures and verification requirements remain in place.

The page uses a shared scroll-reveal hook, short hero entrances, button feedback and animated feature changes. Reduced motion removes the animations. Reveals keep content visible when browser observation is unavailable, reveal focused content, stop observing completed entrances, and reveal all pending content when reduced motion is enabled. The feature preview retains a stable live region while its inner content changes.

## Changed files

- `apps/vendor-web/src/pages/VendorLandingPage.tsx` and `.css`: hero composition, responsive image, scoped styling and motion markers.
- `apps/vendor-web/public/media/vendor-landing/materials-store-poster.jpg`: 1344 × 752, 178,543 bytes.
- `apps/vendor-web/public/media/vendor-landing/materials-store-mobile.jpg`: 960 × 537, 99,608 bytes.
- `packages/web-ui/src/landing-motion.ts` and `.css`, exported from `src/index.ts`: reusable reveal behavior.
- `apps/vendor-web/src/pages/VendorLandingMotion.test.tsx`: three motion/accessibility regression tests.
- This validation record.

Other work already present in the checkout was preserved. No migrations, API contracts, generated clients, authorization rules or provider configuration changed. No setup or credentials are required. Public image assets load from the application's own origin.

## Media provenance and scope

- Image: Higgsfield `gpt_image_2_5`, job `fecfb407-a768-44d9-a427-08b9b0e7bc06`, completed. The original generated PNG was inspected, then exported as optimized desktop and mobile JPEGs.
- Video: the requested eight-second `seedance_2_5` generation was rejected with “Out of credits”; no video job was submitted. The user explicitly chose “Finish with the generated image for now.” This change therefore contains an image background and interface animation. It makes no request for a missing video asset.
- The generated image depicts a fictional materials supplier, not evidence of an actual marketplace participant or transaction.

## Verification

Commands run from `apps/vendor-web`:

- `npm.cmd run lint`: passed; one existing unused-variable warning in `e2e/admin-finance-layout.spec.ts` (`inStore`).
- `npm.cmd run typecheck`: passed.
- `npm.cmd run test -- --run`: **71 files, 642 tests passed**. An existing jsdom navigation-not-implemented diagnostic was emitted without test failures.
- `npm.cmd run test -- --run src/App.test.tsx src/pages/VendorLandingMotion.test.tsx`: **2 files, 25 tests passed**, repeated after the feature live-region adjustment.
- `npm.cmd run build`: passed, repeated after the live-region adjustment. Vite retains its large-chunk warning (main bundle approximately 2.20 MB before gzip).

Automated browser checks used an isolated local harness under ignored `.tmp/`, importing the existing `e2e/vendor-landing.spec.ts` and adding media-loading, overflow, reveal and reduced-motion checks:

```powershell
node apps/vendor-web/node_modules/@playwright/test/cli.js test --config .tmp/vendor-landing-review.config.ts
```

The first run passed **8 tests** at 1440px, 390px, 320px and 390px with reduced motion. A second run passed **6 tests** at 768px, 1024px and 1920px. After improving the tablet image crop, the **4 tablet/1024px tests passed again** and the production build passed again. Registration navigation, mobile navigation, FAQ interaction, feature selection, fee disclosures and horizontal overflow checks passed. Desktop, tablet and mobile captures were visually reviewed under `.tmp/landing-media/hero-*.png`.

Repository checks:

- `git diff --check`: passed.
- A scoped `gitleaks dir` scan of changed source/test files: no leaks found.
- `gitleaks git --staged --redact --no-banner`: no leaks found; no staged changes were present.

The interactive in-app browser was unavailable; visual review used screenshots produced by the automated browser checks. API/database, other client suites and live-provider workflows were not exercised for this public-page presentation change. The Docker executable at the known local path was inaccessible in the sandbox, so the unrelated infrastructure gate was not run; its command is `docker compose config --quiet` from the repository root.

Suggested commit: `feat(vendor): refresh landing hero with generated imagery and motion`

## Follow-up: full-screen hero and scroll entrances

The hero now fills at least the visible viewport below the existing header, including its materials/storefront/Buyers strip. Content may grow on short screens to keep the text and actions accessible. The “From your store. To their next build.” caption and its styles were removed.

Scroll entrances now cover the audience strip, feature layout, payment introduction and footer as well as the existing headings, benefits, setup steps, trust section, FAQ and final registration panel. Benefits and setup steps enter with short staggered delays. The shared observer triggers after content enters the viewport; reduced-motion settings, keyboard focus, unsupported-browser fallback and cleanup remain supported. Print output retains visible content.

Files changed for this follow-up: `VendorLandingPage.tsx`, `VendorLandingPage.css`, `packages/web-ui/src/landing-motion.ts`, `packages/web-ui/src/landing-motion.css`, and this record. No migrations, contracts, authorization changes or setup are required.

Follow-up validation:

- Lint and TypeScript passed, with the same existing unused-variable warning.
- The two focused test files passed: **25 tests**.
- Production build passed, with the existing large-chunk warning.
- The local browser harness passed **14 tests** across 320px, 390px, 768px, 1024px, 1440px and 1920px, including reduced motion. Added checks confirmed the hero reaches the viewport bottom, the removed caption is absent, and below-the-fold sections remain pending until scrolled into view.
- Desktop, tablet and mobile screenshots were reviewed again.
- Scoped Gitleaks scan found no leaks; `git diff --check` passed.

Suggested follow-up commit: `fix(vendor): fill viewport hero and refine scroll reveals`
