# Quality gates repair - runs 132 and 133

Reviewed [run 132](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/42943933279) at `f240e2ceb276c2b5e58df945081a5f16142e67f6` and [run 133](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/42968741226) at the current checkout, `5a6b9b4e27852cb14124f042019d2a940c637aac`, through the authenticated GitHub API.

## Remaining causes and repairs

| Check | Cause | Repair |
| --- | --- | --- |
| Run current Dart contract checks | The commission-policy fixture omitted the required annual/monthly payment periods and payment-history pagination. The generated client correctly rejected it. | Complete the fixture using the existing response schema. Verify Manila calendar reset instants, integer amounts and empty-history pagination, including the generated constant enum. |
| VPS configuration validator | Its exact service allowlist predated the approved resident ClamAV daemon and signature updater. | Include both services while retaining the exact allowlist. Check internal scanning networking, daemon isolation, signature-volume permissions, absence of app credentials and the API's healthy-scanner startup dependency. Include the scanner services in restart/logging checks. |
| Additional local Dart check | The threshold-payment fixture omitted three required original-assessment amounts. This script is not selected by the current CI Dart suffix filter. | Restore the assessed payment, delivery and material VAT fixture values and verify they survive decoding. Retain the existing tax rounding and privacy assertions. |

The account-contract and browser failures in run 132 were already repaired in the current commit. Verified the account checker against a fresh route export from the guarded isolated API environment. Run 133 completed with the backend and all four browser shards successful; only the two checks above and their aggregate gate failed. No browser or account-route changes were needed for this repair.

Run 133's hosted backend result was **1,271 passed, one warning, one skipped, 29,025 assertions**. Its portal, Buyer, iOS-build, dependency-audit and secret-scan jobs also succeeded. Those hosted results describe the original commit, not these uncommitted repairs.

## Files and boundaries

- `packages/api-contract/scripts/check-commission-policy.dart`
- `packages/api-contract/scripts/check-threshold-payments.dart`
- `tools/deployment/validate_vps.py`
- This report.

This repair changes no production application, migration, OpenAPI request/response, authorization, financial formula, credential, deployment configuration or workflow selection. No environment keys or manual setup are required. No gates are disabled. The scanner remains private and fail-closed.

The checkout was clean when inspection began. Separate Buyer/order implementation, workflow, test and OpenAPI edits appeared during verification and were preserved. The results below apply to the original checkout and this repair; they do not validate that separate in-progress work. Only the four files listed above belong to this repair.

## Local validation

| Check | Result |
| --- | --- |
| Original commission fixture and VPS validator | Both failures reproduced before repair, matching the hosted failures. |
| Isolated API guard and fresh route export | Passed; dedicated test environment only. |
| Generated TypeScript client: `npm.cmd run build` | Passed. |
| Node contract checks selected by the backend workflow | **35/35 passed**, using the fresh route export. |
| All Dart contract scripts, including the additional `-dart` scripts | **15 checked across runs**: 13 passed in the broad run; both failed fixtures were corrected and passed focused reruns. The commission rerun uses the generated pagination enum. |
| `python tools/deployment/validate_vps.py` | Passed using the existing deployment virtual environment and its PyYAML dependency. |
| Scanner-validator negative checks | **7/7 passed**: rejected a published port, public scanning network, daemon egress, writable daemon signatures, app credentials, missing healthy-scanner dependency and an unknown service. |
| `python scripts/deployment/test-vps-compose.py` | Passed with disposable synthetic environment inputs; no services started. |
| `python scripts/deployment/test-vps-database.py` | Passed: disposable network-isolated PostgreSQL initialization/restore, least privilege, extensions and source-history preservation. |
| `node --test scripts/deployment/vps-deployment.test.mjs` | **7/7 passed**. |
| Python packaging and operator regressions | **3/3 packaging tests and 4/4 operator tests passed**. |
| `./scripts/deployment/test-release-hostinger.ps1` | **17/17 synthetic scenarios passed**; no deployment occurred. |
| `python tools/deployment/validate_configuration.py` | Passed against the fetched Render schema. |
| Application and isolated-test `docker compose ... config --quiet` | Passed. |
| `npm.cmd run validate` | Passed; eight existing unused-model recommendations. |
| `npm.cmd run generate` and Dart `run build_runner build` | Passed; serializers wrote zero outputs. Generated files matched the base HEAD, including the workflow's canonical drift comparison. Separate in-progress order-contract edits are outside this generation result. |
| Python syntax and Dart fixture formatting | Passed. |
| Gitleaks changed-source scans and `gitleaks git --staged --redact --no-banner` | Passed; no leaks. The staged scan was empty because nothing was staged. |
| `git diff --check` for the repair files | Passed. |

Detailed local logs and synthetic negative fixtures are ignored under `.tmp/ci-run132/`. Native Dart execution uses the installed 3.13.3 SDK with the existing package configuration. The Windows sandbox cannot read the external Pub cache, so Dart checks ran with approved access to local dependencies.

Fresh API/edge image builds, image vulnerability scans, the complete local application suites and live provider/device acceptance were not rerun for these checker/fixture-only changes. A new hosted run on the repaired commit is still required. No commit, push, rerun or deployment was performed.

Suggested commit: `fix(ci): refresh finance fixtures and scanner validation`
