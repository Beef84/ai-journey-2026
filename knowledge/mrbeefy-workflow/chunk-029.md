[Source: Mrbeefy Workflow | Section: 7.2 Dependency Ordering]

### **7.2 Dependency Ordering**
Terraform ensures:

- ACM certificate validated before CloudFront  
- CloudFront created before Route53 alias  
- Lambda created before Function URL is configured
- IAM roles created before Bedrock Agent