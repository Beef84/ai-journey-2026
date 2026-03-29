| Medium | 1,000 | $2.20 | $0.04 | $0.05 | $0.50 | **~$2.80** |
| Heavy | 10,000 | $22.00 | $0.40 | $0.30 | $0.50 | **~$23.00** |

**Bedrock is 90%+ of cost at any meaningful usage level.** Everything else is noise.

---

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

# **4. Streaming Responses — Implemented**

## **4.1 What Changed**
