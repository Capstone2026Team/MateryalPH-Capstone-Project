# MateryalPH VPS deployment continuation prompt

Copy this entire document into the next coding-agent session in this checkout. This is a handoff of work observed on **23 October 2026**, not proof of a completed deployment. Recheck changing local/provider state before acting.

---

Continue the existing MateryalPH Hostinger deployment implementation through a verified staging release. Inspect what is already done, preserve the current work, and complete the remaining steps. Do not restart the project or stop after proposing another plan. Make useful progress on independent work while waiting for genuinely missing inputs. Report blockers accurately; never mark acceptance complete without evidence.

## 1. Workspace, authority and authorization

Repository:

```text
C:\Users\RJ\Downloads\Capstone Project System\Capstone_MateryalPH
```

Read `AGENTS.md`, `PRODUCT.md` and `DESIGN.md`, then the relevant workflows. Apply this authority order: `docs/workflows/` → technical system design → UI/UX planner → Figma for visuals only.

Read these existing implementation documents before editing:

- `docs/adr/0003-hostinger-vps-staging.md`
- `docs/deployment/hostinger-vps.md`
- `docs/deployment/render-staging.md`
- `docs/test-plans/hostinger-vps-verification.md`
- `compose.vps.yaml` and the deployment scripts they reference.

The user approved deploying to the existing Hostinger VPS and explicitly approved transferring the existing **Render staging settings** into protected local/VPS configuration. The VPS has already been purchased. DuckDNS reservation and server access preparation are complete. Do not ask for those approvals again. This handoff does not authorize another purchase, upgrade, unrelated credential rotation, Git push/merge, or unreviewed destructive operation. Prepare a concrete reviewable change before requesting any genuinely missing authorization.

Keep the fixed architecture: Laravel 13/PHP 8.4 modular monolith, PostgreSQL 16 with PostGIS/pg_trgm/pgcrypto, Redis-compatible queues/cache, Reverb, React 19/Vite 8 portals and Flutter Buyer. Clients use `/api/v1`. Do not alter business rules, permissions, payment/refund behavior, private-file authorization or generated clients by hand.

Never print, return, commit or screenshot secrets. Read secret files only through appropriate protected tooling. No credentials in chat, command arguments, tracked files, public build inputs or APKs. Ask only for a protected local file path or cloud-secret configuration when needed. Keep development and staging credentials separate.

## 2. Approved destination and addresses

This is capstone **staging**, with Xendit **TEST** and live commerce disabled. Target 20 simultaneous users, subject to actual testing.

| Item | Observed state |
| --- | --- |
| Hostinger VPS | `2086708`, `srv2086708.hstgr.cloud` |
| IPv4 | `187.77.142.129` |
| Plan/location | KVM 2; 2 vCPU, 8 GB RAM, 100 GB NVMe; Kuala Lumpur, Malaysia |
| OS | Ubuntu 24.04.5 LTS |
| Admin | `https://materyalph26-admin.duckdns.org` |
| Vendor | `https://materyalph26-vendor.duckdns.org` |
| Buyer API | `https://materyalph26-api.duckdns.org/api/v1` |
| Reverb | `wss://materyalph26-ws.duckdns.org` |

All four DuckDNS names were reserved by the user and their A records verified against this IPv4. Their AAAA queries returned no data. The stable IPv4 does not require exporting the DuckDNS account token merely to deploy; the optional updater needs it only if used. HTTPS has **not** been accepted against a running application.

## 3. Server preparation already completed

- Docker 29.9.2 and Compose 5.6.1 installed from Docker's official repository.
- Non-root sudo administrator `materyalph` has verified key-only SSH access. Root key access is retained for recovery; password and keyboard-interactive SSH are disabled.
- Docker, fail2ban and unattended upgrades are active. Automatic security reboot is disabled. Monarx is installed.
- Root-owned mode-0700 directories: `/srv/materyalph/private`, `/srv/materyalph/recovery`, `/srv/materyalph/releases`.
- Hostinger firewall `383691` is attached and its single-VPS synchronization succeeded: TCP 22 allowed from the observed operator IP `112.209.187.0/32`; TCP 80/443 and UDP 443 public; database/cache ports private. Recheck the operator's current IP before changing firewall rules. Preserve a recovery session.
- PostGIS 16/3.5, Redis 7.4 and restic 0.18.1 images were pre-pulled.
- **No application containers have been started on the VPS, no VPS application database has been restored, and no release has been activated.**

