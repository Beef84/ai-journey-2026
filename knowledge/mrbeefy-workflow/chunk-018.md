[Source: Mrbeefy Workflow]

### **8.2 TLS**
- ACM certificate for domain
- CloudFront enforces HTTPS
- Lambda Function URL enforces HTTPS

### **8.3 IAM Separation**
Each component has a dedicated role with least‑privilege permissions.

---

# **9. First-Time Manual Setup**

This section is the complete checklist of every manual step required to stand up Mr. Beefy from scratch. These steps are performed once per environment and are **not automated by CI/CD**. Do them in order — each step depends on the one before it.

> **Prod vs Dev:** Steps 9.1–9.5 are required for **both** environments. Steps 9.6–9.9 are **dev only** — the dev CloudFront distribution requires signed cookies; prod does not.

---