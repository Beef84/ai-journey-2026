[Source: Mrbeefy Workflow]

### **3.4 Lambda Calls Bedrock**
1. Lambda initializes the Bedrock Agent Runtime client.
2. Lambda invokes the Bedrock Agent using the stored `AGENT_ID` and `AGENT_ALIAS_ID`.
3. The agent call returns an async event stream.

### **3.5 Bedrock Agent Workflow**
1. The agent receives the request.
2. The agent performs a Knowledge Base search:
   - Embeds the query using Titan V2
   - Queries the S3 Vector Store
   - Retrieves relevant documents
3. The agent generates a response using Nova Pro, streamed back in chunks.