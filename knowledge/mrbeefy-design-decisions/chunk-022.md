[Source: Mrbeefy Design Decisions | Section: 11.2 Why a Separate KB Pipeline Was Introduced]

## **11.2 Why a Separate KB Pipeline Was Introduced**
Originally, KB ingestion was tied to backend deployments. This created friction:

- Documentation updates required a full backend deploy  
- KB ingestion failures could block infrastructure releases  
- Terraform outputs were tightly coupled to ingestion  
- No safe way to update the KB independently  

The dedicated pipeline resolves these issues by giving the KB its own lifecycle.

---