[Source: Mrbeefy Workflow | Section: 6.2 Pipeline Steps]

### **6.2 Pipeline Steps**
1. Build Lambda bundle.  
2. Deploy Terraform.  
3. Upload KB files to the KB S3 bucket.  
4. **Start a Knowledge Base ingestion job using the Bedrock ingestion API.**  
5. Associate the KB with the agent if needed.  
6. Create the agent alias if missing.  
7. Update Lambda environment variables: `AGENT_ID`, `AGENT_ALIAS_ID`, `GATEWAY_SECRET`.
8. Write `function_url_domain` and `knowledge_bucket` to SSM Parameter Store for downstream pipeline consumption.