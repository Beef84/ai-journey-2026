[Source: Mrbeefy Design Decisions | Section: 13.1 Lambda Function URL Protection: CloudFront Secret Header]

## **13.1 Lambda Function URL Protection: CloudFront Secret Header**

The raw Lambda Function URL (`https://{id}.lambda-url.us-east-1.on.aws`) is publicly reachable by default. Anyone who discovers the URL can POST to it and invoke Bedrock directly, bypassing CloudFront entirely.

**Approach chosen:** CloudFront injects a shared secret as the `x-cloudfront-secret` custom header on every request forwarded to the Function URL origin. Lambda checks for this header before doing anything else and returns 403 if it is absent or wrong.

**Alternatives considered:**

| Option | Why rejected |
|---|---|
| Lambda Function URL `authorization_type = "AWS_IAM"` | Requires SigV4-signed requests — cannot be called directly from the browser |
| Lambda authorizer (separate function) | Adds cold start and billing surface for a simple secret check |
| WAF on Function URL | Not supported — WAF cannot be attached to Lambda Function URLs |
| IP allowlist | CloudFront edge IPs change constantly and are not suitable for static allowlists |

The secret header is simple, free, and effective for a single-API use case.