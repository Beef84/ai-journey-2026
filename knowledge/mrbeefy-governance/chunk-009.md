[Source: Mrbeefy Governance | Section: 3.2 Agent Lifecycle Changes]

## **3.2 Agent Lifecycle Changes**
All agent lifecycle changes must be performed through CI/CD:

- Alias creation  
- Alias updates  
- KB ingestion  
- KB association  
- Lambda environment variable updates  

Terraform must not manage these resources to avoid drift and stale state.

---