[Source: Mrbeefy Workflow]

### **5.3 Versioning**
- Bedrock automatically creates implicit versions.  
- Terraform does not manage versions or aliases.  
- CI/CD ensures the alias always points to the correct version.

---

# **6. CI/CD Workflow**

### **6.1 Trigger Conditions**
Pipeline runs on:

- Push to main  
- Manual dispatch  
- KB file changes  
- Lambda code changes