#!/usr/bin/env bash
# Opens dev.mrbeefy.academy in Edge with CloudFront signed cookies pre-set via CDP.
# Generates the signed cookies using openssl, starts Edge with remote debugging
# (in a separate profile so it doesn't conflict with your normal session),
# then sets the cookies and navigates automatically.
#
# Requires: openssl, aws CLI, node.js
#
# Usage:
#   bash scripts/open-dev.sh [path-to-dev-cf-private.pem] [expiry-hours]
#   bash scripts/open-dev.sh /c/users/oberr/dev-cf-private.pem 8

set -euo pipefail

PRIVATE_KEY="${1:-dev-cf-private.pem}"
DOMAIN="dev.mrbeefy.academy"
EXPIRY_HOURS="${2:-24}"
CDP_PORT=9222
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Validate ---
if [ ! -f "$PRIVATE_KEY" ]; then
  echo "ERROR: Private key not found at '$PRIVATE_KEY'"
  echo "Usage: bash scripts/open-dev.sh <path-to-dev-cf-private.pem> [expiry-hours]"
  exit 1
fi

if ! command -v node &>/dev/null; then
  echo "ERROR: node not found. Install Node.js to use this script."
  exit 1
fi

# --- Generate CloudFront signed cookies ---
echo "Looking up CloudFront key pair ID..."
KEY_PAIR_ID=$(MSYS_NO_PATHCONV=1 aws cloudfront list-public-keys \
  --query "PublicKeyList.Items[?starts_with(Name, 'mrbeefy-dev-cf-public-key-')].Id | [0]" \
  --output text)

if [ -z "$KEY_PAIR_ID" ] || [ "$KEY_PAIR_ID" = "None" ]; then
  echo "ERROR: Could not find CloudFront public key. Has the dev frontend been deployed?"
  exit 1
fi

EXPIRY=$(date -d "+${EXPIRY_HOURS} hours" +%s)
POLICY='{"Statement":[{"Resource":"https://'"$DOMAIN"'/*","Condition":{"DateLessThan":{"AWS:EpochTime":'"$EXPIRY"'}}}]}'

cf_base64() {
  openssl base64 | tr -d '\n' | tr '+/' '-~' | tr '=' '_'
}

POLICY_B64=$(echo -n "$POLICY" | cf_base64)
SIG_B64=$(echo -n "$POLICY" | openssl dgst -sha1 -sign "$PRIVATE_KEY" -binary | cf_base64)

echo "Cookies generated (key: $KEY_PAIR_ID, expires in ${EXPIRY_HOURS}h)"

# --- Start Edge with CDP remote debugging if not already running ---
if (echo > /dev/tcp/localhost/$CDP_PORT) 2>/dev/null; then
  echo "CDP already active on port $CDP_PORT — reusing existing Edge session."
else
  echo "Starting Edge with remote debugging on port $CDP_PORT..."

  EDGE_EXE=""
  for p in \
    "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
    "/c/Program Files/Microsoft/Edge/Application/msedge.exe"
  do
    [ -f "$p" ] && EDGE_EXE="$p" && break
  done

  if [ -z "$EDGE_EXE" ]; then
    echo "ERROR: Microsoft Edge not found at standard paths."
    echo "Start Edge manually with: msedge.exe --remote-debugging-port=$CDP_PORT"
    exit 1
  fi

  # Separate user-data-dir so this doesn't interfere with your normal Edge profile.
  EDGE_PROFILE="${TEMP}\\edge-debug-profile"
  "$EDGE_EXE" \
    --remote-debugging-port=$CDP_PORT \
    --user-data-dir="$EDGE_PROFILE" \
    "about:blank" &

  echo -n "Waiting for Edge to start"
  for i in $(seq 1 10); do
    sleep 1
    if (echo > /dev/tcp/localhost/$CDP_PORT) 2>/dev/null; then
      echo " ready."
      break
    fi
    echo -n "."
    if [ "$i" -eq 10 ]; then
      echo ""
      echo "ERROR: Edge did not expose CDP on port $CDP_PORT after 10s."
      exit 1
    fi
  done
fi

# --- Set cookies and navigate ---
echo "Setting cookies in Edge..."
node "$SCRIPT_DIR/set-cf-cookies.js" \
  "$DOMAIN" "$KEY_PAIR_ID" "$POLICY_B64" "$SIG_B64" "$EXPIRY"
