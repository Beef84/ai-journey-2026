- Lambda Function URL enforces HTTPS
- No public S3 access
- No public KB access
- Lambda Function URL is protected by a shared secret header — direct calls without the header return 403
- Dev CloudFront distribution is protected by CloudFront signed cookies — unauthenticated requests return 403

---

## **4.4 Secret Governance**
- `gateway_secret` is set in `terraform.tfvars` (gitignored) in both `backend/IaC/` and `frontend/IaC/`
- The same value must be used in both stacks
- The secret lives in Terraform state, which is encrypted at rest in S3
- The CloudFront signed-cookie private key is stored only on the developer's local machine and is never committed
- `terraform.tfvars` files must be added to `.gitignore` — committing them exposes the secret

## **4.3 Data Governance**
- KB files are stored in S3 with restricted access  
- Vector store is fully managed by Bedrock  
- No PII or sensitive data is stored in logs  
- No user messages are persisted outside CloudWatch logs  

---

# **5. Operational Governance**

## **5.1 Logging**
- Lambda logs are required
- CloudFront logs are optional but recommended

Logs must not contain:

- Secrets  
- Credentials  
- AWS account identifiers  
- Sensitive personal data  
