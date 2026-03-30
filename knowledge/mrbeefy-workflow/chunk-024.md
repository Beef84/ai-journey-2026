[Source: Mrbeefy Workflow]

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
cd frontend/IaC
terraform init
terraform workspace select default
terraform apply
```

After this first successful deploy, the backend pipeline writes `function_url_domain` to SSM on every run. The frontend pipeline reads it from SSM. You never need to copy it manually again.

---