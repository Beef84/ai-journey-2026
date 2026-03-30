[Source: Mrbeefy Workflow]

# **3. Chat Request Workflow**

### **3.1 User Action**
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