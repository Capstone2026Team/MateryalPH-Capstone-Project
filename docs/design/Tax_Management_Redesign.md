# Withdrawn: Admin Tax Management redesign

**Withdrawn by the owner on 2026-11-09.** The Tax Management page has been removed from the capstone Admin interface. This document records the abandoned design; it does not describe an active page. See [the removal decision](Tax_Management_Removal.md).

## Before -> after screen map

These are ten previous surfaces, including dialogs and supporting views, rather than ten separate routes.

| Previous surface | New destination |
| --- | --- |
| 1. Tax Remittance landing card | Withholding tab; duplicate introduction removed |
| 2. Vendor tax register | Withholding; month, one summary line, responsive Vendor ledger |
| 3. View calculation dialog | Vendor row -> existing shared right-side panel |
| 4. BIR reports list | BIR filings; grouped by calendar quarter |
| 5. Prepare BIR report form | New filing; payment month is the only input |
| 6. BIR report details | Filing detail; progress, totals, named Vendor lines and downloads |
| 7. Independent report review dialog | Review filing; retains version, deadline citation and explicit reconciliation |
| 8. Remittance reconciliation | Issues source links; legacy ledger and protected backup approval remain available |
| 9. Open/resolved finance work queue | Issues shows action items; resolved history is behind Audit log |
| 10. Withholding threshold list/history | Approved-declaration yearly meter in the Vendor drawer; historical routes remain usable |

Primary navigation is **Withholding | BIR filings | Issues [count]**. The filing progress indicator is a status sequence, not another navigation tier.

## Screen behavior and consistency

- Existing Admin sidebar and header, `PageHeader`, `FilterTabs`, `ControlBar`, `Button`, `Field`, `StatusBadge`, `DenseLedgerTable`, `SidePanel`, `FormDialog`, loading and request-error components.
- Existing light surfaces, orange primary action, semantic border/text colors and shared type scale. No new visual theme or dependencies.
- One demo notice in the app header. Plain labels and icon-plus-text neutral/amber chips; red for actual errors.
- The monthly summary uses saved platform withholding, Vendor count and payment count. Any provider withholding stays explicitly separate from the platform return.
- The table's taxable amount is the saved payments-minus-deductions amount before relief. The drawer separately shows the portion subject to withholding and the portion covered by relief.
- True minus signs in the receipt. The emphasized result is the saved sum of independently rounded payment taxes; the browser never recomputes withholding.
- Vendor/payment/filing tables become the existing responsive ledger cards at small widths, including 375px. Numeric cells use right alignment and tabular numerals. Controls retain shared 44px targets and visible focus.
- Missing, pending, rejected and expired declarations never display a limit meter. Approved evidence can display the stored full taxpayer-year total, including other stores and declared external remittances; it is independent of the selected month. Crossing remains final for that year.
- Filings group by quarter. Month 1 or 2 derives 0619-E; month 3 derives 1601-EQ with the quarter start. Return, alphalist and Vendor 2307 support retain their existing package review/export process.
- Issues includes open work and otherwise unqueued source blockers, with exact paginated totals. A source blocker links to correction; it cannot be dismissed using a work-item resolution mutation. Resolved work and voided sources are excluded.
- Loading and errors preserve the shell, tabs and month control. Explicit empty months remain selected; the user can request the latest recorded month. Request failures offer manual retry. No automatic mutation retry was added.

## Label changes

| Before | After |
| --- | --- |
| Tax Remittance / Vendor tax | Withholding |
| Tax Reconciliation / Work queue | Issues |
| BIR reports | BIR filings |
| Prepare BIR report | New filing |
| Collection month | Payment month |
| Collections | Payments |
| Tax basis / Remittance base | Taxable amount |
| Vendor tax withheld / Simulated Withheld | Withheld 0.5% |
| FIN-04A withholding accumulators | Yearly taxpayer limits |
| Reviewed due date | Reviewed deadline |
| Review report / Approve report | Review filing / Approve filing |
| Demo submission recorded | Filing rehearsal recorded; export progress stays Exported |
| UUIDs, internal rule codes, receipt-reference flags | Hidden by default under Details |

“Platform fees” in the receipt means the **saved qualifying payment-service charge**. It does not add monthly commission to the deductions; commission remains separately billed.

## Rationale

The page starts with the monthly task and reveals supporting detail only when a Vendor is opened. Filings and actions have direct destinations, with no nested tab hierarchy. Shared components preserve familiarity with the other Admin pages. Source blockers remain visible without presenting internal codes as instructions.

## Rules retained and verified sources

