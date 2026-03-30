[Source: Mrbeefy Design Decisions]

### **CloudFront OAC**
- `s3:GetObject` with `AWS:SourceArn` condition  

This structure isolates responsibilities and minimizes blast radius.

---

# **9. Frontend Design Decisions**

## **9.1 React SPA**
Chosen for:

- Fast development  
- Simple deployment  
- Easy integration with CloudFront + Lambda Function URL