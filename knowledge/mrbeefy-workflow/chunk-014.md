[Source: Mrbeefy Workflow | Section: 3.7 Browser Receives Tokens in Real Time]

### **3.7 Browser Receives Tokens in Real Time**
1. The browser reads the response via `fetch` + `ReadableStream`.
2. Each SSE line is parsed and the token appended to the assistant message bubble immediately.
3. A blinking cursor is shown while streaming is in progress.
4. When `[DONE]` arrives, the cursor is removed and the send button is re-enabled.

---