The owner confirmed preserving the existing whole crossing-payment rule. Missing approved relief applies standard withholding from the first peso; approved eligible relief applies up to the limit, then the **whole crossing payment** and later payments are covered. No excess-only calculation was introduced. Existing unit/feature tests assert this rule and centavo rounding.

- [BIR RR 5-2025](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%205-2025.pdf): 0.5% on gross remittances.
- [BIR RMC 8-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024%20(1).pdf): declaration and threshold guidance; see Q4 and Q7.
- [System workflow](../workflows/MateryalPH_Final_System_Workflow.md): authoritative computation, taxpayer-year scope and filing calendar.

## Implementation boundary

No migrations or assessment/threshold-engine changes. Two finance.view-protected read projections were added: paginated Vendor payment/declaration context and the action queue. Filing details add a display-name map without changing immutable snapshots. OpenAPI and both generated clients were regenerated.

Maker-checker, source-version checks, deadline citation, idempotency, protected document access, backup-approval checks and append-only history remain enforced by their existing services. A demo export/rehearsal never completes Filed or proves payment to BIR. Real filing rejection/evidence must come from a future supported external-evidence flow; no new legal status is persisted by this redesign.

## Screens

Synthetic browser fixtures only; these images do not contain production financial data.

| Desktop | 375px |
| --- | --- |
| [Withholding](evidence/tax-management/1440-withholding.png) | [Withholding](evidence/tax-management/375-withholding.png) |
| [Vendor drawer](evidence/tax-management/1440-drawer.png) | [Vendor drawer](evidence/tax-management/375-drawer.png) |
| [Limit crossed](evidence/tax-management/1440-limit-crossed.png) | [Limit crossed](evidence/tax-management/375-limit-crossed.png) |
| [Filings](evidence/tax-management/1440-filings.png) | [Filings](evidence/tax-management/375-filings.png) |
| [Filing detail](evidence/tax-management/1440-filing-detail.png) | [Filing detail](evidence/tax-management/375-filing-detail.png) |
| [New filing](evidence/tax-management/1440-new-filing.png) | [New filing](evidence/tax-management/375-new-filing.png) |
| [Issues](evidence/tax-management/1440-issues.png) | [Issues](evidence/tax-management/375-issues.png) |
| [Everything matches](evidence/tax-management/1440-issues-empty.png) | [Everything matches](evidence/tax-management/375-issues-empty.png) |

## Validation (2026-11-09)

| Check actually run | Result |
| --- | --- |
| Admin lint, typecheck and build | Passed; build retains the bundle-size advisory |
| Vendor typecheck (shared UI/client compatibility) | Passed |
| Focused Admin Tax Management, filing and finance components | 53 passed |
| Chromium desktop 1440px and mobile 375px: tabs, filing review, drawer, SD states, errors and legacy reconciliation | 6 passed; no horizontal page overflow |
| Isolated finance regression: PhaseElevenFinanceRulesTest, PhaseFifteenExportsTest and PhaseElevenWithholdingThresholdTest | 60 passed, 655 assertions |
| New Vendor drawer feature test (run separately) | 1 passed, 43 assertions |
| New source-issue projection feature test (run separately) | 1 passed, 33 assertions |
| Native PHP calculation/rule unit suite | 31 passed, 105 assertions |
| Targeted Pint and full configured PHPStan analysis | Passed; PHPStan reported no errors |
| OpenAPI validation and TypeScript finance/queue/drawer contract transport | Passed; validator retains eight unused-model recommendations |
| Generated TypeScript client build | Passed |
| Dart built_value serializer generation and contract round trip | Passed using the installed Dart SDK directly; eight outputs plus supporting generated files rebuilt |
| Compose configuration | Passed without printing configuration values |
| Gitleaks task-source scan and staged scan | No leaks found |
| Scoped diff whitespace check | Passed |

The full Admin run produced **412 passed / 5 failed**. A separate retry of the three affected files with a 30-second timeout and one worker produced **18 passed / 3 failed**: Vite configuration and Integration Health passed; the remaining three `UserDirectoryMedia.test.tsx` failures expect an `Open Enforcement` link. Those directory/media flows were not changed in this task. The full suite was not rerun after that isolation check, so this is not a clean full-suite claim.

Browser evidence uses synthetic intercepted API responses. The new read projections were separately exercised against the isolated PostgreSQL test database; no development records were reset or migrated. Live provider/BIR filing or payment acceptance, full PHP tests and full Buyer/Vendor test suites were not run. No new secrets, configuration keys, migrations or manual setup are required for this redesign.

Suggested commit: `feat(admin): simplify tax management workspace`
