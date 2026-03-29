[Source: Mrbeefy Cost Analysis]

# **3. Dev Environment Cost**

The dev workspace adds a parallel set of AWS resources, but most carry no fixed monthly cost when idle.

| Resource | Added Cost |
|---|---|
| CloudFront distribution (dev) | $0 (no per-distribution fee) |
| ACM certificate (dev subdomain) | $0 |
| S3 buckets (dev) | <$0.01/month |
| Lambda + Function URL (dev) | $0 when idle, same rate when used |
| Bedrock | Same per-token rate as prod |
| Route53 | No additional charge (same hosted zone) |

**Dev incremental cost when idle: <$0.01/month**

When actively testing, dev costs accumulate at the same per-request rate as prod. A typical dev session of 50–100 test chats adds **$0.10–$0.25** to the monthly bill.

---