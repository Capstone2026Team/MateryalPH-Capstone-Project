# Hostinger VPS implementation verification

Initial verification: 22 October 2026. Updated 23 October 2026: **VPS preparation completed; application release and cutover remain blocked**. The user purchased and provisioned the VPS and reserved the DuckDNS names. No application database import, Render promotion or signed APK delivery has occurred.

## Live VPS preparation on 23 October

- Confirmed VPS `2086708`, `187.77.142.129`, KVM 2, Kuala Lumpur, Ubuntu 24.04.5 LTS.
- All four `materyalph26-{api,admin,vendor,ws}.duckdns.org` A records resolve to the VPS; all AAAA lookups returned no data.
- Added the deployment operator's SSH public key. The private key remains in protected ignored local storage and is not in this report.
- Installed Docker 29.9.2 and Compose 5.6.1 using Docker's official Ubuntu repository. Created the `materyalph` deployment administrator, tested its key-only SSH and sudo access, then disabled SSH password/keyboard-interactive login. Root key access is retained for recovery.
- Docker, fail2ban and unattended-upgrades are active. Automatic security reboot is disabled. `/srv/materyalph/private` is root-owned mode 0700.
- Created and attached firewall `383691`: SSH from the observed administrator address only, TCP 80/443 and UDP 443 for public web traffic. The single-VPS sync action completed successfully and a fresh SSH connection succeeded afterward. No database/cache ports are published.
- Pre-downloaded PostgreSQL 16/PostGIS, Redis 7.4 and restic images. No application containers were started and no source data was changed.
- Read GitHub's latest run for staging commit `7e73f4c3ddbc2dfa66b9ad3709fbddb88f6b4dcd`: required aggregate failed. Reported failures include dependency audit, Flutter tests, Admin tests and browser QA; backend was canceled. This commit is not a release candidate.
- Updated both portal lockfiles to a patched Vite 8 version to resolve the high-severity dependency issue. Both portals again passed lint, typecheck, tests (156 Admin / 609 Vendor), production builds and the high-severity audit gate. Two moderate dependency advisories remain; this is not a claim of zero audit findings.
- Raw Compose environment-file handling, optional DuckDNS updater-token handling, five Node deployment tests and static/real Compose validation passed.
- A fresh API image built successfully off-server. Its eight-worker runtime, upload limits, maintenance fence and independent health checks passed at the actual VPS API budget of 1.5 vCPU / 2304 MB (busy health probe 3.9 ms). The earlier run under the Render fixture's 0.5-vCPU budget failed the worker-start timing check; it was not counted as a VPS pass.
- The first Linux portal-image build failed because shared TypeScript configuration was missing from the Docker context. Added `packages/shared-config` to the Dockerfile and its explicit context allowlist; the subsequent Linux image built successfully with synthetic public portal inputs. It is a verification image, not a release configured for actual Google providers.
- Local disk exhaustion interrupted the subsequent build and scanner cleanup. Restarted Docker Desktop, cleared npm's download cache and unused Docker build cache (17.22 GB within Docker), and restored the existing development services; API/PostgreSQL/Redis health checks passed afterward. No database volumes were removed. The API vulnerability scan was then rerun successfully: no HIGH/CRITICAL findings in the Alpine or Composer targets. Both Render and VPS FPM configurations and transfer-script PHP syntax passed against the fresh image. Approximately 5 GB remains free on the Windows drive, so release packaging still needs disk-space monitoring.
- Automatic approval review blocked the attempted export of existing Render staging secrets into the protected local draft; explicit transfer approval was requested. No secret export occurred from that rejected action.
- The portal image's initial scan found five HIGH findings in the official Caddy 2.11.7 binary (Go standard library and `golang.org/x/net`). Rebuilt the same Caddy release with Go 1.27.3 and `x/net` 0.60.0 using the official builder. The final edge image passed Caddy validation and the HIGH/CRITICAL scan with zero findings in its Alpine/Go targets. CI now scans both API and edge images. Docker's build warnings identify the three browser-public build arguments; no backend credentials were supplied.
- Corrected `VendorEarningsTrendTest` to freeze its clock before seeding effective policies. Its isolated PostgreSQL run passed all eight tests and 570 assertions. The subsequent full API suite passed as recorded below.
- Synthetic private-draft verification passed literal dollar/hash handling and protected NTFS access without inherited or unexpected user permissions. Render was not contacted by this test. The PowerShell Security module was unavailable, so ACL verification used the .NET directory security API.

Automatic review also rejected an all-assigned-VM firewall sync because assignment scope was not verified. The safer single-VPS operation was used successfully. Render remains unchanged and active.

## Approved configuration transfer and data preparation on 23 October

