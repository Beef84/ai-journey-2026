[Source: Mrbeefy Design Decisions | Section: 7.2 Explicit Ingestion]

## **7.2 Explicit Ingestion**
KB ingestion is triggered manually via CI/CD because:

- AWS does not auto-ingest  
- Ingestion should be deterministic  
- KB updates should be intentional  

---