[Source: Mrbeefy Workflow]

# Git Bash
bash scripts/gen-dev-cookies.sh /c/path/to/dev-cf-private.pem
```

Then open Edge, navigate to `https://dev.mrbeefy.academy`, open **DevTools** (`F12`) → **Application** → **Cookies** → `https://dev.mrbeefy.academy`, and add each cookie:

| Name | Value | Domain | Path | Secure |
|---|---|---|---|---|
| `CloudFront-Policy` | (from script output) | `dev.mrbeefy.academy` | `/` | ✓ |
| `CloudFront-Signature` | (from script output) | `dev.mrbeefy.academy` | `/` | ✓ |
| `CloudFront-Key-Pair-Id` | (from script output) | `dev.mrbeefy.academy` | `/` | ✓ |

Hard-refresh (`Ctrl+Shift+R`).

> **When to re-run:** Only when the CloudFront public key is rotated (new PEM generated + frontend redeployed). Pushing code to dev does not invalidate cookies.

---