- The user explicitly approved the staging-setting transfer. The guarded helper copied 62 existing Render settings into a new protected local draft; it generated separate database/backup passwords and did not modify Render. The user supplied the missing privacy contact, which is now configured privately.
- Completed the Hostinger frontend URLs, Google callback, exact CORS origins/reCAPTCHA hostname identities and Reverb broadcast driver. API/Reverb draft validation passed. External provider-console allowlists still require verification; draft validation does not prove provider acceptance.
- Fixed both operator preflight parsers to preserve literal quotes, dollar signs and hashes in Compose raw secret files. Seven Node deployment tests and four Python operator tests passed, including malformed-input and exact-hostname rejection.
- Captured a fresh quiescent source recovery set: 282 public tables, 119,804,387 database bytes, a 7,781,033-byte database archive and 179 referenced private objects (28,232,257 unique stored-file bytes). Source recovery registry was empty; development keys were not exported. Historical failed-job and outbox records remain present for review, without replay.
- Resuming writers with Compose unexpectedly reran the existing setup dependency. Comparison against the fresh archive found only creation/update timestamp changes in 15 foundation rows; no added/removed rows or changed policy values. Restored those timestamps in one transaction with matching-current-value guards. A second comparison found zero differences in all six foundation tables, including agreement versions and OAuth clients. The runbook now requires direct container starts. Other background work resumed normally afterward.
- Automatic review rejected persisting full before/after comparison rows. The revised comparison stored only aggregate counts and column names; the source archive remained in protected storage.
- Staged five configuration files in a new root-owned mode-0700 private VPS directory, each mode 0600. All checksums match. Transferred the recovery set into a separate root-only VPS directory and verified its archive/recovery checksums, all 179 objects and target staging-key fingerprint. No VPS database restoration or application startup occurred. The first archive extraction needed an explicit gzip flag; the successful retry passed every check.
- Updated project, catalog-role, support-limit and work-package test fixtures to the approved workflow behavior, without changing production rules or endpoints. The 19 project/specification tests passed with 444 assertions, and the remaining 52 catalog/rate-limit/authoring/sourcing tests passed with 2,859 assertions. Pint passed for the six changed fixture files. The full API rerun is separate evidence below.
- Corrected a Buyer support test that compared Dart `MapEntry` identities rather than multipart field values. All three support repository tests passed, Dart formatting reported no changes, and focused analysis found no issues; no Dart application behavior changed. The other Flutter failures and browser QA remain unresolved.
- Corrected invoice date validation to use the Philippine business date, with a regression at the UTC/Asia-Manila date boundary. The final isolated full API run passed **712 tests and 14,541 assertions** in 10:06.024; PHPStan passed with no errors. Evidence: `.tmp/hostinger-deployment/api-full-final.log` and `api-full-final.xml`. The earlier API verification image predates this correction and must be rebuilt for release.
- Still required: a separate scoped offsite backup key/repository, stable Android release signing identity, provider allowlists and native configuration verification, successful exact-commit CI and all live acceptance/recovery gates. These draft files and recovery sets are not an accepted release.

## Changes and boundaries

Added ADR 0003, separate VPS Compose, Caddy/portal image, independent runtime roles, protected configuration examples, exact-commit release packaging, source export and recovery tools, encrypted offsite backup scheduling, load/monitoring tools and Buyer deployment/signing profiles. Development Compose and the existing Render path remain available. The existing staging recovery registry is reused.

No database migrations, request/response shapes, commerce formulas, role permissions or Dart application behavior changed. API changes are the opt-in staging import boundary (historical outbox events excluded at dispatch **and** direct job execution) and the correction of invoice date validation to use today's Asia/Manila calendar date instead of UTC. OpenAPI documents that date boundary; both generated clients were regenerated, with documentation-only changes. Private files, authenticated signed reads, host-only secure cookies, CSRF, exact origins and TEST-only commerce remain required.

## Executed local checks

