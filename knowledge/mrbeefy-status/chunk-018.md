[Source: Mrbeefy Status | Section: 1. Backend still performs ingestion — but only during deploys]

## **1. Backend still performs ingestion — but only during deploys**
The backend pipeline continues to:

- Deploy infrastructure  
- Publish the knowledge bucket name to SSM  
- Associate the KB with the agent  
- Trigger a full ingestion as part of a release  

This ensures that every backend deploy results in a fully refreshed KB.

**But this is no longer the only ingestion path.**

---