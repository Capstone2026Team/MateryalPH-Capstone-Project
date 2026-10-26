# Exercise release failures with synthetic packages and mocked network/native commands.
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$fixtureRoot = Join-Path $repoRoot '.tmp/hostinger-release-tests'
$fixture = Join-Path $fixtureRoot ([Guid]::NewGuid().ToString('N'))
$scriptPath = Join-Path $fixture 'scripts/deployment/release-hostinger.ps1'
$packagePath = Join-Path $fixture 'package with spaces'
$originalLocation = Get-Location
$testCommit = 'd' * 40
$environmentNames = @('PATH', 'TEMP', 'TMP', 'GITHUB_TOKEN', 'VENDOR_RECAPTCHA_SITE_KEY', 'ADMIN_RECAPTCHA_SITE_KEY', 'GOOGLE_MAPS_BROWSER_KEY')
$savedEnvironment = @{}
foreach ($name in $environmentNames) { $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }

function Assert-Condition($condition, [string] $message) {
    if (-not $condition) { throw $message }
}

function Reset-Scenario {
    $global:hostingerReleaseTest = @{
        Preflight = 0; Directory = 0; Upload = 0; Checksums = 0; Install = 0; Git = 0; Build = 0; AllowBuild = $false
        PreflightFailures = 0; DirectoryFailures = 0; UploadFailures = 0; ChecksumFailure = $false
        CiCommit = $testCommit; CiBranch = 'staging'; CiPath = '.github/workflows/ci.yml'; CiConclusion = 'success'
    }
    $archives = [ordered]@{}
    foreach ($name in 'api.tar', 'edge.tar', 'runtime.tar') {
        $path = Join-Path $packagePath $name
        Set-Content -LiteralPath $path -Value "synthetic archive: $name" -Encoding utf8
        $archives[$name] = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    $script:record = [ordered]@{
        format = 'materyalph-vps-release-v1'; commit = $testCommit; required_check = 'success'
        image_checks = 'runtime-and-trivy-passed'
        ci_run_url = 'https://github.com/Capstone2026Team/MateryalPH-Capstone-Project/actions/runs/1234'
        images = @{ api = 'sha256:' + ('a' * 64); edge = 'sha256:' + ('b' * 64) }; archives = $archives
    }
    Save-Manifest
}

function Save-Manifest {
    $script:record | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $packagePath 'release.json') -Encoding utf8
}

function Invoke-Scenario([switch] $Fresh, [string] $Commit, [string] $ExpectedError) {
    $parameters = @{ OutputRoot = (Join-Path $fixture 'output') }
    if (-not $Fresh) { $parameters.ReleaseDirectory = $packagePath }
    if ($Commit) { $parameters.Commit = $Commit }
    $failure = $null
    try { & $scriptPath @parameters 6>$null | Out-Null }
    catch { $failure = $_.Exception.Message }
    Assert-Condition ($failure -and $failure -match $ExpectedError) "Expected '$ExpectedError', received '$failure'."
}

function ssh {
    $command = [string]$args[-1]
    Assert-Condition ('StrictHostKeyChecking=yes' -in $args -and 'BatchMode=yes' -in $args) 'SSH must retain pinned host verification and noninteractive authentication.'
    if ($command -eq 'true') {
        $global:hostingerReleaseTest.Preflight++
        $global:LASTEXITCODE = if ($global:hostingerReleaseTest.Preflight -le $global:hostingerReleaseTest.PreflightFailures) { 255 } else { 0 }
    } elseif ($command -like 'mkdir -p *') {
        $global:hostingerReleaseTest.Directory++
        $global:LASTEXITCODE = if ($global:hostingerReleaseTest.Directory -le $global:hostingerReleaseTest.DirectoryFailures) { 255 } else { 0 }
    } elseif ($command -like '*setsid nohup*') {
        $global:hostingerReleaseTest.Install++
        throw 'TEST_STOP_BEFORE_INSTALL'
    } else {
        $global:hostingerReleaseTest.Checksums++
        $global:LASTEXITCODE = if ($global:hostingerReleaseTest.ChecksumFailure) { 1 } else { 0 }
    }
}

function scp {
    $global:hostingerReleaseTest.Upload++
    $global:LASTEXITCODE = if ($global:hostingerReleaseTest.Upload -le $global:hostingerReleaseTest.UploadFailures) { 1 } else { 0 }
}

