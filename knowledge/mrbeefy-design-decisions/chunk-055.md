[Source: Mrbeefy Design Decisions | Section: 13.2 Secret Management: terraform.tfvars (Gitignored)]

## **13.2 Secret Management: terraform.tfvars (Gitignored)**

The `gateway_secret` value is set via `terraform.tfvars` in each IaC directory. These files are gitignored and never committed. The value is stored in Terraform state (already encrypted at rest in S3 with DynamoDB locking) and injected into the Lambda environment by Terraform.

This avoids SSM costs and complexity for a personal project while keeping the secret out of source control.