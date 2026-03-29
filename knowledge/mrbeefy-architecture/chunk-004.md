Lambda streams responses as **Server-Sent Events (SSE)**:

```
data: {"token": "Hello"}\n\n
data: {"token": ", world"}\n\n
data: [DONE]\n\n
```

The browser reads chunks via `fetch` + `ReadableStream` and appends tokens to the message bubble as they arrive. Errors stream as `data: {"error": "..."}` before the stream closes.

---

# **4. Compute Architecture (Lambda)**

## **4.1 Lambda Function**
- Runtime: **Node.js 20.x**
- Handler: `index.handler`
- Timeout: 30 seconds
- Deployed via CI/CD (zip artifact)
- Environment variables:
  - `AGENT_ID`
  - `AGENT_ALIAS_ID` (updated by CI/CD after alias creation)
  - `GATEWAY_SECRET` (set by Terraform from `terraform.tfvars`, never committed)  

## **4.2 Lambda IAM Role**
Permissions include:

### **Logging**
- `logs:CreateLogGroup`  
- `logs:CreateLogStream`  
- `logs:PutLogEvents`  

### **Bedrock Agent Runtime**
- `bedrock:InvokeAgent`  

Lambda does **not** need direct access to S3 or vector store — the agent handles retrieval.

---

# **5. AI Architecture (Bedrock)**

## **5.1 Bedrock Agent**
- Foundation model: **amazon.nova-pro-v1:0**  
- Instruction block defines:
  - KB usage rules  
  - Response rules  
  - Action rules  
- Agent resource role attached  
