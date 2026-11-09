# Commission policy, Vendor notices and Admin control panel

The current commercial rate and terms now resolve through `CommissionPolicyService`. No scheduler flip or rate cache is required. Historical quotations, orders, assessments, statement lines, credits and invoice PDFs keep their saved values. Buyer checkout uses rate-free copy because Vendor commission is not a Buyer charge.

## Discovery and scope

| Surface | Source after this change |
| --- | --- |
| Admin rate, schedule and history | Authenticated policy projection; effective timestamp and append-only revisions |
| Vendor Finance and onboarding | Same policy resolver and linked agreement; future-policy notice |
| Vendor landing, fees and public Commission Terms | `/api/v1/commission-policy`, no-store public projection; shared browser helper |
| Buyer checkout | No commission percentage displayed |
| Monthly statement, PDF/CSV and email | Original saved rates and amounts; credits remain separate |
| Initial seed and historical markdown | Initial 2% policy and historical examples retained |

Existing transactional outbox, Owner-only finance notices, `notification_deliveries`, immutable `notification_delivery_attempts`, private PDF generation and shared responsive mail layouts are extended. A business-event key prevents duplicate initial emails across API retries and monthly recovery. Transport retries retain monotonically numbered attempts; explicit resends are audited and throttled.

## Migration and authorization

- Additive migration: `2026_11_09_120000_add_commission_policy_notices.php`. Adds policy notice metadata, revision and email-event tables, and resend attempt-cycle tracking. Backfills generated terms for existing policies without terms. Empty installations receive the same backfill from the foundation seeder.
- Published policy/terms and revision history stay immutable. The backfill recognizes existing initial agreement consent without inserting a new acceptance. Later publications require the new agreement as before.
- View: `finance.view`. Publish/edit/cancel: also `platform_settings.manage`, recent authentication, CSRF, idempotency and expected latest version. Preview requires both view/manage permissions and performs no mutation.
- Statement resend: `finance.approve_statements` plus view. Policy resend: settings manage plus view. One-minute limit per email, with retained audit and attempt history.
- Public projection excludes internal reason, override reason, staff identity, recipient contacts and delivery information. The Vendor-facing message is intentionally public and is HTML-escaped.
- SMTP acceptance is recorded as sent; it is not proof of mailbox receipt. Transport-level exactly-once delivery cannot be proven across a worker crash after SMTP acceptance and before its status commit.

## Local setup and email inspection

Do not use a real mail provider for this exercise. In the ignored local API environment configure `MAIL_MAILER=smtp`, `MAIL_HOST=mailpit`, `MAIL_PORT=1025`, and keep `FINANCE_MODE=TEST`. Existing sender identity keys remain required. Restart the local API/worker/scheduler after changing configuration. Inspect messages at <http://localhost:8025>.

Additional safe configuration keys:

```dotenv
COMMISSION_MIN_NOTICE_DAYS=30
COMMISSION_REMINDER_ENABLED=false
COMMISSION_REMINDER_DAYS=3
```

Admin `VITE_VENDOR_URL` must point to the Vendor web origin for terms links. API `FRONTEND_VENDOR_URL` supplies email finance/terms/support links. No new mail credential is required for Mailpit.

With Mailpit configured, apply migrations and use the existing local worker/scheduler:

```powershell
docker compose exec api php artisan migrate
docker compose up -d mailpit horizon scheduler
docker compose exec api php artisan materyalph:finance-process-commissions
```

1. Open `/finance?view=statements`. Change the reporting period and confirm KPIs, bills, payments and exports share it. Inspect filter totals and a statement drawer.
2. Publish an immediate decrease. Preview recipients, worked example, historical-volume illustration, email and old/new terms; confirm with recent authentication. Inspect Mailpit and public `/commission-terms`.
3. Schedule an increase at least 30 days ahead. A shorter notice must be rejected unless the explicit override and its reason are supplied. Edit/cancel the schedule; inspect retained versions and correction/cancellation emails.
4. Run monthly recovery repeatedly against billable prior-month fixtures. Confirm one initial statement email per bill and no bill for idle Vendors. A fully credited bill says no payment is needed. Mixed-rate bills retain the per-rate split.
5. With SMTP directed only to Mailpit, stop Mailpit to exercise failed delivery, then restore it and use Resend failed. Inspect retained attempts and audit events. Statement resend is available in Activity and emails only with its permission.

