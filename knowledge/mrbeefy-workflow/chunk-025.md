[Source: Mrbeefy Workflow | Section: 9.6 Generate RSA Key Pair for Dev Signed Cookies (Dev only)]

## **9.6 Generate RSA Key Pair for Dev Signed Cookies** *(Dev only)*

> **What this is:** The dev CloudFront distribution rejects all requests that don't carry a valid signed cookie. You sign cookies with your private key. CloudFront verifies them using the public key uploaded via Terraform. The private key never leaves your machine — not in the repo, not in AWS.

Run once from any directory. Store the private key in a secure local folder.

```bash