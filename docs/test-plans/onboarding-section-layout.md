# Store onboarding section layout — 20 September 2026

## Single Store Email field — 21 September 2026

This refinement supersedes the earlier Business Information arrangement below. Registered Business Name and Date Established share the first row; Store Name spans the second. A subtle divider introduces Store Contact Information, with equal-width, equal-height Store Email and Store Phone inputs on the same desktop/tablet row and stacked mobile fields.

There is exactly one named `store_email` input. It starts read-only with Change. Change makes that same input editable and replaces the action with Send Code in a fixed-width area. The existing request/confirm endpoints use this value. Successful confirmation refreshes the authoritative snapshot, clears the code, returns the field to read-only and restores Change. Verified is shown only when the displayed normalized address matches the server-confirmed Store Email. Pending/replacement addresses never inherit the previous address's verification. Editing after requesting a code clears the old challenge UI; failed requests and confirmations remain recoverable. Store Phone remains an ordinary contact field.

Changed `PhaseThreeVendorPages.tsx`, `VendorNavigation.test.tsx`, `e2e/onboarding-steps.spec.ts`, this report and Business Information screenshot evidence. No migrations, API contracts, generated clients, backend authorization or activation rules changed. The server still preserves the existing verified email until a replacement passes OTP confirmation. No new setup or keys are needed.

Validation: Vendor typecheck, lint and build passed; 62 tests in 9 files passed; 16 browser checks passed in 18.1 seconds across 320–1920px. Regression coverage includes initial read-only state, a single email field, change/confirm/re-change, matching-address badges, pending replacements, cleared challenges, request/confirmation failures and draft payloads. Browser checks verify field ordering, matching contact input dimensions and stable widths/heights between Change and Send Code. Desktop/mobile screenshots were reviewed. Source/E2E secret scans and `git diff --check` passed; no staged content was present. Live email delivery/OTP services were not exercised; the existing bundle-size advisory remains.

Suggested commit: `fix(vendor): unify store email verification and align business fields`

## Business information spacing — 21 September 2026

Balanced the two business-name fields in one row and grouped date established, store phone and store email in a second desktop row, with more width for email. Tablet and mobile layouts reflow without an empty half-row or horizontal overflow. The email-verification area now pairs the status, current verified address and explanatory text with a bounded email/OTP action column. Inputs and action buttons share a 48px height. Existing email fields, required flags, send/confirm handlers, OTP validation, draft builders and authorization remain unchanged. The verified-address label distinguishes the saved address from a replacement awaiting verification.

Changed the Business Information and EmailVerificationPanel markup in `PhaseThreeVendorPages.tsx`, the existing onboarding browser spec, this report and screenshot evidence. No migrations, API changes, setup or new keys. Vendor typecheck/lint/build passed, all 59 component tests passed, and all 16 browser checks passed in 20.3 seconds. Browser checks additionally verify desktop field-row alignment and matching input/button geometry. Source/E2E secret scans and diff whitespace checks passed. Desktop/mobile section screenshots were reviewed; live email delivery and OTP services were not retested. The existing bundle-size advisory remains.

Suggested commit: `style(vendor): balance business information and email verification layout`

## Header and stepper polish — 21 September 2026

Refined the supplied header and Tax Profile stepper reference. Back to dashboard now precedes the title as a quiet navigation link. The title, status and description share a consistent left alignment; the two onboarding-area buttons form a compact paired control on the right at desktop widths, and reflow together below the title on smaller screens. This removes the isolated dashboard link beneath the area buttons and the extra header divider.

The stepper separates progress metadata with a subtle divider, uses evenly padded equal-height steps and 32px number circles, and highlights the current step with a pale orange surface and underline. Labels remain 14px, wrap naturally, and never require horizontal scrolling. Completed states remain server-derived. No fields, requirements, handlers, authorization, API contracts or migrations changed.

Changed files for this refinement: `PhaseThreeVendorPages.tsx`, `OnboardingFlow.tsx`, `e2e/onboarding-steps.spec.ts`, this report and the onboarding screenshot evidence. The browser fixture now shows realistic requirement totals and captures the Tax Profile header/stepper.

Validation rerun: Vendor typecheck, lint and production build passed; 59 tests in 9 files passed; 16 browser checks passed in 23.9 seconds at the eight viewport widths listed below. Source and E2E secret scans and `git diff --check` passed. The staged scan found no staged content. Desktop and mobile screenshots were reviewed. The existing >500 kB build advisory remains; live providers were not retested. No new setup or API keys are required.

Suggested commit for this refinement: `style(vendor): refine onboarding header and step navigation`

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
