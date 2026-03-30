# Opens dev.mrbeefy.academy in Edge with CloudFront signed cookies pre-set via CDP.
# Generates signed cookies using openssl.exe (from Git for Windows), then sets them
# in Edge automatically via Chrome DevTools Protocol. Requires node.js.
#
# Usage:
#   powershell -File scripts/open-dev.ps1 -PrivateKeyPath "C:\users\oberr\dev-cf-private.pem"
#   powershell -File scripts/open-dev.ps1 -PrivateKeyPath "C:\users\oberr\dev-cf-private.pem" -PrintOnly
#
# -PrintOnly: generate and print cookie values for manual DevTools setup (no Edge launched)

param(
  [string]$PrivateKeyPath = "dev-cf-private.pem",
  [string]$Domain         = "dev.mrbeefy.academy",
  [int]$ExpiryHours       = 720,
  [int]$CdpPort           = 9222,
  [switch]$PrintOnly,
  [switch]$ThirtyDays
)

if ($ThirtyDays) { $ExpiryHours = 720 }

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- Validate ---
if (-not (Test-Path $PrivateKeyPath)) {
    Write-Error "Private key not found at '$PrivateKeyPath'. Pass -PrivateKeyPath to specify a different location."
    exit 1
}

if (-not $PrintOnly -and -not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "node not found. Install Node.js to use this script."
    exit 1
}

if (-not (Get-Command openssl -ErrorAction SilentlyContinue)) {
    Write-Error "openssl not found. Install Git for Windows (it includes openssl.exe)."
    exit 1
}

# --- Look up key pair ID ---
Write-Host "Looking up CloudFront key pair ID..."
$KeyPairId = aws cloudfront list-public-keys `
  --query "PublicKeyList.Items[?starts_with(Name, 'mrbeefy-dev-cf-public-key-')].Id | [0]" `
  --output text

if (-not $KeyPairId -or $KeyPairId -eq "None") {
    Write-Error "Could not find CloudFront public key. Has the dev frontend been deployed?"
    exit 1
}

# --- Build policy and sign with openssl ---
$Expiry   = [int][DateTimeOffset]::UtcNow.AddHours($ExpiryHours).ToUnixTimeSeconds()
$Policy   = '{"Statement":[{"Resource":"https://' + $Domain + '/*","Condition":{"DateLessThan":{"AWS:EpochTime":' + $Expiry + '}}}]}'

$TempDir = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } elseif ($env:TEMP) { $env:TEMP } else { $env:TMP }

$PolicyFile = Join-Path $TempDir "cf-policy.txt"
$SigFile    = Join-Path $TempDir "cf-sig.bin"

[System.IO.File]::WriteAllText($PolicyFile, $Policy, (New-Object System.Text.UTF8Encoding $false))

# CloudFront base64: standard base64 with +->-, /->~, =->_
function ConvertTo-CfBase64([string]$InputFile) {
    $b64 = (& openssl base64 -in $InputFile) -join ""
    return $b64 -replace '\+','-' -replace '/','~' -replace '=','_'
}

$PolicyB64 = ConvertTo-CfBase64 $PolicyFile

# Sign: openssl dgst -sha1 -sign <key> -binary -out <sig> <input>
& openssl dgst -sha1 -sign $PrivateKeyPath -binary -out $SigFile $PolicyFile
if ($LASTEXITCODE -ne 0) { Write-Error "openssl signing failed."; exit 1 }

$SigB64 = ConvertTo-CfBase64 $SigFile

Remove-Item $PolicyFile, $SigFile -ErrorAction SilentlyContinue

$ExpiryDisplay = [DateTimeOffset]::FromUnixTimeSeconds($Expiry).UtcDateTime.ToString("yyyy-MM-dd HH:mm:ss")

