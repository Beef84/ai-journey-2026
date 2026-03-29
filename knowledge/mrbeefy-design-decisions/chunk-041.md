[Source: Mrbeefy Design Decisions | Section: 11.3 SSM as the Source of Truth]

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