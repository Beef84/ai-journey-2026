[Source: Mrbeefy Status | Section: CloudFront Signed Cookie Stability]

## **CloudFront Signed Cookie Stability**

Signed cookies were being invalidated on every frontend deploy because Terraform was recreating the CloudFront public key resource. The root cause: the PEM value passed via `-var="..."` in the GitHub Actions shell had whitespace differences (trailing newlines, `\r\n` vs `\n`) from what was stored in Terraform state, causing Terraform to see a change and replace the resource.

Two fixes applied:

- `trimspace()` on `encoded_key` in Terraform to normalize PEM whitespace before comparison
- `ignore_changes = [encoded_key]` lifecycle rule — Terraform creates the key on first apply and never touches it again. Deliberate key rotation requires a manual `terraform taint`.

---