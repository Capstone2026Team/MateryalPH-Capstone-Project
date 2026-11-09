# Admin Vendor withholding and BIR remittance

Platform Finance → Tax remittance adds a monthly register, separate platform/provider assessment totals, review flags and the existing filing-package, correction and evidence workflows. Uses existing shared financial cards, chips, tables, pagination and dialogs. Original assessment values remain distinct from corrected package totals. No migration, financial formula, new permission or real-money operation is introduced.

## Source-based implementation

Reviewed 6 November 2026:

- [Xendit gross-remittance withholding guidance](https://docs.xendit.co/docs/withholding-tax-on-gross-remittances-ph): the final controlling facility and account-specific settlement arrangement determine responsibility. Keep provider and platform scenarios separate; connection alone is not a responsibility assignment.
- [BIR RMC 8-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024%20(1).pdf): merchant withholding, evidence and Form 2307 obligations. Existing FIN-01–FIN-12 rules remain authoritative for implementation.
- [BIR forms and instructions](https://www.bir.gov.ph/bir-forms): 0619-E monthly remittance support for the first two calendar-quarter months, 1601-EQ quarterly reporting and prior monthly remittances, and Form 2307 payee certificates. The application prepares support packages; filing and payment are separate external processes.
- [BIR RMC 55-2026](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2055-2026.pdf): payee schedules remain separate supporting submissions. Existing reviewed calendar and export controls are retained.

The page describes the real process but records only DEMO assessments and sample submissions. Production withholding responsibility is UNCONFIRMED. No screen claims that the platform has custody of the displayed tax, that Xendit actually deducted it, or that a BIR payment occurred. A future live implementation needs legal assignment plus validated deduction, funding, filing, payment and issuer evidence; it cannot be activated by a UI toggle.

## Contract and authorization

`GET /api/v1/admin/finance/withholding-register?month=YYYY-MM&page=1` requires existing `finance.view` and web cookie/CSRF transport. The query uses collection timestamps with inclusive Asia/Manila month boundaries, TEST sources, non-voided assessment scope and POSTED tax totals. Full-scope totals do not depend on the current 25-row page. Vendor rows group by organization and assigned entity. No TIN, document, provider payload or private staff contact is returned.

Existing package review/export/external-evidence permissions, independent reviewer requirement, immutable snapshots and audit events remain enforced. Package lists now include the existing `submission_state`; list/detail status and the repeat-action guard use it. Export is never presented as tax payment. Legacy Finance and report URLs stay supported.

## Checks

- Admin: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run --maxWorkers=2`, `npm.cmd run build`.
- API: isolated `PhaseFifteenExportsTest` register and package tests; focused Pint and full PHPStan.
- Contract: OpenAPI validation, regenerated TypeScript/Dart clients, generated TypeScript build and `npm.cmd run test:admin-finance-contract`.
- Review whitespace and redacted secret scan on changed/new task files.

## Acceptance

Executed validation on 6 November 2026:

- Admin lint, typecheck and production build passed; full Vitest suite passed **45 files / 298 tests**. The build retains its large-chunk advisory.
- Focused isolated API tests passed **3 tests / 88 assertions**, including responsibility separation, collection-month scope, totals independent of pagination, exact centavos, read-only source preservation, invalid month and denied access. Existing package tests cover independent review and sample-only exports.
- Focused Pint and full PHPStan passed. Isolation guard and its negative cases passed; no normal development database was migrated or reset.
- OpenAPI validation passed with eight unused-model recommendations. TypeScript/Dart source generation, generated TypeScript build, Dart serializers and both register contract checks passed. The Flutter SDK batch launcher stalled in the restricted session; direct installed Dart SDK execution completed generation and the serialization check.
- Playwright fixture checks passed at **1440, 390 and 320 CSS pixels**: real Admin shell, shared-card styling, internal table scrolling, no page overflow, month-to-form context, dialog bounds and Escape dismissal. Desktop/mobile screenshots were visually inspected. Evidence: `.tmp/analytics-review/admin-tax-remittance/`.
- Whitespace checks passed. Redacted secret scan of the task source bundle passed; staged scan found no staged content.
- Full backend and Flutter suites, authenticated live-data browser/device checks, and live provider/BIR acceptance were not run. No migration or new environment key is required.

1. Open Tax remittance on desktop and narrow screens. Confirm the four-step explanation, compact cards, month input and internally scrolling Vendor table.
2. Change month; verify collection-month totals, no stale data, reset pagination and explicit empty/error/retry states. Provider amounts must not be added to the platform return or revenue.
3. Open Filing packages from the register. The month is retained. First/second quarter months suggest 0619-E; the third suggests 1601-EQ and the quarter's first day.
4. Prepare, independently review and export a sample package. Check deadlines, stale-source rejection, source blockers and protected download as before.
5. Record a demo submission, then refresh/reopen the package and list. The submission remains visible and the action is no longer offered. Nothing is labelled BIR-paid or actually filed.
6. Review adjustments/evidence and legacy URLs. Finance denial must clear figures; exports and review still enforce their existing permissions.

Authenticated browser/device and live-provider/BIR acceptance must be distinguished from fixture-based UI and API checks.

## Running development server cache correction

The existing Admin Vite process retained an optimized API client from before the register method was generated. The rebuilt client contained `getWithholdingRegister`, but the cached browser module did not; the page raised a client error before sending its register request. Startup-only optimizer forcing does not refresh an already running server.

Admin Vite now watches the generated ESM client build and debounces a forced optimizer restart after JavaScript changes settle. The watcher is development-only and is removed when the server closes. Editing the configuration refreshed the existing server without changing finance data, permissions, API behavior or the screen layout.

Verified the running server serves the new method and that a subsequent generated-module change refreshes the cache automatically. Lint, typecheck and production build passed; the existing large-chunk advisory remains. A browser check against the running dev server, with synthetic API responses, confirms that the request is sent and the Vendor register renders. It does not assert authenticated live-data acceptance.
