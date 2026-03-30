[Source: Mrbeefy Workflow | Section: 9.7 Deploy the Dev Environment (Dev only)]

## **9.7 Deploy the Dev Environment** *(Dev only)*

The dev workspace creates a fully isolated parallel stack (`mrbeefy-dev-*`) at `dev.mrbeefy.academy`.

**Via CI/CD (recommended):**

1. Go to **GitHub Actions → deploy-backend → Run workflow**. Set `environment: dev`. This creates all backend resources including the `mrbeefy-dev-kb` Knowledge Base.
2. Go to **GitHub Actions → deploy-frontend → Run workflow**. Set `environment: dev`. This creates the CloudFront distribution, uploads the public key, and creates the key group.

Pushes to the `dev` branch trigger both pipelines automatically.

**Via Terraform locally (alternative):**

```bash