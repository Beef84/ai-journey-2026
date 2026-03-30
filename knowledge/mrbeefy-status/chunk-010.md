[Source: Mrbeefy Status | Section: What Changed > Signed Cookie Automation (`scripts/open-dev.ps1` / `scripts/open-dev.sh`)]

### **Signed Cookie Automation (`scripts/open-dev.ps1` / `scripts/open-dev.sh`)**
Cookie generation and browser injection are now a single command. The scripts:

- Look up the current CloudFront key pair ID from AWS automatically
- Sign a custom policy using `openssl` (no npm packages required)
- Launch Edge with remote debugging (separate profile — does not affect the normal session)
- Set all three cookies directly in Edge via Chrome DevTools Protocol WebSocket
- Navigate to `dev.mrbeefy.academy`

Cookies default to a **30-day expiry**. Since the key pair ID only changes when the PEM is rotated and the frontend is redeployed, the script only needs to be re-run on that rare event — not on every code push.

Supporting scripts `gen-dev-cookies.sh` and `gen-dev-cookies.ps1` produce the cookie values and a curl command for cases where the automated approach is not needed.