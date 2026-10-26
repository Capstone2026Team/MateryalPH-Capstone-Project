# Windows integration checks using synthetic Flutter and Android SDK tools.
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$fixtureRoot = Join-Path $taskRoot '.tmp/buyer-staging-tests'
$fixture = Join-Path $fixtureRoot ([Guid]::NewGuid().ToString('N'))
$buyerPath = Join-Path $fixture 'apps/buyer-mobile'
$buildScript = Join-Path $fixture 'scripts/deployment/build-buyer-staging.ps1'
$environmentNames = @('ANDROID_HOME', 'ANDROID_SDK_ROOT', 'LOCALAPPDATA', 'MAPS_ANDROID_API_KEY', 'BUYER_STAGING_TEST_SIGNER_USED', 'BUYER_STAGING_TEST_SIGNER_FAIL')
$savedEnvironment = @{}
foreach ($name in $environmentNames) { $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
$global:buyerStagingTestFlutterInvocations = [System.Collections.Generic.List[object]]::new()

function Assert-Condition($Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

function Add-TestSigner([string] $Sdk, [string] $Version) {
    $tools = Join-Path $Sdk "build-tools/$Version"
    New-Item -ItemType Directory -Force -Path $tools | Out-Null
    @('@echo off', 'echo %~dp0>"%BUYER_STAGING_TEST_SIGNER_USED%"',
        'if "%BUYER_STAGING_TEST_SIGNER_FAIL%"=="1" exit /b 1',
        ('echo Signer #1 certificate SHA-256 digest: ' + ('a' * 64)), 'exit /b 0') |
        Set-Content -LiteralPath (Join-Path $tools 'apksigner.bat') -Encoding ascii
}

function flutter {
    $global:buyerStagingTestFlutterInvocations.Add(@($args))
    $outputs = Join-Path (Get-Location).Path 'build/app/outputs/flutter-apk'
    New-Item -ItemType Directory -Force -Path $outputs | Out-Null
    $variant = if ('--release' -in $args) { 'release' } else { 'debug' }
    Set-Content -LiteralPath (Join-Path $outputs "app-$variant.apk") -Value 'synthetic APK fixture' -Encoding ascii
    $global:LASTEXITCODE = 0
}

function Assert-BuildFailure([int] $Number, [string] $Pattern, [switch] $BeforeBuild) {
    $calls = $global:buyerStagingTestFlutterInvocations.Count
    $failure = $null
    try { & $buildScript -Deployment Hostinger -Release -BuildName 1.0.1 -BuildNumber $Number | Out-Null }
    catch { $failure = $_.Exception.Message }
    Assert-Condition ($failure -match $Pattern) "Expected failure: $Pattern"
    if ($BeforeBuild) { Assert-Condition ($global:buyerStagingTestFlutterInvocations.Count -eq $calls) 'Flutter must not run when preflight fails.' }
}

try {
    foreach ($directory in @('scripts/deployment', 'apps/buyer-mobile/config', 'apps/buyer-mobile/android/app')) {
        New-Item -ItemType Directory -Force -Path (Join-Path $fixture $directory) | Out-Null
    }
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'build-buyer-staging.ps1') -Destination $buildScript
    $configuration = Get-Content -LiteralPath (Join-Path $taskRoot 'apps/buyer-mobile/config/staging.example.json') -Raw | ConvertFrom-Json
    $configuration.API_BASE_URL = 'https://buyer.example.test/api/v1'
    $configuration.MAPS_CLIENT_CONFIGURED = $true
    $configuration.FIREBASE_PUSH_ENABLED = $true
    foreach ($name in @('GOOGLE_OIDC_SERVER_CLIENT_ID', 'FIREBASE_API_KEY', 'FIREBASE_APP_ID', 'FIREBASE_MESSAGING_SENDER_ID', 'FIREBASE_PROJECT_ID')) {
        $configuration.$name = 'synthetic-public-client-setting'
    }
    $configuration | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $buyerPath 'config/hostinger.json')
    $configuration | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $buyerPath 'config/staging.example.json')
    @{ Hostinger = @{ addressesFinalized = $true; apiBaseUrl = $configuration.API_BASE_URL } } |
        ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path $buyerPath 'config/deployments.json')
    @{ project_info = @{ project_id = $configuration.FIREBASE_PROJECT_ID }; client = @(@{
        client_info = @{ android_client_info = @{ package_name = 'ph.materyal.buyer' }; mobilesdk_app_id = $configuration.FIREBASE_APP_ID }
    }) } | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $buyerPath 'android/app/google-services.json')
    New-Item -ItemType File -Path (Join-Path $buyerPath 'android/key.properties') | Out-Null
    $env:MAPS_ANDROID_API_KEY = 'synthetic-public-client-setting'
    $env:LOCALAPPDATA = Join-Path $fixture 'missing-default-sdk'
    $env:BUYER_STAGING_TEST_SIGNER_USED = Join-Path $fixture 'selected-signer.txt'
    $env:BUYER_STAGING_TEST_SIGNER_FAIL = '0'
    $localSdk = Join-Path $fixture 'project sdk'
    $fallbackSdk = Join-Path $fixture 'fallback sdk'
    Add-TestSigner $localSdk '9.0.0'
    Add-TestSigner $localSdk '10.0.0'
    Add-TestSigner $localSdk '100.0.0-rc1'
    Add-TestSigner $fallbackSdk '11.0.0'
    $env:ANDROID_HOME = $fallbackSdk
    $env:ANDROID_SDK_ROOT = $fallbackSdk
    $localProperties = Join-Path $buyerPath 'android/local.properties'
    ('sdk.dir=' + $localSdk.Replace('\', '\\').Replace(':', '\:').Replace(' ', '\ ')) |
        Set-Content -LiteralPath $localProperties

    & $buildScript -Deployment Hostinger -Release -BuildName 1.0.1 -BuildNumber 1 | Out-Null
    Assert-Condition ((Get-Content -LiteralPath $env:BUYER_STAGING_TEST_SIGNER_USED -Raw) -match '10\.0\.0') 'Use the project SDK and sort stable tool versions numerically.'
    $delivery = Join-Path $fixture '.tmp/apk-delivery/Hostinger/1.0.1-1'
    $metadata = Get-Content -LiteralPath (Join-Path $delivery 'release.json') -Raw | ConvertFrom-Json
    Assert-Condition ($metadata.api -eq $configuration.API_BASE_URL -and $metadata.certificateSha256 -eq ('a' * 64)) 'Preserve the selected API and verified certificate in delivery metadata.'
    Assert-Condition ($metadata.sha256 -eq (Get-FileHash -LiteralPath (Join-Path $delivery 'MateryalPH-Hostinger-release.apk')).Hash.ToLowerInvariant()) 'Delivery checksum must match the APK.'
    Assert-Condition ('--dart-define-from-file=config/hostinger.json' -in $global:buyerStagingTestFlutterInvocations[0] -and '--build-number=1' -in $global:buyerStagingTestFlutterInvocations[0]) 'Pass the Hostinger profile and build number to Flutter.'
    Write-Output 'PASS: project SDK, escaped paths, stable version order, profile and verified delivery metadata'

    Assert-BuildFailure 1 'artifact version already exists' -BeforeBuild
    Write-Output 'PASS: reject an existing delivery before Flutter runs'

    Set-Content -LiteralPath $localProperties -Value 'sdk.dir=C:\\missing\\sdk'
    $env:ANDROID_HOME = 'C:\Users\<YourUser>\AppData\Local\Android\Sdk'
    & $buildScript -Deployment Hostinger -Release -BuildName 1.0.1 -BuildNumber 2 | Out-Null
    Assert-Condition ((Get-Content -LiteralPath $env:BUYER_STAGING_TEST_SIGNER_USED -Raw) -match '11\.0\.0') 'Skip placeholder paths and use ANDROID_SDK_ROOT.'
    Write-Output 'PASS: recover from the reported placeholder ANDROID_HOME using ANDROID_SDK_ROOT'

    $env:ANDROID_SDK_ROOT = Join-Path $fixture 'missing-sdk'
    Assert-BuildFailure 3 'Android apksigner is required' -BeforeBuild
    Assert-Condition (-not (Test-Path -LiteralPath (Join-Path $fixture '.tmp/apk-delivery/Hostinger/1.0.1-3'))) 'Missing SDK must not leave a delivery folder.'
    Write-Output 'PASS: missing signing tools fail before Flutter and delivery creation'

    $env:ANDROID_SDK_ROOT = $fallbackSdk
    $env:BUYER_STAGING_TEST_SIGNER_FAIL = '1'
    Assert-BuildFailure 4 'APK signing verification failed'
    Assert-Condition (-not (Test-Path -LiteralPath (Join-Path $fixture '.tmp/apk-delivery/Hostinger/1.0.1-4'))) 'Failed signature verification must not leave a delivery folder.'
    Write-Output 'PASS: reject an invalid signature without creating a delivery folder'

    $env:ANDROID_SDK_ROOT = Join-Path $fixture 'missing-sdk'
    & $buildScript -Deployment Hostinger | Out-Null
    Assert-Condition ('--debug' -in $global:buyerStagingTestFlutterInvocations[$global:buyerStagingTestFlutterInvocations.Count - 1]) 'Debug builds must remain available without release tools.'
    Write-Output 'PASS: debug build does not require release signing tools'
} finally {
    foreach ($name in $environmentNames) { [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name], 'Process') }
    $resolvedFixture = [IO.Path]::GetFullPath($fixture)
    $resolvedRoot = [IO.Path]::GetFullPath($fixtureRoot).TrimEnd('\') + '\'
    if (-not $resolvedFixture.StartsWith($resolvedRoot, [StringComparison]::OrdinalIgnoreCase)) { throw 'Test cleanup target is outside the fixture directory.' }
    if (Test-Path -LiteralPath $resolvedFixture) { Remove-Item -LiteralPath $resolvedFixture -Recurse -Force }
}
