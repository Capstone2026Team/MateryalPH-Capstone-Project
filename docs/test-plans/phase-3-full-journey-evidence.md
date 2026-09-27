# Phase 3 full journey: evidence and acceptance status

**Reviewed:** 26 September 2026  
**Revision:** `a88d25b` plus the working-tree changes listed below  
**Verdict:** **The complete Phase 3 journey is not yet proven.** Phase 4 should wait for the Phase 3F acceptance gate in the [implementation plan](../plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md) to pass. This report records what the implementation and available checks establish, and the exact proof still required. It does not treat a mocked browser response, a seeded database status, or historical provider evidence as a completed live journey.

## Acceptance target

The approved gate is one Vendor and one organization progressing through: account active → welcome → verification draft → Finish Later → resume → submit → Admin requests a correction → Vendor replaces and resubmits → Admin approves all applicable requirements → Store Setup completes → activation succeeds → a later expired approved document causes the documented restriction. The same run must show authorization, audit history, requirement versions, private evidence handling, and independent Store Verification and Store Setup status. See [Phase 3F acceptance gate](../plans/MateryalPH_Implementation_Phases_and_Codex_Prompts.md) and the [onboarding build specification](../workflows/MateryalPH_Store_Verification_Onboarding_Spec.md).

The later approved onboarding specification has **four Verification steps and six Setup steps**, including required S5 Store Operation. Team Accounts are optional and excluded from setup completion and activation. An older sentence in the implementation plan still says five Setup steps; the six-step specification and current UI take precedence for this review. Store Setup can progress while Admin review is pending, but completion cannot approve a verification requirement or activate the store by itself.

## Evidence map

| Journey segment or rule | Current evidence in repository | What it establishes | Limit |
| --- | --- | --- | --- |
| Welcome, dashboard, Finish Later, step navigation, responsive Vendor/Admin pages | `apps/vendor-web/e2e/onboarding-steps.spec.ts`, `phase-3c.spec.ts`, `team-setup.spec.ts`, and related Playwright specs | Browser behavior and layout at 320, 375, 390, 768, 1024, 1280, 1440, and 1920 px; draft and navigation controls are exercised | The tests intercept `/api/v1` and supply in-memory snapshots, so they do not prove persistence or real cross-role transitions |
| Verification submission and retry safety | `services/api/tests/Feature/Api/PhaseThreeVendorOnboardingTest.php::test_vendor_can_submit_verification_once_and_replay_the_same_idempotent_request` | Passed on the isolated database: `PENDING_VERIFICATION`, idempotent replay, and conflicting replay rejection | It starts from a fixture and is only one segment of the journey |
| Admin correction, Vendor replacement and resubmission | `PhaseThreeVendorOnboardingTest.php::test_submission_promotes_multiple_files_and_only_replacement_reopens_review` | Same-organization feature test covers submission, an Admin `CHANGES_REQUIRED` decision, private replacement, resubmission, preserved BIR approval, and version history; grouped Admin review now asserts the persisted document `SUBMITTED` status separately from the pending requirement status | The chain stops before all approvals, Setup completion and activation |
| Activation readiness and discoverability | `PhaseThreeVendorOnboardingTest.php::test_ready_setup_and_verification_can_activate_without_making_the_store_discoverable` and `test_each_of_the_ten_activation_conditions_individually_blocks_readiness` | The fixture now persists clean Logo/Banner media and a valid seven-day schedule, and the tests pass against the server gate, blocker conditions and separate discoverability | `activationReadyFixture()` still directly seeds verification approvals, tax approval, account connection and agreements. It bypasses the preceding Vendor/Admin journey |
| Later document expiry and restriction | `PhaseThreeVendorOnboardingTest.php::test_expired_approved_evidence_is_notified_once_and_restricts_active_store` | The test targets one expired notice and `RESTRICTED` with `DOCUMENT_EXPIRED` | It directly sets the organization to `ACTIVE` before advancing time, so it does not prove expiry after actual activation in the same journey |
| Private evidence and role limits | `PhaseThreeVendorOnboardingTest.php` includes private evidence, stale decision, activation bypass and team-permission cases; browser checks include denied private-document UI | The private evidence scope test passed on the isolated database | A passing denial case does not complete the full journey |
| Xendit TEST connection | [Current service note](../../services/api/docs/xendit-onboarding.md) documents a backend-associated TEST Owned account confirmed by read-only `GET /v2/accounts/{id}` as `LIVE/OWNED` on 25 September 2026 | Historical evidence for that associated account and the v2 Owned flow | No new provider call was made for this report; this does not prove a newly created account, TEST transaction, LIVE onboarding, or the full Phase 3 journey |

**Core gap:** there is no single executable test or captured UAT record that keeps one organization ID through every step of the acceptance target without inserting successful statuses directly into the database. The existing tests support individual rules and a partial correction chain; they cannot be combined into proof of the whole journey by inference.

## Checks performed in this review

