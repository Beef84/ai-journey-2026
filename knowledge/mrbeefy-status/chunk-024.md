[Source: Mrbeefy Status]

# **🎯 Why This Pipeline Exists**
Previously, the only way to refresh the Knowledge Base was to run the backend deployment pipeline. This created several problems:

- Documentation changes required a full backend deploy  
- Ingestion was tightly coupled to Terraform outputs  
- Failures in the KB ingest path could block backend releases  
- The KB could not be updated independently or frequently  

The new pipeline solves all of these issues by giving the KB its own lifecycle.

---