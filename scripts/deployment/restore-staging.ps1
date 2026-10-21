[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $BatchDirectory,
    [Parameter(Mandatory)] [string] $TargetEnvFile,
    [Parameter(Mandatory)] [string] $ExpectedHost,
    [Parameter(Mandatory)] [string] $ExpectedDatabase
)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$allowedRoot = [IO.Path]::GetFullPath((Join-Path $taskRoot '.tmp')) + [IO.Path]::DirectorySeparatorChar
$batch = (Resolve-Path -LiteralPath $BatchDirectory).Path
$settings = (Resolve-Path -LiteralPath $TargetEnvFile).Path
if (-not $batch.StartsWith($allowedRoot, [StringComparison]::OrdinalIgnoreCase) -or -not $settings.StartsWith($allowedRoot, [StringComparison]::OrdinalIgnoreCase)) { throw 'Keep private import artifacts and destination credentials inside ignored .tmp.' }
if ($ExpectedDatabase -ne 'materyalph_staging' -or $ExpectedHost -notmatch '^[a-zA-Z0-9.-]+$') { throw 'Name the new Railway staging target explicitly.' }
$variables = @{}
foreach ($line in Get-Content -LiteralPath $settings) {
    if ($line -match '^([A-Z_]+)=(.*)$') { $variables[$matches[1]] = $matches[2] }
}
if ($variables.PGHOST -ne $ExpectedHost -or $variables.PGDATABASE -ne $ExpectedDatabase -or $variables.PGSSLMODE -ne 'verify-full' -or $variables.PGSSLROOTCERT -ne '/backup/postgres-ca.crt' -or -not (Test-Path -LiteralPath (Join-Path $batch 'postgres-ca.crt')) -or -not $variables.PGPASSWORD -or -not $variables.PGUSER) { throw 'Destination settings must match the explicit target and verify its pinned TLS certificate.' }
$checksums = Get-Content (Join-Path $batch 'checksums.json') -Raw | ConvertFrom-Json
foreach ($name in @('database.dump', 'ready.json', 'recovery.jsonl', 'files.json', 'counts.json')) {
    if ((Get-FileHash -LiteralPath (Join-Path $batch $name) -Algorithm SHA256).Hash.ToLowerInvariant() -ne $checksums.$name) { throw 'Import artifact checksum validation failed.' }
}
$docker = (Get-Command docker -ErrorAction Stop).Source
# The client reads PG* credentials from the ignored file; no URL/password enters argv.
$arguments = @('run', '--rm', '--env-file', $settings, '--mount', "type=bind,source=$batch,target=/backup,readonly", 'postgis/postgis:16-3.5')
$check = 'SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname=''public'' AND c.relkind IN (''r'',''p'',''v'',''m'',''S'') AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.classid=''pg_class''::regclass AND d.objid=c.oid AND d.deptype=''e'')'
$count = & $docker @arguments psql --no-psqlrc --tuples-only --no-align --set=ON_ERROR_STOP=1 --command $check
if ($LASTEXITCODE -ne 0 -or "$count".Trim() -ne '0') { throw 'Destination contains unexpected objects or could not be verified. Restore aborted.' }
& $docker @arguments pg_restore --list /backup/database.dump *> $null
if ($LASTEXITCODE -ne 0) { throw 'Archive validation failed.' }
& $docker @arguments pg_restore --no-owner --no-privileges --no-comments --single-transaction --exit-on-error --dbname $ExpectedDatabase /backup/database.dump *> $null
if ($LASTEXITCODE -ne 0) { throw 'Transactional staging restore failed. Inspect the destination securely before retrying.' }
Write-Output 'Snapshot restored into the previously empty staging target. Keep all application roles paused until recovery and file verification pass.'
