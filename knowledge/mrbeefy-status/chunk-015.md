[Source: Mrbeefy Status | Section: What Changed > Dev Environment]

### **Dev Environment**
A `dev` Terraform workspace creates a fully isolated parallel stack:

- All AWS resources prefixed `mrbeefy-dev-*`
- Hosted at `dev.mrbeefy.academy`
- Own Terraform state (`env:/dev/...` in the same S3 bucket)
- Requires the developer to set up signed cookies to access it