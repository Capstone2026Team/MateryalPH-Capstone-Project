# Store onboarding section layout — 20 September 2026

## Outcome

Store Verification has five steps and Store Setup has six. The stepper uses equal-width desktop columns, readable 14px labels with natural wrapping, and responsive rows on smaller screens. It has no horizontal scrolling, scrollbar or scrolling arrows. Compact button-style Store Verification / Store Setup controls beside the header replace the former full-width workstream strip. Each uses the same numbered horizontal navigation, orange active state, server-confirmed completion indicators, current step count, and consistent bottom action area. Only the selected section is visible or keyboard-accessible. The requirement checklist is available in the final review step rather than occupying a permanent side column.

Verification sections: Business Information (including Business Type, legal identity, email verification, primary contact, business registration and compliance evidence); Registered Business Address; Supplier Type / Classification; Tax Profile; Privacy, Review and Submit (including the existing acknowledgement and requirement summary).

Setup sections: Public Store Profile (including Store Media uploads and preview); Fulfillment Configuration (bulk capability, fulfillment method, delivery coverage and vehicle fields); Xendit TEST Connection; 2% Commission Terms; Team Accounts; Review and Complete.

Switching steps preserves native form values without saving automatically. Save Draft and Finish Later retain the existing request builders, version checks and dashboard destination. Unsaved edits are identified on review and must be saved before final submission/completion. Privacy and commission choices remain in memory across step changes; the existing final endpoints record them. Changing Business Type updates its conditional identity fields before saving. The address map initializes only when its step is selected.

The Public Store Profile step has an editable form and a marketplace-style preview with a banner, overlapping logo, name, description, public contact details and city/province summary. Text changes appear immediately. Store Media is now a subsection alongside the public-profile editor and preview; successful uploads refresh the preview without discarding unsaved fields. Missing media has structured placeholders; failed previews have a retry control. Private staff contacts, tax data and evidence are excluded.

## Changed files and boundaries

- `apps/vendor-web/src/components/OnboardingFlow.tsx`: shared step navigation, focused content surface and actions.
- `apps/vendor-web/src/lib/onboarding-steps.ts`: section labels and mappings to existing requirement keys.
- `apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx`: section composition, retained forms and handlers, acknowledgement state, review summaries and public preview.
- `apps/vendor-web/src/pages/VendorNavigation.test.tsx`: interaction and preview regression coverage.
- `apps/vendor-web/e2e/onboarding-steps.spec.ts`: responsive browser checks and fixture screenshots.
- This report and `docs/design/evidence/onboarding-sections/` screenshots.

No migrations, API contract/generated-client changes, backend rules, approval rules, payment rules, activation rules or new dependencies. Private images continue to use the existing authorized, short-lived URL endpoint. Existing Owner/delegated permissions and Team Accounts availability remain enforced; the optional Team Accounts step explains the existing post-setup invitation route.

## Validation

Commands run in `apps/vendor-web` unless otherwise indicated:

| Check | Result |
| --- | --- |
| `npm.cmd run typecheck` | Passed |
| `npm.cmd run lint` | Passed, no lint findings |
| `npm.cmd run test -- --run` | 59 tests passed in 9 files |
| `npm.cmd run build` | Passed; existing >500 kB bundle advisory remains |
| `npm.cmd run test:e2e -- e2e/onboarding-steps.spec.ts --config=.onboarding-check.config.ts` | 16 passed in 23.4 seconds at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px |
| Root: `gitleaks dir apps/vendor-web/src --redact --no-banner` | No leaks |
| Root: `gitleaks dir apps/vendor-web/e2e --redact --no-banner` | No leaks |
| Root: `gitleaks git --staged --redact --no-banner` | No staged changes; no findings |
| Root: `git diff --check` | Passed |

To avoid the previously observed Windows Playwright webServer teardown hang, this run inherited the repository Playwright config through a temporary config with `webServer` disabled and used a separately running Vite preview server. The temporary config was removed. The checked-in spec can normally be run with `npm.cmd run test:e2e -- e2e/onboarding-steps.spec.ts`.

Coverage includes step isolation, focus transfer, retained fields, legal-identity conditional rendering, save payload preservation, Finish Later success/failure, combined acknowledgement/review content, unchanged final request shapes, Team Accounts gating, server-sourced completion, live public text, upload-to-preview refresh, failed-image fallback, reduced-motion keyboard use and no horizontal page or stepper overflow. Browser assertions require five/six step buttons, at least 14px label text, all buttons inside the navigation bounds, and one equal-height row at desktop widths of 1024px and above. Compared the original and updated forms: no named verification or setup fields were removed.

Reviewed desktop and mobile screenshots use synthetic API/media fixtures. The image files illustrate layout, not live account or provider readiness.

## Remaining limits and manual checks

- No new setup, environment variables or API keys are required.
- Existing logo/banner support is reused. Operating hours and additional store-gallery media are not implemented by the current onboarding surface and are not fabricated in the preview.
- Live authenticated file scanning/storage, email OTP, map provider, and Xendit reconciliation were not exercised in this UI-only task. Their existing backend validation remains unchanged.
- Backend/Admin/Buyer suites were not rerun because these files and contracts did not change.
- Detailed individual sections can still scroll on small screens; other sections are never stacked underneath them.
- No deployment, push, merge, database mutation or commit was performed.

Suggested commit: `refactor(vendor): consolidate onboarding steps and remove navigation overflow`
