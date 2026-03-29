[Source: Mrbeefy Workflow | Section: 2.2 Deployment]

### **2.2 Deployment**
1. CI/CD uploads the build artifacts to the S3 frontend bucket.  
2. CI/CD issues a CloudFront invalidation to propagate updates globally.