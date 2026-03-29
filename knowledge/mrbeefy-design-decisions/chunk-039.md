[Source: Mrbeefy Design Decisions | Section: 11.1 Dual‑Path Ingestion Model]

## **11.1 Dual‑Path Ingestion Model**
The system now supports two ingestion paths:

1. **Backend Deployment Ingestion**  
   - Runs automatically during backend deploys  
   - Ensures the KB is refreshed whenever infrastructure or agent configuration changes  
   - Acts as a safety net to guarantee consistency after releases  

2. **Dedicated KB Ingestion Pipeline**  
   - Runs independently of backend deploys  
   - Allows documentation updates to be ingested without requiring a backend rollout  
   - Provides a safe, isolated ingestion workflow  

This separation reflects the reality that **knowledge evolves faster than infrastructure**.

---