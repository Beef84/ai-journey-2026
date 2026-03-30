[Source: Mrbeefy Status | Section: What Changed]

## **What Changed**

### **Lambda Function URL Protected by Secret Header**
API Gateway was replaced by a Lambda Function URL (required for SSE streaming). The raw Function URL (`https://{id}.lambda-url.us-east-1.on.aws`) is publicly reachable by default. It is now protected by a shared secret:

- CloudFront injects an `x-cloudfront-secret` header on every request it forwards to the Function URL origin
- Lambda validates this header and returns 403 for any request missing it
- Direct Function URL access without the secret is rejected immediately — no Bedrock call is made
- The secret lives in Terraform state and GitHub secrets — it is never committed to the repository

This applies to both prod and dev.