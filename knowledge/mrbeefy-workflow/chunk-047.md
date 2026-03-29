[Source: Mrbeefy Workflow | Section: 9.7 Deploy the Dev Environment (Dev only)]

## **9.7 Deploy the Dev Environment** *(Dev only)*

The dev workspace creates a fully isolated parallel stack (`mrbeefy-dev-*`) at `dev.mrbeefy.academy`. Follow the same backend-first order as prod.

**Backend dev:**
```bash
cd backend/IaC
terraform workspace new dev        # first time only — skip if already exists
terraform workspace select dev
terraform apply
terraform output function_url_domain