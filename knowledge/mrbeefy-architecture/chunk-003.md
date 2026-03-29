- ACM certificate for `mrbeefy.academy` (prod) / `dev.mrbeefy.academy` (dev)
- SNI‑only
- Security headers policy applied to frontend
- **Dev only:** Signed cookies required — CloudFront returns 403 to any request without a valid signed cookie  

## **2.3 DNS**
- Route53 A‑record alias → CloudFront distribution  
- Certificate validated via DNS  

---

# **3. API Architecture**

## **3.1 Lambda Function URL**
- `authorization_type = "NONE"` — Lambda validates all access itself via the gateway secret header
- `invoke_mode = "RESPONSE_STREAM"` — enables true SSE streaming; Lambda writes chunks to the response as Bedrock produces them
- No API Gateway, no stages, no managed CORS — the Function URL is a direct HTTPS endpoint consumed only by CloudFront

## **3.2 Gateway Secret**
CloudFront injects `x-cloudfront-secret` as a custom header on every request forwarded to the Function URL origin. Lambda checks this header before doing anything else and returns 403 if it is absent or wrong.

The raw Function URL (`https://<id>.lambda-url.us-east-1.on.aws`) is publicly reachable by anyone who discovers it, but without the secret header every request is rejected immediately.

## **3.3 Streaming Response Format**