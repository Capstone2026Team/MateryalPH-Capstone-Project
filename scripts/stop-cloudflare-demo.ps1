[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$stateDirectory = Join-Path $env:TEMP 'materyalph-cloudflare-demo'
$statePath = Join-Path $stateDirectory 'state.json'
if (-not (Test-Path -LiteralPath $statePath)) {
    Write-Output 'No tracked MateryalPH Quick Tunnel demo processes were found.'
    return
}

$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
foreach ($entry in $state.processes) {
    $process = Get-Process -Id ([int]$entry.processId) -ErrorAction SilentlyContinue
    if (-not $process) { continue }
    $actualPath = $null
    try { $actualPath = $process.Path } catch {}
    if ($actualPath -and $actualPath -ieq [string]$entry.filePath) {
        Stop-Process -Id $process.Id -Force
        Write-Output "Stopped $($entry.kind) process $($entry.processId)."
    } else {
        Write-Output "Skipped process $($entry.processId); it no longer matches the recorded executable."
    }
}

Remove-Item -LiteralPath $statePath -Force
$repoRoot = Split-Path -Parent $PSScriptRoot
$apkPaths = @(
    (Join-Path $repoRoot 'apps\vendor-web\public\buyer-demo.apk'),
    (Join-Path $repoRoot 'apps\vendor-web\dist\buyer-demo.apk')
)
foreach ($apkPath in $apkPaths) {
    if (Test-Path -LiteralPath $apkPath) {
        Remove-Item -LiteralPath $apkPath -Force
        Write-Output "Removed temporary APK: $apkPath"
    }
}
Write-Output 'The local portal previews and Quick Tunnels have been stopped.'