| Check | Result |
| --- | --- |
| API Pint and PHPStan | Passed (`vendor/bin/pint --test`; `vendor/bin/phpstan analyse --memory-limit=512M --no-progress`) |
| Vendor lint, typecheck, unit tests, build | Passed; **163/163** Vitest tests |
| Admin lint, typecheck, unit tests, build | Passed; **25/25** Vitest tests |
| OpenAPI validation, generated TypeScript build | Passed; validator reported three unused-model recommendations |
| Vendor/Admin and account contract checks | Passed; **35** Vendor/Admin operations and **61** account operations checked |
| Vendor/Admin Playwright browser suite, eight widths | Passed; **312/312** fixture-backed UI checks in 3.6 minutes |
| Docker access and isolated guard | Docker client and server **29.8.0** work outside this agent's filesystem sandbox. A previous `./scripts/run-tests-isolated.ps1 -GuardOnly` passed all static and live isolation checks, including Compose configuration and PostgreSQL 16/PostGIS schema checks. The initial "CLI was not found" message was caused by sandbox denial of the Docker executable and was an incorrect diagnosis of the host installation |
| Full isolated API suite after fixing the 11 failures | Started the isolated stack with direct `docker compose ... up -d --wait`, then ran `php artisan test --compact --no-ansi`: **244 passed, 0 failed (2,736 assertions)** in 140.48 seconds. The prior 11 Phase 3 failures are resolved. The test containers were stopped afterward |
| Focused Phase 3 regression | The first post-edit focused run had **82 passed, 2 failed** because two tests changed derived Setup checklist rows directly. After changing those tests to invalidate the persisted source data, both cases passed (**2 tests, 77 assertions**), and the subsequent full suite passed |
| Post-edit Vendor lint/typecheck | Passed |
| `git diff --check` on current working tree | Failed on trailing whitespace at `scripts/run-tests-isolated.ps1:140`, `:143`, and `:146` in the separately modified wrapper script; no report whitespace error was found |
| Secret scan | `gitleaks dir apps/vendor-web/e2e --redact --no-banner` and `gitleaks dir docs/test-plans --redact --no-banner` found no leaks. The required staged scan also passed but scanned zero staged commits, so it provides no evidence for unstaged files |
| Live Xendit transaction or new account creation | Not attempted; no provider success claimed in this review |

The local PostgreSQL 18 installation is not a substitute: the test harness requires its dedicated PostgreSQL 16/PostGIS test container and rejects an arbitrary database. The isolated container was used for the results above. Do not run onboarding feature tests against the development database or weaken that guard to obtain a green result.

## Proof required to close Phase 3F

1. The prior **11 Phase 3 feature-test failures are fixed**, and the full isolated API suite passes. The current working-tree `run-tests-isolated.ps1` still needs its Compose startup checked: it attached to logs and stalled while direct `docker compose ... up -d --wait` worked. Preserve a successful wrapper result when that script is repaired. Docker is available outside this agent's sandbox, and the isolated guard passed previously.
2. Add and execute one same-organization integration scenario using public API actions: register and verify the Owner, visit/dismiss welcome, draft and Finish Later, reload and resume, submit, perform scoped Admin correction, replace only the affected evidence, resubmit, approve every applicable requirement, complete all **five required Setup checklist items** (including Store Operation and confirmed TEST payment account), and activate. Assert separate persisted workstream states and show that Setup did not approve any verification item.
3. In that scenario, assert the activation endpoint refuses early and names blockers. Assert a cross-Vendor or unauthorized staff request cannot read private evidence or decide requirements. Confirm Team Accounts remain optional; delegated staff cannot cross their fixed-role boundary.
4. After genuine activation, advance a fake clock past the verified document expiry, run the scheduled expiry scan, assert one notice, the documented `RESTRICTED` state and hold reason, and verify activation/audit history. Check the required reminder path before expiry. Avoid directly setting `ACTIVE`, `APPROVED`, or `COMPLETED` in the test body.
5. Run a cross-client Vendor/Admin browser journey against that local API, or capture a reproducible manual UAT trace with the same organization identifier, request correlation IDs, status snapshots, Admin decision, Vendor correction, and expiry outcome. Mask personal data, evidence contents, tokens and provider IDs. Use fakes or the approved TEST sandbox for provider behavior; record provider confirmation separately from application assertions.
6. Re-run all Phase 3 gates in the implementation plan: API and web suites, eight-width browser checks, OpenAPI validation, contract checks, generated clients, Docker Compose validation, secret scan and `git diff --check`. Review the resulting evidence before accepting Phase 3 and proceeding to Phase 4.

## Working-tree note

This review aligned three fixture-backed Playwright specs with the approved six-step Setup flow and current account security dialog: `apps/vendor-web/e2e/onboarding-steps.spec.ts`, `team-setup.spec.ts`, and `account-settings.spec.ts`. The Phase 3 API feature tests were updated to construct valid persisted Setup data and assert the current requirement/document states. The working-tree edits to `docs/workflows/MateryalPH_Final_Vendor_Workflow.md`, `scripts/run-tests-isolated.ps1`, `docs/architecture/erd.md`, and `docs/architecture/data-dictionary.md` were preserved. No production code, migration, API contract, real credential or provider configuration was changed. The isolated test script prepared its ignored, test-only environment and protected Passport keys.

**Final browser result:** 312 passed, 0 failed (3.6 minutes). This verifies the UI fixtures and layout; it does not close the database-backed full-journey gate.
