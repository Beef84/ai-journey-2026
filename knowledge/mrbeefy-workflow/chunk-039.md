[Source: Mrbeefy Workflow | Section: 9.4 Verify .gitignore Covers the Secret Files]

## **9.4 Verify .gitignore Covers the Secret Files**

> **Why:** If `terraform.tfvars` is accidentally committed, the gateway secret is exposed in git history. Verify this before running any git commands.

In both `backend/IaC/` and `frontend/IaC/`, confirm `.gitignore` contains at minimum:

```
terraform.tfvars
.terraform/
*.tfstate
*.tfstate.backup
```

If these lines are missing, add them before doing anything else.

---