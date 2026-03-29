### **Infrastructure**
- API Gateway removed — replaced with Lambda Function URL (`invoke_mode = RESPONSE_STREAM`)
- `compress = false` set on the `/chat` CloudFront behavior — required to prevent response buffering
- No API Gateway stages, CORS config, or routes needed — the Function URL is a direct HTTPS endpoint consumed only by CloudFront

### **Frontend**
- `fetch` + `ReadableStream` reads SSE chunks as they arrive
- Each token is appended to the assistant message bubble in real time
- Streaming state disables the send button and textarea while a response is in progress
- A blinking cursor (`▍`) is shown on the active assistant bubble during streaming
- Cursor and disabled state are removed when `[DONE]` is received

---

## **Cost Impact**
Zero. Streaming does not change token count, request count, or total bytes transferred. Bedrock, Lambda, and CloudFront costs are identical to the non-streaming implementation. The only cost change is the removal of API Gateway, which saves $1.00/million requests — negligible at personal/portfolio scale but eliminates one service entirely.

---

# **🖥️ Frontend UI Updates**

## **Overview**