# Withholding register collection-month default

## Cause and scope

On 8 November 2026, the local database contained four non-voided posted TEST assessments totalling 508 centavos, all collected in October 2026. The Admin register defaulted to November; the Vendor breakdown included October. No assessment was missing and no tax amount needed recalculation.

`GET /api/v1/admin/finance/withholding-register` now accepts an omitted `month`. After existing `finance.view` authorization, it resolves the latest collection month with a non-voided TEST assessment, or the current Manila month when no such records exist. Explicit months retain their previous scope and empty results. Response fields and tax calculations are unchanged. Both generated clients are regenerated.

The month control shows the resolved month. Filing preparation and reconciliation links use that month. An explicitly selected empty month offers View latest recorded month. No migration, new permission, environment key, financial mutation, provider call or money transfer is introduced.

## Regression coverage

- API: no-record current-month fallback; previous-month default; Manila/UTC month boundary; newer VOIDED assessment exclusion; explicit empty months; empty-parameter validation; read-only source preservation; denied Admin role. Existing coverage retains platform/provider separation, exact integer totals and pagination.
- UI: omitted-month request; server-resolved month and 508-centavo display; filing-period context; explicit empty-month retention; deliberate return to latest recorded month. Existing tests cover loading, denied access, refresh and month changes.
- Contract: optional query parameter, omission over transport, resolved response month, exact centavos and unchanged responsibility separation; generated TypeScript build and Dart register serialization.

## Local data verification

A read-only transaction against the running local API database returned:

| Requested month | Resolved month | Platform withholding | Assessments |
| --- | --- | --- | --- |
| Omitted | 2026-10 | 508 centavos | 4 |
| 2026-10 | 2026-10 | 508 centavos | 4 |
| 2026-11 | 2026-11 | 0 centavos | 0 |

The assessment-record digest was identical before and after these reads. These are TEST assessments, not evidence of cash custody, BIR filing or payment.

Authenticated visual browser verification is unavailable in this session: Computer Use reported that its native pipe and browser access host were unavailable. No deployment or live-provider/BIR acceptance is performed.

## Executed validation

- `php artisan test --filter=withholding_register` in the isolated test container: **2 tests passed, 97 assertions**. The first run exposed a fixture date before the payment fee schedule existed; the fixture now tests a later Manila/UTC boundary.
- Focused `vendor/bin/pint --test` on the three PHP files: **3 files passed**. Full `vendor/bin/phpstan analyse --memory-limit=512M --no-progress`: **no errors**.
- Admin `npm.cmd run lint`, `npm.cmd run typecheck` and `npm.cmd run build`: **passed**. The build retains its existing large-chunk advisory.
- Focused Admin register, filing and Vite tests: **3 files, 12 tests passed**. Full Admin `npm.cmd run test -- --run --maxWorkers=2 --testTimeout=30000`: **51 files, 378 tests passed**. The sandboxed full run stalled after the Vite test timed out; focused and full runs outside the sandbox passed.
- OpenAPI validation: **passed**, with eight unused-model recommendations. TypeScript/Dart generation, generated TypeScript build, `test:admin-finance-contract` and the Dart register serialization check: **passed**. Dart required access to the installed Pub cache outside the sandbox.
- The running Admin development server serves the updated register action, omitted-month request and regenerated client without a required-month runtime guard. This is source delivery verification, not authenticated visual acceptance.
- `docker compose config --quiet`, full `git diff --check`, and redacted source/staged secret scans: **passed**. No staged content was present.

No new setup or environment key is needed. Full backend, Vendor and Buyer suites were not run for this Admin register change.

Suggested commit: `fix(admin): open withholding register at latest recorded month`.
