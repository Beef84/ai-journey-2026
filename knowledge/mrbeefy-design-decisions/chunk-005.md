[Source: Mrbeefy Design Decisions | Section: 2.2 CI/CD Owns Dynamic Lifecycle]

## **2.2 CI/CD Owns Dynamic Lifecycle**
GitHub Actions handles:

- KB ingestion  
- Agent alias creation (if missing)  
- Lambda environment variable updates  
- Deployment of Lambda code  
- Uploading KB files  

This ensures:

- No stale alias IDs  
- No Terraform drift  
- No accidental recreation of agents  
- Clean, predictable updates  

---