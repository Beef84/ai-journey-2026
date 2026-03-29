#!/usr/bin/env bash
# Generates CloudFront signed cookies for dev.mrbeefy.academy using openssl.
# Run from Git Bash with your dev-cf-private.pem.
#
# Usage:
#   bash scripts/gen-dev-cookies.sh /c/users/oberr/dev-cf-private.pem
#   bash scripts/gen-dev-cookies.sh /c/users/oberr/dev-cf-private.pem 8   # 8-hour expiry

set -euo pipefail

PRIVATE_KEY="${1:-}"
DOMAIN="dev.mrbeefy.academy"
EXPIRY_HOURS="${2:-24}"

if [ -z "$PRIVATE_KEY" ]; then
  echo "Usage: bash scripts/gen-dev-cookies.sh <path-to-dev-cf-private.pem> [expiry-hours]"
  exit 1
fi

if [ ! -f "$PRIVATE_KEY" ]; then
  echo "ERROR: Private key not found at '$PRIVATE_KEY'"
  exit 1
fi

echo "Looking up CloudFront key pair ID..."
KEY_PAIR_ID=$(MSYS_NO_PATHCONV=1 aws cloudfront list-public-keys \
  --query "PublicKeyList.Items[?Name=='mrbeefy-dev-cf-public-key'].Id | [0]" \
  --output text)

if [ -z "$KEY_PAIR_ID" ] || [ "$KEY_PAIR_ID" = "None" ]; then
  echo "ERROR: Could not find CloudFront public key 'mrbeefy-dev-cf-public-key'."
  exit 1
fi

# Expiry: seconds since epoch
EXPIRY=$(date -d "+${EXPIRY_HOURS} hours" +%s)
EXPIRY_DISPLAY=$(date -d "@${EXPIRY}" -u "+%Y-%m-%d %H:%M:%S")

# Custom policy JSON — no whitespace, exact format required by CloudFront
POLICY='{"Statement":[{"Resource":"https://'"$DOMAIN"'/*","Condition":{"DateLessThan":{"AWS:EpochTime":'"$EXPIRY"'}}}]}'

# CloudFront base64: standard base64 with + -> -, / -> ~, = -> _
cf_base64() {
  openssl base64 | tr -d '\n' | tr '+/' '-~' | tr '=' '_'
}

POLICY_B64=$(echo -n "$POLICY" | cf_base64)
SIG_B64=$(echo -n "$POLICY" | openssl dgst -sha1 -sign "$PRIVATE_KEY" -binary | cf_base64)

echo ""
echo "========================================="
echo " CloudFront Signed Cookies — dev env"
echo "========================================="
echo " Domain  : $DOMAIN"
echo " Expires : $EXPIRY_DISPLAY UTC (+${EXPIRY_HOURS}h)"
echo " Key ID  : $KEY_PAIR_ID"
echo ""
echo "--- Browser (DevTools > Application > Cookies > $DOMAIN) ---"
echo "Name                       Value"
echo "CloudFront-Policy          $POLICY_B64"
echo "CloudFront-Signature       $SIG_B64"
echo "CloudFront-Key-Pair-Id     $KEY_PAIR_ID"
echo ""
echo "--- curl ---"
echo "curl -v 'https://$DOMAIN/' -H 'Cookie: CloudFront-Policy=$POLICY_B64; CloudFront-Signature=$SIG_B64; CloudFront-Key-Pair-Id=$KEY_PAIR_ID'"
echo ""
