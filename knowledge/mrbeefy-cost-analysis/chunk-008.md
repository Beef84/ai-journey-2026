[Source: Mrbeefy Cost Analysis | Section: 1.6 Amazon S3]

## **1.6 Amazon S3**

| Bucket | Storage | Est. Cost |
|---|---|---|
| Frontend assets | <10 MB | <$0.01/month |
| Knowledge Base files | <5 MB | <$0.01/month |
| Terraform state | <1 MB | <$0.01/month |

S3 storage is negligible. The main S3 cost would come from GET requests during KB ingestion, which is also negligible at this scale.

---