1. User enters a message in the UI.
2. The UI sends a `POST` request to:

```
https://mrbeefy.academy/chat
```

### **3.2 CloudFront Routing**
1. CloudFront matches the `/chat` ordered behavior.
2. CloudFront forwards the request to the Lambda Function URL origin.
3. CloudFront injects the `x-cloudfront-secret` custom header on the outbound request.
4. `compress = false` is set on this behavior — CloudFront does not buffer the response, enabling SSE streaming.

### **3.3 Lambda Validates and Opens Stream**
1. Lambda Function URL receives the request.
2. Lambda checks the `x-cloudfront-secret` header against the `GATEWAY_SECRET` environment variable.
3. If the header is missing or wrong, Lambda returns 403 immediately — no Bedrock call is made.
4. Lambda opens an SSE response stream using `awslambda.streamifyResponse`.

### **3.4 Lambda Calls Bedrock**
1. Lambda initializes the Bedrock Agent Runtime client.
2. Lambda invokes the Bedrock Agent using the stored `AGENT_ID` and `AGENT_ALIAS_ID`.
3. The agent call returns an async event stream.

### **3.5 Bedrock Agent Workflow**
1. The agent receives the request.
2. The agent performs a Knowledge Base search:
   - Embeds the query using Titan V2