The volume estimate averages original eligible materials basis at completion over the last three complete Manila months. It is an illustration before later credits and future changes in activity, not a recalculated bill or earnings forecast. No new statement void/reissue command is introduced; the corrected email variant uses an issued statement's existing version.

## Validation evidence

Logs are in `.tmp/commission-*.log`; responsive screenshots are in `.tmp/admin-finance-review/`. Tests use the isolated `materyalph_test` database and array/fake mail; development data is not reset.

- Final focused API: 26 tests, 792 assertions passed, including notice rules, effective-time resolution, immutable history, publication/recovery idempotency, mixed saved rates, zero due, escaped public message, failed-send retries, resend permissions/throttle, canonical Vendor finance links and initial consent compatibility.
- Final focused Admin: 42 tests passed. Final focused Vendor: 107 tests passed, including scheduled consent-reader refresh that preserves unsaved parent fields and requires acceptance of the new version.
- Initial full Admin: 407 passed, 4 failed; one Vite timeout passed separately, while three profile-media assertions still expect Open Enforcement links although the current interface uses buttons. These files were not changed for commission work.
- Initial full Vendor: 931 passed, 1 Vite timeout; that test passed separately with a 30-second runner timeout. No repository timeout setting was changed.
- OpenAPI validation passed with 8 existing unused-model recommendations. TypeScript clients were regenerated and built; Dart serializers were regenerated with build_runner (26 outputs).
- Responsive Admin commission journey passed at all 8 configured widths after correcting filter-menu stacking. Vendor landing also passed at all 8 widths with a non-default 3.25% policy fixture. Screenshots use synthetic API responses, not production financial data.
- Initial full API: 885 passed, 11 failed, 1 warning (18,655 assertions). The rerun after fixing duplicate initial TEST/DEMO terms and deterministic blocker ordering passed onboarding and finance; all three affected suites together finished with 149 passed, 1 failed (2,823 assertions). The remaining discovery badge test has no address on its Vendor fixture, so the location search returns no Vendor; the discovery rule and this test were not changed. The complete API suite was not repeated after the compatibility fixes.
- Initial full Buyer: 632 passed, 54 failed, 1 skipped. This includes capture/golden failures, an authentication presentation assertion and the obsolete checkout commission-copy assertion. The checkout file passed all 28 tests after updating that assertion. The complete Buyer suite was not repeated; unrelated goldens and authentication behavior were not changed.
- Policy-clock/public App rerun: 25 tests passed, including a response arriving just after its scheduled effective instant. The consent reader's final cleanup refinement passed its separate interaction test as well.
- Both portals' lint, typecheck and builds passed. Builds retain the existing chunk-size advisory. Buyer `flutter analyze` passed with no issues. Full PHPStan passed with no errors; full Pint passed, and the final mail changes passed scoped Pint.
- OpenAPI, generated TypeScript build, JavaScript notice transport contract and Dart policy serialization contract passed. Compose config, Git diff whitespace check, staged Gitleaks and a separate authored-source Gitleaks scan passed. The staged scan contained no staged files; the source scan covered the implementation and documentation explicitly.

Production scheduler execution, actual mailbox receipt, provider throughput, live payment processing and production cutover are not verified by local tests or synthetic browser screenshots.

## Files and API changes

