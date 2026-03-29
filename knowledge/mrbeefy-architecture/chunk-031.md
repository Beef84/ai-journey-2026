[Source: Mrbeefy Architecture | Section: 7.1 Responsibilities]

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