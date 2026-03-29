**Approach chosen:** CloudFront injects a shared secret as the `x-cloudfront-secret` custom header on every request forwarded to the Function URL origin. Lambda checks for this header before doing anything else and returns 403 if it is absent or wrong.

**Alternatives considered:**

| Option | Why rejected |
|---|---|
| Lambda Function URL `authorization_type = "AWS_IAM"` | Requires SigV4-signed requests — cannot be called directly from the browser |
| Lambda authorizer (separate function) | Adds cold start and billing surface for a simple secret check |
| WAF on Function URL | Not supported — WAF cannot be attached to Lambda Function URLs |
| IP allowlist | CloudFront edge IPs change constantly and are not suitable for static allowlists |

The secret header is simple, free, and effective for a single-API use case.

## **13.2 Secret Management: terraform.tfvars (Gitignored)**

The `gateway_secret` value is set via `terraform.tfvars` in each IaC directory. These files are gitignored and never committed. The value is stored in Terraform state (already encrypted at rest in S3 with DynamoDB locking) and injected into the Lambda environment by Terraform.
