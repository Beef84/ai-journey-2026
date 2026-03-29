## **1.2 Amazon Bedrock — Titan V2 Embeddings (KB Ingestion)**

Titan V2 is used only during KB ingestion, not during chat.

| Metric | Rate |
|---|---|
| Embedding tokens | ~$0.00002 / 1K tokens |

**Per ingestion run:**
- Current KB: ~200 chunks × ~1,200 chars each ≈ ~60,000 tokens
- Cost per ingestion: ~$0.0012

Even running ingestion daily, this is **~$0.04/month** — essentially free.

---

## **1.3 AWS Lambda**

Billed on duration × memory allocation, plus a flat per-invocation fee.

| Metric | Rate |
|---|---|
| Compute | $0.0000166667 / GB-second |
| Invocations | $0.0000002 / request |

**Per request estimate (256MB, ~10s average duration):**
- 0.25 GB × 10s = 2.5 GB-seconds × $0.0000166667 = **~$0.00004/request**
- Plus invocation: $0.0000002

Lambda is **not** a meaningful cost at personal/demo scale.

---

## **1.4 Lambda Function URL**

Lambda Function URLs have no per-request charge beyond the Lambda invocation itself. The previous API Gateway ($1.00/million requests) has been removed from the architecture.

**Cost: $0** — absorbed into the Lambda invocation cost already captured in section 1.3.

---

## **1.5 Amazon CloudFront**

| Metric | Rate |
|---|---|
| HTTPS requests | $0.0085 / 10K requests |