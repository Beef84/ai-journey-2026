[Source: Mrbeefy Workflow | Section: 3.5 Bedrock Agent Workflow]

### **3.5 Bedrock Agent Workflow**
1. The agent receives the request.
2. The agent performs a Knowledge Base search:
   - Embeds the query using Titan V2
   - Queries the S3 Vector Store
   - Retrieves relevant documents
3. The agent generates a response using Nova Pro, streamed back in chunks.