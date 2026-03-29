[Source: Mrbeefy Status | Section: What Changed > Infrastructure]

### **Infrastructure**
- API Gateway removed — replaced with Lambda Function URL (`invoke_mode = RESPONSE_STREAM`)
- `compress = false` set on the `/chat` CloudFront behavior — required to prevent response buffering
- No API Gateway stages, CORS config, or routes needed — the Function URL is a direct HTTPS endpoint consumed only by CloudFront