# Gross-remittance threshold review — 6 November 2026

## Outcome

Kept the existing FIN-04/FIN-04A backend and polished the Vendor Balance view in the shared Finance component. The annual panel now has an explicit Gross-remittance threshold heading, displays 0.2% for the supplied ₱1,019.64 example, and explains beside the progress meter why withholding applies below the threshold when no approved Sworn Declaration is recorded. Uploading a document is distinguished from approved relief. Other tax statuses retain their own explanations.

The progress percentage is presentation only. The API's recorded amounts, threshold status and crossing timestamp remain authoritative. Percentages display to one decimal, rounded down, with “Less than 0.1%” for positive smaller values. This does not change monetary rounding. The user explicitly confirmed retaining FIN-02 half-up centavo rounding.

Kept the white surfaces, existing tables, help dialogs and Xendit rail. The five tax-profile fields share one row when the annual workspace has at least 720px of content width; smaller layouts retain their responsive stacking.

## Existing implementation retained

| Requested capability | Existing implementation |
| --- | --- |
| Tax classification and annual totals | Canonical withholding states and taxpayer/year accumulators in `WithholdingThresholdService`; current tax-profile versions in `TaxpayerContext`. No duplicate `tax_status` flag or destructive annual counter reset. |
| Threshold crossing and retries | Transactional assessment and accumulator locking in `RemittanceAssessmentService`; whole crossing remittance subject at ₱500,000.01; repeated groups return their original assessment. |
| Exact money calculations | `Money::proportion` and `WithholdingThresholdEngine`; 0.5% of qualifying gross, half-up to integer centavos. |
| Separate tax accounting | Balanced `VENDOR_PAYABLE` / `CWT_CONTROL` postings in the simulated financial ledger; provider-withholder reconciliation prevents a duplicate deduction. |
| Evidence and review | Existing Store Verification tax-profile/document collection and authorized Admin evidence review. An upload does not grant relief. |
| Vendor transparency | Annual on-platform/declared outside-platform totals, retained-payment records, withholding breakdowns and issued tax-document access. |
| Reporting | Existing Admin tax packages for 2307, 0619-E, 1601-EQ and payee attachments, with independent review and SAMPLE/DEMO disclosures. Exports are not BIR filing. |

## Boundaries preserved

- Approved workflow authority: System FIN-01–FIN-12, Vendor tax evidence and the existing Finance UI planner.
- Taxable years use the recorded fiscal-year start in Asia/Manila. January 1 applies to January-start taxpayers; prior-year records remain intact, and a new year does not automatically approve relief.
- Commission remains the saved commercial policy, initially 2%, billed monthly. The illustrative 5% payout deduction was not adopted.
- Buyer receipt confirmation does not introduce a wallet, escrow release or a second withholding event. Xendit remains TEST-only and balances/withdrawals stay with the provider.
- No blanket `TAX_EXEMPT_SPECIAL` bypass or unrestricted Admin status override was added. A distinct statutory exemption/reduced-rate decision outside the current threshold-relief state machine requires its own approved evidence and policy scope; it must not silently bypass the final-for-year crossing rule.
- No migration, OpenAPI, generated-client, permission or production calculation changes. Owner-only Finance access, private evidence and immutable assessment history are unchanged. No new keys or manual setup are required for this patch.

The missing-declaration and whole-crossing-remittance wording was checked against [BIR RMC No. 8-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024.pdf). The current rate and responsibility are described in FIN-01 and [Xendit's account-specific guidance](https://docs.xendit.co/docs/withholding-tax-on-gross-remittances-ph); an account connection does not establish live withholding responsibility.

## Changed files

- `packages/web-ui/src/finance-patterns.tsx` — annual heading, percentage and conditional declaration explanation.
- `packages/web-ui/src/finance-overview.css` — explanation styling and compact desktop tax-profile row.
- `apps/vendor-web/src/pages/FinancePages.test.tsx` — progress boundaries and status-specific copy.
- `apps/vendor-web/e2e/finance-threshold-layout.spec.ts` — visible heading, accurate progress and adjacent explanation.
- `services/api/tests/Unit/PhaseElevenFinanceRulesTest.php` — half-cent boundaries, summing rounded remittances and large-amount precision.
- This verification record.

## Validation

- PHP finance unit suite: **31 passed, 105 assertions** (`php artisan test --compact --filter=PhaseElevenFinanceRulesTest`).
- PostgreSQL threshold feature suite in the isolated Docker test environment: **11 passed, 176 assertions** (`php artisan test --compact --filter=PhaseElevenWithholdingThresholdTest`). The host-only attempt could not resolve `postgres-test`; the container run passed.
- PHP Pint on the changed test: **passed**. Full PHPStan analysis: **passed, no errors** (`php vendor/bin/phpstan analyse --memory-limit=512M --no-progress`).
- Vendor and Admin lint/typecheck/build: **passed**. Vendor lint reports an existing unused `inStore` variable in the unrelated Admin layout fixture; builds report large-chunk advisories.
- Admin Finance and Tax components: **20 passed**. Full Admin component suite: **293 passed in 44 files** (`npm.cmd run test -- --run --maxWorkers=2`).
- Final Vendor Finance components: **61 passed** (`npm.cmd run test -- --run src/pages/FinancePages.test.tsx --maxWorkers=1`). JSDOM emits a navigation-not-implemented diagnostic for an existing download-link interaction; the test process exits successfully.
- Full Vendor component suite: **869 passed, 1 failed in 92 files** with the same command. The ready-mix Catalog test could not find `Configure mixer truck from this listing` within its asynchronous query window (`CatalogPages.test.tsx:75`). Its isolated rerun **passed, 1 test, 22 skipped**, using `npm.cmd run test -- --run src/pages/CatalogPages.test.tsx -t 'ready-mix variants require a mixer and link to listing-based vehicle setup' --maxWorkers=1`. This is an intermittent observation, not a claim that the full suite passed. Catalog code/tests were left unchanged.
- Playwright annual-threshold suite: **16 passed**, covering 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. Checks include no horizontal overflow, compact wide layout, relief, crossing, review, no assessment, retained-payment records, keyboard help-dialog opening, Escape dismissal and focus restoration. Inspected the final 1440px and 390px screenshots in `.tmp/finance-threshold-review/`.
- OpenAPI validation: **passed**, with eight unused-schema recommendations. Payments contract: **passed, 45 operations**. Admin Finance contract: **passed**.
- Repository and changed-file `git diff --check`: **passed**. Gitleaks scanning a temporary copy of all six current changed files: **passed, no leaks**. The staged-only scan also passed but had zero staged bytes and is not the security evidence for this patch.
- No live-provider or BIR filing acceptance is claimed. Buyer Flutter and the full API feature suite are outside this presentation-only change.

Suggested commit: `fix(finance): clarify annual remittance threshold and withholding reason`
