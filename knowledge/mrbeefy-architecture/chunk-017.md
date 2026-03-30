[Source: Mrbeefy Architecture]

## **7.2 Why CI/CD Owns This**
- Bedrock agent versions and aliases are dynamic  
- Terraform cannot safely manage them without drift  
- CI/CD ensures clean, deterministic updates  

---

# **8. Terraform Architecture**

## **8.1 Terraform Owns**
- S3 buckets
- IAM roles and policies
- Lambda function (static definition)
- Lambda Function URL
- CloudFront
- Route53
- ACM certificate
- Bedrock Agent (DRAFT definition only)