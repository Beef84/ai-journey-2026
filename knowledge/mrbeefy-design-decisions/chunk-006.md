- Only answer from KB when relevant  
- Avoid hallucination  
- Fall back to out-of-domain only when KB is empty  

This ensures accuracy and consistency.

---

# **7. Knowledge Base Design Decisions**

## **7.1 S3 Vector Store**
Chosen because:

- Fully managed  
- Scales automatically  
- Integrates with Titan embeddings  
- No infrastructure to maintain  

## **7.2 Explicit Ingestion**
KB ingestion is triggered manually via CI/CD because:

- AWS does not auto-ingest  
- Ingestion should be deterministic  
- KB updates should be intentional  

---

# **8. IAM Design Decisions**

## **8.1 Least Privilege**
Each role has only the permissions required for its function.

### **Lambda Role**
- Logging  
- `bedrock:InvokeAgent`  

### **Agent Execution Role**
- Model invocation  
- KB retrieval  
- S3 read access  
- Vector store operations  

### **KB Role**
- S3 read  
- s3vectors operations  
- Titan embedding model invocation  

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
