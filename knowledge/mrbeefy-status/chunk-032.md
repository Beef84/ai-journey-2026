[Source: Mrbeefy Status | Section: What Changed > Frontend]

### **Frontend**
- `fetch` + `ReadableStream` reads SSE chunks as they arrive
- Each token is appended to the assistant message bubble in real time
- Streaming state disables the send button and textarea while a response is in progress
- A blinking cursor (`▍`) is shown on the active assistant bubble during streaming
- Cursor and disabled state are removed when `[DONE]` is received

---