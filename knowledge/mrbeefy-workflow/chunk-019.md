[Source: Mrbeefy Workflow | Section: 9.1 Generate the Gateway Secret]

## **9.1 Generate the Gateway Secret**

> **What it is:** A shared secret that Lambda checks on every request. Any call to the raw Lambda Function URL without this header returns 403 immediately — Bedrock is never reached. CloudFront injects it automatically, so legitimate browser requests always pass.

Run this once in any terminal (PowerShell, Git Bash, WSL, or macOS/Linux shell — openssl is available in all of them):

```bash
openssl rand -hex 32
```

Copy the output. You will paste this same value into three places in the next two steps. **It must be identical in all three.**

---