[Source: Mrbeefy Design Decisions | Section: 13.3.1 CloudFront Public Key Stability: `ignore_changes`]

## **13.3.1 CloudFront Public Key Stability: `ignore_changes`**

Terraform was recreating the CloudFront public key on every frontend deploy, invalidating signed cookies. The root cause was that the PEM value passed via `-var="cloudfront_public_key_pem=..."` in the GitHub Actions shell contained whitespace differences (trailing newlines, line ending variations) from the value stored in Terraform state, causing Terraform to treat it as a change.

**Approach chosen:** `ignore_changes = [encoded_key]` on the `aws_cloudfront_public_key` resource, combined with `trimspace()` on the `encoded_key` attribute.

- `trimspace()` normalizes PEM whitespace before Terraform compares it to state — eliminates false positives from formatting differences
- `ignore_changes` ensures Terraform never updates the key material after initial creation — routine frontend deploys leave the CloudFront key group untouched and cookies remain valid for their full lifespan
- Deliberate key rotation (after a private key loss) requires `terraform taint aws_cloudfront_public_key.signed_cookies[0]` to force a one-time replacement