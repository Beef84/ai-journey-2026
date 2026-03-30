[Source: Mrbeefy Architecture | Section: 2.2 CloudFront Distribution > Behaviors]

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