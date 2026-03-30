[Source: Mrbeefy Design Decisions]

# **4. CloudFront Design Decisions**

## **4.1 CloudFront as the Routing Layer**
CloudFront was chosen to:

- Serve static assets globally
- Terminate TLS
- Route `/chat` to the Lambda Function URL origin
- Apply security headers
- Enforce caching policies
- Protect S3 via OAC