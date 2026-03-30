[Source: Mrbeefy Governance | Section: 5.3 Deployment Governance]

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