This avoids SSM costs and complexity for a personal project while keeping the secret out of source control.

## **13.3 Dev Access Control: CloudFront Signed Cookies**

The dev environment (`dev.mrbeefy.academy`) should be accessible only to the developer, not the public internet.

**Approach chosen:** CloudFront signed cookies with an RSA key pair.

**Why signed cookies over alternatives:**

| Option | Why rejected |
|---|---|
| WAF IP allowlist | IP changes break access (home, office, mobile); requires manual updates |
| HTTP Basic Auth via Lambda@Edge | Adds a Lambda@Edge function and associated cost/complexity |
| Signed URLs | Per-object scope — doesn't work well for a SPA with many assets |
| Cognito + Lambda@Edge | Significant complexity for sole-developer access |

Signed cookies work for the whole distribution with a single browser cookie. The private key never leaves the developer's machine. The public key is uploaded to CloudFront via Terraform — it is not a secret and is safe to store in state.

## **13.4 Multi-Environment Strategy: Terraform Workspaces**

Terraform workspaces were chosen over separate directories or separate accounts because:
