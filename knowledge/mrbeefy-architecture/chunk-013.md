[Source: Mrbeefy Architecture | Section: 3.3 Streaming Response Format]

## **3.3 Streaming Response Format**
Lambda streams responses as **Server-Sent Events (SSE)**:

```
data: {"token": "Hello"}\n\n
data: {"token": ", world"}\n\n
data: [DONE]\n\n
```

The browser reads chunks via `fetch` + `ReadableStream` and appends tokens to the message bubble as they arrive. Errors stream as `data: {"error": "..."}` before the stream closes.

---