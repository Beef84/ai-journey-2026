[Source: Mrbeefy Cost Analysis]

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
| Medium | 1,000 | $2.20 | $0.04 | $0.05 | $0.50 | **~$2.80** |
| Heavy | 10,000 | $22.00 | $0.40 | $0.30 | $0.50 | **~$23.00** |

**Bedrock is 90%+ of cost at any meaningful usage level.** Everything else is noise.

---