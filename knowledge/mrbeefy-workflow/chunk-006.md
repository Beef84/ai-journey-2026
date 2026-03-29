[Source: Mrbeefy Workflow | Section: 2.3 User Access]

### **2.3 User Access**
1. User navigates to `https://mrbeefy.academy`.  
2. Route53 resolves the domain to CloudFront.  
3. CloudFront retrieves static assets from S3 using OAC.  
4. The browser loads the SPA and initializes the UI.

---