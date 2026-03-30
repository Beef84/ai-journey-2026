[Source: Mrbeefy Workflow]

# **4. Knowledge Base Workflow**

### **4.1 KB File Management**
1. Machine‑readable KB files are stored in a dedicated folder in the repository.  
2. CI/CD uploads these files to the Knowledge Base S3 bucket.

### **4.2 Ingestion Workflow**
**Exact behavior (no vague phrasing):**

1. CI/CD calls the Bedrock Knowledge Base ingestion API to start a new ingestion job.  
2. Bedrock performs the ingestion process:
   - Reads documents from the KB S3 bucket  
   - Generates embeddings using Titan V2  
   - Writes vectors to the S3 Vector Store  
   - Updates the vector index