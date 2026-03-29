POST https://<url-id>.lambda-url.us-east-1.on.aws
```
- Lambda validates the `x-cloudfront-secret` header → 403 if missing or wrong
- Lambda opens an SSE response stream

### **4. Lambda calls Bedrock Agent Runtime**
- Using Agent ID + Alias ID
- Bedrock streams response chunks back to Lambda

### **5. Lambda streams SSE chunks**
- Each Bedrock chunk is written to the response stream immediately as `data: {"token": "..."}\n\n`
- Browser receives and renders tokens progressively — no waiting for full response

### **6. Bedrock Agent**
- Searches Knowledge Base
- Retrieves relevant documents
- Generates response via Nova Pro (streamed)

### **7. Response flows back**
Agent (streaming) → Lambda (SSE) → CloudFront → Browser (live render)

---

# **10. Multi-Environment Architecture**

The system uses **Terraform workspaces** to maintain isolated environments within the same AWS account.

| Workspace | Domain | Access | Function URL |
|---|---|---|---|
| `default` (prod) | `mrbeefy.academy` | Public | Secret header required |
| `dev` | `dev.mrbeefy.academy` | Signed cookies required | Secret header required |

## **10.1 Workspace Naming**
All resource names are prefixed by workspace:
- prod: `mrbeefy-*`