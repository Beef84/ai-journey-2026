- Associate KB with agent  
- Create alias if missing  
- Update Lambda environment variables (AGENT_ID, AGENT_ALIAS_ID, GATEWAY_SECRET)
- Store `function_url_domain` in SSM for frontend pipeline consumption

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

## **8.2 Terraform Does NOT Own**
- Agent versions  
- Agent aliases  
- KB ingestion jobs  
- Lambda environment variable updates for alias IDs  

These are handled by CI/CD to avoid drift and stale state.

---

# **9. End‑to‑End Request Flow**

### **1. User sends message from UI**
```
POST https://mrbeefy.academy/chat
```

### **2. CloudFront behavior matches `/chat`**
- Forwards request to the Lambda Function URL origin
- Injects `x-cloudfront-secret` custom header
- `compress = false` — ensures CloudFront does not buffer the streaming response

### **3. Lambda Function URL receives**
```