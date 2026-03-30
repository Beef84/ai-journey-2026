[Source: Mrbeefy Status | Section: What Changed > Retrieval Count: 15]

### **Retrieval Count: 15**
Lambda now passes `numberOfResults: 15` to Bedrock via `sessionState.knowledgeBaseConfigurations` in `InvokeAgentCommand`. Previously the default was lower, causing the agent to miss relevant context on multi-part questions.