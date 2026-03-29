[Source: Mrbeefy Workflow | Section: 9.9 Set the Cookie in Your Browser (Dev only)]

## **9.9 Set the Cookie in Your Browser** *(Dev only)*

Open Chrome or Edge and navigate to `https://dev.mrbeefy.academy`.

Open **DevTools** (`F12`) → **Application** tab → **Cookies** (left sidebar) → `https://dev.mrbeefy.academy`

Click the **+** button and add each cookie exactly as shown:

| Name | Value | Domain | Path | Secure |
|---|---|---|---|---|
| `CloudFront-Policy` | (from step 9.8) | `dev.mrbeefy.academy` | `/` | ✓ |
| `CloudFront-Signature` | (from step 9.8) | `dev.mrbeefy.academy` | `/` | ✓ |
| `CloudFront-Key-Pair-Id` | (from step 9.8) | `dev.mrbeefy.academy` | `/` | ✓ |

Hard-refresh the page (`Ctrl+Shift+R`). The site loads normally.

> **When cookies expire:** Repeat steps 9.8 and 9.9 only. The infrastructure and key pair do not need to be recreated.

> **Testing from a new browser or device:** Repeat steps 9.8 and 9.9 on that browser. The private key must be accessible wherever you run the signing command.

---