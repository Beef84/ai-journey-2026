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

## **9.4 Verify .gitignore Covers the Secret Files**

> **Why:** If `terraform.tfvars` is accidentally committed, the gateway secret is exposed in git history. Verify this before running any git commands.

In both `backend/IaC/` and `frontend/IaC/`, confirm `.gitignore` contains at minimum:

```
terraform.tfvars
.terraform/
*.tfstate