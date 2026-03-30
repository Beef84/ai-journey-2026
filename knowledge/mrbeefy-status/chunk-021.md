[Source: Mrbeefy Status | Section: 2. The dedicated KB pipeline handles ingestion between deploys]

## **2. The dedicated KB pipeline handles ingestion between deploys**
This new pipeline is intentionally minimal and focused:

### **Inputs**
- `/knowledge` directory  
- SSM parameter: `mrbeefy.kb.bucket_name`  
- SSM parameter: KB ID

### **Actions**
- Syncs knowledge files → S3 (non‑destructive)  
- Triggers a Bedrock KB ingestion job  
- Waits for ingestion to complete  
- Reports success/failure