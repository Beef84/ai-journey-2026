[Source: Mrbeefy Architecture]

# **9. End‑to‑End Request Flow**

### **1. User sends message from UI**
```
POST https://mrbeefy.academy/chat
```

### **2. CloudFront behavior matches `/chat`**
- Forwards request to the Lambda Function URL origin
- Injects `x-cloudfront-secret` custom header
- `compress = false` — ensures CloudFront does not buffer the streaming response