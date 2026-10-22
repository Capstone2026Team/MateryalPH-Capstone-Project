[CmdletBinding()]
param([switch] $Run, [string] $Device)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$buyerPath = Join-Path $taskRoot 'apps/buyer-mobile'
$configPath = Join-Path $buyerPath 'config/staging.json'
if (-not (Test-Path -LiteralPath $configPath)) { throw 'Copy config/staging.example.json to ignored config/staging.json and configure public staging settings first.' }
$configuration = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
$apiAddress = $null
if ($configuration.APP_ENV -ne 'staging' -or -not [Uri]::TryCreate($configuration.API_BASE_URL, [UriKind]::Absolute, [ref] $apiAddress) -or $apiAddress.Scheme -ne 'https' -or $apiAddress.AbsolutePath -ne '/api/v1' -or $apiAddress.Host -match 'REPLACE|localhost' -or $apiAddress.Host -notmatch '^[a-z0-9-]+\.onrender\.com$' -or $apiAddress.Query -or $apiAddress.Fragment -or $apiAddress.UserInfo) { throw 'Configure the actual Render HTTPS API origin ending in /api/v1.' }
$allowed = (Get-Content (Join-Path $buyerPath 'config/staging.example.json') -Raw | ConvertFrom-Json).PSObject.Properties.Name
foreach ($key in $configuration.PSObject.Properties.Name) { if ($key -notin $allowed) { throw 'Buyer configuration contains an unsupported setting. Backend credentials never belong here.' } }
Push-Location $buyerPath
try {
    if ($Run) {
        $arguments = @('run', '--dart-define-from-file=config/staging.json')
        if ($Device) { $arguments += @('-d', $Device) }
        & flutter @arguments
    } else { & flutter build apk --debug --dart-define-from-file=config/staging.json }
    if ($LASTEXITCODE -ne 0) { throw 'Flutter staging command failed.' }
} finally { Pop-Location }
