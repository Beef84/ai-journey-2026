[Source: Mrbeefy Design Decisions | Section: 4.2 Two-Origin Architecture]

## **4.2 Two-Origin Architecture**
CloudFront uses:

1. **S3 Origin**
   - For static frontend assets
   - Protected by OAC
   - No public access

2. **Lambda Function URL Origin**
   - For dynamic `/chat` requests
   - HTTPS-only
   - No `origin_path` — requests go directly to the function
   - `compress = false` — required to prevent SSE stream buffering