Existing ignored SSH files:

```text
.tmp/hostinger-deployment/access/id_ed25519.operator
.tmp/hostinger-deployment/access/known_hosts
```

Use the protected operator key, without displaying its contents. Example read-only connection from the repository root:

```powershell
& 'C:/Windows/System32/OpenSSH/ssh.exe' -o BatchMode=yes -o ConnectTimeout=15 -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.tmp/hostinger-deployment/access/known_hosts -i .tmp/hostinger-deployment/access/id_ed25519.operator materyalph@187.77.142.129 'sudo -n docker ps --format "{{.Names}}"'
```

Keep the known-hosts option relative: the Windows workspace path contains spaces and the absolute form previously caused option parsing problems. Do not disable host-key checking or weaken the key ACL. Sandbox network/Docker access may require the normal tool escalation mechanism; a sandbox restriction does not mean user deployment approval is missing.

## 4. Repository implementation already present

The implementation is **uncommitted**. Preserve it and unrelated user changes. Observed HEAD: `7e73f4c3ddbc2dfa66b9ad3709fbddb88f6b4dcd` on staging. Verify HEAD and diff before proceeding; no commit/push has been performed for this work.

| Area | Implemented files/behavior |
| --- | --- |
| Runtime | `compose.vps.yaml`: private PostgreSQL/Redis, persistent volumes, Redis AOF, independent HTTP/worker/scheduler/Reverb, Caddy edge, operator/release/backup profiles, restart policies and log rotation. Only edge publishes web ports. |
| Edge and PHP | `infrastructure/docker/portals.vps.Dockerfile`, its context allowlist, `vps-php-fpm.conf`, `infrastructure/vps/Caddyfile`. Static portal assets and same-host API proxy; HTTP does not start duplicate workers/schedulers. |
| Configuration | `infrastructure/vps/.env.example`, API/Reverb/backup examples; `vps-config.mjs`, `vps-host.py`, `prepare-vps-environment.py`. Exact hosts, TEST guards, raw secret handling and protected staging-setting transfer. |
| Release | `package-vps.py`, `vpsctl.sh`, `bootstrap-vps.sh`; immutable images, exact successful staging CI, operator-controlled releases, maintenance fence and evidence-based rehearsal/activation. |
| Recovery | `export-vps-source.py`, `vps-transfer.php`, PostgreSQL init helpers; new-database restoration, checksums, private objects, encrypted-history recovery and extension permissions. |
| Backups | Dedicated restic service/profile and systemd timer; encrypted offsite sets, seven daily/four weekly retention, pre-release backup requirement. |
| Verification | Deployment tests, `tools/deployment/validate_vps.py`, `load-vps.mjs`, `observe-vps.sh`, acceptance/load examples and verification record. |
| Buyer | `build-buyer-staging.ps1`, Hostinger/Render deployment registry examples, protected Android release-signing support, certificate/checksum/version delivery metadata. |
| Render | Existing Blueprint/deploy path retained. API standby fence and independently controlled supervised background processing support manual fallback. |

Additional changes requiring review:

- Historical imported outbox events are excluded at dispatch **and** direct execution via `ImportedOutboxBoundary`; no automatic replay of imported operations.
- Invoice `issued_on` validation now uses the Asia/Manila business date, fixing a UTC evening boundary. Regression coverage exists. OpenAPI wording and both generated clients were regenerated; request/response shapes did not change.
- API test fixtures were aligned to approved workflow behavior. Buyer support repository test compares multipart field values instead of `MapEntry` identity; Dart application behavior was unchanged.
- Both portal lockfiles use patched Vite 8.3.5. Development Compose remains available.

Do not modify already applied migrations. No deployment-related database migration was added in this work.

## 5. Protected settings and data already prepared

Protected ignored local draft:

```text
.tmp/hostinger-deployment/private-draft/
```

The approved helper copied 62 Render staging settings, generated separate database and backup passwords, retained matching **staging** encryption/Passport/Reverb identities, and did not modify Render. It did not export development keys or reuse Render's database connection. The user's approved public privacy contact is `3rdcapstone2026@gmail.com` and is configured. API/Reverb validation passed after final Hostinger URLs, CORS/reCAPTCHA identities, Google callback and Reverb broadcast settings were completed.

