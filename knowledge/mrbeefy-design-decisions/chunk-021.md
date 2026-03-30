[Source: Mrbeefy Design Decisions | Section: 8.1 Least Privilege]

### **KB Role**
- S3 read  
- s3vectors operations  
- Titan embedding model invocation

### **CloudFront OAC**
- `s3:GetObject` with `AWS:SourceArn` condition  

This structure isolates responsibilities and minimizes blast radius.

---