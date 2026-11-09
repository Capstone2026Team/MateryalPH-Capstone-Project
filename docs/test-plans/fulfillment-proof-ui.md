# Fulfillment layout and proof previews

Validated locally on 2026-11-04 (Asia/Manila).

Self-Pickup and Site Delivery use the same updated fulfillment workspace: a method badge, readable expected date, compact milestone labels/statuses, aligned assignment details, and separated accepted-arrangement and assignment-history sections. White surfaces and the recorded milestone order are preserved.

Proof photos, additional photos and signatures appear as thumbnails. Selecting a thumbnail opens the shared modal viewer with Zoom in / Fit image, Close preview and Escape support. Closing restores keyboard focus to the thumbnail. Loading, private-read failure, image decode failure and explicit retry are covered; replaced/unmounted object URLs are released, and reads finishing after navigation cannot create a preview.

## Changed files

- `apps/vendor-web/src/pages/OrderFulfillmentPanels.tsx`
- `packages/web-ui/src/fulfillment-patterns.tsx`
- `packages/web-ui/src/private-evidence-gallery.tsx`
- `apps/vendor-web/src/pages/OrderFulfillmentPanels.test.tsx`
- `apps/vendor-web/src/pages/FulfillmentPages.test.tsx`
- `apps/vendor-web/src/pages/OrderPages.test.tsx`
- `apps/vendor-web/src/components/PrivateEvidenceGallery.test.tsx`
- `apps/vendor-web/e2e/fulfillment-proof-layout.spec.ts`
- This validation note.

No migration, backend, OpenAPI or generated-client changes. No environment keys or manual setup are required. Existing unrelated working-tree changes were retained.

## Security and workflow decisions

- Proof reads retain `readOrderEvidenceFile`, its validated order-scoped API paths, authenticated cookie transport, no-store requests and allowed content types. Images are rendered from temporary local blob URLs.
- Authorization, global access-denied handling and server-side file checks are unchanged. Failed images never fall back to a public URL.
- Existing milestone permissions, assignment controls, receipt confirmation, accepted vehicles/trips/fees, history and the no-live-GPS notice are preserved.
- Other order evidence links keep their existing document-opening behavior. The gallery's existing signed-file/public-listing modes remain supported, with Admin component coverage.

## Executed checks

| Check | Result |
| --- | --- |
| Vendor `npm.cmd run lint` | Passed; existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:31` |
| Vendor `npm.cmd run typecheck` | Passed |
| Vendor `npm.cmd run test -- --run` | 83 files, 774 tests passed |
| Vendor `npm.cmd run build` | Passed |
| Admin `npm.cmd run lint` | Passed |
| Admin `npm.cmd run typecheck` | Passed |
| Admin `npm.cmd run test -- --run --maxWorkers=2` | 42 files, 282 tests passed |
| Admin `npm.cmd run build` | Passed |
| Shared changed TSX files through Vendor's `oxlint.cmd` | Passed |
| Playwright fulfillment spec, widths 320, 768 and 1440 at height 1000 | 6 passed |
| Playwright fulfillment spec, 320 × 568 after final build | 2 passed |
| `git diff --check` | Passed |
| `gitleaks git --staged --redact --no-banner` | No leaks; no staged bytes |
| `gitleaks dir .tmp/fulfillment-ui/secret-scan --redact --no-banner` | No leaks in copies of all eight changed source/test files |

The first concurrent Admin suite run timed out in the unrelated date-adapter child-process test. That test passed alone (4/4), and the complete Admin suite passed with two workers. Production builds retain their existing large-chunk warnings. Vendor's passing suite also emits a jsdom navigation warning.

Browser tests exercise the actual Orders → Open full order route, thumbnail loading, popup/zoom, keyboard reopening, Escape/Close focus restoration, unchanged page context, no extra browser window, no horizontal overflow, and recovery from a simulated 503 without automatic private-file replay. Sample fixtures reuse a public marketing photo; they do not access customer evidence.

Screenshots are under `apps/vendor-web/test-results/fulfillment-*.png`, with logs/backups under `.tmp/fulfillment-ui/`. Desktop screenshots temporarily expand the scroll container for complete capture; layout/interaction assertions use normal portal styles.

Live authenticated customer-proof access was not exercised. Backend, Flutter and API-contract suites were not run for this UI-only change. Docker is unavailable in this shell; the unrun Compose check is `docker compose config --quiet`.

Suggested commit: `fix(vendor): refine fulfillment layout and preview proof photos`

## Zoom correction — 2026-11-05

The original Zoom in action removed sizing constraints and showed the file at its native resolution. This could shrink a small image: the new browser regression reproduced a 256-pixel source returning to 256 pixels instead of the expected 1240-pixel zoomed width on desktop.

`packages/web-ui/src/private-evidence-gallery.tsx` now measures the fitted photo inside its `object-contain` box and enlarges that visible size by 2×, preserving its aspect ratio. The image is centered inside a keyboard-accessible scroll area. Fit image resets sizing and scroll offsets. The modal body uses one image scroll area even on a short phone viewport, retaining visible close/zoom controls and focus restoration.

This correction also updates `apps/vendor-web/src/components/PrivateEvidenceGallery.test.tsx`, `apps/vendor-web/src/pages/OrderFulfillmentPanels.test.tsx`, `apps/vendor-web/e2e/fulfillment-proof-layout.spec.ts`, and this note. No migration, API, authorization, credentials, dependencies or manual setup changes.

Fresh checks for this correction:

- Vendor gallery and fulfillment component tests: **23 passed**. Square, landscape and portrait cases assert doubled fitted dimensions, centered scroll offsets, Fit restoration and no additional file fetch.
- Vendor Orders and staff Fulfillment integration tests: **56 passed**.
- Admin compliance/verification component tests: **8 passed**.
- Playwright: **6 passed**, covering Pickup and Delivery at **320 × 568**, **768 × 1000** and **1440 × 1000**. Tests now measure actual rendered zoom dimensions and scroll centering, rather than checking only the button label; they also verify Fit restoration, modal containment and existing close/retry behavior.
- Both portals: lint, typecheck and production build passed. Shared gallery `oxlint.cmd` passed. Existing unrelated unused-variable and large-chunk warnings remain.
- Focused suites were used for this correction; the earlier full-suite counts above describe the 2026-11-04 run.

New browser coverage includes a generated 256 × 256 SAMPLE PROOF fixture and the existing public marketing image. Live customer photos were not accessed. Logs and pre-correction copies are under `.tmp/proof-zoom-fix/`; zoom screenshots are `apps/vendor-web/test-results/fulfillment-zoom-*.png`.

Suggested commit for this correction: `fix(ui): zoom evidence photos from fitted size`
