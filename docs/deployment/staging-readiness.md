# Free staging deployment readiness — 2026-10-19

Source branch: `staging`. Current live release commit: `3ef276d230d1c5ed37fb5933ea6015848fe49ad6`.

## One-time preview approval

On 2026-10-19 the owner explicitly approved one Free staging preview with the documented application/contract CI failures. This exception applies to the initial manual preview. The automatic GitHub deployment gate remains unchanged and still requires passing CI. All four live services now use commit `3ef276d230d1c5ed37fb5933ea6015848fe49ad6`; unrelated uncommitted Vendor onboarding and design edits were not deployed.

The preview was provisioned through Render's authenticated public API fallback using the validated YAML configuration because Dashboard automation was unavailable. A Render Blueprint object is not linked to the existing resources; adopt them in the Dashboard before any future Blueprint sync. Do not apply the YAML as a new empty Blueprint in the current environment.

## Completed

- Free-only `render.yaml`: API, separate Reverb web service, Vendor/Admin static sites, Postgres 16 and Key Value in Singapore.
- CI/CD workflow with path selection, dependency and secret audits, infrastructure checks, aggregate gate and ordered exact-commit deployment.
- Non-root Nginx/PHP-FPM API image, supervised queue/scheduler for the limited Free preview, guarded startup migrations and reference seeding.
- Private S3 adapter, patched dependency lockfiles and safe secret setup instructions.
- Separate staging Passport key pair generated under the ignored `.tmp/staging-deployment/` directory. No key values were printed or committed.
- [Deployment runbook](render-staging.md) including generated URLs, cookies, provider keys, limits and rollback.

## Live Render resources

All four services are live in the confirmed capstone workspace and all have automatic deployment turned off.

| Service | Plan | URL | Latest live deployment |
| --- | --- | --- | --- |
| API | Free | [materyalph-staging-api.onrender.com](https://materyalph-staging-api.onrender.com) | `dep-dbb3hufavr4c738ju250` |
| Reverb | Free | [materyalph-staging-reverb.onrender.com](https://materyalph-staging-reverb.onrender.com) | `dep-dbb3jsbrjlhs73b9i3rg` |
| Vendor | Static | [materyalph-staging-vendor.onrender.com](https://materyalph-staging-vendor.onrender.com) | `dep-dbb3keifngtc739jvu4g` |
| Admin | Static | [materyalph-staging-admin.onrender.com](https://materyalph-staging-admin.onrender.com) | `dep-dbb3l8jl550s73870veg` |

Free Postgres 16 (`dpg-dbb2t561egvs73clqop0-a`) is available in Singapore and expires **2026-11-18 14:52 UTC** (22:52 Asia/Manila). Free Key Value (`red-dbb2t68n74is73c2juvg`) is volatile on restart.

## Checks actually performed

| Check | Result |
| --- | --- |
| Render published JSON schema plus staging/budget assertions | Passed |
| Render authenticated Blueprint validation | Passed; `valid=true`, eight Free resources planned. No Blueprint was applied. |
| Authenticated Render CLI Blueprint validation | Passed; Render returned valid=true with the expected free resource plan after removing unsupported custom shutdown delays |
| GitHub Actions actionlint | Passed |
| JavaScript deployment/path-selector syntax | Passed |
| Deployment PHP syntax and Pint formatting | Passed |
| Composer manifest validation | Passed |
| Composer dependency audit after the Symfony patch | No advisories reported; the final repeat used cached metadata after a registry timeout |
| npm audits for contract tooling, generated TS client, shared UI, Vendor and Admin | Zero vulnerabilities after updates |
| Generated TypeScript client build | Passed |
| Vendor and Admin Vite builds | Passed; existing large-chunk warnings |
| Final API Docker image build | Passed |
| Render API and Reverb builds at the live commit | Passed; both services report live |
| Render Vendor and Admin builds at the live commit | Passed; both static sites report live |
| Image user, PHP-FPM and Nginx configuration | User `app`; both configurations passed |
| Isolated Docker Compose configuration | Passed locally with the existing ignored test settings; CI now creates temporary test settings explicitly |
| Deployment changes secret scan | No leaks |
| Full repository history secret scan | Passed: 37 commits, approximately 70 MB scanned. Owner confirmed the historical public Maps key's iOS-app restrictions; only its exact fingerprint is excluded, and the current example uses a placeholder. |

No application test suites or authenticated user, browser, device or provider acceptance tests were run for this deployment change. Safe local container startup checks used placeholder settings only.

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
- History scan found one Google Maps key. The owner subsequently confirmed it is a public client key restricted to the iOS app. The example is cleaned and only that historical fingerprint is excluded. No history rewrite, credential rotation or broad rule/file allowlist was performed.

The latest full workflow for the live commit, [run 39279275142](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/39279275142), was queued during final verification. It has not passed. `RENDER_STAGING_CONFIGURED` remains unset, and no automatic deployment ran.

The initial deployment commit did not change application pages or existing application tests. Additional Vendor onboarding edits appeared in the shared workspace later and are outside the deployment commit.

## Live smoke checks and remaining gates

Passed against the public deployment:

- API `/up` and `/api/v1/health` returned HTTP 200; the health envelope reported `ok`.
- The existing staging HTTP smoke helper passed unauthenticated-session denial, both SPA login routes, same-origin portal proxies, secure host-only CSRF cookies, rejection of POST without CSRF (419), and exact-origin credentialed CORS.
- Vendor-to-Reverb WSS completed the Pusher connection handshake.
- `/api/v1/agreements/current` returned HTTP 200 with the two seeded public agreements.
- No Carbon queue retry errors appeared after the final API deploy; `REDIS_QUEUE_RETRY_AFTER` is now cast to an integer.

Remaining gates:

1. Resolve the failing application/contract checks and obtain a successful CI run. The automatic CI deployment gate remains enabled; this manual preview approval did not bypass or weaken it.
2. A repository administrator must configure the protected GitHub staging environment, staging deployment secret/variables and required branch protections described in the runbook. Those controls were not present in the inspected settings.
3. Separate staging provider credentials remain unset. Mail, private S3 uploads, Cloudinary, reCAPTCHA, OAuth, maps, Xendit TEST and Firebase journeys are not accepted. No initial Admin invitation was requested or created.
4. Retain the confirmed iOS application restrictions on the historical public Maps key. Its value was never displayed; the current example remains a placeholder.
5. Uploads stay fail-closed because current ClamAV definitions do not fit the Free plan. Do not bypass the scanner.
6. Free Postgres expires after 30 days with no managed backups; Key Value loses state on restart. This remains a disposable preview and does not complete Phase 19 or production readiness.

Free web services sleep after inactivity, the two API/Reverb instances share the 750-hour monthly allowance, queue and scheduler work pauses while the API sleeps, and Render Free SMTP ports remain restricted. See the runbook for the complete limits and manual acceptance list.
