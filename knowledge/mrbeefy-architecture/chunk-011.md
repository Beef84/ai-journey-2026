[Source: Mrbeefy Architecture | Section: 3.1 Lambda Function URL]

## **3.1 Lambda Function URL**
- `authorization_type = "NONE"` — Lambda validates all access itself via the gateway secret header
- `invoke_mode = "RESPONSE_STREAM"` — enables true SSE streaming; Lambda writes chunks to the response as Bedrock produces them
- No API Gateway, no stages, no managed CORS — the Function URL is a direct HTTPS endpoint consumed only by CloudFront