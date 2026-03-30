[Source: Mrbeefy Workflow]

## **9.9 Manual Cookie Setup (Fallback)** *(Dev only)*

If the automated script is unavailable, set cookies manually via DevTools.

Run the generator to get the values:

```powershell

# PowerShell 7+ (pwsh) — required; gen-dev-cookies.ps1 uses .NET RSA APIs not available in Windows PowerShell 5.1
pwsh -File scripts/gen-dev-cookies.ps1 -PrivateKeyPath "C:\path\to\dev-cf-private.pem"
```

```bash