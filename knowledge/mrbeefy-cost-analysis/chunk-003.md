| Data out to internet | $0.085 / GB (first 10TB) |
| S3 → CloudFront | Free (same region) |

Static assets are small (<2MB SPA) and cached aggressively. At low traffic volumes, CloudFront costs **<$0.10/month**.

---

## **1.6 Amazon S3**

| Bucket | Storage | Est. Cost |
|---|---|---|
| Frontend assets | <10 MB | <$0.01/month |
| Knowledge Base files | <5 MB | <$0.01/month |
| Terraform state | <1 MB | <$0.01/month |

S3 storage is negligible. The main S3 cost would come from GET requests during KB ingestion, which is also negligible at this scale.

---

## **1.7 Amazon Route53**

| Metric | Rate |
|---|---|
| Hosted zone | $0.50 / month |
| DNS queries | $0.40 / million |

Fixed cost: **$0.50/month** regardless of traffic.

---

## **1.8 ACM, DynamoDB (Terraform Locks), VPC**

- ACM certificates: **Free**
- DynamoDB (state locks): **<$0.01/month** (on-demand, effectively zero)
- No VPC — fully managed services only

---

# **2. Monthly Cost Estimates by Usage Tier**

| Tier | Chat Requests/Month | Bedrock | Lambda | CloudFront | Route53 | **Total** |
|---|---|---|---|---|---|---|
| Idle | 0 | $0.00 | $0.00 | $0.00 | $0.50 | **~$0.50** |
| Light | 100 | $0.22 | $0.004 | <$0.01 | $0.50 | **~$0.75** |