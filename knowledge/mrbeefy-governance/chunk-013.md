[Source: Mrbeefy Governance | Section: 4.2 Network Governance]

## **4.2 Network Governance**
- All traffic is HTTPS-only
- CloudFront terminates TLS
- Lambda Function URL enforces HTTPS
- No public S3 access
- No public KB access
- Lambda Function URL is protected by a shared secret header — direct calls without the header return 403
- Dev CloudFront distribution is protected by CloudFront signed cookies — unauthenticated requests return 403

---