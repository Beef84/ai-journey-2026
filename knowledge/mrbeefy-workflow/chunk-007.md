[Source: Mrbeefy Workflow | Section: 3.6 Lambda Streams SSE Chunks]

### **3.6 Lambda Streams SSE Chunks**
1. Each Bedrock chunk is written to the response stream immediately:

```
data: {"token": "Hello"}\n\n
data: {"token": ", world"}\n\n
data: [DONE]\n\n
```

2. The stream stays open until Bedrock signals completion.
3. Lambda sends `data: [DONE]\n\n` as the terminal sentinel.