3. Upload KB files to the KB S3 bucket.  
4. **Start a Knowledge Base ingestion job using the Bedrock ingestion API.**  
5. Associate the KB with the agent if needed.  
6. Create the agent alias if missing.  
7. Update Lambda environment variables: `AGENT_ID`, `AGENT_ALIAS_ID`, `GATEWAY_SECRET`.
8. Write `function_url_domain` and `knowledge_bucket` to SSM Parameter Store for downstream pipeline consumption.

### **6.3 Outputs**
- Updated infrastructure  
- Updated KB index  
- Updated agent alias  
- Updated Lambda runtime  
- Updated frontend  

---

# **7. Infrastructure Provisioning Workflow**

### **7.1 Terraform Apply**
Terraform provisions:

- S3 buckets
- IAM roles
- Lambda function definition
- Lambda Function URL
- CloudFront
- Route53
- ACM certificate
- Bedrock Agent (DRAFT)

### **7.2 Dependency Ordering**
Terraform ensures:

- ACM certificate validated before CloudFront  
- CloudFront created before Route53 alias  
- Lambda created before Function URL is configured
- IAM roles created before Bedrock Agent  

### **7.3 Outputs to CI/CD**
Terraform outputs:

- Agent ID
- KB ID
- Lambda function name
- Lambda Function URL domain
- CloudFront distribution domain