Write-Host ""
Write-Host "========================================="
Write-Host " CloudFront Signed Cookies - dev env"
Write-Host "========================================="
Write-Host " Domain  : $Domain"
Write-Host (" Expires : " + $ExpiryDisplay + " UTC (+" + $ExpiryHours + "h)")
Write-Host " Key ID  : $KeyPairId"
Write-Host ""
$MaxAge = $ExpiryHours * 3600
$CookieAttrs = "domain=$Domain; path=/; secure; max-age=$MaxAge"

Write-Host "--- DevTools Console (navigate to https://$Domain first, then paste) ---"
Write-Host ("document.cookie = " + '"' + "CloudFront-Policy=$PolicyB64; $CookieAttrs" + '";')
Write-Host ("document.cookie = " + '"' + "CloudFront-Signature=$SigB64; $CookieAttrs" + '";')
Write-Host ("document.cookie = " + '"' + "CloudFront-Key-Pair-Id=$KeyPairId; $CookieAttrs" + '";')
Write-Host "location.reload();"
Write-Host ""

if ($PrintOnly) { exit 0 }

# --- Start Edge with CDP remote debugging if not already running ---
$cdpActive = $false
try {
    $null = Invoke-RestMethod "http://localhost:$CdpPort/json/version" -TimeoutSec 2
    $cdpActive = $true
} catch {}

if ($cdpActive) {
    Write-Host "CDP already active on port $CdpPort - reusing existing Edge session."
} else {
    Write-Host "Starting Edge with remote debugging on port $CdpPort..."

    $ProgFilesX86 = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)")
    $EdgePaths = @(
        "$ProgFilesX86\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    )
    $EdgeExe = $EdgePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $EdgeExe) {
        Write-Error "Microsoft Edge not found. Start it manually with: msedge.exe --remote-debugging-port=$CdpPort"
        exit 1
    }

    # Use a timestamp-suffixed profile dir so there's never a conflicting Edge
    # instance already running with this profile (which causes Edge to hand off
    # to the existing process and exit immediately with code 0).
    $stamp = Get-Date -Format "yyyyMMddHHmmss"
    $EdgeProfile = Join-Path $env:TEMP "edge-cdp-$stamp"

    # Clean up debug profiles older than 7 days to avoid accumulation.
    Get-ChildItem $env:TEMP -Directory -Filter "edge-cdp-*" -ErrorAction SilentlyContinue |
        Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-7) } |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    $edgeArgs = "--remote-debugging-port=$CdpPort --user-data-dir=`"$EdgeProfile`" --no-first-run --no-default-browser-check about:blank"
    $edgeProc = Start-Process $EdgeExe -ArgumentList $edgeArgs -PassThru

    Write-Host -NoNewline "Waiting for Edge to start"
    $ready = $false
    for ($i = 0; $i -lt 15; $i++) {
        Start-Sleep -Seconds 1
        if ($edgeProc.HasExited) {
            Write-Host ""
            Write-Error "Edge process exited unexpectedly (code $($edgeProc.ExitCode)). Try launching manually - see below."
            break
        }
        try {
            $null = Invoke-RestMethod "http://localhost:$CdpPort/json/version" -TimeoutSec 1
            $ready = $true
            break
        } catch {}
        Write-Host -NoNewline "."
    }
    Write-Host ""
    if (-not $ready) {
        Write-Host ""
        Write-Host "Tip: open a new terminal and run this, then re-run open-dev.ps1:"
        Write-Host "  & `"$EdgeExe`" --remote-debugging-port=$CdpPort --user-data-dir=`"$EdgeProfile`" about:blank"
        Write-Error "Edge did not expose CDP on port $CdpPort."
        exit 1
    }
}

# --- Set cookies and navigate via CDP ---
Write-Host "Setting cookies in Edge..."
$SetCookiesScript = Join-Path $ScriptDir "set-cf-cookies.js"
& node $SetCookiesScript $Domain $KeyPairId $PolicyB64 $SigB64 $Expiry
if ($LASTEXITCODE -ne 0) { exit 1 }
