- The SPA loads instantly  
- API calls bypass caching  
- Only the intended path hits the backend  

---

# **5. Lambda Design Decisions**

## **5.1 Node.js 20 Runtime**
Chosen for:

- Fast cold starts  
- Native AWS SDK v3 support  
- Simple JSON handling  
- Lightweight deployment package  

## **5.2 Minimal Responsibility**
Lambda does not:

- Perform retrieval  
- Perform embeddings  
- Manage KB ingestion  
- Manage agent versions  

Lambda only:

- Accepts user input  
- Calls Bedrock Agent Runtime  
- Returns the response  

This keeps the function small, predictable, and low-maintenance.

## **5.3 Environment Variables**
Lambda receives:

- `AGENT_ID`  
- `AGENT_ALIAS_ID`  

These are updated by CI/CD to avoid Terraform drift.

---

# **6. Bedrock Agent Design Decisions**

## **6.1 Nova Pro for Reasoning**
Nova Pro was selected because:

- Strong reasoning capabilities  
- Fast response times  
- High-quality output for agent workflows  

## **6.2 Titan V2 for Embeddings**
Titan V2 was chosen because:

- High-quality text embeddings  
- Native integration with S3 Vector Store  
- Optimized for retrieval tasks  

## **6.3 Knowledge Base as the First Source of Truth**
The agent is instructed to:

- Always search the KB first  