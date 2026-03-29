[Source: Mrbeefy Design Decisions | Section: 3.3 SSE Over WebSocket for Streaming]

## **3.3 SSE Over WebSocket for Streaming**
Two real-time delivery options were considered:

| Option | Why rejected |
|---|---|
| WebSocket (API Gateway) | Bidirectional connection management, connection state, reconnect logic — all unnecessary overhead for one-way server→client delivery |
| WebSocket (API Gateway) | API Gateway WebSocket adds cost per connection-minute on top of per-message fees |

SSE (Server-Sent Events) over a regular `POST` request is the right fit here:
- One-way delivery (server → browser) matches the use case exactly
- Works with standard `fetch` + `ReadableStream` — no special browser API
- No persistent connection state to manage
- CloudFront handles it natively when `compress = false` is set on the behavior

---