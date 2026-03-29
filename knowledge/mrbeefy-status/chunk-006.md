- Requires the developer to set up signed cookies to access it

### **Dev Access via Signed Cookies**
The dev CloudFront distribution requires a valid CloudFront signed cookie for every request. This means:

- Only the developer (who holds the RSA private key) can generate valid cookies
- The public key is uploaded to CloudFront via Terraform — not a secret
- The private key lives locally and is never committed
- Unauthenticated requests receive a 403

See the Workflow wiki for the full setup guide.

---

## **What Was Not Changed**
- Prod (`mrbeefy.academy`) remains publicly accessible — unchanged behavior for end users
- No existing resource names, state, or configurations were modified for the `default` workspace
- The `gateway_secret` variable is the only new input required for a prod re-apply

---

# **📚 Knowledge Base Ingestion Pipeline (Dedicated Workflow)**

## **Overview**