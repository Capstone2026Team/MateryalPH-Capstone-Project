# Free staging deployment readiness — 2026-10-19

Source branch: `staging`. Initial deployment commit: `eeb90cfbbd20e845010f1d02d93c1199b78a0712`.

## Completed

- Free-only `render.yaml`: API, separate Reverb web service, Vendor/Admin static sites, Postgres 16 and Key Value in Singapore.
- CI/CD workflow with path selection, dependency and secret audits, infrastructure checks, aggregate gate and ordered exact-commit deployment.
- Non-root Nginx/PHP-FPM API image, supervised queue/scheduler for the limited Free preview, guarded startup migrations and reference seeding.
- Private S3 adapter, patched dependency lockfiles and safe secret setup instructions.
- Separate staging Passport key pair generated under the ignored `.tmp/staging-deployment/` directory. No key values were printed or committed.
- [Deployment runbook](render-staging.md) including generated URLs, cookies, provider keys, limits and rollback.

## Checks actually performed

| Check | Result |
| --- | --- |
| Render published JSON schema plus staging/budget assertions | Passed |
| GitHub Actions actionlint | Passed |
| JavaScript deployment/path-selector syntax | Passed |
| Deployment PHP syntax and Pint formatting | Passed |
| Composer manifest validation | Passed |
| Composer dependency audit after the Symfony patch | No advisories reported; the final repeat used cached metadata after a registry timeout |
| npm audits for contract tooling, generated TS client, shared UI, Vendor and Admin | Zero vulnerabilities after updates |
| Generated TypeScript client build | Passed |
| Vendor and Admin Vite builds | Passed; existing large-chunk warnings |
| Final API Docker image build | Passed |
| Image user, PHP-FPM and Nginx configuration | User `app`; both configurations passed |
| Isolated Docker Compose configuration | Passed locally with the existing ignored test settings; CI now creates temporary test settings explicitly |
| Deployment changes secret scan | No leaks |
| Full repository history secret scan | Failed: Google Maps key in the tracked iOS example and history; current example replaced with a placeholder |

No local backend, browser, device or provider acceptance tests were added or run for this deployment change.

## Remote CI result

[Initial staging CI run](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/39242155010) failed and the deployment job was skipped.

- Dependency audit and path selection passed.
- Vendor portal: **594 tests passed, 6 failed** in `OrderPages.test.tsx`.
- Admin portal: **134 tests passed, 1 failed** in `ProductCompliancePages.test.tsx`.
- iOS job: **445 passed, 80 failed, 1 skipped**; includes golden and interaction failures.
- Flutter Linux job stopped at Dart formatting (six files).
- Generated-client drift check failed for `GeoDemandCellValue.ts`.
- Backend and browser jobs ended canceled; they are not passing evidence.
- Infrastructure stopped because Compose lacked TEST_DB_PASSWORD. The follow-up workflow creates an ephemeral ignored env file and removes it after validation.
- History scan found one Google Maps key. The current example is cleaned; history remains gated pending classification/remediation. No history rewrite, credential rotation or broad allowlist was performed.

The initial deployment commit did not change application pages or existing application tests. Additional Vendor onboarding edits appeared in the shared workspace later and are outside the deployment commit.

## Outstanding inputs and gates

1. Resolve the failing application/contract checks, then obtain a successful CI run. No deployment gate has been disabled to pass.
2. Review the Google Maps key previously committed in `apps/buyer-mobile/ios/Flutter/MapsKeys.xcconfig.example`. Its value was never displayed. Confirm whether it is an intentionally public iOS-restricted key or revoke/replace it in Google Cloud. Historical findings require explicit review; no automatic history rewrite or rotation is authorized.
3. The active Git credential has push access but no repository admin/maintain permission. Staging/production environments and main branch protection were not present in the inspected settings. A repository administrator must configure the protections and deployment secrets documented in the runbook.
4. Render MCP access works for the confirmed workspace, which had no services/datastores. The installed Render CLI v2.30.0 is not authenticated; authenticated Blueprint validation returned `run render login to authenticate`.
5. Initial Blueprint application requires Render Dashboard access. Neither the connector nor CLI exposes Blueprint application. The browser automation surface failed to initialize, so no Dashboard action was performed.
6. Enter separate staging provider credentials through Render/GitHub secret fields and verify the actual assigned URLs. Never reuse development/production credentials.

**No Render resources were created, no paid plan was selected remotely, and no live deployment or HTTP smoke check was completed.**

Free-only limitations remain: service sleep and shared 750-hour allowance, queue/scheduler pauses, volatile Key Value, Postgres expiry after 30 days, SMTP port restrictions, and scan-dependent uploads blocked by the current fail-closed ClamAV implementation. This does not satisfy the full production-readiness scope of Phase 19.
