<#
.SYNOPSIS
  Release one staging commit to the Hostinger VPS from this Windows workstation.

.DESCRIPTION
  1. Ensures a successful MANUAL "quality gates" run exists for the exact commit (starts one and waits if needed).
  2. Packages it with package-vps.py (Linux images, runtime tests, Trivy).
  3. Uploads the archives over SSH and verifies their SHA-256 against release.json.
  4. On the VPS: loads images, installs the runtime, updates control.env, takes the
     required offsite backup and deploys fenced (detached from SSH, logged).
  5. Asks YOU to confirm the four rehearsal checks, then reopens staging.

  Requirements: git push access (credential manager), Docker Desktop, Python 3, Trivy,
  the ignored portal .env files and .tmp/hostinger-deployment/access/{id_ed25519.operator,known_hosts}.
  Your public IP must be allowed for TCP 22 in the Hostinger firewall.

.EXAMPLE
  ./scripts/deployment/release-hostinger.ps1                 # latest origin/staging
  ./scripts/deployment/release-hostinger.ps1 -Commit 3f3020f2ffa1244b1a3d596a239e3b93a591e58e
#>
[CmdletBinding()]
param(
    [string] $Commit,
    [string] $Repository = 'Capstone2026Team/MateryalPH-Capstone-Project',
    [string] $VpsAddress = '187.77.142.129',
    [string] $OutputRoot = $(if (Test-Path 'D:\') { 'D:\materyalph-releases' } else { '' })
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
# ssh -o splits option values on spaces, so work from the repo with relative paths.
Set-Location -LiteralPath $repoRoot
$access = '.tmp/hostinger-deployment/access'
foreach ($required in "$access/id_ed25519.operator", "$access/known_hosts", 'apps/vendor-web/.env', 'apps/admin-web/.env') {
    if (-not (Test-Path -LiteralPath $required)) { throw "Missing $required" }
}
$sshOptions = @('-i', "$access/id_ed25519.operator", '-o', "UserKnownHostsFile=$access/known_hosts", '-o', 'StrictHostKeyChecking=yes', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=30', '-o', 'ServerAliveInterval=30')
$remoteHost = "materyalph@$VpsAddress"

function Write-Step([string] $message) { Write-Host "`n==> $message" -ForegroundColor Cyan }

function Invoke-RemoteScript([string] $script) {
    # PowerShell pipes add CRLF and 'docker compose run' eats piped stdin: send base64, run from a temp file.
    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($script -replace "`r", '')))
    ssh @sshOptions $remoteHost "f=`$(mktemp); echo $encoded | base64 -d > `$f; bash `$f; status=`$?; rm -f `$f; exit `$status"
    if ($LASTEXITCODE -ne 0) { throw "Remote step failed (exit $LASTEXITCODE)." }
}

function Get-GitHubToken {
    $credential = "protocol=https`nhost=github.com`n`n" | git credential fill 2>$null
    $token = ($credential | Where-Object { $_ -like 'password=*' }) -replace '^password=', ''
    if (-not $token) { throw 'No stored GitHub credential. Push once from this machine so Git Credential Manager stores it.' }
    return $token
}

function Get-PortalValue([string] $file, [string] $name) {
    foreach ($line in Get-Content -LiteralPath $file) { if ($line -match "^\s*$name\s*=\s*(.*)$") { return $matches[1].Trim().Trim('"') } }
    throw "Missing $name in $file"
}

# ---- 1. Exact commit and manual CI evidence -------------------------------------------------
Write-Step 'Resolving the staging commit'
git fetch origin staging --quiet
if (-not $Commit) { $Commit = (git rev-parse origin/staging).Trim() }
$Commit = (git rev-parse $Commit).Trim()
if ($Commit -notmatch '^[a-f0-9]{40}$') { throw 'Could not resolve a full commit SHA.' }
$short = $Commit.Substring(0, 8)
Write-Host "Commit $Commit"

$token = Get-GitHubToken
$headers = @{ Authorization = "Bearer $token"; Accept = 'application/vnd.github+json'; 'X-GitHub-Api-Version' = '2022-11-28' }
function Get-ManualRun { (Invoke-RestMethod -Headers $headers "https://api.github.com/repos/$Repository/actions/runs?head_sha=$Commit&event=workflow_dispatch&per_page=10").workflow_runs | Select-Object -First 1 }

Write-Step 'Checking for a successful manual quality-gates run'
$run = Get-ManualRun
if (-not $run -or ($run.status -eq 'completed' -and $run.conclusion -ne 'success')) {
    if ((git rev-parse origin/staging).Trim() -ne $Commit) { throw 'A manual run can only start on the current origin/staging head. Push the commit to staging first.' }
    Write-Host 'Starting a manual quality-gates run on staging...'
    Invoke-RestMethod -Method Post -Headers $headers -ContentType 'application/json' -Body '{"ref":"staging"}' "https://api.github.com/repos/$Repository/actions/workflows/ci.yml/dispatches" | Out-Null
    Start-Sleep -Seconds 20
}
do {
    $run = Get-ManualRun
    if ($run) { Write-Host ("  run #{0}: {1} {2}" -f $run.run_number, $run.status, $run.conclusion) }
    if (-not $run -or $run.status -ne 'completed') { Start-Sleep -Seconds 60 }
} while (-not $run -or $run.status -ne 'completed')
if ($run.conclusion -ne 'success') { throw "Manual run #$($run.run_number) finished '$($run.conclusion)'. Fix CI first: $($run.html_url)" }

# ---- 2. Package -----------------------------------------------------------------------------
Write-Step 'Packaging the release (Docker build, runtime tests, Trivy)'
$env:VENDOR_RECAPTCHA_SITE_KEY = Get-PortalValue 'apps/vendor-web/.env' 'VITE_RECAPTCHA_SITE_KEY'
$env:ADMIN_RECAPTCHA_SITE_KEY = Get-PortalValue 'apps/admin-web/.env' 'VITE_RECAPTCHA_SITE_KEY'
$env:GOOGLE_MAPS_BROWSER_KEY = Get-PortalValue 'apps/vendor-web/.env' 'VITE_GOOGLE_MAPS_BROWSER_KEY'
$env:GITHUB_TOKEN = $token
if (Test-Path 'D:\materyalph-tools\trivy-0.75.0\trivy.exe') { $env:PATH = "D:\materyalph-tools\trivy-0.75.0;$env:PATH" }
if (-not (Get-Command trivy -ErrorAction SilentlyContinue)) { throw 'Trivy is not on PATH.' }
if ($OutputRoot) { New-Item -ItemType Directory -Force $OutputRoot | Out-Null; $env:TEMP = Join-Path $OutputRoot 'tmp'; $env:TMP = $env:TEMP; New-Item -ItemType Directory -Force $env:TEMP | Out-Null }
$releaseRoot = if ($OutputRoot) { $OutputRoot } else { Join-Path $repoRoot '.tmp/releases' }
$release = Join-Path $releaseRoot "$short-$([DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))"
try {
    python scripts/deployment/package-vps.py $Repository $Commit $release
    if ($LASTEXITCODE -ne 0) { throw 'Packaging failed (see output above). A Trivy HIGH/CRITICAL finding must be fixed, not ignored.' }
} finally { Remove-Item Env:GITHUB_TOKEN -ErrorAction SilentlyContinue }
$manifest = Get-Content -LiteralPath (Join-Path $release 'release.json') -Raw | ConvertFrom-Json

# ---- 3. Upload and verify -------------------------------------------------------------------
Write-Step 'Uploading the release to the VPS'
$stage = "release-$short"
ssh @sshOptions $remoteHost "rm -rf ~/$stage && mkdir -p ~/$stage"
scp @sshOptions -C (Join-Path $release 'api.tar') (Join-Path $release 'edge.tar') (Join-Path $release 'runtime.tar') (Join-Path $release 'release.json') "${remoteHost}:$stage/"
if ($LASTEXITCODE -ne 0) { throw 'Upload failed.' }
Invoke-RemoteScript @"
cd ~/$stage && python3 -c "import json,hashlib,sys; r=json.load(open('release.json')); bad=[n for n,h in r['archives'].items() if hashlib.sha256(open(n,'rb').read()).hexdigest()!=h]; print('checksums', 'OK' if not bad else 'MISMATCH '+str(bad)); sys.exit(1 if bad else 0)"
"@

# ---- 4. Install, back up, deploy fenced (detached) -------------------------------------------
Write-Step 'Installing, backing up and deploying on the VPS (takes several minutes)'
$chain = @'
#!/bin/bash
set -uo pipefail
cd /tmp
c=__COMMIT__; src=$HOME/__STAGE__; r=/srv/materyalph/releases/$c
fail() { echo "CHAIN-FAILED: $1"; exit 1; }
sudo -n docker load -q -i $src/api.tar </dev/null || fail 'load api image'
sudo -n docker load -q -i $src/edge.tar </dev/null || fail 'load edge image'
sudo -n mkdir -p "$r" && sudo -n rm -rf "$r/runtime" && sudo -n tar -xf $src/runtime.tar -C "$r" || fail 'extract runtime'
# Archives built on Windows carry 666/777 modes: restore safe ownership and modes.
sudo -n chown -R root:root "$r/runtime"
sudo -n find "$r/runtime" -type d -exec chmod 755 {} +
sudo -n find "$r/runtime" -type f -exec chmod 644 {} +
sudo -n chmod 700 "$r/runtime/scripts/deployment/vpsctl.sh"
sudo -n chmod 755 "$r/runtime/infrastructure/vps/init-database.sh"
sudo -n cp $src/release.json $src/api.tar $src/edge.tar $src/runtime.tar "$r/"
sudo -n sh -c "chmod 600 '$r/release.json' '$r'/*.tar"
api=__API__; edge=__EDGE__
sudo -n sed -i "s|^VPS_DEPLOY_COMMIT=.*|VPS_DEPLOY_COMMIT=$c|; s|^VPS_API_IMAGE=.*|VPS_API_IMAGE=$api|; s|^VPS_EDGE_IMAGE=.*|VPS_EDGE_IMAGE=$edge|" /srv/materyalph/private/control.env
sudo -n ln -sfn "$r/runtime" /srv/materyalph/current
echo '== backup'
sudo -n bash /srv/materyalph/current/scripts/deployment/vpsctl.sh backup /srv/materyalph/private/control.env </dev/null 2>&1 | grep -vE 'Creating|Created|Tini|Zombie|To fix|Starting|Started|Running|Waiting|Healthy|Stopping|Stopped'
[ "${PIPESTATUS[0]}" = 0 ] || fail 'backup'
sleep 3
echo '== deploy'
sudo -n bash /srv/materyalph/current/scripts/deployment/vpsctl.sh deploy /srv/materyalph/private/control.env "$r/release.json" </dev/null 2>&1 | grep -vE 'Creating|Created|Tini|Zombie|To fix|Starting|Started|Waiting|Healthy|Stopping|Stopped|Pulling|Running'
[ "${PIPESTATUS[0]}" = 0 ] || fail 'deploy'
sudo -n docker ps --format '{{.Names}} {{.Status}}'
echo CHAIN-DONE
'@
$chain = $chain.Replace('__COMMIT__', $Commit).Replace('__STAGE__', $stage).Replace('__API__', $manifest.images.api).Replace('__EDGE__', $manifest.images.edge)
$chainEncoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($chain -replace "`r", '')))
ssh @sshOptions $remoteHost "echo $chainEncoded | base64 -d > ~/$stage.sh; rm -f ~/$stage.log; setsid nohup bash ~/$stage.sh > ~/$stage.log 2>&1 < /dev/null & echo started"
$printed = 0
do {
    Start-Sleep -Seconds 20
    $log = @(ssh @sshOptions $remoteHost "cat ~/$stage.log 2>/dev/null" 2>$null)
    if ($log.Count -gt $printed) { $log[$printed..($log.Count - 1)] | ForEach-Object { Write-Host "  $_" }; $printed = $log.Count }
} until ($log -match '^CHAIN-(DONE|FAILED)')
if ($log -match '^CHAIN-FAILED') { throw "VPS step failed. Full log on the server: ~/$stage.log" }

