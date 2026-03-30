[Source: Mrbeefy Architecture]

### **5. Lambda streams SSE chunks**
- Each Bedrock chunk is written to the response stream immediately as `data: {"token": "..."}\n\n`
- Browser receives and renders tokens progressively — no waiting for full response

### **6. Bedrock Agent**
- Searches Knowledge Base
- Retrieves relevant documents
- Generates response via Claude 3.5 Haiku (streamed)