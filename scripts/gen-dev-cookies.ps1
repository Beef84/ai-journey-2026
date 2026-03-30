# Generates CloudFront signed cookies for dev.mrbeefy.academy.
# Run locally with your dev-cf-private.pem to get cookie values for browser testing.
# Requires PowerShell 7+ (pwsh) and AWS CLI configured with your credentials.
#
# Usage:
#   pwsh scripts/gen-dev-cookies.ps1
#   pwsh scripts/gen-dev-cookies.ps1 -PrivateKeyPath "C:\path\to\dev-cf-private.pem" -ExpiryHours 8

param(
  [string]$PrivateKeyPath = "dev-cf-private.pem",
  [string]$Domain         = "dev.mrbeefy.academy",
  [int]$ExpiryHours       = 24
)

$ErrorActionPreference = "Stop"

# Require PowerShell 7+ (pwsh). Windows PowerShell (5.1) can produce parsing/runtime
# errors and lacks required .NET APIs. Fail fast with an explanatory message.
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This script requires PowerShell 7+ (pwsh). Run using 'pwsh -File scripts/gen-dev-cookies.ps1' or install PowerShell 7+."
    exit 1
}

if (-not (Test-Path $PrivateKeyPath)) {
    Write-Error "Private key not found at '$PrivateKeyPath'. Pass -PrivateKeyPath to specify a different location."
    exit 1
}

# Get the CloudFront key pair ID for the dev environment
Write-Host "Looking up CloudFront key pair ID..."
$KeyPairId = aws cloudfront list-public-keys `
  --query "PublicKeyList.Items[?starts_with(Name, 'mrbeefy-dev-cf-public-key-')].Id | [0]" `
  --output text

if (-not $KeyPairId -or $KeyPairId -eq "None") {
    Write-Error "Could not find CloudFront public key 'mrbeefy-dev-cf-public-key'. Has the dev frontend been deployed?"
    exit 1
}

# Build the custom policy JSON (no extra whitespace — CloudFront is sensitive to formatting)
$Expiry   = [int][DateTimeOffset]::UtcNow.AddHours($ExpiryHours).ToUnixTimeSeconds()
$Resource = "https://${Domain}/*"
$Policy   = '{"Statement":[{"Resource":"' + $Resource + '","Condition":{"DateLessThan":{"AWS:EpochTime":' + $Expiry + '}}}]}'

# CloudFront base64 encoding: standard base64 with + -> -, / -> ~, = -> _
function ConvertTo-CfBase64([byte[]]$Bytes) {
    [Convert]::ToBase64String($Bytes) -replace '\+','-' -replace '/','~' -replace '=','_'
}

# Load private key and sign the policy with RSA-SHA1
# RSA.ImportFromPem requires .NET 5+ (PowerShell 7+)
$pemContent  = Get-Content $PrivateKeyPath -Raw
$rsa         = [System.Security.Cryptography.RSA]::Create()
$rsa.ImportFromPem($pemContent)

$policyBytes = [System.Text.Encoding]::UTF8.GetBytes($Policy)
$signature   = $rsa.SignData(
    $policyBytes,
    [System.Security.Cryptography.HashAlgorithmName]::SHA1,
    [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
)

$PolicyB64 = ConvertTo-CfBase64 $policyBytes
$SigB64    = ConvertTo-CfBase64 $signature

$ExpiryDisplay = [DateTimeOffset]::FromUnixTimeSeconds($Expiry).UtcDateTime.ToString("yyyy-MM-dd HH:mm:ss")

Write-Host ""
Write-Host "========================================="
Write-Host " CloudFront Signed Cookies — dev env"
Write-Host "========================================="
Write-Host " Domain  : $Domain"
$CurlCmd = "curl -v 'https://$Domain/' -H 'Cookie: CloudFront-Policy=$PolicyB64; CloudFront-Signature=$SigB64; CloudFront-Key-Pair-Id=$KeyPairId'"

# Use the format operator to avoid parser ambiguity (e.g., Windows PowerShell parsing of ${var}h)
Write-Host (" Expires : {0} UTC (+{1}h)" -f $ExpiryDisplay, $ExpiryHours)
Write-Host " Key ID  : $KeyPairId"
Write-Host ""
Write-Host "--- Browser (DevTools -> Application -> Cookies -> $Domain) ---"
Write-Host "Name                      Value"
Write-Host "CloudFront-Policy         $PolicyB64"
Write-Host "CloudFront-Signature      $SigB64"
Write-Host "CloudFront-Key-Pair-Id    $KeyPairId"
Write-Host ""
Write-Host "--- curl ---"
Write-Host $CurlCmd
Write-Host ""
