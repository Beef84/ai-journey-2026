[Source: Mrbeefy Governance]

# **6. Risk Governance**

## **6.1 Drift Prevention**
- Terraform manages all static resources  
- CI/CD manages all dynamic resources  
- No overlapping ownership  
- No manual edits to Terraform‑managed resources

## **6.2 Failure Isolation**
- Frontend failures do not affect backend  
- Backend failures do not affect KB ingestion  
- KB ingestion failures do not affect existing chat functionality  
- Agent alias ensures stable versioning

## **6.3 Rollback Strategy**
- Terraform supports infrastructure rollback  
- CI/CD supports Lambda rollback  
- Alias pinning ensures agent rollback  
- KB ingestion is versioned implicitly  

---

# **7. Compliance Governance**