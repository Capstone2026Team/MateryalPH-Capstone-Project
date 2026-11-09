# Vendor tax calculation and BIR report preparation

The Tax Remittance default view now shows Vendor tax withheld, the calculation formula and a Vendor table with tax basis, tax withheld and View calculation. The dialog uses the shared FinanceCalculationBreakdown to show original posted collections, refunds, delivery, materials VAT and provider charges, followed by the taxable/relieved basis and recorded withholding. Monthly withholding remains the sum of per-collection rounded amounts. Zero provider totals and the unexplained review-count card/badges are removed.

Prepare BIR report opens the existing preparation dialog directly from the resolved collection month. Monthly/quarterly form defaults, independent report review, private exports, source blockers and external filing/payment remain enforced. Filing issues are readable inside the calculation dialog; viewing amounts requires no approval. Tax Reconciliation remains a separate view.

## API and data boundaries

- The existing `GET /api/v1/admin/finance/withholding-register` adds each Vendor row's `calculation` and bounded `filing_issues` fields. TypeScript and Dart clients are regenerated from OpenAPI.
- Calculation components include only POSTED assessments, matching the original withholding sum. Voided assessments remain excluded; non-posted sources remain visible as filing issues without inventing amounts.
- The existing `finance.view` authorization, pagination, TEST scope, Asia/Manila collection-month boundaries, entity separation and immutable source history remain unchanged.
- No migration, new permission, environment key, provider call, money transfer or BIR submission is introduced. Original figures and reviewed report corrections remain distinct.

## Verification

- API: exact saved components, platform/provider separation, relief basis, readable source issues, read-only history, default/explicit months, pagination and denied finance access.
- UI: calculation dialog deductions, saved withholding, readable issue, no approval step for viewing, direct monthly/quarterly report defaults, empty/denied responses and month changes.
- Contract: OpenAPI validation, TypeScript transport/deserialization and Dart serialization of the new fields.
- Browser fixtures: register, calculation dialog and direct report preparation at 1440, 390 and 320 CSS pixels, no horizontal page overflow, shared styling and Escape dismissal. Fixtures establish presentation and routing only; authenticated data, live-provider and BIR acceptance remain separate.

Commands: Admin lint/typecheck/Vitest/build; isolated API `PhaseFifteenExportsTest` withholding/package cases; focused Pint and full PHPStan; API-contract validation and finance checks; Dart build_runner and withholding serialization check; Playwright `admin-tax-remittance.spec.ts` and `admin-tax-management.spec.ts`.

## Results — 8 November 2026

- Targeted API tests passed: **5 tests / 170 assertions**, including the existing independent-review/sample-export test. The isolated database guard passed. An initial test fixture attempted to change protected historical profile fields and was rejected by the existing immutability trigger; the fixture was corrected without changing the protection.
- Focused Admin component tests passed: **2 files / 13 tests**. Admin lint, typecheck and production build passed; the existing large-chunk advisory remains.
- Browser fixtures passed: **6 tests** across 1440, 390 and 320 px. Register and calculation/preparation screenshots were visually inspected under `.tmp/analytics-review/admin-tax-remittance/`.
- OpenAPI validation passed with eight unused-model recommendations. Regenerated TypeScript build, finance contract checks, Dart build_runner and the Dart withholding/reconciliation serialization check passed. Dart required normal access to its user tool-state and installed Pub cache; no new package or environment key was required.
- Focused Pint, full PHPStan, scoped whitespace checks, isolated Compose validation and the redacted source secret scan passed. The staged secret scan found no staged content.
- Full Admin suite: **400 passed / 4 failed** across **51 passed / 2 failed files**. One failure was the Vite server test's five-second startup timeout. Re-running the two failing files with a 20-second timeout passed that Vite test and left **3 directory-media assertions** expecting an `Open Enforcement` link. Those directory/enforcement files were not changed by this task; no claim is made that the complete Admin suite passes.
- Full backend, Vendor and Buyer suites, authenticated live-data acceptance and actual BIR/provider filing/payment were not run.

Suggested commit: `fix(admin): simplify vendor tax calculations and BIR report preparation`
