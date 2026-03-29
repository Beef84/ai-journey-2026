[Source: Mrbeefy Governance | Section: 4.4 Secret Governance]

## **4.4 Secret Governance**
- `gateway_secret` is set in `terraform.tfvars` (gitignored) in both `backend/IaC/` and `frontend/IaC/`
- The same value must be used in both stacks
- The secret lives in Terraform state, which is encrypted at rest in S3
- The CloudFront signed-cookie private key is stored only on the developer's local machine and is never committed
- `terraform.tfvars` files must be added to `.gitignore` — committing them exposes the secret