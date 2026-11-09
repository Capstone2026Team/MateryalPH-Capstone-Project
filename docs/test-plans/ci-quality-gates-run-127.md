# Quality gates repair - run 127

Reviewed [GitHub Actions run 127](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/42623572968), commit `b49d1921b8fd1b8be9237a5f57f4167dd2ed6424`.

## Causes and repairs

| Gate | Cause | Repair |
| --- | --- | --- |
| Laravel tests | The messaging fixture set a Project to `ARCHIVED` without the metadata required by the archive constraints. | Supply its archive timestamp, exact 720-hour retention deadline and prior lifecycle state. Keep the constraints and messaging assertions. |
| Browser QA, all four shards | Checklist and team tests still expected the former six-screen setup flow. The team fixture also lacked the saved delivery method/readiness needed to show staff guidance. | Select the current setup sections by name, supply an incomplete Vendor Delivery setup, and verify the existing invitation and subsequent Xendit/Store Operation flow. |
| Browser retry passes | The analytics test read scroll position before keyboard scrolling finished. The onboarding test counted saves before its retry button finished waiting for an earlier autosave. | Poll the scroll result and settle retry-button actionability before counting the explicit save. |
| Local browser readiness | A lazy verification page exceeded the five-second initial heading wait. A compact setup layout test clicked Next while its preview edit was still autosaving. | Allow a bounded 15-second initial load and wait for the saved preview edit before measuring section navigation. Existing autosave/navigation behavior tests remain in place. |
| Buyer interaction | The Ranking Preferences text was partly obscured by the bottom navigation when tapped. | Bring it fully into view and settle scrolling before tapping. |
| Buyer screenshots | Ten baselines predated approved ranking, cart, checkout, profile and Project/archive changes. | Visually compare and refresh only the affected baselines. Keep exact image comparison. |
| Buyer Project test | After the first golden mismatch was removed, the test still attempted supplier sourcing from archived history. | Assert archived sourcing is absent, then simulate a restored Active Project and verify the map retains its locked site. |

## Changed files and boundaries

- API: `services/api/tests/Feature/Api/PhaseNineMessagingTest.php`.
- Buyer: `test/phase7_enhancements_test.dart`, `test/projects_phase_ten_test.dart` and ten PNGs under `docs/design/evidence/{buyer-account-refinement,phase-7,phase-10,ui-refinement}`.
- Browser: `checklist-panels.spec.ts`, `team-setup.spec.ts`, `product-analytics-layout.spec.ts` and `onboarding-steps.spec.ts` under `apps/vendor-web/e2e`.
- Documentation: this report. Incidental failure images and logs remain local in ignored `.tmp/ci-run127/`.
- No production application, migration, OpenAPI/generated-client, workflow-gate, role, authorization or payment-rule changes. No new environment keys or manual setup are required.

## Validation

| Check | Result |
| --- | --- |
| Isolated messaging reproduction before the repair | Failed with `projects_archive_state_check`, matching GitHub. |
| Isolated `vendor/bin/phpunit tests/Feature/Api/PhaseNineMessagingTest.php --colors=never` | Passed: 56 tests, 1,520 assertions. |
| API `vendor/bin/pint --test` | Passed: 914 files. |
| API `vendor/bin/phpstan analyse --memory-limit=1G` | Passed: no errors. |
| Vendor `npm.cmd run lint` / `npm.cmd run typecheck` | Passed. |
| Vendor and Admin `npm.cmd run build` | Passed; existing large-chunk recommendations remain. |
| Buyer Dart formatting | Passed: 298 files, zero changes. |
| Buyer `flutter analyze --no-pub` | Passed: no issues. |
| Buyer `flutter test --no-pub --concurrency=2 --reporter=expanded` | Passed: 713 tests, one existing skip, zero failures. |
| Browser: four affected suites, eight viewports, automatic retries disabled | 150 of 152 passed in the broad run. The two local readiness cases above were then corrected; both passed three repeats at each affected width (12 passed). All 152 distinct cases are covered across these runs. |
| Team invitation/setup regression | Passed at all eight viewports after completing the delivery fixture. |
| Autosave conflict/retry regression at 320px | Five consecutive passes, automatic retries disabled. |
| OpenAPI `npm.cmd run validate` | Passed: eight existing unused-model recommendations. |
| `docker compose config --quiet` | Passed. |
| Gitleaks changed-source scan and staged scan | Passed: no leaks; the staged scan is empty because no files were staged. |
| `git diff --check` | Passed. |

Backend tests use `compose.test.yaml`, project `materyalph_phase1_test`, after the live isolation guard passes. Development data is not used. The full backend suite and unaffected portal component suites are not rerun: this repair changes test fixtures and baselines, and those portal suites passed in the reviewed hosted run. Browser responses are synthetic and do not establish live provider acceptance.

Final browser checks inherit the committed Playwright configuration, projects and assertions through an ignored local configuration, with independently managed previews on ports 4173/4174. This avoids Windows preview-teardown stalls. One earlier local rerun was interrupted when its reused preview was stopped; its results are excluded from final coverage. The complete 152-case run was not repeated solely to replace the two corrected readiness results with a single aggregate green run. Logs and visual comparisons are retained in `.tmp/ci-run127/`.

No commit, push or deployment is performed. A new GitHub run on the repaired commit is still required to establish hosted CI success.

Suggested commit: `fix(ci): align regression fixtures with current workflows`