| Check | Result and scope |
| --- | --- |
| API Pint | Passed from `services/api`; isolated run reported 818 files. |
| API PHPStan | Passed, no errors, 512 MB budget. |
| New outbox boundary unit tests | 3 passed, 5 assertions. |
| `OutboxDeliveryTest.php` and `ImportedEncryptionRecoveryTest.php` | 15 passed, 51 assertions, guarded isolated PostgreSQL 16. |
| Full API suite | **Passed:** 712 tests, 14,541 assertions, 10:06.024, 151 MB reported memory, isolated PostgreSQL 16 with a 512 MB CLI budget. This supersedes the earlier failed runs after workflow-aligned fixture corrections and the invoice business-date fix. |
| Schema verification | Isolation guard and negative cases passed. Full schema check reached `migrate:rollback` and failed. An earlier fresh migration attempt encountered two detached Phase 15 trigger functions in the reused isolated database; only those isolated functions were removed before retrying. Development data was not touched. |
| Admin lint/typecheck/tests/build | Passed; 26 test files, 156 tests. Existing bundle-size warning remains. |
| Vendor lint/typecheck/tests/build | Passed; 65 test files, 609 tests. Existing bundle-size and jsdom navigation warnings remain. |
| Flutter analyze | Passed, no issues. |
| Full Flutter tests | **Failed:** latest full run had 480 passed, one skipped, 66 failed, including widget expectations and golden/layout checks. The later three-test support fixture fix passed separately; the full suite has not been rerun since that fix. New failure artifacts were retained privately under `.tmp/vps-flutter-failures`; tracked generated images were restored to their original bytes. |
| Android Gradle | `gradlew help --offline` passed using the installed JDK; signing configuration compiled. No release signing or APK build was performed. |
| OpenAPI validate | Passed with eight unused-model recommendations. Invoice-date documentation was clarified and both clients regenerated; request/response shapes are unchanged. Disputes contract verification passed for 58 operations. |
| Node deployment tests | 7 passed, including raw secret preservation, immutable releases/host suffixes, DNS fencing, DuckDNS redaction and load-scenario/report guards. |
| Python operator-input tests | 4 passed, including raw environment parsing, data-only inputs, duplicate/multiline rejection, extension allowlist and restore-list preservation. |
| Recovery archive fixture | Passed traversal rejection, key normalization, full checksum verification and object-tamper rejection. |
| Real VPS Compose parser | Passed using temporary synthetic inputs; no VPS services started. |
| Fresh API/edge images | Both built off-server; API runtime/FPM checks and edge Caddy validation passed. Both final HIGH/CRITICAL scans exited zero. Edge portal settings were synthetic; no accepted release was packaged. |
| Earnings fixture clock | 8 tests passed, 570 assertions after freezing the date before policy seeding. No financial rule changed. |
| Static VPS invariants | Passed private networking, independent roles, staging guards, persistence and log rotation. |
| PostgreSQL restore fixture | Passed in a unique network-isolated container: private secret initialization, source extensions, application-role restore, retained source history and removal of temporary extension import grants. The fixture exposed and fixed PostGIS extension/schema ownership issues. |
| HTTP runtime fixtures | Passed against cached PHP images with current configuration: eight concurrent VPS workers, maintenance fence and reopening, independent health, query redaction, upload limits and FPM-failure detection. VPS health response while workers were busy: 1.8 ms in the fixture. This is not a live 20-user capacity measurement. |
| Caddy configuration | Passed `caddy adapt --validate` with synthetic hosts and the pinned Caddy image. Formatting/redundant forwarded-header warnings are nonblocking. |
| Restic image | Pinned 0.18.1 image starts; version verified. No offsite repository or recovery drill was exercised. |
| Shell/Python/PowerShell syntax | Passed for deployment entrypoints, operator tooling and Buyer build script. |
| Secret scan/diff | Changed-file scan passed after identifying the proposed **public** API hostname as a generic-key false positive and marking only that public example line. `git diff --check` passed. No credentials were printed. |

The native API unit-suite invocation was interrupted after hitting database-backed tests outside its required isolated environment. The authoritative API results above are from the isolated Docker test environment. An initial API run exhausted the cached image's 128 MB CLI default; the full reported run used 512 MB.

The earlier fresh API build attempts failed on Alpine repository DNS resolution; the later fresh build and vulnerability scan on 23 October succeeded as recorded above. A successful workstation build or synthetic runtime fixture does not establish an accepted CI release or live-provider readiness. No Git push/commit or application deployment was performed.

## Remaining release gates

- Resolve the schema verification and remaining Flutter/browser failures; run the full quality workflow on the exact reviewed staging commit. The local full API suite now passes. Build, scan and verify the exact release images, including the latest invoice correction.
- VPS purchase/provisioning, four DuckDNS A/AAAA checks and SSH/firewall preparation are complete. Verify HTTPS after the accepted application release is installed, and finish exact provider allowlists/callbacks.
- The API/Reverb staging draft and fresh recovery set are prepared, validated and privately staged on the VPS. Finish separate scoped offsite credentials and provider-console allowlists/native identities; verify private storage, TEST payment identities, Brevo, Bouncer, Google and Firebase in the running application. Never put credentials in chat or tracked files.
- Restore the staged fresh recovery set to a new VPS database after accepted-release gates pass, then verify counts, extensions, encrypted history, private authorization and import reviews. Refresh the quiescent export if local data changes before release.
- Supply the stable protected signing identity/native settings; build and verify both APKs, checksums, versions, signing-certificate identity and physical-device installation.
- Complete user-led authentication, discovery/maps, messaging, TEST checkout, fulfillment, reporting and failure-path acceptance across all roles.
- Run the 20-user scenario on the actual KVM 2 with CPU/RAM/queue/schedule/error observations; verify reboot recovery and a timed Hostinger-to-Render drill (RPO <=24h, RTO <=60m).
- Preserve Render data, align the accepted release and fence it at cutover; maintain only the selected fallback window through 17 November 2026.

Suggested commit: `feat(deploy): add Hostinger VPS staging and Render recovery tooling`.