Provider-console allowlists are **not verified** merely because these environment values are valid. Existing private S3-compatible storage, Cloudinary, Brevo, Bouncer, Xendit TEST, Google and backend Firebase settings remain behind existing adapters.

Use these ignored pointer files to locate the prepared inputs; verify that the referenced paths and checksums still exist:

| Pointer | Observed destination |
| --- | --- |
| `.tmp/hostinger-deployment/source-location.txt` | `.tmp/hostinger-deployment/private-draft/source-20261022T203032Z` |
| `.tmp/hostinger-deployment/remote-draft-location.txt` | `/srv/materyalph/private/staging-draft-364508e2dd` |
| `.tmp/hostinger-deployment/remote-source-location.txt` | `/srv/materyalph/recovery/source-draft-9448cf0035` |

Five configuration files were staged remotely: `api.env`, `reverb.env`, `db-app-password`, `db-owner-password`, `backup-password`. Directory mode 0700, files root-owned 0600, checksums matched. This is a draft: **no complete runtime control file or offsite backup environment has been accepted**.

The source snapshot was captured quiescent on 22 October at 20:30:32 UTC / 23 October at 04:30:32 Philippine time:

- 89 applied migrations; no pending migrations observed.
- 282 public tables; source database size 119,804,387 bytes.
- Custom PostgreSQL archive: 7,781,033 bytes.
- 179 referenced private objects; 28,232,257 unique stored-file bytes.
- Jobs 0, failed jobs 47, outbox events 3,112 and audit rows 1,945 retained for review.
- Source imported-encryption registry was empty. Target staging-key recovery metadata was generated without exporting the development key.
- Remote archive/recovery checksums, all 179 objects and staging-key fingerprint passed verification.

Local writers have resumed, so **refresh the source snapshot before final release if local data has changed**. The old snapshot must not be described as indefinitely current. Render's actual restored size and its full recovery drill remain unverified, despite the source being below 1 GB.

Important prior incident, already repaired: resuming writers with Compose started an existing setup dependency and reran foundation seeding. Guarded comparison found only 15 creation/update timestamp changes across foundation rows; no policy-value or row-set changes. Those timestamps were restored transactionally and all six compared tables then matched the snapshot. Do not repeat this repair. For future export, record the running writer container IDs, stop them, and resume those exact IDs with **`docker start`**, not `docker compose start`. Preserve PostgreSQL/storage during export.

## 6. Latest verification: use these results accurately

See the verification record and ignored logs for details. Passing local checks are not successful CI, live acceptance or a deployed release.

| Check | Latest recorded result |
| --- | --- |
| Full isolated API suite | **PASS: 712 tests, 14,541 assertions**, 10:06.024, reported memory 151 MB, PHP 8.4.27/PostgreSQL 16. `.tmp/hostinger-deployment/api-full-final.log` and `.xml`. |
| API static checks | Pint full run passed, 818 files; changed PHP files subsequently passed focused Pint. PHPStan full run passed with no errors; `phpstan-final.log`. |
| Admin portal | Lint/types/build pass; 26 files, 156 tests pass. |
| Vendor portal | Lint/types/build pass; 65 files, 609 tests pass. |
| Portal dependency audits | HIGH-severity gate passes; two moderate advisories remain in each portal. |
| OpenAPI/clients | Validation passes with eight unused-model recommendations; both clients regenerated. Disputes contract check passes for 58 operations. |
| Deployment inputs | Seven Node tests and four Python operator tests pass; synthetic Windows ACL/raw-secret handling passed. |
| Flutter analyze | Full run passed; later focused support analysis also passed. |
| Flutter full suite | **FAIL:** last full run 480 pass, one skip, 66 failures, including widgets/goldens. Later three-test support fixture correction passes separately; no subsequent full rerun yet. |
| Schema verification | **FAIL:** guarded isolated helper reaches rollback and encounters forward-only migration behavior. Fresh/API test success does not resolve that separate verification problem. |
| API/edge verification images | Off-server builds, runtime/config fixtures and final HIGH/CRITICAL scans passed. They are not an accepted release; the API image predates the invoice correction and edge inputs were synthetic. |
| Android signing/build | Gradle offline configuration check passed. No signed release APK was built or delivered. |
| Live acceptance | Not performed: HTTPS/application, providers, 20 users, physical APK, reboot and timed Render recovery. |

