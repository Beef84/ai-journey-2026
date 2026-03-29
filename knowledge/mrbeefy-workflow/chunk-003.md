   - Queries the S3 Vector Store
   - Retrieves relevant documents
3. The agent generates a response using Nova Pro, streamed back in chunks.

### **3.6 Lambda Streams SSE Chunks**
1. Each Bedrock chunk is written to the response stream immediately:

```
data: {"token": "Hello"}\n\n
data: {"token": ", world"}\n\n
data: [DONE]\n\n
```

2. The stream stays open until Bedrock signals completion.
3. Lambda sends `data: [DONE]\n\n` as the terminal sentinel.

### **3.7 Browser Receives Tokens in Real Time**
1. The browser reads the response via `fetch` + `ReadableStream`.
2. Each SSE line is parsed and the token appended to the assistant message bubble immediately.
3. A blinking cursor is shown while streaming is in progress.
4. When `[DONE]` arrives, the cursor is removed and the send button is re-enabled.

---

# **4. Knowledge Base Workflow**

### **4.1 KB File Management**
1. Machine‑readable KB files are stored in a dedicated folder in the repository.  
2. CI/CD uploads these files to the Knowledge Base S3 bucket.

### **4.2 Ingestion Workflow**
**Exact behavior (no vague phrasing):**

1. CI/CD calls the Bedrock Knowledge Base ingestion API to start a new ingestion job.  
2. Bedrock performs the ingestion process: