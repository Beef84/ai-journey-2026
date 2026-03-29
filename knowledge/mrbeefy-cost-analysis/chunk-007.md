[Source: Mrbeefy Cost Analysis | Section: 1.5 Amazon CloudFront]

## **1.5 Amazon CloudFront**

| Metric | Rate |
|---|---|
| HTTPS requests | $0.0085 / 10K requests |
| Data out to internet | $0.085 / GB (first 10TB) |
| S3 → CloudFront | Free (same region) |

Static assets are small (<2MB SPA) and cached aggressively. At low traffic volumes, CloudFront costs **<$0.10/month**.

---