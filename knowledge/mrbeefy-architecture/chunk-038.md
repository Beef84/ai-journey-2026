[Source: Mrbeefy Architecture | Section: 2. CloudFront behavior matches `/chat`]

### **2. CloudFront behavior matches `/chat`**
- Forwards request to the Lambda Function URL origin
- Injects `x-cloudfront-secret` custom header
- `compress = false` — ensures CloudFront does not buffer the streaming response