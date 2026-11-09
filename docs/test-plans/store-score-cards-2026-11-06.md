# Store Performance score-card refinement — 6 November 2026

## Outcome

The VCS, MQS and OHS cards retain their desktop columns and now match heights within each row, following the owner's follow-up request. Their top/bottom edges and bottom-anchored notes align, eliminating the uneven canvas gaps under shorter cards. The tallest card determines the row height without fixed heights or clipping. Tablet row peers also match, while stacked mobile cards size to their content. Each has a concise purpose description, a compact score/sample/publication summary and a smaller ring containing a relevant icon. Rating criteria retain their numeric star values and gain icons and fixed five-point decorative bars. OHS keeps all five factors, counts, rates, penalties and calculation help. An unpublished score remains neutral, with its existing eligibility explanation and sample progress next to the summary.

The equal-height follow-up supersedes the initial content-height decision. Operational KPI/history placement, VPS, badges, store health and navigation retain their existing arrangement.

## Files and boundaries

- `packages/web-ui/src/rating-ring.tsx` and `rating-ring.css`: optional summary layout and decorative icon. The default centered review-ring layout remains available and unchanged in presentation.
- `packages/web-ui/src/store-performance-overview.tsx` and `store-performance.css`: compact score summaries, criterion/factor icons and bars, equal row heights and quiet dividers.
- `apps/vendor-web/src/pages/TrustPages.tsx`: purpose descriptions and criterion icons; existing server fields and score gate helpers remain the source of displayed values.
- Vendor component tests and `e2e/store-performance-layout.spec.ts`: publication gates, samples, exact values, missing criterion bars, equal row heights, aligned notes, layout geometry and the screenshot's mixed publication state.
- UI/UX planner: records the score-card layout decision.

No migrations, API contract, generated-client, backend, provider, scoring, penalty, ranking or authorization changes. Store Performance keeps `scores.view_store`; no new data or grants. VCS retains the combined Delivery/Processing Speed criterion and MQS retains its eligible publication gate. OHS retains its ten-order minimum, 30-day window and weekly cadence. Rings/bars/icons are decorative and have no inferred score, fabricated progress or new interaction. Text and existing meters retain the accessible meaning. No dependencies, setup keys or external assets were added; nothing was deployed.

## Verification

- Vendor lint passed, with the existing unrelated `inStore` unused-variable warning in `e2e/admin-finance-layout.spec.ts:31`.
- Vendor and Admin typechecks passed.
- Focused Vendor tests: **49 passed** in `TrustPages.test.tsx`, `ProductAnalyticsPages.test.tsx` and `VendorDashboardInsights.test.tsx`.
- Admin shared-component regression: **19 passed** in `TrustPages.test.tsx`.
- Vendor and Admin production builds passed; both retain Vite's existing large-chunk recommendation.
- Responsive browser checks: **16 passed (30.9 seconds)** across Store Performance and Ratings & Reviews, at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 pixels.
- Scoped diff whitespace check passed; Gitleaks scanned the nine task files with **no leaks found**.

Browser acceptance covers published, fully unpublished, and the supplied mixed state: VCS/MQS at 4.00 from six eligible ratings while OHS has seven of ten required orders and no published numeric value. Exact factors and help remain visible; missing values produce no filled score arc or criterion bar. Cards sharing a row have equal widths/heights and aligned note bottoms in all three publication states. All viewports avoid horizontal overflow and retain the existing no-table/no-dropdown behavior. Visual review confirmed crisp summary icons, compact OHS rows and the unchanged centered ring on Ratings & Reviews. An icon size/stroke assertion guards against inherited ring styles obscuring the icons.

Equal-height follow-up: CSS, responsive assertions and these design/QA notes only. Vendor lint, typecheck and production build passed, retaining the unrelated unused-variable warning and large-chunk recommendation above. All **8 Store Performance browser checks passed (16.0 seconds)** at the same eight widths, covering equal heights and aligned note bottoms in published, mixed and fully unpublished states. Desktop mixed-state screenshot review confirmed matching card edges. Scoped whitespace check passed and Gitleaks found no leaks in the four follow-up files. No component, backend, Admin or Flutter tests were repeated for this CSS adjustment.

The default centered ring is shared with Ratings & Reviews, so the Admin and Vendor trust tests are included. React review checks stable components, semantic sections/definition lists/figcaptions, decorative SVG/icon accessibility and unchanged loading/retry effects. The full portal suites and backend/Flutter suites are not repeated for this visual slice. Mocked browser fixtures do not prove live API or user acceptance.

Suggested commit for the follow-up: `fix(vendor): equalize store score card heights`.
