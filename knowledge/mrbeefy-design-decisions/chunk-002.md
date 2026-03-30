[Source: Mrbeefy Design Decisions]

# **2. Infrastructure Ownership Model**

## **2.1 Terraform Owns Static Infrastructure**
Terraform manages all resources that are:

- Declarative  
- Long‑lived  
- Stable  
- Not subject to frequent versioning  

This includes:

- S3 buckets (frontend + knowledge)
- CloudFront distribution
- Route53 records
- ACM certificate
- Lambda function definition
- Lambda Function URL
- IAM roles and policies
- Bedrock Agent (DRAFT definition only)

Terraform **does not** manage:

- Agent versions  
- Agent aliases  
- KB ingestion jobs  
- Lambda environment variable updates for alias IDs  

These are dynamic and would cause drift if managed declaratively.