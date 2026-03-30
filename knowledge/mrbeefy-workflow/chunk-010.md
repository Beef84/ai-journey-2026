[Source: Mrbeefy Workflow | Section: 4.2 Ingestion Workflow]

### **4.2 Ingestion Workflow**
**Exact behavior (no vague phrasing):**

1. CI/CD uploads the `/knowledge` directory to the KB S3 bucket.
2. CI/CD calls the Bedrock Knowledge Base ingestion API to start a new ingestion job.
3. Bedrock performs the ingestion process:
   - Reads documents from the KB S3 bucket
   - Generates embeddings using Titan V2
   - Writes vectors to the S3 Vector Store
   - Updates the vector index