# ---- 5. Reopen staging (your attestation) -----------------------------------------------------
Write-Step 'Release deployed FENCED (API answers 503 until reopened)'
Write-Host 'Reopening records YOU as reviewer for these checks on this commit:'
Write-Host '  1. No other environment (e.g. Render) writes to this deployment''s data or providers.'
Write-Host '  2. Database and files verified (backup/export succeeded above).'
Write-Host '  3. Imported side effects reviewed (outbox, queued jobs, timers).'
Write-Host '  4. TEST provider settings (Xendit TEST, Google, reCAPTCHA, Maps) are owned and correct.'
$answer = Read-Host 'Type REOPEN to confirm and open staging, or anything else to leave it fenced'
if ($answer -cne 'REOPEN') { Write-Host "Left fenced. Reopen later by rerunning rehearse with a review file for commit $Commit."; return }
$reviewer = (git config user.name).Trim()
$review = [ordered]@{ commit = $Commit; reviewer = $reviewer; reviewed_at = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
    other_environment_fenced = $true; database_and_files_verified = $true; imported_side_effects_reviewed = $true; test_provider_ownership_verified = $true
    notes = "Confirmed interactively by $reviewer via release-hostinger.ps1; CI run $($run.html_url)" } | ConvertTo-Json
$reviewEncoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($review))
Invoke-RemoteScript @"
set -euo pipefail
cd /tmp
f=/srv/materyalph/private/rehearsal-review-$short.json
echo $reviewEncoded | base64 -d | sudo -n install -m 600 -o root -g root /dev/stdin "`$f"
sudo -n bash /srv/materyalph/current/scripts/deployment/vpsctl.sh rehearse /srv/materyalph/private/control.env "`$f" </dev/null 2>&1 | grep -vE 'Creating|Created|Tini|Zombie|To fix|Starting|Started|Waiting|Healthy|Running'
rm -rf ~/$stage ~/$stage.sh
"@

Write-Step 'Smoke test'
foreach ($url in 'https://materyalph26-api.duckdns.org/up', 'https://materyalph26-api.duckdns.org/api/v1/auth/csrf', 'https://materyalph26-vendor.duckdns.org/', 'https://materyalph26-admin.duckdns.org/') {
    $response = Invoke-WebRequest $url -TimeoutSec 60 -SkipHttpErrorCheck
    Write-Host ("  {0}  {1}" -f $response.StatusCode, $url)
}
Write-Host "`nReleased $Commit. Local release files: $release" -ForegroundColor Green
