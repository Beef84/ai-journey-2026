*.tfstate.backup
```

If these lines are missing, add them before doing anything else.

---

## **9.5 First-Time Production Deploy Sequence**

> **Why this order matters:** The frontend Terraform needs the Lambda Function URL domain as an input variable. That value only exists after the backend is deployed. Do backend first, capture the output, then deploy frontend. After this first time, CI/CD handles the handoff via SSM automatically.

**Step 1 — Initialize and select the prod workspace (default):**
```bash
cd backend/IaC
terraform init
terraform workspace list        # confirm "default" exists
terraform workspace select default
```

**Step 2 — Deploy the backend:**
```bash
terraform apply
# Review the plan, type "yes" when prompted
```

**Step 3 — Capture the Lambda Function URL domain:**
```bash
terraform output function_url_domain
# Output looks like: abc123xyz.lambda-url.us-east-1.on.aws
# Copy this value — you need it in the next step
```

**Step 4 — Update the frontend tfvars with the captured domain:**

Open `frontend/IaC/terraform.tfvars` and fill in the value:
```hcl
gateway_secret      = "your-secret"
function_url_domain = "abc123xyz.lambda-url.us-east-1.on.aws"
```

**Step 5 — Deploy the frontend:**
```bash