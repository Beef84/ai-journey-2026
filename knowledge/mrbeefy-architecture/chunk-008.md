- dev: `mrbeefy-dev-*`

State is automatically isolated: prod state lives at `global/terraform.tfstate`, dev at `env:/dev/global/terraform.tfstate`.

## **10.2 Dev Access Control**
The dev CloudFront distribution enforces **signed cookies**:

1. Developer generates an RSA key pair locally (private key never leaves the machine)
2. Public key is uploaded to CloudFront via Terraform as a trusted key group
3. Developer generates a signed cookie offline using the private key (valid window of their choice)
4. Cookie is set in the browser once — all requests to `dev.mrbeefy.academy` are then authorized
5. Anyone without a valid signed cookie receives a 403

See the Workflow wiki for the step-by-step signed cookie setup.

## **10.3 Function URL Protection (Both Environments)**
The raw Lambda Function URL (`https://{id}.lambda-url.us-east-1.on.aws`) is protected in both environments:

- CloudFront injects `x-cloudfront-secret` on every request forwarded to the API origin
- Lambda validates the header and returns 403 if it is absent or does not match `GATEWAY_SECRET`
- The secret is set via `terraform.tfvars` (gitignored) and never committed to the repository

---

# **11. Final Architecture Summary**