| Area | Main files changed |
| --- | --- |
| Policy, terms, delivery and statements | `services/api/app/Domain/Finance/{CommissionPolicyService,CommissionTermsTemplate,CommissionEmails,StatementService,PlatformFeeInvoiceService,AdminFinanceService,FinanceOperationsService,VendorFinanceService}.php` |
| Authorization, current consent and outbox | `services/api/app/Domain/Notifications/{NotificationPolicy,NotificationDelivery}.php`, `Domain/Operations/OutboxProcessor.php`, `Domain/Agreements/AccountAgreements.php`, `Domain/Vendors/{StoreActivationGate,VendorOnboardingService}.php`, `Domain/Demo/DemoVendorMarketplace.php` |
| HTTP and configuration | `services/api/app/Http/Controllers/Api/AdminFinanceController.php`, `Http/Requests/Finance/PublishCommissionPolicyRequest.php`, `routes/{payments,console}.php`, `config/finance.php`, `services/api/.env.example` |
| Migration, seed, terms and mail | New migration named above; `database/seeders/SystemFoundationSeeder.php`; `resources/agreements/commission-template-v2.md`; `app/Mail/{CommissionPolicyMail,PlatformFeeInvoiceMail}.php`; HTML/plain templates `resources/views/mail/{commission-policy,commission-policy-text,platform-fee-invoice,platform-fee-invoice-text}.blade.php` |
| Admin workspace | `apps/admin-web/src/pages/{FinancePages,CommissionFinancePanels,CommissionManagementWorkspace,CommissionPolicyPanel,CommissionStatementDrawer,AdminPlatformEarnings}.tsx`, `CommissionManagementWorkspace.css`, `src/lib/finance-api.ts`, `src/components/OperationsKit.tsx`, `apps/admin-web/.env.example` |
| Shared presentation | `packages/web-ui/src/{commission-policy,filter-controls,stock-ledger,async-state,published-agreement-reader}.tsx`, `src/index.ts` |
| Vendor and Buyer | `apps/vendor-web/src/{App.tsx,pages/CommissionTermsPage.tsx,pages/VendorLandingPage.tsx,pages/FinancePages.tsx,components/CommissionTerms.tsx}`; `apps/buyer-mobile/lib/features/item_procurement/checkout_preview_screen.dart` |
| Contract and generated clients | `packages/api-contract/openapi.yaml`, `package.json`, `scripts/check-commission-notices-contract.mjs`, `scripts/check-commission-policy.dart`, regenerated TypeScript/Dart policy models, public/admin finance APIs and Dart serializers |
| Tests | `services/api/tests/Feature/Api/{PhaseElevenFinanceFlowsTest,PhaseThreeVendorOnboardingTest}.php`, `tests/Support/CreatesDiscoveryFixtures.php`; Admin `FinancePages.test.tsx`, new `CommissionManagementWorkspace.test.tsx`; Vendor `App.test.tsx`, new `CommissionPolicyClock.test.tsx` and `CommissionTermsRefresh.test.tsx`; `e2e/{admin-finance-layout,vendor-landing}.spec.ts`; Buyer `test/item_procurement_test.dart` |
| Owner decisions and handover | System, Vendor and Admin workflows, UI/UX implementation planner and this test plan |

Additive endpoints: public `GET /api/v1/commission-policy`; Admin policy preview, failed-notice resend, individual email resend and statement detail. Existing policy publish accepts optional Vendor message, notice override/reason and scheduled replacement/cancellation fields. Bills/payments accept search and multiple statuses. Existing required publish fields and existing single-status filters remain supported. Every unbounded response list remains paginated.

Recipient assumption: the current data model has no separate verified billing contact, so one active, verified Owner account receives each Vendor's notice. An otherwise eligible Vendor without that destination is counted as blocked and is visible to Admin; no staff or public store email is substituted. `finance.approve_statements` gates statement resends; publication and policy resends use `platform_settings.manage` in addition to `finance.view`.

The new migration ran in the isolated test database. It has not been applied to the existing development database. Rollback is available before notice history exists; once used, its guard retains financial/legal notice history. No deployment or live email was performed.

Focused checks from the repository root (the test stack uses its isolated database):

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Feature/Api/PhaseThreeVendorOnboardingTest.php
npm.cmd --prefix apps/admin-web run test -- --run src/pages/CommissionManagementWorkspace.test.tsx src/pages/FinancePages.test.tsx
npm.cmd --prefix apps/vendor-web run test -- --run src/components/CommissionPolicyClock.test.tsx src/components/CommissionTerms.test.tsx src/components/CommissionTermsRefresh.test.tsx src/pages/FinancePages.test.tsx src/App.test.tsx
npm.cmd --prefix packages/api-contract run test:commission-notices-contract
```

From `apps/vendor-web`, run `npx.cmd playwright test e2e/admin-finance-layout.spec.ts e2e/vendor-landing.spec.ts --reporter=line` after building both portals. From `apps/buyer-mobile`, run `flutter test test/item_procurement_test.dart`. The full required project checks are in `AGENTS.md`; broader-suite limitations above remain open.

Suggested commit: `feat(finance): version commission terms and deliver Vendor billing notices`
