[Source: Mrbeefy Architecture | Section: 2.2 CloudFront Distribution > Origins]

### **Origins**
1. **S3 Frontend Origin**
   - Uses Origin Access Control (OAC)  
   - Only CloudFront can read from the bucket  
   - S3 bucket policy restricts access via `AWS:SourceArn`  

2. **Lambda Function URL Origin**
   - Domain: `<url-id>.lambda-url.us-east-1.on.aws`
   - No `origin_path` — requests go directly to the function
   - HTTPS enforced, TLSv1.2
   - `compress = false` on the `/chat` behavior — required for SSE streaming (compression forces buffering)