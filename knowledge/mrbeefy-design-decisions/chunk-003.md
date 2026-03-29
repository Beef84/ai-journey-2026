- `invoke_mode = RESPONSE_STREAM` enables chunked transfer directly from Lambda to CloudFront to browser
- No stages, no routing rules, no CORS configuration needed — the Function URL is a direct HTTPS endpoint consumed only by CloudFront
- Simpler: one fewer AWS service, one fewer IaC module to manage
- Same security posture: the gateway secret header check in Lambda replaces API Gateway auth

**Cost:** Lambda Function URLs have no per-request charge beyond the Lambda invocation itself. Removing API Gateway saves $1.00/million requests — negligible at this scale but a simplification win.

## **3.2 Single Endpoint: `POST /chat`**
The system exposes only one route. This keeps the attack surface minimal, the contract simple, and the frontend integration straightforward. The Function URL receives all requests; Lambda routes internally by HTTP method if needed.

## **3.3 SSE Over WebSocket for Streaming**
Two real-time delivery options were considered:

| Option | Why rejected |
|---|---|
| WebSocket (API Gateway) | Bidirectional connection management, connection state, reconnect logic — all unnecessary overhead for one-way server→client delivery |