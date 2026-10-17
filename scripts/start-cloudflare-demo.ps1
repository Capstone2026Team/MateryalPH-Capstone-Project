[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$stateDirectory = Join-Path $env:TEMP 'materyalph-cloudflare-demo'
$statePath = Join-Path $stateDirectory 'state.json'
$nodePath = (Get-Command node.exe -ErrorAction Stop).Source
$npmPath = Join-Path (Split-Path -Parent $nodePath) 'npm.cmd'
$cloudflaredCandidates = @(
    (Join-Path $env:ProgramFiles 'cloudflared\cloudflared.exe'),
    'C:\Program Files (x86)\cloudflared\cloudflared.exe'
)
$cloudflaredPath = $cloudflaredCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if (-not (Test-Path -LiteralPath $npmPath)) {
    throw 'Node.js npm.cmd was not found beside node.exe.'
}
if (-not $cloudflaredPath) {
    throw 'cloudflared.exe was not found in Program Files. Install or locate cloudflared, then rerun this script.'
}
if (Test-Path -LiteralPath $statePath) {
    throw "A Cloudflare demo state file already exists at $statePath. Run scripts/stop-cloudflare-demo.ps1 first."
}

$apiHealth = 'http://127.0.0.1:8080/api/v1/health'
try {
    $healthResponse = Invoke-WebRequest -Uri $apiHealth -TimeoutSec 5 -UseBasicParsing
    if ([int]$healthResponse.StatusCode -ne 200) { throw 'Health check did not return HTTP 200.' }
} catch {
    throw 'The local API is not responding on 127.0.0.1:8080. Start the existing MateryalPH services first; this script does not run migrations or seed data.'
}

New-Item -ItemType Directory -Path (Join-Path $stateDirectory 'logs') -Force | Out-Null
$state = [ordered]@{
    startedAt = (Get-Date).ToString('o')
    processes = @()
    urls = [ordered]@{}
}

function Save-DemoState {
    $json = $state | ConvertTo-Json -Depth 6
    [System.IO.File]::WriteAllText($statePath, $json, [System.Text.UTF8Encoding]::new($false))
}

function Start-TrackedProcess {
    param(
        [Parameter(Mandatory)][string]$Kind,
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$ArgumentLine,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [Parameter(Mandatory)][string]$LogName
    )
    $stdout = Join-Path $stateDirectory "logs\$LogName.out.log"
    $stderr = Join-Path $stateDirectory "logs\$LogName.err.log"
    $process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentLine -WorkingDirectory $WorkingDirectory `
        -RedirectStandardOutput $stdout -RedirectStandardError $stderr -WindowStyle Hidden -PassThru
    $state.processes += [ordered]@{
        kind = $Kind
        processId = $process.Id
        filePath = $FilePath
        stdout = $stdout
        stderr = $stderr
    }
    Save-DemoState
    return $process
}

function Wait-HttpReady {
    param([Parameter(Mandatory)][string]$Url, [int]$TimeoutSeconds = 30)
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        try {
            $response = Invoke-WebRequest -Uri $Url -TimeoutSec 3 -UseBasicParsing
            if ([int]$response.StatusCode -lt 500) { return $response }
        } catch {}
        Start-Sleep -Milliseconds 500
    } while ((Get-Date) -lt $deadline)
    throw "Timed out waiting for $Url"
}

function Start-PortalPreview {
    param([string]$Portal, [int]$Port)
    $appRoot = Join-Path $repoRoot "apps\$Portal-web"
    $viteEntry = Join-Path $appRoot 'node_modules\vite\bin\vite.js'
    if (-not (Test-Path -LiteralPath $viteEntry)) { throw "Vite dependencies are missing for $Portal. Run npm install in apps/$Portal-web." }
    $portOccupied = $false
    try {
        [void](Invoke-WebRequest -Uri "http://127.0.0.1:$Port/" -TimeoutSec 2 -UseBasicParsing)
        $portOccupied = $true
    } catch {
        $portOccupied = $null -ne $_.Exception.Response
    }
    if ($portOccupied) { throw "Port $Port is already serving another app. Stop it or choose a free preview port; this script will not stop existing processes." }
    $argumentLine = '"{0}" preview --host 127.0.0.1 --port {1} --strictPort' -f $viteEntry, $Port
    $process = Start-TrackedProcess -Kind "$Portal-preview" -FilePath $nodePath -ArgumentLine $argumentLine `
        -WorkingDirectory $appRoot -LogName "$Portal-preview"
    Start-Sleep -Milliseconds 750
    if (-not (Get-Process -Id $process.Id -ErrorAction SilentlyContinue)) {
        throw "The $Portal production preview process exited. Check $stateDirectory\logs\$Portal-preview.err.log."
    }
    $rootUrl = "http://127.0.0.1:$Port/"
    $page = Wait-HttpReady -Url $rootUrl
    if ($page.Content.Contains('/@vite/client') -or $page.Content.Contains('/@react-refresh')) {
        throw "$Portal port $Port served a Vite development page instead of the production preview."
    }
    $health = Wait-HttpReady -Url "http://127.0.0.1:$Port/api/v1/health"
    if ([int]$health.StatusCode -ne 200) { throw "$Portal API proxy health check failed." }
    return $process
}

function Start-QuickTunnel {
    param([string]$Portal, [int]$Port)
    $origin = "http://127.0.0.1:$Port"
    $argumentLine = 'tunnel --url {0} --no-autoupdate' -f $origin
    $process = Start-TrackedProcess -Kind "$Portal-tunnel" -FilePath $cloudflaredPath -ArgumentLine $argumentLine `
        -WorkingDirectory $repoRoot -LogName "$Portal-tunnel"
    $deadline = (Get-Date).AddSeconds(60)
    $tunnelUrl = $null
    do {
        if (-not (Get-Process -Id $process.Id -ErrorAction SilentlyContinue)) {
            throw "cloudflared exited while opening the $Portal Quick Tunnel. Check its log in $stateDirectory\logs."
        }
        $logText = @($state.processes | Where-Object { $_.processId -eq $process.Id } | ForEach-Object {
            foreach ($path in @($_.stdout, $_.stderr)) {
                if (Test-Path -LiteralPath $path) { Get-Content -LiteralPath $path -Raw -ErrorAction SilentlyContinue }
            }
        }) -join "`n"
        $match = [regex]::Match($logText, 'https://[a-z0-9-]+\.trycloudflare\.com', 'IgnoreCase')
        if ($match.Success) { $tunnelUrl = $match.Value.TrimEnd('.') }
        if (-not $tunnelUrl) { Start-Sleep -Milliseconds 500 }
    } while (-not $tunnelUrl -and (Get-Date) -lt $deadline)
    if (-not $tunnelUrl) { throw "Timed out waiting for the $Portal Quick Tunnel URL. Check its log in $stateDirectory\logs." }
    $state.urls[$Portal] = $tunnelUrl
    Save-DemoState
    return $tunnelUrl
}

