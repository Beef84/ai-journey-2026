[Source: Mrbeefy Design Decisions | Section: 13.4 Multi-Environment Strategy: Terraform Workspaces]

## **13.4 Multi-Environment Strategy: Terraform Workspaces**

Terraform workspaces were chosen over separate directories or separate accounts because:

- **Same account:** No cross-account IAM complexity for a personal project
- **Workspace-aware naming:** `terraform.workspace` drives the resource prefix, keeping dev and prod fully isolated by name
- **Automatic state isolation:** Each workspace gets its own state key in S3 with no extra configuration
- **Minimal code duplication:** One set of Terraform files serves all environments

The `default` workspace maps to prod, preserving all existing resource names with no migration needed.

---