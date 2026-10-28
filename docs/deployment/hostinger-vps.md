# Hostinger KVM 2: staging deployment and recovery

Implementation: [ADR 0003](../adr/0003-hostinger-vps-staging.md), [`compose.vps.yaml`](../../compose.vps.yaml). This is staging with Xendit TEST and live commerce disabled. No purchase, server provisioning or cutover is implied by repository files.

## 1. Purchase and account prerequisites

Obtain an authenticated Hostinger **one-month** KVM 2 quote including taxes, currency, location, full due-now total, renewal and selected extras. Malaysia first; Indonesia only if unavailable. Review it against the earlier USD 15 limit. Do not buy a prepaid multi-month/year term or automatically upgrade. Separate approval of that exact quote is required.

Select Ubuntu 24.04 LTS and an SSH public key. The user signs in to Hostinger and DuckDNS directly; never put a password/token in chat. Reserve `materyalph26-{api,vendor,admin,ws}.duckdns.org` together, or one replacement numeric suffix across all four. Reservation, not a missing DNS response, proves availability. Point all four A records to the confirmed VPS IPv4 and remove stale AAAA records. DuckDNS supplies ongoing free subdomains; no Hostinger paid domain is required.

Use a key-only SSH administrator with sudo. Confirm a second key-authenticated session and Hostinger console recovery before disabling password/root login. Restrict provider firewall TCP 22 to the administrator's public IP; expose TCP 80/443 and optional UDP 443. Publish no PostgreSQL/Redis/container-admin ports. Docker published ports can bypass UFW, so check the provider firewall and actual listeners as well as host rules. Install fail2ban and unattended security updates; schedule reboots outside demos and verify recovery afterward. Docker group membership grants root-equivalent access.

