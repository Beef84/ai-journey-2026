[Source: Mrbeefy Design Decisions]

## **4.3 Behavior Design**
- Default behavior → S3
- Ordered behavior → `/chat` → Lambda Function URL

This ensures:

- The SPA loads instantly  
- API calls bypass caching  
- Only the intended path hits the backend  

---

# **5. Lambda Design Decisions**