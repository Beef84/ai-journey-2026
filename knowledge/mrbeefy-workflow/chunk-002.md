[Source: Mrbeefy Workflow]

# **2. Frontend Delivery Workflow**

### **2.1 Build**
1. The React application is compiled into a static asset bundle.  
2. Output includes `index.html`, JavaScript bundles, CSS, and static assets.

### **2.2 Deployment**
1. CI/CD uploads the build artifacts to the S3 frontend bucket.  
2. CI/CD issues a CloudFront invalidation to propagate updates globally.