function git {
    $global:hostingerReleaseTest.Git++
    $global:LASTEXITCODE = 0
    if ($args[0] -eq 'credential') { return 'password=synthetic-release-test-credential-only' }
    if ($args[0] -eq 'rev-parse') { return $testCommit }
    if ($args[0] -ne 'fetch') { throw 'Unexpected Git command in release test.' }
}

function python {
    $global:hostingerReleaseTest.Build++
    if (-not $global:hostingerReleaseTest.AllowBuild) { throw 'An existing release must not be rebuilt.' }
    $destination = [string]$args[3]
    New-Item -ItemType Directory -Force -Path $destination | Out-Null
    foreach ($name in 'api.tar', 'edge.tar', 'runtime.tar', 'release.json') {
        Copy-Item -LiteralPath (Join-Path $packagePath $name) -Destination (Join-Path $destination $name)
    }
    $global:LASTEXITCODE = 0
}

function trivy { throw 'The synthetic packager does not invoke Trivy.' }
function Resolve-DnsName { }
function Start-Sleep { }
function Invoke-RestMethod {
    param([string] $Uri, [string] $Method, $Headers, [string] $ContentType, [string] $Body)
    if ($Method -ne 'Get') { throw 'Resume must not dispatch a replacement CI run.' }
    return @{ workflow_runs = @(@{
        head_sha = $global:hostingerReleaseTest.CiCommit; head_branch = $global:hostingerReleaseTest.CiBranch
        path = $global:hostingerReleaseTest.CiPath; status = 'completed'; conclusion = $global:hostingerReleaseTest.CiConclusion
        run_number = 1; html_url = $script:record.ci_run_url
    }) }
}

