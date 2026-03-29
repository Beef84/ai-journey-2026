[Source: Jordan Engineering Philosophy]

# **4. Design for Observability First**

A system without visibility is a system waiting to fail.

I design with observability as a first‑class requirement:

- Lambda logs  
- API Gateway access logs  
- API Gateway execution logs  
- CloudFront metrics  
- KB ingestion status  
- Bedrock invocation metrics  

If something goes wrong, I want the system to tell me *exactly* where and why.

---