[Source: Mrbeefy Governance]

# **4. Security Governance**

## **4.1 IAM Governance**
IAM roles follow strict least‑privilege rules:

- Lambda role: logging + `InvokeAgent`  
- Agent execution role: model invocation + KB retrieval + vector store access  
- KB role: S3 read + vector store operations + Titan embedding model  
- CloudFront OAC: `s3:GetObject` with `AWS:SourceArn` restriction  

No role may be expanded without explicit justification.

---