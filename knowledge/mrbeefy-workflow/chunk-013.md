Click the **+** button and add each cookie exactly as shown:

| Name | Value | Domain | Path | Secure |
|---|---|---|---|---|
| `CloudFront-Policy` | (from step 9.8) | `dev.mrbeefy.academy` | `/` | ✓ |
| `CloudFront-Signature` | (from step 9.8) | `dev.mrbeefy.academy` | `/` | ✓ |
| `CloudFront-Key-Pair-Id` | (from step 9.8) | `dev.mrbeefy.academy` | `/` | ✓ |

Hard-refresh the page (`Ctrl+Shift+R`). The site loads normally.

> **When cookies expire:** Repeat steps 9.8 and 9.9 only. The infrastructure and key pair do not need to be recreated.

> **Testing from a new browser or device:** Repeat steps 9.8 and 9.9 on that browser. The private key must be accessible wherever you run the signing command.

---

# **10. Monitoring Workflow**

### **10.1 CloudWatch**
- Lambda logs
- CloudFront access logs (optional)

### **10.2 CloudFront**
- Cache hit/miss metrics
- Optional standard logs

### **10.3 Bedrock**
- KB ingestion job status
- Agent invocation metrics

---

# **11. Summary**

The Mr. Beefy workflow is a fully serverless, tightly integrated system that:

- Delivers a global frontend
- Routes chat requests through CloudFront to Lambda Function URL
- Validates every request via secret header before touching Bedrock