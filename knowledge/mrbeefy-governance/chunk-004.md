[Source: Mrbeefy Governance | Section: 2.1 Infrastructure Ownership (Terraform)]

## **2.1 Infrastructure Ownership (Terraform)**
Terraform owns:

- S3 buckets  
- CloudFront distribution  
- Route53 DNS records  
- ACM certificates  
- Lambda Function URL
- Lambda function definition
- IAM roles and policies  
- Bedrock Agent (DRAFT definition only)  

Terraform is the **single source of truth** for all static, long‑lived infrastructure.

Terraform does **not** own:

- Agent versions  
- Agent aliases  
- KB ingestion jobs  
- Lambda environment variable updates for alias IDs  

These are dynamic and governed by CI/CD.

---