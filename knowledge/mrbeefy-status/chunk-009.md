- **KB pipeline → documentation‑only refresh**  

This mirrors real‑world AI infra patterns where knowledge updates and infrastructure updates move at different speeds.

---

# **🚀 Impact**
The addition of the dedicated KB ingestion pipeline provides:

- Faster documentation iteration  
- Safer ingestion cycles  
- Clear separation of concerns  
- Reduced coupling between infra and knowledge  
- A more resilient and maintainable architecture  

The backend still owns ingestion during deploys, but the KB pipeline now owns ingestion during day‑to‑day updates — exactly the right division of responsibilities.

---

# **⚡ SSE Streaming Responses**

## **Overview**
Chat responses now stream token-by-token from Bedrock to the browser. Instead of waiting for the full response to generate, users see words appear progressively — the same typing effect used by modern AI chat interfaces.

---

## **What Changed**

### **Lambda Handler**
- Replaced the standard handler with `awslambda.streamifyResponse`
- Bedrock chunks are piped directly to the response stream as they arrive
- Output formatted as Server-Sent Events: `data: {"token": "..."}\n\n`
- Final sentinel: `data: [DONE]\n\n`
- Content-Type set to `text/event-stream`
