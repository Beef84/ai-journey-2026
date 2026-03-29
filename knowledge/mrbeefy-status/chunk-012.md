[Source: Mrbeefy Status | Section: What Changed > Dev Access via Signed Cookies]

### **Dev Access via Signed Cookies**
The dev CloudFront distribution requires a valid CloudFront signed cookie for every request. This means:

- Only the developer (who holds the RSA private key) can generate valid cookies
- The public key is uploaded to CloudFront via Terraform — not a secret
- The private key lives locally and is never committed
- Unauthenticated requests receive a 403

See the Workflow wiki for the full setup guide.

---