The last observed GitHub run for the old staging HEAD was unsuccessful:

```text
https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/39774820093
```

It had dependency/Flutter/Admin/browser failures and a canceled backend. Local fixes are not pushed; recheck current CI rather than assuming this historical run is still latest. `package-vps.py` requires a successful **full manually dispatched quality-gates run on the exact staging SHA** and packages that Git commit, not this dirty tree.

Do not hide failed tests, regenerate goldens indiscriminately, weaken security gates, forge acceptance JSON or substitute success from another commit. Investigate Flutter failures against the approved design/workflows. Resolve schema verification honestly without rewriting applied migrations or dropping immutable history. The temporary unsuccessful profile-test expectation experiment was reverted; that failure remains to investigate.

The three isolated test containers used for API verification were stopped after the run; their volumes remain. Normal development services remain running. Do not run database tests against the development database.

## 7. Inputs still genuinely missing

Two questions were already asked and remained unanswered at handoff. Do not infer their answers:

1. Is there a **separate scoped offsite S3-compatible backup key and repository**? If available, obtain only the path to protected `backup.env`; no secrets in chat. Do not reuse the application storage key. New paid storage needs a concrete quote and approval.
2. Is there an existing **Android release keystore** that must be retained for updates? Obtain only its protected path/alias configuration. If none exists, establish the first stable signing identity through protected local handling and retain recovery custody. Do not replace an existing identity or assume one does not exist.

Provider checks still needed:

- Exact Google OAuth callback: `https://materyalph26-vendor.duckdns.org/api/v1/auth/google/callback`.
- reCAPTCHA allowlists for both portal hosts; Maps browser referrers and server/IP restrictions as applicable.
- Android package `ph.materyal.buyer`, release certificate, Maps key restrictions, Google sign-in client identity and native Firebase project/app identity.
- Xendit TEST callback/webhook; confirm the actual current OpenAPI/route before registering `https://materyalph26-api.duckdns.org/api/v1/webhooks/xendit`.
- Private S3 authorization, Cloudinary references, Brevo, fail-closed Bouncer scanning, provider-failure behavior and Firebase push on a physical device.

Ignored Buyer `hostinger.json`, `staging.json` and `deployments.json` already exist. Their endpoints are final; `addressesFinalized` was set for the confirmed DNS addresses, **not as proof of provider acceptance**. Native Firebase settings matched the existing package/project during static inspection. Maps is still marked unconfigured. `android/key.properties` does not exist. Revalidate all of these before release.

## 8. Complete the remaining work in this order

