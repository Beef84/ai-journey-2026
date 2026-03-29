[Source: Mrbeefy Design Decisions | Section: 3.1 Lambda Function URL Instead of API Gateway]

## **3.1 Lambda Function URL Instead of API Gateway**

API Gateway was the original API layer. It was replaced with a Lambda Function URL when streaming was added.

**Why API Gateway could not stay:**
API Gateway HTTP API buffers the complete Lambda response before forwarding it to the client. This makes true SSE streaming impossible — the browser receives one large payload at the end rather than tokens as they arrive.

**Why Lambda Function URL:**
- `invoke_mode = RESPONSE_STREAM` enables chunked transfer directly from Lambda to CloudFront to browser
- No stages, no routing rules, no CORS configuration needed — the Function URL is a direct HTTPS endpoint consumed only by CloudFront
- Simpler: one fewer AWS service, one fewer IaC module to manage
- Same security posture: the gateway secret header check in Lambda replaces API Gateway auth

**Cost:** Lambda Function URLs have no per-request charge beyond the Lambda invocation itself. Removing API Gateway saves $1.00/million requests — negligible at this scale but a simplification win.