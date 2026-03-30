[Source: Mrbeefy Design Decisions]

## **7.2 Explicit Ingestion**
KB ingestion is triggered manually via CI/CD because:

- AWS does not auto-ingest  
- Ingestion should be deterministic  
- KB updates should be intentional  

---

# **8. IAM Design Decisions**

## **8.1 Least Privilege**
Each role has only the permissions required for its function.