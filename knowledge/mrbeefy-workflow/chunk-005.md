[Source: Mrbeefy Workflow | Section: 3.3 Lambda Validates and Opens Stream]

### **3.3 Lambda Validates and Opens Stream**
1. Lambda Function URL receives the request.
2. Lambda checks the `x-cloudfront-secret` header against the `GATEWAY_SECRET` environment variable.
3. If the header is missing or wrong, Lambda returns 403 immediately — no Bedrock call is made.
4. Lambda opens an SSE response stream using `awslambda.streamifyResponse`.