Install Docker Engine, Buildx and Compose using Docker's [Ubuntu apt repository instructions](https://docs.docker.com/engine/install/ubuntu/). Install Python 3 and `util-linux` (`flock`). Review Docker's [firewall behavior](https://docs.docker.com/engine/network/packet-filtering-firewalls/). Do not change SSH/firewall rules without a working recovery session.

Create root-owned `/srv/materyalph/{private,recovery,releases}` with mode 0700. Keep `/srv/materyalph/current` pointing to the accepted runtime directory. Never put private files in a release archive or Git. Keep provider and staging keys in private files/cloud fields, separate from development; use at least 32 random characters for generated secrets. No backend secrets go into portal build arguments or Buyer config.

`scripts/deployment/bootstrap-vps.sh` implements the fresh Ubuntu preparation. It installs official Docker packages, creates the protected `materyalph` administrator and enables unattended security updates without automatic reboot. Run its `secure-ssh` mode only after a separate `materyalph` key session succeeds. Root key access remains available for recovery; password and keyboard-interactive SSH are disabled. Provider firewall SSH source restrictions must be updated through hPanel/console if the administrator's public IP changes.

## 2. Private configuration and providers

Copy the public control and API/Reverb/backup `.env.example` files from `infrastructure/vps/` into `/srv/materyalph/private/`, each mode 0600. The control file contains absolute paths, the accepted commit, immutable image IDs, the four finalized hosts and VPS IPv4. Owner/app PostgreSQL passwords are separate files; the app password must match `DB_PASSWORD`. Keep the existing **staging** APP_KEY, Passport and Reverb identity consistent with Render; never reuse development keys. `APP_PREVIOUS_KEYS` must not carry the development key.

The API receives only its required adapters: existing private S3-compatible storage, Cloudinary, Bouncer, Brevo STARTTLS/587 (Hostinger blocks outbound 2525), Google OIDC/Maps/reCAPTCHA Enterprise, Xendit TEST and native Firebase. Reverb receives only its app identity and Redis settings. The restic repository uses separate scoped offsite credentials and a protected password file. Provisioning a new paid backup store requires a quote; the implementation does not silently buy one.

Update exact Google OAuth callback `https://VENDOR_HOST/api/v1/auth/google/callback`, reCAPTCHA hostnames, Maps browser referrers, Android package `ph.materyal.buyer` plus release certificate, TEST webhook `https://API_HOST/api/v1/webhooks/xendit`, and native Firebase identities using the existing adapter runbooks. Verify the webhook path against the current OpenAPI before provider registration. Keep the existing `materyalph://auth/callback` and payment deep links. Configure providers only after all four addresses are final.

On a trusted Node 24 workstation, use a local control-file copy whose private input paths point to the local protected copies (absolute Windows paths on Windows). Validate those exact inputs and DNS, then transfer the files unchanged by verified SSH and set the VPS control copy's paths to `/srv/materyalph/private/...`. The runtime does not require Node on Ubuntu:

```text
node scripts/deployment/vps-config.mjs validate PRIVATE_CONTROL_FILE
node scripts/deployment/vps-config.mjs duckdns PRIVATE_CONTROL_FILE
```

The updater reads a private DuckDNS token file, logs neither token nor provider payload, and updates only names already reserved in that account. A DuckDNS token is required only when invoking the updater; operator-reserved names that already resolve to the stable VPS address do not require exporting that account token. Re-run validation after updates. Do not schedule token-bearing URLs in shell history. Use host-only Secure/HttpOnly cookies, existing CSRF enforcement, exact portal allowlists and the authorized signed-file proxy. Never make private buckets public to fix image display.

After explicit approval to transfer the existing Render staging settings, `prepare-vps-environment.py NEW_PRIVATE_DIRECTORY_UNDER_TMP` prepares API/Reverb draft files from the confirmed staging service and its group. It generates new PostgreSQL/backup passwords, retains only the matching staging encryption/signing identities, does not copy Render's database connection, and changes nothing on Render. Supply PyYAML through the local protected tooling environment. The helper removes inherited Windows directory access before writing any values and grants the current operator and SYSTEM; retain only trusted operating-system administrative access in addition. Review its names-only readiness report, finish the fresh import boundaries and separate offsite credentials, then transfer protected files by verified SSH. Compose reads these secret-bearing files in raw mode, so dollar characters are not interpolated. No draft file is an accepted live configuration until validation succeeds.

## 3. Build an accepted release off the VPS

Commit/review the implementation through the normal workflow. Run `quality gates` manually on the exact **staging** commit; all affected domains run on that branch. Do not treat local checks or a successful aggregate on an unrelated commit as release approval.

On a Docker/Python workstation with Trivy installed, set the three **public** environment build inputs `VENDOR_RECAPTCHA_SITE_KEY`, `ADMIN_RECAPTCHA_SITE_KEY`, `GOOGLE_MAPS_BROWSER_KEY`. For a private repository, supply a scoped `GITHUB_TOKEN` through the local environment, never a command argument.

```text
python scripts/deployment/package-vps.py OWNER/REPO ACCEPTED_40_CHAR_SHA NEW_OUTPUT_DIRECTORY
```

This exports that commit, checks a successful full manually triggered CI run, builds Linux amd64 images, tests those exact runtime images and scans both with Trivy, then saves `api.tar`, `edge.tar`, `runtime.tar`, `release.json`. Uncommitted work and private environment files do not enter the archive. Copy those files over verified SSH. Compare all archive SHA-256 values in `release.json` on both hosts, extract the runtime into a new release directory, `docker load` both images, then set immutable image IDs and the same commit in the private control file. Keep the previous release/images for recovery. Never build portal assets or PHP images on the KVM 2.

The API and edge builds use `--no-cache-filter api-runtime` and `--no-cache-filter edge-runtime` so Alpine security upgrades run again even when the base tags have not changed; `--pull` alone does not refresh cached `RUN` layers. The API's final runtime stage upgrades packages after the cached PHP/application build and requires Python >=3.14.10-r0 for [CVE-2026-115557](https://www.python.org/downloads/release/python-31410/); Supervisor depends on Python. The edge runtime requires curl/libcurl >=8.23.0-r0 for CVE-2026-92392. Keep the HIGH/CRITICAL Trivy gate enabled. After an image-security fix, commit and push it to `staging` before rerunning the release command: packaging exports the selected commit, so an uncommitted Dockerfile edit cannot repair that release. A package that failed Trivy cannot be resumed with `-ReleaseDirectory`.

The edge image rebuilds standard Caddy 2.11.7 with Go 1.27.3 and `golang.org/x/net` 0.62.0. The latter fixes the HTML parser/renderer findings published on 27 October: [CVE-2026-78661](https://pkg.go.dev/vuln/GO-2026-6860) and [CVE-2026-97045](https://pkg.go.dev/vuln/GO-2026-6866), which affect the previously pinned 0.60.0. It also pins go-jose/v4 to 4.1.6 and applies a tested [RSA validation backport to go-jose/v3](../../infrastructure/docker/patches/README.md) for [CVE-2026-116587](https://github.com/go-jose/go-jose/security/advisories/GHSA-mgcc-cww5-fp2q). Upstream has no patched v3 release; Smallstep still requires v3, so updating v4 alone does not fix both findings. The local v3 replacement's patch status is established by its source patch and mandatory regression tests, rather than an upstream version number. Alpine package upgrades cannot update dependencies compiled into `/usr/bin/caddy`; the binary must be rebuilt. It uses the official builder and the documented [xcaddy dependency replacement](https://github.com/caddyserver/xcaddy#custom-builds); no extra plugins are added. Go's [release history](https://go.dev/doc/devel/release#go1.27.3) records the toolchain's security fixes. Keep scans on both API and edge images in CI and on the exact release package; do not ignore findings to complete a demo.

## 4. Fresh local data export

Use current local PostgreSQL 16 and matching current files, not an old `.tmp` dump. Review migrations and encrypted-column coverage first. Quiesce all development writers (API, horizon/worker, scheduler, Reverb, CLI tasks and browser actions); keep PostgreSQL and MinIO/storage running. The exporter refuses known running writers and does not stop or mutate the source itself. Keep it quiescent until verification finishes.

Create a protected **local file containing the target staging APP_KEY**. The source development key never leaves its local process. Run with Docker on PATH:

```text
python scripts/deployment/export-vps-source.py PRIVATE_STAGING_KEY_FILE .tmp/vps-source-YYYYMMDDHHMMSS
```

On Windows, place the export beneath an already protected NTFS directory; POSIX mode 0700 alone does not restrict inherited Windows ACLs. Record running writer container IDs before stopping them. Resume those exact containers with `docker start CONTAINER_IDS`; `docker compose start` can start the setup dependency and rerun its migration/seeding command. Do not rerun setup as part of a read-only source export.

The private bundle contains a custom PostgreSQL dump, target-key recovery registry entries, content-addressed objects and a checksummed manifest. Cloudinary provider identities are inventoried and retained in their existing account. Unknown encrypted columns, existing unreviewed source recovery registries, missing referenced files, mismatched checksums and wrong keys fail closed. Review these rather than bypassing the check. Transfer the private bundle over SSH to the VPS recovery directory; encrypt it offsite, then remove local working copies according to the project's data handling policy. The bundle contains personal data even though development keys are excluded.

## 5. Initialize, restore, deploy fenced

Run as the protected deployment administrator from the accepted runtime. Substitute the actual private control path below:

```bash
bash scripts/deployment/vpsctl.sh initialize /srv/materyalph/private/control.env
bash scripts/deployment/vpsctl.sh restore-new /srv/materyalph/private/control.env /srv/materyalph/recovery/SELECTED_BUNDLE materyalph_restore_YYYYMMDDHHMMSS
bash scripts/deployment/vpsctl.sh backup /srv/materyalph/private/control.env
bash scripts/deployment/vpsctl.sh deploy /srv/materyalph/private/control.env /srv/materyalph/releases/RELEASE/release.json
```

`initialize` creates the private stores and initializes the encrypted offsite repository once; it is not a recurring command. A restore creates a **new** database, retains the previous database, checks archive/object hashes and counts, recovers encrypted-history reads, refuses conflicting object bytes and enforces the Render sizing gate. It selects the restored database only after verification. No local source data is overwritten. Migration release is additive, with HTTP/jobs fenced. A verified offsite backup from the last 15 minutes is required before deployment.

Inspect actual extension versions (`postgis`, `pg_trgm`, `pgcrypto`), `php artisan migrate:status`, table counts, `pg_database_size`, registry reads and private file authorization. Run release commands through the dedicated Compose `release` service; HTTP never starts duplicate workers or a scheduler. `/up` stays available during fencing; application routes return 503.

Before rehearsal, record the first four checks in a private copy of `acceptance.example.json`: other environment fenced, database/files verified, imported effects reviewed, TEST provider ownership reviewed. Include exact commit, reviewer and UTC time. Review old outbox events, queued jobs, invites/OTP/session validity, webhook replay records, payment IDs and overdue commerce timers. Timestamp boundaries prevent historical mail/outbox replay; they do not decide whether existing domain timers should advance. Do not clear history or replay operations automatically.

```bash
bash scripts/deployment/vpsctl.sh rehearse /srv/materyalph/private/control.env PRIVATE_REVIEW_JSON
```

This opens the controlled staging rehearsal and starts one worker and one scheduler. Keep Render fenced throughout. Complete user-led acceptance and only then mark the remaining checks true and run `activate` with the completed evidence. Rehearsal is already a writer and must be fenced before any recovery drill.

## 6. Signed Buyer APKs

Copy `config/hostinger.example.json`, `config/staging.example.json` and `config/deployments.example.json` to their ignored counterparts. Finalize both exact API addresses in the registry and set `addressesFinalized=true` only after provider setup. The build validates each profile against the registry and accepts public configuration names only.

Create or retain one protected release keystore using the [Flutter Android signing procedure](https://docs.flutter.dev/deployment/android). Keep the same identity for both deployments and future updates, encrypted in recovery custody outside Git. Copy `android/key.example.properties` to ignored `android/key.properties`; it names environment variables for passwords, not literal passwords. Supply them via protected local/CI secret handling. Configure the ignored native Firebase file and Maps client key. Verify package, Firebase app/project and release signing certificate restrictions before distribution.

The release script checks for `apksigner` before building. It first uses `sdk.dir` in `android/local.properties`, then valid `ANDROID_HOME`, `ANDROID_SDK_ROOT` and the default Windows SDK location, selecting the newest installed stable Build-Tools version with `apksigner.bat`. An obsolete environment path does not override the project's working SDK. Signature verification must succeed before a delivery folder is created. An existing delivery version is rejected before rebuilding; choose the next build number.

```powershell
./scripts/deployment/build-buyer-staging.ps1 -Deployment Hostinger -Release -BuildName 1.0.0 -BuildNumber NEXT_NUMBER
./scripts/deployment/build-buyer-staging.ps1 -Deployment Render -Release -BuildName 1.0.0 -BuildNumber NEXT_LARGER_NUMBER
```

Build numbers must increase for Android update installation, including switching back from Render. The app package is the same; installing the alternate APK updates the app and requires a fresh sign-in where sessions differ. Debug-signed installs may require uninstalling before the first release-signed install; preserve needed device data first. Do not silently change application ID or deep links. `apksigner verify` is mandatory. Deliver both APKs and `.tmp/apk-delivery/{Hostinger,Render}/VERSION-BUILD/release.json` (SHA-256, version/build, endpoint, certificate). Use `adb install -r APK` or user-led installation from a trusted download, compare checksums, and test on a physical phone. No working release APK is claimed before these inputs and build verification exist.

## 7. Backups, monitoring and load acceptance

Install the supplied `materyalph-backup.service` and `.timer` under `/etc/systemd/system/` after reviewing paths. Enable the timer with `systemctl enable --now materyalph-backup.timer`. It runs around **02:10 Philippine time**, with a persistent catch-up after reboot. Check `systemctl list-timers` and the service exit status. Take an extra `vpsctl.sh backup` immediately before every demo/release.

Backups briefly fence and stop all writers for a consistent database/files snapshot. Only previously running services are restarted; a fenced environment stays fenced. Restic writes encrypted offsite sets, checks metadata plus a rotating data subset, retains seven daily/four weekly sets grouped by stable host/tag, prunes and checks again. Failed working sets remain private; `last-success` advances only after success. Keep the restic password and staging keys in separate protected recovery custody; an encrypted backup without its recovery keys is unusable. Use `fetch SNAPSHOT_ID` to retrieve an explicit set; verify it before restoring.

Recovery export uses each chat attachment's recorded disk, including the private `local`/`public` S3 aliases for imported files. Changing the default upload disk does not move those objects. If a release fails with `REFERENCED_OBJECT_MISSING`, verify the recorded disk and checksum before treating the object as lost; do not delete the reference or bypass the backup. Ship a recovery-helper fix in a new accepted commit and rerun the routine release command. Packaging exports the selected commit, so an uncommitted workstation fix is not included in its images.

Run `bash scripts/deployment/observe-vps.sh PRIVATE_CONTROL` before/during/after load and after reboot. Record CPU, RAM, API error rate, queue delay/backlog and scheduled-task outcomes from Admin operations. Record Hostinger dashboard CPU credits/throttling as actually presented; no unsupported numeric credit assumptions. Alert when the backup is older than 24 hours, jobs stop, errors rise or resources exhaust. Restore timing and private-file checks must be part of a drill, not inferred from successful upload.

For load, create synthetic accounts/data under the existing workflows. The user handles authentication. Create an ignored mode-0600 scenario based on `load.example.json` with **20 actors**, e.g. 12 Buyers, six Vendors, two Admins, using private local tokens/cookies. Never paste them in chat. Select database-backed GET paths with required parameters and authorized fixture records. Provider maps/routes, uploads and write journeys are separate acceptance.

```text
node scripts/deployment/load-vps.mjs PRIVATE_SCENARIO NEW_REPORT_JSON 300
```

Require no failed reads and per-operation p95 <= 2000 ms with at least 20 samples per group. Validate the scenario first at low traffic. Capture metrics during realistic user-led messaging/TEST checkout/fulfillment activity too; the read-load tool alone does not prove all cross-client workflows. Investigate failures without automatically purchasing a larger plan.

## 8. Render fallback drill and promotion

Use the existing [Render runbook](render-staging.md) and exact accepted commit for API, Reverb and both portals; keep auto-deploy off. Stage the new runtime before migration/cutover. At primary promotion set Render API `DEPLOYMENT_STANDBY=true`, `RUN_QUEUE=false`, `RUN_SCHEDULER=false`, and deploy that exact accepted commit. Standby blocks application HTTP, job processes and release migrations while preserving `/up`. Verify both portal API paths and direct API return 503. No automatic fallback is configured.

Time a full drill before release:

1. Fence Hostinger with `vpsctl.sh fence`. Stop any external CLI writers and verify no second environment can mutate state. Select a checksummed offsite set no older than 24 hours; record its timestamp and release.
2. Preserve the **current Render database and its matching private files** in a separate encrypted recovery set before replacing anything. Run the deployment recovery helper with the protected Render staging environment from a trusted recovery workstation. Keep Render's staging keys outside the archive. Verify that preservation before touching its database.
3. Inspect the selected archive with PostgreSQL 16 `pg_restore --list`; check all required extensions and compare full database size with the 1 GB limit. Prepare an extension-preserving restore list for Render's managed extensions. Use explicit target `PGHOST`, `PGDATABASE`, `PGUSER`, `PGSSLMODE=require` and a protected `PGPASSFILE`; never put a URL/password in the command line. Restore only the named Render staging target using PostgreSQL 16 `pg_restore --use-list REVIEWED_LIST --clean --if-exists --no-owner --no-acl --single-transaction --exit-on-error`. This is the reviewed replacement step; preserve the old set first. Do not drop the managed database or trim commercial/audit rows. If the target cannot fit, stop promotion and obtain a new hosting decision.
4. With a protected Render staging environment (matching staging APP_KEY, private S3 aliases, TEST adapters), run `php scripts/deployment/vps-transfer.php verify SELECTED_BUNDLE`, then `restore SELECTED_BUNDLE`. Verify exact table counts, extensions, migration status, encrypted history, private object hashes and signed reads. Restore refuses object collisions. Review TEST associations and import mail/outbox boundaries. Use a separate private bucket/prefix if existing Render objects conflict; do not overwrite unmatched versions.
5. Activate Render only after Hostinger is confirmed fenced. Set `DEPLOYMENT_STANDBY=false`, enable its intended supervised queue/scheduler and deploy the accepted API; verify providers and Reverb. Distribute the Render portal links and signed backup APK. Render Free may sleep; measure recovery and request delay rather than promise zero delay.
6. Record actual RPO <=24h and time to a working three-role system <=60m. Record failures as failed gates. Before returning, fence Render, export its **newer** database/files, preserve Hostinger data, restore to a new Hostinger database, review and promote only one writer. Never just reactivate an older Hostinger snapshot.

The selected fallback window ends **17 November 2026**; the supplied Render database expiry is **18 November 2026 at 22:52 Philippine time**. Verify the dashboard before the drill. No fallback coverage after that window is assumed. Render promotion deliberately remains a reviewed operation because managed extension ownership and the live target dataset must be inspected; the VPS restore script does not point at or overwrite Render.

## 8a. Routine release of a new staging commit

After the first deployment, release a pushed `staging` commit from the operator workstation with one command:

```powershell
./scripts/deployment/release-hostinger.ps1            # latest origin/staging
./scripts/deployment/release-hostinger.ps1 -Commit SHA
./scripts/deployment/release-hostinger.ps1 -ReleaseDirectory 'D:\materyalph-releases\COMMIT-TIMESTAMP'
```

It starts and waits for the manual `quality gates` run when none exists, packages with `package-vps.py`, uploads and verifies checksums, then on the VPS loads the images, installs the runtime (resetting the Windows archive's file modes), updates `control.env`, takes the required backup and deploys fenced in a detached session (log: `~/release-SHORT.log`). It reopens staging only after the operator types `REOPEN` to confirm the four rehearsal checks for that commit. The workstation's public IP must be allowed for TCP 22.

SSH authentication and pinned-host verification run before any CI wait or package build. SSH preflight, upload-directory preparation and SCP each retry up to three times. A failed directory-preparation command blocks SCP; failed uploads block installation and retain the local release directory. A timeout or `banner exchange` failure means SSH did not establish a usable connection: verify the workstation's current public IPv4, the Hostinger TCP 22 allowlist and VPN/network access before retrying. Keep strict host verification enabled.

After packaging succeeds, `-ReleaseDirectory` resumes that exact package instead of selecting the latest staging head or rebuilding images. It verifies the manifest's repository/commit, immutable image IDs, passed runtime/Trivy evidence and all three local archive hashes, then rechecks a successful manual `ci.yml` run on the same staging commit. It does not require portal build inputs or local Docker/Trivy for this resume path. Remote hashes, backup, fenced deployment and interactive rehearsal approval still apply. If SSH drops while starting the detached installation, inspect `~/release-SHORT.log` before retrying because the remote job may already be running.

## 9. Release evidence

Record required API/portal/Flutter/contract/infrastructure/secret checks, accepted commit/image hashes, quote approval, DNS/TLS, portal refresh/deep links, cookie/CSRF, private authorization/scanning, provider failures, user-led three-role journeys, device APK install, 20-user results, reboot recovery and timed restore drill in [the verification record](../test-plans/hostinger-vps-verification.md). Passing local static checks does not satisfy the live gates.
