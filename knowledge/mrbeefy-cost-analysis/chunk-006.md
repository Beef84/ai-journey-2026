Streaming saves the API Gateway per-request charge ($1.00/million) while adding zero new cost. At personal/portfolio scale this saving is negligible, but eliminating API Gateway simplifies the architecture and removes one operational surface.

---

# **5. Cost Decisions**

These are architectural decisions where cost was an explicit factor in the choice made.

---

## **5.1 Lambda Function URL Over API Gateway**

API Gateway HTTP API costs $1.00/million requests. Lambda Function URLs cost nothing beyond the Lambda invocation. At personal/portfolio scale the difference is ~$0.001/month — negligible. The decision to switch was driven primarily by the technical requirement for streaming, not cost. But the cost saving is real and the architecture is simpler.

**Decision:** Use Lambda Function URL. Remove API Gateway entirely.

---

## **5.2 Serverless-Only Architecture**

No EC2 instances, no containers, no NAT gateways, no VPC. All services (Lambda, Bedrock, S3, CloudFront) are fully managed serverless offerings with zero idle cost except Route53 ($0.50/month fixed).

**Decision:** Serverless-only. Cost is proportional to usage. Idle cost is $0.50/month.

---

## **5.3 S3 Vector Store Over OpenSearch**
