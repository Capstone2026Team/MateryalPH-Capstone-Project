param()
$ErrorActionPreference = 'Stop'
$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$destination = Join-Path $repositoryRoot '.tmp/staging-deployment/passport.env'
if (Test-Path -LiteralPath $destination) {
    throw 'A staging signing-key file already exists. Keep and reuse it; this command never rotates keys.'
}
New-Item -ItemType Directory -Path (Split-Path $destination) -Force | Out-Null
$signingKey = [System.Security.Cryptography.RSA]::Create(4096)
try {
    $privateValue = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($signingKey.ExportRSAPrivateKeyPem()))
    $publicValue = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($signingKey.ExportSubjectPublicKeyInfoPem()))
    $lines = @("PASSPORT_PRIVATE_KEY_BASE64=$privateValue", "PASSPORT_PUBLIC_KEY_BASE64=$publicValue")
    [IO.File]::WriteAllLines($destination, $lines, [Text.UTF8Encoding]::new($false))
} finally {
    $signingKey.Dispose()
    $privateValue = $null
    $publicValue = $null
    $lines = $null
}
Write-Host 'Created the ignored staging Passport key file. Import it into the API Environment page; do not print or commit it.'
