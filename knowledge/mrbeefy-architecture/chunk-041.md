[Source: Mrbeefy Architecture | Section: 5. Lambda streams SSE chunks]

### **5. Lambda streams SSE chunks**
- Each Bedrock chunk is written to the response stream immediately as `data: {"token": "..."}\n\n`
- Browser receives and renders tokens progressively — no waiting for full response