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

## **2.2 CI/CD Owns Dynamic Lifecycle**
GitHub Actions handles:

- KB ingestion  
- Agent alias creation (if missing)  
- Lambda environment variable updates  
- Deployment of Lambda code  
- Uploading KB files  

This ensures:

- No stale alias IDs  
- No Terraform drift  
- No accidental recreation of agents  
- Clean, predictable updates  

---

# **3. API Design Decisions**

## **3.1 Lambda Function URL Instead of API Gateway**

API Gateway was the original API layer. It was replaced with a Lambda Function URL when streaming was added.

**Why API Gateway could not stay:**
API Gateway HTTP API buffers the complete Lambda response before forwarding it to the client. This makes true SSE streaming impossible — the browser receives one large payload at the end rather than tokens as they arrive.

**Why Lambda Function URL:**