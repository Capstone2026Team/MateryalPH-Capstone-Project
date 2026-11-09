# Quality gates repair - run 129

Reviewed [GitHub Actions run 129](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/42646571333), commit `85f649cd5ce9807befd5f01fe5bfc2d57aa535c7`, through the authenticated GitHub API.

## Causes and repairs

| Failed step | Cause | Repair |
| --- | --- | --- |
| Check API contracts against Laravel routes | The orders checker treated `rescanProjectOrderSuppliers` as a mutation requiring `Idempotency-Key`. The implemented and documented operation only authorizes the cancelled order and returns its unchanged Work Package; replacement selection is a separate retry-protected mutation. | Identify the two read-only order POST paths explicitly: delivery recommendations and supplier-rescan context. Keep authentication, account guards, transport, documented errors and mutation idempotency checks. |
| Exercise the isolated Render HTTP runtime | The fixture launched a simultaneous burst against an ondemand FPM pool and required every worker to start within three seconds. Its six-second sleeps also imposed an unnecessary timing window. The hosted run failed at worker startup; the unchanged local fixture passed, confirming the failure was not consistently reproducible. | Start each request after the previous worker signals readiness, with a bounded ten-second startup deadline. Hold all requests behind an explicit release signal until both health probes complete. A twenty-second fixture deadline fails closed if release never arrives. |

The required aggregate check failed because these two jobs failed. Backend tests themselves completed in the reviewed hosted run: **1,252 passed, one warning, one skipped, 28,686 assertions**. Portal, browser, Flutter, contract-generation, dependency-audit and secret-scan jobs succeeded in that run. These hosted results belong to the original commit, not the repair.

## Files and boundaries

- `packages/api-contract/scripts/check-orders-contract.mjs`: exact read-only POST exceptions instead of the delivery-recommendation suffix exception.
- `scripts/deployment/test-render-runtime.py`: deterministic worker readiness and release synchronization in the isolated synthetic runtime fixture.
- This report.

No production application, migration, OpenAPI request/response, generated-client, authorization, credential, deployment setting or FPM pool configuration changes. No new environment keys or manual setup are required. Real checkout/order mutations still require idempotency keys. No workflow gates are removed or skipped.

## Local validation

| Check | Result |
| --- | --- |
| Isolated database guard and read-only route export | Passed; dedicated PostgreSQL 16 test database only. |
| Order contract before repair | Failed with `rescanProjectOrderSuppliers requires Idempotency-Key`, matching GitHub. |
| All Node route contract scripts selected by the backend workflow | **33/33 passed**, using a fresh Laravel route export. |
| Contract negative checks | **4/4 passed**: rejected checkout and Vendor confirmation without idempotency keys, and rejected rescan routes missing Buyer access or Passport authentication. |
| Render runtime: `python scripts/deployment/test-render-runtime.py --image materyalph-api:b9c4b89c8aadf8de26c988726d2812088b448948` | Passed, followed by **three consecutive repeat passes**. Two ordinary workers were held busy; the final health response took 1.9 ms, below the unchanged one-second limit. |
| VPS runtime: same command with `--vps` | Passed with all eight ordinary workers held busy; health response 1.9 ms. |
| Runtime negative checks | **2/2 passed**: rejected a one-worker pool when two were required, and rejected health requests routed through the busy ordinary pool. |
| Runtime safety assertions, both modes | Passed: full 25 MiB upload, multipart above 32 MiB, PHP file-size rejection, Nginx request-size rejection, GET/HEAD health, stopped-FPM detection, maintenance fence/reopen, original route logging and query-string redaction. Containers had no network access. |
| `npm.cmd run validate` in `packages/api-contract` | Passed; eight existing unused-model recommendations. |
| `node --check packages/api-contract/scripts/check-orders-contract.mjs` and `python -m py_compile scripts/deployment/test-render-runtime.py` | Passed. |
| Application and isolated-test `docker compose ... config --quiet` | Passed. |
| Gitleaks changed-source and staged scans; `git diff --check` | Passed; no leaks or whitespace errors. Staged scan was empty because no files were staged. |

The runtime checks reused the existing local API image identified above, mounting the current Nginx, Render/VPS FPM and upload configurations plus synthetic PHP fixtures. A fresh image build, vulnerability scans and the full repository suite were not rerun for these checker/fixture-only changes. The hosted job's later infrastructure steps still require a new GitHub run. Raw job logs, negative fixtures and validation output remain ignored in `.tmp/ci-run129/`.

No commit, push, rerun or deployment was performed. A new hosted run on the repaired commit remains required.

Suggested commit: `fix(ci): recognize rescan previews and synchronize runtime probes`
