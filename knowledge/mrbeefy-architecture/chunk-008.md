[Source: Mrbeefy Architecture | Section: 2.2 CloudFront Distribution > Security]

### **Security**
- ACM certificate for `mrbeefy.academy` (prod) / `dev.mrbeefy.academy` (dev)
- SNI‑only
- Security headers policy applied to frontend
- **Dev only:** Signed cookies required — CloudFront returns 403 to any request without a valid signed cookie