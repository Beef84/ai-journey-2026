[Source: Mrbeefy Governance]

# **3. Change Management**

## **3.1 Infrastructure Changes**
All infrastructure changes must:

- Be made in Terraform  
- Pass validation (`terraform validate`)  
- Pass plan review (`terraform plan`)  
- Be deployed via CI/CD  

No manual changes are permitted in:

- CloudFront  
- IAM
- S3 bucket configuration  
- Route53  
- Lambda configuration (except environment variables updated by CI/CD)

This prevents drift and ensures reproducibility.

---