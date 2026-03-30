[Source: Mrbeefy Cost Analysis | Section: 1.3 AWS Lambda]

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