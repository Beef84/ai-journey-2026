[Source: Mrbeefy Cost Analysis | Section: 4.2 Architecture Change: API Gateway → Lambda Function URL]

## **4.2 Architecture Change: API Gateway → Lambda Function URL**

Streaming required replacing API Gateway with a Lambda Function URL. API Gateway HTTP API buffers the complete Lambda response before forwarding it — true SSE streaming is impossible through it.

Lambda Function URL with `invoke_mode = RESPONSE_STREAM` enables chunked transfer directly from Lambda to CloudFront to browser with no buffering.