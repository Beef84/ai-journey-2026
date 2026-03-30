[Source: Mrbeefy Workflow | Section: 9.8 Open Dev in Browser with Signed Cookies (Dev only)]

## **9.8 Open Dev in Browser with Signed Cookies** *(Dev only)*

> **What this does:** Generates three CloudFront signed cookies using your private key and sets them directly in Edge via Chrome DevTools Protocol — no manual copy-paste required. Cookies default to a **30-day expiry**, so you only need to re-run this when the key pair rotates (i.e., when you change the PEM and redeploy the frontend). Pushing code to dev does not require new cookies.

**Requirements:** Node.js, `openssl.exe` (included with Git for Windows), AWS CLI configured.

Run from PowerShell in the repo root:

```powershell
powershell -File scripts/open-dev.ps1 -PrivateKeyPath "C:\path\to\dev-cf-private.pem"
```

Or from Git Bash:

```bash
bash scripts/open-dev.sh /c/path/to/dev-cf-private.pem
```

The script:
1. Looks up the CloudFront key pair ID from AWS
2. Signs a custom policy using openssl
3. Launches a fresh Edge instance with remote debugging enabled (separate profile — does not affect your normal Edge session)
4. Sets the three cookies via CDP WebSocket
5. Navigates Edge to `https://dev.mrbeefy.academy`

**To generate cookies only** (without opening Edge), use `scripts/gen-dev-cookies.sh` or `scripts/gen-dev-cookies.ps1` — they print the values and a ready-to-use curl command.

---