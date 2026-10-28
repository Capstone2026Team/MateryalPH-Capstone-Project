# Message quotation layout verification — 28 October 2026

## Outcome and scope

Prepare quotation now has numbered Materials, Fulfillment and Message to Buyer cards on a restrained canvas. Fulfillment contains destination/access and Delivery arrangement & fee cards. Desktop keeps the order summary alongside the form; smaller screens stack it after the details. The footer keeps the total, autosave status and publishing action available while scrolling.

Material rows group the description and specifications above quantity, unit price and the line subtotal before discounts. The summary groups the existing discount controls, materials subtotal, delivery fee, deduction and overall total. Published conversation cards give the recorded total, version/status, fulfillment method and Vendor note a clearer hierarchy.

Automatic fees awaiting calculation no longer show an editable-amount validation error. A blank recommendation-change explanation stays hidden until a change requires it; saved explanations remain visible. Current location and Alternate Buyer Location retain the confirmed map-selection flow and fit narrow cards.

This UI follow-up adds no migrations, API contract changes, provider calls or new setup requirements. Earlier location-picker/API work already in the working tree is preserved. Server authorization, quotation publication, immutable versions, money calculations, Buyer payment selection and serialized autosave remain unchanged. Components and calculations come from `packages/web-ui`; no duplicate pricing formula was added.

## Files for this UI follow-up

- `apps/vendor-web/src/pages/ConversationThread.tsx`
- `apps/vendor-web/src/pages/QuotationDraftEditor.test.tsx`
- `apps/vendor-web/e2e/quotation-delivery.spec.ts`
- `packages/web-ui/src/quotation-draft-summary.tsx` (new shared section and summary components)
- `packages/web-ui/src/quotation-materials-editor.tsx`
- `packages/web-ui/src/quotation-discount-editor.tsx` (optional compact presentation; existing default retained)
- `packages/web-ui/src/quotation-destination-fields.tsx`
- `packages/web-ui/src/quotation-delivery-arrangement.tsx`
- `packages/web-ui/src/messaging-patterns.tsx`
- `packages/web-ui/src/index.ts`
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This verification report.

## Checks run

| Command / working directory | Result |
| --- | --- |
| `npm.cmd run lint` — `apps/vendor-web` | Exit 0; existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:30`. |
| `npm.cmd run typecheck` — `apps/vendor-web` | Passed. |
| `npm.cmd run test -- --run` — `apps/vendor-web` | 75 files, 688 tests passed. |
| `npm.cmd run test -- --run src/pages/QuotationDraftEditor.test.tsx src/lib/messaging-patterns.test.tsx src/lib/quotation-draft.test.ts src/pages/QuotationLocationDialog.test.tsx` — `apps/vendor-web` | Final focused run: 4 files, 55 tests passed. |
| `npm.cmd run build` — `apps/vendor-web` | Passed; final build restored the normal environment after the synthetic map fixture build. |
| `npm.cmd run lint` — `apps/admin-web` | Passed. |
| `npm.cmd run typecheck` — `apps/admin-web` | Passed. |
| `npm.cmd run test -- --run --maxWorkers=2` — `apps/admin-web` | 38 files, 236 tests passed. |
| `npm.cmd run build` — `apps/admin-web` | Passed. |
| `npm.cmd run test:e2e -- e2e/quotation-delivery.spec.ts --reporter=line` — `apps/vendor-web` | Final run: 8 passed (320, 375, 390, 768, 1024, 1280, 1440 and 1920 px). |
| `git -c core.autocrlf=false diff --check` | Passed. |
| Diff and new summary source piped to `gitleaks stdin --redact --no-banner` | No leaks found. |

The new interaction coverage checks summary/subtotal updates after quantity and discount edits, clearing the last material, and the existing delivery/manual-fee publication gates. Browser coverage checks the nested delivery region, card-level horizontal overflow, persistent total/action visibility, map search/cancel/pin confirmation, access confirmations, manual fee/reason and the discounted pickup total. Desktop and compact screenshots were inspected. The 320 px overflow assertion caught the alternate-location button; full-width mobile choices corrected it before the final passing run.

Screenshots are local ignored artifacts under `apps/vendor-web/test-results/quotation-delivery-*/`: `quotation-editor-overview.png`, `quotation-destination.png`, `quotation-delivery-card.png`, `quotation-map-popup.png`, `quotation-manual-fee.png` and `quotation-pickup-summary.png`. Browser data and Google map behavior are synthetic test fixtures; no live Buyer address or live provider result is represented.

## Iteration observations and remaining acceptance

- The first concurrent Admin run had two geographic-boundary timing failures (234 passed, 2 failed). The unchanged geographic test file then passed all 14 tests in isolation, and the complete suite passed all 236 with two workers. No geographic implementation was changed.
- One early 320 px map-confirmation assertion failed once before the final card iteration; subsequent three-viewport and full eight-viewport runs passed. No location business-rule change was made for that observation.
- A Windows Playwright runner hung during preview-server cleanup. Verification completed using the existing previews, and only the identified test runner and its preview processes were stopped afterward. Development servers were excluded.
- Builds retain the existing bundle-size warning; Vendor tests also emit jsdom's unsupported-navigation diagnostic while passing.
- Live Google Maps/geocoding/routing acceptance, physical-device checks, screen-reader review, 200% zoom and high-contrast acceptance were not performed. Existing `VITE_GOOGLE_MAPS_BROWSER_KEY` configuration is reused; this layout requires no new key.
- Backend, Flutter and contract suites were not rerun for this presentation-only follow-up. Earlier location-picker verification is recorded separately in `quotation-location-map-2026-10-28.md`.

Suggested conventional commit: `feat(vendor): organize message quotations into section cards`.