function Test-PublicPortal {
    param([string]$Portal, [string]$TunnelUrl)
    $page = Wait-HttpReady -Url "$TunnelUrl/" -TimeoutSeconds 45
    $api = Wait-HttpReady -Url "$TunnelUrl/api/v1/health" -TimeoutSeconds 45
    if ([int]$page.StatusCode -ne 200 -or [int]$api.StatusCode -ne 200) {
        throw "The $Portal public page or API proxy did not return HTTP 200."
    }
    if ($page.Content.Contains('/@vite/client') -or $page.Content.Contains('/@react-refresh')) {
        throw "The $Portal tunnel reached a Vite development server instead of the production preview."
    }
    $sessionStatus = 'unexpected'
    try {
        [void](Invoke-WebRequest -Uri "$TunnelUrl/api/v1/auth/session" -TimeoutSec 15 -UseBasicParsing)
    } catch {
        if ($_.Exception.Response) { $sessionStatus = [string][int]$_.Exception.Response.StatusCode }
    }
    $csrf = Invoke-WebRequest -Uri "$TunnelUrl/api/v1/auth/csrf" -TimeoutSec 15 -UseBasicParsing
    $setCookie = @($csrf.Headers['Set-Cookie']) -join '; '
    $expectedSuffix = if ($Portal -eq 'vendor') { '_vendor' } else { '_admin' }
    $cookieName = [regex]::Match($setCookie, "mp_csrf$expectedSuffix=").Success
    $secure = [regex]::IsMatch($setCookie, ';\s*Secure(?:;|$)', 'IgnoreCase')
    $badDomain = [regex]::IsMatch($setCookie, ';\s*Domain=localhost(?:;|$)', 'IgnoreCase')
    if ([int]$csrf.StatusCode -ne 200 -or $sessionStatus -ne '401' -or -not $cookieName -or -not $secure -or $badDomain) {
        throw "$Portal auth cookie probe failed. The expected host-only Secure portal cookie was not returned."
    }
    Write-Output "${Portal}: page=200 API=200 auth-session=$sessionStatus CSRF-cookie=portal-scoped+Secure+host-only"
}

