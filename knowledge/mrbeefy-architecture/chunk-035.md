[Source: Mrbeefy Architecture | Section: 10.3 Function URL Protection (Both Environments)]

## **10.3 Function URL Protection (Both Environments)**
The raw Lambda Function URL (`https://{id}.lambda-url.us-east-1.on.aws`) is protected in both environments:

- CloudFront injects `x-cloudfront-secret` on every request forwarded to the API origin
- Lambda validates the header and returns 403 if it is absent or does not match `GATEWAY_SECRET`
- The secret is set via `terraform.tfvars` (gitignored) and never committed to the repository

---