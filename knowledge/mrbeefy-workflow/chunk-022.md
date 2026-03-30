[Source: Mrbeefy Workflow | Section: 9.3 Create Local Terraform Variable Files (only needed for manual local deploys)]

## **9.3 Create Local Terraform Variable Files** *(only needed for manual local deploys)*

> **What these are:** The CI/CD pipelines receive `gateway_secret` directly from GitHub secrets and pass it to Terraform via `-var` flags — no local file needed for pipeline runs. These `terraform.tfvars` files are only required if you run `terraform apply` manually from your own machine. If you always deploy through CI/CD, you can skip this step entirely.

If you do want to run Terraform locally, create these files. They must never be committed.

**`backend/IaC/terraform.tfvars`:**
```hcl
gateway_secret = "paste-your-value-from-9.1-here"
```

**`frontend/IaC/terraform.tfvars`:**
```hcl
gateway_secret      = "paste-your-value-from-9.1-here"
function_url_domain = ""
```

> Leave `function_url_domain` blank for now. You will fill it in after the first backend deploy in step 9.5.

---