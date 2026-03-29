## **9.2 Clean API Contract**
Frontend only calls:

```
POST /chat
```

No other endpoints are exposed.

## **9.3 CloudFront + S3 Hosting**
Provides:

- Global caching  
- Instant invalidation  
- Zero server maintenance  
- Strong security posture  

---

# **10. Deployment Design Decisions**

## **10.1 Terraform for Infrastructure**
Ensures:

- Reproducibility  
- Version control  
- Clear diffs  
- Safe rollbacks  

## **10.2 CI/CD for Dynamic Operations**
Ensures:

- No stale alias IDs  
- No Terraform drift  
- Clean agent lifecycle  
- Automated KB ingestion  

---

# **11. Knowledge Base Lifecycle Design Decisions**

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
