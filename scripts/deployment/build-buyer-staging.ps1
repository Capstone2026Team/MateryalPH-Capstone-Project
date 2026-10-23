[CmdletBinding()]
param(
    [ValidateSet('Hostinger', 'Render')] [string] $Deployment = 'Render',
    [switch] $Release,
    [string] $BuildName,
    [int] $BuildNumber = 0,
    [switch] $Run,
    [string] $Device
)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$buyerPath = Join-Path $taskRoot 'apps/buyer-mobile'
$profile = if ($Deployment -eq 'Hostinger') { 'hostinger' } else { 'staging' }
$configPath = Join-Path $buyerPath "config/$profile.json"
$registryPath = Join-Path $buyerPath 'config/deployments.json'
if (-not (Test-Path -LiteralPath $configPath) -or -not (Test-Path -LiteralPath $registryPath)) {
    throw 'Configure the ignored Buyer deployment registry and selected public profile from their examples first.'
}
$configuration = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
$registry = Get-Content -LiteralPath $registryPath -Raw | ConvertFrom-Json
$selected = $registry.$Deployment
$apiAddress = $null
if ($configuration.APP_ENV -ne 'staging' -or $selected.addressesFinalized -ne $true -or $configuration.API_BASE_URL -cne $selected.apiBaseUrl -or
    -not [Uri]::TryCreate($configuration.API_BASE_URL, [UriKind]::Absolute, [ref] $apiAddress) -or $apiAddress.Scheme -ne 'https' -or
    $apiAddress.AbsolutePath -ne '/api/v1' -or $apiAddress.Host -match 'REPLACE|localhost' -or $apiAddress.Query -or $apiAddress.Fragment -or $apiAddress.UserInfo -or -not $apiAddress.IsDefaultPort) {
    throw 'Use the exact finalized HTTPS API address registered for this deployment, ending in /api/v1.'
}
$allowed = (Get-Content (Join-Path $buyerPath 'config/staging.example.json') -Raw | ConvertFrom-Json).PSObject.Properties.Name
foreach ($key in $configuration.PSObject.Properties.Name) { if ($key -notin $allowed) { throw 'Buyer configuration contains an unsupported setting. Backend credentials never belong here.' } }
if ($Release) {
    if ($Run -or $BuildNumber -lt 1 -or $BuildName -notmatch '^\d+\.\d+\.\d+$') { throw 'Release needs a version name and positive, increasing build number; omit -Run.' }
    if (-not (Test-Path (Join-Path $buyerPath 'android/key.properties')) -or -not (Test-Path (Join-Path $buyerPath 'android/app/google-services.json')) -or
        $configuration.MAPS_CLIENT_CONFIGURED -ne $true -or $configuration.FIREBASE_PUSH_ENABLED -ne $true) {
        throw 'Release needs protected signing, restricted native Maps and native Firebase configuration.'
    }
    foreach ($name in @('GOOGLE_OIDC_SERVER_CLIENT_ID', 'FIREBASE_API_KEY', 'FIREBASE_APP_ID', 'FIREBASE_MESSAGING_SENDER_ID', 'FIREBASE_PROJECT_ID')) {
        if (-not $configuration.$name) { throw "Configure the public Buyer setting $name before release." }
    }
    $mapsFile = Join-Path $buyerPath 'android/secrets.properties'
    $mapsConfigured = $env:MAPS_ANDROID_API_KEY -or ((Test-Path -LiteralPath $mapsFile) -and (Select-String -LiteralPath $mapsFile -Pattern '^MAPS_ANDROID_API_KEY=\S+' -Quiet))
    if (-not $mapsConfigured) { throw 'Configure the restricted native Android Maps client key before release.' }
    $native = Get-Content (Join-Path $buyerPath 'android/app/google-services.json') -Raw | ConvertFrom-Json
    $androidClient = @($native.client | Where-Object { $_.client_info.android_client_info.package_name -eq 'ph.materyal.buyer' })
    if ($native.project_info.project_id -cne $configuration.FIREBASE_PROJECT_ID -or $androidClient.Count -ne 1 -or
        $androidClient[0].client_info.mobilesdk_app_id -cne $configuration.FIREBASE_APP_ID) { throw 'Native Firebase identity must match the selected public deployment profile.' }
}
Push-Location $buyerPath
try {
    if ($Run) {
        $arguments = @('run', "--dart-define-from-file=config/$profile.json")
        if ($Device) { $arguments += @('-d', $Device) }
    } else {
        $mode = if ($Release) { '--release' } else { '--debug' }
        $arguments = @('build', 'apk', $mode, "--dart-define-from-file=config/$profile.json")
        if ($Release) { $arguments += @("--build-name=$BuildName", "--build-number=$BuildNumber") }
    }
    & flutter @arguments
    if ($LASTEXITCODE -ne 0) { throw 'Flutter staging command failed.' }
    if (-not $Run) {
        $variant = if ($Release) { 'release' } else { 'debug' }
        $artifactVersion = if ($Release) { "$BuildName-$BuildNumber" } else { [DateTime]::UtcNow.ToString('yyyyMMddHHmmss') }
        $delivery = Join-Path $taskRoot ".tmp/apk-delivery/$Deployment/$artifactVersion"
        if (Test-Path -LiteralPath $delivery) { throw 'This artifact version already exists. Use the next build number or a new debug build time.' }
        New-Item -ItemType Directory -Force -Path $delivery | Out-Null
        $target = Join-Path $delivery "MateryalPH-$Deployment-$variant.apk"
        Copy-Item -LiteralPath (Join-Path $buyerPath "build/app/outputs/flutter-apk/app-$variant.apk") -Destination $target
        $metadata = [ordered]@{ deployment=$Deployment; variant=$variant; api=$selected.apiBaseUrl; version=$BuildName; buildNumber=$BuildNumber; sha256=(Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant(); builtAt=[DateTime]::UtcNow.ToString('o') }
        if ($Release) {
            $sdk = $env:ANDROID_HOME
            if (-not $sdk) { $sdk = Join-Path $env:LOCALAPPDATA 'Android/Sdk' }
            $signer = Get-ChildItem -LiteralPath (Join-Path $sdk 'build-tools') -Filter apksigner.bat -Recurse | Sort-Object FullName -Descending | Select-Object -First 1
            if (-not $signer) { throw 'Android apksigner is required to verify the delivered APK.' }
            $verification = & $signer.FullName verify --verbose --print-certs $target 2>&1
            if ($LASTEXITCODE -ne 0) { throw 'APK signing verification failed.' }
            $certificate = @($verification | Select-String '^Signer #1 certificate SHA-256 digest: (.+)$')
            if ($certificate.Count -ne 1) { throw 'Cannot identify the APK signing certificate.' }
            $metadata.certificateSha256 = $certificate[0].Matches[0].Groups[1].Value
        }
        $metadata | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $delivery 'release.json') -Encoding utf8
        Write-Output "APK and checksum metadata: $delivery"
    }
} finally { Pop-Location }
