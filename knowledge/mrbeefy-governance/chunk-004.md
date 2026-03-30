[Source: Mrbeefy Governance | Section: 2.3 Runtime Ownership (AWS Services)]

## **2.3 Runtime Ownership (AWS Services)**

At runtime:

- **CloudFront** owns request routing and caching
- **Lambda Function URL** owns request receipt and secret validation
- **Lambda** owns request processing and Bedrock invocation
- **Bedrock Agent** owns reasoning and retrieval  
- **Bedrock Knowledge Base** owns vector search and document retrieval  

Each service is responsible for its own operational behavior, with no cross‑service responsibilities.

---