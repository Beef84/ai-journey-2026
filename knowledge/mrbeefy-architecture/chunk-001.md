[Source: Mrbeefy Architecture]

# **🏗️ Mr. Beefy — System Architecture (Final Production Design)**  
*Comprehensive technical overview of the deployed system*

---

# **1. High‑Level Architecture Overview**

Mr. Beefy is a fully serverless, event‑driven AI agent platform built on AWS.  
The system consists of four major layers:

1. **Frontend Delivery Layer**  
   - CloudFront distribution  
   - S3 static hosting with Origin Access Control (OAC)  
   - Custom domain + ACM certificate + Route53  

2. **API Layer**
   - Lambda Function URL with response streaming (`invoke_mode = RESPONSE_STREAM`)
   - CloudFront → Function URL integration
   - `/chat` routed directly to Lambda with no intermediate gateway

3. **Compute Layer**
   - Node.js 20 Lambda function with `awslambda.streamifyResponse`
   - Bedrock Agent Runtime client streaming SSE chunks as they arrive
   - Environment variables for Agent ID, Alias ID, and Gateway Secret

4. **AI Layer**  
   - Bedrock Agent  
   - Bedrock Knowledge Base  
   - Titan V2 embeddings  
   - S3 Vector Store  
   - IAM roles for agent execution + KB ingestion  

All infrastructure is deployed via **Terraform**, with dynamic agent lifecycle operations handled by **GitHub Actions CI/CD**.

---