try {
    foreach ($portal in @(@{ Name = 'vendor'; Port = 5183 }, @{ Name = 'admin'; Port = 5184 })) {
        $appRoot = Join-Path $repoRoot "apps\$($portal.Name)-web"
        $hadApiBase = Test-Path Env:VITE_API_BASE_URL
        $previousApiBase = $env:VITE_API_BASE_URL
        try {
            $env:VITE_API_BASE_URL = '/api/v1'
            Push-Location $appRoot
            & $npmPath run build
            if ($LASTEXITCODE -ne 0) { throw "$($portal.Name) portal build failed with exit code $LASTEXITCODE." }
        } finally {
            Pop-Location
            if ($hadApiBase) { $env:VITE_API_BASE_URL = $previousApiBase }
            else { Remove-Item Env:VITE_API_BASE_URL -ErrorAction SilentlyContinue }
        }
    }

    foreach ($portal in @(@{ Name = 'vendor'; Port = 5183 }, @{ Name = 'admin'; Port = 5184 })) {
        [void](Start-PortalPreview -Portal $portal.Name -Port $portal.Port)
    }

    $vendorUrl = Start-QuickTunnel -Portal 'vendor' -Port 5183
    $adminUrl = Start-QuickTunnel -Portal 'admin' -Port 5184
    Test-PublicPortal -Portal 'vendor' -TunnelUrl $vendorUrl
    Test-PublicPortal -Portal 'admin' -TunnelUrl $adminUrl

    Write-Output ''
    Write-Output "Vendor portal: $vendorUrl/login"
    Write-Output "Admin portal:  $adminUrl/login"
    Write-Output 'Local production previews: Vendor http://127.0.0.1:5183 and Admin http://127.0.0.1:5184'
    Write-Output "Buyer API base for the Android demo build: $vendorUrl/api/v1"
    Write-Output 'Keep this PowerShell session, this PC, and both Quick Tunnel processes running until the demo ends.'
    Write-Output "Buyer phone APK: run scripts/build-buyer-cloudflare-apk.ps1 -VendorTunnelUrl '$vendorUrl'"
    Write-Output 'Stop the local previews and tunnels with scripts/stop-cloudflare-demo.ps1.'
} catch {
    foreach ($entry in $state.processes) {
        $process = Get-Process -Id ([int]$entry.processId) -ErrorAction SilentlyContinue
        if ($process) {
            try { Stop-Process -Id $process.Id -Force -ErrorAction Stop } catch {}
        }
    }
    if (Test-Path -LiteralPath $statePath) { Remove-Item -LiteralPath $statePath -Force }
    throw
}
