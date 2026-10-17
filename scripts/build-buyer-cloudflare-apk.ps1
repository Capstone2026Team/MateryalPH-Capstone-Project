[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$VendorTunnelUrl,
    [string]$BuildWorkspace
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$uri = [Uri]$VendorTunnelUrl
if ($uri.Scheme -ne 'https' -or -not $uri.Host.EndsWith('.trycloudflare.com', [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Pass the HTTPS Vendor Quick Tunnel URL printed by start-cloudflare-demo.ps1.'
}
$statePath = Join-Path $env:TEMP 'materyalph-cloudflare-demo\state.json'
if (-not (Test-Path -LiteralPath $statePath)) {
    throw 'Start the Quick Tunnel demo first so the local Vendor portal proxy is running.'
}

$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
if ($state.urls.vendor -ne $uri.GetLeftPart([UriPartial]::Authority)) {
    throw 'The supplied Vendor URL does not match the currently running Quick Tunnel. Restart the app build with the printed URL.'
}

$sourceBuyerRoot = Join-Path $repoRoot 'apps\buyer-mobile'
$buyerRoot = $sourceBuyerRoot
$createdBuildWorkspace = $false
$buildSucceeded = $false
$buildWorkspaceRoot = $null
$sourceConfig = Join-Path $buyerRoot 'config\development.json'
if (-not (Test-Path -LiteralPath $sourceConfig)) {
    throw 'apps/buyer-mobile/config/development.json is missing. Restore the local development config without sharing its values.'
}

$config = Get-Content -LiteralPath $sourceConfig -Raw | ConvertFrom-Json
$config.API_BASE_URL = "$($uri.GetLeftPart([UriPartial]::Authority))/api/v1"
$temporaryConfig = Join-Path $env:TEMP ("materyalph-buyer-demo-{0}.json" -f [Guid]::NewGuid().ToString('N'))
$publicApkPath = Join-Path $repoRoot 'apps\vendor-web\public\buyer-demo.apk'

try {
    if ($BuildWorkspace) {
        $buildWorkspaceRoot = [System.IO.Path]::GetFullPath($BuildWorkspace)
        $repoPrefix = $repoRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
        if ($buildWorkspaceRoot.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw 'BuildWorkspace must be outside the repository so the full C: drive is not used for Flutter intermediates.'
        }
        $buyerRoot = Join-Path $buildWorkspaceRoot 'apps\buyer-mobile'
        $workspaceMarker = Join-Path $buildWorkspaceRoot '.materyalph-buyer-demo-workspace'
        if (Test-Path -LiteralPath $buildWorkspaceRoot) {
            if (-not (Test-Path -LiteralPath $workspaceMarker) -or -not (Test-Path -LiteralPath $buyerRoot)) {
                throw "BuildWorkspace already exists and is not a MateryalPH demo build copy: $buildWorkspaceRoot"
            }
        } else {
            New-Item -ItemType Directory -Path $buildWorkspaceRoot -Force | Out-Null
            $createdBuildWorkspace = $true
            $dartClientRoot = Join-Path $buildWorkspaceRoot 'packages\api-contract\generated\dart'
            $excludedDirectories = @('build', '.dart_tool', '.git', '.gradle', '.idea', 'node_modules')
            $excludedFiles = @('development.json', '.env', '.env.local', 'secrets.properties', 'key.properties', '*.jks', '*.keystore')
            function Copy-DemoProjectFiles {
                param([string]$Source, [string]$Destination)
                New-Item -ItemType Directory -Path $Destination -Force | Out-Null
                foreach ($item in Get-ChildItem -LiteralPath $Source -Force) {
                    if ($item.PSIsContainer -and $excludedDirectories -contains $item.Name) { continue }
                    if (-not $item.PSIsContainer -and ($excludedFiles | Where-Object { $item.Name -like $_ })) { continue }
                    $targetPath = Join-Path $Destination $item.Name
                    if ($item.PSIsContainer) { Copy-DemoProjectFiles -Source $item.FullName -Destination $targetPath }
                    else { Copy-Item -LiteralPath $item.FullName -Destination $targetPath -Force }
                }
            }
            Copy-DemoProjectFiles -Source $sourceBuyerRoot -Destination $buyerRoot
            Copy-DemoProjectFiles -Source (Join-Path $repoRoot 'packages\api-contract\generated\dart') -Destination $dartClientRoot
            [System.IO.File]::WriteAllText($workspaceMarker, 'Temporary Buyer demo build workspace.', [System.Text.UTF8Encoding]::new($false))
        }
        $gradlePropertiesPath = Join-Path $buyerRoot 'android\gradle.properties'
        if (Test-Path -LiteralPath $gradlePropertiesPath) {
            $gradleProperties = Get-Content -LiteralPath $gradlePropertiesPath -Raw
            $buildLimits = [System.Collections.Generic.List[string]]::new()
            if ($gradleProperties -notmatch '(?m)^kotlin\.incremental=') { $buildLimits.Add('kotlin.incremental=false') }
            if ($gradleProperties -notmatch '(?m)^org\.gradle\.workers\.max=') { $buildLimits.Add('org.gradle.workers.max=1') }
            if ($buildLimits.Count -gt 0) {
                [System.IO.File]::AppendAllText($gradlePropertiesPath, "`r`n$($buildLimits -join "`r`n")`r`n", [System.Text.UTF8Encoding]::new($false))
            }
        }
    }

    $apkPath = Join-Path $buyerRoot 'build\app\outputs\flutter-apk\app-debug.apk'
    $json = $config | ConvertTo-Json -Depth 40
    [System.IO.File]::WriteAllText($temporaryConfig, $json, [System.Text.UTF8Encoding]::new($false))
    Push-Location $buyerRoot
    & flutter build apk --debug --dart-define-from-file="$temporaryConfig"
    if ($LASTEXITCODE -ne 0) { throw "Flutter APK build failed with exit code $LASTEXITCODE." }
    if (-not (Test-Path -LiteralPath $apkPath)) { throw 'Flutter completed without producing the expected debug APK.' }
    Copy-Item -LiteralPath $apkPath -Destination $publicApkPath -Force
    $vendorRoot = Join-Path $repoRoot 'apps\vendor-web'
    $npmPath = Join-Path (Split-Path -Parent (Get-Command node.exe -ErrorAction Stop).Source) 'npm.cmd'
    $hadApiBase = Test-Path Env:VITE_API_BASE_URL
    $previousApiBase = $env:VITE_API_BASE_URL
    try {
        $env:VITE_API_BASE_URL = '/api/v1'
        Push-Location $vendorRoot
        & $npmPath run build
        if ($LASTEXITCODE -ne 0) { throw "Vendor portal rebuild for the APK download failed with exit code $LASTEXITCODE." }
    } finally {
        if ((Get-Location).Path -eq $vendorRoot) { Pop-Location }
        if ($hadApiBase) { $env:VITE_API_BASE_URL = $previousApiBase }
        else { Remove-Item Env:VITE_API_BASE_URL -ErrorAction SilentlyContinue }
    }
    $publishedApkPath = Join-Path $repoRoot 'apps\vendor-web\dist\buyer-demo.apk'
    if (-not (Test-Path -LiteralPath $publishedApkPath)) { throw 'Vendor build did not include the temporary Buyer APK.' }
    $buildSucceeded = $true
} finally {
    if ((Get-Location).Path -eq $buyerRoot) { Pop-Location }
    if (Test-Path -LiteralPath $temporaryConfig) { Remove-Item -LiteralPath $temporaryConfig -Force }
    if ($createdBuildWorkspace -and $buildSucceeded -and (Test-Path -LiteralPath $buildWorkspaceRoot)) {
        $workspacePath = [System.IO.Path]::GetFullPath($buildWorkspaceRoot)
        $driveRoot = [System.IO.Path]::GetPathRoot($workspacePath)
        if ($workspacePath.StartsWith($driveRoot, [StringComparison]::OrdinalIgnoreCase) -and $workspacePath -ne $driveRoot) {
            Remove-Item -LiteralPath $workspacePath -Recurse -Force
        }
    } elseif ($BuildWorkspace -and (Test-Path -LiteralPath (Join-Path $buildWorkspaceRoot '.materyalph-buyer-demo-workspace'))) {
        Write-Output "Preserved the failed build workspace for a retry: $buildWorkspaceRoot"
    }
}

$publishedApkPath = Join-Path $repoRoot 'apps\vendor-web\dist\buyer-demo.apk'
if (-not (Test-Path -LiteralPath $publishedApkPath)) { throw 'Vendor build did not include the temporary Buyer APK.' }
$sizeMb = [Math]::Round((Get-Item -LiteralPath $publishedApkPath).Length / 1MB, 1)
Write-Output "Buyer Android demo APK is available at: $($uri.GetLeftPart([UriPartial]::Authority))/buyer-demo.apk"
Write-Output "APK size: $sizeMb MB. Download it on the phone while this tunnel is running, then install it."
Write-Output 'This debug APK is for the temporary demo only; the phone uses secure local storage for mobile auth tokens.'
