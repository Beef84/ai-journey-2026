[Source: Mrbeefy Governance | Section: 2.2 Application Lifecycle Ownership (CI/CD)]

## **2.2 Application Lifecycle Ownership (CI/CD)**

CI/CD owns all dynamic, stateful, or versioned operations:

- Building and deploying Lambda code  
- Uploading Knowledge Base files  
- Starting Knowledge Base ingestion jobs  
- Associating the KB with the agent  
- Creating the agent alias if missing  
- Updating Lambda environment variables with alias IDs  
- Invalidating CloudFront cache  

CI/CD is the **single source of truth** for runtime configuration and agent lifecycle.

---