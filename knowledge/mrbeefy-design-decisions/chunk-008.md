This separation reflects the reality that **knowledge evolves faster than infrastructure**.

---

## **11.2 Why a Separate KB Pipeline Was Introduced**
Originally, KB ingestion was tied to backend deployments. This created friction:

- Documentation updates required a full backend deploy  
- KB ingestion failures could block infrastructure releases  
- Terraform outputs were tightly coupled to ingestion  
- No safe way to update the KB independently  

The dedicated pipeline resolves these issues by giving the KB its own lifecycle.

---

## **11.3 SSM as the Source of Truth**
The backend pipeline now publishes:

- KB bucket name  
- KB ID  

…into SSM parameters.

The KB pipeline reads these values at runtime, ensuring:

- No Terraform coupling  
- No querying the KB for data source ARNs  
- No brittle assumptions about resource recreation  
- A stable, explicit contract between pipelines  

SSM becomes the **canonical interface** between backend deploys and KB ingestion.

---

## **11.4 Non‑Destructive S3 Sync**
The KB pipeline intentionally avoids destructive sync flags.

This prevents:

- Metadata loss  
- Embedding corruption  
- Ingestion failures caused by missing files  