try {
    foreach ($directory in 'scripts/deployment', '.tmp/hostinger-deployment/access', 'package with spaces') {
        New-Item -ItemType Directory -Force -Path (Join-Path $fixture $directory) | Out-Null
    }
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'release-hostinger.ps1') -Destination $scriptPath
    foreach ($name in 'id_ed25519.operator', 'known_hosts') {
        Set-Content -LiteralPath (Join-Path $fixture ".tmp/hostinger-deployment/access/$name") -Value 'synthetic fixture, no real key'
    }

    Reset-Scenario
    $global:hostingerReleaseTest.PreflightFailures = 3
    Invoke-Scenario -Fresh -ExpectedError 'SSH preflight failed after 3 attempts'
    Assert-Condition ($global:hostingerReleaseTest.Preflight -eq 3 -and $global:hostingerReleaseTest.Git -eq 0 -and $global:hostingerReleaseTest.Build -eq 0 -and $global:hostingerReleaseTest.Upload -eq 0) 'Unreachable SSH must stop before CI, packaging or upload.'
    Write-Output 'PASS: SSH failure stops before CI/build and retries are bounded'

    Reset-Scenario
    $global:hostingerReleaseTest.PreflightFailures = 1
    $global:hostingerReleaseTest.DirectoryFailures = 1
    $global:hostingerReleaseTest.UploadFailures = 1
    Invoke-Scenario -ExpectedError 'TEST_STOP_BEFORE_INSTALL'
    Assert-Condition ($global:hostingerReleaseTest.Preflight -eq 2 -and $global:hostingerReleaseTest.Directory -eq 2 -and $global:hostingerReleaseTest.Upload -eq 2 -and $global:hostingerReleaseTest.Checksums -eq 1 -and $global:hostingerReleaseTest.Build -eq 0) 'Resume should recover transient connections and verify the uploaded package without a rebuild.'
    Write-Output 'PASS: transient SSH/SCP recovery, pinned hosts, paths with spaces and package reuse without portal env/build tools'

    Reset-Scenario
    $global:hostingerReleaseTest.DirectoryFailures = 3
    Invoke-Scenario -ExpectedError 'Preparing the upload directory failed after 3 attempts'
    Assert-Condition ($global:hostingerReleaseTest.Directory -eq 3 -and $global:hostingerReleaseTest.Upload -eq 0) 'A failed SSH directory step must block SCP.'
    Write-Output 'PASS: failed upload-directory preparation blocks SCP'

    Reset-Scenario
    $global:hostingerReleaseTest.UploadFailures = 3
    Invoke-Scenario -ExpectedError "Release upload failed after 3 attempts.*-ReleaseDirectory"
    Assert-Condition ($global:hostingerReleaseTest.Upload -eq 3 -and $global:hostingerReleaseTest.Checksums -eq 0 -and $global:hostingerReleaseTest.Install -eq 0 -and (Test-Path -LiteralPath (Join-Path $packagePath 'api.tar'))) 'Failed uploads must retain the local package and block all install steps.'
    Write-Output 'PASS: failed SCP preserves the package, prints resume guidance and blocks installation'

    Reset-Scenario
    Add-Content -LiteralPath (Join-Path $packagePath 'api.tar') -Value 'tampered'
    Invoke-Scenario -ExpectedError 'checksum mismatch: api.tar'
    Assert-Condition ($global:hostingerReleaseTest.Preflight -eq 0) 'Tampered archives must fail before SSH.'
    Write-Output 'PASS: archive tampering blocks resume before network access'

    Reset-Scenario
    Remove-Item -LiteralPath (Join-Path $packagePath 'edge.tar')
    Invoke-Scenario -ExpectedError 'archive missing or checksum mismatch: edge.tar'
    Write-Output 'PASS: missing archives block resume'

    foreach ($variant in 'archive-path', 'mutable-image', 'missing-scan', 'wrong-repository') {
        Reset-Scenario
        switch ($variant) {
            'archive-path' { $script:record.archives['../outside.tar'] = 'a' * 64 }
            'mutable-image' { $script:record.images.api = 'materyalph-api:latest' }
            'missing-scan' { $script:record.image_checks = 'not-checked' }
            'wrong-repository' { $script:record.ci_run_url = 'https://github.com/another/repository/actions/runs/1234' }
        }
        Save-Manifest
        Invoke-Scenario -ExpectedError 'manifest|immutable'
        Assert-Condition ($global:hostingerReleaseTest.Preflight -eq 0) "Invalid package metadata ($variant) must fail before SSH."
        Write-Output "PASS: reject $variant metadata"
    }

    Reset-Scenario
    Invoke-Scenario -Commit ('e' * 40) -ExpectedError 'Commit must match'
    Write-Output 'PASS: an explicit commit cannot conflict with the packaged commit'

    foreach ($variant in 'commit', 'branch', 'workflow', 'failed-run') {
        Reset-Scenario
        switch ($variant) {
            'commit' { $global:hostingerReleaseTest.CiCommit = 'e' * 40 }
            'branch' { $global:hostingerReleaseTest.CiBranch = 'main' }
            'workflow' { $global:hostingerReleaseTest.CiPath = '.github/workflows/other.yml' }
            'failed-run' { $global:hostingerReleaseTest.CiConclusion = 'failure' }
        }
        Invoke-Scenario -ExpectedError 'no successful current quality-gates run'
        Assert-Condition ($global:hostingerReleaseTest.Upload -eq 0) "CI evidence for the wrong $variant must block upload."
        Write-Output "PASS: resume rechecks CI $variant evidence"
    }

    Reset-Scenario
    $global:hostingerReleaseTest.ChecksumFailure = $true
    Invoke-Scenario -ExpectedError 'Remote step failed'
    Assert-Condition ($global:hostingerReleaseTest.Install -eq 0) 'A remote checksum failure must block installation.'
    Write-Output 'PASS: remote checksum failure blocks installation'

    Reset-Scenario
    $global:hostingerReleaseTest.AllowBuild = $true
    foreach ($portal in 'vendor-web', 'admin-web') {
        $portalPath = Join-Path $fixture "apps/$portal"
        New-Item -ItemType Directory -Force -Path $portalPath | Out-Null
        Set-Content -LiteralPath (Join-Path $portalPath '.env') -Value @('VITE_RECAPTCHA_SITE_KEY=synthetic-public-captcha', 'VITE_GOOGLE_MAPS_BROWSER_KEY=synthetic-public-maps')
    }
    Invoke-Scenario -Fresh -ExpectedError 'TEST_STOP_BEFORE_INSTALL'
    Assert-Condition ($global:hostingerReleaseTest.Build -eq 1 -and $global:hostingerReleaseTest.Checksums -eq 1) 'The default path must still package and validate a new release.'
    Write-Output 'PASS: the default release path still builds and verifies its package'
} finally {
    Set-Location -LiteralPath $originalLocation.Path
    foreach ($name in $environmentNames) { [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name], 'Process') }
    $resolvedFixture = [IO.Path]::GetFullPath($fixture)
    $allowedPrefix = [IO.Path]::GetFullPath($fixtureRoot) + [IO.Path]::DirectorySeparatorChar
    if (-not $resolvedFixture.StartsWith($allowedPrefix, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe release-test cleanup path.' }
    if (Test-Path -LiteralPath $resolvedFixture) { Remove-Item -LiteralPath $resolvedFixture -Recurse -Force }
    Remove-Variable -Name hostingerReleaseTest -Scope Global -ErrorAction SilentlyContinue
}
