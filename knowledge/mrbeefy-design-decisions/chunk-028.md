[Source: Mrbeefy Design Decisions | Section: 11.4 Non‑Destructive S3 Sync]

## **11.4 Non‑Destructive S3 Sync**
The KB pipeline intentionally avoids destructive sync flags.

This prevents:

- Metadata loss  
- Embedding corruption  
- Ingestion failures caused by missing files  

Only new or updated files are uploaded, preserving the integrity of the vector store.

---