1. **Inspect and preserve.** Verify local/provider state, uncommitted diff and prepared paths. Read all relevant runbooks and workflow contracts. Use the Hostinger/Render plugins where sufficient; never display secret fields. Do not redo completed provisioning or the repaired local incident.
2. **Finish release gates.** Resolve remaining Flutter/browser failures and schema verification. Run the required API, both portals, Flutter, contract, infrastructure and secret checks. Keep focused/static evidence separate from full/live results. Review the final diff. If committing/pushing requires authorization, present the concrete ready change and remaining reason first. Obtain full successful CI on the reviewed staging commit.
3. **Finish provider and recovery inputs.** Complete exact provider allowlists/native configuration, protected backup credentials, recovery-key custody and the stable Android release identity. Proceed with independent work while waiting for an input; do not put a fake value on a required acceptance path.
4. **Build the exact accepted release off the VPS.** Use actual browser-public build inputs, rebuild API including the invoice correction, verify/scans on both immutable images, and retain release/archive hashes. Never build PHP or portal assets on the KVM 2.
5. **Finish private runtime control.** Use `infrastructure/vps/.env.example`, API/Reverb/backup examples and the prepared root-only drafts. Set exact commit, immutable image IDs and actual private paths. Validate API/Reverb/raw inputs, TEST/live flags and DNS. Do not copy a Windows control file unchanged if its paths need Linux equivalents.
6. **Refresh and transfer data if needed.** Quiesce writers, export current PostgreSQL and matching files, verify all checksums/key recovery, restart only the previously running container IDs, and transfer into a new protected recovery directory. Preserve the local source and existing Render data. Review failed/pending jobs, historical outbox, invites/sessions, overdue timers and TEST associations before enabling background work.
7. **Install and restore fenced.** Transfer/load the accepted images and runtime, verify hashes, initialize the separate offsite repository, restore only to a new VPS database, verify it, take the required recent offsite backup and deploy under the fence. Keep old data/releases available for recovery. Check extensions, migrations, counts, file hashes, encrypted history and least-privilege ownership.
8. **Prepare single-writer rehearsal.** Preserve Render data/files first. Align all Render services with the accepted release, keep automatic deploy off, then fence its HTTP/queue/scheduler before Hostinger rehearsal. Verify direct API and both portal API paths are fenced. Do not interrupt the current Render service until the replacement is ready for controlled acceptance.
9. **Build and deliver both signed APKs.** Use the same protected release identity for Hostinger and Render, increasing version codes, existing OAuth/payment deep links and verified native settings. Verify signatures, SHA-256 and version/endpoint metadata. The user handles installation/sign-in and three-role acceptance; a configuration check does not prove an installable APK.
10. **Run live acceptance.** HTTPS; portal refresh/deep links; secure HttpOnly host-only cookies and CSRF; exact origins; signed private files; scanning/provider failures; Buyer/Vendor/Admin authentication, discovery/maps, messaging, TEST checkout, fulfillment and reporting. Measure realistic activity with 20 simultaneous synthetic actors. Require ordinary database-backed reads p95 ≤2 seconds; report uploads/provider operations separately. Observe RAM/CPU, dashboard throttling/credits as actually reported, errors, queue age and scheduler execution. No zero-delay promise or automatic upgrade.
11. **Verify recovery before final activation.** Enable/check nightly encrypted offsite backups and pre-demo backups, reboot recovery, and a timed Hostinger-to-Render restore drill. Preserve Render's current dataset before replacement, validate the complete dataset against its 1 GB limit, and prove RPO ≤24 hours / RTO ≤60 minutes. Fence Hostinger before Render promotion. For failback transfer newer Render data into a new Hostinger database before promoting one writer. Never trim commercial/audit history to fit.
12. **Record and activate truthfully.** Record exact commit/images, reviewer/time, all acceptance outcomes and unresolved limits. Use `rehearse`/`activate` only with genuine evidence. Deliver working public URLs, both signed APKs/checksums/install instructions, backup/recovery instructions and the final verification record. Report a blocked gate explicitly if user input or an external system prevents completion.

## 9. Existing commands to use after their prerequisites pass

Read each script before invoking it. Placeholders below are not runnable values. Privileged runtime commands require the deployment administrator's appropriate sudo context and the accepted runtime directory.

```text
node scripts/deployment/vps-config.mjs validate PRIVATE_CONTROL_FILE
python scripts/deployment/package-vps.py Capstone2026Team/MateryalPH-Capstone-Project ACCEPTED_40_CHARACTER_SHA NEW_OUTPUT_DIRECTORY
python scripts/deployment/export-vps-source.py PRIVATE_STAGING_KEY_FILE NEW_PROTECTED_SOURCE_DIRECTORY
```

The packaging workstation needs Docker, Python dependencies and Trivy. Supply scoped GitHub authentication via protected environment handling and only browser-public `VENDOR_RECAPTCHA_SITE_KEY`, `ADMIN_RECAPTCHA_SITE_KEY`, `GOOGLE_MAPS_BROWSER_KEY` build inputs. Do not include backend credentials.

```bash
bash scripts/deployment/vpsctl.sh initialize /srv/materyalph/private/control.env
bash scripts/deployment/vpsctl.sh restore-new /srv/materyalph/private/control.env /srv/materyalph/recovery/SELECTED_BUNDLE materyalph_restore_YYYYMMDDHHMMSS
bash scripts/deployment/vpsctl.sh backup /srv/materyalph/private/control.env
bash scripts/deployment/vpsctl.sh deploy /srv/materyalph/private/control.env /srv/materyalph/releases/RELEASE/release.json
bash scripts/deployment/vpsctl.sh rehearse /srv/materyalph/private/control.env PRIVATE_REVIEW_JSON
# Only after the remaining acceptance checks actually pass:
bash scripts/deployment/vpsctl.sh activate /srv/materyalph/private/control.env PRIVATE_COMPLETED_ACCEPTANCE_JSON
```

