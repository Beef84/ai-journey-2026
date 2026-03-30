[Source: Mrbeefy Status]

# **🔐 Multi-Environment Support and Security Hardening**

## **Overview**
The platform now supports two fully isolated environments within the same AWS account using Terraform workspaces: `default` (prod) and `dev`. Alongside this, the API backend — previously reachable by anyone who discovered the URL — is protected in both environments.

---