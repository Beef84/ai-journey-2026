[Source: Mrbeefy Architecture]

### **3. Lambda Function URL receives**
```
POST https://<url-id>.lambda-url.us-east-1.on.aws
```
- Lambda validates the `x-cloudfront-secret` header → 403 if missing or wrong
- Lambda opens an SSE response stream

### **4. Lambda calls Bedrock Agent Runtime**
- Using Agent ID + Alias ID
- Bedrock streams response chunks back to Lambda