[Source: Mrbeefy Workflow | Section: 8.1 Access Control]

### **8.1 Access Control**
- S3 frontend bucket locked behind OAC
- KB bucket restricted to KB role
- Lambda role restricted to logging + InvokeAgent
- Agent execution role restricted to model + KB access
- CloudFront restricted via `AWS:SourceArn`
- Lambda Function URL protected by `x-cloudfront-secret` header (both environments)
- Dev CloudFront protected by signed cookies