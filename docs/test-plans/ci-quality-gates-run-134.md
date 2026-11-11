# Quality gates repair - run 134

Reviewed [GitHub Actions run 134](https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/42973987931), commit `9031a7ec2dea2f8c68a6e741ab21c6cee878aafd`, through the authenticated GitHub API.

## Cause and repair

The only failing job was **Flutter Buyer app**, at **Test Buyer app**. The `order hub` golden in `test/phase8_capture_test.dart` differed from `docs/design/evidence/phase-8/390-order-hub.png` by **8.48%, 357,180 pixels**. The unchanged local test reproduced those exact values with Flutter 3.47.3 and Dart 3.13.3, matching CI.

The approved active-order tab update increased the Item/Project controls from 40 to 44 logical pixels, shifting the content below them. The committed baseline still showed the earlier controls. Visual review confirmed the expected shift with the existing order facts, actions and layout preserved.

Updated only the order-hub baseline, using the exact test-name filter. The synthetic capture fixture now supplies `ITEM_BASED: 2` and `PROJECT_BASED: 1` active totals so the same screenshot also covers both new tab badges. Other golden baselines and the pixel comparison remain unchanged.

All other hosted jobs succeeded, including the backend, OpenAPI/generated clients, portals, four browser shards, iOS simulator build, infrastructure, dependency audits and secret scan. The aggregate job failed because the Buyer test job failed. The original hosted Buyer result was **749 passed, one failed, one skipped**; it does not describe the repaired checkout.

## Files and boundaries

- `apps/buyer-mobile/test/phase8_capture_test.dart`: synthetic active-count fixture.
- `docs/design/evidence/phase-8/390-order-hub.png`: reviewed current baseline.
- This report.

No production application, migration, API contract, generated client, authorization, financial rule, credential or workflow-gate change. No new environment keys or manual setup are required. Failure diagnostics were retained under ignored `.tmp/ci-run134/`; tracked diagnostic images were restored from their original local copies.

## Local validation

| Check | Result |
| --- | --- |
| Unchanged `order hub` golden | Reproduced the exact hosted failure before repair. |
| Filtered `order hub --update-goldens` | Passed; only the intended baseline changed. |
| Dart formatting check for Buyer `lib` and `test` | Passed: 308 files, zero changes. |
| `flutter test --no-pub --reporter expanded` | Passed: **750 tests, one existing skip, zero failures**, including the order-hub comparison and the remaining golden tests. |
| `flutter analyze --no-pub` | Passed: no issues found. |
| Gitleaks on changed fixture/report source and staged changes | Passed; no leaks. The staged scan was empty because nothing was staged. |
| `git diff --check` and final diff review | Passed; only the fixture, intended baseline and this report changed. |

Backend, portal, iOS-build and infrastructure checks were not rerun locally for this test-only change. The screenshots use synthetic data; physical-device and provider acceptance were not performed.

No commit, push, rerun or deployment was performed. A fresh hosted run on the repaired commit remains required.

Suggested commit: `test(buyer): refresh order hub golden for active counts`
