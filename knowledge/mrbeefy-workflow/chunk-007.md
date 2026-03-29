> **What it is:** A shared secret that Lambda checks on every request. Any call to the raw Lambda Function URL without this header returns 403 immediately — Bedrock is never reached. CloudFront injects it automatically, so legitimate browser requests always pass.

Run this once in any terminal (PowerShell, Git Bash, WSL, or macOS/Linux shell — openssl is available in all of them):

```bash
openssl rand -hex 32
```

Copy the output. You will paste this same value into three places in the next two steps. **It must be identical in all three.**

---

## **9.2 Add GitHub Repository Secrets**

> **What these are:** GitHub Actions injects these into every CI/CD run. Without them the pipelines cannot authenticate to AWS or protect the Lambda endpoint.

Go to: **GitHub repo → Settings → Secrets and Variables → Actions → New repository secret**

Add all three:

| Secret Name | Where to get the value |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user in AWS Console → Security credentials |
| `AWS_SECRET_ACCESS_KEY` | Same IAM user — only shown once at creation |
| `GATEWAY_SECRET` | The value you generated in step 9.1 |

> **Never** put these values in code or commit them to the repository.

---
