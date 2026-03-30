[Source: Mrbeefy Architecture]

### **7. Response flows back**
Agent (streaming) → Lambda (SSE) → CloudFront → Browser (live render)

---

# **10. Multi-Environment Architecture**

The system uses **Terraform workspaces** to maintain isolated environments within the same AWS account.

| Workspace | Domain | Access | Function URL |
|---|---|---|---|
| `default` (prod) | `mrbeefy.academy` | Public | Secret header required |
| `dev` | `dev.mrbeefy.academy` | Signed cookies required | Secret header required |