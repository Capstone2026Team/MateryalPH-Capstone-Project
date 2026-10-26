# Admin supporting tax tools — 2026-10-26

## Scope

Keep Overview, Commission Management, Payments and Refunds, and Reconciliation as the four main Finance views. Reconciliation → Tax records contains a small selector for Tax adjustments, Tax support packages, and Tax evidence. This supersedes the earlier removal of the adjustment controls from the Finance interface.

- Adjustments use the existing prepare → independent review → post flow. Amounts use the shared peso field and integer-centavo transport. Returned drafts retain the proposed amount and supporting references.
- Packages use a preparation dialog, a readable report summary, explicit independent review and the existing protected export. Vendor choices use the existing paginated Admin Vendor directory; an individual certificate requires a selected Vendor. Directory authorization remains enforced separately. No raw Vendor ID is entered.
- Package source details remain expandable. Source exceptions explain the necessary work before another package is prepared.
- Evidence links to the existing Vendor verification record; documents remain protected there.
- `/reports/tax` opens the grouped package list. Existing `/reports/tax/:packageId` URLs remain supported. New record links use `/finance/tax/packages/:packageId`. Old `/finance?view=adjustments` links open Tax records.
- Notifications retain their inbox, alerts and record links. No tax administration navigation is reintroduced there.

## Rules and authorization

Existing `finance.view`, `finance.review_tax`, export and external-evidence permissions remain server-enforced. Adjustment actions follow the server-provided state actions; the preparer cannot approve their own adjustment or package. Posting remains explicit and appends a linked demo ledger entry. No formula, rate, threshold, refund rule, tax responsibility, provider configuration or filing behavior changes.

Newly prepared adjustments now include their original `gross_basis_centavos` and explicitly corrected `withheld_centavos` in `after_values`, as expected by report snapshots. The existing proposal/difference fields remain available. Missing original bases remain null and block report review. Earlier posted adjustments and existing report snapshots are not rewritten.

No migration, new role, endpoint, configuration key or live-provider setup is required. The OpenAPI snapshot description and generated TypeScript/Dart clients are refreshed.

## Automated checks

```powershell
Set-Location apps/admin-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run
npm.cmd run build
```

Focused component coverage: grouped navigation and old adjustment links; exact-centavo correction submission; independent review and explicit posting; reasoned returns and server conflicts; Vendor selection by name; retry-safe package preparation; readable report blockers; versioned package review; unauthorized reads and retry.

The extended `PhaseSixteenAdminOperationsTest::test_tax_adjustments_need_two_named_finance_users_and_post_a_linked_entry_and_vendor_review_status_is_owner_only` also checks that the posted corrected amount appears in a newly prepared package without an adjustment-review blocker. Existing immutable assessments, accumulator values and unauthorized/Owner-only checks remain asserted.

Run database-backed checks only in the verified isolated Compose test environment. Include `PhaseFifteenExportsTest` for package review, immutable source versions and protected exports. Run focused Pint, PHPStan, OpenAPI validation, Admin Finance/operations/notifications contract checks, generated TypeScript build, diff whitespace and secret scanning.

## Executed validation

- Admin lint, typecheck and production build passed. The full Admin suite passed **28 files / 177 tests** with `npm.cmd run test -- --run --maxWorkers=2`.
- The first default parallel run passed 176 tests and hit an unchanged Vendor verification test assertion expecting two business-name elements before the second had loaded. Its three tests passed against source archived from unchanged HEAD; the complete current suite then passed with two workers. No Vendor verification assertion or production code was changed.
- The isolated Compose guard and negative isolation checks passed. The focused restored adjustment/report flow passed **1 test / 49 assertions**; the related `PhaseSixteenAdminOperationsTest.php` and `PhaseFifteenExportsTest.php` suites passed **25 tests / 585 assertions**.
- Both changed PHP files passed syntax checks and Pint. Full PHPStan passed with no errors.
- OpenAPI validation passed with eight unused-model recommendations. Admin Finance, Admin operations and notification/export contract checks passed. TypeScript/Dart sources were regenerated through the repository generator; the generated TypeScript build passed. Generated changes are snapshot-field documentation only.
- Diff whitespace and redacted secret scanning of the working diff and new files passed.
- The web build still reports a bundle over 500 kB. Browser/device, live-provider and government-filing acceptance were not run.

## Manual acceptance

1. Open Admin Finance → Reconciliation → Tax records on desktop and a narrow screen. Confirm all four Finance tabs remain visible and tables scroll within their own area.
2. Open an adjustment, enter a correction, and send it for review. Sign in with a different authorized finance user, review it, then explicitly post it.
3. Prepare a package using a named Vendor for form 2307. Verify an invalid period, missing evidence, unresolved adjustment or stale source receives an actionable error without reporting success.
4. Review and export a package with a different authorized finance user. Refresh the package after export to see its updated state. Confirm sample/demo labels and private-download behavior.
5. Verify Notifications has no tax-management header links and old package links return to Finance.

Browser/device and live-provider acceptance must be reported separately from automated component/API checks. Older posted adjustments lacking report-ready snapshot fields remain subject to existing report blockers; this change does not amend historical tax data.

Suggested commit: `feat(admin): restore compact finance tax records`
