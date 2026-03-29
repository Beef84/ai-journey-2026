[Source: Mrbeefy Governance | Section: 3.3 Knowledge Base Updates]

## **3.3 Knowledge Base Updates**
KB updates follow a strict workflow:

1. Update machine‑readable KB files in the repo  
2. CI/CD uploads files to the KB S3 bucket  
3. CI/CD starts a new ingestion job  
4. Bedrock updates the vector index  

Manual ingestion is not permitted.

---