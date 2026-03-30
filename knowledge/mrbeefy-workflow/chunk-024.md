[Source: Mrbeefy Workflow | Section: 9.5 First-Time Production Deploy Sequence]

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