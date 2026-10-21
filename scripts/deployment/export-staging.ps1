[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$docker = (Get-Command docker -ErrorAction Stop).Source
$batchName = 'staging-import-' + [guid]::NewGuid().ToString('N')
$batchDirectory = Join-Path $taskRoot ".tmp/$batchName"
New-Item -ItemType Directory -Path $batchDirectory -Force | Out-Null
$keyPath = Join-Path $batchDirectory 'staging-app-key.txt'
$keyBytes = [System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32)
[IO.File]::WriteAllText($keyPath, 'base64:' + [Convert]::ToBase64String($keyBytes))
$containerDirectory = "/workspace/.tmp/$batchName"
$process = $null
Push-Location $taskRoot
try {
    # Start an exporter holding a read-only PostgreSQL snapshot, without displaying private artifacts.
    $process = Start-Process -FilePath $docker -ArgumentList @('compose', 'exec', '-T', 'api', 'php', '/workspace/scripts/deployment/staging-transfer.php', 'export', $containerDirectory, "$containerDirectory/staging-app-key.txt") -WorkingDirectory $taskRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $batchDirectory 'export.log') -RedirectStandardError (Join-Path $batchDirectory 'export-error.log')
    $deadline = [DateTime]::UtcNow.AddMinutes(20)
    while (-not (Test-Path -LiteralPath (Join-Path $batchDirectory 'ready.json'))) {
        if ($process.HasExited -or [DateTime]::UtcNow -gt $deadline) { throw 'Source export failed or timed out. Protected artifacts are retained for inspection.' }
        Start-Sleep -Milliseconds 500
    }
    $ready = Get-Content (Join-Path $batchDirectory 'ready.json') -Raw | ConvertFrom-Json
    if ($ready.snapshot -notmatch '^[0-9A-Fa-f-]+$') { throw 'Invalid exported snapshot identifier.' }
    # All source queries and pg_dump share this one snapshot. No source record is modified.
    $dumpCommand = 'exec pg_dump --format=custom --no-owner --no-privileges --exclude-table-data=public.imported_encrypted_values --snapshot=' + $ready.snapshot + ' --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" --file=/tmp/' + $batchName + '.dump'
    & $docker compose exec -T postgres sh -c $dumpCommand
    if ($LASTEXITCODE -ne 0) { throw 'PostgreSQL 16 snapshot dump failed.' }
    & $docker compose cp "postgres:/tmp/$batchName.dump" (Join-Path $batchDirectory 'database.dump')
    if ($LASTEXITCODE -ne 0) { throw 'Snapshot archive copy failed.' }
    & $docker compose exec -T postgres rm "/tmp/$batchName.dump"
    if ($LASTEXITCODE -ne 0) { throw 'Temporary source-container archive cleanup failed.' }
    New-Item -ItemType File -Path (Join-Path $batchDirectory 'release-snapshot') | Out-Null
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { throw 'Snapshot exporter did not complete successfully.' }
    $checksums = @{}
    foreach ($name in @('database.dump', 'ready.json', 'recovery.jsonl', 'files.json', 'counts.json')) {
        $checksums[$name] = (Get-FileHash -LiteralPath (Join-Path $batchDirectory $name) -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    [IO.File]::WriteAllText((Join-Path $batchDirectory 'checksums.json'), ($checksums | ConvertTo-Json))
    Write-Output "Verified snapshot artifacts prepared in .tmp/$batchName. Keep this directory private."
} finally {
    if ($process -and -not $process.HasExited) {
        New-Item -ItemType File -Path (Join-Path $batchDirectory 'release-snapshot') -Force | Out-Null
        $process.WaitForExit(10000) | Out-Null
    }
    Pop-Location
}
