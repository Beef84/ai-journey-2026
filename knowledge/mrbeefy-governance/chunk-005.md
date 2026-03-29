---

## **5.2 Monitoring**
Monitoring includes:

- Lambda error rates
- CloudFront cache hit/miss ratios
- KB ingestion job status  
- Bedrock agent invocation metrics  

Alerts may be added as the system scales.

---

## **5.3 Deployment Governance**
Deployments must:

- Run through CI/CD  
- Use versioned artifacts  
- Produce deterministic infrastructure  
- Avoid manual console changes  

Manual console edits are only allowed for:

- Emergency rollback  
- Temporary debugging  
- AWS support troubleshooting  

Any manual change must be documented and reverted into Terraform if permanent.

---

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
