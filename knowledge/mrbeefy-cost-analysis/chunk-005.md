SSE streaming is fully implemented. The Lambda handler now pipes Bedrock chunks directly to the browser as they arrive, giving the typing effect seen in modern AI chat interfaces. Users see words appear progressively rather than waiting for the full response.

## **4.2 Architecture Change: API Gateway → Lambda Function URL**

Streaming required replacing API Gateway with a Lambda Function URL. API Gateway HTTP API buffers the complete Lambda response before forwarding it — true SSE streaming is impossible through it.

Lambda Function URL with `invoke_mode = RESPONSE_STREAM` enables chunked transfer directly from Lambda to CloudFront to browser with no buffering.

## **4.3 Cost Impact**

| Component | Before | After | Delta |
|---|---|---|---|
| Bedrock tokens | Same | Same | **$0** |
| Lambda duration | ~10s | ~10s (same wall time) | **~$0** |
| API Gateway | $1.00/million requests | **Removed** | **-$1.00/M** |
| Lambda Function URL | n/a | $0 additional | **$0** |
| CloudFront | Same bytes transferred | Same bytes, incremental delivery | **$0** |