Initialize is a one-time operation. A verified offsite backup no older than 15 minutes is required before deploy. Rehearsal itself enables writes/background processing, so the other environment must already be fenced. Confirm `activate` arguments against the current script before use.

```powershell
./scripts/deployment/build-buyer-staging.ps1 -Deployment Hostinger -Release -BuildName 1.0.0 -BuildNumber NEXT_NUMBER
./scripts/deployment/build-buyer-staging.ps1 -Deployment Render -Release -BuildName 1.0.0 -BuildNumber NEXT_LARGER_NUMBER
```

Use protected signing environment variables `MATERYALPH_ANDROID_STORE_PASSWORD` and `MATERYALPH_ANDROID_KEY_PASSWORD` through the existing key-properties mechanism. Retain the release certificate and recovery custody. Existing debug-signed installs may need user-led uninstall before their first release-signed install. Require fresh sign-in when switching deployments where sessions differ. Do not change package/deep links to avoid signing conflicts.

Backups use the supplied systemd service/timer around **02:10 Philippine time**, seven daily/four weekly sets, and separate protected recovery keys. The load tool and observer are documented in the runbook; use an ignored protected 20-actor scenario and never expose test tokens/cookies.

## 10. Render fallback constraints

Render is still active and was not modified by the approved setting export. Observed service identities:

```text
Backend service: srv-dbb2uafbtjjs7395h1r0
Vendor service:  srv-dbb2teuq1p3s73dl011g
Admin service:   srv-dbb2tg3rjlhs73b7epsg
Reverb service:  srv-dbb2u93rjlhs73b7huo0
Database:        dpg-dbb2t561egvs73clqop0-a
```

Standby uses `DEPLOYMENT_STANDBY=true`, `RUN_QUEUE=false`, `RUN_SCHEDULER=false` with the accepted deployment; verify fencing rather than just changing fields. Health `/up` remains available. Preserve data before any reviewed replacement and keep staging recovery keys consistent.

Manual fallback is selected **through 17 November 2026**. Previously supplied free-database expiry: **18 November 2026, 22:52 Philippine time**; recheck the dashboard before relying on it. Continued coverage after the selected window needs another hosting decision. No automatic failover or continuous cross-provider replication is implemented. Free Render may sleep; measure actual fallback delay.

## 11. Local tooling and pitfalls

Common installed Windows paths:

```text
Docker:   C:/Users/RJ/AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe
Flutter:  C:/Users/RJ/Documents/flutter/bin/flutter.bat
Dart:     C:/Users/RJ/Documents/flutter/bin/dart.bat
PHP:      C:/Users/RJ/Documents/php/php-8.4.25-nts-Win32-vs17-x64/php.exe
JDK:      C:/Program Files/Android/Android Studio/jbr
Gitleaks: C:/Users/RJ/Documents/gitleaks_8.30.1_windows_x64/gitleaks.exe
Bash:     C:/Program Files/Git/bin/bash.exe
```

Use `npm.cmd` on PowerShell. PyYAML/jsonschema tooling was installed under ignored `.tmp/vps-python`; use a task-specific `PYTHONPATH` when needed. Confirm tools rather than assuming PATH. Use `scripts/run-tests-isolated.ps1` and `compose.test.yaml` for database tests; the helper's schema rollback failure is still unresolved. Never point these tests at development or staging data to get past isolation guards.

Only about 5 GB remained on the Windows drive after recovery from build-cache exhaustion. Monitor disk space before images/APKs. Never delete/prune database volumes, factory-reset Docker Desktop or remove arbitrary user files. Previously cached verification images are not accepted release artifacts.

Prior automatic-review rejections were handled with narrower operations or explicit user approval: single-VPS firewall sync instead of all assigned VMs; approved guarded staging-setting transfer; aggregate-only source comparison instead of persisting complete sensitive rows. Do not retry the rejected broader forms.

## 12. Completion report

Update `docs/test-plans/hostinger-vps-verification.md` with dated evidence. Report actual deployment state, exact release, changed files/migrations/contract, security decisions, checks and results, signed APK artifacts and hashes, recovery outcomes and remaining setup or blocked gates. Distinguish local verification from CI, live providers, browser/device acceptance and restore testing. Never claim fully deployed, fully functional or no delay until the relevant gates actually pass.

Suggested eventual conventional commit, subject to final reviewed scope:

```text
feat(deploy): add Hostinger VPS staging and Render recovery tooling
```
