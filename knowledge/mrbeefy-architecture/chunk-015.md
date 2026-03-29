[Source: Mrbeefy Architecture | Section: 4.1 Lambda Function]

## **4.1 Lambda Function**
- Runtime: **Node.js 20.x**
- Handler: `index.handler`
- Timeout: 30 seconds
- Deployed via CI/CD (zip artifact)
- Environment variables:
  - `AGENT_ID`
  - `AGENT_ALIAS_ID` (updated by CI/CD after alias creation)
  - `GATEWAY_SECRET` (set by Terraform from `terraform.tfvars`, never committed)