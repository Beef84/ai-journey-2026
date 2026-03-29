# **2. Frontend Architecture**

## **2.1 Static Hosting**
- React SPA built and uploaded to an S3 bucket:
  - Bucket name pattern: `mrbeefy-frontend-<random>`  
  - Public access fully blocked  
  - Access controlled exclusively through CloudFront OAC  

## **2.2 CloudFront Distribution**
CloudFront serves as the global CDN and routing layer.

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

### **Behaviors**
- **Default behavior** → S3 frontend  
- **Ordered behavior**:
  - `path_pattern = "/chat"`  
  - Allowed methods:  
    `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`  
  - Cached methods:  
    `GET, HEAD`  
  - Cache policy: API no‑cache policy  
  - Origin request policy: forwards `Content-Type` header + all query strings  

### **Security**