[Source: Mrbeefy Workflow | Section: 9.2 Add GitHub Repository Secrets]

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