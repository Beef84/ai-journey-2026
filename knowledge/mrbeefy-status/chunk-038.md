[Source: Mrbeefy Status | Section: What Changed > Lambda Handler]

### **Lambda Handler**
- Replaced the standard handler with `awslambda.streamifyResponse`
- Bedrock chunks are piped directly to the response stream as they arrive
- Output formatted as Server-Sent Events: `data: {"token": "..."}\n\n`
- Final sentinel: `data: [DONE]\n\n`
- Content-Type set to `text/event-stream`