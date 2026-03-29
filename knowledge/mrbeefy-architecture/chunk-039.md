[Source: Mrbeefy Architecture | Section: 3. Lambda Function URL receives]

### **3. Lambda Function URL receives**
```
POST https://<url-id>.lambda-url.us-east-1.on.aws
```
- Lambda validates the `x-cloudfront-secret` header → 403 if missing or wrong
- Lambda opens an SSE response stream