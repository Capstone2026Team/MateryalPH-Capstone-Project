# Finance transaction Tax basis breakdown

The Payments list now has an explicit **View breakdown** action below each retained Tax basis. The shared calculation popup presents two numbered steps: the saved collection and exclusions, then the saved effective rate and withholding amount. It uses a white surface, aligned amounts, a wider desktop popup, bounded mobile scrolling and a sticky close/header area.

## Files and scope

- `packages/web-ui/src/finance-patterns.tsx`: shared tax breakdown using recorded assessment amounts, with relief, missing-value and review handling.
- `packages/web-ui/src/finance-overview.css`: numbered steps, compact calculation rows and aligned totals.
- `packages/web-ui/src/calculation-help.tsx` and `.css`: optional visible trigger label and wide popup; existing icon-only callers keep their default behavior.
- `apps/vendor-web/src/pages/FinancePages.tsx`: maps the additional recorded assessment fields into the shared UI.
- `services/api/app/Domain/Finance/VendorFinanceService.php`: read-only projection of saved delivery, VAT and effective rate.
- `packages/api-contract/openapi.yaml`: documents nullable `assessment_delivery_centavos`, `assessment_vat_centavos` and `assessment_rate_basis_points` on the existing dynamic transaction rows; regenerated TypeScript/Dart documentation accompanies the change.
- `apps/vendor-web/src/pages/FinancePages.test.tsx`, `apps/vendor-web/e2e/finance-transactions-layout.spec.ts`, `services/api/tests/Feature/Api/VendorEarningsTrendTest.php` and `packages/api-contract/scripts/check-payments-contract.mjs`: focused regression coverage.

No migration, calculation-rule change, route change or new write operation is required. Existing Owner-only authorization and Vendor/order/payment/environment assessment matching remain in place. The read-only fields require no audit/notification event or manual configuration. Voided assessments retain their existing history display. Later refunds do not rewrite the posted tax basis, rate or withholding.

## Acceptance example (TEST fixture)

| Recorded component | Amount |
| --- | ---: |
| Payment received, including Buyer processing fee | ₱293.05 |
| Refunds before assessment | ₱0.00 |
| Separately billed delivery | ₱0.00 |
| Included material VAT | −₱30.59 |
| Payment provider charge, removed once | −₱7.55 |
| Tax basis | **₱254.91** |
| Applied rate | 0.5% |
| Withholding tax (half-up) | **₱1.27** |

Do not subtract the Buyer fee again. Delivery and included VAT stay in the Vendor payment even though excluded from the tax basis. Commission remains billed separately. A missing original amount renders `—`; it is never reconstructed as zero. A review-state assessment is explicitly unfinalized and has no finalized rate calculation.

## Validation

- Vendor: `npm.cmd run test -- --run src/pages/FinancePages.test.tsx src/components/SharedPortalPatterns.test.tsx` initially passed 74 tests; after three additional edge cases, the Finance file passed 67 tests (77 unique Vendor tests across both files).
- Admin shared-component regressions: `npm.cmd run test -- --run src/pages/FinancePages.test.tsx src/pages/FinanceTaxPages.test.tsx` passed 20 tests.
- Vendor and Admin `npm.cmd run typecheck` passed. Vendor `npm.cmd run lint` and `npm.cmd run build` passed. Existing unused-variable lint and large-bundle notices remain non-blocking; jsdom reported unsupported navigation during passing tests.
- API: `php artisan test tests/Feature/Api/VendorEarningsTrendTest.php --compact` passed **12 tests / 928 assertions** in the dedicated `materyalph_tax_basis_test` Compose project after its isolation guard passed.
- `php vendor/bin/pint --test app/Domain/Finance/VendorFinanceService.php tests/Feature/Api/VendorEarningsTrendTest.php` passed; `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` passed.
- `npm.cmd run validate`, `npm.cmd run generate` and `npm.cmd run test:payments-contract` passed; payment contract coverage checks 45 operations, transport and authorization middleware.
- Final browser command: `npm.cmd run test:e2e -- e2e/finance-transactions-layout.spec.ts --output=../../.tmp/tax-basis-review/playwright-final --reporter=list --trace=off` passed all **8** widths: 320, 375, 390, 768, 1024, 1280, 1440 and 1920px. It verifies deductions, unchanged payment/remittance totals, no horizontal overflow, keyboard activation, popup bounds, lower content and close-control visibility, Escape and focus restoration.
- Screenshots were visually inspected at desktop and narrow mobile widths. Artifacts are under `.tmp/finance-transactions-review/`.
- Scoped `git diff --check` and an explicit trailing-whitespace check on all task files passed. `gitleaks git --staged --redact --no-banner` found no leaks in an empty staging area; a separate `gitleaks dir` scan of the actual task files and generated documentation found no leaks. `docker compose config --quiet` passed.

Initial attempts against the shared test database failed during migration setup with missing/duplicate tables before any assertions. The same suite passed in a separate Compose project. An intermediate browser run lost shared artifact files; another overlapped a rebuild and could not load two pages. The final run completed after the build with its own output directory. These failed attempts are not counted as passing checks.

The dedicated test containers were stopped after validation; their test volume was retained. No deployment or real provider/BIR action was performed. Full monorepo suites and live-provider acceptance are outside this focused UI/read-projection verification. Suggested commit: `fix(finance): explain transaction tax basis breakdown`.
