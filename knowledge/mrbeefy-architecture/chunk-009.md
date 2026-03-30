[Source: Mrbeefy Architecture]

# **4. Compute Architecture (Lambda)**

## **4.1 Lambda Function**
- Runtime: **Node.js 20.x**
- Handler: `index.handler`
- Timeout: 30 seconds
- Deployed via CI/CD (zip artifact)
- Environment variables:
  - `AGENT_ID`
  - `AGENT_ALIAS_ID` (updated by CI/CD after alias creation)
  - `KB_ID` (updated by CI/CD after KB setup)
  - `GATEWAY_SECRET` (set by Terraform from `terraform.tfvars`, never committed)