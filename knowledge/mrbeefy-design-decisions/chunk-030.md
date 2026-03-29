[Source: Mrbeefy Design Decisions | Section: 8.1 Least Privilege > CloudFront OAC]

### **CloudFront OAC**
- `s3:GetObject` with `AWS:SourceArn` condition  

This structure isolates responsibilities and minimizes blast radius.

---