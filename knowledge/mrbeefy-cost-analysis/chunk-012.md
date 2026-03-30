[Source: Mrbeefy Cost Analysis | Section: 4.3 Cost Impact]

## **4.3 Cost Impact**

| Component | Before | After | Delta |
|---|---|---|---|
| Bedrock tokens | Same | Same | **$0** |
| Lambda duration | ~10s | ~10s (same wall time) | **~$0** |
| API Gateway | $1.00/million requests | **Removed** | **-$1.00/M** |
| Lambda Function URL | n/a | $0 additional | **$0** |
| CloudFront | Same bytes transferred | Same bytes, incremental delivery | **$0** |

Streaming saves the API Gateway per-request charge ($1.00/million) while adding zero new cost. At personal/portfolio scale this saving is negligible, but eliminating API Gateway simplifies the architecture and removes one operational surface.

---