[Source: Mrbeefy Architecture]

## **6.3 KB Ingestion**
- Triggered explicitly via CI/CD  
- Uses KB role with:
  - S3 read permissions  
  - s3vectors permissions  
  - Titan embedding model permissions  

---

# **7. CI/CD Architecture**

## **7.1 Responsibilities**
CI/CD handles all dynamic operations:

- Build Lambda bundle  
- Deploy Terraform  
- Upload KB files  
- Trigger KB ingestion  
- Associate KB with agent  
- Create alias if missing  
- Update Lambda environment variables (AGENT_ID, AGENT_ALIAS_ID, GATEWAY_SECRET)
- Store `function_url_domain` in SSM for frontend pipeline consumption