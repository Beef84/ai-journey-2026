[Source: Mrbeefy Cost Analysis]

# **5. Cost Decisions**

These are architectural decisions where cost was an explicit factor in the choice made.

---

## **5.1 Lambda Function URL Over API Gateway**

API Gateway HTTP API costs $1.00/million requests. Lambda Function URLs cost nothing beyond the Lambda invocation. At personal/portfolio scale the difference is ~$0.001/month — negligible. The decision to switch was driven primarily by the technical requirement for streaming, not cost. But the cost saving is real and the architecture is simpler.

**Decision:** Use Lambda Function URL. Remove API Gateway entirely.

---